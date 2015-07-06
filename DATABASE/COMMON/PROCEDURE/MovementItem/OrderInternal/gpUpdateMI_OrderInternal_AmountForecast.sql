-- Function: gpUpdateMI_OrderInternal_AmountForecast()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountForecast (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountForecast(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStartDate           TDateTime , -- Дата документа
    IN inEndDate             TDateTime , -- Дата документа
    IN inFromId              Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsPack  Boolean;
   DECLARE vbIsBasis Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- расчет, временно захардкодил
    vbIsPack:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 8451); -- Цех Упаковки
    -- расчет, временно захардкодил
    vbIsBasis:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_From() AND MovementId = inMovementId AND ObjectId IN (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (8446) AS tmp)); -- ЦЕХ колбаса+дел-сы
 

     -- таблица -
     CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountForecastOrder TFloat, AmountForecast TFloat) ON COMMIT DROP;
    
     -- 
                                 WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup)
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                   FROM Object_InfoMoney_View
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE ((Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция + Готовая продукция and Тушенка and Хлеб
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье : запечена...
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = FALSE)
                                                   OR ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                                        OR Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Продукция + Готовая продукция
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                          )
                                                         AND vbIsPack = TRUE AND vbIsBasis = FALSE)
                                                   OR ((Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                                                        -- OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Незавершенное производство
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsBasis = TRUE)
                                                  )
                                    , tmpMIAll AS
                                      (-- 1.1 Заявки
                                       SELECT MovementItem.ObjectId                                                    AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                            AS GoodsKindId
                                            , SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountOrder
                                            , 0                                                                        AS AmountSale
                                       FROM Movement 
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
                                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId = zc_Movement_OrderExternal()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                         AND vbIsBasis = FALSE
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)) <> 0
                                      UNION ALL
                                       -- 1.2 Продажи
                                       SELECT MovementItem.ObjectId                               AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , 0                                                   AS AmountOrder
                                            , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountSale
                                       FROM MovementDate AS MovementDate_OperDatePartner
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = MovementDate_OperDatePartner.MovementId
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId
                                            INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                                               AND Movement.DescId = zc_Movement_Sale()
                                                               AND Movement.StatusId = zc_Enum_Status_Complete()

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                       WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                         AND vbIsBasis = FALSE
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) <> 0   
                                      UNION ALL
                                       -- 1.3 Перемещение на филиал
                                       SELECT MovementItem.ObjectId                               AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , 0                                                   AS AmountOrder
                                            , SUM (COALESCE (MovementItem.Amount, 0))             AS AmountSale
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId = zc_Movement_SendOnPrice()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                         AND vbIsBasis = FALSE
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (COALESCE (MovementItem.Amount, 0)) <> 0   

                                      UNION ALL
                                       -- 2. !!!!ПРОИЗВОДСТВО!!!
                                       SELECT MovementItem.ObjectId                               AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                                            , 0                                                   AS AmountOrder
                                            , SUM (COALESCE (MovementItem.Amount, 0))             AS AmountSale
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                         AND MovementLinkObject_To.ObjectId = MovementLinkObject_From.ObjectId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Child()
                                                                   AND MovementItem.isErased   = FALSE
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                         AND Movement.DescId = zc_Movement_ProductionUnion()
                                         AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                         AND vbIsBasis = TRUE
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (COALESCE (MovementItem.Amount, 0)) <> 0   
                                      )
                                    , tmpMI AS
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
                                      )
                               INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountForecastOrder, AmountForecast)
                                 SELECT tmpMI.MovementItemId
                                       , COALESCE (tmpMI.GoodsId,tmpAll.GoodsId)          AS GoodsId
                                       , COALESCE (tmpMI.GoodsKindId, tmpAll.GoodsKindId) AS GoodsKindId
                                       , COALESCE (tmpAll.AmountOrder, 0)                 AS AmountForecastOrder
                                       , COALESCE (tmpAll.AmountSale, 0)                  AS AmountForecast
                                 FROM (SELECT tmpMIAll.GoodsId
                                            , tmpMIAll.GoodsKindId
                                            , SUM (tmpMIAll.AmountOrder) AS AmountOrder
                                            , SUM (tmpMIAll.AmountSale)  AS AmountSale
                                       FROM tmpMIAll
                                       GROUP BY tmpMIAll.GoodsId
                                              , tmpMIAll.GoodsKindId
                                       ) AS tmpAll
                                 FULL JOIN tmpMI ON tmpMI.GoodsId = tmpAll.GoodsId
                                                AND tmpMI.GoodsKindId = tmpAll.GoodsKindId
                     ;

       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId
                                                 , inAmount_Param       := tmpAll.AmountForecast * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountForecast()
                                                 , inAmount_ParamOrder  := CASE WHEN vbIsBasis = FALSE
                                                                                     THEN tmpAll.AmountForecastOrder * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                                                ELSE NULL
                                                                           END
                                                 , inDescId_ParamOrder  := CASE WHEN vbIsBasis = FALSE
                                                                                     THEN zc_MIFloat_AmountForecastOrder()
                                                                                ELSE NULL
                                                                           END
                                                 , inIsPack             := CASE WHEN vbIsBasis = FALSE
                                                                                     THEN vbIsPack
                                                                                ELSE NULL
                                                                           END
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
 19.06.15                                        * all
 03.03.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountForecast (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
 