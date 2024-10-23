-- Function: gpSelect_MI_OrderInternalPackRemains()

DROP FUNCTION IF EXISTS lpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpSelect_MI_OrderInternalPackRemains(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inUserId      Integer       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate  TDateTime;
   DECLARE vbDayCount  Integer;
   DECLARE vbWeekCount Integer;
BEGIN
     -- определяется
     SELECT Movement.OperDate
          ,   1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData)))       AS DayCount
          , ((1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData)))) / 7) AS WeekCount
            INTO vbOperDate, vbDayCount, vbWeekCount
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.Id = inMovementId;


     -- Данные - все MI
     CREATE TEMP TABLE _tmpMI_All (MovementItemId Integer, ContainerId Integer
                                    , ReceiptId Integer, GoodsId Integer, GoodsKindId Integer, MeasureId Integer
                                    , GoodsId_complete Integer, GoodsKindId_complete Integer
                                    , ReceiptId_basis Integer, GoodsId_basis Integer
                                    , Amount TFloat, AmountSecond TFloat
                                    , AmountPack TFloat, AmountPackSecond TFloat
                                    , AmountPack_calc TFloat, AmountPackSecond_calc TFloat
                                    , AmountNext TFloat, AmountNextSecond TFloat
                                    , AmountPackNext TFloat, AmountPackNextSecond TFloat
                                    , AmountPackNext_calc TFloat, AmountPackNextSecond_calc TFloat
                                    , AmountRemainsTOTAL TFloat, Remains_CEH TFloat, Remains_CEH_Next TFloat, Remains_CEH_err TFloat, Remains TFloat, Remains_pack TFloat, Remains_err TFloat, RemainsRK TFloat
                                    , AmountPartnerPrior TFloat, AmountPartnerPriorPromo TFloat, AmountPartner TFloat, AmountPartnerNext TFloat, AmountPartnerPromo TFloat, AmountPartnerNextPromo TFloat
                                    , AmountForecast TFloat, AmountForecastPromo TFloat, AmountForecastOrder TFloat, AmountForecastOrderPromo TFloat
                                    , AmountPrIn TFloat, AmountPartnerOld TFloat, AmountPartnerPromoOld TFloat
                                    , CountForecast TFloat, CountForecastOrder TFloat
                                    , Plan1 TFloat, Plan2 TFloat, Plan3 TFloat, Plan4 TFloat, Plan5 TFloat, Plan6 TFloat, Plan7 TFloat
                                    , Promo1 TFloat, Promo2 TFloat, Promo3 TFloat, Promo4 TFloat, Promo5 TFloat, Promo6 TFloat, Promo7 TFloat
                                    , Income_CEH TFloat, Income_PACK_to TFloat, Income_PACK_from TFloat
                                    , TermProduction TFloat, PartionGoods_start TDateTime, PartionDate_pf TDateTime, GoodsKindId_pf Integer, GoodsKindCompleteId_pf Integer, UnitId_pf Integer
                                    , isErased Boolean
                                     ) ON COMMIT DROP;
        -- Сохранили - все MI
        WITH 
            -- Склад Реализации
             tmpUnit_RK   AS (SELECT 8459 AS UnitId
                             )
           , tmpMI AS (SELECT MovementItem.Id                                       AS MovementItemId
                            , COALESCE (MIFloat_ContainerId.ValueData, 0)           AS ContainerId

                            , COALESCE (MILinkObject_Receipt.ObjectId, 0)           AS ReceiptId
                            , MovementItem.ObjectId                                 AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                            , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0)  AS MeasureId


                            , COALESCE (MILinkObject_GoodsComplete.ObjectId, 0)     AS GoodsId_complete
                            , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete

                            , COALESCE (MILinkObject_ReceiptBasis.ObjectId, 0)      AS ReceiptId_basis
                            , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)        AS GoodsId_basis

                            , MovementItem.Amount                                   AS Amount
                            , COALESCE (MIFloat_AmountSecond.ValueData, 0)          AS AmountSecond

                            , COALESCE (MIFloat_AmountPack.ValueData, 0)            AS AmountPack
                            , COALESCE (MIFloat_AmountPackSecond.ValueData, 0)      AS AmountPackSecond
                            , COALESCE (MIFloat_AmountPack_calc.ValueData, 0)       AS AmountPack_calc
                            , COALESCE (MIFloat_AmountPackSecond_calc.ValueData, 0) AS AmountPackSecond_calc

                            , COALESCE (MIFloat_AmountNext.ValueData, 0)            AS AmountNext
                            , COALESCE (MIFloat_AmountNextSecond.ValueData, 0)      AS AmountNextSecond
                            , COALESCE (MIFloat_AmountPackNext.ValueData, 0)        AS AmountPackNext
                            , COALESCE (MIFloat_AmountPackNextSecond.ValueData, 0)  AS AmountPackNextSecond
                            , COALESCE (MIFloat_AmountPackNext_calc.ValueData, 0)       AS AmountPackNext_calc
                            , COALESCE (MIFloat_AmountPackNextSecond_calc.ValueData, 0) AS AmountPackNextSecond_calc

                              -- Ост. ИТОГО
                            , CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 1
                                   THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                   ELSE     CAST (MIFloat_AmountRemains.ValueData     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                              END AS AmountRemainsTOTAL
                              -- Ост. начальн. - произв.
                            , CASE WHEN MIFloat_ContainerId.ValueData > 0
                                    AND ObjectFloat_TaxExit.ValueData > 0 AND ObjectFloat_Value.ValueData > 0 AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbOperDate - (COALESCE (MIFloat_TermProduction.ValueData, 0) :: Integer :: TVarChar || ' DAY') :: INTERVAL
                                    AND COALESCE (MIFloat_AmountRemains.ValueData, 0) >= ObjectFloat_TaxExit.ValueData * 0.20 -- !!!так НЕ учитываем если партия НЕ закрыта!!!
                                        THEN CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 2
                                                  THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE     CAST (MIFloat_AmountRemains.ValueData     * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains_CEH
                              -- Ост. начальн. - произв.
                            , CASE WHEN MIFloat_ContainerId.ValueData > 0
                                    AND ObjectFloat_TaxExit.ValueData > 0 AND ObjectFloat_Value.ValueData > 0 AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbOperDate - (COALESCE (MIFloat_TermProduction.ValueData, 0) :: Integer :: TVarChar || ' DAY') :: INTERVAL
                                    AND COALESCE (MIFloat_AmountRemains.ValueData, 0) >= ObjectFloat_TaxExit.ValueData * 0.20 -- !!!так НЕ учитываем если партия НЕ закрыта!!!
                                        THEN CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 2
                                                  THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE     CAST (MIFloat_AmountRemains.ValueData     * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains_CEH_Next
                              -- Ост. начальн. - произв. -- !!!здесь то что НЕ учитываем если партия НЕ закрыта!!!
                            , CASE WHEN MIFloat_ContainerId.ValueData > 0
                                    AND (COALESCE (ObjectFloat_TaxExit.ValueData, 0) <= 0 OR COALESCE(ObjectFloat_Value.ValueData, 0) <= 0
                                      OR COALESCE (MIFloat_AmountRemains.ValueData, 0) < ObjectFloat_TaxExit.ValueData * 0.20 -- !!!так учитываем если партия НЕ закрыта!!!
                                        )
                                        THEN CASE WHEN COALESCE (ObjectFloat_Value.ValueData, 0) = 0
                                                       THEN 0
                                                  
                                                  WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 2
                                                  THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE     CAST (MIFloat_AmountRemains.ValueData     * ObjectFloat_TaxExit.ValueData / ObjectFloat_Value.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains_CEH_err

                              -- Ост. нач. - НЕ упакованный
                            , CASE WHEN COALESCE (MILinkObject_GoodsComplete.ObjectId, 0) = 0 AND COALESCE (MIFloat_ContainerId.ValueData, 0) = 0
                                    AND (COALESCE (MIFloat_AmountRemains.ValueData, 0)
                                       - CASE WHEN MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis() THEN COALESCE (MIFloat_AmountRemainsRK.ValueData, 0) ELSE 0 END
                                        ) >= 0 -- !!!НЕ учитываем ОТРИЦАТЕЛЬНЫЙ остаток!!!
                                        THEN CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0) /*- MovementItem.Amount*/
                                                          - CASE WHEN MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis() THEN COALESCE (MIFloat_AmountRemainsRK.ValueData, 0) ELSE 0 END
                                                           ) < 1
                                                  THEN       (COALESCE (MIFloat_AmountRemains.ValueData, 0) /*- MovementItem.Amount*/
                                                            - CASE WHEN MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis() THEN COALESCE (MIFloat_AmountRemainsRK.ValueData, 0) ELSE 0 END
                                                             ) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE CAST ((COALESCE (MIFloat_AmountRemains.ValueData, 0) /*- MovementItem.Amount*/
                                                            - CASE WHEN MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis() THEN COALESCE (MIFloat_AmountRemainsRK.ValueData, 0) ELSE 0 END
                                                           ) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains
                              -- Ост. нач. - упакованный
                            , CASE WHEN COALESCE (MILinkObject_GoodsComplete.ObjectId, 0) > 0 AND COALESCE (MIFloat_ContainerId.ValueData, 0) = 0
                                    AND (COALESCE (MIFloat_AmountRemains.ValueData, 0)
                                       - CASE WHEN MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis() THEN COALESCE (MIFloat_AmountRemainsRK.ValueData, 0) ELSE 0 END
                                        ) >= 0 -- !!!НЕ учитываем ОТРИЦАТЕЛЬНЫЙ остаток!!!
                                        THEN CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)
                                                          - CASE WHEN MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis() THEN COALESCE (MIFloat_AmountRemainsRK.ValueData, 0) ELSE 0 END
                                                           ) < 1
                                                  THEN (COALESCE (MIFloat_AmountRemains.ValueData, 0)
                                                      - CASE WHEN MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis() THEN COALESCE (MIFloat_AmountRemainsRK.ValueData, 0) ELSE 0 END
                                                       ) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE CAST ((COALESCE (MIFloat_AmountRemains.ValueData, 0)
                                                            - CASE WHEN MILinkObject_GoodsKind.ObjectId = zc_GoodsKind_Basis() THEN COALESCE (MIFloat_AmountRemainsRK.ValueData, 0) ELSE 0 END
                                                             )* CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains_pack

                              -- Ост. начальн. - НЕ упакованный + упакованный -- !!!здесь то что НЕ учитываем если ОТРИЦАТЕЛЬНЫЙ остаток!!!
                            , CASE WHEN COALESCE (MIFloat_ContainerId.ValueData, 0) = 0
                                    AND COALESCE (MIFloat_AmountRemains.ValueData, 0) < 0
                                        THEN CASE WHEN ABS (COALESCE(MIFloat_AmountRemains.ValueData, 0)) < 1
                                                  THEN COALESCE (MIFloat_AmountRemains.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                  ELSE     CAST (MIFloat_AmountRemains.ValueData     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS NUMERIC (16, 1))
                                             END
                                   ELSE 0
                              END AS Remains_err
                              
                            , COALESCE (MIFloat_AmountRemainsRK.ValueData, 0) AS RemainsRK

                              -- заказ покупателя БЕЗ акций, неотгруж - вчера
                            , COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0)         * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerPrior
                              -- заказ покупателя ТОЛЬКО Акции, неотгруж - вчера
                            , COALESCE (MIFloat_AmountPartnerPriorPromo.ValueData, 0)    * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerPriorPromo

                              -- заказ покупателя БЕЗ акций, сегодня + завтра
                            , COALESCE (MIFloat_AmountPartner.ValueData, 0)              * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartner
                              -- "информативно" заказ покупателя БЕЗ акций, завтра
                            , COALESCE (MIFloat_AmountPartnerNext.ValueData, 0)          * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerNext

                              -- заказ покупателя ТОЛЬКО Акции, сегодня + завтра
                            , COALESCE (MIFloat_AmountPartnerPromo.ValueData, 0)         * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerPromo
                              -- "информативно" заказ покупателя ТОЛЬКО Акции, завтра
                            , COALESCE (MIFloat_AmountPartnerNextPromo.ValueData, 0)     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerNextPromo

                              -- для прогноза - продажи покупателям БЕЗ акций за "много" недель
                            , COALESCE (MIFloat_AmountForecast.ValueData, 0)             * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountForecast
                              -- для прогноза - продажи покупателям ТОЛЬКО Акции за "много" недель
                            , COALESCE (MIFloat_AmountForecastPromo.ValueData, 0)        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountForecastPromo
                              -- для прогноза - заказы покупателей БЕЗ акций за "много" недель
                            , COALESCE (MIFloat_AmountForecastOrder.ValueData, 0)        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountForecastOrder
                              -- для прогноза - заказы покупателей ТОЛЬКО Акции за "много" недель
                            , COALESCE (MIFloat_AmountForecastOrderPromo.ValueData, 0)   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountForecastOrderPromo
                            
                              -- ***Приход пр-во (ФАКТ)
                            , COALESCE (MIFloat_AmountPrIn.ValueData, 0)            * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPrIn
                              -- ***Факт заказ покупателя, сегодня
                            , COALESCE (MIFloat_AmountPartnerOld.ValueData, 0)      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerOld
                              -- ***Факт заказ покупателя, сегодня
                            , COALESCE (MIFloat_AmountPartnerPromoOld.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS AmountPartnerPromoOld

                              -- "средняя" за 1 день - продажа покупателям БЕЗ акций
                            , CASE WHEN vbDayCount <> 0 THEN COALESCE (MIFloat_AmountForecast.ValueData, 0)      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbDayCount ELSE 0 END AS CountForecast
                              -- "средняя" за 1 день - заказы покупателей БЕЗ акций
                            , CASE WHEN vbDayCount <> 0 THEN COALESCE (MIFloat_AmountForecastOrder.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbDayCount ELSE 0 END AS CountForecastOrder

                              -- "средняя" за 1 день - продажа ИЛИ заявка
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Plan1.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Plan1
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Plan2.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Plan2
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Plan3.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Plan3
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Plan4.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Plan4
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Plan5.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Plan5
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Plan6.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Plan6
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Plan7.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Plan7
                              -- "средняя" за 1 день - акции - прогноз
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Promo1.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Promo1
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Promo2.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Promo2
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Promo3.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Promo3
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Promo4.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Promo4
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Promo5.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Promo5
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Promo6.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Promo6
                            , CASE WHEN vbWeekCount <> 0 THEN COALESCE (MIFloat_Promo7.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END / vbWeekCount ELSE 0 END AS Promo7

                            , COALESCE (MIFloat_TermProduction.ValueData, 0)  AS TermProduction
                            , vbOperDate - (COALESCE (MIFloat_TermProduction.ValueData, 0) :: INteger :: TVarChar || ' DAY') :: INTERVAL AS PartionGoods_start
                            , ObjectDate_Value.ValueData                      AS PartionDate_pf
                            , CLO_GoodsKind.ObjectId                          AS GoodsKindId_pf
                            , CASE WHEN MIFloat_ContainerId.ValueData > 0 THEN COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) END AS GoodsKindCompleteId_pf
                            , CLO_Unit.ObjectId                               AS UnitId_pf

                            , MovementItem.isErased                                 AS isErased

                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPack
                                                        ON MIFloat_AmountPack.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPack.DescId = zc_MIFloat_AmountPack()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond
                                                        ON MIFloat_AmountPackSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPackSecond.DescId = zc_MIFloat_AmountPackSecond()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPack_calc
                                                        ON MIFloat_AmountPack_calc.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPack_calc.DescId = zc_MIFloat_AmountPack_calc()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond_calc
                                                        ON MIFloat_AmountPackSecond_calc.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPackSecond_calc.DescId = zc_MIFloat_AmountPackSecond_calc()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountNext
                                                        ON MIFloat_AmountNext.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountNext.DescId = zc_MIFloat_AmountNext()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountNextSecond
                                                        ON MIFloat_AmountNextSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountNextSecond.DescId = zc_MIFloat_AmountNextSecond()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext
                                                        ON MIFloat_AmountPackNext.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPackNext.DescId = zc_MIFloat_AmountPackNext()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond
                                                        ON MIFloat_AmountPackNextSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPackNextSecond.DescId = zc_MIFloat_AmountPackNextSecond()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext_calc
                                                        ON MIFloat_AmountPackNext_calc.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPackNext_calc.DescId = zc_MIFloat_AmountPackNext_calc()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond_calc
                                                        ON MIFloat_AmountPackNextSecond_calc.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPackNextSecond_calc.DescId = zc_MIFloat_AmountPackNextSecond_calc()

                            LEFT JOIN MovementItemFloat AS MIFloat_Plan1
                                                        ON MIFloat_Plan1.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Plan1.DescId         = zc_MIFloat_Plan1()
                            LEFT JOIN MovementItemFloat AS MIFloat_Plan2
                                                        ON MIFloat_Plan2.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Plan2.DescId         = zc_MIFloat_Plan2()
                            LEFT JOIN MovementItemFloat AS MIFloat_Plan3
                                                        ON MIFloat_Plan3.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Plan3.DescId         = zc_MIFloat_Plan3()
                            LEFT JOIN MovementItemFloat AS MIFloat_Plan4
                                                        ON MIFloat_Plan4.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Plan4.DescId         = zc_MIFloat_Plan4()
                            LEFT JOIN MovementItemFloat AS MIFloat_Plan5
                                                        ON MIFloat_Plan5.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Plan5.DescId         = zc_MIFloat_Plan5()
                            LEFT JOIN MovementItemFloat AS MIFloat_Plan6
                                                        ON MIFloat_Plan6.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Plan6.DescId         = zc_MIFloat_Plan6()
                            LEFT JOIN MovementItemFloat AS MIFloat_Plan7
                                                        ON MIFloat_Plan7.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Plan7.DescId         = zc_MIFloat_Plan7()
                            LEFT JOIN MovementItemFloat AS MIFloat_Promo1
                                                        ON MIFloat_Promo1.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Promo1.DescId         = zc_MIFloat_Promo1()
                            LEFT JOIN MovementItemFloat AS MIFloat_Promo2
                                                        ON MIFloat_Promo2.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Promo2.DescId         = zc_MIFloat_Promo2()
                            LEFT JOIN MovementItemFloat AS MIFloat_Promo3
                                                        ON MIFloat_Promo3.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Promo3.DescId         = zc_MIFloat_Promo3()
                            LEFT JOIN MovementItemFloat AS MIFloat_Promo4
                                                        ON MIFloat_Promo4.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Promo4.DescId         = zc_MIFloat_Promo4()
                            LEFT JOIN MovementItemFloat AS MIFloat_Promo5
                                                        ON MIFloat_Promo5.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Promo5.DescId         = zc_MIFloat_Promo5()
                            LEFT JOIN MovementItemFloat AS MIFloat_Promo6
                                                        ON MIFloat_Promo6.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Promo6.DescId         = zc_MIFloat_Promo6()
                            LEFT JOIN MovementItemFloat AS MIFloat_Promo7
                                                        ON MIFloat_Promo7.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Promo7.DescId         = zc_MIFloat_Promo7()

                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
--                                                AND  = Object_InfoMoney_View.InfoMoneyId

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                        ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountRemains.DescId         = zc_MIFloat_AmountRemains()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountRemainsRK
                                                        ON MIFloat_AmountRemainsRK.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountRemainsRK.DescId         = zc_MIFloat_AmountRemainsRK()
                            LEFT JOIN MovementItemFloat AS MIFloat_TermProduction
                                                        ON MIFloat_TermProduction.MovementItemId = MovementItem.Id
                                                       AND MIFloat_TermProduction.DescId         = zc_MIFloat_TermProduction()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerNext
                                                        ON MIFloat_AmountPartnerNext.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerNext.DescId         = zc_MIFloat_AmountPartnerNext()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                                        ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerPrior.DescId         = zc_MIFloat_AmountPartnerPrior()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                                        ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountForecast.DescId         = zc_MIFloat_AmountForecast()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                                        ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountForecastOrder.DescId         = zc_MIFloat_AmountForecastOrder()
                            --
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPromo
                                                        ON MIFloat_AmountPartnerPromo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerPromo.DescId         = zc_MIFloat_AmountPartnerPromo()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPriorPromo
                                                        ON MIFloat_AmountPartnerPriorPromo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerPriorPromo.DescId         = zc_MIFloat_AmountPartnerPriorPromo()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerNextPromo
                                                        ON MIFloat_AmountPartnerNextPromo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerNextPromo.DescId         = zc_MIFloat_AmountPartnerNextPromo()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastPromo
                                                        ON MIFloat_AmountForecastPromo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountForecastPromo.DescId         = zc_MIFloat_AmountForecastPromo()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrderPromo
                                                        ON MIFloat_AmountForecastOrderPromo.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountForecastOrderPromo.DescId         = zc_MIFloat_AmountForecastOrderPromo()

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPrIn
                                                        ON MIFloat_AmountPrIn.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPrIn.DescId         = zc_MIFloat_AmountPrIn()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerOld
                                                        ON MIFloat_AmountPartnerOld.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerOld.DescId         = zc_MIFloat_AmountPartnerOld()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPromoOld
                                                        ON MIFloat_AmountPartnerPromoOld.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartnerPromoOld.DescId         = zc_MIFloat_AmountPartnerPromoOld()
                            --
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                             ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                             ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId         = zc_MILinkObject_GoodsKindComplete()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                             ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Receipt.DescId         = zc_MILinkObject_Receipt()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptBasis
                                                             ON MILinkObject_ReceiptBasis.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_ReceiptBasis.DescId         = zc_MILinkObject_ReceiptBasis()

                            LEFT JOIN ObjectFloat AS ObjectFloat_TaxExit
                                                  ON ObjectFloat_TaxExit.ObjectId = MILinkObject_Receipt.ObjectId
                                                 AND ObjectFloat_TaxExit.DescId   = zc_ObjectFloat_Receipt_TaxExit()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = MILinkObject_Receipt.ObjectId
                                                 AND ObjectFloat_Value.DescId   = zc_ObjectFloat_Receipt_Value()

                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

                            LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                          ON CLO_Unit.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                          ON CLO_PartionGoods.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                            LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                    AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                 ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                                AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                      )
             -- хардкодим - ЦЕХ колбаса+дел-сы (производство)
           , tmpUnit_CEH   AS (SELECT UnitId, TRUE AS isContainer FROM lfSelect_Object_Unit_byGroup (8446) AS lfSelect_Object_Unit_byGroup)
             -- хардкодим - Склады База + Реализации + Склад Поклейки этикетки
           , tmpUnit_SKLAD AS (SELECT UnitId, FALSE AS isContainer FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup
                               WHERE lfSelect_Object_Unit_byGroup.UnitId <> 9558031 -- Склад Неликвид
                              UNION
                                -- Склад Поклейки этикетки
                               SELECT 9073781 AS UnitId, FALSE AS isContainer
                              )
             -- хардкодим - Цех Упаковки
           , tmpUnit_PACK  AS (SELECT 8451 AS UnitId)
             -- Приход - с Цеха Упаковки
           , tmpPACK AS (SELECT MIContainer.ObjectId_Analyzer                    AS GoodsId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , SUM (CASE WHEN MIContainer.isActive = TRUE  THEN      MIContainer.Amount ELSE 0 END) AS Amount_to
                                , SUM (CASE WHEN MIContainer.isActive = FALSE THEN -1 * MIContainer.Amount ELSE 0 END) AS Amount_from
                                , MIContainer.WhereObjectId_Analyzer             AS UnitId_pf
                           FROM MovementItemContainer AS MIContainer
                                -- Склады База + Реализации
                                INNER JOIN tmpUnit_SKLAD   ON tmpUnit_SKLAD.UnitId   = MIContainer.ObjectExtId_Analyzer
                                -- Цех Упаковки
                                INNER JOIN tmpUnit_PACK ON tmpUnit_PACK.UnitId = MIContainer.WhereObjectId_Analyzer
                                -- убрали Тару
                                INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ObjectId      = MIContainer.ObjectId_Analyzer
                                                     AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                    , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                    , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                     )
                           WHERE MIContainer.OperDate       = vbOperDate
                             AND MIContainer.DescId         = zc_MIContainer_Count()
                             AND MIContainer.MovementDescId = zc_Movement_Send()
                             -- AND MIContainer.isActive       = FALSE
                             AND MIContainer.Amount <> 0
                             -- AND 1=0
                           GROUP BY MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer
                                  , MIContainer.WhereObjectId_Analyzer
                          )
          -- Приход пр-во (ФАКТ)
        , tmpIncome_all AS (SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , SUM (MIContainer.Amount)                       AS Amount
                                , MIContainer.ObjectExtId_Analyzer               AS UnitId_pf
                           FROM MovementItemContainer AS MIContainer
                                -- ЦЕХ колбаса+дел-сы
                                INNER JOIN tmpUnit_CEH   ON tmpUnit_CEH.UnitId   = MIContainer.ObjectExtId_Analyzer
                                -- Склады База + Реализации
                                INNER JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = MIContainer.WhereObjectId_Analyzer
                                -- убрали Тару
                                INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ObjectId      = MIContainer.ObjectId_Analyzer
                                                     AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                    , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                    , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                                     )
                           WHERE MIContainer.OperDate       = vbOperDate
                             AND MIContainer.DescId         = zc_MIContainer_Count()
                             AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                             AND MIContainer.isActive       = TRUE
                             -- AND 1=0
                           GROUP BY MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer
                                  , MIContainer.ObjectExtId_Analyzer
 
                          UNION
                           -- Приход от поставщ
                           SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , SUM (MIContainer.Amount)                       AS Amount
                                , MAX (MIContainer.ObjectExtId_Analyzer)         AS UnitId_pf
                           FROM MovementItemContainer AS MIContainer
                                -- Склады База + Реализации
                                INNER JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = MIContainer.WhereObjectId_Analyzer
                                -- Ирна
                                INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ObjectId      = MIContainer.ObjectId_Analyzer
                                                     AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                    , zc_Enum_InfoMoney_30101() -- Продукция
                                                                                                     )
                           WHERE MIContainer.OperDate       = vbOperDate
                             AND MIContainer.DescId         = zc_MIContainer_Count()
                             AND MIContainer.MovementDescId = zc_Movement_Income()
                             AND MIContainer.isActive       = TRUE
                             -- AND 1=0
                           GROUP BY MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer

                          UNION
                           -- Приход перемещение
                           SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , SUM (MIContainer.Amount)                       AS Amount
                                , MAX (MIContainer.ObjectExtId_Analyzer)         AS UnitId_pf
                           FROM MovementItemContainer AS MIContainer
                                -- Склады База + Реализации
                                INNER JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = MIContainer.WhereObjectId_Analyzer
                                -- Ирна
                                INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ObjectId      = MIContainer.ObjectId_Analyzer
                                                     AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                    , zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                     )
                           WHERE MIContainer.OperDate       = vbOperDate
                             AND MIContainer.DescId         = zc_MIContainer_Count()
                             AND MIContainer.MovementDescId = zc_Movement_Send()
                             AND MIContainer.isActive       = TRUE
                             AND MIContainer.ObjectExtId_Analyzer = 8450 -- Дільниця термічної обробки
                             -- AND 1=0
                           GROUP BY MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer

                          UNION
                           SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                , SUM (MIContainer.Amount)                       AS Amount
                                , MAX (MIContainer.ObjectExtId_Analyzer)         AS UnitId_pf
                           FROM MovementItemContainer AS MIContainer
                                -- Склады База + Реализации
                                INNER JOIN tmpUnit_SKLAD ON tmpUnit_SKLAD.UnitId = MIContainer.WhereObjectId_Analyzer
                                                        AND tmpUnit_SKLAD.UnitId = 8458 -- Склад База ГП
                                -- Ирна
                                INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ObjectId      = MIContainer.ObjectId_Analyzer
                                                     AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                     AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                    , zc_Enum_InfoMoney_30101() -- Продукция
                                                                                                     )
                           WHERE MIContainer.OperDate       = vbOperDate
                             AND MIContainer.DescId         = zc_MIContainer_Count()
                             AND MIContainer.MovementDescId = zc_Movement_Send()
                             AND MIContainer.isActive       = TRUE
                             -- AND 1=0
                           GROUP BY MIContainer.ObjectId_Analyzer
                                  , MIContainer.ObjectIntId_Analyzer
                          )
             -- Приход пр-во (ФАКТ)
           , tmpIncome AS (SELECT tmpIncome_all.GoodsId
                                , tmpIncome_all.GoodsKindId
                                , SUM (tmpIncome_all.Amount)     AS Amount
                                , MAX (tmpIncome_all.UnitId_pf)  AS UnitId_pf
                           FROM tmpIncome_all
                           GROUP BY tmpIncome_all.GoodsId
                                  , tmpIncome_all.GoodsKindId
                          )
     -- Сохранили - все MI
     INSERT INTO _tmpMI_All (MovementItemId, ContainerId
                              , ReceiptId, GoodsId, GoodsKindId, MeasureId
                              , GoodsId_complete, GoodsKindId_complete
                              , ReceiptId_basis, GoodsId_basis
                              , Amount, AmountSecond
                              , AmountPack, AmountPackSecond
                              , AmountPack_calc, AmountPackSecond_calc
                              , AmountNext, AmountNextSecond
                              , AmountPackNext, AmountPackNextSecond
                              , AmountPackNext_calc, AmountPackNextSecond_calc
                              , AmountRemainsTOTAL, Remains_CEH, Remains_CEH_Next, Remains_CEH_err, Remains, Remains_pack, Remains_err, RemainsRK
                              , AmountPartnerPrior, AmountPartnerPriorPromo, AmountPartner, AmountPartnerNext, AmountPartnerPromo, AmountPartnerNextPromo
                              , AmountForecast, AmountForecastPromo, AmountForecastOrder, AmountForecastOrderPromo
                              , AmountPrIn, AmountPartnerOld, AmountPartnerPromoOld
                              , CountForecast, CountForecastOrder
                              , Plan1, Plan2, Plan3, Plan4, Plan5, Plan6, Plan7
                              , Promo1, Promo2, Promo3, Promo4, Promo5, Promo6, Promo7
                              , Income_CEH, Income_PACK_to, Income_PACK_from
                              , TermProduction, PartionGoods_start, PartionDate_pf, GoodsKindId_pf, GoodsKindCompleteId_pf, UnitId_pf
                              , isErased
                               )
        -- Данные MI
        SELECT tmpMI.MovementItemId, tmpMI.ContainerId
             , tmpMI.ReceiptId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.MeasureId
             , tmpMI.GoodsId_complete, tmpMI.GoodsKindId_complete
             , tmpMI.ReceiptId_basis, tmpMI.GoodsId_basis
             , tmpMI.Amount, tmpMI.AmountSecond
             , tmpMI.AmountPack, tmpMI.AmountPackSecond
             , tmpMI.AmountPack_calc, tmpMI.AmountPackSecond_calc
             , tmpMI.AmountNext, tmpMI.AmountNextSecond
             , tmpMI.AmountPackNext, tmpMI.AmountPackNextSecond
             , tmpMI.AmountPackNext_calc, tmpMI.AmountPackNextSecond_calc
             , tmpMI.AmountRemainsTOTAL, tmpMI.Remains_CEH, tmpMI.Remains_CEH_Next, tmpMI.Remains_CEH_err, tmpMI.Remains, tmpMI.Remains_pack, tmpMI.Remains_err, tmpMI.RemainsRK
             , tmpMI.AmountPartnerPrior, tmpMI.AmountPartnerPriorPromo, tmpMI.AmountPartner, tmpMI.AmountPartnerNext, tmpMI.AmountPartnerPromo, tmpMI.AmountPartnerNextPromo
             , tmpMI.AmountForecast, tmpMI.AmountForecastPromo, tmpMI.AmountForecastOrder, tmpMI.AmountForecastOrderPromo
             , tmpMI.AmountPrIn, tmpMI.AmountPartnerOld, tmpMI.AmountPartnerPromoOld
             , tmpMI.CountForecast, tmpMI.CountForecastOrder
             , tmpMI.Plan1, tmpMI.Plan2, tmpMI.Plan3, tmpMI.Plan4, tmpMI.Plan5, tmpMI.Plan6, tmpMI.Plan7
             , tmpMI.Promo1, tmpMI.Promo2, tmpMI.Promo3, tmpMI.Promo4, tmpMI.Promo5, tmpMI.Promo6, tmpMI.Promo7
             , 0 AS Income_CEH
             , 0 AS Income_PACK_to
             , 0 AS Income_PACK_from
             , tmpMI.TermProduction, tmpMI.PartionGoods_start, tmpMI.PartionDate_pf, tmpMI.GoodsKindId_pf, tmpMI.GoodsKindCompleteId_pf, tmpMI.UnitId_pf
             , tmpMI.isErased
        FROM tmpMI

       UNION ALL
        -- Приход пр-во (ФАКТ)
        SELECT 0 AS MovementItemId
             , 0 AS ContainerId
             , 0 AS ReceiptId
             , tmpIncome.GoodsId
             , tmpIncome.GoodsKindId
             , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) AS MeasureId
             , 0 AS GoodsId_complete, 0 AS GoodsKindId_complete
             , 0 AS ReceiptId_basis, 0 AS GoodsId_basis
             , 0 AS Amount, 0 AS AmountSecond
             , 0 AS AmountPack, 0 AS AmountPackSecond
             , 0 AS AmountPack_calc, 0 AS AmountPackSecond_calc
             , 0 AS AmountNext, 0 AS AmountNextSecond
             , 0 AS AmountPackNext, 0 AS AmountPackNextSecond
             , 0 AS AmountPackNext_calc, 0 AS AmountPackNextSecond_calc
             , 0 AS AmountRemainsTOTAL, 0 AS Remains_CEH, 0 AS Remains_CEH_Next, 0 AS Remains_CEH_err, 0 AS Remains, 0 AS Remains_pack, 0 AS Remains_err, 0 AS RemainsRK
             , 0 AS AmountPartnerPrior, 0 AS AmountPartnerPriorPromo, 0 AS AmountPartner, 0 AS AmountPartnerNext, 0 AS AmountPartnerPromo, 0 AS AmountPartnerNextPromo
             , 0 AS AmountForecast, 0 AS AmountForecastPromo, 0 AS AmountForecastOrder, 0 AS AmountForecastOrderPromo
             , 0 AS AmountPrIn, 0 AS AmountPartnerOld, 0 AS AmountPartnerPromoOld
             , 0 AS CountForecast, 0 AS CountForecastOrder
             , 0 AS Plan1, 0 AS Plan2, 0 AS Plan3, 0 AS Plan4, 0 AS Plan5, 0 AS Plan6, 0 AS Plan7
             , 0 AS Promo1, 0 AS Promo2, 0 AS Promo3, 0 AS Promo4, 0 AS Promo5, 0 AS Promo6, 0 AS Promo7
             , tmpIncome.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Income_CEH
             , 0 AS Income_PACK_to
             , 0 AS Income_PACK_from
             , 0 AS TermProduction, NULL :: TDateTime AS PartionGoods_start, NULL :: TDateTime AS PartionDate_pf, 0 AS GoodsKindId_pf, 0 AS GoodsKindCompleteId_pf
             , tmpIncome.UnitId_pf
             , FALSE AS isErased
        FROM tmpIncome
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = tmpIncome.GoodsId
                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpIncome.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
       UNION ALL
        -- Расход на / Приход с - Цеха Упаковки
        SELECT 0 AS MovementItemId
             , 0 AS ContainerId
             , COALESCE (tmp.ReceiptId, 0) AS ReceiptId
             , tmpPACK.GoodsId
             , tmpPACK.GoodsKindId
             , COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) AS MeasureId
             , COALESCE (tmp.GoodsId_complete, 0) AS GoodsId_complete, COALESCE (tmp.GoodsKindId_complete, 0) AS GoodsKindId_complete
             , COALESCE (tmp.ReceiptId_basis, 0) AS ReceiptId_basis, COALESCE (tmp.GoodsId_basis, 0) AS GoodsId_basis
             , 0 AS Amount, 0 AS AmountSecond
             , 0 AS AmountPack, 0 AS AmountPackSecond
             , 0 AS AmountPack_calc, 0 AS AmountPackSecond_calc
             , 0 AS AmountNext, 0 AS AmountNextSecond
             , 0 AS AmountPackNext, 0 AS AmountPackNextSecond
             , 0 AS AmountPackNext_calc, 0 AS AmountPackNextSecond_calc
             , 0 AS AmountRemainsTOTAL, 0 AS Remains_CEH, 0 AS Remains_CEH_Next, 0 AS Remains_CEH_err, 0 AS Remains, 0 AS Remains_pack, 0 AS Remains_err, 0 AS RemainsRK
             , 0 AS AmountPartnerPrior, 0 AS AmountPartnerPriorPromo, 0 AS AmountPartner, 0 AS AmountPartnerNext, 0 AS AmountPartnerPromo, 0 AS AmountPartnerNextPromo
             , 0 AS AmountForecast, 0 AS AmountForecastPromo, 0 AS AmountForecastOrder, 0 AS AmountForecastOrderPromo
             , 0 AS AmountPrIn, 0 AS AmountPartnerOld, 0 AS AmountPartnerPromoOld
             , 0 AS CountForecast, 0 AS CountForecastOrder
             , 0 AS Plan1, 0 AS Plan2, 0 AS Plan3, 0 AS Plan4, 0 AS Plan5, 0 AS Plan6, 0 AS Plan7
             , 0 AS Promo1, 0 AS Promo2, 0 AS Promo3, 0 AS Promo4, 0 AS Promo5, 0 AS Promo6, 0 AS Promo7
             , 0 AS Income_CEH
             , tmpPACK.Amount_to   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Income_PACK_to
             , tmpPACK.Amount_from * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Income_PACK_from
             , 0 AS TermProduction, NULL :: TDateTime AS PartionGoods_start, NULL :: TDateTime AS PartionDate_pf, 0 AS GoodsKindId_pf, 0 AS GoodsKindCompleteId_pf
             , tmpPACK.UnitId_pf
             , FALSE AS isErased
        FROM tmpPACK
             LEFT JOIN (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId
                             , tmpMI.ReceiptId, tmpMI.GoodsId_complete, tmpMI.GoodsKindId_complete
                             , tmpMI.ReceiptId_basis, tmpMI.GoodsId_basis
                               --  № п/п
                             , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.GoodsId_complete DESC) AS Ord
                        FROM tmpMI
                        WHERE tmpMI.ContainerId = 0
                       ) AS tmp ON tmp.GoodsId     = tmpPACK.GoodsId
                               AND tmp.GoodsKindId = tmpPACK.GoodsKindId
                               AND tmp.Ord         = 1 -- !!!на всякий случай!!!
             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = tmpPACK.GoodsId
                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = tmpPACK.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
       ;

-- RAISE EXCEPTION '<%>', (select count(*) from _tmpMI_All where _tmpMI_All.GoodsId = 4965 and _tmpMI_All.GoodsKindId = zc_GoodsKind_Basis());


     -- Результат - master
     CREATE TEMP TABLE _Result_Master (Id         Integer
                                     , KeyId      TVarChar
                                     , GoodsId    Integer
                                     , GoodsCode  Integer
                                     , GoodsName  TVarChar
                                     , GoodsId_basis    Integer
                                     , GoodsCode_basis  Integer
                                     , GoodsName_basis  TVarChar
                                     , GoodsKindId      Integer
                                     , GoodsKindName    TVarChar
                                     , MeasureId        Integer
                                     , MeasureName      TVarChar
                                     , MeasureName_basis   TVarChar
                                     , GoodsGroupNameFull  TVarChar
                                     , isCheck_basis             Boolean

                                     , Amount                    TFloat-- ***Ост. на УПАК
                                     , AmountSecond              TFloat-- ***План ПР-ВО на УПАК
                                     , AmountTotal               TFloat-- ***План ПР-ВО на УПАК

                                     , AmountNext                TFloat-- ***План2Ост. на УПАК
                                     , AmountNextSecond          TFloat-- ***План2 ПР-ВО на УПАК
                                     , AmountNextTotal           TFloat-- *** итого План2 ПР-ВО на УПАК
                                     , AmountAllTotal            TFloat-- *** итого План+План2 ПР-ВО на УПАК

                                     , Amount_result             TFloat
                                     , Amount_result_two         TFloat
                                     , Amount_result_pack        TFloat

                                       -- ПРИОРИТЕТ
                                     , Num                       Integer

                                     , Income_CEH                TFloat
                                     , Income_PACK_to            TFloat
                                     , Income_PACK_from          TFloat

                                     , Remains                   TFloat
                                     , Remains_pack              TFloat
                                     , RemainsRK                 TFloat
                                     , Remains_CEH               TFloat
                                     , Remains_CEH_Next          TFloat

                                     , AmountPartnerPrior        TFloat
                                     , AmountPartnerPriorPromo   TFloat
                                     , AmountPartnerPriorTotal   TFloat

                                     , AmountPartner             TFloat
                                     , AmountPartnerNext         TFloat
                                     , AmountPartnerPromo        TFloat
                                     , AmountPartnerNextPromo    TFloat
                                     , AmountPartnerTotal        TFloat

                                     , AmountForecast            TFloat
                                     , AmountForecastPromo       TFloat

                                     , AmountForecastOrder       TFloat
                                     , AmountForecastOrderPromo  TFloat

                                     , AmountPrIn                TFloat
                                     , AmountPartnerOld          TFloat
                                     , AmountPartnerPromoOld     TFloat
                                     , AmountPartnerOldTotal     TFloat

                                     , CountForecast             TFloat
                                     , CountForecastOrder        TFloat

                                     , Plan1 TFloat, Plan2 TFloat, Plan3 TFloat, Plan4 TFloat, Plan5 TFloat, Plan6 TFloat, Plan7 TFloat
                                     , Promo1 TFloat, Promo2 TFloat, Promo3 TFloat, Promo4 TFloat, Promo5 TFloat, Promo6 TFloat, Promo7 TFloat

                                     , DayCountForecast          TFloat
                                     , DayCountForecastOrder     TFloat
                                     , DayCountForecast_calc     TFloat

                                     , ReceiptId                 Integer
                                     , ReceiptCode               TVarChar
                                     , ReceiptName               TVarChar
                                     , ReceiptId_basis           Integer
                                     , ReceiptCode_basis         TVarChar
                                     , ReceiptName_basis         TVarChar
                                     , UnitId                    Integer
                                     , UnitCode                  Integer
                                     , UnitName                  TVarChar
                                     , isErased                  Boolean
                                      ) ON COMMIT DROP;

      -- Сохранили - master
      INSERT INTO _Result_Master (Id
                                , KeyId
                                , GoodsId
                                , GoodsCode
                                , GoodsName
                                , GoodsId_basis
                                , GoodsCode_basis
                                , GoodsName_basis
                                , GoodsKindId
                                , GoodsKindName
                                , MeasureId
                                , MeasureName
                                , MeasureName_basis
                                , GoodsGroupNameFull
                                , isCheck_basis
                                , Amount
                                , AmountSecond
                                , AmountTotal

                                , AmountNext
                                , AmountNextSecond
                                , AmountNextTotal
                                , AmountAllTotal

                                , Amount_result
                                , Amount_result_two
                                , Amount_result_pack
                                , Num
                                , Income_CEH
                                , Income_PACK_to
                                , Income_PACK_from

                                , Remains
                                , Remains_pack
                                , RemainsRK
                                , Remains_CEH
                                , Remains_CEH_Next

                                , AmountPartnerPrior
                                , AmountPartnerPriorPromo
                                , AmountPartnerPriorTotal

                                , AmountPartner
                                , AmountPartnerNext
                                , AmountPartnerPromo
                                , AmountPartnerNextPromo
                                , AmountPartnerTotal

                                , AmountForecast
                                , AmountForecastPromo

                                , AmountForecastOrder
                                , AmountForecastOrderPromo
                                
                                , AmountPrIn
                                , AmountPartnerOld
                                , AmountPartnerPromoOld
                                , AmountPartnerOldTotal

                                , CountForecast
                                , CountForecastOrder

                                , Plan1, Plan2, Plan3, Plan4, Plan5, Plan6, Plan7
                                , Promo1, Promo2, Promo3, Promo4, Promo5, Promo6, Promo7

                                , DayCountForecast
                                , DayCountForecastOrder
                                , DayCountForecast_calc

                                , ReceiptId
                                , ReceiptCode
                                , ReceiptName
                                , ReceiptId_basis
                                , ReceiptCode_basis
                                , ReceiptName_basis
                                , UnitId
                                , UnitCode
                                , UnitName
                                , isErased
                                 )
       -- Результат - master
       WITH tmpMI_all AS (SELECT * FROM _tmpMI_All
                          WHERE _tmpMI_All.Income_CEH       = 0 -- отбросили Приход пр-во (ФАКТ)
                            AND _tmpMI_All.GoodsId_complete = 0 -- т.е. НЕ упакованный
                            AND _tmpMI_All.ContainerId      = 0 -- отбросили остатки на ПР-ВЕ
                            -- отбросили Перемещение на Цех Упаковки
                            AND (_tmpMI_All.Income_PACK_to    = 0
                                OR (_tmpMI_All.Income_PACK_to   <> 0 AND _tmpMI_All.ReceiptId = 0 AND _tmpMI_All.GoodsId_complete = 0 AND _tmpMI_All.GoodsId_basis = 0))
                             -- отбросили Перемещение с Цеха Упаковки
                            AND (_tmpMI_All.Income_PACK_from  = 0
                                OR (_tmpMI_All.Income_PACK_from <> 0 AND _tmpMI_All.ReceiptId = 0 AND _tmpMI_All.GoodsId_complete = 0 AND _tmpMI_All.GoodsId_basis = 0))
                         )
        -- Приход пр-во (ФАКТ)
      , tmpIncome AS (SELECT * FROM _tmpMI_All WHERE _tmpMI_All.Income_CEH <> 0)
           -- Ост. на произв-ве
         , tmpCEH AS (SELECT _tmpMI_All.GoodsId
                           , _tmpMI_All.GoodsKindCompleteId_pf
                           , SUM (_tmpMI_All.Remains_CEH)      AS Remains_CEH
                           , SUM (_tmpMI_All.Remains_CEH_Next) AS Remains_CEH_Next
                      FROM _tmpMI_All
                      WHERE _tmpMI_All.Remains_CEH <> 0 OR _tmpMI_All.Remains_CEH_Next <> 0
                      GROUP BY _tmpMI_All.GoodsId
                             , _tmpMI_All.GoodsKindCompleteId_pf
                     )
    -- Поиск хоть одного упакованного, где не хватает
  , tmpChild_find AS (SELECT DISTINCT
                             CASE WHEN _tmpMI_All.GoodsId_complete = 0
                                       THEN _tmpMI_All.GoodsId
                                  ELSE _tmpMI_All.GoodsId_complete
                             END AS GoodsId
                           , CASE WHEN _tmpMI_All.GoodsId_complete = 0
                                       THEN _tmpMI_All.GoodsKindId
                                  ELSE _tmpMI_All.GoodsKindId_complete
                             END AS GoodsKindId
                           , MIN (_tmpMI_All.Remains + _tmpMI_All.Remains_pack
                                - _tmpMI_All.AmountPartnerPrior - _tmpMI_All.AmountPartnerPriorPromo
                                - _tmpMI_All.AmountPartner      - _tmpMI_All.AmountPartnerPromo
                                 ) AS Amount_res
                      FROM _tmpMI_All
                      WHERE 0 > _tmpMI_All.Remains + _tmpMI_All.Remains_pack
                              - _tmpMI_All.AmountPartnerPrior - _tmpMI_All.AmountPartnerPriorPromo
                              - _tmpMI_All.AmountPartner      - _tmpMI_All.AmountPartnerPromo
                      GROUP BY CASE WHEN _tmpMI_All.GoodsId_complete = 0
                                         THEN _tmpMI_All.GoodsId
                                    ELSE _tmpMI_All.GoodsId_complete
                               END
                             , CASE WHEN _tmpMI_All.GoodsId_complete = 0
                                         THEN _tmpMI_All.GoodsKindId
                                    ELSE _tmpMI_All.GoodsKindId_complete
                               END
                     )
         -- Итого по данным из Курсора-2
       , tmpChild AS (SELECT CASE WHEN _tmpMI_All.GoodsId_complete = 0
                                       THEN _tmpMI_All.GoodsId
                                  ELSE _tmpMI_All.GoodsId_complete
                             END AS GoodsId
                           , CASE WHEN _tmpMI_All.GoodsId_complete = 0
                                       THEN _tmpMI_All.GoodsKindId
                                  ELSE _tmpMI_All.GoodsKindId_complete
                             END AS GoodsKindId

                           , SUM (_tmpMI_All.AmountPack)               AS AmountPack
                           , SUM (_tmpMI_All.AmountPackSecond)         AS AmountPackSecond

                           , SUM (_tmpMI_All.AmountPackNext)           AS AmountPackNext
                           , SUM (_tmpMI_All.AmountPackNextSecond)     AS AmountPackNextSecond

                           , SUM (_tmpMI_All.Remains_pack)             AS Remains_pack
                           , SUM (_tmpMI_All.RemainsRK)                AS RemainsRK
                           , SUM (_tmpMI_All.Income_PACK_to)           AS Income_PACK_to
                           , SUM (_tmpMI_All.Income_PACK_from)         AS Income_PACK_from

                           , SUM (_tmpMI_All.AmountPartnerPrior)       AS AmountPartnerPrior
                           , SUM (_tmpMI_All.AmountPartnerPriorPromo)  AS AmountPartnerPriorPromo
                           , SUM (_tmpMI_All.AmountPartner)            AS AmountPartner
                           , SUM (_tmpMI_All.AmountPartnerNext)        AS AmountPartnerNext
                           , SUM (_tmpMI_All.AmountPartnerPromo)       AS AmountPartnerPromo
                           , SUM (_tmpMI_All.AmountPartnerNextPromo)   AS AmountPartnerNextPromo

                           , SUM (_tmpMI_All.AmountForecast)           AS AmountForecast
                           , SUM (_tmpMI_All.AmountForecastPromo)      AS AmountForecastPromo
                           , SUM (_tmpMI_All.AmountForecastOrder)      AS AmountForecastOrder
                           , SUM (_tmpMI_All.AmountForecastOrderPromo) AS AmountForecastOrderPromo

                           , SUM (_tmpMI_All.AmountPrIn)               AS AmountPrIn
                           , SUM (_tmpMI_All.AmountPartnerOld)         AS AmountPartnerOld
                           , SUM (_tmpMI_All.AmountPartnerPromoOld)    AS AmountPartnerPromoOld

                           , SUM (_tmpMI_All.CountForecast)      AS CountForecast
                           , SUM (_tmpMI_All.CountForecastOrder) AS CountForecastOrder

                           , SUM (_tmpMI_All.Plan1)      AS Plan1
                           , SUM (_tmpMI_All.Plan2)      AS Plan2
                           , SUM (_tmpMI_All.Plan3)      AS Plan3
                           , SUM (_tmpMI_All.Plan4)      AS Plan4
                           , SUM (_tmpMI_All.Plan5)      AS Plan5
                           , SUM (_tmpMI_All.Plan6)      AS Plan6
                           , SUM (_tmpMI_All.Plan7)      AS Plan7

                           , SUM (_tmpMI_All.Promo1)     AS Promo1
                           , SUM (_tmpMI_All.Promo2)     AS Promo2
                           , SUM (_tmpMI_All.Promo3)     AS Promo3
                           , SUM (_tmpMI_All.Promo4)     AS Promo4
                           , SUM (_tmpMI_All.Promo5)     AS Promo5
                           , SUM (_tmpMI_All.Promo6)     AS Promo6
                           , SUM (_tmpMI_All.Promo7)     AS Promo7

                      FROM _tmpMI_All
                      -- WHERE _tmpMI_All.Remains_pack <> 0
                      GROUP BY CASE WHEN _tmpMI_All.GoodsId_complete = 0
                                         THEN _tmpMI_All.GoodsId
                                    ELSE _tmpMI_All.GoodsId_complete
                              END
                            , CASE WHEN _tmpMI_All.GoodsId_complete = 0
                                         THEN _tmpMI_All.GoodsKindId
                                    ELSE _tmpMI_All.GoodsKindId_complete
                               END
                     )
          , tmpMI AS (SELECT tmpMI_all.MovementItemId, tmpMI_all.ContainerId
                           , tmpMI_all.ReceiptId, tmpMI_all.GoodsId
                           , tmpMI_all.GoodsKindId
                           , tmpMI_all.MeasureId
                           , tmpMI_all.GoodsId_complete, tmpMI_all.GoodsKindId_complete
                           , tmpMI_all.ReceiptId_basis
                           , tmpMI_all.GoodsId_basis
                           , tmpMI_all.Amount, tmpMI_all.AmountSecond
                           , tmpMI_all.AmountNext, tmpMI_all.AmountNextSecond
                           , tmpMI_all.AmountRemainsTOTAL, tmpMI_all.Remains_CEH, tmpMI_all.Remains_CEH_Next, tmpMI_all.Remains, tmpMI_all.Remains_pack, tmpMI_all.RemainsRK
                           , tmpMI_all.AmountPartnerPrior, tmpMI_all.AmountPartnerPriorPromo, tmpMI_all.AmountPartner, tmpMI_all.AmountPartnerNext, tmpMI_all.AmountPartnerPromo, tmpMI_all.AmountPartnerNextPromo
                           , tmpMI_all.AmountForecast, tmpMI_all.AmountForecastPromo, tmpMI_all.AmountForecastOrder, tmpMI_all.AmountForecastOrderPromo
                           , tmpMI_all.AmountPrIn, tmpMI_all.AmountPartnerOld, tmpMI_all.AmountPartnerPromoOld
                           , tmpMI_all.CountForecast, tmpMI_all.CountForecastOrder
                           , tmpMI_all.Income_CEH
                           , tmpMI_all.TermProduction, tmpMI_all.PartionGoods_start, tmpMI_all.PartionDate_pf, tmpMI_all.GoodsKindId_pf, tmpMI_all.GoodsKindCompleteId_pf, tmpMI_all.UnitId_pf
                           , tmpMI_all.isErased
                      FROM tmpMI_all
                     UNION
                      SELECT _tmpMI_All.MovementItemId, _tmpMI_All.ContainerId
                           , _tmpMI_All.ReceiptId, _tmpMI_All.GoodsId
                           , _tmpMI_All.GoodsKindId
                           -- , _tmpMI_All.GoodsKindCompleteId_pf AS GoodsKindId
                           , _tmpMI_All.MeasureId
                           , _tmpMI_All.GoodsId_complete, _tmpMI_All.GoodsKindId_complete
                           , _tmpMI_All.ReceiptId_basis
                           , _tmpMI_All.GoodsId_basis
                           -- , _tmpMI_All.GoodsId AS GoodsId_basis
                           , _tmpMI_All.Amount, _tmpMI_All.AmountSecond
                           , _tmpMI_All.AmountNext, _tmpMI_All.AmountNextSecond
                           , _tmpMI_All.AmountRemainsTOTAL, _tmpMI_All.Remains_CEH, _tmpMI_All.Remains_CEH_Next, _tmpMI_All.Remains, _tmpMI_All.Remains_pack, _tmpMI_All.RemainsRK
                           , _tmpMI_All.AmountPartnerPrior, _tmpMI_All.AmountPartnerPriorPromo, _tmpMI_All.AmountPartner, tmpMI_all.AmountPartnerNext, _tmpMI_All.AmountPartnerPromo, _tmpMI_All.AmountPartnerNextPromo
                           , _tmpMI_All.AmountForecast, _tmpMI_All.AmountForecastPromo, _tmpMI_All.AmountForecastOrder, _tmpMI_All.AmountForecastOrderPromo
                           , _tmpMI_All.AmountPrIn, _tmpMI_All.AmountPartnerOld, _tmpMI_All.AmountPartnerPromoOld
                           , _tmpMI_All.CountForecast, _tmpMI_All.CountForecastOrder
                           , _tmpMI_All.Income_CEH
                           , _tmpMI_All.TermProduction, _tmpMI_All.PartionGoods_start, _tmpMI_All.PartionDate_pf, _tmpMI_All.GoodsKindId_pf, _tmpMI_All.GoodsKindCompleteId_pf, _tmpMI_All.UnitId_pf
                           , _tmpMI_All.isErased
                      FROM _tmpMI_All
                           LEFT JOIN tmpMI_all ON tmpMI_all.GoodsId_basis = _tmpMI_All.GoodsId
                                              AND tmpMI_all.GoodsKindId   = _tmpMI_All.GoodsKindCompleteId_pf
                      WHERE (_tmpMI_All.Remains_CEH <> 0 OR _tmpMI_All.Remains_CEH_Next  <> 0)
                        AND tmpMI_all.GoodsId_basis IS NULL
                     )
       -- Результат - master
       SELECT
             tmpMI.MovementItemId   AS Id
           , (tmpMI.GoodsId :: TVarChar || '_' || tmpMI.GoodsKindId :: TVarChar) :: TVarChar AS KeyId
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_Goods_basis.Id               AS GoodsId_basis
           , Object_Goods_basis.ObjectCode       AS GoodsCode_basis
           , Object_Goods_basis.ValueData        AS GoodsName_basis

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_Measure.Id                   AS MeasureId
           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_basis.ValueData      AS MeasureName_basis

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId <> tmpMI.GoodsId_basis AND tmpMI.GoodsId_basis > 0 THEN TRUE ELSE FALSE END AS isCheck_basis

           , tmpMI.Amount                        :: TFloat AS Amount        -- ***Ост. на УПАК
           , tmpMI.AmountSecond                  :: TFloat AS AmountSecond  -- ***План ПР-ВО на УПАК
           , (tmpMI.Amount + tmpMI.AmountSecond) :: TFloat AS AmountTotal   -- ***План ПР-ВО на УПАК

           , tmpMI.AmountNext                            :: TFloat AS AmountNext        -- ***Ост. на УПАК
           , tmpMI.AmountNextSecond                      :: TFloat AS AmountNextSecond  -- ***План2 ПР-ВО на УПАК
           , (tmpMI.AmountNext + tmpMI.AmountNextSecond) :: TFloat AS AmountNextTotal   -- ***План2 ПР-ВО на УПАК
           , (tmpMI.Amount + tmpMI.AmountSecond + tmpMI.AmountNext + tmpMI.AmountNextSecond) :: TFloat AS AmountAllTotal   -- ***Итого План+План2 ПР-ВО на УПАК

             -- Amount_result
           , (CAST (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0) + CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH ELSE COALESCE (tmpCEH.Remains_CEH, 0) END
              - COALESCE (tmpChild.AmountPartnerPrior, 0) - COALESCE (tmpChild.AmountPartnerPriorPromo, 0) - COALESCE (tmpChild.AmountPartner, 0) - COALESCE (tmpChild.AmountPartnerPromo, 0) AS NUMERIC (16, 1))) :: TFloat AS Amount_result
             -- Amount_result_two
           , (CAST (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0) + 0
              - COALESCE (tmpChild.AmountPartnerPrior, 0) - COALESCE (tmpChild.AmountPartnerPriorPromo, 0) - COALESCE (tmpChild.AmountPartner, 0) - COALESCE (tmpChild.AmountPartnerPromo, 0) AS NUMERIC (16, 1))) :: TFloat AS Amount_result_two
             -- Amount_result_pack
           , (CAST (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0) + 0
              - COALESCE (tmpChild.AmountPartnerPrior, 0) - COALESCE (tmpChild.AmountPartnerPriorPromo, 0) - COALESCE (tmpChild.AmountPartner, 0) - COALESCE (tmpChild.AmountPartnerPromo, 0) AS NUMERIC (16, 1))
              - tmpMI.Amount - tmpMI.AmountNext
              + COALESCE (tmpChild.AmountPack, 0) + COALESCE (tmpChild.AmountPackSecond, 0) + COALESCE (tmpChild.AmountPackNext, 0) + COALESCE (tmpChild.AmountPackNextSecond, 0)
             ) :: TFloat AS Amount_result_pack


           , CASE -- ИТОГО: РЕЗУЛЬТАТ с ПР-ВОМ < 0, т.е. не хватит ВООБЩЕ
                  WHEN 0 > tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0) + CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH ELSE COALESCE (tmpCEH.Remains_CEH, 0) END
                         - COALESCE (tmpChild.AmountPartnerPrior, 0) - COALESCE (tmpChild.AmountPartnerPriorPromo, 0) - COALESCE (tmpChild.AmountPartner, 0) - COALESCE (tmpChild.AmountPartnerPromo, 0)
                       THEN 0

                  -- ИТОГО: РЕЗУЛЬТАТ БЕЗ ПР-ВА < 0, т.е. ждем Приход с пр-ва и его пакуем
                  WHEN 0 > tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0) + 0
                         - COALESCE (tmpChild.AmountPartnerPrior, 0) - COALESCE (tmpChild.AmountPartnerPriorPromo, 0) - COALESCE (tmpChild.AmountPartner, 0) - COALESCE (tmpChild.AmountPartnerPromo, 0)
                       THEN -1

                  -- упакованой продукции не хватает
                  WHEN tmpChild_find.GoodsId > 0
                       THEN -2

                  -- есть остаток и его есть куда паковать (т.е. все нормально со статистикой)
                  WHEN tmpMI.Remains > 0 AND (tmpChild.CountForecast > 0 OR tmpChild.CountForecastOrder > 0)
                       THEN 1

                  -- будет приход с пр-ва и его есть куда паковать (т.е. все нормально со статистикой)
                  WHEN CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH ELSE COALESCE (tmpCEH.Remains_CEH, 0) END > 0
                   AND (tmpChild.CountForecast > 0 OR tmpChild.CountForecastOrder > 0)
                       THEN 2

                  -- есть Остаток или Приход, но НЕТ статистики
                  WHEN (tmpMI.Remains > 0 OR tmpChild.Remains_pack > 0
                     OR CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH ELSE COALESCE (tmpCEH.Remains_CEH, 0) END > 0
                       )
                   AND COALESCE (tmpChild.CountForecast, 0) = 0 AND COALESCE (tmpChild.CountForecastOrder, 0) = 0
                       THEN 44
                  -- НЕТ Остатка или НЕТ Прихода, но ЕСТЬ статистика
                  WHEN tmpMI.Remains = 0 AND COALESCE (tmpChild.Remains_pack, 0) = 0
                   AND CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH ELSE COALESCE (tmpCEH.Remains_CEH, 0) END = 0
                   AND (tmpChild.CountForecast > 0 OR tmpChild.CountForecastOrder > 0)
                       THEN 55

                  -- ВСЕ ОК - есть Остаток УПАКОВАННОЙ и ЕСТЬ статистика
                  WHEN tmpChild.Remains_pack > 0
                   AND (tmpChild.CountForecast > 0 OR tmpChild.CountForecastOrder > 0)
                       THEN 88

                  ELSE 100
             END  :: Integer AS Num

             -- Приход пр-во (ФАКТ)
           , tmpIncome.Income_CEH    :: TFloat AS Income_CEH
             -- ФАКТ - Перемещение на Цех Упаковки
           , tmpChild.Income_PACK_to
             -- ФАКТ - Перемещение с Цеха Упаковки
           , tmpChild.Income_PACK_from

             -- Ост. нач. - НЕ упак.
           , tmpMI.Remains
             -- Ост. начальн. - упакованный
           , COALESCE (tmpChild.Remains_pack, 0) :: TFloat AS Remains_pack -- tmpMI.Remains_pack
           , COALESCE (tmpChild.RemainsRK, 0)    :: TFloat AS RemainsRK    -- 

             -- Ост. начальн. - произв. (СЕГОДНЯ)
           , CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH      ELSE tmpCEH.Remains_CEH      END :: TFloat AS Remains_CEH
             -- Ост. начальн. - произв. (ПОЗЖЕ)
           , CASE WHEN tmpMI.ContainerId > 0 THEN tmpMI.Remains_CEH_Next ELSE tmpCEH.Remains_CEH_Next END :: TFloat AS Remains_CEH_Next

              -- неотгуж. заявка
           , CAST (COALESCE (tmpChild.AmountPartnerPrior, 0)       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (COALESCE (tmpChild.AmountPartnerPriorPromo, 0)  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorPromo
           , CAST (COALESCE (tmpChild.AmountPartnerPrior, 0) + COALESCE (tmpChild.AmountPartnerPriorPromo, 0) AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorTotal

            -- сегодня заявка
           , CAST (COALESCE (tmpChild.AmountPartner, 0)            AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (COALESCE (tmpChild.AmountPartnerNext, 0)        AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerNext
           , CAST (COALESCE (tmpChild.AmountPartnerPromo, 0)       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromo
           , CAST (COALESCE (tmpChild.AmountPartnerNextPromo, 0)   AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerNextPromo
           , CAST (COALESCE (tmpChild.AmountPartner, 0) + COALESCE (tmpChild.AmountPartnerPromo, 0) AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerTotal

            -- Прогноз по прод.
           , CASE WHEN ABS (tmpChild.AmountForecast) < 1           THEN tmpChild.AmountForecast           ELSE CAST (COALESCE (tmpChild.AmountForecast, 0)           AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast
           , CASE WHEN ABS (tmpChild.AmountForecastPromo) < 1      THEN tmpChild.AmountForecastPromo      ELSE CAST (COALESCE (tmpChild.AmountForecastPromo, 0)      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastPromo
             -- Прогноз по заяв.
           , CASE WHEN ABS (tmpChild.AmountForecastOrder) < 1      THEN tmpChild.AmountForecastOrder      ELSE CAST (COALESCE (tmpChild.AmountForecastOrder, 0)      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder
           , CASE WHEN ABS (tmpChild.AmountForecastOrderPromo) < 1 THEN tmpChild.AmountForecastOrderPromo ELSE CAST (COALESCE (tmpChild.AmountForecastOrderPromo, 0) AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrderPromo

           -- *** факт
           , CAST (COALESCE (tmpChild.AmountPrIn, 0)               AS NUMERIC (16, 2)) :: TFloat AS AmountPrIn
           , CAST (COALESCE (tmpChild.AmountPartnerOld, 0)         AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerOld
           , CAST (COALESCE (tmpChild.AmountPartnerPromoOld, 0)    AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromoOld
           , CAST (COALESCE (tmpChild.AmountPartnerOld, 0) + COALESCE (tmpChild.AmountPartnerPromoOld, 0) AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerOldTotal

             -- Норм 1д (по пр.) без К
           , COALESCE (tmpChild.CountForecast, 0)      :: TFloat AS CountForecastOrder
             -- Норм 1д (по зв.) без К
           , COALESCE (tmpChild.CountForecastOrder, 0) :: TFloat AS CountForecastOrder

             -- "средняя" за 1 день - продажа ИЛИ заявака
           , tmpChild.Plan1, tmpChild.Plan2, tmpChild.Plan3, tmpChild.Plan4, tmpChild.Plan5, tmpChild.Plan6, tmpChild.Plan7
             -- "средняя" за 1 день - акции - прогноз
           , tmpChild.Promo1, tmpChild.Promo2, tmpChild.Promo3, tmpChild.Promo4, tmpChild.Promo5, tmpChild.Promo6, tmpChild.Promo7

              -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN tmpChild.CountForecast > 0
                             THEN (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0)
                                  ) / tmpChild.CountForecast
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast
             -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN tmpChild.CountForecastOrder > 0
                             THEN (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0)
                                  ) / tmpChild.CountForecastOrder
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

             -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
           , CAST (CASE WHEN tmpChild.CountForecast > 0
                             THEN (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0) + COALESCE (tmpChild.AmountPack, 0) + COALESCE (tmpChild.AmountPackSecond, 0) + COALESCE (tmpChild.AmountPackNext, 0) + COALESCE (tmpChild.AmountPackNextSecond, 0)
                                 - tmpMI.Amount - tmpMI.AmountNext
                                 - COALESCE (tmpChild.AmountPartnerPrior, 0) - COALESCE (tmpChild.AmountPartnerPriorPromo, 0)
                                 - COALESCE (tmpChild.AmountPartner, 0)      - COALESCE (tmpChild.AmountPartnerPromo, 0)
                                  ) / tmpChild.CountForecast
                        WHEN tmpChild.CountForecastOrder > 0
                             THEN (tmpMI.Remains + COALESCE (tmpChild.Remains_pack, 0) + COALESCE (tmpChild.AmountPack, 0) + COALESCE (tmpChild.AmountPackSecond, 0) + COALESCE (tmpChild.AmountPackNext, 0) + COALESCE (tmpChild.AmountPackNextSecond, 0)
                                 - tmpMI.Amount - tmpMI.AmountNext
                                 - COALESCE (tmpChild.AmountPartnerPrior, 0) - COALESCE (tmpChild.AmountPartnerPriorPromo, 0)
                                 - COALESCE (tmpChild.AmountPartner, 0)      - COALESCE (tmpChild.AmountPartnerPromo, 0)
                                  ) / tmpChild.CountForecastOrder
                        ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast_calc

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis
           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName

           , tmpMI.isErased

       FROM tmpMI
            -- Приход пр-во (ФАКТ)
            FULL JOIN tmpIncome
                   ON tmpIncome.GoodsId     = tmpMI.GoodsId
                  AND tmpIncome.GoodsKindId = tmpMI.GoodsKindId

            -- Ост. на произв-ве
            LEFT JOIN tmpCEH
                   ON tmpCEH.GoodsId                = tmpMI.GoodsId_basis
                  AND tmpCEH.GoodsKindCompleteId_pf = tmpMI.GoodsKindId
            -- Итого по данным из Курсора-2
            LEFT JOIN tmpChild
                   ON tmpChild.GoodsId              = COALESCE (tmpMI.GoodsId, tmpIncome.GoodsId)
                  AND tmpChild.GoodsKindId          = COALESCE (tmpMI.GoodsKindId, tmpIncome.GoodsKindId)
            -- Итого по данным из Курсора-2
            LEFT JOIN tmpChild_find
                   ON tmpChild_find.GoodsId         = COALESCE (tmpMI.GoodsId, tmpIncome.GoodsId)
                  AND tmpChild_find.GoodsKindId     = COALESCE (tmpMI.GoodsKindId, tmpIncome.GoodsKindId)


            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = tmpMI.GoodsId_basis
            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = COALESCE (tmpMI.GoodsId, tmpIncome.GoodsId)
            LEFT JOIN Object AS Object_GoodsKind   ON Object_GoodsKind.Id   = COALESCE (tmpMI.GoodsKindId, tmpIncome.GoodsKindId)

            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (tmpMI.MeasureId, tmpIncome.MeasureId)

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_basis
                                 ON ObjectLink_Goods_Measure_basis.ObjectId = Object_Goods_basis.Id
                                AND ObjectLink_Goods_Measure_basis.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_basis ON Object_Measure_basis.Id = ObjectLink_Goods_Measure_basis.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods_basis.Id
                                AND ObjectLink_OrderType_Goods.DescId        = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId   = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderType_Unit.ChildObjectId
      ;


        -- Результат - Child
        CREATE TEMP TABLE _Result_Child (Id                          Integer
                                        , ContainerId                Integer
                                        , KeyId                      TVarChar
                                        , GoodsId                    Integer
                                        , GoodsCode                  Integer
                                        , GoodsName                  TVarChar
                                        , GoodsId_basis              Integer
                                        , GoodsCode_basis            Integer
                                        , GoodsName_basis            TVarChar
                                        , GoodsKindId                Integer
                                        , GoodsKindName              TVarChar
                                        , GoodsId_complete           Integer
                                        , GoodsKindId_complete       Integer
                                        , MeasureId                  Integer
                                        , MeasureName                TVarChar
                                        , MeasureName_basis          TVarChar
                                        , GoodsGroupNameFull         TVarChar

                                        , AmountPack                 TFloat
                                        , AmountPackSecond           TFloat
                                        , AmountPackTotal            TFloat

                                        , AmountPack_calc            TFloat
                                        , AmountSecondPack_calc      TFloat
                                        , AmountPackTotal_calc       TFloat

                                        , AmountPackNext             TFloat
                                        , AmountPackNextSecond       TFloat
                                        , AmountPackNextTotal        TFloat

                                        , AmountPackNext_calc        TFloat
                                        , AmountPackNextSecond_calc  TFloat
                                        , AmountPackNextTotal_calc   TFloat

                                        , AmountPackAllTotal         TFloat
                                        , AmountPackAllTotal_calc    TFloat

                                        , Amount_result_two          TFloat
                                        , Amount_result_pack         TFloat
                                        , Amount_result_pack_pack    TFloat

                                        , Income_PACK_to             TFloat
                                        , Income_PACK_from           TFloat

                                        , Remains                    TFloat
                                        , Remains_pack               TFloat
                                        , RemainsRK                  TFloat

                                        , AmountPartnerPrior         TFloat
                                        , AmountPartnerPriorPromo    TFloat
                                        , AmountPartnerPriorTotal    TFloat
                                        , AmountPartner              TFloat
                                        , AmountPartnerNext          TFloat
                                        , AmountPartnerPromo         TFloat
                                        , AmountPartnerNextPromo     TFloat
                                        , AmountPartnerTotal         TFloat
                                        , AmountForecast             TFloat
                                        , AmountForecastPromo        TFloat
                                        , AmountForecastOrder        TFloat
                                        , AmountForecastOrderPromo   TFloat

                                        , AmountPrIn                 TFloat
                                        , AmountPartnerOld           TFloat
                                        , AmountPartnerPromoOld      TFloat
                                        , AmountPartnerOldTotal      TFloat

                                        , CountForecast              TFloat
                                        , CountForecastOrder         TFloat

                                        , Plan1 TFloat, Plan2 TFloat, Plan3 TFloat, Plan4 TFloat, Plan5 TFloat, Plan6 TFloat, Plan7 TFloat
                                        , Promo1 TFloat, Promo2 TFloat, Promo3 TFloat, Promo4 TFloat, Promo5 TFloat, Promo6 TFloat, Promo7 TFloat

                                        , DayCountForecast           TFloat  --
                                        , DayCountForecastOrder      TFloat
                                        , DayCountForecast_calc      TFloat

                                        , Amount_master              TFloat
                                        , AmountNext_master          TFloat

                                        , ReceiptId                  Integer
                                        , ReceiptCode                TVarChar
                                        , ReceiptName                TVarChar
                                        , ReceiptId_basis            Integer
                                        , ReceiptCode_basis          TVarChar
                                        , ReceiptName_basis          TVarChar
                                        , isErased                   Boolean) ON COMMIT DROP;
          -- Результат - Child
          INSERT INTO _Result_Child (Id, ContainerId
                                        , KeyId
                                        , GoodsId
                                        , GoodsCode
                                        , GoodsName
                                        , GoodsKindId
                                        , GoodsKindName

                                        , GoodsId_complete
                                        , GoodsKindId_complete

                                        , MeasureId
                                        , MeasureName
                                        , GoodsGroupNameFull

                                        , AmountPack
                                        , AmountPackSecond
                                        , AmountPackTotal

                                        , AmountPack_calc
                                        , AmountSecondPack_calc
                                        , AmountPackTotal_calc

                                        , AmountPackNext
                                        , AmountPackNextSecond
                                        , AmountPackNextTotal

                                        , AmountPackNext_calc
                                        , AmountPackNextSecond_calc
                                        , AmountPackNextTotal_calc

                                        , AmountPackAllTotal
                                        , AmountPackAllTotal_calc

                                        , Amount_result_two
                                        , Amount_result_pack
                                        , Amount_result_pack_pack

                                        , Income_PACK_to
                                        , Income_PACK_from

                                        , Remains
                                        , Remains_pack
                                        , RemainsRK

                                        , AmountPartnerPrior
                                        , AmountPartnerPriorPromo
                                        , AmountPartnerPriorTotal
                                        , AmountPartner
                                        , AmountPartnerNext
                                        , AmountPartnerPromo
                                        , AmountPartnerNextPromo
                                        , AmountPartnerTotal
                                        , AmountForecast
                                        , AmountForecastPromo
                                        , AmountForecastOrder
                                        , AmountForecastOrderPromo

                                        , AmountPrIn
                                        , AmountPartnerOld
                                        , AmountPartnerPromoOld
                                        , AmountPartnerOldTotal

                                        , CountForecast
                                        , CountForecastOrder

                                        , Plan1, Plan2, Plan3, Plan4, Plan5, Plan6, Plan7
                                        , Promo1, Promo2, Promo3, Promo4, Promo5, Promo6, Promo7

                                        , DayCountForecast
                                        , DayCountForecastOrder
                                        , DayCountForecast_calc

                                        , Amount_master
                                        , AmountNext_master

                                        , ReceiptId
                                        , ReceiptCode
                                        , ReceiptName
                                        , ReceiptId_basis
                                        , ReceiptCode_basis
                                        , ReceiptName_basis
                                        , isErased  )

       -- Результат - Child
       WITH -- то что в Мастере (факт Расход на упаковку)
            tmpMI_master AS (SELECT *
                             FROM _tmpMI_All
                             WHERE _tmpMI_All.GoodsId_complete = 0 -- т.е. НЕ упакованный
                               AND _tmpMI_All.ContainerId      = 0 -- отбросили остатки на ПР-ВЕ
                               AND (_tmpMI_All.Amount          > 0
                                 OR _tmpMI_All.AmountNext      > 0
                                   )
                            )
            -- ФАКТ - Перемещение на / с - Цеха Упаковки
          , tmpPACK AS (SELECT _tmpMI_All.GoodsId
                             , _tmpMI_All.GoodsKindId
                             , SUM (_tmpMI_All.Income_PACK_to)   AS Income_PACK_to
                             , SUM (_tmpMI_All.Income_PACK_from) AS Income_PACK_from
                        FROM _tmpMI_All
                        WHERE _tmpMI_All.Income_PACK_to <> 0 OR _tmpMI_All.Income_PACK_from <> 0
                        GROUP BY _tmpMI_All.GoodsId
                               , _tmpMI_All.GoodsKindId
                       )
       -- Данные - Child
       SELECT
             tmpMI.MovementItemId   AS Id
           , tmpMI.ContainerId      AS ContainerId
           , CASE WHEN tmpMI.GoodsId_complete = 0
                       THEN tmpMI.GoodsId :: TVarChar || '_' || tmpMI.GoodsKindId :: TVarChar
                  ELSE tmpMI.GoodsId_complete :: TVarChar || '_' || tmpMI.GoodsKindId_complete :: TVarChar
             END  :: TVarChar AS KeyId
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           
           , tmpMI.GoodsId_complete
           , tmpMI.GoodsKindId_complete

           , Object_Measure.Id                   AS MeasureId
           , Object_Measure.ValueData            AS MeasureName

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , tmpMI.AmountPack                            :: TFloat AS AmountPack         -- ***План для упаковки (с остатка, факт)
           , tmpMI.AmountPackSecond                      :: TFloat AS AmountPackSecond   -- ***План для упаковки (с прихода с пр-ва, факт)
           , (tmpMI.AmountPack + tmpMI.AmountPackSecond) :: TFloat AS AmountPackTotal    -- ***План для упаковки (ИТОГО, факт)

           , tmpMI.AmountPack_calc                                 :: TFloat AS AmountPack_calc         -- ***План для упаковки (с остатка, расчет)
           , tmpMI.AmountPackSecond_calc                           :: TFloat AS AmountSecondPack_calc   -- ***План для упаковки (с прихода с пр-ва, расчет)
           , (tmpMI.AmountPack_calc + tmpMI.AmountPackSecond_calc) :: TFloat AS AmountPackTotal_calc    -- ***План для упаковки(ИТОГО, расчет)

           , tmpMI.AmountPackNext                                :: TFloat AS AmountPackNext
           , tmpMI.AmountPackNextSecond                          :: TFloat AS AmountPackNextSecond
           , (tmpMI.AmountPackNext + tmpMI.AmountPackNextSecond) :: TFloat AS AmountPackNextTotal

           , tmpMI.AmountPackNext_calc                                     :: TFloat AS AmountPackNext_calc
           , tmpMI.AmountPackNextSecond_calc                               :: TFloat AS AmountPackNextSecond_calc
           , (tmpMI.AmountPackNext_calc + tmpMI.AmountPackNextSecond_calc) :: TFloat AS AmountPackNextTotal_calc

             -- *** итого План1 + План2 ПР-ВО на УПАК
           , (tmpMI.AmountPack + tmpMI.AmountPackSecond + tmpMI.AmountPackNext + tmpMI.AmountPackNextSecond)                     :: TFloat AS AmountPackAllTotal
           , (tmpMI.AmountPack_calc + tmpMI.AmountPackSecond_calc + tmpMI.AmountPackNext_calc + tmpMI.AmountPackNextSecond_calc) :: TFloat AS AmountPackAllTotal_calc

           -- Amount_result
           -- , CAST (tmpMI.Remains + tmpMI.Remains_pack + tmpMI.Remains_CEH - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo AS NUMERIC (16, 1)) :: TFloat AS Amount_result
           -- Amount_result_two
           , CAST (tmpMI.Remains + tmpMI.Remains_pack + 0                    - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo AS NUMERIC (16, 1)) :: TFloat AS Amount_result_two
             -- Amount_result_pack
           , CAST (tmpMI.Remains + tmpMI.Remains_pack + 0                    - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo
                 - COALESCE (tmpMI_master.Amount, 0) - COALESCE (tmpMI_master.AmountNext, 0)
                 + tmpMI.AmountPack + tmpMI.AmountPackSecond + tmpMI.AmountPackNext + tmpMI.AmountPackNextSecond
                   AS NUMERIC (16, 1)) :: TFloat AS Amount_result_pack
             -- Amount_result_pack_pack
           , CAST (tmpMI.Remains + tmpMI.Remains_pack + 0                    - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo
                 - COALESCE (tmpMI_master.Amount, 0) - COALESCE (tmpMI_master.AmountNext, 0)
                 + tmpMI.AmountPack_calc + tmpMI.AmountPackSecond_calc + tmpMI.AmountPackNext_calc + tmpMI.AmountPackNextSecond_calc
                   AS NUMERIC (16, 1)) :: TFloat AS Amount_result_pack_pack

             -- ФАКТ - Перемещение на Цех Упаковки
           , tmpPACK.Income_PACK_to   :: TFloat AS Income_PACK_to
             -- ФАКТ - Перемещение с Цеха Упаковки
           , tmpPACK.Income_PACK_from :: TFloat AS Income_PACK_from
             -- Ост. начальн. - НЕ упакованный
           , (tmpMI.Remains - COALESCE (tmpMI_master.Amount, 0) - COALESCE (tmpMI_master.AmountNext, 0)) :: TFloat AS Remains
             -- Ост. нач. - упакованный
           , tmpMI.Remains_pack
             -- Ост. нач. - упакованный
           , tmpMI.RemainsRK

              -- неотгуж. заявка
           , CAST (tmpMI.AmountPartnerPrior       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (tmpMI.AmountPartnerPriorPromo  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorPromo
           , CAST (tmpMI.AmountPartnerPrior + tmpMI.AmountPartnerPriorPromo AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorTotal
            -- сегодня заявка
           , CAST (tmpMI.AmountPartner            AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (tmpMI.AmountPartnerNext        AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerNext
           , CAST (tmpMI.AmountPartnerPromo       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromo
           , CAST (tmpMI.AmountPartnerNextPromo   AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerNextPromo
           , CAST (tmpMI.AmountPartner + tmpMI.AmountPartnerPromo AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerTotal

            -- Прогноз по прод.
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1           THEN tmpMI.AmountForecast           ELSE CAST (tmpMI.AmountForecast           AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast
           , CASE WHEN ABS (tmpMI.AmountForecastPromo) < 1      THEN tmpMI.AmountForecastPromo      ELSE CAST (tmpMI.AmountForecastPromo      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastPromo
             -- Прогноз по заяв.
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1      THEN tmpMI.AmountForecastOrder      ELSE CAST (tmpMI.AmountForecastOrder      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder
           , CASE WHEN ABS (tmpMI.AmountForecastOrderPromo) < 1 THEN tmpMI.AmountForecastOrderPromo ELSE CAST (tmpMI.AmountForecastOrderPromo AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrderPromo

           , CAST (tmpMI.AmountPrIn               AS NUMERIC (16, 2)) :: TFloat AS AmountPrIn
           , CAST (tmpMI.AmountPartnerOld         AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerOld
           , CAST (tmpMI.AmountPartnerPromoOld    AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromoOld
           , CAST (COALESCE (tmpMI.AmountPartnerOld,0) + COALESCE (tmpMI.AmountPartnerPromoOld,0)  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerOldTotal

             -- Норм 1д (по пр.) без К
           , tmpMI.CountForecast
             -- Норм 1д (по зв.) без К
           , tmpMI.CountForecastOrder

             -- "средняя" за 1 день - продажа ИЛИ заявака
           , tmpMI.Plan1, tmpMI.Plan2, tmpMI.Plan3, tmpMI.Plan4, tmpMI.Plan5, tmpMI.Plan6, tmpMI.Plan7
             -- "средняя" за 1 день - акции - прогноз
           , tmpMI.Promo1, tmpMI.Promo2, tmpMI.Promo3, tmpMI.Promo4, tmpMI.Promo5, tmpMI.Promo6, tmpMI.Promo7

              -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN tmpMI.CountForecast > 0
                             THEN (tmpMI.Remains + tmpMI.Remains_pack - COALESCE (tmpMI_master.Amount, 0) - COALESCE (tmpMI_master.AmountNext, 0)) / tmpMI.CountForecast
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast
             -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0
                             THEN (tmpMI.Remains + tmpMI.Remains_pack - COALESCE (tmpMI_master.Amount, 0) - COALESCE (tmpMI_master.AmountNext, 0)) / tmpMI.CountForecastOrder
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

             -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
           , CAST (CASE WHEN tmpMI.CountForecast > 0
                             THEN (tmpMI.Remains + tmpMI.Remains_pack + tmpMI.AmountPack + tmpMI.AmountPackSecond + tmpMI.AmountPackNext + tmpMI.AmountPackNextSecond
                                 - COALESCE (tmpMI_master.Amount, 0) - COALESCE (tmpMI_master.AmountNext, 0)
                                 - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo
                                 - tmpMI.AmountPartner      - tmpMI.AmountPartnerPromo
                                  ) / tmpMI.CountForecast
                        WHEN tmpMI.CountForecastOrder > 0
                             THEN (tmpMI.Remains + tmpMI.Remains_pack + tmpMI.AmountPack + tmpMI.AmountPackSecond + tmpMI.AmountPackNext + tmpMI.AmountPackNextSecond
                                 - COALESCE (tmpMI_master.Amount, 0) - COALESCE (tmpMI_master.AmountNext, 0)
                                 - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo
                                 - tmpMI.AmountPartner      - tmpMI.AmountPartnerPromo
                                  ) / tmpMI.CountForecastOrder
                        ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast_calc
             
           , COALESCE (tmpMI_master.Amount, 0)         AS Amount_master
           , COALESCE (tmpMI_master.AmountNext, 0)     AS AmountNext_master

           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis

           , tmpMI.isErased

       FROM _tmpMI_All AS tmpMI

            LEFT JOIN tmpMI_master ON tmpMI_master.GoodsId     = tmpMI.GoodsId
                                  AND tmpMI_master.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN tmpPACK ON tmpPACK.GoodsId     = tmpMI.GoodsId
                             AND tmpPACK.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind   ON Object_GoodsKind.Id   = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = tmpMI.MeasureId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
        WHERE tmpMI.Income_CEH       = 0 -- отбросили Приход пр-во (ФАКТ)
          AND tmpMI.Income_PACK_to   = 0 -- отбросили Перемещение на Цех Упаковки
          AND tmpMI.Income_PACK_from = 0 -- отбросили Перемещение с Цеха Упаковки
          AND tmpMI.ContainerId      = 0 -- отбросили остатки на ПР-ВЕ

       ;

     -- Результат - ChildTotal
     CREATE TEMP TABLE _Result_ChildTotal (Id                         Integer
                                         , ContainerId                Integer
                                         , GoodsId                    Integer
                                         , GoodsCode                  Integer
                                         , GoodsName                  TVarChar
                                         , GoodsId_complete           Integer
                                         , GoodsCode_complete         Integer
                                         , GoodsName_complete         TVarChar
                                         , GoodsId_basis              Integer
                                         , GoodsCode_basis            Integer
                                         , GoodsName_basis            TVarChar
                                         , GoodsKindId                Integer
                                         , GoodsKindName              TVarChar
                                         , GoodsKindId_complete       Integer
                                         , GoodsKindName_complete     TVarChar
                                         , MeasureId                  Integer
                                         , MeasureName                TVarChar
                                         , MeasureName_complete       TVarChar
                                         , MeasureName_basis          TVarChar
                                         , GoodsGroupNameFull         TVarChar
                                         , isCheck_basis              Boolean

                                         , Amount                     TFloat
                                         , AmountSecond               TFloat
                                         , AmountTotal                TFloat

                                         , AmountPack                 TFloat
                                         , AmountPackSecond           TFloat
                                         , AmountPackTotal            TFloat

                                         , AmountPack_calc            TFloat
                                         , AmountSecondPack_calc      TFloat
                                         , AmountPackTotal_calc       TFloat

                                         , AmountNext                 TFloat
                                         , AmountNextSecond           TFloat
                                         , AmountNextTotal            TFloat

                                         , AmountPackNext             TFloat
                                         , AmountPackNextSecond       TFloat
                                         , AmountPackNextTotal        TFloat

                                         , AmountPackNext_calc        TFloat
                                         , AmountPackNextSecond_calc  TFloat
                                         , AmountPackNextTotal_calc   TFloat

                                         , Amount_result              TFloat
                                         , Amount_result_two          TFloat
                                         , Amount_result_pack         TFloat

                                         , Income_CEH                 TFloat
                                         , Income_PACK_to             TFloat
                                         , Income_PACK_from           TFloat

                                         , Remains_CEH                TFloat
                                         , Remains_CEH_Next           TFloat
                                         , Remains_CEH_err            TFloat
                                         , Remains                    TFloat
                                         , Remains_pack               TFloat
                                         , Remains_err                TFloat
                                         , RemainsRK                  TFloat

                                         , AmountPartnerPrior         TFloat
                                         , AmountPartnerPriorPromo    TFloat
                                         , AmountPartnerPriorTotal    TFloat

                                         , AmountPartner              TFloat
                                         , AmountPartnerNext          TFloat
                                         , AmountPartnerPromo         TFloat
                                         , AmountPartnerNextPromo     TFloat
                                         , AmountPartnerTotal         TFloat

                                         , AmountForecast             TFloat
                                         , AmountForecastPromo        TFloat
                                         , AmountForecastOrder        TFloat
                                         , AmountForecastOrderPromo   TFloat

                                         , AmountPrIn                 TFloat
                                         , AmountPartnerOld           TFloat
                                         , AmountPartnerPromoOld      TFloat
                                         , AmountPartnerOldTotal      TFloat

                                         , CountForecast              TFloat
                                         , CountForecastOrder         TFloat

                                         , Plan1 TFloat, Plan2 TFloat, Plan3 TFloat, Plan4 TFloat, Plan5 TFloat, Plan6 TFloat, Plan7 TFloat
                                         , Promo1 TFloat, Promo2 TFloat, Promo3 TFloat, Promo4 TFloat, Promo5 TFloat, Promo6 TFloat, Promo7 TFloat

                                         , DayCountForecast           TFloat
                                         , DayCountForecastOrder      TFloat
                                         , DayCountForecast_calc      TFloat

                                         , ReceiptId                  Integer
                                         , ReceiptCode                TVarChar
                                         , ReceiptName                TVarChar
                                         , ReceiptId_basis            Integer
                                         , ReceiptCode_basis          TVarChar
                                         , ReceiptName_basis          TVarChar
                                         , UnitId                     Integer
                                         , UnitCode                   Integer
                                         , UnitName                   TVarChar
                                         , GoodsKindName_pf           TVarChar
                                         , GoodsKindCompleteName_pf   TVarChar
                                         , PartionDate_pf             TVarChar
                                         , PartionGoods_start         TVarChar
                                         , TermProduction             TVarChar
                                         , isErased                   Boolean
                                          ) ON COMMIT DROP;
      -- Результат - ChildTotal
      INSERT INTO _Result_ChildTotal (Id, ContainerId
                                    , GoodsId
                                    , GoodsCode
                                    , GoodsName
                                    , GoodsId_complete
                                    , GoodsCode_complete
                                    , GoodsName_complete
                                    , GoodsId_basis
                                    , GoodsCode_basis
                                    , GoodsName_basis
                                    , GoodsKindId
                                    , GoodsKindName
                                    , GoodsKindId_complete
                                    , GoodsKindName_complete
                                    , MeasureId
                                    , MeasureName
                                    , MeasureName_complete
                                    , MeasureName_basis
                                    , GoodsGroupNameFull
                                    , isCheck_basis

                                    , Amount
                                    , AmountSecond
                                    , AmountTotal

                                    , AmountPack
                                    , AmountPackSecond
                                    , AmountPackTotal

                                    , AmountPack_calc
                                    , AmountSecondPack_calc
                                    , AmountPackTotal_calc

                                    , AmountNext
                                    , AmountNextSecond
                                    , AmountNextTotal

                                    , AmountPackNext
                                    , AmountPackNextSecond
                                    , AmountPackNextTotal

                                    , AmountPackNext_calc
                                    , AmountPackNextSecond_calc
                                    , AmountPackNextTotal_calc	

                                    , Amount_result
                                    , Amount_result_two
                                    , Amount_result_pack

                                    , Income_CEH
                                    , Income_PACK_to
                                    , Income_PACK_from

                                    , Remains_CEH
                                    , Remains_CEH_Next
                                    , Remains_CEH_err

                                    , Remains
                                    , Remains_pack
                                    , Remains_err
                                    , RemainsRK

                                    , AmountPartnerPrior
                                    , AmountPartnerPriorPromo
                                    , AmountPartnerPriorTotal

                                    , AmountPartner
                                    , AmountPartnerNext
                                    , AmountPartnerPromo
                                    , AmountPartnerNextPromo
                                    , AmountPartnerTotal

                                    , AmountForecast
                                    , AmountForecastPromo
                                    , AmountForecastOrder
                                    , AmountForecastOrderPromo

                                    , AmountPrIn
                                    , AmountPartnerOld
                                    , AmountPartnerPromoOld
                                    , AmountPartnerOldTotal

                                    , CountForecast
                                    , CountForecastOrder

                                    , Plan1, Plan2, Plan3, Plan4, Plan5, Plan6, Plan7
                                    , Promo1, Promo2, Promo3, Promo4, Promo5, Promo6, Promo7

                                    , DayCountForecast
                                    , DayCountForecastOrder
                                    , DayCountForecast_calc

                                    , ReceiptId
                                    , ReceiptCode
                                    , ReceiptName
                                    , ReceiptId_basis
                                    , ReceiptCode_basis
                                    , ReceiptName_basis
                                    , UnitId
                                    , UnitCode
                                    , UnitName
                                    , GoodsKindName_pf
                                    , GoodsKindCompleteName_pf
                                    , PartionDate_pf
                                    , PartionGoods_start
                                    , TermProduction
                                    , isErased
                                     )
      -- Результат - ChildTotal
      SELECT
             tmpMI.MovementItemId   AS Id
           , tmpMI.ContainerId      AS ContainerId

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName

           , Object_Goods_complete.Id            AS GoodsId_complete
           , Object_Goods_complete.ObjectCode    AS GoodsCode_complete
           , Object_Goods_complete.ValueData     AS GoodsName_complete

           , Object_Goods_basis.Id               AS GoodsId_basis
           , Object_Goods_basis.ObjectCode       AS GoodsCode_basis
           , Object_Goods_basis.ValueData        AS GoodsName_basis

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKind_complete.Id        AS GoodsKindId_complete
           , Object_GoodsKind_complete.ValueData AS GoodsKindName_complete

           , Object_Measure.Id                   AS MeasureId
           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_complete.ValueData   AS MeasureName_complete
           , Object_Measure_basis.ValueData      AS MeasureName_basis

           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId_complete = 0 AND tmpMI.GoodsId <> tmpMI.GoodsId_basis AND tmpMI.GoodsId_basis > 0
                       THEN TRUE
                  WHEN tmpMI.GoodsId_complete <> tmpMI.GoodsId_basis AND tmpMI.GoodsId_basis > 0
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isCheck_basis

           , tmpMI.Amount                        :: TFloat AS Amount        -- ***План1 выдали с Ост. на УПАК
           , tmpMI.AmountSecond                  :: TFloat AS AmountSecond  -- ***План1 выдали с Цеха на УПАК
           , (tmpMI.Amount + tmpMI.AmountSecond) :: TFloat AS AmountTotal   -- ***План1 ИТОГО выдали на УПАК

           , tmpMI.AmountPack                            :: TFloat AS AmountPack         -- ***План1 заказ факт (с Ост.) - Приход с УПАК
           , tmpMI.AmountPackSecond                      :: TFloat AS AmountPackSecond   -- ***План1 заказ факт (с Цеха) - Приход с УПАК
           , (tmpMI.AmountPack + tmpMI.AmountPackSecond) :: TFloat AS AmountPackTotal    -- ***План1 ИТОГО заказ факт - Приход с УПАК

           , tmpMI.AmountPack_calc                                 :: TFloat AS AmountPack_calc         -- ***План1 заказ расч. (с Ост.) - Приход с УПАК
           , tmpMI.AmountPackSecond_calc                           :: TFloat AS AmountSecondPack_calc   -- ***План1 заказ расч. (с Цеха) - Приход с УПАК
           , (tmpMI.AmountPack_calc + tmpMI.AmountPackSecond_calc) :: TFloat AS AmountPackTotal_calc    -- ***План1 ИТОГО заказ расч. - Приход с УПАК

           , tmpMI.AmountNext                                              :: TFloat AS AmountNext        -- ***План2 выдали с Ост. на УПАК
           , tmpMI.AmountNextSecond                                        :: TFloat AS AmountNextSecond  -- ***План2 выдали с Цеха на УПАК
           , (tmpMI.AmountNext + tmpMI.AmountNextSecond)                   :: TFloat AS AmountNextTotal   -- ***План2 ИТОГО выдали на УПАК

           , tmpMI.AmountPackNext                                          :: TFloat AS AmountPackNext       -- ***План2 заказ факт (с Ост.) - Приход с УПАК
           , tmpMI.AmountPackNextSecond                                    :: TFloat AS AmountPackNextSecond -- ***План2 заказ факт (с Цеха) - Приход с УПАК
           , (tmpMI.AmountPackNext + tmpMI.AmountPackNextSecond)           :: TFloat AS AmountPackNextTotal  -- ***План2 ИТОГО заказ факт - Приход с УПАК

           , tmpMI.AmountPackNext_calc                                     :: TFloat AS AmountPackNext_calc       -- ***План2 заказ расч. (с Ост.) - Приход с УПАК
           , tmpMI.AmountPackNextSecond_calc                               :: TFloat AS AmountPackNextSecond_calc -- ***План2 заказ расч. (с Цеха) - Приход с УПАК
           , (tmpMI.AmountPackNext_calc + tmpMI.AmountPackNextSecond_calc) :: TFloat AS AmountPackNextTotal_calc  -- ***План2 ИТОГО заказ расч. - Приход с УПАК

             -- РЕЗУЛЬТАТ c пр-вом
           , CAST (tmpMI.Remains + tmpMI.Remains_pack + tmpMI.Remains_CEH - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo AS NUMERIC (16, 1)) :: TFloat AS Amount_result
             -- РЕЗУЛЬТАТ без пр-ва
           , CAST (tmpMI.Remains + tmpMI.Remains_pack + 0                 - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo AS NUMERIC (16, 1)) :: TFloat AS Amount_result_two
             -- РЕЗУЛЬТАТ ***УПАК
           , CAST (tmpMI.Remains + tmpMI.Remains_pack + 0                 - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo - tmpMI.AmountPartner - tmpMI.AmountPartnerPromo
                 - tmpMI.Amount - tmpMI.AmountNext
                 + tmpMI.AmountPack + tmpMI.AmountPackSecond + tmpMI.AmountPackNext + tmpMI.AmountPackNextSecond
                   AS NUMERIC (16, 1)) :: TFloat AS Amount_result_pack

             -- Приход пр-во (ФАКТ)
           , tmpMI.Income_CEH    :: TFloat AS Income_CEH
             -- ФАКТ - Перемещение на Цех Упаковки
           , tmpMI.Income_PACK_to
             -- ФАКТ - Перемещение с Цеха Упаковки
           , tmpMI.Income_PACK_from

             -- Ост. начальн. - произв. (СЕГОДНЯ)
           , tmpMI.Remains_CEH
             -- Ост. начальн. - произв. (ПОЗЖЕ)
           , tmpMI.Remains_CEH_Next
             -- Ост. начальн. - произв. -- !!!здесь то что НЕ учитываем если партия НЕ закрыта!!!
           , tmpMI.Remains_CEH_err
             -- Ост. начальн. - НЕ упакованный
           , tmpMI.Remains
             -- Ост. начальн. - упакованный
           , tmpMI.Remains_pack
             -- Ост. начальн. - НЕ упакованный + упакованный -- !!!здесь то что НЕ учитываем если ОТРИЦАТЕЛЬНЫЙ остаток!!!
           , tmpMI.Remains_err
             --
           , tmpMI.RemainsRK

             -- неотгуж. заявка
           , CAST (tmpMI.AmountPartnerPrior       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior
           , CAST (tmpMI.AmountPartnerPriorPromo  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorPromo
           , CAST (tmpMI.AmountPartnerPrior + tmpMI.AmountPartnerPriorPromo AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPriorTotal
             -- сегодня заявка
           , CAST (tmpMI.AmountPartner            AS NUMERIC (16, 2)) :: TFloat AS AmountPartner
           , CAST (tmpMI.AmountPartnerNext        AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerNext
           , CAST (tmpMI.AmountPartnerPromo       AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromo
           , CAST (tmpMI.AmountPartnerNextPromo   AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerNextPromo
           , CAST (tmpMI.AmountPartner + tmpMI.AmountPartnerPromo AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerTotal

             -- Прогноз по прод.
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1           THEN tmpMI.AmountForecast           ELSE CAST (tmpMI.AmountForecast           AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast
           , CASE WHEN ABS (tmpMI.AmountForecastPromo) < 1      THEN tmpMI.AmountForecastPromo      ELSE CAST (tmpMI.AmountForecastPromo      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastPromo
             -- Прогноз по заяв.
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1      THEN tmpMI.AmountForecastOrder      ELSE CAST (tmpMI.AmountForecastOrder      AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder
           , CASE WHEN ABS (tmpMI.AmountForecastOrderPromo) < 1 THEN tmpMI.AmountForecastOrderPromo ELSE CAST (tmpMI.AmountForecastOrderPromo AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrderPromo

           --
           , CAST (tmpMI.AmountPrIn               AS NUMERIC (16, 2)) :: TFloat AS AmountPrIn
           , CAST (tmpMI.AmountPartnerOld         AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerOld
           , CAST (tmpMI.AmountPartnerPromoOld    AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPromoOld
           , CAST (COALESCE (tmpMI.AmountPartnerOld,0) + COALESCE (tmpMI.AmountPartnerPromoOld,0)    AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerOldTotal

             -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
           , tmpMI.CountForecast
             -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
           , tmpMI.CountForecastOrder

             -- "средняя" за 1 день - продажа ИЛИ заявака
           , tmpMI.Plan1, tmpMI.Plan2, tmpMI.Plan3, tmpMI.Plan4, tmpMI.Plan5, tmpMI.Plan6, tmpMI.Plan7
             -- "средняя" за 1 день - акции - прогноз
           , tmpMI.Promo1, tmpMI.Promo2, tmpMI.Promo3, tmpMI.Promo4, tmpMI.Promo5, tmpMI.Promo6, tmpMI.Promo7

             -- Ост. в днях (по пр.) - без К
           , CAST (CASE WHEN tmpMI.CountForecast > 0
                             THEN (tmpMI.Remains + tmpMI.Remains_pack - tmpMI.Amount - tmpMI.AmountNext) / tmpMI.CountForecast
                        ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast
             -- Ост. в днях (по зв.) - без К
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0
                             THEN (tmpMI.Remains + tmpMI.Remains_pack - tmpMI.Amount - tmpMI.AmountNext) / tmpMI.CountForecastOrder
                        ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder

             -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
           , CAST (CASE WHEN tmpMI.CountForecast > 0
                             THEN (tmpMI.Remains + tmpMI.Remains_pack + tmpMI.AmountPack + tmpMI.AmountPackSecond + tmpMI.AmountPackNext + tmpMI.AmountPackNextSecond
                                 - tmpMI.Amount - tmpMI.AmountNext
                                 - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo
                                 - tmpMI.AmountPartner      - tmpMI.AmountPartnerPromo
                                  ) / tmpMI.CountForecast
                        WHEN tmpMI.CountForecastOrder > 0
                             THEN (tmpMI.Remains + tmpMI.Remains_pack + tmpMI.AmountPack + tmpMI.AmountPackSecond + tmpMI.AmountPackNext + tmpMI.AmountPackNextSecond
                                 - tmpMI.Amount - tmpMI.AmountNext
                                 - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo
                                 - tmpMI.AmountPartner      - tmpMI.AmountPartnerPromo
                                  ) / tmpMI.CountForecastOrder
                        ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast_calc


           , Object_Receipt.Id                         AS ReceiptId
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName
           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis
           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName

           , Object_GoodsKind_pf.ValueData             AS GoodsKindName_pf
           , Object_GoodsKindComplete_pf.ValueData     AS GoodsKindCompleteName_pf
           , tmpMI.PartionDate_pf                      AS PartionDate_pf
           , tmpMI.PartionGoods_start                  AS PartionGoods_start
           , tmpMI.TermProduction                      AS TermProduction

           , tmpMI.isErased

       FROM _tmpMI_All AS tmpMI

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods              ON Object_Goods.Id          = tmpMI.GoodsId
            LEFT JOIN Object AS Object_Goods_complete     ON Object_Goods_complete.Id = tmpMI.GoodsId_complete
            LEFT JOIN Object AS Object_Goods_basis        ON Object_Goods_basis.Id    = tmpMI.GoodsId_basis

            LEFT JOIN Object AS Object_GoodsKind          ON Object_GoodsKind.Id          = tmpMI.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = tmpMI.GoodsKindId_complete

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpMI.MeasureId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_complete
                                 ON ObjectLink_Goods_Measure_complete.ObjectId = Object_Goods_complete.Id
                                AND ObjectLink_Goods_Measure_complete.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_complete ON Object_Measure_complete.Id = ObjectLink_Goods_Measure_complete.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_basis
                                 ON ObjectLink_Goods_Measure_basis.ObjectId = Object_Goods_basis.Id
                                AND ObjectLink_Goods_Measure_basis.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_basis ON Object_Measure_basis.Id = ObjectLink_Goods_Measure_basis.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind_pf ON Object_GoodsKind_pf.Id = tmpMI.GoodsKindId_pf
            LEFT JOIN Object AS Object_GoodsKindComplete_pf ON Object_GoodsKindComplete_pf.Id = tmpMI.GoodsKindCompleteId_pf

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods_basis.Id
                                AND ObjectLink_OrderType_Goods.DescId        = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId   = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = CASE WHEN tmpMI.ContainerId > 0 OR tmpMI.UnitId_pf > 0 THEN tmpMI.UnitId_pf ELSE ObjectLink_OrderType_Unit.ChildObjectId END
           ;
           

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.12.20         * 
 17.11.17         *
 13.11.17         *
 29.10.17         *
 19.06.15                                        * all
 31.03.15         * add GoodsGroupNameFull
 02.03.14         * add AmountRemains, AmountPartner, AmountForecast, AmountForecastOrder
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM lpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= TRUE, inIsErased:= FALSE, inUserId:= 2)
