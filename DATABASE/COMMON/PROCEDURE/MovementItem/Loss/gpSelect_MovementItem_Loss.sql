   -- Function: gpSelect_MovementItem_Loss()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loss (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loss(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ContainerId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_old TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat, AmountRemains TFloat, Count TFloat, HeadCount TFloat
             , Price TFloat
             , PartionGoodsDate TDateTime
             , PartionGoodsId Integer, PartionGoods TVarChar
             , PartNumber TVarChar
             , StorageId Integer, StorageName TVarChar
             , PartionModelId Integer, PartionModelName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsKindId_Complete Integer, GoodsKindName_Complete  TVarChar
             , InDate TDateTime, PartnerInName TVarChar
             , AssetId Integer, AssetName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , isErased Boolean
             , isPeresort Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbBranchId_Constraint Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbDescId_from Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Loss());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется уровень доступа
     vbBranchId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), 0);

     -- определяется
     vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject INNER JOIN Object ON Object.Id = MovementLinkObject.ObjectId AND Object.DescId = zc_Object_Unit() WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From());
     vbDescId_from:= (SELECT Object.DescId FROM MovementLinkObject INNER JOIN Object ON Object.Id = MovementLinkObject.ObjectId WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_From());
     IF COALESCE (vbUnitId, 0) = 0
     THEN
         vbUnitId:= (SELECT MovementLinkObject.ObjectId FROM MovementLinkObject WHERE MovementLinkObject.MovementId = inMovementId AND MovementLinkObject.DescId = zc_MovementLinkObject_To());
     END IF;

     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     
     IF inShowAll = TRUE THEN

     -- Результат такой
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                           , MovementItem.Amount                           AS Amount
                           , MovementItem.ObjectId                         AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                           , COALESCE (MILO_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_Complete

                           , MIFloat_Count.ValueData            AS Count
                           , MIFloat_HeadCount.ValueData        AS HeadCount
                           , MIFloat_Price.ValueData            AS Price
                           , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
                           , MIString_PartionGoods.ValueData    AS PartionGoods
                           , MIString_PartNumber.ValueData :: TVarChar AS PartNumber
                           , COALESCE (MILinkObject_PartionGoods.ObjectId,0) AS PartionGoodsId
                           , MILinkObject_Storage.ObjectId      AS StorageId
                           , MILinkObject_PartionModel.ObjectId AS PartionModelId
                           , MILinkObject_Asset.ObjectId        AS AssetId

                           , MovementItem.isErased                         AS isErased
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                                            ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                           AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()

                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                            ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                            ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                                            ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionModel
                                                            ON MILinkObject_PartionModel.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PartionModel.DescId = zc_MILinkObject_PartionModel()

                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                       AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                     )
        -- Ограничение для ГП - какие товары показать
      , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                     , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                FROM ObjectBoolean AS ObjectBoolean_Order
                                     LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                                WHERE ObjectBoolean_Order.ValueData = TRUE
                                  AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                               )
      , tmpGoods AS (SELECT Object_Goods.Id                                                   AS GoodsId
                          , Object_Goods.ObjectCode                                           AS GoodsCode
                          , Object_Goods.ValueData                                            AS GoodsName
                          , COALESCE (tmpGoodsByGoodsKind.GoodsKindId, 0)                     AS GoodsKindId
                          -- , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN zc_Enum_GoodsKind_Main() ELSE 0 END AS GoodsKindId -- Ирна + Готовая продукция + Доходы Мясное сырье
                          -- , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                          , Object_InfoMoney_View.InfoMoneyId
                     FROM Object_InfoMoney_View
                          JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                          ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                         AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                          JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                                     AND Object_Goods.isErased = FALSE
                          LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
                          /*LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                                AND Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье*/
                     WHERE (tmpGoodsByGoodsKind.GoodsId > 0 AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()
                                                                                                               , zc_Enum_InfoMoneyDestination_21000()
                                                                                                               , zc_Enum_InfoMoneyDestination_21100()
                                                                                                               , zc_Enum_InfoMoneyDestination_30100()
                                                                                                               , zc_Enum_InfoMoneyDestination_30200()
                                                                                                               -- , zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                                                               -- , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                                                                ))
                        OR Object_InfoMoney_View.InfoMoneyDestinationId IN  (zc_Enum_InfoMoneyDestination_20500()) -- Общефирменные + Оборотная тара
                        OR vbBranchId_Constraint = 0
                    )

            -- Остатки
          , tmpDescWhereObject AS (SELECT zc_ContainerLinkObject_Unit() AS DescId UNION SELECT zc_ContainerLinkObject_Member() AS DescId)
          , tmpRemains AS (SELECT CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                    , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                    , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                     )
                                            THEN 0
                                       ELSE Container.Id
                                  END AS ContainerId
                                , Container.ObjectId                          AS GoodsId
                                , SUM (Container.Amount)                      AS Amount
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0) AS GoodsKindId_complete
                                , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                    , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                    , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                     )
                                            THEN zc_DateEnd()
                                       ELSE COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())
                                  END AS PartionDate
                                , Object_PartionGoods.ValueData AS PartionGoodsName
                                , ObjectString_PartNumber.ValueData AS PartNumber
                                , Object_Storage.Id               AS StorageId
                                , Object_Storage.ValueData        AS StorageName
                                , Object_PartionModel.Id          AS PartionModelId
                                , Object_PartionModel.ValueData   AS PartionModelName
                           FROM tmpDescWhereObject
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ObjectId = vbUnitId
                                                              AND CLO_Unit.DescId = tmpDescWhereObject.DescId
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                     ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                    AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                --место хранения
                                LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                     ON ObjectLink_Storage.ObjectId = Object_PartionGoods.Id
                                                    AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
                                LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = ObjectLink_Storage.ChildObjectId
                                -- модель
                                LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                     ON ObjectLink_PartionModel.ObjectId = Object_PartionGoods.Id		        
                                                    AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()
                                LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = ObjectLink_PartionModel.ChildObjectId                    
                                -- № по тех паспорту
                                LEFT JOIN ObjectString AS ObjectString_PartNumber
                                                       ON ObjectString_PartNumber.ObjectId = Object_PartionGoods.Id
                                                      AND ObjectString_PartNumber.DescId = zc_ObjectString_PartionGoods_PartNumber()

                                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                     ON ObjectLink_Goods_InfoMoney.ObjectId = Container.ObjectId
                                                    AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                     ON ObjectLink_GoodsKindComplete.ObjectId = Object_PartionGoods.Id
                                                    AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()

                           WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                           GROUP BY CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                      , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                      , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                       )
                                              THEN 0
                                         ELSE Container.Id
                                    END
                                  , Container.ObjectId
                                  , COALESCE (CLO_GoodsKind.ObjectId, 0)
                                  , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)
                                  , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                      , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                      , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                       )
                                              THEN zc_DateEnd()
                                         ELSE COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())
                                    END
                                  , Object_PartionGoods.ValueData
                                  , ObjectString_PartNumber.ValueData 
                                  , Object_Storage.Id
                                  , Object_Storage.ValueData
                                  , Object_PartionModel.Id  
                                  , Object_PartionModel.ValueData
                          )

       -- товары пересорт да/нет
      , tmpGoodsByGoodsKindSub AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                        , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                        --, ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     AS GoodsSubId
                                        --, ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId AS GoodsKindSubId
                                        , CASE WHEN COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)<>0 OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0
                                               THEN TRUE ELSE FALSE
                                          END AS isPeresort
                                   FROM Object_GoodsByGoodsKind_View
                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                   WHERE COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)<>0 OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0
                                   )

       -- Цены из прайса
      , tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                              , lfSelect.GoodsKindId AS GoodsKindId
                              , lfSelect.ValuePrice  AS Price_PriceList
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:=  zc_PriceList_Basis(), inOperDate:= COALESCE (vbOperDate, CURRENT_DATE)::TDateTime) AS lfSelect
                         )


       -- Результат
       SELECT
             0                          AS Id
           , tmpRemains.ContainerId     AS ContainerId
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TFloat)      AS Amount
           , COALESCE (tmpRemains.Amount, 0)  :: TFloat  AS AmountRemains
           , CAST (NULL AS TFloat)      AS Count
           , CAST (NULL AS TFloat)      AS HeadCount 
           
           , CAST (COALESCE (tmpPriceList_Kind.Price_Pricelist, tmpPriceList.Price_Pricelist) AS TFloat) :: TFloat AS Price
           
           , CAST (NULL AS TDateTime)   AS PartionGoodsDate
           , CAST (NULL AS Integer)     AS PartionGoodsId
           , COALESCE (tmpRemains.PartionGoodsName,NULL) :: TVarChar AS PartionGoods
           , COALESCE (tmpRemains.PartNumber,NULL)       :: TVarChar AS PartNumber
           , tmpRemains.StorageId
           , tmpRemains.StorageName
           , tmpRemains.PartionModelId
           , tmpRemains.PartionModelName

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , CAST (NULL AS Integer)     AS GoodsKindId_Complete
           , CAST (NULL AS TVarchar)    AS GoodsKindName_Complete

           , ObjectDate_In.ValueData       :: TDateTime AS InDate
           , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName

           , 0 ::Integer                AS AssetId
           , CAST (NULL AS TVarChar)    AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , FALSE                      AS isErased
           , COALESCE (tmpGoodsByGoodsKindSub.isPeresort, False) AS isPeresort
           
       FROM tmpGoods
            LEFT JOIN tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                           AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpGoods.InfoMoneyId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_In
                                 ON ObjectDate_In.ObjectId = tmpGoods.GoodsId
                                AND ObjectDate_In.DescId = zc_ObjectDate_Goods_In()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_PartnerIn
                                 ON ObjectLink_Goods_PartnerIn.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_PartnerIn.DescId = zc_ObjectLink_Goods_PartnerIn()
            LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = ObjectLink_Goods_PartnerIn.ChildObjectId

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId
                                AND tmpRemains.GoodsKindId = CASE WHEN tmpGoods.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                              , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                              , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                )
                                                                       THEN tmpGoods.GoodsKindId
                                                                  WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                                       THEN tmpGoods.GoodsKindId
                                                                  ELSE 0
                                                              END
                                AND (tmpRemains.PartionDate = zc_DateEnd()
                                AND tmpRemains.Amount <> 0
                                    )

            LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId = tmpGoods.GoodsId
                                            AND tmpGoodsByGoodsKindSub.GoodsKindId = tmpGoods.GoodsKindId

            -- привязываем 2 раза по виду товара и без
            LEFT JOIN tmpPriceList AS tmpPriceList_Kind 
                                   ON tmpPriceList_Kind.GoodsId = tmpGoods.GoodsId
                                  AND COALESCE (tmpPriceList_Kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpGoods.GoodsId
                                  AND tmpPriceList.GoodsKindId IS NULL


       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             tmpMI.MovementItemId               AS Id
           , tmpRemains.ContainerId     AS ContainerId
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , tmpMI.Amount
           , COALESCE (tmpRemains.Amount, 0)  :: TFloat  AS AmountRemains
           , tmpMI.Count
           , tmpMI.HeadCount 
           , tmpMI.Price ::TFloat
           , tmpMI.PartionGoodsDate
           , tmpMI.PartionGoodsId
           , tmpMI.PartionGoods
           , tmpMI.PartNumber
           , Object_Storage.Id                  AS StorageId
           , Object_Storage.ValueData           AS StorageName
           , Object_PartionModel.Id             AS PartionModelId
           , Object_PartionModel.ValueData      AS PartionModelName
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_GoodsKindComplete.Id        AS GoodsKindId_Complete
           , Object_GoodsKindComplete.ValueData AS GoodsKindName_Complete

           , ObjectDate_In.ValueData       :: TDateTime AS InDate
           , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName

           , Object_Asset.Id                    AS AssetId
           , Object_Asset.ValueData             AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , tmpMI.isErased
           , COALESCE (tmpGoodsByGoodsKindSub.isPeresort, False) AS isPeresort

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpMI.GoodsKindId_Complete

            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = tmpMI.StorageId 
            LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = tmpMI.PartionModelId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI.AssetId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_In
                                 ON ObjectDate_In.ObjectId = tmpMI.GoodsId
                                AND ObjectDate_In.DescId = zc_ObjectDate_Goods_In()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_PartnerIn
                                 ON ObjectLink_Goods_PartnerIn.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_PartnerIn.DescId = zc_ObjectLink_Goods_PartnerIn()
            LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = ObjectLink_Goods_PartnerIn.ChildObjectId

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI.GoodsId
                                AND tmpRemains.GoodsKindId = CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                                  , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                                  , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                                   )
                                                                        THEN tmpMI.GoodsKindId
                                                                   WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                                        THEN tmpMI.GoodsKindId
                                                                   ELSE 0
                                                              END
                                AND (tmpRemains.PartionDate = COALESCE (tmpMI.PartionGoodsDate, zc_DateEnd())
                                --OR PartionGoodsDate IS NULL
                                --OR tmpRemains.PartionDate = zc_DateEnd()
                                  OR vbDescId_from <> zc_Object_Unit()
                                    )
                                AND COALESCE (tmpRemains.PartionGoodsName,'') = COALESCE (tmpMI.PartionGoods,'')

            LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId = tmpMI.GoodsId
                                            AND tmpGoodsByGoodsKindSub.GoodsKindId = tmpMI.GoodsKindId

            ;
     ELSE

     -- Результат другой
     RETURN QUERY
     WITH   -- Остатки
            tmpDescWhereObject AS (SELECT zc_ContainerLinkObject_Unit() AS DescId UNION SELECT zc_ContainerLinkObject_Member() AS DescId)
          , tmpRemains AS (SELECT CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                    , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                    , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                     )
                                            THEN 0
                                       ELSE Container.Id
                                  END AS ContainerId
                                , Container.ObjectId                          AS GoodsId
                                , SUM (Container.Amount)                      AS Amount
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0) AS GoodsKindId_complete
                                , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                    , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                    , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                     )
                                            THEN zc_DateEnd()
                                       ELSE COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())
                                  END AS PartionDate
                                , Object_PartionGoods.ValueData AS PartionGoodsName
                           FROM tmpDescWhereObject
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ObjectId = vbUnitId
                                                              AND CLO_Unit.DescId = tmpDescWhereObject.DescId
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                     ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                    AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                     ON ObjectLink_Goods_InfoMoney.ObjectId = Container.ObjectId
                                                    AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                                LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                     ON ObjectLink_GoodsKindComplete.ObjectId = Object_PartionGoods.Id
                                                    AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()

                           WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                           GROUP BY CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                      , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                      , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                       )
                                              THEN 0
                                         ELSE Container.Id
                                    END
                                  , Container.ObjectId
                                  , COALESCE (CLO_GoodsKind.ObjectId, 0)
                                  , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)
                                  , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                      , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                      , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                       )
                                              THEN zc_DateEnd()
                                         ELSE COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())
                                    END
                                  , Object_PartionGoods.ValueData
                          )


       -- товары пересорт да/нет
      , tmpGoodsByGoodsKindSub AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                        , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                        --, ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     AS GoodsSubId
                                        --, ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId AS GoodsKindSubId
                                        , CASE WHEN COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)<>0 OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0
                                               THEN TRUE ELSE FALSE
                                          END AS isPeresort
                                   FROM Object_GoodsByGoodsKind_View
                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                   WHERE COALESCE(ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId ,0)<>0 OR COALESCE(ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId,0) <> 0
                                   )

       -- Результат
       SELECT
             MovementItem.Id                    AS Id
           , tmpRemains.ContainerId             AS ContainerId
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                AS Amount
           , COALESCE (tmpRemains.Amount, 0) :: TFloat   AS AmountRemains
           , MIFloat_Count.ValueData            AS Count
           , MIFloat_HeadCount.ValueData        AS HeadCount
           , COALESCE (MIFloat_Price.ValueData,0):: TFloat AS Price      
           , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
           , Object_PartionGoods.Id :: Integer AS PartionGoodsId

           , CASE WHEN COALESCE (Object_PartionGoods.ValueData, MIString_PartionGoods.ValueData) <> ''
                   AND COALESCE (Object_PartionGoods.ValueData, MIString_PartionGoods.ValueData) <> '0'
                       THEN COALESCE (Object_PartionGoods.ValueData, MIString_PartionGoods.ValueData)

                  WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0 AND Object_PartionGoods.ObjectCode > 0
                       THEN zfCalc_PartionGoodsName_Asset (inMovementId      := Object_PartionGoods.ObjectCode          -- 
                                                         , inInvNumber       := Object_PartionGoods.ValueData           -- Инвентарный номер
                                                         , inOperDate        := ObjectDate_PartionGoods_Value.ValueData -- Дата ввода в эксплуатацию
                                                         , inUnitName        := Object_Unit_partion.ValueData           -- Подразделение использования
                                                         , inStorageName     := Object_Storage_partion.ValueData        -- Место хранения
                                                         , inGoodsName       := ''                                      -- Основные средства или Товар
                                                          )
                  WHEN ObjectLink_Goods.ChildObjectId <> 0 AND ObjectLink_Unit.ChildObjectId <> 0
                       THEN zfCalc_PartionGoodsName_InvNumber (inInvNumber       := Object_PartionGoods.ValueData             -- Инвентарный номер
                                                             , inOperDate        := ObjectDate_PartionGoods_Value.ValueData   -- Дата перемещения
                                                             , inPrice           := ObjectFloat_PartionGoods_Price.ValueData  -- Цена
                                                             , inUnitName_Partion:= Object_Unit_partion.ValueData             -- Подразделение(для цены)
                                                             , inStorageName     := Object_Storage_partion.ValueData          -- Место хранения
                                                             , inGoodsName       := ''                                        -- Товар
                                                              )
             END ::TVarChar AS PartionGoods
           
           , MIString_PartNumber.ValueData  ::TVarChar AS PartNumber
           , Object_Storage.Id                  AS StorageId
           , Object_Storage.ValueData           AS StorageName
           , Object_PartionModel.Id             AS PartionModelId
           , Object_PartionModel.ValueData      AS PartionModelName
           
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_GoodsKindComplete.Id           AS GoodsKindId_Complete
           , Object_GoodsKindComplete.ValueData    AS GoodsKindName_Complete
           
           , ObjectDate_In.ValueData       :: TDateTime AS InDate
           , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName
           
           , Object_Asset.Id                    AS AssetId
           , Object_Asset.ValueData             AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , MovementItem.isErased              AS isErased
           
           , COALESCE (tmpGoodsByGoodsKindSub.isPeresort, False) AS isPeresort

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased

            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

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

            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId

            -- Остальные св-ва партии
            LEFT JOIN ObjectLink AS ObjectLink_Goods
                                 ON ObjectLink_Goods.ObjectId = Object_PartionGoods.Id
                                AND ObjectLink_Goods.DescId   = zc_ObjectLink_PartionGoods_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_PartionGoods.Id
                                AND ObjectLink_Unit.DescId   = zc_ObjectLink_PartionGoods_Unit()
            LEFT JOIN Object AS Object_Unit_partion ON Object_Unit_partion.Id = ObjectLink_Unit.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Storage
                                 ON ObjectLink_Storage.ObjectId = Object_PartionGoods.Id
                                AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_Storage_partion ON Object_Storage_partion.Id = ObjectLink_Storage.ChildObjectId
            LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                 ON ObjectDate_PartionGoods_Value.ObjectId = Object_PartionGoods.Id
                                AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
            LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Price
                                  ON ObjectFloat_PartionGoods_Price.ObjectId = Object_PartionGoods.Id
                                 AND ObjectFloat_PartionGoods_Price.DescId   = zc_ObjectFloat_PartionGoods_Price()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                             ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
            LEFT JOIN Object AS Object_Storage ON Object_Storage.Id = MILinkObject_Storage.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionModel
                                             ON MILinkObject_PartionModel.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionModel.DescId = zc_MILinkObject_PartionModel()
            LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = MILinkObject_PartionModel.ObjectId

            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_In
                                 ON ObjectDate_In.ObjectId = MovementItem.ObjectId
                                AND ObjectDate_In.DescId = zc_ObjectDate_Goods_In()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_PartnerIn
                                 ON ObjectLink_Goods_PartnerIn.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_PartnerIn.DescId = zc_ObjectLink_Goods_PartnerIn()
            LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = ObjectLink_Goods_PartnerIn.ChildObjectId

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = Object_Goods.Id
                                AND tmpRemains.GoodsKindId = CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                                  , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                                  , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                                   )
                                                                        THEN Object_GoodsKind.Id
                                                                   WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                                        THEN Object_GoodsKind.Id
                                                                   ELSE 0
                                                              END
                                AND (tmpRemains.PartionDate = COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd())
                               -- OR PartionGoodsDate IS NULL
                               -- OR tmpRemains.PartionDate = zc_DateEnd()
                                  OR vbDescId_from <> zc_Object_Unit()
                                    )
                                AND COALESCE (tmpRemains.PartionGoodsName,'') = COALESCE (Object_PartionGoods.ValueData, MIString_PartionGoods.ValueData,'')
                                AND COALESCE (tmpRemains.GoodsKindId_complete, 0) = COALESCE (MILO_GoodsKindComplete.ObjectId, 0)
                                --AND (tmpRemains.Amount > 0 OR vbUserId = 5)

            LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId = MovementItem.ObjectId
                                            AND tmpGoodsByGoodsKindSub.GoodsKindId = Object_GoodsKind.Id                                
            ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.01.24         * GoodsName_old
 14.12.23         * add Price
 25.06.23         *
 13.12.22         * isPeresort
 08.02.22         *
 01.02.21         *
 19.10.18         *
 28.07.16         *
 31.03.15         * add GoodsGroupNameFull, MeasureName
 17.10.14         * add св-ва PartionGoods
 08.10.14                                        * add Object_InfoMoney_View
 01.09.14                                                       * + PartionGoodsDate
 26.05.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Loss (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
