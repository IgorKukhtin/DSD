-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , HeadCount TFloat, Count TFloat
             , Price TFloat, Summ TFloat
             , Price_pr TFloat, Summ_pr TFloat
             , PartionGoodsDate TDateTime, PartionGoods TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsKindId_Complete Integer, GoodsKindName_Complete  TVarChar
             , AssetId Integer, AssetName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , StorageId Integer, StorageName TVarChar
             , ContainerId Integer
             , isErased Boolean
             , PartionGoodsId Integer
             , IdBarCode TVarChar
             , OperDate TDateTime
           --  , Price_Partion     TFloat
             )
AS
$BODY$
   DECLARE vbPriceListId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());

     vbPriceListId := COALESCE ((SELECT MovementLinkObject_PriceList.ObjectId
                                 FROM MovementLinkObject AS MovementLinkObject_PriceList
                                 WHERE MovementLinkObject_PriceList.MovementId = inMovementId
                                   AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList())
                                 , zc_PriceList_Basis()
                                 );


     -- inShowAll:= TRUE;

     IF inShowAll = TRUE
     THEN

     RETURN QUERY
       WITH tmpPrice AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                              , lfObjectHistory_PriceListItem.GoodsKindId
                              , lfObjectHistory_PriceListItem.ValuePrice AS Price
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) + INTERVAL '1 DAY')
                              AS lfObjectHistory_PriceListItem
                         WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                        )  
           -- цены по прайсу
          , tmpPricePR AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , lfObjectHistory_PriceListItem.GoodsKindId
                                , lfObjectHistory_PriceListItem.ValuePrice AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                                AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )

            --колво движения из проводок
          , tmpContainer AS (SELECT MIContainer.MovementItemId
                                 , SUM (MIContainer.Amount) AS Amount
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.MovementId = inMovementId  
                               AND MIContainer.MovementDescId = zc_Movement_Inventory()
                               AND MIContainer.DescId = zc_MIContainer_Count()
                             GROUP BY  MIContainer.MovementItemId
                             )

       SELECT
             0 AS Id
           , tmpGoods.GoodsId
           , tmpGoods.GoodsCode
           , tmpGoods.GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TFloat)              AS Amount
           , CAST (NULL AS TFloat)              AS HeadCount
           , CAST (NULL AS TFloat)              AS Count
           , COALESCE (tmpPrice_Kind.Price, tmpPrice.Price) :: TFloat AS Price
           , CAST (NULL AS TFloat)              AS Summ
           , COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price) :: TFloat AS Price_pr
           , CAST (NULL AS TFloat)              AS Summ_pr 
           , CAST (NULL AS TDateTime)           AS PartionGoodsDate
           , CAST (NULL AS TVarChar)            AS PartionGoods
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , CAST (NULL AS Integer)             AS GoodsKindId_Complete
           , CAST (NULL AS TVarchar)            AS GoodsKindName_Complete
           , CAST (0 AS Integer)                AS AssetId
           , CAST (NULL AS TVarChar)            AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName
           , CAST (0 AS Integer)                AS UnitId
           , CAST (NULL AS TVarChar)            AS UnitName
           , CAST (0 AS Integer)                AS StorageId
           , CAST (NULL AS TVarChar)            AS StorageName

           , 0 :: Integer AS ContainerId

           , FALSE        AS isErased

           , 0 :: Integer                    AS PartionGoodsId
           , zfFormat_BarCode (zc_BarCodePref_Object(), tmpGoods.GoodsId) :: TVarChar AS IdBarCode
           , Null ::TDateTime  AS OperDate
         --  , CAST (NULL AS TFloat)           AS Price_Partion
           
       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)            AS GoodsKindId
                  , ObjectLink_Goods_InfoMoney.ChildObjectId                          AS InfoMoneyId
             FROM Object AS Object_Goods
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id 
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_InfoMoneyDestination
                                       ON ObjectLink_InfoMoney_InfoMoneyDestination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                      AND ObjectLink_InfoMoney_InfoMoneyDestination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND (ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
                                                          OR ObjectLink_InfoMoney_InfoMoneyDestination.ChildObjectId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                            )
             WHERE Object_Goods.DescId = zc_Object_Goods()
               AND Object_Goods.isErased = FALSE
            ) AS tmpGoods
            LEFT JOIN (SELECT MovementItem.ObjectId AS GoodsId
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
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpGoods.InfoMoneyId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- привязываем цены 2 раза по виду товара и без
            LEFT JOIN tmpPrice AS tmpPrice_Kind 
                               ON tmpPrice_Kind.GoodsId = tmpGoods.GoodsId
                              AND COALESCE (tmpPrice_Kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL


            -- привязываем цены по прайсу 2 раза по виду товара и без
            LEFT JOIN tmpPricePR AS tmpPricePR_Kind 
                                 ON tmpPricePR_Kind.GoodsId = tmpGoods.GoodsId
                                AND COALESCE (tmpPricePR_Kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN tmpPricePR ON tmpPricePR.GoodsId = tmpGoods.GoodsId
                                AND tmpPricePR.GoodsKindId IS NULL

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                AS Amount
           , MIFloat_HeadCount.ValueData        AS HeadCount
           , MIFloat_Count.ValueData            AS Count
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN ObjectFloat_Price_Partion.ValueData ELSE (CASE WHEN MIFloat_Price.ValueData <> 0 THEN MIFloat_Price.ValueData ELSE COALESCE (tmpPrice_Kind.Price, tmpPrice.Price) END) END:: TFloat AS Price
           , MIFloat_Summ.ValueData   :: TFloat AS Summ    

           , COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)                         ::TFloat AS Price_pr
           , (tmpContainer.Amount * COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)) ::TFloat AS Summ_pr

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN ObjectDate_Value.ValueData    ELSE MIDate_PartionGoods.ValueData   END AS PartionGoodsDate
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 AND Object_PartionGoods.ValueData <> '0' THEN Object_PartionGoods.ValueData ELSE MIString_PartionGoods.ValueData END AS PartionGoods
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
           , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete
           , Object_Asset.Id                    AS AssetId
           , Object_Asset.ValueData             AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Unit_Partion.Id ELSE Object_Unit.Id               END AS UnitId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Unit_Partion.ValueData ELSE Object_Unit.ValueData END AS UnitName

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Storage_Partion.Id ELSE Object_Storage.Id               END AS StorageId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Storage_Partion.ValueData ELSE Object_Storage.ValueData END AS StorageName

           , MIFloat_ContainerId.ValueData :: Integer AS ContainerId
           , MovementItem.isErased              AS isErased
           
           -- из партии
           , Object_PartionGoods.Id                AS PartionGoodsId
           , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.Id) :: TVarChar AS IdBarCode
           , Null ::TDateTime  AS OperDate
           
/*         , ObjectFloat_Price_Partion.ValueData   AS Price_Partion
           
           , Object_Storage_Partion.Id             AS StorageId_Partion
           , Object_Storage_Partion.ValueData      AS StorageName_Partion
          
           , Object_Unit_Partion.Id                AS UnitId_Partion
           , Object_Unit_Partion.ValueData         AS UnitName_Partion
*/
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                             ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- привязываем цены 2 раза по виду товара и без
            LEFT JOIN tmpPrice AS tmpPrice_Kind 
                               ON tmpPrice_Kind.GoodsId = MovementItem.ObjectId
                              AND COALESCE (tmpPrice_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)

            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
                              AND tmpPrice.GoodsKindId IS NULL

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
            -- свойства из партии
            LEFT JOIN ObjectDate AS ObjectDate_Value 
                                 ON ObjectDate_Value.ObjectId = MILinkObject_PartionGoods.ObjectId                      -- дата
                                AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()

            JOIN ObjectFloat AS ObjectFloat_Price_Partion 
                             ON ObjectFloat_Price_Partion.ObjectId = MILinkObject_PartionGoods.ObjectId                 -- цена
                            AND ObjectFloat_Price_Partion.DescId = zc_ObjectFloat_PartionGoods_Price()    

            LEFT JOIN ObjectLink AS ObjectLink_Unit 
                                 ON ObjectLink_Unit.ObjectId = MILinkObject_PartionGoods.ObjectId		        -- подразделение
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
            JOIN Object AS Object_Unit_Partion ON Object_Unit_Partion.Id = ObjectLink_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Storage 
                                 ON ObjectLink_Storage.ObjectId = MILinkObject_PartionGoods.ObjectId	                -- склад
                                AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_Storage_Partion ON Object_Storage_Partion.Id = ObjectLink_Storage.ChildObjectId  

            -- привязываем цены по прайсу 2 раза по виду товара и без
            LEFT JOIN tmpPricePR AS tmpPricePR_Kind 
                                 ON tmpPricePR_Kind.GoodsId = MovementItem.ObjectId
                                AND COALESCE (tmpPricePR_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)

            LEFT JOIN tmpPricePR ON tmpPricePR.GoodsId = MovementItem.ObjectId
                                AND tmpPricePR.GoodsKindId IS NULL

            LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = MovementItem.Id                                 
       ;

     ELSE

     RETURN QUERY
       WITH tmpPrice AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                              , lfObjectHistory_PriceListItem.GoodsKindId
                              , lfObjectHistory_PriceListItem.ValuePrice AS Price
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                              AS lfObjectHistory_PriceListItem
                         WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                        )


           -- цены по прайсу
          , tmpPricePR AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , lfObjectHistory_PriceListItem.GoodsKindId
                                , lfObjectHistory_PriceListItem.ValuePrice AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) )
                                AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )
            --колво движения из проводок
          , tmpContainer AS (SELECT MIContainer.MovementItemId
                                 , SUM (MIContainer.Amount) AS Amount
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.MovementId = inMovementId  
                               AND MIContainer.MovementDescId = zc_Movement_Inventory()
                               AND MIContainer.DescId = zc_MIContainer_Count()
                             GROUP BY  MIContainer.MovementItemId
                             )

       SELECT
             MovementItem.Id                     AS Id
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData            AS MeasureName

           , MovementItem.Amount                 AS Amount
           , MIFloat_HeadCount.ValueData         AS HeadCount
           , MIFloat_Count.ValueData             AS Count
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN ObjectFloat_Price_Partion.ValueData ELSE (CASE WHEN COALESCE (MIFloat_Price.ValueData, 0) <> 0 THEN MIFloat_Price.ValueData ELSE COALESCE (tmpPrice_Kind.Price, tmpPrice.Price) END) END :: TFloat AS Price
           
           , MIFloat_Summ.ValueData  :: TFloat AS Summ   
           
           , COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)                         ::TFloat AS Price_pr
           , (tmpContainer.Amount * COALESCE (tmpPricePR_Kind.Price, tmpPricePR.Price)) ::TFloat AS Summ_pr
           
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN ObjectDate_Value.ValueData    ELSE MIDate_PartionGoods.ValueData   END AS PartionGoodsDate
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 AND Object_PartionGoods.ValueData <> '0' THEN Object_PartionGoods.ValueData ELSE MIString_PartionGoods.ValueData END AS PartionGoods
           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKindComplete.Id         AS GoodsKindId_Complete
           , Object_GoodsKindComplete.ValueData  AS GoodsKindName_Complete
           , Object_Asset.Id                     AS AssetId
           , Object_Asset.ValueData              AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Unit_Partion.Id ELSE Object_Unit.Id               END AS UnitId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Unit_Partion.ValueData ELSE Object_Unit.ValueData END AS UnitName

           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Storage_Partion.Id ELSE Object_Storage.Id               END AS StorageId
           , CASE WHEN COALESCE (Object_PartionGoods.Id, 0) <> 0 THEN Object_Storage_Partion.ValueData ELSE Object_Storage.ValueData END AS StorageName

           , MIFloat_ContainerId.ValueData :: Integer AS ContainerId

           , MovementItem.isErased               AS isErased

           -- Id партии
           , Object_PartionGoods.Id              AS PartionGoodsId
           , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.Id) :: TVarChar AS IdBarCode
           , Null ::TDateTime  AS OperDate

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                          ON CLO_GoodsKind.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                         AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            -- LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (CLO_GoodsKind.ObjectId, MILinkObject_GoodsKind.ObjectId)
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (MILinkObject_GoodsKind.ObjectId, CLO_GoodsKind.ObjectId)

            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                             ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- привязываем цены 2 раза по виду товара и без
            LEFT JOIN tmpPrice AS tmpPrice_Kind 
                               ON tmpPrice_Kind.GoodsId = MovementItem.ObjectId
                              AND COALESCE (tmpPrice_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)

            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
                              AND tmpPrice.GoodsKindId IS NULL

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId
            -- свойства из партии
            LEFT JOIN ObjectDate AS ObjectDate_Value 
                                 ON ObjectDate_Value.ObjectId = MILinkObject_PartionGoods.ObjectId                      -- дата
                                AND ObjectDate_Value.DescId = zc_ObjectDate_PartionGoods_Value()

            LEFT JOIN ObjectFloat AS ObjectFloat_Price_Partion 
                             ON ObjectFloat_Price_Partion.ObjectId = MILinkObject_PartionGoods.ObjectId                 -- цена
                            AND ObjectFloat_Price_Partion.DescId = zc_ObjectFloat_PartionGoods_Price()    

            LEFT JOIN ObjectLink AS ObjectLink_Unit 
                                 ON ObjectLink_Unit.ObjectId = MILinkObject_PartionGoods.ObjectId		        -- подразделение
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
            LEFT JOIN Object AS Object_Unit_Partion ON Object_Unit_Partion.Id = ObjectLink_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Storage 
                                 ON ObjectLink_Storage.ObjectId = MILinkObject_PartionGoods.ObjectId	                -- склад
                                AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_Storage_Partion ON Object_Storage_Partion.Id = ObjectLink_Storage.ChildObjectId 

            -- привязываем цены по прайсу 2 раза по виду товара и без
            LEFT JOIN tmpPricePR AS tmpPricePR_Kind 
                                 ON tmpPricePR_Kind.GoodsId = MovementItem.ObjectId
                                AND COALESCE (tmpPricePR_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)

            LEFT JOIN tmpPricePR ON tmpPricePR.GoodsId = MovementItem.ObjectId
                                AND tmpPricePR.GoodsKindId IS NULL  
            
            LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = MovementItem.Id
       ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_Inventory (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 02.12.19         * цена с учетом вида товара
 19.12.18         *
 31.03.15         * add GoodsGroupNameFull, MeasureName
 01.09.14                                                       * add Unit, Storage
 27.07.14                                        * add Price
 23.07.14                                        * add Object_InfoMoney_View
 27.01.14                                        * all
 22.07.13         * add PartionGoodsDate
 18.07.13         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
