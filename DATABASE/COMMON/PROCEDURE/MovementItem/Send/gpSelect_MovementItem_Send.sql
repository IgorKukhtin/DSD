 -- Function: gpSelect_MovementItem_Send()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_old TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , PartionGoodsDate TDateTime
             , Amount TFloat, Count TFloat, HeadCount TFloat
             , PartionGoodsId Integer, PartionGoods TVarChar
             , PartNumber TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , GoodsKindId_Complete Integer, GoodsKindName_Complete  TVarChar
             , InDate TDateTime, PartnerInName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , AssetId Integer, AssetCode Integer, AssetName TVarChar
             , AssetId_two Integer, AssetCode_two Integer, AssetName_two TVarChar
             , UnitName TVarChar
             , StorageId Integer, StorageName TVarChar
             , PartionModelId Integer, PartionModelName TVarChar
             , Price TFloat
             , AmountRemains TFloat
             , Amount_child_sec TFloat, Amount_diff TFloat      --резерв
             , isErased Boolean
             , isPeresort Boolean
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
     IF inShowAll = TRUE
     THEN

     -- Результат такой
     RETURN QUERY
       WITH tmpRemains AS (SELECT Container.ObjectId                    AS GoodsId
                                , SUM (Container.Amount)                AS Amount
                                , COALESCE (CLO_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                , Object_PartionGoods.Id                AS PartionGoodsId
                                , Object_PartionGoods.ValueData         AS PartionGoodsName
                           FROM ContainerLinkObject AS CLO_Unit
                                INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                           WHERE CLO_Unit.ObjectId = vbUnitId
                             AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                             AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                           GROUP BY Container.ObjectId
                                  , COALESCE (CLO_GoodsKind.ObjectId, 0)
                                  , Object_PartionGoods.Id
                                  , Object_PartionGoods.ValueData
                          )
      , tmpMIContainer AS (SELECT tmp.MovementItemId
                                , tmp.PartionGoodsId
                                , tmp.PartionGoods
                                , tmp.PartionDate
                                , tmp.UnitId
                                , tmp.StorageId
                                , tmp.PartionModelId
                                , tmp.Price

                           FROM (SELECT MIContainer.MovementItemId            AS MovementItemId
                                      , Object_PartionGoods.Id                AS PartionGoodsId
                                      , CASE WHEN Object_PartionGoods.ValueData = '0' THEN '' ELSE Object_PartionGoods.ValueData END AS PartionGoods
                                      , ObjectDate_Value.ValueData            AS PartionDate
                                      , ObjectLink_Unit.ChildObjectId         AS UnitId
                                      , ObjectLink_Storage.ChildObjectId      AS StorageId
                                      , ObjectLink_PartionModel.ChildObjectId AS PartionModelId
                                      , ObjectFloat_Price.ValueData           AS Price
                                      , ROW_NUMBER() OVER (PARTITION BY MIContainer.ObjectId_Analyzer ORDER BY ABS (MIContainer.Amount) DESC) AS Ord
                                 FROM MovementItemContainer AS MIContainer
                                      INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                     ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                                    AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                      LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId = Object_PartionGoods.Id
                                                           AND ObjectLink_Unit.DescId   = zc_ObjectLink_PartionGoods_Unit()
                                      LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                           ON ObjectLink_Storage.ObjectId = Object_PartionGoods.Id
                                                          AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
                                      -- модель
                                      LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                           ON ObjectLink_PartionModel.ObjectId = Object_PartionGoods.Id
                                                          AND ObjectLink_PartionModel.DescId = zc_ObjectLink_PartionGoods_PartionModel()

                                      LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                            ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id
                                                           AND ObjectFloat_Price.DescId   = zc_ObjectFloat_PartionGoods_Price()
                                      LEFT JOIN ObjectDate AS ObjectDate_Value
                                                           ON ObjectDate_Value.ObjectId = Object_PartionGoods.Id
                                                          AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                 WHERE MIContainer.MovementId             = inMovementId
                                   AND MIContainer.DescId                 = zc_MIContainer_Count()
                                   AND MIContainer.WhereObjectId_Analyzer = (SELECT ABS (MAX (CASE WHEN MLO.DescId = zc_MovementLinkObject_From() AND Object.DescId = zc_Object_Member() THEN  1 * MLO.ObjectId
                                                                                                   WHEN MLO.DescId = zc_MovementLinkObject_To()   AND Object.DescId = zc_Object_Member() THEN -1 * MLO.ObjectId
                                                                                                   ELSE NULL
                                                                                              END))
                                                                             FROM MovementLinkObject AS MLO
                                                                                  INNER JOIN Object ON Object.Id = MLO.ObjectId
                                                                             WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
                                                                            )
                                ) AS tmp
                           WHERE tmp.Ord = 1 -- !!!берем только ОДНУ партию!!!
                          )

       --данные из документов заказа по резерву для текущего документа
      , tmpOrderExternalChild AS (SELECT tmp.GoodsId
                                       , tmp.GoodsKindId
                                       , SUM (COALESCE (tmp.AmountSecond,0)) AS AmountSecond
                                  FROM gpSelect_MI_OrderExternalChild_bySend (inMovementId, inIsErased, inSession) AS tmp
                                  GROUP BY tmp.GoodsId
                                         , tmp.GoodsKindId
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
             0                                           AS Id
           , tmpGoods.GoodsId                            AS GoodsId
           , tmpGoods.GoodsCode                          AS GoodsCode
           , tmpGoods.GoodsName                          AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TDateTime)   AS PartionGoodsDate
           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS Count
           , CAST (NULL AS TFloat)      AS HeadCount
           , COALESCE (tmpRemains.PartionGoodsId, NULL)   :: Integer  AS PartionGoodsId
           , COALESCE (tmpRemains.PartionGoodsName, NULL) :: TVarChar AS PartionGoods
           , '' ::TVarChar              AS PartNumber
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , CAST (NULL AS Integer)     AS GoodsKindId_Complete
           , CAST (NULL AS TVarchar)    AS GoodsKindName_Complete
           , ObjectDate_In.ValueData       :: TDateTime AS InDate
           , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , CAST (NULL AS Integer)     AS AssetId
           , CAST (NULL AS Integer)     AS AssetCode
           , CAST (NULL AS TVarChar)    AS AssetName
           , CAST (NULL AS Integer)     AS AssetId_two
           , CAST (NULL AS Integer)     AS AssetCode_two
           , CAST (NULL AS TVarChar)    AS AssetName_two
           , CAST (NULL AS TVarChar)    AS UnitName
           , CAST (NULL AS Integer)     AS StorageId
           , CAST (NULL AS TVarChar)    AS StorageName
           , CAST (NULL AS Integer)     AS PartionModelId
           , CAST (NULL AS TVarChar)    AS PartionModelName
           , CAST (NULL AS TFloat)      AS Price

           , tmpRemains.Amount   :: TFloat AS AmountRemains

           , CAST (NULL AS TFloat)      AS Amount_child_sec --итого резерв для заявок
           , CAST (NULL AS TFloat)      AS Amount_diff      --разница перемещения с резервом

           , FALSE                      AS isErased
           , COALESCE (tmpGoodsByGoodsKindSub.isPeresort, False) AS isPeresort
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
                  /*LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье*/
             -- WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100())
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

            LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId = tmpGoods.GoodsId
                                            AND tmpGoodsByGoodsKindSub.GoodsKindId = tmpGoods.GoodsKindId
       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                             AS Id
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , COALESCE (tmpMIContainer.PartionDate, MIDate_PartionGoods.ValueData)   :: TDateTime AS PartionGoodsDate
           , MovementItem.Amount                   AS Amount
           , MIFloat_CountPack.ValueData           AS Count
           , MIFloat_HeadCount.ValueData           AS HeadCount
           , COALESCE (tmpMIContainer.PartionGoodsId, Object_PartionGoods.Id,0 ) AS PartionGoodsId
           , COALESCE (tmpMIContainer.PartionGoods, Object_PartionGoods.ValueData, MIString_PartionGoods.ValueData) :: TVarChar AS PartionGoods
           , MIString_PartNumber.ValueData :: TVarChar AS PartNumber
           , Object_GoodsKind.Id                   AS GoodsKindId
           , Object_GoodsKind.ValueData            AS GoodsKindName
           , Object_GoodsKindComplete.Id           AS GoodsKindId_Complete
           , Object_GoodsKindComplete.ValueData    AS GoodsKindName_Complete
           , ObjectDate_In.ValueData       :: TDateTime AS InDate
           , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Asset.Id                       AS AssetId
           , Object_Asset.ObjectCode               AS AssetCode
           , Object_Asset.ValueData                AS AssetName

           , Object_Asset_two.Id                   AS AssetId_two
           , Object_Asset_two.ObjectCode           AS AssetCode_two
           , Object_Asset_two.ValueData            AS AssetName_two

           , Object_Unit_partion.ValueData         AS UnitName
           , Object_Storage.Id                     AS StorageId
           , Object_Storage.ValueData              AS StorageName
           , Object_PartionModel.Id                AS PartionModelId
           , Object_PartionModel.ValueData         AS PartionModelName

           , tmpMIContainer.Price                  AS Price

           , tmpRemains.Amount :: TFloat           AS AmountRemains

           , tmpReserv.AmountSecond :: TFloat AS Amount_child_sec --итого резерв для заявок
           , (COALESCE (tmpReserv.AmountSecond,0) - COALESCE (MovementItem.Amount,0))  ::TFloat AS Amount_diff

           , MovementItem.isErased                 AS isErased
           , COALESCE (tmpGoodsByGoodsKindSub.isPeresort, False) AS isPeresort

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

            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKindComplete
                                             ON MILO_GoodsKindComplete.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILO_GoodsKindComplete.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                             ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionModel
                                             ON MILinkObject_PartionModel.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionModel.DescId = zc_MILinkObject_PartionModel()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                             ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()
            LEFT JOIN Object AS Object_Asset_two ON Object_Asset_two.Id = MILinkObject_Asset_two.ObjectId

            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id
            LEFT JOIN Object AS Object_Unit_partion ON Object_Unit_partion.Id = tmpMIContainer.UnitId
            LEFT JOIN Object AS Object_Storage      ON Object_Storage.Id      = COALESCE (MILinkObject_Storage.ObjectId,tmpMIContainer.StorageId)
            LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = COALESCE (MILinkObject_PartionModel.ObjectId, tmpMIContainer.PartionModelId)

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

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.ObjectId
                                AND tmpRemains.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                AND COALESCE (tmpRemains.PartionGoodsName,'') = COALESCE (tmpMIContainer.PartionGoods, Object_PartionGoods.ValueData, MIString_PartionGoods.ValueData,'')

            LEFT JOIN ObjectDate AS ObjectDate_In
                                 ON ObjectDate_In.ObjectId = MovementItem.ObjectId
                                AND ObjectDate_In.DescId = zc_ObjectDate_Goods_In()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_PartnerIn
                                 ON ObjectLink_Goods_PartnerIn.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_PartnerIn.DescId = zc_ObjectLink_Goods_PartnerIn()
            LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = ObjectLink_Goods_PartnerIn.ChildObjectId

            LEFT JOIN tmpOrderExternalChild AS tmpReserv
                                            ON tmpReserv.GoodsId = MovementItem.ObjectId
                                           AND tmpReserv.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)

            LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId = MovementItem.ObjectId
                                            AND tmpGoodsByGoodsKindSub.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
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
                                 , MIString_PartionGoods.ValueData               AS PartionGoods
                                 , MIString_PartNumber.ValueData :: TVarChar     AS PartNumber
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , COALESCE (MILO_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_Complete
                                 , COALESCE (MILinkObject_PartionGoods.ObjectId,0) AS PartionGoodsId
                                 , MILinkObject_Storage.ObjectId                   AS StorageId
                                 , MILinkObject_PartionModel.ObjectId              AS PartionModelId
                                 , MILinkObject_Asset.ObjectId                     AS AssetId
                                 , MILinkObject_Asset_two.ObjectId                 AS AssetId_two
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
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Storage
                                                                  ON MILinkObject_Storage.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Storage.DescId = zc_MILinkObject_Storage()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionModel
                                                                  ON MILinkObject_PartionModel.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_PartionModel.DescId = zc_MILinkObject_PartionModel()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                                  ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                                  ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()

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

                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                   )
          , tmpRemains AS (SELECT tmpMI_Goods.MovementItemId
                                , SUM (Container.Amount)        AS Amount
                                , Object_PartionGoods.Id        AS PartionGoodsId
                                , Object_PartionGoods.ValueData AS PartionGoodsName
                           FROM tmpMI_Goods
                                INNER JOIN Container ON Container.ObjectId = tmpMI_Goods.GoodsId
                                                    AND Container.DescId   = zc_Container_Count()
                                                    AND Container.Amount   <> 0
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId    = vbUnitId
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                              ON CLO_GoodsKind.ContainerId = Container.Id
                                                             AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                LEFT JOIN ContainerLinkObject AS CLO_Account
                                                              ON CLO_Account.ContainerId = Container.Id
                                                             AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = CLO_Unit.ContainerId
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                           WHERE COALESCE (CLO_GoodsKind.ObjectId, 0) = tmpMI_Goods.GoodsKindId
                             AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                           GROUP BY tmpMI_Goods.MovementItemId
                                  , Object_PartionGoods.Id
                                  , Object_PartionGoods.ValueData
                          )
      , tmpMIContainer AS (SELECT tmp.MovementItemId
                                , tmp.PartionGoodsId
                                , tmp.PartionGoods
                                , tmp.PartionDate
                                , tmp.UnitId
                                , tmp.StorageId
                                , tmp.PartionModelId
                                , tmp.Price
                           FROM (SELECT MIContainer.MovementItemId            AS MovementItemId
                                      , Object_PartionGoods.Id                AS PartionGoodsId
                                      , CASE WHEN Object_PartionGoods.ValueData = '0' THEN '' ELSE Object_PartionGoods.ValueData END AS PartionGoods
                                      , ObjectDate_Value.ValueData            AS PartionDate
                                      , ObjectLink_Unit.ChildObjectId         AS UnitId
                                      , ObjectLink_Storage.ChildObjectId      AS StorageId
                                      , ObjectLink_PartionModel.ChildObjectId AS PartionModelId
                                      , ObjectFloat_Price.ValueData           AS Price
                                      , ROW_NUMBER() OVER (PARTITION BY MIContainer.ObjectId_Analyzer ORDER BY ABS (MIContainer.Amount) DESC) AS Ord
                                 FROM MovementItemContainer AS MIContainer
                                      INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                     ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                                    AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                      LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id        = CLO_PartionGoods.ObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                           ON ObjectLink_Unit.ObjectId = Object_PartionGoods.Id
                                                          AND ObjectLink_Unit.DescId   = zc_ObjectLink_PartionGoods_Unit()
                                      LEFT JOIN ObjectLink AS ObjectLink_Storage
                                                           ON ObjectLink_Storage.ObjectId = Object_PartionGoods.Id
                                                          AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
                                      LEFT JOIN ObjectLink AS ObjectLink_PartionModel
                                                           ON ObjectLink_PartionModel.ObjectId = Object_PartionGoods.Id
                                                          AND ObjectLink_PartionModel.DescId   = zc_ObjectLink_PartionGoods_PartionModel()

                                      LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                                            ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id
                                                           AND ObjectFloat_Price.DescId   = zc_ObjectFloat_PartionGoods_Price()
                                      LEFT JOIN ObjectDate AS ObjectDate_Value
                                                           ON ObjectDate_Value.ObjectId = Object_PartionGoods.Id
                                                          AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                 WHERE MIContainer.MovementId             = inMovementId
                                   AND MIContainer.DescId                 = zc_MIContainer_Count()
                                   AND MIContainer.WhereObjectId_Analyzer = (SELECT ABS (MAX (CASE WHEN MLO.DescId = zc_MovementLinkObject_From() AND Object.DescId = zc_Object_Member() THEN  1 * MLO.ObjectId
                                                                                                   WHEN MLO.DescId = zc_MovementLinkObject_To()   AND Object.DescId = zc_Object_Member() THEN -1 * MLO.ObjectId
                                                                                                   ELSE NULL
                                                                                              END))
                                                                             FROM MovementLinkObject AS MLO
                                                                                  INNER JOIN Object ON Object.Id = MLO.ObjectId
                                                                             WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_From(), zc_MovementLinkObject_To())
                                                                            )
                                ) AS tmp
                           WHERE tmp.Ord = 1 -- !!!берем только ОДНУ партию!!!
                          )

       --данные из документов заказа по резерву для текущего документа
      , tmpOrderExternalChild AS (SELECT tmp.GoodsId
                                       , tmp.GoodsKindId
                                       , SUM (COALESCE (tmp.AmountSecond,0)) AS AmountSecond
                                  FROM gpSelect_MI_OrderExternalChild_bySend (inMovementId, inIsErased, inSession) AS tmp
                                  GROUP BY tmp.GoodsId
                                         , tmp.GoodsKindId
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
             tmpMI_Goods.MovementItemId                  AS Id
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , COALESCE (tmpMIContainer.PartionDate, tmpMI_Goods.PartionGoodsDate, ObjectDate_Value.ValueData) :: TDateTime AS PartionGoodsDate
           , tmpMI_Goods.Amount                 AS Amount
           , tmpMI_Goods.Count                  AS Count
           , tmpMI_Goods.HeadCount              AS HeadCount
           , COALESCE (tmpMIContainer.PartionGoodsId, Object_PartionGoods.Id ) AS PartionGoodsId
           , CASE WHEN COALESCE (tmpMI_Goods.PartionGoodsId, 0) = 0 AND tmpMI_Goods.PartionGoods <> '' THEN tmpMI_Goods.PartionGoods
                  ELSE COALESCE (tmpMIContainer.PartionGoods, Object_PartionGoods.ValueData)
             END :: TVarChar  AS PartionGoods
           , tmpMI_Goods.PartNumber  ::TVarChar AS PartNumber
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_GoodsKindComplete.Id        AS GoodsKindId_Complete
           , Object_GoodsKindComplete.ValueData AS GoodsKindName_Complete
           , ObjectDate_In.ValueData       :: TDateTime AS InDate
           , Object_PartnerIn.ValueData    :: TVarChar  AS PartnerInName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , Object_Asset.Id                    AS AssetId
           , Object_Asset.ObjectCode            AS AssetCode
           , Object_Asset.ValueData             AS AssetName
           , Object_Asset_two.Id                AS AssetId_two
           , Object_Asset_two.ObjectCode        AS AssetCode_two
           , Object_Asset_two.ValueData         AS AssetName_two

           , Object_Unit_partion.ValueData      AS UnitName
           , Object_Storage.Id                  AS StorageId
           , CASE WHEN tmpMI_Goods.StorageId IS NULL AND tmpMIContainer.StorageId > 0 THEN '***Только для партии расхода: ' || Object_Storage.ValueData ELSE Object_Storage.ValueData END :: TVarChar AS StorageName
           , Object_PartionModel.Id             AS PartionModelId
           , Object_PartionModel.ValueData      AS PartionModelName

           , tmpMIContainer.Price               AS Price

           , tmpRemains.Amount :: TFloat        AS AmountRemains

           , tmpReserv.AmountSecond :: TFloat AS Amount_child_sec --итого резерв для заявок
           , (COALESCE (tmpReserv.AmountSecond,0) - COALESCE (tmpMI_Goods.Amount,0))  ::TFloat AS Amount_diff

           , tmpMI_Goods.isErased               AS isErased
           , COALESCE (tmpGoodsByGoodsKindSub.isPeresort, False) AS isPeresort
       FROM tmpMI_Goods
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI_Goods.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_Goods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = tmpMI_Goods.GoodsKindId_Complete
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMI_Goods.PartionGoodsId
            LEFT JOIN ObjectDate AS ObjectDate_Value
                                 ON ObjectDate_Value.ObjectId = Object_PartionGoods.Id
                                AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = tmpMI_Goods.MovementItemId
            LEFT JOIN Object AS Object_Unit_partion ON Object_Unit_partion.Id = tmpMIContainer.UnitId
            LEFT JOIN Object AS Object_Storage      ON Object_Storage.Id      = COALESCE (tmpMI_Goods.StorageId, tmpMIContainer.StorageId)
            LEFT JOIN Object AS Object_PartionModel ON Object_PartionModel.Id = COALESCE (tmpMI_Goods.PartionModelId, tmpMIContainer.PartionModelId)
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmpMI_Goods.AssetId
            LEFT JOIN Object AS Object_Asset_two ON Object_Asset_two.Id = tmpMI_Goods.AssetId_two

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
                                 ON ObjectDate_In.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectDate_In.DescId = zc_ObjectDate_Goods_In()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_PartnerIn
                                 ON ObjectLink_Goods_PartnerIn.ObjectId = tmpMI_Goods.GoodsId
                                AND ObjectLink_Goods_PartnerIn.DescId = zc_ObjectLink_Goods_PartnerIn()
            LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = ObjectLink_Goods_PartnerIn.ChildObjectId

            LEFT JOIN tmpRemains ON tmpRemains.MovementItemId = tmpMI_Goods.MovementItemId
                                AND COALESCE (tmpRemains.PartionGoodsId,0) = COALESCE (tmpMIContainer.PartionGoodsId, Object_PartionGoods.Id, 0)

            LEFT JOIN tmpOrderExternalChild AS tmpReserv
                                            ON tmpReserv.GoodsId = tmpMI_Goods.GoodsId
                                           AND tmpReserv.GoodsKindId = COALESCE (tmpMI_Goods.GoodsKindId, 0)

            LEFT JOIN tmpGoodsByGoodsKindSub ON tmpGoodsByGoodsKindSub.GoodsId = tmpMI_Goods.GoodsId
                                            AND tmpGoodsByGoodsKindSub.GoodsKindId = tmpMI_Goods.GoodsKindId
            ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Send (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.05.23         *
 18.10.22         * AssetId_two
 03.10.22         * asset
 18.07.22         *
 08.02.22         *
 28.01.21         * PartionGoodsId
 19.10.18         *
 02.08.17         * add GoodsKindId_Complete
 15.10.14         * add Price, Storage_Partion
 04.08.14                                        * add Object_InfoMoney_View
 04.08.14         * add zc_MILinkObject_Unit
                        zc_MILinkObject_Storage
                        zc_MILinkObject_PartionGoods
 07.12.13                                        * rename UserRole_View -> ObjectLink_UserRole_View
 09.11.13                                        * add FuelName and tmpUserTransport
 30.10.13                       *            FULL JOIN
 29.10.13                       *            add GoodsKindId
 22.07.13         * add Count
 18.07.13         * add Object_Asset
 12.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_Send (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
