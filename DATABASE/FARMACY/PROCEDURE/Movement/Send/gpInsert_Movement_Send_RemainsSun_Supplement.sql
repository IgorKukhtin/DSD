-- Function: gpInsert_Movement_Send_RemainsSun_Supplement

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun_Supplement (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun_Supplement(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;

     -- все Товары для схемы SUN Supplement
     CREATE TEMP TABLE _tmpGoods_SUN_Supplement   (GoodsId Integer, KoeffSUN TFloat, UnitOutId Integer) ON COMMIT DROP;

     -- все Подразделения для схемы SUN Supplement
     CREATE TEMP TABLE _tmpUnit_SUN_Supplement   (UnitId Integer, DeySupplSun1 Integer, MonthSupplSun1 Integer, isSUN_Supplement_in Boolean, isSUN_Supplement_out Boolean, isSUN_Supplement_Priority Boolean) ON COMMIT DROP;

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     CREATE TEMP TABLE _tmpGoods_TP_exception_Supplement   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- Уже использовано в текущем СУН
     CREATE TEMP TABLE _tmpGoods_Sun_exception_Supplement   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all_Supplement   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountRemains TFloat, AmountNotSend TFloat, AmountSalesDay TFloat, AmountSalesMonth TFloat, AverageSalesMonth TFloat, Need TFloat, AmountUse TFloat, MinExpirationDate TDateTime, isCloseMCS boolean) ON COMMIT DROP;

     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     CREATE TEMP TABLE _tmpStockRatio_all_Supplement   (GoodsId Integer, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AverageSales TFloat, StockRatio TFloat) ON COMMIT DROP;

     -- 3. распределяем-1 остатки - по всем аптекам
     CREATE TEMP TABLE _tmpResult_Supplement   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;



     -- !!!1 - сформировали данные во временные табл!!!
     PERFORM lpInsert_Movement_Send_RemainsSun_Supplement (inOperDate:= inOperDate
                                                         , inDriverId:= 0 -- vbDriverId_1
                                                         , inUserId  := vbUserId
                                                          );

     -- создали документы
     UPDATE _tmpResult_Supplement SET MovementId = tmp.MovementId
     FROM (SELECT tmp.UnitId_from
                , tmp.UnitId_to
                , gpInsertUpdate_Movement_Send (ioId               := 0
                                              , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                              , inOperDate         := inOperDate
                                              , inFromId           := UnitId_from
                                              , inToId             := UnitId_to
                                              , inComment          := 'Распределение товара по сети согласно дополнению к СУН1'
                                              , inChecked          := FALSE
                                              , inisComplete       := FALSE
                                              , inNumberSeats      := 1
                                              , inDriverSunId      := 0
                                              , inSession          := inSession
                                               ) AS MovementId

           FROM (SELECT DISTINCT _tmpResult_Supplement.UnitId_from, _tmpResult_Supplement.UnitId_to FROM _tmpResult_Supplement WHERE _tmpResult_Supplement.Amount > 0) AS tmp
          ) AS tmp
     WHERE _tmpResult_Supplement.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Supplement.UnitId_to   = tmp.UnitId_to
          ;

     -- сохранили свойство <Перемещение по СУН> + isAuto + zc_Enum_PartionDateKind_6
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
     FROM (SELECT DISTINCT _tmpResult_Supplement.MovementId FROM _tmpResult_Supplement WHERE _tmpResult_Supplement.Amount > 0
          ) AS tmp;


     -- 6.1. создали строки - Перемещение по СУН
     UPDATE _tmpResult_Supplement SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inCommentTRID          := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Supplement AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp
     WHERE _tmpResult_Supplement.MovementId = tmp.MovementId
       AND _tmpResult_Supplement.GoodsId    = tmp.GoodsId
          ;

     -- 8. Удаляем документы, что б не мешали
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Supplement.MovementId FROM _tmpResult_Supplement WHERE _tmpResult_Supplement.MovementId > 0
          ) AS tmp;

     --raise notice 'Value 05: %', (select Count(*) from _tmpResult_Supplement WHERE _tmpResult_Supplement.MovementId > 0);      
     --RAISE EXCEPTION '<ok>';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.19                                        *
*/

-- тест
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun_Supplement (inOperDate:= CURRENT_DATE + INTERVAL '2 DAY', inSession:= zfCalc_UserAdmin()) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ

