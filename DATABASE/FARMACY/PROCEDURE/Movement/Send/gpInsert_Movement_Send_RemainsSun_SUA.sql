-- Function: gpInsert_Movement_Send_RemainsSun_SUA

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun_SUA (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun_SUA(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;

     -- все Товары для схемы SUN SUA
     CREATE TEMP TABLE _tmpGoods_SUN_SUA   (GoodsId Integer, KoeffSUN TFloat, UnitOutId Integer) ON COMMIT DROP;

     -- все Подразделения для схемы SUN SUA
     CREATE TEMP TABLE _tmpUnit_SUN_SUA   (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean) ON COMMIT DROP;

     -- Выкладки
     CREATE TEMP TABLE _tmpGoodsLayout_SUN_SUA (GoodsId Integer, UnitId Integer, Layout TFloat) ON COMMIT DROP;

     -- Маркетинговый план для точек
     CREATE TEMP TABLE _tmpGoods_PromoUnit_SUA (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     CREATE TEMP TABLE _tmpGoods_TP_exception_SUA   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- Уже использовано в текущем СУН
     CREATE TEMP TABLE _tmpGoods_Sun_exception_SUA   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all_SUA   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_SUA   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. вся статистика продаж - OVER
     CREATE TEMP TABLE _tmpSale_over_SUA   (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     -- 2.2. NotSold
     CREATE TEMP TABLE _tmpSale_not_SUA (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     CREATE TEMP TABLE _tmpStockRatio_all_SUA   (GoodsId Integer, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AverageSales TFloat, StockRatio TFloat) ON COMMIT DROP;

     -- 2.5. "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
     CREATE TEMP TABLE _tmpGoods_SUN_PairSun_SUA (GoodsId Integer, GoodsId_PairSun Integer) ON COMMIT DROP;

     -- 3.1. все остатки, СРОК
     CREATE TEMP TABLE _tmpRemains_Partion_all_SUA   (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;

     -- 3.2. остатки, СРОК - для распределения
     CREATE TEMP TABLE _tmpRemains_Partion_SUA   (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;

     -- 4. Остатки по которым есть Автозаказ и срок
     CREATE TEMP TABLE _tmpRemains_calc_SUA   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat, AmountUse TFloat) ON COMMIT DROP;

     -- 5. распределяем-1 остатки - по всем аптекам
     CREATE TEMP TABLE _tmpResult_SUA   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;

     IF NOT EXISTS(SELECT Movement.id
                   FROM Movement
                   WHERE Movement.OperDate = inOperDate - ((date_part('DOW', inOperDate)::Integer - 1)::TVarChar||' DAY')::INTERVAL
                     AND Movement.DescId = zc_Movement_FinalSUA()
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                   )
     THEN
       RETURN;
     END IF;

     SELECT Movement.id
     INTO vbMovementId
     FROM Movement
     WHERE Movement.OperDate = inOperDate - ((date_part('DOW', inOperDate)::Integer - 1)::TVarChar||' DAY')::INTERVAL
       AND Movement.DescId = zc_Movement_FinalSUA()
       AND Movement.StatusId = zc_Enum_Status_Complete();
       
     -- !!!1 - сформировали данные во временные табл!!!
     PERFORM lpInsert_Movement_Send_RemainsSun_SUA (inOperDate:= inOperDate
                                                  , inDriverId:= 0 -- vbDriverId_1
                                                  , inUserId  := vbUserId
                                                   );

     -- создали документы
     UPDATE _tmpResult_SUA SET MovementId = tmp.MovementId
     FROM (SELECT tmp.UnitId_from
                , tmp.UnitId_to
                , gpInsertUpdate_Movement_Send (ioId               := 0
                                              , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                              , inOperDate         := inOperDate
                                              , inFromId           := UnitId_from
                                              , inToId             := UnitId_to
                                              , inComment          := 'Товар по СУА'
                                              , inChecked          := FALSE
                                              , inisComplete       := FALSE
                                              , inNumberSeats      := 1
                                              , inDriverSunId      := 0
                                              , inSession          := inSession
                                               ) AS MovementId

           FROM (SELECT DISTINCT _tmpResult_SUA.UnitId_from, _tmpResult_SUA.UnitId_to FROM _tmpResult_SUA WHERE _tmpResult_SUA.Amount > 0) AS tmp
          ) AS tmp
     WHERE _tmpResult_SUA.UnitId_from = tmp.UnitId_from
       AND _tmpResult_SUA.UnitId_to   = tmp.UnitId_to
          ;

     -- сохранили свойство <Перемещение по СУН> + isAuto
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
     FROM (SELECT DISTINCT _tmpResult_SUA.MovementId FROM _tmpResult_SUA WHERE _tmpResult_SUA.Amount > 0
          ) AS tmp;


     -- 6.1. создали строки - Перемещение по СУН
     UPDATE _tmpResult_SUA SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inCommentSendID        := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_SUA AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp
     WHERE _tmpResult_SUA.MovementId = tmp.MovementId
       AND _tmpResult_SUA.GoodsId    = tmp.GoodsId
          ;

     -- 8. Удаляем документы, что б не мешали
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_SUA.MovementId FROM _tmpResult_SUA WHERE _tmpResult_SUA.MovementId > 0
          ) AS tmp;
    
     -- 9. Cохранили количество <Сформировано в перемещение>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SendSUN(), MovementItem.Id, COALESCE(SUM(_tmpResult_SUA.Amount), 0))
     FROM MovementItem

         LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                          ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                         AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                         
         LEFT JOIN _tmpResult_SUA ON _tmpResult_SUA.UnitId_to = MILinkObject_Unit.ObjectId 
                                 AND _tmpResult_SUA.GoodsId = MovementItem.ObjectId
                                 AND _tmpResult_SUA.MovementItemId > 0

     WHERE MovementItem.MovementId = vbMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = False
     GROUP BY MovementItem.Id, MovementItem.ObjectId, MILinkObject_Unit.ObjectId
     HAVING SUM(_tmpResult_SUA.Amount) > 0;
             
     -- 10. сохранили свойство <Дата перемещений>
     IF EXISTS(SELECT 1 FROM _tmpResult_SUA WHERE _tmpResult_SUA.Amount > 0)
     THEN
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Calculation(), vbMovementId, CURRENT_DATE);
     END IF;

     -- RAISE EXCEPTION '<ok>';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21                                        *
*/

-- тест
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun_SUA (inOperDate:= CURRENT_DATE + INTERVAL '3 DAY', inSession:= zfCalc_UserAdmin()) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ