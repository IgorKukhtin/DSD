-- Function: gpSelect_MovementItem_Send()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_SendMember (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_SendMember(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , PartionGoodsDate TDateTime
             , Amount TFloat, Count TFloat, HeadCount TFloat
             , PartionGoodsId Integer, PartionGoods TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsKindId_Complete Integer, GoodsKindName_Complete  TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , UnitName TVarChar
             , StorageName TVarChar
             , Price TFloat
             , AmountRemains TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется
     vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From());
     IF vbUnitId IN (SELECT lfSelect_Object_Unit_byGroup.UnitId FROM lfSelect_Object_Unit_byGroup (8433) AS lfSelect_Object_Unit_byGroup) -- Производство
     THEN vbUnitId:= NULL;
     END IF;


     -- Результат
     IF inShowAll THEN

     -- Результат такой
     RETURN QUERY
       WITH tmpRemains AS (SELECT 0 AS GoodsId
                                , 0 :: TFloat AS Amount
                                , 0 AS GoodsKindId
                          )
      , tmpMIContainer AS (SELECT 0 AS MovementItemId
                                , NULL ::Integer AS PartionGoodsId
                                , '' :: TVarChar AS PartionGoods
                                , NULL :: TDateTime AS  PartionDate
                                , 0 AS UnitId
                                , 0 AS StorageId
                                , 0 :: TFloat AS Price
                          )
       -- Результат
       SELECT
             0                          AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TDateTime)   AS PartionGoodsDate
           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS Count
           , CAST (NULL AS TFloat)      AS HeadCount
           , CAST (NULL AS Integer)     AS PartionGoodsId
           , CAST (NULL AS TVarChar)    AS PartionGoods
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , CAST (NULL AS Integer)     AS GoodsKindId_Complete
           , CAST (NULL AS TVarchar)    AS GoodsKindName_Complete
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , CAST (NULL AS TVarChar)    AS UnitName
           , CAST (NULL AS TVarChar)    AS StorageName
           , CAST (NULL AS TFloat)      AS Price

           , tmpRemains.Amount :: TFloat AS AmountRemains

           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция
                              THEN zc_Enum_GoodsKind_Main()
                         -- WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                         --      THEN zc_Enum_GoodsKind_Main()
                         ELSE 0
                    END AS GoodsKindId

                  -- , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id       = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
             WHERE -- Оборотная тара
                   Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500())
            ) AS tmpGoods

            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId
                                AND tmpRemains.GoodsKindId = tmpGoods.GoodsKindId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                      AS Id
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , COALESCE (tmpMIContainer.PartionDate, MIDate_PartionGoods.ValueData)   :: TDateTime AS PartionGoodsDate
           , MovementItem.Amount                   AS Amount
           , MIFloat_CountPack.ValueData           AS Count
           , MIFloat_HeadCount.ValueData           AS HeadCount
           , COALESCE (tmpMIContainer.PartionGoodsId, Object_PartionGoods.Id, 0) AS PartionGoodsId
           , COALESCE (tmpMIContainer.PartionGoods, MIString_PartionGoods.ValueData) :: TVarChar AS PartionGoods
           , Object_GoodsKind.Id                   AS GoodsKindId
           , Object_GoodsKind.ValueData            AS GoodsKindName
           , Object_GoodsKindComplete.Id           AS GoodsKindId_Complete
           , Object_GoodsKindComplete.ValueData    AS GoodsKindName_Complete
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Unit_partion.ValueData         AS UnitName
           , Object_Storage.ValueData              AS StorageName
           , tmpMIContainer.Price                  AS Price

           , tmpRemains.Amount :: TFloat           AS AmountRemains

           , MovementItem.isErased                 AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                        ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id
            LEFT JOIN Object AS Object_Unit_partion ON Object_Unit_partion.Id = tmpMIContainer.UnitId
            LEFT JOIN Object AS Object_Storage      ON Object_Storage.Id      = tmpMIContainer.StorageId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.ObjectId
                                AND tmpRemains.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            ;


     ELSE

     -- Результат другой
     RETURN QUERY
       WITH tmpMI_Goods AS (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , MovementItem.Amount                           AS Amount
                                 , MIDate_PartionGoods.ValueData                 AS PartionGoodsDate
                                 , MIFloat_CountPack.ValueData                   AS Count
                                 , MIFloat_HeadCount.ValueData                   AS HeadCount
                                 , MIString_PartionGoods.ValueData               AS PartionGoods_mi
                                 , CASE WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0 AND Object_PartionGoods.ObjectCode > 0
                                             THEN zfCalc_PartionGoodsName_Asset (inMovementId      := Object_PartionGoods.ObjectCode          --
                                                                               , inInvNumber       := Object_PartionGoods.ValueData           -- Инвентарный номер
                                                                               , inOperDate        := ObjectDate_PartionGoods_Value.ValueData -- Дата ввода в эксплуатацию
                                                                               , inUnitName        := Object_Unit.ValueData                   -- Подразделение использования
                                                                               , inStorageName     := Object_Storage.ValueData                -- Место хранения
                                                                               , inGoodsName       := ''                                      -- Основные средства или Товар
                                                                                )
                                        WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0
                                             THEN zfCalc_PartionGoodsName_InvNumber (inInvNumber       := Object_PartionGoods.ValueData             -- Инвентарный номер
                                                                                   , inOperDate        := ObjectDate_PartionGoods_Value.ValueData   -- Дата перемещения
                                                                                   , inPrice           := ObjectFloat_PartionGoods_Price.ValueData  -- Цена
                                                                                   , inUnitName_Partion:= Object_Unit.ValueData                     -- Подразделение(для цены)
                                                                                   , inStorageName     := Object_Storage.ValueData                  -- Место хранения
                                                                                   , inGoodsName       := ''                                        -- Товар
                                                                                    )
                                        WHEN Object_PartionGoods.ValueData <> '' THEN Object_PartionGoods.ValueData

                                        ELSE MIString_PartionGoods.ValueData
                                   END AS PartionGoods
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , COALESCE (MILO_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_Complete
                                 , COALESCE (MILinkObject_PartionGoods.ObjectId,0) AS PartionGoodsId
                                 , MovementItem.isErased
                            FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                 INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = tmpIsErased.isErased

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                                  ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                 AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                                  ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()

                                 LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                             ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountPack.DescId         = zc_MIFloat_CountPack()
                                 LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                             ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                            AND MIFloat_HeadCount.DescId         = zc_MIFloat_HeadCount()
                                 LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                            ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                           AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                                 LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                              ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                             AND MIString_PartionGoods.DescId         = zc_MIString_PartionGoods()
                                 -- партия
                                 LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                      ON ObjectLink_Goods.ObjectId = MILinkObject_PartionGoods.ObjectId
                                                     AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()
                                 -- подразделение
                                 LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                      ON ObjectLink_Unit.ObjectId = MILinkObject_PartionGoods.ObjectId
                                                     AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                                 LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId
                                 -- место хранения
                                 LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                      ON ObjectLink_Storage.ObjectId = MILinkObject_PartionGoods.ObjectId
                                                     AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
                                 LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId
                                 -- дата
                                 LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                      ON ObjectDate_PartionGoods_Value.ObjectId = MILinkObject_PartionGoods.ObjectId
                                                     AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                                 -- цена
                                 LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                                                       ON ObjectFloat_PartionGoods_Price.ObjectId = MILinkObject_PartionGoods.ObjectId
                                                      AND ObjectFloat_PartionGoods_Price.DescId = zc_ObjectFloat_PartionGoods_Price()
                                   )
      , tmpRemains AS (SELECT 0 AS MovementItemId
                            , 0 :: TFloat AS Amount
                      )
      , tmpMIContainer AS (SELECT 0 AS MovementItemId
                                , NULL ::Integer AS PartionGoodsId
                                , '' :: TVarChar AS PartionGoods
                                , NULL :: TDateTime AS  PartionDate
                                , 0 AS UnitId
                                , 0 AS StorageId
                                , 0 :: TFloat AS Price
                           WHERE 1=0
                          )
       -- Результат
       SELECT
             tmpMI_Goods.MovementItemId         AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , COALESCE (tmpMIContainer.PartionDate, tmpMI_Goods.PartionGoodsDate) :: TDateTime AS PartionGoodsDate
           , tmpMI_Goods.Amount                 AS Amount
           , tmpMI_Goods.Count                  AS Count
           , tmpMI_Goods.HeadCount              AS HeadCount
           , COALESCE (tmpMIContainer.PartionGoodsId, Object_PartionGoods.Id ) AS PartionGoodsId
           , CASE WHEN COALESCE (tmpMI_Goods.PartionGoodsId, 0) = 0 AND tmpMI_Goods.PartionGoods_mi <> '' THEN tmpMI_Goods.PartionGoods_mi
                  ELSE COALESCE (tmpMIContainer.PartionGoods, Object_PartionGoods.ValueData)
             END :: TVarChar  AS PartionGoods
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_GoodsKindComplete.Id        AS GoodsKindId_Complete
           , Object_GoodsKindComplete.ValueData AS GoodsKindName_Complete
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Unit_partion.ValueData      AS UnitName
           , Object_Storage.ValueData           AS StorageName
           , tmpMIContainer.Price               AS Price

           , tmpRemains.Amount :: TFloat        AS AmountRemains

           , tmpMI_Goods.isErased               AS isErased

       FROM tmpMI_Goods
            LEFT JOIN tmpRemains ON tmpRemains.MovementItemId = tmpMI_Goods.MovementItemId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Goods.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Goods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpMI_Goods.GoodsKindId_Complete
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMI_Goods.PartionGoodsId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = tmpMI_Goods.MovementItemId
            LEFT JOIN Object AS Object_Unit_partion ON Object_Unit_partion.Id = tmpMIContainer.UnitId
            LEFT JOIN Object AS Object_Storage      ON Object_Storage.Id      = tmpMIContainer.StorageId


            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.11.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_SendMember (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_SendMember (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
