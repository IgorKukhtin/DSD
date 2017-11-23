     -- Результат - master
-- Function: gpSelect_MI_OrderInternalPackRemains()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPackRemains(
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
   DECLARE Cursor3 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- получааем  _Result_Master, _Result_Child, _Result_ChildTotal
     PERFORM lpSelect_MI_OrderInternalPackRemains (inMovementId:= inMovementId, inShowAll:= FALSE, inIsErased:= FALSE, inUserId:= vbUserId) ;

       --
       OPEN Cursor1 FOR

       -- Результат
       SELECT _Result_Master.Id
            , _Result_Master.KeyId
            , _Result_Master.GoodsId
            , _Result_Master.GoodsCode
            , _Result_Master.GoodsName
            , _Result_Master.GoodsId_basis
            , _Result_Master.GoodsCode_basis
            , _Result_Master.GoodsName_basis
            , _Result_Master.GoodsKindId
            , _Result_Master.GoodsKindName
            , _Result_Master.MeasureName
            , _Result_Master.MeasureName_basis
            , _Result_Master.GoodsGroupNameFull
            , _Result_Master.isCheck_basis

            , _Result_Master.Amount
            , _Result_Master.AmountSecond
            , _Result_Master.AmountTotal

            , _Result_Master.AmountNext
            , _Result_Master.AmountNextSecond
            , _Result_Master.AmountNextTotal
            , _Result_Master.AmountAllTotal

            , _Result_Master.Amount_result
            , _Result_Master.Amount_result_two
            , _Result_Master.Amount_result_pack

            , _Result_Master.Num
            , _Result_Master.Income_CEH
            , _Result_Master.Income_PACK_to
            , _Result_Master.Income_PACK_from

            , _Result_Master.Remains
            , _Result_Master.Remains_pack
            , _Result_Master.Remains_CEH
            , _Result_Master.Remains_CEH_Next

              -- неотгуж. заявка
            , _Result_Master.AmountPartnerPrior
            , _Result_Master.AmountPartnerPriorPromo
            , _Result_Master.AmountPartnerPriorTotal
              -- сегодня заявка
            , _Result_Master.AmountPartner
            , _Result_Master.AmountPartnerNext
            , _Result_Master.AmountPartnerPromo
            , _Result_Master.AmountPartnerNextPromo
            , _Result_Master.AmountPartnerTotal
            -- Прогноз по прод.
            , _Result_Master.AmountForecast
            , _Result_Master.AmountForecastPromo
             -- Прогноз по заяв.
            , _Result_Master.AmountForecastOrder
            , _Result_Master.AmountForecastOrderPromo

             -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
            , CAST (_Result_Master.CountForecast AS NUMERIC (16, 1)) :: TFloat AS CountForecast
             -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
            , CAST (_Result_Master.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- "средняя" за 1 день - продажа ИЛИ заявака
            , CAST (_Result_Master.Plan1 AS NUMERIC (16, 1)) :: TFloat AS Plan1
            , CAST (_Result_Master.Plan2 AS NUMERIC (16, 1)) :: TFloat AS Plan2
            , CAST (_Result_Master.Plan3 AS NUMERIC (16, 1)) :: TFloat AS Plan3
            , CAST (_Result_Master.Plan4 AS NUMERIC (16, 1)) :: TFloat AS Plan4
            , CAST (_Result_Master.Plan5 AS NUMERIC (16, 1)) :: TFloat AS Plan5
            , CAST (_Result_Master.Plan6 AS NUMERIC (16, 1)) :: TFloat AS Plan6
            , CAST (_Result_Master.Plan7 AS NUMERIC (16, 1)) :: TFloat AS Plan7
              -- "средняя" за 1 день - акции - прогноз
            , CAST (_Result_Master.Promo1 AS NUMERIC (16, 1)) :: TFloat AS Promo1
            , CAST (_Result_Master.Promo2 AS NUMERIC (16, 1)) :: TFloat AS Promo2
            , CAST (_Result_Master.Promo3 AS NUMERIC (16, 1)) :: TFloat AS Promo3
            , CAST (_Result_Master.Promo4 AS NUMERIC (16, 1)) :: TFloat AS Promo4
            , CAST (_Result_Master.Promo5 AS NUMERIC (16, 1)) :: TFloat AS Promo5
            , CAST (_Result_Master.Promo6 AS NUMERIC (16, 1)) :: TFloat AS Promo6
            , CAST (_Result_Master.Promo7 AS NUMERIC (16, 1)) :: TFloat AS Promo7

              -- Ост. в днях (по пр.) - без К
            , _Result_Master.DayCountForecast
              -- Ост. в днях (по зв.) - без К
            , _Result_Master.DayCountForecastOrder
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_Master.DayCountForecast_calc
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , zfCalc_StatDayCount_Week (inAmount           := COALESCE (_Result_Master.Amount_result_pack, 0)
                                      , inAmountPartnerNext:= COALESCE (_Result_Master.AmountPartnerNext, 0) + COALESCE (_Result_Master.AmountPartnerNextPromo, 0)
                                      , inCountForecast    := CASE WHEN _Result_Master.CountForecast > 0 THEN COALESCE (_Result_Master.CountForecast, 0) ELSE COALESCE (_Result_Master.CountForecastOrder, 0) END
                                      , inPlan1            := COALESCE (_Result_Master.Plan1, 0) + COALESCE (_Result_Master.Promo1, 0)
                                      , inPlan2            := COALESCE (_Result_Master.Plan2, 0) + COALESCE (_Result_Master.Promo2, 0)
                                      , inPlan3            := COALESCE (_Result_Master.Plan3, 0) + COALESCE (_Result_Master.Promo3, 0)
                                      , inPlan4            := COALESCE (_Result_Master.Plan4, 0) + COALESCE (_Result_Master.Promo4, 0)
                                      , inPlan5            := COALESCE (_Result_Master.Plan5, 0) + COALESCE (_Result_Master.Promo5, 0)
                                      , inPlan6            := COALESCE (_Result_Master.Plan6, 0) + COALESCE (_Result_Master.Promo6, 0)
                                      , inPlan7            := COALESCE (_Result_Master.Plan7, 0) + COALESCE (_Result_Master.Promo7, 0)
                                       ) AS DayCountForecast_new

            , _Result_Master.ReceiptId
            , _Result_Master.ReceiptCode
            , _Result_Master.ReceiptName
            , _Result_Master.ReceiptId_basis
            , _Result_Master.ReceiptCode_basis
            , _Result_Master.ReceiptName_basis
            , _Result_Master.UnitId
            , _Result_Master.UnitCode
            , _Result_Master.UnitName
            , _Result_Master.isErased

       FROM _Result_Master
       ;
       RETURN NEXT Cursor1;


       OPEN Cursor2 FOR
       SELECT _Result_Child.Id
            , _Result_Child.ContainerId
            , _Result_Child.KeyId
            , _Result_Child.GoodsId
            , _Result_Child.GoodsCode
            , _Result_Child.GoodsName
            , _Result_Child.GoodsKindId
            , _Result_Child.GoodsKindName
            , _Result_Child.MeasureName
            , _Result_Child.GoodsGroupNameFull

            , _Result_Child.AmountPack
            , _Result_Child.AmountPackSecond
            , _Result_Child.AmountPackTotal

            , _Result_Child.AmountPack_calc
            , _Result_Child.AmountSecondPack_calc
            , _Result_Child.AmountPackTotal_calc

            , _Result_Child.AmountPackNext
            , _Result_Child.AmountPackNextSecond
            , _Result_Child.AmountPackNextTotal

            , _Result_Child.AmountPackNext_calc
            , _Result_Child.AmountPackNextSecond_calc
            , _Result_Child.AmountPackNextTotal_calc

            , _Result_Child.AmountPackAllTotal
            , _Result_Child.AmountPackAllTotal_calc

            , _Result_Child.Amount_result_two
            , _Result_Child.Amount_result_pack
            , _Result_Child.Amount_result_pack_pack

            , _Result_Child.Income_PACK_to
            , _Result_Child.Income_PACK_from

            , _Result_Child.Remains
            , _Result_Child.Remains_pack

              -- неотгуж. заявка
            , _Result_Child.AmountPartnerPrior
            , _Result_Child.AmountPartnerPriorPromo
            , _Result_Child.AmountPartnerPriorTotal
              -- сегодня заявка
            , _Result_Child.AmountPartner
            , _Result_Child.AmountPartnerNext
            , _Result_Child.AmountPartnerPromo
            , _Result_Child.AmountPartnerNextPromo
            , _Result_Child.AmountPartnerTotal
              -- Прогноз по прод.
            , _Result_Child.AmountForecast
            , _Result_Child.AmountForecastPromo
              -- Прогноз по заяв.
            , _Result_Child.AmountForecastOrder
            , _Result_Child.AmountForecastOrderPromo

              -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
            , CAST (_Result_Child.CountForecast AS NUMERIC (16, 1)) :: TFloat AS CountForecast
              -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
            , CAST (_Result_Child.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- "средняя" за 1 день - продажа ИЛИ заявака
            , CAST (_Result_Child.Plan1 AS NUMERIC (16, 1)) :: TFloat AS Plan1
            , CAST (_Result_Child.Plan2 AS NUMERIC (16, 1)) :: TFloat AS Plan2
            , CAST (_Result_Child.Plan3 AS NUMERIC (16, 1)) :: TFloat AS Plan3
            , CAST (_Result_Child.Plan4 AS NUMERIC (16, 1)) :: TFloat AS Plan4
            , CAST (_Result_Child.Plan5 AS NUMERIC (16, 1)) :: TFloat AS Plan5
            , CAST (_Result_Child.Plan6 AS NUMERIC (16, 1)) :: TFloat AS Plan6
            , CAST (_Result_Child.Plan7 AS NUMERIC (16, 1)) :: TFloat AS Plan7
              -- "средняя" за 1 день - акции - прогноз
            , CAST (_Result_Child.Promo1 AS NUMERIC (16, 1)) :: TFloat AS Promo1
            , CAST (_Result_Child.Promo2 AS NUMERIC (16, 1)) :: TFloat AS Promo2
            , CAST (_Result_Child.Promo3 AS NUMERIC (16, 1)) :: TFloat AS Promo3
            , CAST (_Result_Child.Promo4 AS NUMERIC (16, 1)) :: TFloat AS Promo4
            , CAST (_Result_Child.Promo5 AS NUMERIC (16, 1)) :: TFloat AS Promo5
            , CAST (_Result_Child.Promo6 AS NUMERIC (16, 1)) :: TFloat AS Promo6
            , CAST (_Result_Child.Promo7 AS NUMERIC (16, 1)) :: TFloat AS Promo7

              -- Ост. в днях (по пр.) - без К
            , _Result_Child.DayCountForecast
              -- Ост. в днях (по зв.) - без К
            , _Result_Child.DayCountForecastOrder
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_Child.DayCountForecast_calc
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , zfCalc_StatDayCount_Week (inAmount           := COALESCE (_Result_Child.Amount_result_pack, 0)
                                      , inAmountPartnerNext:= COALESCE (_Result_Child.AmountPartnerNext, 0) + COALESCE (_Result_Child.AmountPartnerNextPromo, 0)
                                      , inCountForecast    := CASE WHEN _Result_Child.CountForecast > 0 THEN COALESCE (_Result_Child.CountForecast, 0) ELSE COALESCE (_Result_Child.CountForecastOrder, 0) END
                                      , inPlan1            := COALESCE (_Result_Child.Plan1, 0) + COALESCE (_Result_Child.Promo1, 0)
                                      , inPlan2            := COALESCE (_Result_Child.Plan2, 0) + COALESCE (_Result_Child.Promo2, 0)
                                      , inPlan3            := COALESCE (_Result_Child.Plan3, 0) + COALESCE (_Result_Child.Promo3, 0)
                                      , inPlan4            := COALESCE (_Result_Child.Plan4, 0) + COALESCE (_Result_Child.Promo4, 0)
                                      , inPlan5            := COALESCE (_Result_Child.Plan5, 0) + COALESCE (_Result_Child.Promo5, 0)
                                      , inPlan6            := COALESCE (_Result_Child.Plan6, 0) + COALESCE (_Result_Child.Promo6, 0)
                                      , inPlan7            := COALESCE (_Result_Child.Plan7, 0) + COALESCE (_Result_Child.Promo7, 0)
                                       ) AS DayCountForecast_new
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , zfCalc_StatDayCount_Week (inAmount           := COALESCE (_Result_Child.Amount_result_pack_pack, 0)
                                      , inAmountPartnerNext:= COALESCE (_Result_Child.AmountPartnerNext, 0) + COALESCE (_Result_Child.AmountPartnerNextPromo, 0)
                                      , inCountForecast    := CASE WHEN _Result_Child.CountForecast > 0 THEN COALESCE (_Result_Child.CountForecast, 0) ELSE COALESCE (_Result_Child.CountForecastOrder, 0) END
                                      , inPlan1            := COALESCE (_Result_Child.Plan1, 0) + COALESCE (_Result_Child.Promo1, 0)
                                      , inPlan2            := COALESCE (_Result_Child.Plan2, 0) + COALESCE (_Result_Child.Promo2, 0)
                                      , inPlan3            := COALESCE (_Result_Child.Plan3, 0) + COALESCE (_Result_Child.Promo3, 0)
                                      , inPlan4            := COALESCE (_Result_Child.Plan4, 0) + COALESCE (_Result_Child.Promo4, 0)
                                      , inPlan5            := COALESCE (_Result_Child.Plan5, 0) + COALESCE (_Result_Child.Promo5, 0)
                                      , inPlan6            := COALESCE (_Result_Child.Plan6, 0) + COALESCE (_Result_Child.Promo6, 0)
                                      , inPlan7            := COALESCE (_Result_Child.Plan7, 0) + COALESCE (_Result_Child.Promo7, 0)
                                       ) AS DayCountForecast_new_new

            , _Result_Child.ReceiptId
            , _Result_Child.ReceiptCode
            , _Result_Child.ReceiptName
            , _Result_Child.ReceiptId_basis
            , _Result_Child.ReceiptCode_basis
            , _Result_Child.ReceiptName_basis
            , _Result_Child.isErased
       FROM _Result_Child
       ;
       RETURN NEXT Cursor2;

       OPEN Cursor3 FOR
       SELECT _Result_ChildTotal.Id
            , _Result_ChildTotal.ContainerId
            , _Result_ChildTotal.GoodsId
            , _Result_ChildTotal.GoodsCode
            , _Result_ChildTotal.GoodsName
            , _Result_ChildTotal.GoodsId_complete
            , _Result_ChildTotal.GoodsCode_complete
            , _Result_ChildTotal.GoodsName_complete
            , _Result_ChildTotal.GoodsId_basis
            , _Result_ChildTotal.GoodsCode_basis
            , _Result_ChildTotal.GoodsName_basis
            , _Result_ChildTotal.GoodsKindId
            , _Result_ChildTotal.GoodsKindName
            , _Result_ChildTotal.GoodsKindId_complete
            , _Result_ChildTotal.GoodsKindName_complete
            , _Result_ChildTotal.MeasureName
            , _Result_ChildTotal.MeasureName_complete
            , _Result_ChildTotal.MeasureName_basis
            , _Result_ChildTotal.GoodsGroupNameFull
            , _Result_ChildTotal.isCheck_basis

              -- План1 + План2 ИТОГО выдали на УПАК
            , (_Result_ChildTotal.AmountTotal + _Result_ChildTotal.AmountNextTotal)                   :: TFloat AS AmountAllTotal
              -- План1 + План2 ИТОГО заказ факт - Приход с УПАК
            , (_Result_ChildTotal.AmountPackTotal + _Result_ChildTotal.AmountPackNextTotal)           :: TFloat AS AmountPackAllTotal
              -- План1 + План2 ИТОГО заказ расч. - Приход с УПАК
            , (_Result_ChildTotal.AmountPackTotal_calc + _Result_ChildTotal.AmountPackNextTotal_calc) :: TFloat AS AmountPackAllTotal_calc

              -- ***План1 выдали на УПАК ...
            , _Result_ChildTotal.Amount
            , _Result_ChildTotal.AmountSecond
            , _Result_ChildTotal.AmountTotal
              -- ***План1 заказ факт - Приход с УПАК
            , _Result_ChildTotal.AmountPack
            , _Result_ChildTotal.AmountPackSecond
            , _Result_ChildTotal.AmountPackTotal
              -- ***План1 заказ расч. - Приход с УПАК
            , _Result_ChildTotal.AmountPack_calc
            , _Result_ChildTotal.AmountSecondPack_calc
            , _Result_ChildTotal.AmountPackTotal_calc

              -- ***План2 выдали на УПАК ...
            , _Result_ChildTotal.AmountNext
            , _Result_ChildTotal.AmountNextSecond
            , _Result_ChildTotal.AmountNextTotal
              -- ***План2 заказ факт - Приход с УПАК
            , _Result_ChildTotal.AmountPackNext
            , _Result_ChildTotal.AmountPackNextSecond
            , _Result_ChildTotal.AmountPackNextTotal
              -- ***План2 заказ расч. - Приход с УПАК
            , _Result_ChildTotal.AmountPackNext_calc
            , _Result_ChildTotal.AmountPackNextSecond_calc
            , _Result_ChildTotal.AmountPackNextTotal_calc

              -- РЕЗУЛЬТАТ c пр-вом
            , _Result_ChildTotal.Amount_result
              -- РЕЗУЛЬТАТ без пр-ва
            , _Result_ChildTotal.Amount_result_two
              -- РЕЗУЛЬТАТ ***УПАК
            , _Result_ChildTotal.Amount_result_pack

            , _Result_ChildTotal.Income_CEH
            , _Result_ChildTotal.Income_PACK_to
            , _Result_ChildTotal.Income_PACK_from

            , _Result_ChildTotal.Remains_CEH
            , _Result_ChildTotal.Remains_CEH_Next
            , _Result_ChildTotal.Remains_CEH_err
            , _Result_ChildTotal.Remains
            , _Result_ChildTotal.Remains_pack
            , _Result_ChildTotal.Remains_err

              -- неотгуж. заявка
            , _Result_ChildTotal.AmountPartnerPrior
            , _Result_ChildTotal.AmountPartnerPriorPromo
            , _Result_ChildTotal.AmountPartnerPriorTotal
              -- сегодня заявка
            , _Result_ChildTotal.AmountPartner
            , _Result_ChildTotal.AmountPartnerNext
            , _Result_ChildTotal.AmountPartnerPromo
            , _Result_ChildTotal.AmountPartnerNextPromo
            , _Result_ChildTotal.AmountPartnerTotal
              -- Прогноз по прод.
            , _Result_ChildTotal.AmountForecast
            , _Result_ChildTotal.AmountForecastPromo
              -- Прогноз по заяв.
            , _Result_ChildTotal.AmountForecastOrder
            , _Result_ChildTotal.AmountForecastOrderPromo

              -- "средняя" за 1 день - продажа покупателям БЕЗ акций - Норм 1д (по пр.) без К
            , CAST (_Result_ChildTotal.CountForecast AS NUMERIC (16, 1)) :: TFloat AS CountForecast
              -- "средняя" за 1 день - заказы покупателей БЕЗ акций - Норм 1д (по зв.) без К
            , CAST (_Result_ChildTotal.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder

              -- "средняя" за 1 день - продажа ИЛИ заявака
            , CAST (_Result_ChildTotal.Plan1 AS NUMERIC (16, 1)) :: TFloat AS Plan1
            , CAST (_Result_ChildTotal.Plan2 AS NUMERIC (16, 1)) :: TFloat AS Plan2
            , CAST (_Result_ChildTotal.Plan3 AS NUMERIC (16, 1)) :: TFloat AS Plan3
            , CAST (_Result_ChildTotal.Plan4 AS NUMERIC (16, 1)) :: TFloat AS Plan4
            , CAST (_Result_ChildTotal.Plan5 AS NUMERIC (16, 1)) :: TFloat AS Plan5
            , CAST (_Result_ChildTotal.Plan6 AS NUMERIC (16, 1)) :: TFloat AS Plan6
            , CAST (_Result_ChildTotal.Plan7 AS NUMERIC (16, 1)) :: TFloat AS Plan7
              -- "средняя" за 1 день - акции - прогноз
            , CAST (_Result_ChildTotal.Promo1 AS NUMERIC (16, 1)) :: TFloat AS Promo1
            , CAST (_Result_ChildTotal.Promo2 AS NUMERIC (16, 1)) :: TFloat AS Promo2
            , CAST (_Result_ChildTotal.Promo3 AS NUMERIC (16, 1)) :: TFloat AS Promo3
            , CAST (_Result_ChildTotal.Promo4 AS NUMERIC (16, 1)) :: TFloat AS Promo4
            , CAST (_Result_ChildTotal.Promo5 AS NUMERIC (16, 1)) :: TFloat AS Promo5
            , CAST (_Result_ChildTotal.Promo6 AS NUMERIC (16, 1)) :: TFloat AS Promo6
            , CAST (_Result_ChildTotal.Promo7 AS NUMERIC (16, 1)) :: TFloat AS Promo7

              -- Ост. в днях (по пр.) - без К
            , _Result_ChildTotal.DayCountForecast
              -- Ост. в днях (по зв.) - без К
            , _Result_ChildTotal.DayCountForecastOrder
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , _Result_ChildTotal.DayCountForecast_calc
              -- Ост. в днях (по пр. !!!ИЛИ!!! по зв.) - ПОСЛЕ УПАКОВКИ
            , zfCalc_StatDayCount_Week (inAmount           := COALESCE (_Result_ChildTotal.Amount_result_pack, 0)
                                      , inAmountPartnerNext:= COALESCE (_Result_ChildTotal.AmountPartnerNext, 0) + COALESCE (_Result_ChildTotal.AmountPartnerNextPromo, 0)
                                      , inCountForecast    := CASE WHEN _Result_ChildTotal.CountForecast > 0 THEN COALESCE (_Result_ChildTotal.CountForecast, 0) ELSE COALESCE (_Result_ChildTotal.CountForecastOrder, 0) END
                                      , inPlan1            := COALESCE (_Result_ChildTotal.Plan1, 0) + COALESCE (_Result_ChildTotal.Promo1, 0)
                                      , inPlan2            := COALESCE (_Result_ChildTotal.Plan2, 0) + COALESCE (_Result_ChildTotal.Promo2, 0)
                                      , inPlan3            := COALESCE (_Result_ChildTotal.Plan3, 0) + COALESCE (_Result_ChildTotal.Promo3, 0)
                                      , inPlan4            := COALESCE (_Result_ChildTotal.Plan4, 0) + COALESCE (_Result_ChildTotal.Promo4, 0)
                                      , inPlan5            := COALESCE (_Result_ChildTotal.Plan5, 0) + COALESCE (_Result_ChildTotal.Promo5, 0)
                                      , inPlan6            := COALESCE (_Result_ChildTotal.Plan6, 0) + COALESCE (_Result_ChildTotal.Promo6, 0)
                                      , inPlan7            := COALESCE (_Result_ChildTotal.Plan7, 0) + COALESCE (_Result_ChildTotal.Promo7, 0)
                                       ) AS DayCountForecast_new

            , _Result_ChildTotal.ReceiptId
            , _Result_ChildTotal.ReceiptCode
            , _Result_ChildTotal.ReceiptName
            , _Result_ChildTotal.ReceiptId_basis
            , _Result_ChildTotal.ReceiptCode_basis
            , _Result_ChildTotal.ReceiptName_basis
            , _Result_ChildTotal.UnitId
            , _Result_ChildTotal.UnitCode
            , _Result_ChildTotal.UnitName
            , _Result_ChildTotal.GoodsKindName_pf
            , _Result_ChildTotal.GoodsKindCompleteName_pf
            , _Result_ChildTotal.PartionDate_pf
            , _Result_ChildTotal.PartionGoods_start
            , _Result_ChildTotal.TermProduction
            , _Result_ChildTotal.isErased

       FROM _Result_ChildTotal
       ;

       RETURN NEXT Cursor3;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_OrderInternalPackRemains (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.11.17         *
 13.11.17         *
 29.10.17         *
 19.06.15                                        * all
 31.03.15         * add GoodsGroupNameFull
 02.03.14         * add AmountRemains, AmountPartner, AmountForecast, AmountForecastOrder
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderInternalPackRemains (inMovementId:= 1828419, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2'); -- FETCH ALL "<unnamed portal 1>";
