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


      -- таблица -
     CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, AmountPartnerPromo TFloat, AmountPartnerPrior TFloat, AmountPartnerPriorPromo TFloat) ON COMMIT DROP;
     --
     INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountPartner, AmountPartnerPromo, AmountPartnerPrior, AmountPartnerPriorPromo)
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
                                 SELECT tmp.MovementItemId
                                       , COALESCE (tmp.GoodsId,tmpOrder.GoodsId)          AS GoodsId
                                       , COALESCE (tmp.GoodsKindId, tmpOrder.GoodsKindId) AS GoodsKindId
                                       , COALESCE (tmpOrder.AmountPartner, 0)             AS AmountPartner
                                       , COALESCE (tmpOrder.AmountPartnerPromo, 0)        AS AmountPartnerPromo
                                       , COALESCE (tmpOrder.AmountPartnerPrior, 0)        AS AmountPartnerPrior
                                       , COALESCE (tmpOrder.AmountPartnerPriorPromo, 0)   AS AmountPartnerPriorPromo
                                 FROM (SELECT MovementItem.ObjectId                                                    AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                            AS GoodsKindId
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartner
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerPromo
                                            , SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                         AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END) AS AmountPartnerPrior
                                            , SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                         AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END) AS AmountPartnerPriorPromo
                                       FROM Movement 
                                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                                            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                        ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                                       WHERE Movement.OperDate BETWEEN (inOperDate - INTERVAL '8 DAY') AND inOperDate + INTERVAL '0 DAY'
                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                         AND Movement.DescId   = zc_Movement_OrderExternal()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (CASE WHEN Movement.OperDate = inOperDate THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) <> 0
                                           OR SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END)  <> 0
                                       ) AS tmpOrder
                                 FULL JOIN
                                (SELECT MovementItem.Id                               AS MovementItemId 
                                      , MovementItem.ObjectId                         AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                      , MovementItem.Amount
                                 FROM MovementItem 
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                ) AS tmp  ON tmp.GoodsId     = tmpOrder.GoodsId
                                         AND tmp.GoodsKindId = tmpOrder.GoodsKindId
                     ;

       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId

                                                 , inAmount_Param       := tmpAll.AmountPartner      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountPartner()
                                                 , inAmount_ParamOrder  := tmpAll.AmountPartnerPromo * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamOrder  := zc_MIFloat_AmountPartnerPromo()

                                                 , inAmount_ParamSecond := tmpAll.AmountPartnerPrior      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamSecond := zc_MIFloat_AmountPartnerPrior()
                                                 , inAmount_ParamAdd := tmpAll.AmountPartnerPriorPromo * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamAdd := zc_MIFloat_AmountPartnerPriorPromo()
                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  ) 
       FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
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
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountPartnerPromo (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
