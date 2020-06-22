-- Function: gpUpdateMI_OrderInternal_AmountPartner()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPartner (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountPartner(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbIsPack     Boolean;
   DECLARE vbIsTushenka Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- расчет, временно захардкодил - To = Цех Упаковки
    vbIsPack:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 8451); -- Цех Упаковки
    -- расчет, временно захардкодил - To = ЦЕХ Тушенка
    vbIsTushenka:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 2790412); -- ЦЕХ Тушенка


    -- таблица -
   CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, AmountPartnerPrior TFloat) ON COMMIT DROP;
   --
   INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountPartner, AmountPartnerPrior)
                                 WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup WHERE UnitId <> inFromId)
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                        , CASE WHEN Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                                                        , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                                                        , zc_Enum_InfoMoney_30201() -- Мясное сырье

                                                                                                        , zc_Enum_InfoMoney_30102() -- Доходы + Продукция + Тушенка
                                                                                                         )
                                                                    THEN TRUE
                                                               ELSE FALSE
                                                          END AS isGoodsKind
                                                   FROM Object_InfoMoney_View
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE ((Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Доходы + Продукция + Готовая продукция 
                                                        OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30102()            -- Доходы + Продукция + Тушенка
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье + запечена...
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsTushenka = FALSE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30102() -- Доходы + Продукция + Тушенка
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsTushenka = TRUE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- Доходы + Продукция + Готовая продукция
                                                        OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30201()            -- Доходы + Мясное сырье + Мясное сырье
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = TRUE AND vbIsTushenka = FALSE)
                                                  )
                    , tmpOrder_all AS (SELECT MovementItem.ObjectId                                                    AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                            AS GoodsKindId
                                            , SUM (CASE WHEN Movement.OperDate = inOperDate THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartner
                                            , SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END) AS AmountPartnerPrior
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

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                       WHERE Movement.OperDate BETWEEN (inOperDate - INTERVAL '7 DAY') AND inOperDate + INTERVAL '0 DAY'
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
                                       )
                        , tmpOrder AS (SELECT tmpOrder_all.GoodsId
                                            , CASE WHEN tmpGoods.isGoodsKind = TRUE AND tmpOrder_all.GoodsKindId = 0 THEN zc_GoodsKind_Basis() WHEN tmpGoods.isGoodsKind = TRUE THEN tmpOrder_all.GoodsKindId ELSE 0 END AS GoodsKindId
                                            , SUM (tmpOrder_all.AmountPartner)      AS AmountPartner
                                            , SUM (tmpOrder_all.AmountPartnerPrior) AS AmountPartnerPrior
                                       FROM tmpOrder_all
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpOrder_all.GoodsId
                                       GROUP BY tmpOrder_all.GoodsId
                                              , CASE WHEN tmpGoods.isGoodsKind = TRUE AND tmpOrder_all.GoodsKindId = 0 THEN zc_GoodsKind_Basis() WHEN tmpGoods.isGoodsKind = TRUE THEN tmpOrder_all.GoodsKindId ELSE 0 END
                                       )
                 , tmpMI_all AS (SELECT MovementItem.Id                               AS MovementItemId
                                      , MovementItem.ObjectId                         AS GoodsId
                                      , CASE WHEN tmpGoods.isGoodsKind = TRUE AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0 THEN zc_GoodsKind_Basis()
                                             WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                             ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                        END AS GoodsKindId
                                      , MovementItem.Amount
                                        -- № п/п
                                      , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId
                                                                      , CASE WHEN tmpGoods.isGoodsKind = TRUE AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0 THEN zc_GoodsKind_Basis()
                                                                             WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                                             ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                                        END
                                                           ORDER BY MovementItem.Id DESC
                                                          ) AS Ord
                                 FROM MovementItem 
                                      LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                )
                     , tmpMI AS (SELECT tmpMI_all.MovementItemId
                                      , tmpMI_all.GoodsId
                                      , tmpMI_all.GoodsKindId
                                      , tmpMI_all.Amount
                                 FROM tmpMI_all 
                                 WHERE tmpMI_all.Ord = 1
                                )
       -- Результат
       SELECT tmp.MovementItemId
             , COALESCE (tmp.GoodsId,tmpOrder.GoodsId)          AS GoodsId
             , COALESCE (tmp.GoodsKindId, tmpOrder.GoodsKindId) AS GoodsKindId
             , COALESCE (tmpOrder.AmountPartner, 0)             AS AmountPartner
             , COALESCE (tmpOrder.AmountPartnerPrior, 0)        AS AmountPartnerPrior
       FROM tmpOrder
            FULL JOIN tmpMI AS tmp  ON tmp.GoodsId     = tmpOrder.GoodsId
                                   AND tmp.GoodsKindId = tmpOrder.GoodsKindId
      ;


       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                    := tmpAll.MovementItemId
                                                 , inMovementId            := inMovementId
                                                 , inGoodsId               := tmpAll.GoodsId
                                                 , inGoodsKindId           := tmpAll.GoodsKindId
                                                 , inAmount_Param          := tmpAll.AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param          := zc_MIFloat_AmountPartner()
                                                 , inAmount_ParamOrder     := tmpAll.AmountPartnerPrior * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamOrder     := zc_MIFloat_AmountPartnerPrior()
                                                 , inAmount_ParamSecond    := NULL
                                                 , inDescId_ParamSecond    := NULL
                                                 , inAmount_ParamAdd       := 0
                                                 , inDescId_ParamAdd       := 0
                                                 , inAmount_ParamNext      := 0
                                                 , inDescId_ParamNext      := 0
                                                 , inAmount_ParamNextPromo := 0
                                                 , inDescId_ParamNextPromo := 0
                                                 , inIsPack                := vbIsPack
                                                 , inIsParentMulti         := TRUE
                                                 , inUserId                := vbUserId
                                                  ) 
       FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
      ;
/*
IF inSession = '5'
THEN
    RAISE EXCEPTION 'OK';
    -- 'Повторите действие через 3 мин.'
END IF;*/


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
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= zfCalc_UserAdmin())
