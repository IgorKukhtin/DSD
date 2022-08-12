-- Function: gpInsert_Movement_Send_RemainsSun_pi

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun_pi (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun_pi(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inSession             TVarChar    -- сессия пользователя
)
-- RETURNS VOID
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime)
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
                     WHERE Movement.OperDate = inOperDate
                       -- AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId = zc_Enum_Status_Erased()
                    )
          OR EXISTS (SELECT Movement.Id AS MovementId
                     FROM Movement
                          INNER JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                     ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                    AND MovementBoolean_DefSUN.DescId     = zc_MovementBoolean_DefSUN()
                                                    AND MovementBoolean_DefSUN.ValueData = TRUE
                     WHERE Movement.OperDate = inOperDate
                       AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId = zc_Enum_Status_Erased()
                    )
            )
     THEN
         -- ВЫХОД
         RETURN;
     END IF;*/


     -- все Подразделения для схемы SUN
     CREATE TEMP TABLE _tmpUnit_SUN   (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_a (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean) ON COMMIT DROP;
     -- Выкладка
     CREATE TEMP TABLE _tmpGoods_Layout  (UnitId Integer, GoodsId Integer, Layout TFloat, isNotMoveRemainder6 boolean, MovementLayoutId Integer) ON COMMIT DROP;
     -- Маркетинговый план для точек
     CREATE TEMP TABLE _tmpGoods_PromoUnit  (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     -- Товары дисконтных проектов
     CREATE TEMP TABLE _tmpGoods_DiscountExternal  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     CREATE TEMP TABLE _tmpUnit_SUN_balance   (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_a (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     CREATE TEMP TABLE _tmpGoods_TP_exception   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_all_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. вся статистика продаж - OVER
     CREATE TEMP TABLE _tmpSale_over   (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSale_over_a (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     -- 2.2. NotSold
     CREATE TEMP TABLE _tmpSale_not (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 2.3. Перемещение ВСЕ SUN-кроме текущего - Erased - за СЕГОДНЯ, что б не отправлять / не получать эти товары повторно в СУН-2-пи
     CREATE TEMP TABLE  _tmpSUN_oth (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 2.4. товары для Кратность
     CREATE TEMP TABLE _tmpGoods_SUN (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 2.5. "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
     CREATE TEMP TABLE _tmpGoods_SUN_PairSun (GoodsId Integer, GoodsId_PairSun Integer, PairSunAmount TFloat) ON COMMIT DROP;

     -- 3.1. все остатки, СРОК
     CREATE TEMP TABLE _tmpRemains_Partion_all   (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_all_a (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     -- 3.2. остатки, СРОК - для распределения
     CREATE TEMP TABLE _tmpRemains_Partion   (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_a (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;

     -- 4. Остатки по которым есть Автозаказ и срок
     CREATE TEMP TABLE _tmpRemains_calc   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_calc_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     CREATE TEMP TABLE _tmpSumm_limit   (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSumm_limit_a (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion   (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_Partion_a (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     -- 6.2. !!!товары - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     CREATE TEMP TABLE _tmpList_DefSUN   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpList_DefSUN_a (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. распределяем перемещения - по партиям со сроками
     CREATE TEMP TABLE _tmpResult_child   (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_child_a (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 8. исключаем такие перемещения
     CREATE TEMP TABLE _tmpUnit_SunExclusion (UnitId_from Integer, UnitId_to Integer, isMCS_to Boolean) ON COMMIT DROP;


     -- !!!первый водитель!!!
   /*vbDriverId_1 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                     );*/
     -- !!!1 - сформировали данные во временные табл!!!
     PERFORM lpInsert_Movement_Send_RemainsSun_pi (inOperDate:= inOperDate
                                                 , inDriverId:= vbDriverId_1
                                                 , inStep    := 1
                                                 , inUserId  := vbUserId
                                                  );
     -- !!!1 - перенесли данные
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;
     INSERT INTO _tmpResult_child_a   SELECT * FROM _tmpResult_child;



     -- !!!второй водитель!!!
   /*vbDriverId_2 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                        AND ObjectLink_Unit_Driver.ChildObjectId <> vbDriverId_1
                     );
     -- !!!2 - сформировали данные во временные табл!!!
     PERFORM lpInsert_Movement_Send_RemainsSun_over (inOperDate:= inOperDate
                                                   , inDriverId:= vbDriverId_2
                                                   , inStep    := 1
                                                   , inUserId  := vbUserId
                                                    );
     -- !!!2 - перенесли данные
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;
     INSERT INTO _tmpResult_child_a   SELECT * FROM _tmpResult_child;*/
      

     -- !!!Удаляем предыдущие документы - SUN-v4 !!!
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, FALSE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v4(), tmp.MovementId, FALSE)
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
                INNER JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                           ON MovementBoolean_SUN_v4.MovementId = Movement.Id
                                          AND MovementBoolean_SUN_v4.DescId     = zc_MovementBoolean_SUN_v4()
                                          AND MovementBoolean_SUN_v4.ValueData  = TRUE
           WHERE Movement.OperDate = inOperDate
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId = zc_Enum_Status_Erased()
          ) AS tmp;

     -- !!!Удаляем предыдущие документы - DefSUN!!!
    /*PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DefSUN(), tmp.MovementId, FALSE)
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
                INNER JOIN MovementBoolean AS MovementBoolean_DefSUN
                                           ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                          AND MovementBoolean_DefSUN.DescId     = zc_MovementBoolean_DefSUN()
                                          AND MovementBoolean_DefSUN.ValueData = TRUE
           WHERE Movement.OperDate = inOperDate
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId = zc_Enum_Status_Erased()
          ) AS tmp;*/


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

           FROM (SELECT DISTINCT _tmpResult_Partion_a.UnitId_from, _tmpResult_Partion_a.UnitId_to FROM _tmpResult_Partion_a WHERE _tmpResult_Partion_a.Amount > 0) AS tmp
          ) AS tmp
     WHERE _tmpResult_Partion_a.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Partion_a.UnitId_to   = tmp.UnitId_to
          ;

     -- сохранили свойство <Перемещение по СУН-v2-PI> + isAuto
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v4(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
         --, lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartionDateKind(), tmp.MovementId, zc_Enum_PartionDateKind_6())
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
                                                  , inCommentSendID        := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Partion_a AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp
     WHERE _tmpResult_Partion_a.MovementId = tmp.MovementId
       AND _tmpResult_Partion_a.GoodsId    = tmp.GoodsId
          ;

     -- 6.2. создали строки - Отложено перемещение по СУН
     /*UPDATE _tmpResult_Partion_a SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount_next
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inCommentSendID        := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Partion_a AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount_next > 0
          ) AS tmp
     WHERE _tmpResult_Partion_a.MovementId = tmp.MovementId
       AND _tmpResult_Partion_a.GoodsId    = tmp.GoodsId
          ;*/



     -- 7.2. создали строки Child - по СУН
     /*PERFORM lpInsertUpdate_MovementItem_Send_Child (ioId         := 0
                                                   , inParentId   := tmpResult_Partion.ParentId   -- _tmpResult_child.ParentId
                                                   , inMovementId := tmpResult_Partion.MovementId -- _tmpResult_child.MovementId
                                                   , inGoodsId    := _tmpResult_child.GoodsId
                                                   , inAmount     := _tmpResult_child.Amount
                                                   , inContainerId:= _tmpResult_child.ContainerId
                                                   , inUserId     := vbUserId
                                                    )
     FROM _tmpResult_child_A AS _tmpResult_child
          LEFT JOIN (SELECT DISTINCT
                            _tmpResult_Partion.MovementId
                          , _tmpResult_Partion.UnitId_from
                          , _tmpResult_Partion.UnitId_to
                          , _tmpResult_Partion.MovementItemId AS ParentId
                          , _tmpResult_Partion.GoodsId
                     FROM _tmpResult_Partion_a AS _tmpResult_Partion
                    ) AS tmpResult_Partion
                      ON tmpResult_Partion.UnitId_from = _tmpResult_child .UnitId_from
                     AND tmpResult_Partion.UnitId_to   = _tmpResult_child .UnitId_to
                     AND tmpResult_Partion.GoodsId     = _tmpResult_child .GoodsId
                    ;*/


     -- 8. Удаляем документы, что б не мешали
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Partion_a.MovementId FROM _tmpResult_Partion_a WHERE _tmpResult_Partion_a.MovementId > 0
          ) AS tmp;


     --
     RETURN QUERY 
       SELECT DISTINCT Movement.Id, Movement.InvNumber, Movement.OperDate
       FROM _tmpResult_Partion_a 
            INNER JOIN Movement ON Movement.Id = _tmpResult_Partion_a.MovementId 
       WHERE _tmpResult_Partion_a.MovementId > 0;


  --RAISE EXCEPTION '<ok>';


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.19                                        *
*/

-- тест
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun_pi (inOperDate:= CURRENT_DATE + INTERVAL '2 DAY', inSession:= zfCalc_UserAdmin()) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ