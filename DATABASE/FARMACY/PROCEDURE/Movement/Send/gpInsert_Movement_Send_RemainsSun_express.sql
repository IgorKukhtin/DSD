-- Function: gpInsert_Movement_Send_RemainsSun_express

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun_express (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun_express(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;

   DECLARE vbDriverId_1 Integer;
   DECLARE vbDriverId_2 Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;
     

     -- !!!ВЫХОД для zfCalc_UserAdmin - т.к. автоматом надо формировать только 1 раз
     /*IF inSession = zfCalc_UserAdmin()
        AND (EXISTS (SELECT Movement.Id AS MovementId
                     FROM Movement
                          INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                     ON MovementBoolean_SUN.MovementId = Movement.Id
                                                    AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                    AND MovementBoolean_SUN.ValueData  = TRUE
                     WHERE Movement.OperDate = CURRENT_DATE
                       -- AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId = zc_Enum_Status_Erased()
                    )
          OR EXISTS (SELECT Movement.Id AS MovementId
                     FROM Movement
                          INNER JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                     ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                    AND MovementBoolean_DefSUN.DescId     = zc_MovementBoolean_DefSUN()
                                                    AND MovementBoolean_DefSUN.ValueData = TRUE
                     WHERE Movement.OperDate = CURRENT_DATE
                       AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId = zc_Enum_Status_Erased()
                    )
            )
     THEN
         -- ВЫХОД
         RETURN;
     END IF;*/


     -- все Подразделения для схемы SUN-EXPRESS
     CREATE TEMP TABLE _tmpUnit_SUN   (UnitId Integer, isSUN_out Boolean, isSUN_in Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_a (UnitId Integer, isSUN_out Boolean, isSUN_in Boolean) ON COMMIT DROP;
     -- Выкладка
     CREATE TEMP TABLE _tmpGoods_Layout  (UnitId Integer, GoodsId Integer, Layout TFloat, isNotMoveRemainder6 boolean, MovementLayoutId Integer) ON COMMIT DROP;
     -- Маркетинговый план для точек
     CREATE TEMP TABLE _tmpGoods_PromoUnit  (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     -- Товары дисконтных проектов
     CREATE TEMP TABLE _tmpGoods_DiscountExternal  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва излишек/потребность у Отправителя/Получателя
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Amount_sale TFloat, Summ_sale TFloat, AmountResult_in TFloat, AmountResult_out TFloat, AmountRemains TFloat, AmountRemains_calc_in TFloat, AmountRemains_calc_out TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_all_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Amount_sale TFloat, Summ_sale TFloat, AmountResult_in TFloat, AmountResult_out TFloat, AmountRemains TFloat, AmountRemains_calc_in TFloat, AmountRemains_calc_out TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains   (UnitId Integer, GoodsId Integer, Price TFloat, AmountResult TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_a (UnitId Integer, GoodsId Integer, Price TFloat, AmountResult TFloat) ON COMMIT DROP;
     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     CREATE TEMP TABLE _tmpGoods_TP_exception   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 2.1. вся статистика продаж - EXPRESS
     CREATE TEMP TABLE _tmpSale_express   (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSale_express_a (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     -- 2.3. товары для Кратность
     CREATE TEMP TABLE _tmpGoods_express   (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 3.2. остатки, СРОК - для распределения
     CREATE TEMP TABLE _tmpRemains_Partion   (UnitId Integer, GoodsId Integer, AmountRemains TFloat, AmountResult TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_a (UnitId Integer, GoodsId Integer, AmountRemains TFloat, AmountResult TFloat) ON COMMIT DROP;

     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     CREATE TEMP TABLE _tmpSumm_limit   (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSumm_limit_a (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion   (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_Partion_a (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;

     -- 7.1. распределяем перемещения - по партиям со сроками
     CREATE TEMP TABLE _tmpResult_child   (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_child_a (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- !!!1 - сформировали данные во временные табл!!!
     PERFORM lpInsert_Movement_Send_RemainsSun_express (inOperDate:= inOperDate
                                                      , inDriverId:= vbDriverId_1
                                                      , inStep    := 1
                                                      , inUserId  := vbUserId
                                                       );
     -- !!!1 - перенесли данные
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;
     INSERT INTO _tmpResult_child_a   SELECT * FROM _tmpResult_child;


     -- !!!Удаляем предыдущие документы - SUN-v3 !!!
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, FALSE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v3(), tmp.MovementId, FALSE)
     FROM (SELECT Movement.Id AS MovementId
           FROM Movement
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                -- !!!только для таких Аптек!!!
                INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_From.ObjectId
                --
                INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                          AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                          AND MovementBoolean_SUN.ValueData  = TRUE
                INNER JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                           ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                          AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                          AND MovementBoolean_SUN_v3.ValueData  = TRUE
           WHERE Movement.OperDate = CURRENT_DATE
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId = zc_Enum_Status_Erased()
          ) AS tmp;



     -- создали документы
     UPDATE _tmpResult_Partion_a SET MovementId = tmp.MovementId
     FROM (SELECT tmp.UnitId_from
                , tmp.UnitId_to
                , gpInsertUpdate_Movement_Send (ioId               := 0
                                              , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                              , inOperDate         := inOperDate
                                              , inFromId           := UnitId_from
                                              , inToId             := UnitId_to
                                              , inComment          := ''
                                              , inChecked          := FALSE
                                              , inisComplete       := FALSE
                                              , inNumberSeats      := 1
                                              , inDriverSunId      := 0
                                              , inSession          := inSession
                                               ) AS MovementId

           FROM (SELECT DISTINCT _tmpResult_Partion_a.UnitId_from, _tmpResult_Partion_a.UnitId_to FROM _tmpResult_Partion_a) AS tmp
          ) AS tmp
     WHERE _tmpResult_Partion_a.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Partion_a.UnitId_to   = tmp.UnitId_to
          ;

     -- сохранили свойство <Перемещение по СУН-v3> + isAuto
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v3(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Driver(),          tmp.MovementId, tmp.DriverId)
     FROM (SELECT DISTINCT _tmpResult_Partion_a.MovementId, _tmpResult_Partion_a.DriverId FROM _tmpResult_Partion_a WHERE _tmpResult_Partion_a.Amount > 0
          ) AS tmp;


     -- 6.1. создали строки - Перемещение по СУН
     UPDATE _tmpResult_Partion_a SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inCommentSendID         := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Partion_a AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp
     WHERE _tmpResult_Partion_a.MovementId = tmp.MovementId
       AND _tmpResult_Partion_a.GoodsId    = tmp.GoodsId
          ;



     -- 8. Удаляем документы, что б не мешали
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Partion_a.MovementId FROM _tmpResult_Partion_a WHERE _tmpResult_Partion_a.MovementId > 0
          ) AS tmp;



  -- RAISE EXCEPTION '<ok>';


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.19                                        *
*/

-- тест
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun_express (inOperDate:= ('17.01.2022')::TDateTime, inSession:= zfCalc_UserAdmin()) 