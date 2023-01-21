 -- Function: gpSelect_MovementItem_Send_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , ReturnKindId Integer, ReturnKindName TVarChar
             
             , GoodsId_master Integer, GoodsCode_master Integer, GoodsName_master TVarChar
             , GoodsKindId_master Integer, GoodsKindName_master  TVarChar
             , Amount_master TFloat
             , PartionGoodsDate  TDateTime
             , PartionGoods      TVarChar
             
             , isErased Boolean
             , Ord Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
     vbUserId:= lpGetUserBySession (inSession);
     

     -- Результат
     RETURN QUERY
     WITH
     tmpMI_Master AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , MovementItem.Amount                           AS Amount
                           , MIDate_PartionGoods.ValueData                 AS PartionGoodsDate
                           , MIString_PartionGoods.ValueData               AS PartionGoods
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                     )

   , tmpMI_Child AS (SELECT MovementItem.Id
                          , MovementItem.ParentId          AS ParentId
                          , MovementItem.ObjectId          AS GoodsId
                          , MovementItem.Amount            AS Amount
                          , COALESCE (MILinkObject_GoodsKind.ObjectId,0) AS GoodsKindId
                          , MILinkObject_ReturnKind.ObjectId             AS ReturnKindId
                          , SUM (COALESCE (MovementItem.Amount,0)) OVER (PARTITION BY MovementItem.ParentId) AS TotalAmount 
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId     = zc_MI_Child()
                                           AND MovementItem.isErased   = tmpIsErased.isErased

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReturnKind
                                                           ON MILinkObject_ReturnKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ReturnKind.DescId = zc_MILinkObject_ReturnKind()
                          LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = MILinkObject_ReturnKind.ObjectId
                    )

   , tmpDiff AS (SELECT tmpMI_Master.Id
                      , tmpMI_Master.GoodsId
                      , tmpMI_Master.GoodsKindId
                      , COALESCE (tmpMI_Master.Amount,0) - COALESCE (tmpChild.TotalAmount,0) AS Amount
                 FROM tmpMI_Master
                      LEFT JOIN (SELECT DISTINCT tmpMI_Child.ParentId, tmpMI_Child.TotalAmount FROM tmpMI_Child) AS tmpChild ON tmpChild.ParentId = tmpMI_Master.Id
                 WHERE COALESCE (tmpMI_Master.Amount,0) - COALESCE (tmpChild.TotalAmount,0) > 0
                )

   , tmpAll AS (SELECT COALESCE (tmpMI_Child.Id,0) AS Id
                     , COALESCE (tmpMI_Child.ParentId, tmpMI_Master.Id) AS ParentId
                     , tmpMI_Master.GoodsId                       AS GoodsId_master
                     , tmpMI_Master.GoodsKindId                   AS GoodsKindId_master
                     , COALESCE (tmpMI_Master.Amount,0) :: TFloat AS Amount_master
                     , tmpMI_Master.PartionGoodsDate              AS PartionGoodsDate_master
                     , tmpMI_Master.PartionGoods                  AS PartionGoods_master
                     
                     , tmpMI_Child.GoodsId        ::Integer       AS GoodsId
                     , tmpMI_Child.GoodsKindId    ::Integer      AS GoodsKindId
                     , tmpMI_Child.ReturnKindId   ::Integer       AS ReturnKindId
                     , COALESCE (tmpMI_Child.Amount,0) :: TFloat  AS Amount

                       -- № п.п.
                     , ROW_NUMBER () OVER (PARTITION BY tmpMI_Master.GoodsId, tmpMI_Master.GoodsKindId ORDER BY tmpMI_Child.Id ASC) AS Ord
                FROM tmpMI_Child
                     INNER JOIN tmpMI_Master ON tmpMI_Master.Id = tmpMI_Child.ParentId
               )


       -- Результат
       SELECT
             COALESCE (tmpAll.Id,0) AS Id
           , tmpAll.ParentId
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , tmpAll.Amount :: TFloat AS Amount
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
 
           , Object_ReturnKind.Id        ::Integer  AS ReturnKindId   
           , Object_ReturnKind.ValueData ::TVarChar AS ReturnKindName   

           , Object_Goods_master.Id            AS GoodsId_master
           , Object_Goods_master.ObjectCode    AS GoodsCode_master
           , Object_Goods_master.ValueData     AS GoodsName_master
           , Object_GoodsKind_master.Id        AS GoodsKindId_master
           , Object_GoodsKind_master.ValueData AS GoodsKindName_master
           , tmpAll.Amount_master  ::TFloat
           , tmpAll.PartionGoodsDate_master
           , tmpAll.PartionGoods_master

           , FALSE                      AS isErased
             -- № п.п.
           , ROW_NUMBER () OVER (PARTITION BY tmpAll.GoodsId, tmpAll.GoodsKindId ORDER BY tmpAll.Ord ASC) :: Integer AS ord  
       FROM tmpAll
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpAll.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpAll.GoodsKindId
            LEFT JOIN Object AS Object_ReturnKind ON Object_ReturnKind.Id = tmpAll.ReturnKindId

            LEFT JOIN Object AS Object_Goods_master ON Object_Goods_master.Id = tmpAll.GoodsId_master
            LEFT JOIN Object AS Object_GoodsKind_master ON Object_GoodsKind_master.Id = tmpAll.GoodsKindId_master

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpAll.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.23         *
*/

-- тест
--
-- SELECT * FROM gpSelect_MovementItem_Send_Child (inMovementId:= 20081622, inIsErased:= FALSE, inSession:= '9818')
