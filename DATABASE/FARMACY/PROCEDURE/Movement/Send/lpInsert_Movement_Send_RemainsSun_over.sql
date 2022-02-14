-- Function: lpInsert_Movement_TestSend_RemainsSun_over

DROP FUNCTION IF EXISTS lpInsert_Movement_TestSend_RemainsSun_over (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_TestSend_RemainsSun_over(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inDriverId            Integer   , -- Водитель, распределяем только по аптекам этого
    IN inStep                Integer   , -- на 1-ом шаге находим DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда на 2-м шаге они участвовать не будут !!!
    IN inUserId              Integer     -- пользователь
)
RETURNS TABLE (

               DriverId Integer,
               UnitId_from Integer,
               UnitId_fromName TVarChar,
               UnitId_to Integer,
               UnitId_ToName TVarChar,
               GoodsId Integer,
               GoodsCode Integer,
               GoodsName TVarChar,
               AmountRemains TFloat,
               MCS TFloat,
               Layout TFloat,
               PromoUnit TFloat,
               Amount TFloat,
               Summ TFloat,
               Amount_next TFloat,
               Summ_next TFloat,
               MovementId Integer,
               MovementItemId Integer
              )
AS
$BODY$
   DECLARE vbObjectId Integer;
BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);


      -- все Подразделения для схемы SUN
     CREATE TEMP TABLE _tmpUnit_SUN   (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLockSale Boolean, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_a (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLockSale Boolean, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean) ON COMMIT DROP;
     -- Выкладка
     CREATE TEMP TABLE _tmpGoods_Layout  (UnitId Integer, GoodsId Integer, Layout TFloat) ON COMMIT DROP;
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

     -- 2.3. Перемещение ВСЕ SUN-кроме текущего - Erased - за СЕГОДНЯ, что б не отправлять / не получать эти товары повторно в СУН-2
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


     PERFORM lpInsert_Movement_Send_RemainsSun_Over (inOperDate:= inOperDate, inDriverId:= inDriverId, inStep:= inStep, inUserId:= inUserId);

     raise notice 'Value 05: %',  (SELECT COUNT(*) FROM _tmpUnit_SUN);

     -- Результат
     RETURN QUERY
       SELECT _tmpResult_Partion.DriverId,
              _tmpResult_Partion.UnitId_from,
              Object_Unit_from.valuedata,
              _tmpResult_Partion.UnitId_to,
              Object_Unit_to.valuedata,
              _tmpResult_Partion.GoodsId,
              Object_Goods.objectcode,
              Object_Goods.valuedata,
              _tmpRemains.AmountRemains,
              _tmpRemains.MCS,
              _tmpGoods_Layout.Layout,
              _tmpGoods_PromoUnit.Amount,
              _tmpResult_Partion.Amount,
              _tmpResult_Partion.Summ,
              _tmpResult_Partion.Amount_next,
              _tmpResult_Partion.Summ_next,
              _tmpResult_Partion.MovementId,
              _tmpResult_Partion.MovementItemId

       FROM _tmpResult_Partion
            LEFT JOIN _tmpRemains ON _tmpRemains.UnitId = _tmpResult_Partion.UnitId_from
                                 AND _tmpRemains.GoodsId = _tmpResult_Partion.GoodsId
            LEFT JOIN Object AS Object_Unit_from  ON Object_Unit_from.Id  = _tmpResult_Partion.UnitId_from
            LEFT JOIN Object AS Object_Unit_to  ON Object_Unit_to.Id  = _tmpResult_Partion.UnitId_to
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpResult_Partion.GoodsId

            LEFT JOIN _tmpGoods_PromoUnit ON _tmpGoods_PromoUnit.UnitId = _tmpResult_Partion.UnitId_from
                                         AND _tmpGoods_PromoUnit.GoodsId = _tmpResult_Partion.GoodsId

            LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = _tmpResult_Partion.UnitId_from
                                      AND _tmpGoods_Layout.GoodsId = _tmpResult_Partion.GoodsId
       ORDER BY  _tmpResult_Partion.UnitId_from,  _tmpResult_Partion.GoodsId
       ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.19         *
 18.07.19                                        *
*/
-- тест


  WITH -- SUN - за 30 дней
              tmpRemainsSun AS (SELECT * FROM lpInsert_Movement_TestSend_RemainsSun_Over (inOperDate:= CURRENT_DATE + INTERVAL '3 DAY', inDriverId:= 0, inStep:= 1, inUserId:= 3))
        , tmpLayout AS (SELECT MovementItem.ObjectId              AS GoodsId
                             , MAX (MovementItem.Amount):: TFloat AS Amount
                        FROM Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                                    AND MovementItem.Amount > 0
                        WHERE Movement.DescId = zc_Movement_Layout()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        GROUP BY MovementItem.ObjectId
                       )


select *

        from tmpRemainsSun

--where tmpRemainsSun.GoodsId in

--             INNER JOIN tmpLayout ON tmpLayout.GoodsId = tmpRemainsSun.GoodsId

/*             LEFT JOIN (SELECT OL_GoodsPairSun.ObjectId      AS GoodsId
                             , OL_GoodsPairSun.ChildObjectId AS GoodsId_PairSun
                        FROM ObjectLink AS OL_GoodsPairSun
                        WHERE OL_GoodsPairSun.ChildObjectId > 0 AND OL_GoodsPairSun.DescId = zc_ObjectLink_Goods_GoodsPairSun()) AS GoodsPair
                                                                                                                                 ON GoodsPair.GoodsId =  tmpRemainsSun.GoodsId

             LEFT JOIN tmpRemainsSun AS MI_PairSun
                                     ON MI_PairSun.GoodsId =  GoodsPair.GoodsId_PairSun
--                                    AND MI_PairSun.UnitId =  tmpRemainsSun.UnitId
                                    AND MI_PairSun.UnitId_From =  tmpRemainsSun.UnitId_From
                                    AND MI_PairSun.UnitId_To =  tmpRemainsSun.UnitId_To
*/
/*        where tmpRemainsSun.GoodsId in (SELECT OL_GoodsPairSun.ObjectId      AS GoodsId
                                        FROM ObjectLink AS OL_GoodsPairSun
                                        WHERE OL_GoodsPairSun.ChildObjectId > 0 AND OL_GoodsPairSun.DescId = zc_ObjectLink_Goods_GoodsPairSun());
*/