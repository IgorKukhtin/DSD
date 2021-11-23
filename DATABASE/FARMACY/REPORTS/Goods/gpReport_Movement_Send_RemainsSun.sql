-- Function: gpReport_Movement_Send_RemainsSun()

DROP FUNCTION IF EXISTS gpReport_Movement_Send_RemainsSun (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun(
    IN inOperDate      TDateTime,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId     Integer;

  DECLARE vbDriverId_1 Integer;
  DECLARE vbDriverId_2 Integer;

  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
  DECLARE Cursor3 refcursor;
  DECLARE Cursor4 refcursor;
  DECLARE Cursor5 refcursor;

  DECLARE vbDate_0 TDateTime;
  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_1 TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;


     -- !!!первый водитель!!!
     vbDriverId_1 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                     );
     -- !!!второй водитель!!!
     vbDriverId_2 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                        AND ObjectLink_Unit_Driver.ChildObjectId <> vbDriverId_1
                     );

    -- дата + 6 месяцев
    vbDate_6:= inOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- дата + 1 месяц
    vbDate_1:= inOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               )
               -- меняем: добавим еще 9 дней, будет от 60 дней включительно - только для СУН
             + INTERVAL '9 DAY'
             ;
    -- дата + 0 месяцев
    vbDate_0 := inOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );

     -- все Подразделения для схемы SUN
     CREATE TEMP TABLE _tmpUnit_SUN   (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isOnlyTimingSUN Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_a (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isOnlyTimingSUN Boolean) ON COMMIT DROP;
     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     CREATE TEMP TABLE _tmpUnit_SUN_balance   (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_a (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_partion   (UnitId Integer, Summ_out TFloat, Summ_in TFloat, Summ_out_calc TFloat, Summ_in_calc TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_partion_a (UnitId Integer, Summ_out TFloat, Summ_in TFloat, Summ_out_calc TFloat, Summ_in_calc TFloat) ON COMMIT DROP;
     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     CREATE TEMP TABLE _tmpGoods_TP_exception   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     -- Выкладка
     CREATE TEMP TABLE _tmpGoods_Layout  (UnitId Integer, GoodsId Integer, Layout TFloat) ON COMMIT DROP;
     -- Маркетинговый план для точек
     CREATE TEMP TABLE _tmpGoods_PromoUnit  (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     -- Товары дисконтных проектов
     CREATE TEMP TABLE _tmpGoods_DiscountExternal  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_all_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. вся статистика продаж
     CREATE TEMP TABLE _tmpSale   (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSale_a (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;

     -- 2.2. товары для Кратность
     CREATE TEMP TABLE _tmpGoods_SUN (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 2.3. "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
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
     CREATE TEMP TABLE _tmpResult_Partion   (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer, Amount_not_out TFloat, Summ_not_out TFloat, Amount_not_in TFloat, Summ_not_in TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_Partion_a (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer, Amount_not_out TFloat, Summ_not_out TFloat, Amount_not_in TFloat, Summ_not_in TFloat) ON COMMIT DROP;
     -- 6.2. !!!товары - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     CREATE TEMP TABLE _tmpList_DefSUN   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpList_DefSUN_a (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. распределяем перемещения - по партиям со сроками
     CREATE TEMP TABLE _tmpResult_child   (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_child_a (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 8. исключаем такие перемещения
     CREATE TEMP TABLE _tmpUnit_SunExclusion (UnitId_from Integer, UnitId_to Integer) ON COMMIT DROP;


     -- Результат
     CREATE TEMP TABLE _tmpResult (DriverId Integer, DriverName TVarChar
                                 , UnitId Integer, UnitName TVarChar
                                 , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, isClose boolean
                                 , Amount_sale         TFloat --
                                 , Summ_sale           TFloat --
                                 , AmountSun_real      TFloat -- сумма сроковых по реальным остаткам, должно сходиться с AmountSun_summ_save
                                 , AmountSun_summ_save TFloat -- сумма сроковых, без учета изменения
                                 , AmountSun_summ      TFloat -- сумма сроковых + notSold, которые будем распределять
                                 , AmountSunOnly_summ  TFloat -- сумма сроковых, которые будем распределять
                                 , Amount_notSold_summ TFloat -- сумма notSold, которые будем распределять
                                 , AmountResult        TFloat -- Автозаказ
                                 , AmountResult_summ   TFloat -- итого Автозаказ по всем Аптекам
                                 , AmountRemains       TFloat -- Остаток
                                 , AmountIncome        TFloat -- Приход (ожидаемый)
                                 , AmountSend_in       TFloat -- Перемещение - приход (ожидается)
                                 , AmountSend_out      TFloat -- Перемещение - расход (ожидается)
                                 , AmountOrderExternal TFloat -- Заказ (ожидаемый)
                                 , AmountReserve       TFloat -- Резерв по чекам
                                 , AmountSun_unit      TFloat -- инф.=0, сроковые на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
                                 , AmountSun_unit_save TFloat -- инф.=0, сроковые на этой аптеке, без учета изменения
                                 , Price               TFloat -- Цена
                                 , MCS                 TFloat -- НТЗ
                                 , Layout              TFloat -- Выкладка
                                 , PromoUnit           TFloat -- Марк. план длч точки
                                 , isCloseMCS          boolean -- Убить код
                                 , Summ_min            TFloat -- информативно - мнимальн сумма
                                 , Summ_max            TFloat -- информативно - максимальн сумма
                                 , Unit_count          TFloat -- информативно - кол-во таких накл.
                                 , Summ_min_1          TFloat -- информативно - после распределения-1: мнимальн сумма
                                 , Summ_max_1          TFloat -- информативно - после распределения-1: максимальн сумма
                                 , Unit_count_1        TFloat -- информативно - после распределения-1: кол-во таких накл.
                                 , Summ_min_2          TFloat -- информативно - после распределения-2: мнимальн сумма
                                 , Summ_max_2          TFloat -- информативно - после распределения-2: максимальн сумма
                                 , Unit_count_2        TFloat -- информативно - после распределения-2: кол-во таких накл.
                                 , Summ_str            TVarChar
                                 , Summ_next_str       TVarChar
                                 , UnitName_str        TVarChar
                                 , UnitName_next_str   TVarChar
                                   -- !!!результат!!!
                                 , Amount_res          TFloat
                                 , Summ_res            TFloat
                                 , Amount_next_res     TFloat
                                 , Summ_next_res       TFloat
                                 , Amount_not_out_res  TFloat
                                 , Summ_not_out_res    TFloat
                                 , Amount_not_in_res   TFloat
                                 , Summ_not_in_res     TFloat
                                 ) ON COMMIT DROP;
     -- Результат - ПЕРВЫЙ водитель
     INSERT INTO _tmpResult (DriverId, DriverName
                           , UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName, isClose
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_real
                           , AmountSun_summ_save
                           , AmountSun_summ
                           , AmountSunOnly_summ
                           , Amount_notSold_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountIncome
                           , AmountSend_in
                           , AmountSend_out
                           , AmountOrderExternal
                           , AmountReserve
                           , AmountSun_unit
                           , AmountSun_unit_save
                           , Price
                           , MCS
                           , Layout
                           , PromoUnit
                           , isCloseMCS
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_min_2
                           , Summ_max_2
                           , Unit_count_2
                           , Summ_str
                           , Summ_next_str
                           , UnitName_str
                           , UnitName_next_str
                           , Amount_res
                           , Summ_res
                           , Amount_next_res
                           , Summ_next_res
                           , Amount_not_out_res
                           , Summ_not_out_res
                           , Amount_not_in_res
                           , Summ_not_in_res
                            )
          SELECT COALESCE (vbDriverId_1, 0)                              :: Integer  AS DriverId
               , COALESCE (lfGet_Object_ValueData_sh (vbDriverId_1), '') :: TVarChar AS DriverName
               , COALESCE (tmp.UnitId, 0)      :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, '')   :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, 0)     :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, 0)   :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, '')  :: TVarChar AS GoodsName
               , COALESCE (tmp.isClose, False)             AS isClose
               , tmp.Amount_sale
               , tmp.Summ_sale
               , tmp.AmountSun_real
               , tmp.AmountSun_summ_save
               , tmp.AmountSun_summ
               , tmp.AmountSunOnly_summ
               , tmp.Amount_notSold_summ
               , COALESCE (tmp.AmountResult, 0)        :: TFloat AS AmountResult
               , tmp.AmountResult_summ
               , COALESCE (tmp.AmountRemains, 0)       :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountIncome, 0)        :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend_in, 0)       :: TFloat AS AmountSend_in
               , COALESCE (tmp.AmountSend_out, 0)      :: TFloat AS AmountSend_out
               , COALESCE (tmp.AmountOrderExternal, 0) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, 0)       :: TFloat AS AmountReserve
               , tmp.AmountSun_unit
               , tmp.AmountSun_unit_save
               , COALESCE (tmp.Price, 0) :: TFloat AS Price
               , COALESCE (tmp.MCS, 0)   :: TFloat AS MCS
               , COALESCE (tmp.Layout, 0):: TFloat AS Layout
               , COALESCE (tmp.PromoUnit, 0):: TFloat AS PromoUnit
               , COALESCE (tmp.isCloseMCS, False)       AS isCloseMCS
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_min_2
               , tmp.Summ_max_2
               , tmp.Unit_count_2
               , tmp.Summ_str
               , tmp.Summ_next_str
               , tmp.UnitName_str
               , tmp.UnitName_next_str
               , tmp.Amount_res
               , tmp.Summ_res
               , tmp.Amount_next_res
               , tmp.Summ_next_res
               , tmp.Amount_not_out_res
               , tmp.Summ_not_out_res
               , tmp.Amount_not_in_res
               , tmp.Summ_not_in_res
          FROM lpInsert_Movement_Send_RemainsSun (inOperDate := inOperDate
                                                , inDriverId := 0 -- vbDriverId_1
                                                , inStep     := 1
                                                , inUserId   := vbUserId
                                                 ) AS tmp
         ;
     -- !!!1 - перенесли данные
     INSERT INTO _tmpUnit_SUN_a SELECT * FROM _tmpUnit_SUN;
     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     INSERT INTO _tmpUnit_SUN_balance_a         SELECT * FROM _tmpUnit_SUN_balance;
     INSERT INTO _tmpUnit_SUN_balance_partion_a SELECT * FROM _tmpUnit_SUN_balance_partion;
     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     INSERT INTO _tmpRemains_all_a SELECT * FROM _tmpRemains_all;
     INSERT INTO _tmpRemains_a     SELECT * FROM _tmpRemains;
     -- 2. вся статистика продаж
     INSERT INTO _tmpSale_a SELECT * FROM _tmpSale;
     -- 3.1. все остатки, СРОК
     INSERT INTO _tmpRemains_Partion_all_a SELECT * FROM _tmpRemains_Partion_all;
     -- 3.2. остатки, СРОК - для распределения
     INSERT INTO _tmpRemains_Partion_a SELECT * FROM _tmpRemains_Partion;
     -- 4. Остатки по которым есть Автозаказ и срок
     INSERT INTO _tmpRemains_calc_a SELECT * FROM _tmpRemains_calc;
     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     INSERT INTO _tmpSumm_limit_a SELECT * FROM _tmpSumm_limit;
     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;
     -- 6.2. !!!товары - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     INSERT INTO _tmpList_DefSUN_a SELECT * FROM _tmpList_DefSUN;
     -- 7.1. распределяем перемещения - по партиям со сроками
     INSERT INTO _tmpResult_child_a   SELECT * FROM _tmpResult_child;


/*
     -- Результат - ВТОРОЙ водитель
     INSERT INTO _tmpResult (DriverId, DriverName
                           , UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_real
                           , AmountSun_summ_save
                           , AmountSun_summ
                           , AmountSunOnly_summ
                           , Amount_notSold_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountIncome
                           , AmountSend_in
                           , AmountSend_out
                           , AmountOrderExternal
                           , AmountReserve
                           , AmountSun_unit
                           , AmountSun_unit_save
                           , Price
                           , MCS
                           , Layout
                           , PromoUnit
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_min_2
                           , Summ_max_2
                           , Unit_count_2
                           , Summ_str
                           , Summ_next_str
                           , UnitName_str
                           , UnitName_next_str
                           , Amount_res
                           , Summ_res
                           , Amount_next_res
                           , Summ_next_res
                            )
          SELECT COALESCE (vbDriverId_2, 0)                              :: Integer  AS DriverId
               , COALESCE (lfGet_Object_ValueData_sh (vbDriverId_2), '') :: TVarChar AS DriverName
               , COALESCE (tmp.UnitId, 0)      :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, '')   :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, 0)     :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, 0)   :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, '')  :: TVarChar AS GoodsName
               , tmp.Amount_sale
               , tmp.Summ_sale
               , tmp.AmountSun_real
               , tmp.AmountSun_summ_save
               , tmp.AmountSun_summ
               , tmp.AmountSunOnly_summ
               , tmp.Amount_notSold_summ
               , COALESCE (tmp.AmountResult, 0)        :: TFloat AS AmountResult
               , tmp.AmountResult_summ
               , COALESCE (tmp.AmountRemains, 0)       :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountIncome, 0)        :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend_in, 0)       :: TFloat AS AmountSend_in
               , COALESCE (tmp.AmountSend_out, 0)      :: TFloat AS AmountSend_out
               , COALESCE (tmp.AmountOrderExternal, 0) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, 0)       :: TFloat AS AmountReserve
               , tmp.AmountSun_unit
               , tmp.AmountSun_unit_save
               , COALESCE (tmp.Price, 0)  :: TFloat AS Price
               , COALESCE (tmp.MCS, 0)    :: TFloat AS MCS
               , COALESCE (tmp.Layout, 0) :: TFloat AS Layout
               , COALESCE (tmp.PromoUnit, 0) :: TFloat AS PromoUnit
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_min_2
               , tmp.Summ_max_2
               , tmp.Unit_count_2
               , tmp.Summ_str
               , tmp.Summ_next_str
               , tmp.UnitName_str
               , tmp.UnitName_next_str
               , tmp.Amount_res
               , tmp.Summ_res
               , tmp.Amount_next_res
               , tmp.Summ_next_res
          FROM lpInsert_Movement_Send_RemainsSun (inOperDate := inOperDate
                                                , inDriverId := vbDriverId_2
                                                , inStep     := 1
                                                , inUserId   := vbUserId
                                                 ) AS tmp
         ;
     -- !!!2 - перенесли данные
     INSERT INTO _tmpUnit_SUN_a SELECT * FROM _tmpUnit_SUN;
     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     INSERT INTO _tmpUnit_SUN_balance_a         SELECT * FROM _tmpUnit_SUN_balance;
     INSERT INTO _tmpUnit_SUN_balance_partion_a SELECT * FROM _tmpUnit_SUN_balance_partion;
     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     INSERT INTO _tmpRemains_all_a SELECT * FROM _tmpRemains_all;
     INSERT INTO _tmpRemains_a     SELECT * FROM _tmpRemains;
     -- 2. вся статистика продаж
     INSERT INTO _tmpSale_a SELECT * FROM _tmpSale;
     -- 3.1. все остатки, СРОК
     INSERT INTO _tmpRemains_Partion_all_a SELECT * FROM _tmpRemains_Partion_all;
     -- 3.2. остатки, СРОК - для распределения
     INSERT INTO _tmpRemains_Partion_a SELECT * FROM _tmpRemains_Partion;
     -- 4. Остатки по которым есть Автозаказ и срок
     INSERT INTO _tmpRemains_calc_a SELECT * FROM _tmpRemains_calc;
     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     INSERT INTO _tmpSumm_limit_a SELECT * FROM _tmpSumm_limit;
     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;
     -- 6.2. !!!товары - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     INSERT INTO _tmpList_DefSUN_a SELECT * FROM _tmpList_DefSUN;
     -- 7.1. распределяем перемещения - по партиям со сроками
     INSERT INTO _tmpResult_child_a   SELECT * FROM _tmpResult_child;
*/

      -- добавили ВСЕ остатки
     /*INSERT INTO _tmpResult (UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_real
                           , AmountSun_summ_save
                           , AmountSun_summ
                           , AmountSunOnly_summ
                           , Amount_notSold_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountIncome
                           , AmountSend_in
                           , AmountSend_out
                           , AmountOrderExternal
                           , AmountReserve
                           , AmountSun_unit
                           , AmountSun_unit_save
                           , Price
                           , MCS
                           , Layout
                           , PromoUnit
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_min_2
                           , Summ_max_2
                           , Unit_count_2
                           , Summ_str
                           , Summ_next_str
                           , UnitName_str
                           , UnitName_next_str
                           , Amount_res
                           , Summ_res
                           , Amount_next_res
                           , Summ_next_res
                            )
          SELECT COALESCE (tmp.UnitId, _tmpRemains_all.UnitId)     :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, Object_Unit.ValueData)    :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, _tmpRemains_all.GoodsId)   :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, Object_Goods.ObjectCode) :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, Object_Goods.ValueData)  :: TVarChar AS GoodsName
               , tmp.Amount_sale
               , tmp.Summ_sale
               , tmp.AmountSun_real
               , tmp.AmountSun_summ_save
               , tmp.AmountSun_summ
               , tmp.AmountSunOnly_summ
               , tmp.Amount_notSold_summ
               , COALESCE (tmp.AmountResult, _tmpRemains_all.AmountResult)               :: TFloat AS AmountResult
               , tmp.AmountResult_summ                                                   
               , COALESCE (tmp.AmountRemains, _tmpRemains_all.AmountRemains)             :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountIncome, _tmpRemains_all.AmountIncome)               :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend_in, _tmpRemains_all.AmountSend_in)             :: TFloat AS AmountSend_in
               , COALESCE (tmp.AmountSend_out, _tmpRemains_all.AmountSend_out)           :: TFloat AS AmountSend_out
               , COALESCE (tmp.AmountOrderExternal, _tmpRemains_all.AmountOrderExternal) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, _tmpRemains_all.AmountReserve)             :: TFloat AS AmountReserve
               , tmp.AmountSun_unit
               , tmp.AmountSun_unit_save
               , COALESCE (tmp.Price, _tmpRemains_all.Price)   :: TFloat AS Price
               , COALESCE (tmp.MCS, _tmpRemains_all.MCS)       :: TFloat AS MCS
               , COALESCE (tmp.Layout, _tmpRemains_all.Layout) :: TFloat AS Layout
               , COALESCE (tmp.PromoUnit, _tmpRemains_all.PromoUnit) :: TFloat AS PromoUnit
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_min_2
               , tmp.Summ_max_2
               , tmp.Unit_count_2
               , tmp.Summ_str
               , tmp.Summ_next_str
               , tmp.UnitName_str
               , tmp.UnitName_next_str
               , tmp.Amount_res
               , tmp.Summ_res
               , tmp.Amount_next_res
               , tmp.Summ_next_res
          FROM _tmpRemains_all_a AS _tmpRemains_all
               LEFT JOIN _tmpResult AS tmp
                                    ON tmp.UnitId  = _tmpRemains_all.UnitId
                                   AND tmp.GoodsId = _tmpRemains_all.GoodsId
               LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains_all.UnitId
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains_all.GoodsId
          WHERE tmp.GoodsId IS NULL;
          */

     IF EXISTS (SELECT COUNT(*) FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1)
        AND 1=1
     THEN
         RAISE EXCEPTION 'Ошибка.Дублируется товар: % %(%) % %(%) % %(%)'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT tmpRes.UnitId_from FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1))
                       ,                            (SELECT tmpRes.UnitId_from FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT tmpRes.UnitId_to   FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1))
                       ,                            (SELECT tmpRes.UnitId_to   FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1)
                       , CHR (13)
                       , lfGet_Object_ValueData    ((SELECT tmpRes.GoodsId     FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1))
                       ,                            (SELECT tmpRes.GoodsId     FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1)
                        ;
     END IF;



     OPEN Cursor1 FOR
          SELECT *
          FROM _tmpResult AS tmp;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
          SELECT tmp.*
               , tmp.UnitId_from
               , Object_UnitFrom.ValueData AS FromName
               , tmp.UnitId_to
               , Object_UnitTo.ValueData   AS ToName
               , Object_Goods_Main.ObjectCode AS GoodsCode
               , Object_Goods_Main.Name       AS GoodsName
               , Object_Goods_Main.isClose    AS isClose
                 -- сумма сроковых, без учета изменения
               , tmpRemains_Partion_sum.AmountSun_summ_save
                 -- сумма сроковых + notSold, которые будем распределять
               , tmpRemains_Partion_sum.AmountSun_summ
                 -- сумма только сроковых, которые будем распределять
               , tmpRemains_Partion_sum.AmountSunOnly_summ
                 -- сумма только notSold, которые будем распределять
               , tmpRemains_Partion_sum.Amount_notSold_summ
                 --
               , tmpRemains_Partion_sum.Amount_sale
               , tmpRemains_Partion_sum.MCSValue AS MCS
               , _tmpGoods_Layout.Layout   AS Layout
               , _tmpGoods_PromoUnit.Amount   AS PromoUnit
               , _tmpRemains.isCloseMCS
               , _tmpRemains.AmountResult
               , _tmpRemains.AmountRemains
                 -- отложенные Чеки + не проведенные с CommentError
               , _tmpRemains.AmountReserve
                 -- Перемещение - приход (ожидается)
               , _tmpRemains.AmountSend_in
                 -- Перемещение - расход (ожидается)
               , _tmpRemains.AmountSend_out
               , _tmpRemains.Price

               , tmp.Amount_not_out -- Кол-во блок расход
               , tmp.Summ_not_out   -- Сумма блок расход
               , tmp.Amount_not_in  -- Кол-во блок приход
               , tmp.Summ_not_in    -- Сумма блок приход

          FROM _tmpResult_Partion_a AS tmp
               LEFT JOIN Object AS Object_UnitFrom  ON Object_UnitFrom.Id  = tmp.UnitId_from
               LEFT JOIN Object AS Object_UnitTo  ON Object_UnitTo.Id  = tmp.UnitId_to
               -- итого сроковые + notSold которые будем распределять
               LEFT JOIN (SELECT _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId, _tmpRemains_Partion.MCSValue, _tmpRemains_Partion.Amount_sale
                                , SUM (_tmpRemains_Partion.Amount_save)    AS AmountSun_summ_save
                                , SUM (_tmpRemains_Partion.Amount)         AS AmountSun_summ
                                , SUM (_tmpRemains_Partion.Amount_sun)     AS AmountSunOnly_summ
                                , SUM (_tmpRemains_Partion.Amount_notSold) AS Amount_notSold_summ
                          FROM _tmpRemains_Partion_a AS _tmpRemains_Partion
                          GROUP BY _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId, _tmpRemains_Partion.MCSValue, _tmpRemains_Partion.Amount_sale
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.UnitId  = tmp.UnitId_from
                                                    AND tmpRemains_Partion_sum.GoodsId = tmp.GoodsId
               -- все остатки, НТЗ
               LEFT JOIN _tmpRemains_all_a AS _tmpRemains
                                           ON _tmpRemains.UnitId  = tmp.UnitId_from
                                          AND _tmpRemains.GoodsId = tmp.GoodsId
               
               LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
               LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

               LEFT JOIN _tmpGoods_PromoUnit ON _tmpGoods_PromoUnit.UnitId = tmp.UnitId_from
                                            AND _tmpGoods_PromoUnit.GoodsId = tmp.GoodsId

               LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = tmp.UnitId_from
                                         AND _tmpGoods_Layout.GoodsId = tmp.GoodsId

          ;
     RETURN NEXT Cursor2;

     OPEN Cursor3 FOR
          WITH
          tmp_Result AS (SELECT tmp.*
                              , COALESCE (ObjectDate_Value.ValueData, zc_DateEnd())           AS ExpirationDate_in
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)    AS MovementId_Income
                              , CASE WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_0 THEN zc_Enum_PartionDateKind_0()
                                     WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_0  AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_1 THEN zc_Enum_PartionDateKind_1()
                                     WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_1  AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_6 THEN zc_Enum_PartionDateKind_6()
                                     ELSE 0
                                END                                                          AS PartionDateKindId
                         FROM _tmpResult_child_a AS tmp
                              LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ContainerId = tmp.ContainerId
                                                           AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                              LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                         ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                        AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()

                              -- находим партию
                              LEFT JOIN ContainerlinkObject AS CLO_PartionMovementItem
                                                            ON CLO_PartionMovementItem.ContainerId = tmp.ContainerId
                                                           AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                              -- элемент прихода
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                              /*LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate_in
                                                                ON MIDate_ExpirationDate_in.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                               AND MIDate_ExpirationDate_in.DescId = zc_MIDate_PartionGoods()*/
                        )

          SELECT tmp.*
               , Object_UnitFrom.ValueData        AS FromName
               , Object_UnitTo.ValueData          AS ToName
               , Movement_Income.Id               AS MovementId
               , Movement_Income.OperDate         AS OperDate
               , Movement_Income.Invnumber        AS Invnumber
               , tmp.ContainerId
               , tmp.MovementId
               , tmp.ExpirationDate_in
               , Object_PartionDateKind.ValueData AS PartionDateKindName
          FROM tmp_Result AS tmp
               LEFT JOIN Object AS Object_UnitFrom ON Object_UnitFrom.Id = tmp.UnitId_from
               LEFT JOIN Object AS Object_UnitTo   ON Object_UnitTo.Id   = tmp.UnitId_to
               LEFT JOIN Movement ON Movement.Id = tmp.MovementId
               LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmp.MovementId_Income
               LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmp.PartionDateKindId
              ;
     RETURN NEXT Cursor3;


     OPEN Cursor4 FOR
          SELECT Object_Goods.Id           AS GoodsId
               , Object_Goods.ObjectCode   AS GoodsCode
               , Object_Goods.ValueData    AS GoodsName
               , Object_UnitFrom.Id        AS FrimId
               , Object_UnitFrom.ValueData AS FromName
               , Object_UnitTo.Id          AS ToId
               , Object_UnitTo.ValueData   AS ToName
          FROM _tmpList_DefSUN_a AS tmp
               LEFT JOIN Object AS Object_UnitFrom ON Object_UnitFrom.Id = tmp.UnitId_from
               LEFT JOIN Object AS Object_UnitTo   ON Object_UnitTo.Id   = tmp.UnitId_to
               LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmp.GoodsId
          ;
     RETURN NEXT Cursor4;

     OPEN Cursor5 FOR
          SELECT Object_Unit.Id        AS UnitId
               , Object_Unit.ValueData AS UnitName
               , tmp1.Summ_out
               , tmp1.Summ_in
               , tmp1.KoeffOutSUN
               , tmp1.KoeffInSUN
               , tmp2.Summ_out      AS Summ_out_partion
               , tmp2.Summ_in       AS Summ_in_partion
               , tmp2.Summ_out_calc AS Summ_out_partion_calc
               , tmp2.Summ_in_calc  AS Summ_in_partion_calc
          FROM _tmpUnit_SUN
               LEFT JOIN _tmpUnit_SUN_balance_a         AS tmp1 ON tmp1.UnitId = _tmpUnit_SUN.UnitId
               LEFT JOIN _tmpUnit_SUN_balance_partion_a AS tmp2 ON tmp2.UnitId = _tmpUnit_SUN.UnitId
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpUnit_SUN.UnitId
          WHERE tmp1.Summ_out      <> 0 OR tmp1.Summ_in      <> 0
             OR tmp2.Summ_out      <> 0 OR tmp2.Summ_in      <> 0
             OR tmp2.Summ_out_calc <> 0 OR tmp2.Summ_in_calc <> 0
          ;
     RETURN NEXT Cursor5;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.19         *
*/

-- тест
-- SELECT * FROM gpReport_Movement_Send_RemainsSun (inOperDate:= CURRENT_DATE + INTERVAL '3 DAY', inSession:= '3'); -- FETCH ALL "<unnamed portal 1>";