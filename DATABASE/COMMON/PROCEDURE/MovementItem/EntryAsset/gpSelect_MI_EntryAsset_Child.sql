-- Function: gpSelect_MI_EntryAsset_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_EntryAsset_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_EntryAsset_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Remains TFloat, Comment TVarChar
             , PartionGoodsId Integer, PartionGoodsName TVarChar
             , LocationName TVarChar
             , StorageName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , MovementPartionGoods_InvNumber TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_EntryAsset());
     vbUserId:= lpGetUserBySession (inSession);

      RETURN QUERY
    WITH 
    tmpMI AS (SELECT MovementItem.Id AS Id
                   , MovementItem.ObjectId AS AssetId
              FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
             )
, tmpMI_Child AS (SELECT MovementItem.Id       AS Id
                       , MovementItem.ParentId AS ParentId
                       , MovementItem.ObjectId AS PartionGoodsId
                       , MovementItem.Amount   AS Amount
                       , MovementItem.isErased
                  FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Child()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                  )
 , tmpContainer AS (-- здесь и Товар и ОС и Услуги
                    SELECT tmpMI.Id                  AS ParentId
                         , CLO_PartionGoods.ObjectId AS PartionGoodsId
                         , Container.ObjectId        AS GoodsId
                         , Container.Amount
                         , COALESCE (CLO_Member.ObjectId, CLO_Unit.ObjectId) AS LocationId
                    FROM tmpMI
                         INNER JOIN ContainerLinkObject AS CLO_AssetTo
                                                        ON CLO_AssetTo.DescId   = zc_ContainerLinkObject_AssetTo()
                                                       AND CLO_AssetTo.ObjectId = tmpMI.AssetId
                         INNER JOIN Container ON Container.Id = CLO_AssetTo.ContainerId 
                                             AND Container.DescId = zc_Container_Count()
                                             AND Container.Amount <>0
                         LEFT JOIN ContainerLinkObject AS CLO_PartionGoods 
                                                       ON CLO_PartionGoods.ContainerId = Container.Id
                                                      AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                   
                         LEFT JOIN ContainerLinkObject AS CLO_Member
                                                       ON CLO_Member.ContainerId = Container.Id
                                                      AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
                         LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                       ON CLO_Unit.ContainerId = Container.Id
                                                      AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                    )
   , tmpResult AS (SELECT tmpMI_Child.Id                         AS Id
                        , COALESCE (tmpMI_Child.ParentId, tmpContainer.ParentId)                  AS ParentId
                        , COALESCE (tmpMI_Child.PartionGoodsId, tmpContainer.PartionGoodsId)      AS PartionGoodsId
                        , COALESCE (tmpContainer.GoodsId, ObjectLink_PartionGoods_Goods.ObjectId) AS GoodsId
                        , tmpMI_Child.Amount                     AS Amount
                        , tmpContainer.Amount                    AS Remains
                        , tmpContainer.LocationId                AS LocationId
                        , COALESCE (tmpMI_Child.isErased, FALSE) AS isErased
                   FROM tmpMI_Child
                        LEFT JOIN ObjectLink AS ObjectLink_PartionGoods_Goods
                                             ON ObjectLink_PartionGoods_Goods.ObjectId = tmpMI_Child.PartionGoodsId
                                            AND ObjectLink_PartionGoods_Goods.DescId   = zc_ObjectLink_PartionGoods_Goods() 
                        FULL JOIN tmpContainer ON tmpContainer.PartionGoodsId = tmpMI_Child.PartionGoodsId
                                              AND tmpContainer.GoodsId        = ObjectLink_PartionGoods_Goods.ObjectId
                   )
   -- Результат
   SELECT tmpResult.Id
        , tmpResult.ParentId
        , Object_Goods.Id            AS GoodsId
        , Object_Goods.ObjectCode    AS GoodsCode
        , Object_Goods.ValueData     AS GoodsName
        , tmpResult.Amount
        , tmpResult.Remains
        , MIString_Comment.ValueData    AS Comment
        , tmpResult.PartionGoodsId
        , Object_PartionGoods.ValueData AS PartionGoodsName

        , Object_Location.ValueData     AS LocationName  
        , Object_Storage.ValueData      AS StorageName
        , Object_Unit.ObjectCode        AS UnitCode
        , Object_Unit.ValueData         AS UnitName

        , zfCalc_PartionMovementName (Movement_PartionGoods.DescId, MovementDesc_PartionGoods.ItemName, Movement_PartionGoods.InvNumber, Movement_PartionGoods.OperDate) AS MovementPartionGoods_InvNumber

        , tmpResult.isErased
   FROM tmpResult
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
        LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpResult.PartionGoodsId
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = tmpResult.LocationId

        LEFT JOIN MovementItemString AS MIString_Comment
                                     ON MIString_Comment.MovementItemId =  tmpResult.Id
                                    AND MIString_Comment.DescId = zc_MIString_Comment()
        
        LEFT JOIN ObjectLink AS ObjectLink_PartionGoods_Unit
                             ON ObjectLink_PartionGoods_Unit.ObjectId = tmpResult.PartionGoodsId
                            AND ObjectLink_PartionGoods_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_PartionGoods_Unit.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_PartionGoods_Storage
                             ON ObjectLink_PartionGoods_Storage.ObjectId = tmpResult.PartionGoodsId
                            AND ObjectLink_PartionGoods_Storage.DescId = zc_ObjectLink_PartionGoods_Storage() 
        LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_PartionGoods_Storage.ChildObjectId

        LEFT JOIN Movement AS Movement_PartionGoods ON Movement_PartionGoods.Id = Object_PartionGoods.ObjectCode
        LEFT JOIN MovementDesc AS MovementDesc_PartionGoods ON MovementDesc_PartionGoods.Id = Movement_PartionGoods.DescId
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 28.08.16         * 
*/

-- тест
-- SELECT * from gpSelect_MI_EntryAsset_Child (0,False, '3');
