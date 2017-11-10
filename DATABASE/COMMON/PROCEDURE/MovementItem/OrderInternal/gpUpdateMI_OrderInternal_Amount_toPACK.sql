-- Function: gpUpdateMI_OrderInternal_Amount_toPACK()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_toPACK (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_Amount_toPACK(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inIsClear             Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;

   DECLARE vbOperDate TDateTime;
   DECLARE vbDayCount Integer;

   DECLARE vbNumber   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_OrderInternal_toPACK());
     vbUserId:= lpGetUserBySession (inSession);


    IF inIsClear = TRUE
    THEN
        -- пересчитали Итоговые суммы по накладной
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    ELSE
        -- определяется
        SELECT Movement.OperDate
             , 1 + EXTRACT (DAY FROM (MovementDate_OperDateEnd.ValueData - MovementDate_OperDateStart.ValueData))
               INTO vbOperDate, vbDayCount
        FROM Movement
             LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                   AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
             LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                   AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
        WHERE Movement.Id = inMovementId;
        
        -- Проверка
        IF COALESCE (vbDayCount, 0) <= 0
        THEN
            RAISE EXCEPTION 'vbDayCount <%>', vbDayCount;
        END IF;
        

        -- сохранили
        CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, AmountSecond TFloat) ON COMMIT DROP;
        -- Сохранили
        INSERT INTO _tmpMI_master (MovementItemId, GoodsId, GoodsKindId, Amount, AmountSecond)
           SELECT MovementItem.Id                                AS MovementItemId
                , MovementItem.ObjectId                          AS GoodsId
                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                , MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS Amount
                , COALESCE (MIFloat_AmountSecond.ValueData, 0)   AS AmountSecond
           FROM MovementItem
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                 ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                            ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                            ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                           AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                     AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                    AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId     = zc_MI_Master()
             AND MovementItem.isErased   = FALSE
             AND COALESCE (MILinkObject_GoodsComplete.ObjectId, 0) = 0 -- т.е. НЕ упакованный
             AND COALESCE (MIFloat_ContainerId.ValueData, 0)       = 0 -- отбросили остатки на ПР-ВЕ
             AND (MovementItem.Amount > 0 OR MIFloat_AmountSecond.ValueData > 0)
          ;


        -- сохранили
        CREATE TEMP TABLE _tmpMI_Child (MovementItemId Integer, GoodsId_complete Integer, GoodsKindId_complete Integer, GoodsId Integer, GoodsKindId Integer
                                      , RemainsStart TFloat
                                      , CountForecast TFloat
                                      , AmountResult TFloat, AmountSecondResult TFloat
                                       ) ON COMMIT DROP;
        -- Сохранили
        INSERT INTO _tmpMI_Child (MovementItemId, GoodsId_complete, GoodsKindId_complete, GoodsId, GoodsKindId
                                , RemainsStart
                                , CountForecast
                                , AmountResult
                                , AmountSecondResult
                                 )
           SELECT MovementItem.Id                                AS MovementItemId
                , CASE WHEN MILinkObject_GoodsComplete.ObjectId     > 0 THEN MILinkObject_GoodsComplete.ObjectId     ELSE MovementItem.ObjectId                         END AS GoodsId_complete
                , CASE WHEN MILinkObject_GoodsKindComplete.ObjectId > 0 THEN MILinkObject_GoodsKindComplete.ObjectId ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0) END AS GoodsKindId_complete
                , MovementItem.ObjectId                          AS GoodsId
                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId

                  -- <Нач остаток> МИНУС <неотгруж. заявка (итого)> МИНУС <сегодня заявка (итого)>
                , (CASE WHEN MIFloat_AmountRemains.ValueData > 0 THEN MIFloat_AmountRemains.ValueData ELSE 0 END
                - COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0) - COALESCE (MIFloat_AmountPartnerPriorPromo.ValueData, 0)
                - COALESCE (MIFloat_AmountPartner.ValueData, 0)      - COALESCE (MIFloat_AmountPartnerPromo.ValueData, 0)
                  ) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                  AS RemainsStart

                  -- <Прогн 1д>
                , CASE WHEN COALESCE (MIFloat_AmountForecast.ValueData, 0) > 0
                            THEN COALESCE (MIFloat_AmountForecast.ValueData, 0)      / vbDayCount
                            ELSE COALESCE (MIFloat_AmountForecastOrder.ValueData, 0) / vbDayCount
                  END * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                  AS CountForecast

                  -- Вот он, РЕЗУЛЬТАТ
                , 0 AS AmountResult
                , 0 AS AmountSecondResult

           FROM MovementItem
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                 ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                 ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsKindComplete.DescId         = zc_MILinkObject_GoodsKindComplete()

                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                            ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                           AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                            ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountRemains.DescId         = zc_MIFloat_AmountRemains()

                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
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
                LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastPromo
                                            ON MIFloat_AmountForecastPromo.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountForecastPromo.DescId         = zc_MIFloat_AmountForecastPromo()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrderPromo
                                            ON MIFloat_AmountForecastOrderPromo.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountForecastOrderPromo.DescId         = zc_MIFloat_AmountForecastOrderPromo()

                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                     AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                    AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId     = zc_MI_Master()
             AND MovementItem.isErased   = FALSE
             AND COALESCE (MIFloat_ContainerId.ValueData, 0)       = 0 -- отбросили остатки на ПР-ВЕ
          ;
          



         -- Первый
         vbNumber:= 0;
         WHILE vbNumber <= 100
         LOOP
             UPDATE _tmpMI_Child SET AmountResult = _tmpMI_Child.AmountResult + tmpResult.Amount_result
             FROM (WITH -- сумма - сколько уже распределили
                        tmpMI_summ AS (SELECT _tmpMI_Child.GoodsId_complete     AS GoodsId_master
                                            , _tmpMI_Child.GoodsKindId_complete AS GoodsKindId_master
                                            , SUM (_tmpMI_Child.AmountResult)   AS AmountResult
                                       FROM _tmpMI_Child
                                       WHERE _tmpMI_Child.AmountResult <> 0 OR _tmpMI_Child.AmountSecondResult <> 0
                                       GROUP BY _tmpMI_Child.GoodsId_complete
                                              , _tmpMI_Child.GoodsKindId_complete
                                     )
                        -- объединили Master и Child
                      , tmpMI_all AS (SELECT _tmpMI_Child.MovementItemId
                                           , _tmpMI_master.GoodsId     AS GoodsId_master
                                           , _tmpMI_master.GoodsKindId AS GoodsKindId_master
                                             -- сколько осталось для распределения
                                           , _tmpMI_master.Amount - COALESCE (tmpMI_summ.AmountResult, 0) AS Amount_master
                                             -- сколько надо на vbNumber ДНЕЙ
                                           , vbNumber * _tmpMI_Child.CountForecast - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult)
                                              AS Amount_result
                                      FROM _tmpMI_master
                                           INNER JOIN _tmpMI_Child ON _tmpMI_Child.GoodsId_complete     = _tmpMI_master.GoodsId
                                                                  AND _tmpMI_Child.GoodsKindId_complete = _tmpMI_master.GoodsKindId
                                           LEFT JOIN tmpMI_summ  ON tmpMI_summ.GoodsId_master     = _tmpMI_master.GoodsId
                                                                AND tmpMI_summ.GoodsKindId_master = _tmpMI_master.GoodsKindId
    
                                      WHERE -- если есть что распределять
                                            _tmpMI_master.Amount - COALESCE (tmpMI_summ.AmountResult, 0) > 0
                                            -- если на vbNumber ДНЕЙ ЕСТЬ ПОТРЕБНОСТЬ
                                        AND 0 < vbNumber * _tmpMI_Child.CountForecast - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult)
                                     )
                        -- ИТОГО по Child для ПРОПОРЦИИ
                      , tmpMI_all_summ AS (SELECT tmpMI_all.GoodsId_master
                                                , tmpMI_all.GoodsKindId_master
                                                , SUM (tmpMI_all.Amount_result) AS Amount_result
                                           FROM tmpMI_all
                                           GROUP BY tmpMI_all.GoodsId_master
                                                  , tmpMI_all.GoodsKindId_master
                                          )
                   -- Результат - здесь распределяем, НО ТОЛЬКО ЕСЛИ НАДО
                   SELECT tmpMI_all.MovementItemId
                        , CASE -- если в Master больше чем ИТОГО по Child
                               WHEN tmpMI_all_summ.Amount_result <= tmpMI_all.Amount_master
                                    -- тогда сколько надо на vbNumber ДНЕЙ, т.е. НЕ распределяем
                                    THEN ROUND (tmpMI_all.Amount_result, 1)
                               ELSE -- иначе Распределяем
                                    ROUND (tmpMI_all.Amount_master * tmpMI_all.Amount_result / tmpMI_all_summ.Amount_result, 1)
                                    -- tmpMI_all.Amount_result
                                    -- tmpMI_all.Amount_master
                                    
                          END AS Amount_result
                   FROM tmpMI_all
                        INNER JOIN tmpMI_all_summ ON tmpMI_all_summ.GoodsId_master     = tmpMI_all.GoodsId_master
                                                 AND tmpMI_all_summ.GoodsKindId_master = tmpMI_all.GoodsKindId_master
                  ) AS tmpResult
             WHERE tmpResult.MovementItemId = _tmpMI_Child.MovementItemId;

             -- теперь следуюющий
             vbNumber := vbNumber + 1;

         END LOOP;
       

         -- ВТОРОЙ
         vbNumber:= 0;
         WHILE vbNumber < 100
         LOOP
             UPDATE _tmpMI_Child SET AmountSecondResult = _tmpMI_Child.AmountSecondResult + tmpResult.Amount_result
             FROM (WITH -- сумма - сколько уже распределили
                        tmpMI_summ AS (SELECT _tmpMI_Child.GoodsId_complete         AS GoodsId_master
                                            , _tmpMI_Child.GoodsKindId_complete     AS GoodsKindId_master
                                            , SUM (_tmpMI_Child.AmountSecondResult) AS AmountResult
                                       FROM _tmpMI_Child
                                       WHERE _tmpMI_Child.AmountResult <> 0 OR _tmpMI_Child.AmountSecondResult <> 0
                                       GROUP BY _tmpMI_Child.GoodsId_complete
                                              , _tmpMI_Child.GoodsKindId_complete
                                     )
                        -- объединили Master и Child
                      , tmpMI_all AS (SELECT _tmpMI_Child.MovementItemId
                                           , _tmpMI_master.GoodsId     AS GoodsId_master
                                           , _tmpMI_master.GoodsKindId AS GoodsKindId_master
                                             -- сколько осталось для распределения
                                           , _tmpMI_master.AmountSecond - COALESCE (tmpMI_summ.AmountResult, 0) AS Amount_master
                                             -- сколько надо на vbNumber ДНЕЙ
                                           , vbNumber * _tmpMI_Child.CountForecast - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult)
                                              AS Amount_result
                                      FROM _tmpMI_master
                                           INNER JOIN _tmpMI_Child ON _tmpMI_Child.GoodsId_complete     = _tmpMI_master.GoodsId
                                                                  AND _tmpMI_Child.GoodsKindId_complete = _tmpMI_master.GoodsKindId
                                           LEFT JOIN tmpMI_summ  ON tmpMI_summ.GoodsId_master     = _tmpMI_master.GoodsId
                                                                AND tmpMI_summ.GoodsKindId_master = _tmpMI_master.GoodsKindId
    
                                      WHERE -- если есть что распределять
                                            _tmpMI_master.AmountSecond - COALESCE (tmpMI_summ.AmountResult, 0) > 0 -- если есть что распределять
                                            -- если на vbNumber ДНЕЙ ЕСТЬ ПОТРЕБНОСТЬ
                                        AND 0 < vbNumber * _tmpMI_Child.CountForecast - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult)
                                     )
                        -- ИТОГО по Child для ПРОПОРЦИИ
                      , tmpMI_all_summ AS (SELECT tmpMI_all.GoodsId_master
                                                , tmpMI_all.GoodsKindId_master
                                                , SUM (tmpMI_all.Amount_result) AS Amount_result
                                           FROM tmpMI_all
                                           GROUP BY tmpMI_all.GoodsId_master
                                                  , tmpMI_all.GoodsKindId_master
                                          )
                   -- Результат - здесь распределяем, НО ТОЛЬКО ЕСЛИ НАДО
                   SELECT tmpMI_all.MovementItemId
                        , CASE -- если в Master больше чем ИТОГО по Child
                               WHEN tmpMI_all_summ.Amount_result <= tmpMI_all.Amount_master
                                    -- тогда сколько надо на vbNumber ДНЕЙ, т.е. НЕ распределяем
                                    THEN ROUND (tmpMI_all.Amount_result, 1)
                               ELSE -- иначе Распределяем
                                    ROUND (tmpMI_all.Amount_master * tmpMI_all.Amount_result / tmpMI_all_summ.Amount_result, 1)
                                    -- tmpMI_all.Amount_result
                                    -- tmpMI_all.Amount_master
                                    
                          END AS Amount_result
                   FROM tmpMI_all
                        INNER JOIN tmpMI_all_summ ON tmpMI_all_summ.GoodsId_master     = tmpMI_all.GoodsId_master
                                                 AND tmpMI_all_summ.GoodsKindId_master = tmpMI_all.GoodsKindId_master
                  ) AS tmpResult
             WHERE tmpResult.MovementItemId = _tmpMI_Child.MovementItemId;

             -- теперь следуюющий
             vbNumber := vbNumber + 1;

         END LOOP;


         -- ОБНУЛИЛИ
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack(),            MovementItem.Id, 0)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack_calc(),       MovementItem.Id, 0)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond(),      MovementItem.Id, 0)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond_calc(), MovementItem.Id, 0)
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Master()
        ;

         -- СОХРАНИЛИ
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack(),            _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountResult)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack_calc(),       _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountResult)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond(),      _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountSecondResult)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond_calc(), _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountSecondResult)
         FROM _tmpMI_Child
         WHERE _tmpMI_Child.AmountResult <> 0 OR _tmpMI_Child.AmountSecondResult <> 0
        ;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.17                                        *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount_toPACK (inMovementId:= 7463900, inId:= 0, inIsClear:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount_toPACK (inMovementId:= 7463854, inId:= 0, inIsClear:= FALSE, inSession:= zfCalc_UserAdmin());
