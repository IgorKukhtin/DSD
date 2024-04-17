-- Function: gpUpdateMI_OrderInternal_AmountPartnerPromo()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPartnerPromo (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountPartnerPromo(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());

if vbUserId = 5 AND 1=1
then
    inOperDate:= CURRENT_DATE;
end if;


     -- ЦЕХ упаковки
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To() AND MLO.ObjectId = 8451)
     THEN
         -- Сохраняем предыдущие значения
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerOld(),      MovementItem.Id, COALESCE (MIFloat_AmountPartner.ValueData, 0))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerPromoOld(), MovementItem.Id, COALESCE (MIFloat_AmountPartnerPromo.ValueData, 0))
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                          ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
              LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPromo
                                          ON MIFloat_AmountPartnerPromo.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountPartnerPromo.DescId         = zc_MIFloat_AmountPartnerPromo()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.isErased   = FALSE
         ;
     END IF;


      -- таблица -
     CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, AmountPartnerNext TFloat, AmountPartnerPromo TFloat, AmountPartnerNextPromo TFloat, AmountPartnerPrior TFloat, AmountPartnerPriorPromo TFloat) ON COMMIT DROP;
     --
     INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountPartner, AmountPartnerNext, AmountPartnerPromo, AmountPartnerNextPromo, AmountPartnerPrior, AmountPartnerPriorPromo)
                                 WITH -- хардкодим - Склады База + Реализации
                                      tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)
                                      -- хардкодим - товары ГП
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                   FROM Object_InfoMoney_View
                                                        INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                              ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                             AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                             , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                             , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                                              )
                                                  )
                    , tmpOrder_all AS (SELECT MovementItem.MovementId                                                  AS MovementId
                                            , MovementItem.ObjectId                                                    AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())         AS GoodsKindId
                                            , COALESCE (MIFloat_PromoMovementId.ValueData, 0)                          AS MovementId_promo
                                              -- заказ покупателя БЕЗ акций, сегодня + завтра
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartner
                                              -- заказ покупателя ТОЛЬКО Акции, сегодня + завтра
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerPromo

                                              -- "информативно" заказ покупателя БЕЗ акций, завтра
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND MovementDate_OperDatePartner.ValueData > inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerNext
                                              -- "информативно" заказ покупателя ТОЛЬКО Акции, завтра
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND MovementDate_OperDatePartner.ValueData > inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerNextPromo

                                              -- заказ покупателя БЕЗ акций, неотгруж - вчера
                                            , SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                         AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END) AS AmountPartnerPrior
                                              -- заказ покупателя ТОЛЬКО Акции, неотгруж - вчера
                                            , SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                         AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END) AS AmountPartnerPriorPromo
                                       FROM Movement
                                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                                            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                        ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                                       WHERE Movement.OperDate BETWEEN (inOperDate - INTERVAL '7 DAY') AND inOperDate + INTERVAL '0 DAY'
                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                         AND Movement.DescId   = zc_Movement_OrderExternal()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       GROUP BY MovementItem.MovementId
                                              , MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                              , MIFloat_PromoMovementId.ValueData
                                       HAVING SUM (CASE WHEN Movement.OperDate = inOperDate THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) <> 0
                                           OR SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END)  <> 0
                                       )
                          -- выбираем продажи по заказам
                        , tmpMISale AS (SELECT tmp.MovementId             AS MovementId_order -- заявка
                                             , MovementItem.Id
                                             , MovementItem.ObjectId      AS GoodsId
                                             , MovementItem.Amount        AS Amount
                                      FROM (SELECT DISTINCT tmpOrder_all.MovementId FROM tmpOrder_all) AS tmp
                                           LEFT JOIN MovementLinkMovement AS MLM_Order
                                                                          ON MLM_Order.MovementChildId = tmp.MovementId
                                                                         AND MLM_Order.DescId          = zc_MovementLinkMovement_Order()
                                           INNER JOIN Movement AS MovementSale
                                                               ON MovementSale.Id     = MLM_Order.MovementId  -- продажа
                                                              AND MovementSale.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                            --AND MovementSale.StatusId <> zc_Enum_Status_Erased()
                                                              AND MovementSale.StatusId = zc_Enum_Status_Complete()
                                                              -- обязатательно прошлые продажи, т.к. остаток берем на 8:00
                                                              AND MovementSale.OperDate < inOperDate
                                           LEFT JOIN MovementItem ON MovementItem.MovementId = MovementSale.Id
                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                 AND MovementItem.isErased   = FALSE
                                       )
                        , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                                                FROM MovementItemLinkObject
                                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMISale.Id FROM tmpMISale)
                                                   AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                                )
                        , tmpSale AS (SELECT tmpMISale.MovementId_order -- заявка
                                           , tmpMISale.GoodsId
                                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                           , SUM (tmpMISale.Amount)  AS Amount
                                      FROM tmpMISale
                                           LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = tmpMISale.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                      WHERE tmpMISale.Amount > 0
                                      GROUP BY tmpMISale.MovementId_order -- заявка
                                             , tmpMISale.GoodsId
                                             , MILinkObject_GoodsKind.ObjectId
                                      )
                      , tmpOrder_s AS (SELECT tmpOrder_all.GoodsId
                                            , tmpOrder_all.GoodsKindId
                                            , tmpOrder_all.AmountPartner           - CASE WHEN tmpOrder_all.MovementId_promo = 0 THEN COALESCE (tmpSale.Amount, 0) ELSE 0 END AS AmountPartner
                                            , tmpOrder_all.AmountPartnerNext       - CASE WHEN tmpOrder_all.MovementId_promo = 0 THEN COALESCE (tmpSale.Amount, 0) ELSE 0 END AS AmountPartnerNext
                                            , tmpOrder_all.AmountPartnerPromo      - CASE WHEN tmpOrder_all.MovementId_promo > 0 THEN COALESCE (tmpSale.Amount, 0) ELSE 0 END AS AmountPartnerPromo
                                            , tmpOrder_all.AmountPartnerNextPromo  - CASE WHEN tmpOrder_all.MovementId_promo > 0 THEN COALESCE (tmpSale.Amount, 0) ELSE 0 END AS AmountPartnerNextPromo
                                            , tmpOrder_all.AmountPartnerPrior      - CASE WHEN tmpOrder_all.MovementId_promo = 0 THEN COALESCE (tmpSale.Amount, 0) ELSE 0 END AS AmountPartnerPrior
                                            , tmpOrder_all.AmountPartnerPriorPromo - CASE WHEN tmpOrder_all.MovementId_promo > 0 THEN COALESCE (tmpSale.Amount, 0) ELSE 0 END AS AmountPartnerPriorPromo
                                       FROM tmpOrder_all
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpOrder_all.GoodsId
                                            LEFT JOIN tmpSale ON tmpSale.MovementId_order = tmpOrder_all.MovementId
                                                             AND tmpSale.GoodsId          = tmpOrder_all.GoodsId
                                                             AND tmpSale.GoodsKindId      = tmpOrder_all.GoodsKindId
                                       )
                        , tmpOrder AS (SELECT tmpOrder_s.GoodsId
                                            , tmpOrder_s.GoodsKindId
                                            , SUM (CASE WHEN tmpOrder_s.AmountPartner           > 0 THEN tmpOrder_s.AmountPartner           ELSE 0 END) AS AmountPartner
                                            , SUM (CASE WHEN tmpOrder_s.AmountPartnerNext       > 0 THEN tmpOrder_s.AmountPartnerNext       ELSE 0 END) AS AmountPartnerNext
                                            , SUM (CASE WHEN tmpOrder_s.AmountPartnerPromo      > 0 THEN tmpOrder_s.AmountPartnerPromo      ELSE 0 END) AS AmountPartnerPromo
                                            , SUM (CASE WHEN tmpOrder_s.AmountPartnerNextPromo  > 0 THEN tmpOrder_s.AmountPartnerNextPromo  ELSE 0 END) AS AmountPartnerNextPromo
                                            , SUM (CASE WHEN tmpOrder_s.AmountPartnerPrior      > 0 THEN tmpOrder_s.AmountPartnerPrior      ELSE 0 END) AS AmountPartnerPrior
                                            , SUM (CASE WHEN tmpOrder_s.AmountPartnerPriorPromo > 0 THEN tmpOrder_s.AmountPartnerPriorPromo ELSE 0 END) AS AmountPartnerPriorPromo
                                       FROM tmpOrder_s
                                       GROUP BY tmpOrder_s.GoodsId
                                              , tmpOrder_s.GoodsKindId
                                       )
                     , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                                      , MovementItem.ObjectId                         AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                      , MovementItem.Amount
                                      , COALESCE (MIFloat_ContainerId.ValueData, 0)   AS ContainerId
                                 FROM MovementItem
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                      LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                  ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                )
    -- Не упаковывать
  , tmpGoodsByGoodsKind_not AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId          AS GoodsId
                                     , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId      AS GoodsKindId
                                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                     JOIN Object AS Object_GoodsByGoodsKind
                                                 ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                AND Object_GoodsByGoodsKind.isErased = FALSE
                                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                     JOIN ObjectBoolean AS ObjectBoolean_NotPack
                                                        ON ObjectBoolean_NotPack.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                       AND ObjectBoolean_NotPack.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()
                                                       AND ObjectBoolean_NotPack.ValueData = TRUE
                                WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId <> zc_GoodsKind_Basis()
                                --AND 1=0
                               )
       -- Результат
       SELECT tmp.MovementItemId
            , tmp.GoodsId
            , tmp.GoodsKindId
            , tmp.AmountPartner
            , tmp.AmountPartnerNext
            , tmp.AmountPartnerPromo
            , tmp.AmountPartnerNextPromo
            , tmp.AmountPartnerPrior
            , tmp.AmountPartnerPriorPromo
       FROM (SELECT tmp.MovementItemId
                   , COALESCE (tmp.GoodsId,tmpOrder.GoodsId)          AS GoodsId
                   , COALESCE (tmp.GoodsKindId, tmpOrder.GoodsKindId) AS GoodsKindId
                   , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartner, 0)             END AS AmountPartner
                   , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerNext, 0)         END AS AmountPartnerNext
                   , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerPromo, 0)        END AS AmountPartnerPromo
                   , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerNextPromo, 0)    END AS AmountPartnerNextPromo
                   , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerPrior, 0)        END AS AmountPartnerPrior
                   , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerPriorPromo, 0)   END AS AmountPartnerPriorPromo
             FROM tmpOrder
                  FULL JOIN tmpMI AS tmp ON tmp.GoodsId   = tmpOrder.GoodsId
                                       AND tmp.GoodsKindId = tmpOrder.GoodsKindId
            ) AS tmp
            LEFT JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = tmp.GoodsId
                                             AND tmpGoodsByGoodsKind_not.GoodsKindId = tmp.GoodsKindId
       WHERE tmpGoodsByGoodsKind_not.GoodsId IS NULL

      UNION ALL
       SELECT tmpMI.MovementItemId
            , tmpMI.GoodsId
            , tmpMI.GoodsKindId
            , 0 AS AmountPartner
            , 0 AS AmountPartnerNext
            , 0 AS AmountPartnerPromo
            , 0 AS AmountPartnerNextPromo
            , 0 AS AmountPartnerPrior
            , 0 AS AmountPartnerPriorPromo
       FROM tmpMI
            INNER JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = tmpMI.GoodsId
                                              AND tmpGoodsByGoodsKind_not.GoodsKindId = tmpMI.GoodsKindId
      ;

       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId

                                                 , inAmount_Param       := tmpAll.AmountPartner      -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountPartner()
                                                 , inAmount_ParamOrder  := tmpAll.AmountPartnerPromo -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamOrder  := zc_MIFloat_AmountPartnerPromo()

                                                 , inAmount_ParamSecond := tmpAll.AmountPartnerPrior      -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamSecond := zc_MIFloat_AmountPartnerPrior()
                                                 , inAmount_ParamAdd    := tmpAll.AmountPartnerPriorPromo -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamAdd    := zc_MIFloat_AmountPartnerPriorPromo()


                                                 , inAmount_ParamNext        := tmpAll.AmountPartnerNext -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamNext        := zc_MIFloat_AmountPartnerNext()
                                                 , inAmount_ParamNextPromo   := tmpAll.AmountPartnerNextPromo -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamNextPromo   := zc_MIFloat_AmountPartnerNextPromo()

                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  )
       FROM tmpAll
            /*LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()*/
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.15                                        * расчет, временно захардкодил
 19.06.15                                        *
 14.02.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountPartnerPromo (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= zfCalc_UserAdmin())
