-- Function: gpSelect_MI_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF REFCURSOR
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;

   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;

   DECLARE vbDayCount Integer;
   DECLARE vbMonth Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


    -- !!!Нет прав!!! - Ограничение - нет доступа к Заказ производство цех
    IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11190562)
    THEN
        RAISE EXCEPTION 'Ошибка.Нет прав.';
    END IF;


     -- определяется
     SELECT Movement.OperDate
          , 1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData)))
          , EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
            INTO vbOperDate, vbDayCount, vbMonth, vbFromId, vbToId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.Id = inMovementId;


     --
     CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, GoodsId_detail Integer, GoodsKindId_detail Integer, GoodsId Integer, GoodsId_basis Integer, GoodsKindId_complete Integer
                                    , ReceiptId Integer, ReceiptId_basis Integer
                                    , Amount TFloat, AmountSecond TFloat, AmountRemains TFloat, AmountPartnerPrior TFloat, AmountPartner TFloat
                                    , AmountForecast TFloat, AmountForecastOrder TFloat, AmountOrderPromo TFloat, AmountSalePromo TFloat, AmountProductionOut TFloat
                                    , KoeffLoss TFloat, TaxLoss TFloat, CuterCount TFloat, CuterCountSecond TFloat, Koeff TFloat, TermProduction TFloat, NormInDays TFloat, StartProductionInDays TFloat
                                    , isErased Boolean) ON COMMIT DROP;
     INSERT INTO _tmpMI_master (MovementItemId, GoodsId_detail, GoodsKindId_detail, GoodsId, GoodsId_basis, GoodsKindId_complete
                              , ReceiptId , ReceiptId_basis
                              , Amount, AmountSecond, AmountRemains, AmountPartnerPrior, AmountPartner
                              , AmountForecast, AmountForecastOrder, AmountOrderPromo, AmountSalePromo, AmountProductionOut
                              , KoeffLoss, TaxLoss, CuterCount, CuterCountSecond, Koeff, TermProduction, NormInDays, StartProductionInDays
                              , isErased)
                              SELECT MovementItem.Id                                       AS MovementItemId
                                   , CASE WHEN inShowAll = TRUE THEN MovementItem.ObjectId                         ELSE 0 END AS GoodsId_detail
                                   , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ELSE 0 END AS GoodsKindId_detail

                                   , COALESCE (MILinkObject_Goods.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN MovementItem.ObjectId
                                                    ELSE 0
                                               END
                                              )AS GoodsId
                                   , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)        AS GoodsId_basis
                                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN zc_GoodsKind_Basis()
                                                    ELSE 0
                                               END
                                              ) AS GoodsKindId_complete
                                   , CASE WHEN inShowAll = TRUE THEN COALESCE (MILinkObject_Receipt.ObjectId, 0) ELSE 0 END AS ReceiptId
                                   , COALESCE (MILinkObject_ReceiptBasis.ObjectId, 0)      AS ReceiptId_basis

                                   , MovementItem.Amount                                   AS Amount
                                   , COALESCE (MIFloat_AmountSecond.ValueData, 0)          AS AmountSecond

                                   , COALESCE (MIFloat_AmountRemains.ValueData, 0)         AS AmountRemains
                                   , COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0)    AS AmountPartnerPrior
                                   , COALESCE (MIFloat_AmountPartner.ValueData, 0)         AS AmountPartner
                                   , COALESCE (MIFloat_AmountForecast.ValueData, 0)        AS AmountForecast
                                   , COALESCE (MIFloat_AmountForecastOrder.ValueData, 0)   AS AmountForecastOrder
                                     -- !!!не ошибка, здесь заявки Акции!!!
                                   , COALESCE (MIFloat_Promo1.ValueData, 0)                AS AmountOrderPromo
                                     -- !!!не ошибка, здесь продажи Акции!!!
                                   , COALESCE (MIFloat_Promo2.ValueData, 0)                AS AmountSalePromo
                                     -- !!!не ошибка, здесь добавленный Расход на производство в статистику Продаж!!!
                                   , COALESCE (MIFloat_Plan1.ValueData, 0)                 AS AmountProductionOut
                                     --
                                   , CASE WHEN ObjectFloat_TaxLoss.ValueData > 0 THEN 1 - ObjectFloat_TaxLoss.ValueData / 100 ELSE 1 END AS KoeffLoss
                                   , CASE WHEN ObjectFloat_TaxLoss.ValueData > 0 THEN ObjectFloat_TaxLoss.ValueData           ELSE 0 END AS TaxLoss
                                   , COALESCE (MIFloat_CuterCount.ValueData, 0)            AS CuterCount
                                   , COALESCE (MIFloat_CuterCountSecond.ValueData, 0)      AS CuterCountSecond
                                   , COALESCE (MIFloat_Koeff.ValueData, 0)                 AS Koeff
                                   , COALESCE (MIFloat_TermProduction.ValueData, 0)        AS TermProduction
                                   , COALESCE (MIFloat_NormInDays.ValueData, 0)            AS NormInDays
                                   , COALESCE (MIFloat_StartProductionInDays.ValueData, 0) AS StartProductionInDays
                                   , MovementItem.isErased                                 AS isErased

                              FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                   INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = tmpIsErased.isErased
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
--                                                       AND  = Object_InfoMoney_View.InfoMoneyId

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                               ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                                               ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                                               ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                                               ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecastOrder.DescId = zc_MIFloat_AmountForecastOrder()

                                   -- !!!не ошибка, здесь заявки Акции!!!
                                   LEFT JOIN MovementItemFloat AS MIFloat_Promo1
                                                               ON MIFloat_Promo1.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Promo1.DescId = zc_MIFloat_Promo1()
                                   -- !!!не ошибка, здесь продажи Акции!!!
                                   LEFT JOIN MovementItemFloat AS MIFloat_Promo2
                                                               ON MIFloat_Promo2.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Promo2.DescId = zc_MIFloat_Promo2()
                                   -- !!!не ошибка, здесь добавленный Расход на производство в статистику Продаж!!!
                                   LEFT JOIN MovementItemFloat AS MIFloat_Plan1
                                                               ON MIFloat_Plan1.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Plan1.DescId = zc_MIFloat_Plan1()


                                   LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                               ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                                              AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                   LEFT JOIN MovementItemFloat AS MIFloat_CuterCountSecond
                                                               ON MIFloat_CuterCountSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_CuterCountSecond.DescId = zc_MIFloat_CuterCountSecond()
                                   LEFT JOIN MovementItemFloat AS MIFloat_Koeff
                                                               ON MIFloat_Koeff.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Koeff.DescId = zc_MIFloat_Koeff()
                                   LEFT JOIN MovementItemFloat AS MIFloat_TermProduction
                                                               ON MIFloat_TermProduction.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TermProduction.DescId = zc_MIFloat_TermProduction()
                                   LEFT JOIN MovementItemFloat AS MIFloat_NormInDays
                                                               ON MIFloat_NormInDays.MovementItemId = MovementItem.Id
                                                              AND MIFloat_NormInDays.DescId = zc_MIFloat_NormInDays()
                                   LEFT JOIN MovementItemFloat AS MIFloat_StartProductionInDays
                                                               ON MIFloat_StartProductionInDays.MovementItemId = MovementItem.Id
                                                              AND MIFloat_StartProductionInDays.DescId = zc_MIFloat_StartProductionInDays()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                                    ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsBasis.DescId = zc_MILinkObject_GoodsBasis()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                    ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                                    ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptBasis
                                                                    ON MILinkObject_ReceiptBasis.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                                                         ON ObjectFloat_TaxLoss.ObjectId = MILinkObject_Receipt.ObjectId
                                                        AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()
                             ;

     --
     CREATE TEMP TABLE _tmpMI_child (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, PartionGoodsDate TDateTime, ContainerId Integer, Amount TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpMI_child (MovementItemId, GoodsId, GoodsKindId, GoodsKindId_complete, PartionGoodsDate, ContainerId, Amount)
             SELECT MovementItem.Id                                       AS MovementItemId
                  , MovementItem.ObjectId                                 AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                  , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete
                  , MIDate_PartionGoods.ValueData                         AS PartionGoodsDate
                  , MIFloat_ContainerId.ValueData                         AS ContainerId
                  , MovementItem.Amount                                   AS Amount
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                              ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                             AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                   ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Child()
               AND MovementItem.isErased   = FALSE;

       --
       OPEN Cursor1 FOR
        WITH tmpMI_master_find_mi_ord AS (SELECT _tmpMI_master.MovementItemId
                                               , ROW_NUMBER() OVER (PARTITION BY _tmpMI_master.GoodsId_basis, _tmpMI_master.GoodsKindId_complete
                                                                    ORDER BY CASE WHEN _tmpMI_master.GoodsId_basis = _tmpMI_master.GoodsId
                                                                                       THEN 0
                                                                                  ELSE 1
                                                                             END ASC
                                                                           , _tmpMI_master.MovementItemId DESC
                                                                   ) AS Ord
                                          FROM _tmpMI_master
                                          WHERE _tmpMI_master.isErased = FALSE
                                         )
            , tmpMI_master_find_mi AS (SELECT tmpMI_master_find_mi_ord.MovementItemId
                                       FROM tmpMI_master_find_mi_ord
                                       WHERE tmpMI_master_find_mi_ord.Ord = 1
                                      )
           , tmpMI_master_find_all AS (SELECT tmpMI_master_find_mi.MovementItemId, _tmpMI_master.GoodsId_basis, _tmpMI_master.GoodsKindId_complete
                                       FROM tmpMI_master_find_mi
                                            INNER JOIN _tmpMI_master ON _tmpMI_master.MovementItemId = tmpMI_master_find_mi.MovementItemId
                                      )
                 , tmpGoods_params AS (SELECT _tmpMI_master.GoodsId_basis, MIN (_tmpMI_master.TermProduction) AS TermProduction, MAX (_tmpMI_master.KoeffLoss) AS KoeffLoss
                                       FROM _tmpMI_master
                                       GROUP BY _tmpMI_master.GoodsId_basis
                                      )
                  , tmpMI_find AS (SELECT tmpMI_master_find_all.MovementItemId
                                        , COALESCE (tmpMI_master_find_all.GoodsId_basis,        _tmpMI_child.GoodsId)              AS GoodsId_basis
                                        , COALESCE (tmpMI_master_find_all.GoodsKindId_complete, _tmpMI_child.GoodsKindId_complete) AS GoodsKindId_complete
                                   FROM tmpMI_master_find_all
                                        FULL JOIN _tmpMI_child ON _tmpMI_child.GoodsId              = tmpMI_master_find_all.GoodsId_basis
                                                              AND _tmpMI_child.GoodsKindId_complete = tmpMI_master_find_all.GoodsKindId_complete
                                   GROUP BY tmpMI_master_find_all.MovementItemId
                                          , COALESCE (tmpMI_master_find_all.GoodsId_basis, _tmpMI_child.GoodsId)
                                          , COALESCE (tmpMI_master_find_all.GoodsKindId_complete, _tmpMI_child.GoodsKindId_complete)
                                  )
           , tmpMIPartion_master AS (SELECT tmpMI_find.MovementItemId
                                          , tmpMI_find.GoodsId_basis
                                          , tmpMI_find.GoodsKindId_complete
                                          , SUM (CASE WHEN _tmpMI_child.PartionGoodsDate <= (vbOperDate :: Date - COALESCE (tmpGoods_params.TermProduction, 0) :: Integer)
                                                           THEN _tmpMI_child.Amount * COALESCE (tmpGoods_params.KoeffLoss, 1)
                                                      ELSE 0
                                                 END) AS AmountProduction_old
                                          , SUM (CASE WHEN _tmpMI_child.PartionGoodsDate > (vbOperDate :: Date - COALESCE (tmpGoods_params.TermProduction, 0) :: Integer)
                                                           THEN _tmpMI_child.Amount * COALESCE (tmpGoods_params.KoeffLoss, 1)
                                                      ELSE 0
                                                 END) AS AmountProduction_next
                                          , MIN (CASE WHEN _tmpMI_child.PartionGoodsDate <= (vbOperDate :: Date - COALESCE (tmpGoods_params.TermProduction, 0) :: Integer)
                                                       AND _tmpMI_child.Amount > 0
                                                           THEN _tmpMI_child.PartionGoodsDate
                                                      ELSE zc_DateEnd()
                                                 END) AS StartDate_old
                                          , MAX (CASE WHEN _tmpMI_child.PartionGoodsDate <= (vbOperDate :: Date - COALESCE (tmpGoods_params.TermProduction, 0) :: Integer)
                                                       AND _tmpMI_child.Amount > 0
                                                           THEN _tmpMI_child.PartionGoodsDate
                                                      ELSE zc_DateStart()
                                                 END) AS EndDate_old
                                          , MIN (CASE WHEN _tmpMI_child.PartionGoodsDate > (vbOperDate :: Date - COALESCE (tmpGoods_params.TermProduction, 0) :: Integer)
                                                       AND _tmpMI_child.Amount > 0
                                                           THEN _tmpMI_child.PartionGoodsDate
                                                      ELSE zc_DateEnd()
                                                 END) AS StartDate_next
                                          , MAX (CASE WHEN _tmpMI_child.PartionGoodsDate > (vbOperDate :: Date - COALESCE (tmpGoods_params.TermProduction, 0) :: Integer)
                                                       AND _tmpMI_child.Amount > 0
                                                           THEN _tmpMI_child.PartionGoodsDate
                                                      ELSE zc_DateStart()
                                                 END) AS EndDate_next
                                     FROM tmpMI_find
                                          INNER JOIN _tmpMI_child ON _tmpMI_child.GoodsId              = tmpMI_find.GoodsId_basis
                                                                 AND _tmpMI_child.GoodsKindId_complete = tmpMI_find.GoodsKindId_complete
                                          LEFT JOIN tmpGoods_params ON tmpGoods_params.GoodsId_basis = tmpMI_find.GoodsId_basis
                                     GROUP BY tmpMI_find.MovementItemId
                                            , tmpMI_find.GoodsId_basis
                                            , tmpMI_find.GoodsKindId_complete
                                    )

          , _tmpMI_child_group AS (SELECT _tmpMI_child.ContainerId, MAX (_tmpMI_child.GoodsKindId_complete) AS GoodsKindId_complete FROM _tmpMI_child GROUP BY _tmpMI_child.ContainerId)
          , tmpUnitFrom AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (vbFromId) AS lfSelect_Object_Unit_byGroup)
          , tmpUnitTo AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (vbToId) AS lfSelect_Object_Unit_byGroup)
          , tmpMI_Send AS (SELECT tmpMI.GoodsId                           AS GoodsId
                                , COALESCE (CLO_GoodsKindId.ObjectId, 0)  AS GoodsKindId
                                , SUM (tmpMI.Amount)                      AS Amount
                           FROM (SELECT MIContainer.ObjectId_Analyzer AS GoodsId
                                      , MIContainer.ContainerId
                                      , SUM (MIContainer.Amount) AS Amount
                                 FROM MovementItemContainer AS MIContainer
                                      INNER JOIN tmpUnitFrom ON tmpUnitFrom.UnitId = MIContainer.WhereObjectId_Analyzer
                                      INNER JOIN tmpUnitTo   ON tmpUnitTo.UnitId   = MIContainer.ObjectExtId_Analyzer -- AnalyzerId
                                 WHERE MIContainer.OperDate   = (vbOperDate + INTERVAL '1 DAY')
                                   AND MIContainer.DescId     = zc_MIContainer_Count()
                                   AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                   AND MIContainer.isActive = TRUE
                                 GROUP BY MIContainer.ObjectId_Analyzer
                                        , MIContainer.ContainerId
                                ) AS tmpMI
                                LEFT JOIN ContainerLinkObject AS CLO_GoodsKindId
                                                              ON CLO_GoodsKindId.ContainerId = tmpMI.ContainerId
                                                             AND CLO_GoodsKindId.DescId = zc_ContainerLinkObject_GoodsKind()
                            GROUP BY tmpMI.GoodsId
                                   , CLO_GoodsKindId.ObjectId
                          )
       SELECT
             tmpMI.MovementItemId :: Integer     AS Id
           , vbOperDate           :: TDateTime   AS OperDate
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , CASE WHEN inShowAll = TRUE THEN 0 ELSE Object_Goods_basis.Id END AS GoodsId_basis
           , Object_Goods_basis.ObjectCode               AS GoodsCode_basis
           , Object_Goods_basis.ValueData                AS GoodsName_basis
           , Object_Goods_detail.ObjectCode              AS GoodsCode_detail
           , Object_Goods_detail.ValueData               AS GoodsName_detail
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId <> tmpMI.GoodsId_basis THEN TRUE ELSE FALSE END AS isCheck_basis

           , tmpMI.Amount           :: TFloat AS Amount           -- Заказ на пр-во
           , tmpMI.AmountSecond     :: TFloat AS AmountSecond     -- Дозаказ на пр-во
           , tmpMI.CuterCount       :: TFloat AS CuterCount       -- Заказ на пр-во кутеров
           , tmpMI.CuterCountSecond :: TFloat AS CuterCountSecond -- Заказ на пр-во кутеров

             -- Приход с пр. шт. + вес
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN tmpMI_Send.Amount ELSE 0 END :: TFloat AS AmountSend_sh
           , (tmpMI_Send.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) :: TFloat AS AmountSend_Weight

             -- Прогн. ост.
           , CAST (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner
                 + tmpMI.AmountProduction_old  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
             AS NUMERIC (16, 1)) :: TFloat AS AmountRemains_calc
             -- *Прогн. ост. на срок
           , CAST (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner
                 + tmpMI.AmountProduction_old   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                 + tmpMI.AmountProduction_next  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
             AS NUMERIC (16, 1)) :: TFloat AS AmountRemainsTerm_calc

           , CAST (tmpMI.NormInDays     * tmpMI.CountForecast      * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognoz_calc          -- Норма запас (по пр.)
           , CAST (tmpMI.NormInDays     * tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozOrder_calc     -- Норма запас (по зв.)
           , CAST (tmpMI.TermProduction * tmpMI.CountForecast      * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozTerm_calc      -- *Норма зап. на срок (по пр.)
           , CAST (tmpMI.TermProduction * tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozOrderTerm_calc -- *Норма зап. на срок (по зв.)

           , CAST ((tmpMI.NormInDays + tmpMI.TermProduction) * tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountReserve_calc     -- Норма запаса пр-во+склад = AmountPrognozOrder_calc + AmountPrognozOrderTerm_calc

            -- Прогноз Заказ кг = "Норма запаса пр-во+склад" - AmountRemainsTerm_calc
           , CAST (( (tmpMI.NormInDays + tmpMI.TermProduction) * tmpMI.CountForecastOrder * tmpMI.Koeff)
                   - (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner
                    + tmpMI.AmountProduction_old  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                    + tmpMI.AmountProduction_next * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                     ) AS NUMERIC (16, 1)) :: TFloat AS AmountReserveOrderKg_calc

            -- Прогноз заказ (куттер) = "Прогноз Заказ кг" / zc_ObjectFloat_Receipt_TaxExit -
           , CASE WHEN COALESCE (ObjectFloat_TaxExit.ValueData,0) <> 0
                  THEN CAST (( ((tmpMI.NormInDays + tmpMI.TermProduction) * tmpMI.CountForecastOrder * tmpMI.Koeff)
                              - (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner
                               + tmpMI.AmountProduction_old  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                               + tmpMI.AmountProduction_next * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                )
                             ) / ObjectFloat_TaxExit.ValueData
                            AS NUMERIC (16, 1))
                  ELSE 0
             END                                                   :: TFloat AS AmountReserveOrderCuter_calc

           , CAST (tmpMI.AmountProduction_old  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1)) :: TFloat AS AmountProduction_old  -- Произв. сегодня
           , CAST (tmpMI.AmountProduction_next * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1)) :: TFloat AS AmountProduction_next -- Произв. далее
           , CASE WHEN tmpMI.StartDate_old  = zc_DateEnd()                                                THEN NULL ELSE tmpMI.StartDate_old  END :: TDateTime AS StartDate_old  -- Партия-1 сегодня
           , CASE WHEN tmpMI.EndDate_old    = zc_DateStart() OR tmpMI.EndDate_old = tmpMI.StartDate_old   THEN NULL ELSE tmpMI.EndDate_old    END :: TDateTime AS EndDate_old    -- Партия-2 сегодня
           , CASE WHEN tmpMI.StartDate_next = zc_DateEnd()                                                THEN NULL ELSE tmpMI.StartDate_next END :: TDateTime AS StartDate_next -- Партия-1 далее
           , CASE WHEN tmpMI.EndDate_next   = zc_DateStart() OR tmpMI.EndDate_next = tmpMI.StartDate_next THEN NULL ELSE tmpMI.EndDate_next   END :: TDateTime AS EndDate_next   -- Партия-2 далее

            -- Ост. начальн. ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.AmountRemains / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountRemains_sh --
           -- Заказ на пр-во шт
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.Amount / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS Amount_sh
           -- Дозаказ на пр-во шт
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.AmountSecond / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountSecond_sh
           -- сегодня заявка ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.AmountPartner / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountPartner_sh   --
           -- неотгуж. заявка ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.AmountPartnerPrior / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountPartnerPrior_sh  --
             -- Прогноз по прод. ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.AmountForecast / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountForecast_sh
           -- Прогноз по заяв. ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.AmountForecastOrder / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountForecastOrder_sh
           -- Норма запас (по пр.) шт
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.NormInDays * tmpMI.CountForecast * tmpMI.Koeff / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountPrognoz_calc_sh --
           -- Норма запас (по зв.) шт
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.NormInDays * tmpMI.CountForecastOrder* tmpMI.Koeff / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountPrognozOrder_calc_sh --
           -- *Норма зап. на срок (по пр.) ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.TermProduction * tmpMI.CountForecast * tmpMI.Koeff / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountPrognozTerm_calc_sh  --
           -- *Норма зап. на срок (по зв.) ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.TermProduction * tmpMI.CountForecastOrder * tmpMI.Koeff / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountPrognozOrderTerm_calc_sh --
           -- Норма запаса пр-во+склад = AmountPrognozOrder_calc + AmountPrognozOrderTerm_calc ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST ((tmpMI.NormInDays + tmpMI.TermProduction) * tmpMI.CountForecastOrder * tmpMI.Koeff / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountReserve_calc_sh
           -- Прогноз Заказ кг = "Норма запаса пр-во+склад" - AmountRemainsTerm_calc ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (( ((tmpMI.NormInDays + tmpMI.TermProduction) * tmpMI.CountForecastOrder * tmpMI.Koeff)
                                                                                                                                - (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner
                                                                                                                                + tmpMI.AmountProduction_old  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                                                                                + tmpMI.AmountProduction_next * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                                                                                 )) / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS AmountReserveOrderKg_calc_sh
           -- Норм 1д (по пр.) без К ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.CountForecast / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS CountForecast_sh
           -- Норм 1д (по зв.) без К
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.CountForecastOrder / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS CountForecastOrder_sh
           -- Норм 1д (по пр.)
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.CountForecast * tmpMI.Koeff / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS CountForecastK_sh
           -- Норм 1д (по зв.)
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.CountForecastOrder * tmpMI.Koeff / ObjectFloat_Weight.ValueData AS NUMERIC (16, 0)) ELSE 0 END :: TFloat AS CountForecastOrderK_sh

            -- Произв. сегодня ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.AmountProduction_old  AS NUMERIC (16, 1)) ELSE 0 END :: TFloat AS AmountProduction_old_sh    --
           -- Произв. далее ШТ
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST (tmpMI.AmountProduction_next AS NUMERIC (16, 1)) ELSE 0 END :: TFloat AS AmountProduction_next_sh   --
             -- *Прогн. ост. на срок
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST ((tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner
                                                                                                                              + tmpMI.AmountProduction_old   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                                                                              + tmpMI.AmountProduction_next  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                                                                               ) / ObjectFloat_Weight.ValueData AS NUMERIC (16, 1))  ELSE 0 END  :: TFloat AS AmountRemainsTerm_calc_sh
             -- Прогн. ост.
           , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND ObjectFloat_Weight.ValueData > 0 THEN CAST ((tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner
                                                                                                                              + tmpMI.AmountProduction_old  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                                                                              )  / ObjectFloat_Weight.ValueData
                                                                                                                          AS NUMERIC (16, 1))  ELSE 0 END  :: TFloat AS AmountRemains_calc_sh

              -- Ост. начальн.
           , CASE WHEN ABS (tmpMI.AmountRemains) < 1 THEN tmpMI.AmountRemains ELSE CAST (tmpMI.AmountRemains AS NUMERIC (16, 1)) END :: TFloat AS AmountRemains
             -- неотгуж. заявка
           , CAST (tmpMI.AmountPartnerPrior  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
             -- сегодня заявка
           , CAST (tmpMI.AmountPartner       AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
             -- Прогноз по прод.
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1 THEN tmpMI.AmountForecast ELSE CAST (tmpMI.AmountForecast AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast
             -- Прогноз по заяв.
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1 THEN tmpMI.AmountForecastOrder ELSE CAST (tmpMI.AmountForecastOrder AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder

             -- заявки  Акции
           , CASE WHEN ABS (tmpMI.AmountOrderPromo) < 1 THEN tmpMI.AmountOrderPromo ELSE CAST (tmpMI.AmountOrderPromo AS NUMERIC (16, 1)) END :: TFloat AS AmountOrderPromo
             -- продажи  Акции
           , CASE WHEN ABS (tmpMI.AmountSalePromo) < 1  THEN tmpMI.AmountSalePromo  ELSE CAST (tmpMI.AmountSalePromo AS NUMERIC (16, 1))  END :: TFloat AS AmountSalePromo
             -- добавленный Расход на производство в статистику Продаж
           , CASE WHEN ABS (tmpMI.AmountProductionOut) < 1 THEN tmpMI.AmountProductionOut ELSE CAST (tmpMI.AmountProductionOut AS NUMERIC (16, 1)) END :: TFloat AS AmountProductionOut

             -- Норм 1д (по пр. Акций) без К
           , CAST (CASE WHEN vbDayCount <> 0 THEN tmpMI.AmountOrderPromo / vbDayCount ELSE 0 END AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrderPromo
             -- Норм 1д (по зв. Акций) без К
           , CAST (CASE WHEN vbDayCount <> 0 THEN tmpMI.AmountSalePromo  / vbDayCount ELSE 0 END AS NUMERIC (16, 1)) :: TFloat AS CountForecastPromo

             -- Норм 1д (по пр. МИНУС Акции)
           , CAST (tmpMI.Koeff * (tmpMI.CountForecast      - CASE WHEN vbDayCount <> 0 THEN COALESCE (tmpMI.AmountSalePromo, 0)  / vbDayCount ELSE 0 END) AS NUMERIC (16, 1)) :: TFloat AS CountForecast_minus
             -- Норм 1д (по зв. МИНУС Акции)
           , CAST (tmpMI.Koeff * (tmpMI.CountForecastOrder - CASE WHEN vbDayCount <> 0 THEN COALESCE (tmpMI.AmountOrderPromo, 0) / vbDayCount ELSE 0 END) AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder_minus


           , CAST (tmpMI.CountForecast AS NUMERIC (16, 1))      :: TFloat AS CountForecast                     -- Норм 1д (по пр.) без К
           , CAST (tmpMI.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder                -- Норм 1д (по зв.) без К
           , CAST (tmpMI.CountForecast * tmpMI.Koeff AS NUMERIC (16, 1))      :: TFloat AS CountForecastK      -- Норм 1д (по пр.)
           , CAST (tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrderK -- Норм 1д (по зв.)

             -- Ост. в днях (по зв.)
           , CAST (CASE WHEN tmpMI.CountForecast > 0 AND tmpMI.Koeff > 0
                             THEN tmpMI.AmountRemains / (tmpMI.CountForecast * tmpMI.Koeff)
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast
             -- Ост. в днях (по пр.)
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0 AND tmpMI.Koeff > 0
                             THEN tmpMI.AmountRemains / (tmpMI.CountForecastOrder * tmpMI.Koeff)
                         ELSE 0
                   END
             AS NUMERIC (16, 1))         :: TFloat AS DayCountForecastOrder

           , tmpMI.Koeff                 :: TFloat AS Koeff                 -- Коэфф.
           , tmpMI.TermProduction        :: TFloat AS TermProduction        -- Срок произв. в дн.
           , tmpMI.NormInDays            :: TFloat AS NormInDays            -- Норма запас в дн.
           , tmpMI.StartProductionInDays :: TFloat AS StartProductionInDays -- Нач. произв. в дн.

           , CASE WHEN inShowAll = TRUE THEN 0 ELSE Object_GoodsKind.Id END AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKind_detail.ValueData   AS GoodsKindName_detail
           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_basis.ValueData      AS MeasureName_basis
           , Object_Measure_detail.ValueData     AS MeasureName_detail

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis
           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName

           , CASE WHEN tmpMI.AmountRemains <= 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_remains

           , CASE WHEN tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner
                     + tmpMI.AmountProduction_old * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                       <= 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_remains_calc

           , CASE WHEN tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner
                     + tmpMI.AmountProduction_old  * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                     + tmpMI.AmountProduction_next * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                       <= 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_remainsTerm_calc

           , zc_Color_Blue() AS Color_send

           , CASE WHEN tmpMI.AmountProduction_old < 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_production_old

           , CASE WHEN tmpMI.AmountProduction_next < 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_production_next


           , zc_Color_Aqua()   :: Integer AS ColorB_const
           , zc_Color_Cyan()   :: Integer AS ColorB_DayCountForecast
           , zc_Color_GreenL() :: Integer AS ColorB_AmountPartner
           , zc_Color_Yelow()  :: Integer AS ColorB_AmountPrognoz

           , tmpMI.isErased

       FROM (SELECT CASE WHEN inShowAll = TRUE THEN tmpMI_master.MovementItemId ELSE 0 END AS MovementItemId
                  , tmpMI_master.GoodsId_detail
                  , tmpMI_master.GoodsKindId_detail
                  , SUM (tmpMI_master.Amount)           AS Amount
                  , SUM (tmpMI_master.AmountSecond)     AS AmountSecond
                  , SUM (tmpMI_master.CuterCount)       AS CuterCount
                  , SUM (tmpMI_master.CuterCountSecond) AS CuterCountSecond

                  , SUM (tmpMI_master.AmountRemains)       AS AmountRemains
                  , SUM (tmpMI_master.AmountPartnerPrior)  AS AmountPartnerPrior
                  , SUM (tmpMI_master.AmountPartner)       AS AmountPartner
                  , SUM (tmpMI_master.AmountForecast)      AS AmountForecast
                  , SUM (tmpMI_master.AmountForecastOrder) AS AmountForecastOrder

                  , SUM (tmpMI_master.AmountOrderPromo)    AS AmountOrderPromo
                  , SUM (tmpMI_master.AmountSalePromo)     AS AmountSalePromo
                  , SUM (tmpMI_master.AmountProductionOut) AS AmountProductionOut

                  , CASE WHEN vbDayCount <> 0 THEN SUM (tmpMI_master.AmountForecast)      / vbDayCount ELSE 0 END AS CountForecast
                  , CASE WHEN vbDayCount <> 0 THEN SUM (tmpMI_master.AmountForecastOrder) / vbDayCount ELSE 0 END AS CountForecastOrder

                  , tmpMI_master.Koeff
                  , tmpMI_master.TermProduction
                  , tmpMI_master.NormInDays
                  , tmpMI_master.StartProductionInDays
                  , tmpMI_master.ReceiptId
                  , tmpMI_master.ReceiptId_basis
                  , COALESCE (tmpMI_master.GoodsId, tmpMIPartion_master.GoodsId_basis) AS GoodsId
                  , COALESCE (tmpMI_master.GoodsId_basis, tmpMIPartion_master.GoodsId_basis) AS GoodsId_basis
                  , COALESCE (tmpMI_master.GoodsKindId_complete, tmpMIPartion_master.GoodsKindId_complete) AS GoodsKindId_complete

                  , MIN (COALESCE (tmpMIPartion_master.StartDate_old,  zc_DateEnd()))   AS StartDate_old
                  , MAX (COALESCE (tmpMIPartion_master.EndDate_old,    zc_DateStart())) AS EndDate_old
                  , MIN (COALESCE (tmpMIPartion_master.StartDate_next, zc_DateEnd()))   AS StartDate_next
                  , MAX (COALESCE (tmpMIPartion_master.EndDate_next,   zc_DateStart())) AS EndDate_next
                  , SUM (COALESCE (tmpMIPartion_master.AmountProduction_old, 0))  AS AmountProduction_old
                  , SUM (COALESCE (tmpMIPartion_master.AmountProduction_next, 0)) AS AmountProduction_next

                  , tmpMI_master.isErased
             FROM _tmpMI_master AS tmpMI_master
                  FULL JOIN tmpMIPartion_master ON tmpMIPartion_master.MovementItemId = tmpMI_master.MovementItemId  ---tmpMIPartion_master.GoodsId_basis = tmpMI_master.GoodsId --
             GROUP BY CASE WHEN inShowAll = TRUE THEN tmpMI_master.MovementItemId ELSE 0 END
                  , tmpMI_master.GoodsId_detail
                  , tmpMI_master.GoodsKindId_detail

                  , tmpMI_master.Koeff
                  , tmpMI_master.TermProduction
                  , tmpMI_master.NormInDays
                  , tmpMI_master.StartProductionInDays
                  , tmpMI_master.ReceiptId
                  , tmpMI_master.ReceiptId_basis
                  , COALESCE (tmpMI_master.GoodsId, tmpMIPartion_master.GoodsId_basis)
                  , COALESCE (tmpMI_master.GoodsId_basis, tmpMIPartion_master.GoodsId_basis)
                  , COALESCE (tmpMI_master.GoodsKindId_complete, tmpMIPartion_master.GoodsKindId_complete)

                  , tmpMI_master.isErased
            ) AS tmpMI

            FULL JOIN tmpMI_Send ON tmpMI_Send.GoodsId = tmpMI.GoodsId
                                AND tmpMI_Send.GoodsKindId  = tmpMI.GoodsKindId_complete
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = COALESCE (tmpMI_Send.GoodsId, tmpMI.GoodsId)
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN Object AS Object_Goods_detail ON Object_Goods_detail.Id = tmpMI.GoodsId_detail
            LEFT JOIN Object AS Object_GoodsKind_detail ON Object_GoodsKind_detail.Id = tmpMI.GoodsKindId_detail
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_detail
                                 ON ObjectLink_Goods_Measure_detail.ObjectId = Object_Goods_detail.Id
                                AND ObjectLink_Goods_Measure_detail.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_detail ON Object_Measure_detail.Id = ObjectLink_Goods_Measure_detail.ChildObjectId

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                  ON ObjectFloat_TaxExit.ObjectId = tmpMI.ReceiptId_basis
                                 AND ObjectFloat_TaxExit.DescId   = zc_ObjectFloat_Receipt_TaxExit()

            LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = tmpMI.GoodsId_basis
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpMI.GoodsId, tmpMI_Send.GoodsId)
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (tmpMI.GoodsKindId_complete, tmpMI_Send.GoodsKindId)

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_basis
                                 ON ObjectLink_Goods_Measure_basis.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure_basis.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_basis ON Object_Measure_basis.Id = ObjectLink_Goods_Measure_basis.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods.Id
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderType_Unit.ChildObjectId
          ;

       RETURN NEXT Cursor1;

       OPEN Cursor2 FOR
        WITH tmpGoods_params AS (SELECT _tmpMI_master.GoodsId_basis, MIN (_tmpMI_master.TermProduction) AS TermProduction, MAX (_tmpMI_master.KoeffLoss) AS KoeffLoss, MAX (_tmpMI_master.TaxLoss) AS TaxLoss
                                 FROM _tmpMI_master
                                 GROUP BY _tmpMI_master.GoodsId_basis
                                )
       SELECT
             _tmpMI_child.MovementItemId         AS Id
           , CASE WHEN inShowAll = TRUE THEN 0 ELSE Object_Goods.Id END AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , CASE WHEN inShowAll = TRUE THEN 0 ELSE Object_GoodsKindComplete.Id END AS GoodsKindId_complete
           , Object_GoodsKindComplete.ValueData  AS GoodsKindName_complete
           , Object_Measure.ValueData            AS MeasureName
           , _tmpMI_child.PartionGoodsDate
           , CASE WHEN ABS (_tmpMI_child.Amount) < 1 THEN _tmpMI_child.Amount ELSE CAST (_tmpMI_child.Amount AS NUMERIC (16, 1)) END :: TFloat AS Amount
           , CAST (_tmpMI_child.Amount * tmpGoods_params.KoeffLoss AS NUMERIC (16, 1)) :: TFloat AS Amount_calc
           , CAST (tmpGoods_params.TaxLoss AS NUMERIC (16, 1))                         :: TFloat AS TaxLoss
           , CASE WHEN _tmpMI_child.PartionGoodsDate <= (vbOperDate :: Date - tmpGoods_params.TermProduction :: Integer)
                       THEN CAST (_tmpMI_child.Amount * tmpGoods_params.KoeffLoss AS NUMERIC (16, 1))
                  ELSE 0
             END :: TFloat AS Amount_old
           , CASE WHEN _tmpMI_child.PartionGoodsDate > (vbOperDate :: Date - tmpGoods_params.TermProduction :: Integer)
                       THEN CAST (_tmpMI_child.Amount * tmpGoods_params.KoeffLoss AS NUMERIC (16, 1))
                  ELSE 0
             END :: TFloat AS Amount_next
           , _tmpMI_child.ContainerId
           , (vbOperDate :: Date - tmpGoods_params.TermProduction :: Integer) :: TDateTime AS Date_TermProd
           , FALSE AS isErased
       FROM _tmpMI_child
             LEFT JOIN tmpGoods_params ON tmpGoods_params.GoodsId_basis = _tmpMI_child.GoodsId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpMI_child.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpMI_child.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = _tmpMI_child.GoodsKindId_complete

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = _tmpMI_child.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
       ;
       RETURN NEXT Cursor2;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_OrderInternal (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.03.20         * KoeffLoss
 19.06.15                                        * all
 31.03.15         * add GoodsGroupNameFull
 02.03.14         * add AmountRemains, AmountPartner, AmountForecast, AmountForecastOrder
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternal (inMovementId:= 16907320, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818'); -- FETCH ALL "<unnamed portal 1>";
-- SELECT * FROM gpSelect_MI_OrderInternal (inMovementId:= 16907320, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2'); -- FETCH ALL "<unnamed portal 1>";
