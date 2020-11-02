-- Function: lpInsert_Movement_Send_RemainsSun_over

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_over (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_over(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inDriverId            Integer   , -- Водитель, распределяем только по аптекам этого
    IN inStep                Integer   , -- на 1-ом шаге находим DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда на 2-м шаге они участвовать не будут !!!
    IN inUserId              Integer     -- пользователь
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount_sale         TFloat --
             , Summ_sale           TFloat --
             , AmountSun_real      TFloat -- сумма сроковых по реальным остаткам, должно сходиться с AmountSun_summ_save
             , AmountSun_summ_save TFloat -- сумма сроковых, без учета изменения
             , AmountSun_summ      TFloat -- сумма сроковых + notSold, которые будем распределять
             , AmountSunOnly_summ  TFloat -- сумма сроковых, которые будем распределять
             , Amount_notSold_summ TFloat -- сумма notSold, которые будем распределять

             , AmountResult        TFloat -- Автозаказ    -- важно сколько нужно в єту аптеку
             , AmountResult_summ   TFloat -- итого Автозаказ по всем Аптекам --инф
             , AmountRemains       TFloat -- Остаток
             , AmountIncome        TFloat -- Приход (ожидаемый)--инф
             , AmountSend_in       TFloat -- Перемещение - приход (ожидается)--инф
             , AmountSend_out      TFloat -- Перемещение - расход (ожидается)--инф
             , AmountOrderExternal TFloat -- Заказ (ожидаемый)
             , AmountReserve       TFloat -- Резерв по чекам
             , AmountSun_unit      TFloat -- инф.=0, сроковые на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
             , AmountSun_unit_save TFloat -- инф.=0, сроковые на этой аптеке, без учета изменения
             , Price               TFloat -- Цена
             , MCS                 TFloat -- НТЗ
             , Layout              TFloat -- Выкладка
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
              )
AS
$BODY$
   DECLARE vbObjectId Integer;

   DECLARE vbKoeff_over TFloat;

   DECLARE vbPeriod_t1    Integer;
   DECLARE vbPeriod_t2    Integer;
   DECLARE vbPeriod_t_max Integer;

   DECLARE vbDate_6     TDateTime;
   DECLARE vbDate_1     TDateTime;
   DECLARE vbDate_0     TDateTime;
   DECLARE vbSumm_limit TFloat;

   DECLARE vbUnitId_from   Integer;
   DECLARE vbUnitId_to     Integer;
   DECLARE vbGoodsId       Integer;
   DECLARE vbAmount        TFloat;
   DECLARE vbAmount_calc   TFloat;
   DECLARE vbAmount_save   TFloat;
   DECLARE vbAmountResult  TFloat;
   DECLARE vbPrice         TFloat;
   DECLARE vbKoeffSUN      TFloat;

   DECLARE curPartion      refcursor;
   DECLARE curResult       refcursor;
   DECLARE curPartion_next refcursor;
   DECLARE curResult_next  refcursor;

   DECLARE vbContainerId     Integer;
   DECLARE vbAmount_remains  TFloat;
   DECLARE vbMovementId      Integer;
   DECLARE vbParentId        Integer;

   DECLARE curRemains        refcursor;
   DECLARE curResult_partion refcursor;

   DECLARE vbDOW_curr        TVarChar;

   DECLARE vbDayIncome_max Integer;
   DECLARE vbDaySendSUN_max Integer;
   DECLARE vbDaySendSUNAll_max Integer;

   DECLARE vbGoodsId_PairSun Integer;
   DECLARE vbPrice_PairSun   TFloat;

BEGIN

     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     -- !!!
     vbKoeff_over:= 2;

     -- !!! в днях
     vbPeriod_t1    := 35;
     vbPeriod_t2    := 25;

     -- !!!
     vbSumm_limit:= CASE WHEN 0 < (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                              THEN (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                         ELSE 1500
                    END;

     -- все Подразделения для схемы SUN-v2
     DELETE FROM _tmpUnit_SUN;
     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     IF inStep = 1 THEN DELETE FROM _tmpUnit_SUN_balance; END IF;
     -- 1. все остатки, продажи => получаем кол-ва ПОТРЕБНОСТЬ у получателя
     DELETE FROM _tmpRemains_all;
     DELETE FROM _tmpRemains;
     -- 2.1. вся статистика продаж: 1) у отправителя в разрезе T1=60 дней 2) у получателя в разрезе T2=45
     DELETE FROM _tmpSale_over;
     -- 2.2. NotSold
     DELETE FROM _tmpSale_not;
     -- 2.3. Перемещение ВСЕ SUN-кроме текущего
     DELETE FROM _tmpSUN_oth;
     -- 2.4. товары для Кратность
     DELETE FROM _tmpGoods_SUN;
     -- 2.5. "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
     DELETE FROM _tmpGoods_SUN_PairSun;
     -- 3.1. все остатки, OVER (Сверх запас)
     DELETE FROM _tmpRemains_Partion_all;
     -- 3.2. остатки, OVER (Сверх запас) - для распределения
     DELETE FROM _tmpRemains_Partion;
     -- 4. Остатки по которым есть ПОТРЕБНОСТЬ и OVER
     DELETE FROM _tmpRemains_calc;
     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     DELETE FROM _tmpSumm_limit;
     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь НЕ только >= vbSumm_limit
     DELETE FROM _tmpResult_Partion;
     -- 6.2. !!!товары - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     IF inStep = 1 THEN DELETE FROM _tmpList_DefSUN; END IF;
     -- 7.1. распределяем перемещения - по партиям со сроками
     DELETE FROM _tmpResult_child;


     -- товары для Кратность
     INSERT INTO _tmpGoods_SUN (GoodsId, KoeffSUN)
        SELECT OF_KoeffSUN.ObjectId  AS GoodsId
             , OF_KoeffSUN.ValueData AS KoeffSUN
        FROM ObjectFloat AS OF_KoeffSUN
        WHERE OF_KoeffSUN.DescId    = zc_ObjectFloat_Goods_KoeffSUN_v2()
          AND OF_KoeffSUN.ValueData > 0
       ;

     -- день недели
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;


     -- все Подразделения для схемы SUN-v2
     INSERT INTO _tmpUnit_SUN (UnitId, KoeffInSUN, KoeffOutSUN, Value_T1, Value_T2, DayIncome, DaySendSUN, DaySendSUNAll, Limit_N, isLockSale, isLock_CheckMSC, isLock_CloseGd, isLock_ClosePL)
        SELECT OB.ObjectId AS UnitId
             , 0           AS KoeffInSUN
             , 0           AS KoeffOutSUN
             , CASE WHEN OF_T1.ValueData > 0 THEN OF_T1.ValueData ELSE vbPeriod_t1 END    AS Value_T1
             , CASE WHEN OF_T2.ValueData > 0 THEN OF_T2.ValueData ELSE vbPeriod_t2 END    AS Value_T2
             , CASE WHEN OF_DI.ValueData >= 0 THEN OF_DI.ValueData ELSE 0  END :: Integer AS DayIncome
             , CASE WHEN OF_DS.ValueData >  0 THEN OF_DS.ValueData ELSE 10 END :: Integer AS DaySendSUN
             , CASE WHEN OF_DSA.ValueData > 0 THEN OF_DSA.ValueData ELSE 0 END :: Integer AS DaySendSUNAll
             , CASE WHEN OF_SN.ValueData >  0 THEN OF_SN.ValueData ELSE 0  END :: TFloat  AS Limit_N
             , COALESCE (OB_LS.ValueData, FALSE)                                          AS isLockSale
               -- TRUE = НЕ подключать чек "не для НТЗ"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 1 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLockSale
               -- TRUE = НЕТ товаров "закрыт код"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 3 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseGd
               -- TRUE = НЕТ товаров "убит код"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 5 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_ClosePL
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
             LEFT JOIN ObjectFloat   AS OF_T1  ON OF_T1.ObjectId  = OB.ObjectId AND OF_T1.DescId  = zc_ObjectFloat_Unit_T1_SUN_v2()
             LEFT JOIN ObjectFloat   AS OF_T2  ON OF_T2.ObjectId  = OB.ObjectId AND OF_T2.DescId  = zc_ObjectFloat_Unit_T2_SUN_v2()
             LEFT JOIN ObjectFloat   AS OF_DI  ON OF_DI.ObjectId  = OB.ObjectId AND OF_DI.DescId  = zc_ObjectFloat_Unit_Sun_v2Income()
             LEFT JOIN ObjectFloat   AS OF_DS  ON OF_DS.ObjectId  = OB.ObjectId AND OF_DS.DescId  = zc_ObjectFloat_Unit_HT_SUN_v2()
             LEFT JOIN ObjectFloat   AS OF_DSA ON OF_DSA.ObjectId = OB.ObjectId AND OF_DSA.DescId = zc_ObjectFloat_Unit_HT_SUN_All()
             LEFT JOIN ObjectFloat   AS OF_SN  ON OF_SN.ObjectId  = OB.ObjectId AND OF_SN.DescId  = zc_ObjectFloat_Unit_LimitSUN_N()
             LEFT JOIN ObjectBoolean AS OB_LS  ON OB_LS.ObjectId  = OB.ObjectId AND OB_LS.DescId  = zc_ObjectBoolean_Unit_SUN_v2_LockSale()
             LEFT JOIN ObjectString  AS OS_LL  ON OS_LL.ObjectId  = OB.ObjectId AND OS_LL.DescId  = zc_ObjectString_Unit_SUN_v2_Lock()

      --WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN()
        WHERE (OB.ValueData = TRUE
          --OR OB.ObjectId in (183292, 9771036) -- select * from object where Id in (183292, 9771036)
              )
          AND OB.DescId = zc_ObjectBoolean_Unit_SUN_v2()
          -- если указан день недели - проверим его
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = ''
          --OR inUserId = 3 -- Админ - отладка
              )
       ;

     -- находим максимальный
     vbDayIncome_max:= (SELECT MAX (_tmpUnit_SUN.DayIncome) FROM _tmpUnit_SUN);

     -- находим максимальный
     vbDaySendSUN_max:= (SELECT MAX (_tmpUnit_SUN.DaySendSUN) FROM _tmpUnit_SUN);
     -- находим максимальный
     vbDaySendSUNAll_max:= (SELECT MAX (_tmpUnit_SUN.DaySendSUNAll) FROM _tmpUnit_SUN);

     -- находим максимальный
     vbPeriod_t_max := (SELECT MAX (CASE WHEN _tmpUnit_SUN.Value_T1 > _tmpUnit_SUN.Value_T2 THEN _tmpUnit_SUN.Value_T1 ELSE _tmpUnit_SUN.Value_T2 END)
                        FROM _tmpUnit_SUN
                       );

     -- "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
     INSERT INTO _tmpGoods_SUN_PairSun (GoodsId, GoodsId_PairSun)
        SELECT OL_GoodsPairSun.ObjectId      AS GoodsId
             , OL_GoodsPairSun.ChildObjectId AS GoodsId_PairSun
        FROM ObjectLink AS OL_GoodsPairSun
        WHERE OL_GoodsPairSun.ChildObjectId > 0 AND OL_GoodsPairSun.DescId = zc_ObjectLink_Goods_GoodsPairSun()
       ;


     -- исключаем такие перемещения
     INSERT INTO _tmpUnit_SunExclusion (UnitId_from, UnitId_to, isMCS_to)
        SELECT COALESCE (ObjectLink_Unit_Area_From.ObjectId, ObjectLink_From.ChildObjectId, _tmpUnit_SUN_From.UnitId) AS UnitId_from
             , COALESCE (ObjectLink_Unit_Area_To.ObjectId,   ObjectLink_To.ChildObjectId,   _tmpUnit_SUN_To.UnitId)   AS UnitId_to
             , FALSE                                                              AS isMCS_to
        FROM Object
             INNER JOIN ObjectBoolean AS OB
                                      ON OB.ObjectId  = Object.Id
                                     AND OB.DescId    = zc_ObjectBoolean_SunExclusion_v2()
                                     AND OB.ValueData = TRUE
             LEFT JOIN ObjectLink AS ObjectLink_From
                                  ON ObjectLink_From.ObjectId = Object.Id
                                 AND ObjectLink_From.DescId   = zc_ObjectLink_SunExclusion_From()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Area_From
                                  ON ObjectLink_Unit_Area_From.ChildObjectId = ObjectLink_From.ChildObjectId
                                 AND ObjectLink_Unit_Area_From.DescId        = zc_ObjectLink_Unit_Area()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN AS _tmpUnit_SUN_From ON ObjectLink_From.ChildObjectId IS NULL AND ObjectLink_Unit_Area_From.ObjectId IS NULL

             LEFT JOIN ObjectLink AS ObjectLink_To
                                  ON ObjectLink_To.ObjectId = Object.Id
                                 AND ObjectLink_To.DescId   = zc_ObjectLink_SunExclusion_To()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Area_To
                                  ON ObjectLink_Unit_Area_To.ChildObjectId = ObjectLink_To.ChildObjectId
                                 AND ObjectLink_Unit_Area_To.DescId        = zc_ObjectLink_Unit_Area()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN AS _tmpUnit_SUN_To ON ObjectLink_To.ChildObjectId IS NULL AND ObjectLink_Unit_Area_To.ObjectId IS NULL

        WHERE Object.DescId   = zc_Object_SunExclusion()
          AND Object.isErased = FALSE

       UNION ALL
        SELECT COALESCE (ObjectLink_From.ChildObjectId, _tmpUnit_SUN_From.UnitId) AS UnitId_from
             , COALESCE (ObjectLink_To.ChildObjectId,   _tmpUnit_SUN_To.UnitId)   AS UnitId_to
             , OB.ValueData                                                       AS isMCS_to
        FROM Object
             INNER JOIN ObjectBoolean AS OB
                                      ON OB.ObjectId  = Object.Id
                                     AND OB.DescId    = zc_ObjectBoolean_SunExclusion_MSC_in()
                                     AND OB.ValueData = TRUE
             LEFT JOIN ObjectLink AS ObjectLink_From
                                  ON ObjectLink_From.ObjectId = Object.Id
                                 AND ObjectLink_From.DescId   = zc_ObjectLink_SunExclusion_From()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN AS _tmpUnit_SUN_From ON ObjectLink_From.ChildObjectId IS NULL

             LEFT JOIN ObjectLink AS ObjectLink_To
                                  ON ObjectLink_To.ObjectId = Object.Id
                                 AND ObjectLink_To.DescId   = zc_ObjectLink_SunExclusion_To()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN AS _tmpUnit_SUN_To ON ObjectLink_To.ChildObjectId IS NULL

        WHERE Object.DescId   = zc_Object_SunExclusion()
          AND Object.isErased = FALSE
           ;

     -- 2.1. вся статистика продаж
     -- CREATE TEMP TABLE _tmpSale_over (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     INSERT INTO _tmpSale_over (UnitId, GoodsId, Amount_t1, Summ_t1, Amount_t2, Summ_t2)
        SELECT tmp.UnitId
             , tmp.GoodsId
               -- у отправителя в разрезе T1=60 дней OR T1=30 дней
             , SUM (tmp.Amount_t1) AS Amount_t1, SUM (tmp.Summ_t1) AS Summ_t1
               -- у получателя в разрезе T2=45
             , SUM (tmp.Amount_t2) AS Amount_t2, SUM (tmp.Summ_t2) AS Summ_t2
        FROM (-- zc_Movement_Check
              SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                   , MIContainer.ObjectId_analyzer               AS GoodsId
                   , SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0)                                  ELSE 0 END) AS Amount_t1
                   , SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summ_t1
                   , SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0)                                  ELSE 0 END) AS Amount_t2
                   , SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summ_t2
              FROM MovementItemContainer AS MIContainer
                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MIContainer.WhereObjectId_analyzer
                   LEFT JOIN MovementBoolean AS MB_NotMCS
                                             ON MB_NotMCS.MovementId = MIContainer.MovementId
                                            AND MB_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                                            AND MB_NotMCS.ValueData  = TRUE
              WHERE MIContainer.DescId         = zc_MIContainer_Count()
                AND MIContainer.MovementDescId = zc_Movement_Check()
                AND MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((vbPeriod_t_max :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate
                -- !!!не учитывать если галка "не для СУН"
                AND (MB_NotMCS.MovementId IS NULL OR _tmpUnit_SUN.isLock_CheckMSC = FALSE)
              GROUP BY MIContainer.ObjectId_analyzer
                     , MIContainer.WhereObjectId_analyzer
              HAVING SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) <> 0
                  OR SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) <> 0

             UNION ALL
              -- zc_Movement_Sale
              SELECT MLO_Unit.ObjectId      AS UnitId
                   , MovementItem.ObjectId  AS GoodsId
                   , SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0)                                    ELSE 0 END) AS Amount_t1
                   , SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0) * COALESCE (MIF_Price.ValueData,0) ELSE 0 END) AS Summ_t1
                   , SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0)                                    ELSE 0 END) AS Amount_t2
                   , SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0) * COALESCE (MIF_Price.ValueData,0) ELSE 0 END) AS Summ_t2
              FROM Movement
                   INNER JOIN MovementLinkObject AS MLO_Unit
                                                 ON MLO_Unit.MovementId = Movement.Id
                                                AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId     = MLO_Unit.ObjectId
                                          AND _tmpUnit_SUN.isLockSale = FALSE
                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                   LEFT JOIN MovementItemFloat AS MIF_Price
                                               ON MIF_Price.MovementItemId = Movement.Id
                                              AND MIF_Price.DescId     = zc_MIFloat_Price()
              WHERE Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((vbPeriod_t_max :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate
                AND Movement.DescId   = zc_Movement_Sale()
                AND Movement.StatusId = zc_Enum_Status_Complete()
              GROUP BY MLO_Unit.ObjectId
                     , MovementItem.ObjectId
              HAVING SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END) <> 0
                  OR SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END) <> 0
             ) AS tmp
        GROUP BY tmp.UnitId
               , tmp.GoodsId
       ;

     -- 2.2. NotSold
     INSERT INTO _tmpSale_not (UnitId, GoodsId, Amount)
        WITH -- список для NotSold
             tmpContainer AS (SELECT Container.Id               AS ContainerId
                                   , Container.WhereObjectId    AS UnitId
                                   , Container.ObjectId         AS GoodsId
                                   , Container.Amount           AS Amount
                              FROM -- !!!только для таких Аптек!!!
                                   _tmpUnit_SUN
                                   INNER JOIN Container ON Container.WhereObjectId = _tmpUnit_SUN.UnitId
                                                       AND Container.Amount        <> 0
                                                       AND Container.DescId        = zc_Container_Count()
                             )
             -- так можно определить NotSold
           , tmpNotSold_all AS (SELECT tmpContainer.UnitID
                                     , tmpContainer.GoodsID
                                     , SUM (tmpContainer.Amount) AS Amount
                                FROM tmpContainer
                                     LEFT JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.WhereObjectId_Analyzer = tmpContainer.UnitId
                                                                    AND MIContainer.ObjectId_Analyzer      = tmpContainer.GoodsID
                                                                    AND MIContainer.DescId                 = zc_MIContainer_Count()
                                                                    AND MIContainer.OperDate               >= inOperDate - INTERVAL '250 DAY'
                                                                    AND MIContainer.Amount                 <> 0
                                                                    AND MIContainer.MovementDescId         = zc_Movement_Check()
                                WHERE MIContainer.ObjectId_Analyzer IS NULL
                                GROUP BY tmpContainer.UnitID
                                       , tmpContainer.GoodsID
                                HAVING SUM (tmpContainer.Amount) > 0
                               )
        -- Результат
        SELECT tmpNotSold_all.UnitId
             , tmpNotSold_all.GoodsId
             , tmpNotSold_all.Amount
        FROM tmpNotSold_all
       ;

     -- 2.3. Перемещение ВСЕ SUN-кроме текущего - Erased - за СЕГОДНЯ, что б не отправлять / не получать эти товары повторно в СУН-2
     INSERT INTO _tmpSUN_oth (UnitId_from, UnitId_to, GoodsId, Amount)
        SELECT MovementLinkObject_From.ObjectId AS UnitId_from
             , MovementLinkObject_To.ObjectId   AS UnitId_to
             , MovementItem.ObjectId            AS GoodsId
             , MovementItem.Amount              AS Amount
        FROM Movement
             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                          AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
             -- !!!только для таких Аптек!!!
             INNER JOIN _tmpUnit_SUN AS _tmpUnit_SUN_from ON _tmpUnit_SUN_from.UnitId = MovementLinkObject_From.ObjectId

             INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                           ON MovementLinkObject_To.MovementId = Movement.Id
                                          AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
             -- !!!только для таких Аптек!!!
             INNER JOIN _tmpUnit_SUN AS _tmpUnit_SUN_to ON _tmpUnit_SUN_to.UnitId = MovementLinkObject_To.ObjectId

             INNER JOIN MovementItem AS MovementItem
                                     ON MovementItem.MovementId = Movement.Id
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                    AND MovementItem.Amount     > 0
             INNER JOIN MovementBoolean AS MB_SUN
                                        ON MB_SUN.MovementId = Movement.Id
                                       AND MB_SUN.DescId     = zc_MovementBoolean_SUN()
                                       AND MB_SUN.ValueData  = TRUE
             LEFT JOIN MovementBoolean AS MB_SUN_v2
                                       ON MB_SUN_v2.MovementId = Movement.Id
                                      AND MB_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                      AND MB_SUN_v2.ValueData  = TRUE
        WHERE Movement.OperDate = inOperDate
          AND Movement.DescId   = zc_Movement_Send()
          AND Movement.StatusId = zc_Enum_Status_Erased()
          -- исключили текущие
          AND MB_SUN_v2.MovementId IS NULL
        --AND 1=0
       ;

     -- 2.4. все остатки, продажи => расчет кол-ва ПОТРЕБНОСТЬ у получателя
     WITH -- приход - UnComplete - за последние +/-7 дней для Date_Branch
         tmpMI_Income AS (SELECT MovementLinkObject_To.ObjectId AS UnitId
                                , MovementItem.ObjectId          AS GoodsId
                                , SUM (MovementItem.Amount)      AS Amount
                           FROM Movement
                                INNER JOIN MovementDate AS MovementDate_Branch
                                                        ON MovementDate_Branch.MovementId = Movement.Id
                                                       AND MovementDate_Branch.DescId     = zc_MovementDate_Branch()
                                                       -- AND MovementDate_Branch.ValueData >= CURRENT_DATE
                                                       AND MovementDate_Branch.ValueData BETWEEN inOperDate - INTERVAL '7 DAY' AND inOperDate + INTERVAL '7 DAY'
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                -- !!!только для таких Аптек!!!
                                INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                           WHERE Movement.DescId   = zc_Movement_Income()
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           GROUP BY MovementLinkObject_To.ObjectId, MovementItem.ObjectId
                           HAVING SUM (MovementItem.Amount) <> 0
                          )
       -- Перемещение - приход - UnComplete - за последние +/-30 дней
     , tmpMI_Send_in AS (SELECT MovementLinkObject_To.ObjectId AS UnitId_to
                              , MovementItem.ObjectId          AS GoodsId
                              , SUM (MovementItem.Amount)      AS Amount
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                 -- !!!только для таких Аптек!!!
                                 INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
                                 -- закомментил - пусть будут все перемещения, не только Авто
                                 /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                            ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                           AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                           AND MovementBoolean_isAuto.ValueData  = TRUE*/
                                 /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                           ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                          AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                                 INNER JOIN MovementItem AS MovementItem
                                                         ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 -- таким образом - попробуем "восстановить" картину - что б открыть отчет "задним" числом - для теста
                                 LEFT JOIN MovementBoolean AS MB_SUN_v2
                                                           ON MB_SUN_v2.MovementId = Movement.Id
                                                          AND MB_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                                          AND MB_SUN_v2.ValueData  = TRUE
                                                          AND Movement.OperDate    >= inOperDate
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '30 DAY' AND Movement.OperDate < inOperDate + INTERVAL '30 DAY'
                           -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           -- AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                              AND MB_SUN_v2.MovementId IS NULL
                            GROUP BY MovementLinkObject_To.ObjectId, MovementItem.ObjectId
                            HAVING SUM (MovementItem.Amount) <> 0
                           )
      -- Перемещение - расход - UnComplete - за последние +/-14 дней
    , tmpMI_Send_out AS (SELECT MovementLinkObject_From.ObjectId AS UnitId_from
                              , MovementItem.ObjectId            AS GoodsId
                              , SUM (MovementItem.Amount)        AS Amount
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                 -- !!!только для таких Аптек!!!
                                 INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_From.ObjectId
                                 -- закомментил - пусть будут все перемещения, не только Авто
                                 /*INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                                            ON MovementBoolean_isAuto.MovementId = Movement.Id
                                                           AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                           AND MovementBoolean_isAuto.ValueData  = TRUE*/
                                 LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                           ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                          AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()
                                                          AND MovementBoolean_Deferred.ValueData  = TRUE
                                 INNER JOIN MovementItem AS MovementItem
                                                         ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 -- таким образом - попробуем "восстановить" картину - что б открыть отчет "задним" числом - для теста
                                 LEFT JOIN MovementBoolean AS MB_SUN_v2
                                                           ON MB_SUN_v2.MovementId = Movement.Id
                                                          AND MB_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                                          AND MB_SUN_v2.ValueData  = TRUE
                                                          AND Movement.OperDate    >= inOperDate
                         -- WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '14 DAY' AND Movement.OperDate < inOperDate + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              AND MovementBoolean_Deferred.MovementId IS NULL
                              AND MB_SUN_v2.MovementId IS NULL
                            GROUP BY MovementLinkObject_From.ObjectId, MovementItem.ObjectId
                            HAVING SUM (MovementItem.Amount) <> 0
                           )
          -- заказы - UnComplete - !ВСЕ! Deferred
        , tmpMI_OrderExternal AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                                       , MovementItem.ObjectId            AS GoodsId
                                       , SUM (MovementItem.Amount)        AS Amount
                                  FROM Movement
                                       INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                                 AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()
                                                                 AND MovementBoolean_Deferred.ValueData  = TRUE
                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_To()
                                       -- !!!только для таких Аптек!!!
                                       INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_Unit.ObjectId
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                              AND MovementItem.DescId     = zc_MI_Master()
                                                              AND MovementItem.isErased   = FALSE

                                  WHERE Movement.DescId   = zc_Movement_OrderExternal()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                  GROUP BY MovementLinkObject_Unit.ObjectId, MovementItem.ObjectId
                                  HAVING SUM (MovementItem.Amount) <> 0
                                 )
          -- отложенные Чеки + не проведенные с CommentError
        , tmpMovementCheck AS (SELECT Movement.Id AS MovementId, MovementLinkObject_Unit.ObjectId AS UnitId
                               FROM MovementBoolean AS MovementBoolean_Deferred
                                    INNER JOIN Movement ON Movement.Id       = MovementBoolean_Deferred.MovementId
                                                       AND Movement.DescId   = zc_Movement_Check()
                                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    -- !!!только для таких Аптек!!!
                                    INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_Unit.ObjectId
                               WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                 AND MovementBoolean_Deferred.ValueData = TRUE
                              UNION
                               SELECT Movement.Id AS MovementId, MovementLinkObject_Unit.ObjectId AS UnitId
                               FROM MovementString AS MovementString_CommentError
                                    INNER JOIN Movement ON Movement.Id       = MovementString_CommentError.MovementId
                                                       AND Movement.DescId   = zc_Movement_Check()
                                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    -- !!!только для таких Аптек!!!
                                    INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_Unit.ObjectId
                               WHERE MovementString_CommentError.DescId    = zc_MovementString_CommentError()
                                 AND MovementString_CommentError.ValueData <> ''
                              )
          -- отложенные Чеки + не проведенные с CommentError
        , tmpMI_Reserve AS (SELECT tmpMovementCheck.UnitId
                                 , MovementItem.ObjectId     AS GoodsId
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM tmpMovementCheck
                                 INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementCheck.MovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                            GROUP BY tmpMovementCheck.UnitId, MovementItem.ObjectId
                           )
          -- остатки
        , tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (Container.Amount, 0)) AS Amount
                         FROM Container
                              -- !!!только для таких Аптек!!!
                              INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = Container.WhereObjectId
                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
          -- Выкладки
        , tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                     , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                                FROM Movement
                                     LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                               ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                              AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                                WHERE Movement.DescId = zc_Movement_Layout()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               )
        , tmpLayout AS (SELECT MovementItem.ObjectId              AS GoodsId
                             , MAX (MovementItem.Amount):: TFloat AS Amount
                             , CASE WHEN SUM(CASE WHEN Movement.isPharmacyItem = TRUE THEN 1 ELSE 0 END) > 0 THEN TRUE ELSE FALSE END AS isPharmacyItem
                        FROM tmpLayoutMovement AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                                    AND MovementItem.Amount > 0
                        GROUP BY MovementItem.ObjectId
                       )
          -- MCS_isClose
        , tmpPrice_MCS_isClose AS (SELECT MCS_isClose.*
                                   FROM ObjectLink AS OL_Price_Unit
                                        -- !!!только для таких Аптек!!!
                                        INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_Price_Unit.ChildObjectId
                                        --
                                        INNER JOIN ObjectBoolean AS MCS_isClose
                                                                 ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                                AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                                AND MCS_isClose.ValueData = TRUE
                                   WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                  )
          -- цены
        , tmpPrice AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , ROUND (Price_Value.ValueData, 2)  AS Price
                            , MCS_Value.ValueData               AS MCSValue
                            , CASE WHEN Price_MCSValueMin.ValueData IS NOT NULL
                                   THEN CASE WHEN COALESCE (Price_MCSValueMin.ValueData, 0) < COALESCE (MCS_Value.ValueData, 0) THEN COALESCE (Price_MCSValueMin.ValueData, 0) ELSE MCS_Value.ValueData END
                                   ELSE 0
                              END AS MCSValue_min
                       FROM ObjectLink AS OL_Price_Unit
                            -- !!!только для таких Аптек!!!
                            INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_Price_Unit.ChildObjectId
                            -- 25.05.20 -- временно отключил - 21.05.20
                            LEFT JOIN tmpPrice_MCS_isClose AS MCS_isClose
                                                           ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                            LEFT JOIN ObjectLink AS OL_Price_Goods
                                                 ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            INNER JOIN Object AS Object_Goods
                                              ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                             AND Object_Goods.isErased = FALSE
                            LEFT JOIN ObjectFloat AS Price_Value
                                                  ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN ObjectFloat AS Price_MCSValueMin
                                                  ON Price_MCSValueMin.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_MCSValueMin.DescId = zc_ObjectFloat_Price_MCSValueMin()
                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         -- товары "убит код" - 25.05.20 -- временно отключил - 21.05.20
                         AND (MCS_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_ClosePL = FALSE)
                      )
          -- данные из ассорт. матрицы
        , tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjectFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!только для таких Аптек!!!
                                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                         ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                   INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                         AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                   -- выходим на товар сети
                                   INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                         ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                        AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                   INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                         ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                        AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                         ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                        AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                        AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                               WHERE Object_GoodsCategory.DescId   = zc_Object_GoodsCategory()
                                 AND Object_GoodsCategory.isErased = FALSE
                               )
          -- подменяем НТЗ на значение из ассорт. матрицы, если в ассотр. матрице значение больше
        , tmpObject_Price AS (SELECT COALESCE (tmpPrice.UnitId,  tmpGoodsCategory.UnitId)  AS UnitId
                                   , COALESCE (tmpPrice.GoodsId, tmpGoodsCategory.GoodsId) AS GoodsId
                                   , COALESCE (tmpPrice.Price, 0)                :: TFloat AS Price
                                   , CASE WHEN COALESCE (tmpGoodsCategory.Value, 0.0) <= COALESCE (tmpPrice.MCSValue, 0.0)
                                          THEN COALESCE (tmpPrice.MCSValue, 0.0)
                                          ELSE tmpGoodsCategory.Value
                                     END                                         :: TFloat AS MCSValue
                                   , COALESCE (tmpPrice.MCSValue_min, 0.0)       :: TFloat AS MCSValue_min
                                   , COALESCE (tmpLayout.Amount, 0)              :: TFloat AS Layout
                              FROM tmpPrice
                                   FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpPrice.GoodsId
                                                             AND tmpGoodsCategory.UnitId  = tmpPrice.UnitId

                                   LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                           ON Unit_PharmacyItem.ObjectId  = COALESCE (tmpPrice.UnitId,  tmpGoodsCategory.UnitId)
                                                          AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
                                   LEFT JOIN tmpLayout ON tmpLayout.GoodsId = COALESCE (tmpPrice.GoodsId, tmpGoodsCategory.GoodsId)
                                                      AND (COALESCE (Unit_PharmacyItem.ValueData, False) = FALSE OR tmpLayout.isPharmacyItem = TRUE)
                              WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                 OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                                 OR COALESCE (tmpPrice.Price, 0) <> 0
                             )
     -- 2.5. Результат: все остатки, продажи => расчет кол-во ПОТРЕБНОСТЬ у получателя: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains_all (UnitId, GoodsId, Price, MCS, Layout, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        --
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             , tmpObject_Price.Layout
             , CASE WHEN 1.0 <= FLOOR (-- продажи у у получателя в разрезе T2=45
                                       (COALESCE (_tmpSale_over.Amount_t2, 0)
                                        -- МИНУС остаток
                                      - CASE WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) /*- COALESCE (tmpMI_Send_out.Amount, 0)*/
                                                 + COALESCE (tmpMI_Send_in.Amount, 0)
                                                 + COALESCE (tmpMI_Income.Amount, 0)
                                                 + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                  ) > 0
                                             THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) /*- COALESCE (tmpMI_Send_out.Amount, 0)*/
                                                 + COALESCE (tmpMI_Send_in.Amount, 0)
                                                 + COALESCE (tmpMI_Income.Amount, 0)
                                                 + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                  )
                                             ELSE 0
                                        END
                                        -- МИНУС все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "потребность"
                                      - COALESCE (tmpSUN_oth.Amount, 0)
                                       )
                                       -- делим на кратность
                                     / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                      ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                         THEN -- округляем ВВНИЗ
                              FLOOR (-- продажи у у получателя в разрезе T2=45
                                     (COALESCE (_tmpSale_over.Amount_t2, 0)
                                      -- МИНУС остаток
                                      - CASE WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) /*- COALESCE (tmpMI_Send_out.Amount, 0)*/
                                                 + COALESCE (tmpMI_Send_in.Amount, 0)
                                                 + COALESCE (tmpMI_Income.Amount, 0)
                                                 + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                  ) > 0
                                             THEN  (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) /*- COALESCE (tmpMI_Send_out.Amount, 0)*/
                                                 + COALESCE (tmpMI_Send_in.Amount, 0)
                                                 + COALESCE (tmpMI_Income.Amount, 0)
                                                 + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                  )
                                             ELSE 0
                                        END
                                        -- МИНУС все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "потребность"
                                      - COALESCE (tmpSUN_oth.Amount, 0)
                                     )
                                     -- делим на кратность
                                   / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                    ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                    ELSE 0
               END AS AmountResult
               -- остаток
             , COALESCE (tmpRemains.Amount, 0)          AS AmountRemains
               -- приход - UnComplete - за последние +/-7 дней для Date_Branch
             , COALESCE (tmpMI_Income.Amount, 0)        AS AmountIncome
               -- Перемещение - приход - UnComplete - за последние +/-30 дней
             , COALESCE (tmpMI_Send_in.Amount, 0)       AS AmountSend_In
               -- Перемещение - расход - UnComplete - за последние +/-30 дней
             , COALESCE (tmpMI_Send_out.Amount, 0)      AS AmountSend_out
               -- заказы - UnComplete - !ВСЕ! Deferred
             , COALESCE (tmpMI_OrderExternal.Amount,0)  AS AmountOrderExternal
               -- отложенные Чеки + не проведенные с CommentError
             , COALESCE (tmpMI_Reserve.Amount, 0)       AS AmountReserve
        FROM tmpObject_Price
             -- Работают по СУН - только отправка
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_out
                                     ON OB_Unit_SUN_out.ObjectId  = tmpObject_Price.UnitId
                                    AND OB_Unit_SUN_out.DescId    = zc_ObjectBoolean_Unit_SUN_v2_out()
                                    AND OB_Unit_SUN_out.ValueData = TRUE
             LEFT JOIN tmpRemains AS tmpRemains
                                  ON tmpRemains.UnitId  = tmpObject_Price.UnitId
                                 AND tmpRemains.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Income ON tmpMI_Income.UnitId  = tmpObject_Price.UnitId
                                   AND tmpMI_Income.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Send_in ON tmpMI_Send_in.UnitId_to = tmpObject_Price.UnitId
                                    AND tmpMI_Send_in.GoodsId   = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Send_out ON tmpMI_Send_out.UnitId_from = tmpObject_Price.UnitId
                                     AND tmpMI_Send_out.GoodsId     = tmpObject_Price.GoodsId
             LEFT OUTER JOIN tmpMI_OrderExternal ON tmpMI_OrderExternal.UnitId  = tmpObject_Price.UnitId
                                                AND tmpMI_OrderExternal.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Reserve ON tmpMI_Reserve.UnitId  = tmpObject_Price.UnitId
                                    AND tmpMI_Reserve.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN _tmpSale_over ON _tmpSale_over.UnitId  = tmpObject_Price.UnitId
                                    AND _tmpSale_over.GoodsId = tmpObject_Price.GoodsId

             -- товары для Кратность
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId  = tmpObject_Price.GoodsId

             -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "потребность"
             LEFT JOIN (SELECT _tmpSUN_oth.UnitId_to, _tmpSUN_oth.GoodsId, SUM (_tmpSUN_oth.Amount) AS Amount
                        FROM _tmpSUN_oth
                        GROUP BY _tmpSUN_oth.UnitId_to, _tmpSUN_oth.GoodsId
                       ) AS tmpSUN_oth
                         ON tmpSUN_oth.UnitId_to = tmpObject_Price.UnitId
                        AND tmpSUN_oth.GoodsId   = tmpObject_Price.GoodsId

             -- отбросили !!закрытые!!
             -- 25.05.20 -- временно отключил - 13.05.20
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isClose
                                     ON ObjectBoolean_Goods_isClose.ObjectId  = tmpObject_Price.GoodsId
                                    AND ObjectBoolean_Goods_isClose.DescId    = zc_ObjectBoolean_Goods_Close()
                                    AND ObjectBoolean_Goods_isClose.ValueData = TRUE
             -- !!!
             LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = tmpObject_Price.UnitId

             -- отбросили !!акционные!!
             INNER JOIN Object AS Object_Goods ON Object_Goods.Id        = tmpObject_Price.GoodsId
                                              AND Object_Goods.ValueData NOT ILIKE 'ААА%'
             -- НЕ отбросили !!холод!!
             /*LEFT JOIN ObjectLink AS OL_Goods_ConditionsKeep
                                    ON OL_Goods_ConditionsKeep.ObjectId = tmpObject_Price.GoodsId
                                   AND OL_Goods_ConditionsKeep.DescId   = zc_ObjectLink_Goods_ConditionsKeep()
               LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = OL_Goods_ConditionsKeep.ChildObjectId
             */
        WHERE OB_Unit_SUN_out.ObjectId IS NULL
          -- товары "закрыт код"
          AND (ObjectBoolean_Goods_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_CloseGd = FALSE)
       ;

     -- 2.6. Результат: все остатки, продажи => получаем кол-ва ПОТРЕБНОСТЬ у получателя
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, MCS, Layout, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT _tmpRemains_all.UnitId, _tmpRemains_all.GoodsId, _tmpRemains_all.Price, _tmpRemains_all.MCS, _tmpRemains_all.Layout, _tmpRemains_all.AmountResult, _tmpRemains_all.AmountRemains, _tmpRemains_all.AmountIncome, _tmpRemains_all.AmountSend_in, _tmpRemains_all.AmountSend_out, _tmpRemains_all.AmountOrderExternal, _tmpRemains_all.AmountReserve
        FROM _tmpRemains_all
             -- если товар среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_all.GoodsId

        WHERE -- !!!только с таким AmountResult!!!
              _tmpRemains_all.AmountResult >= 1.0
              -- !!!Добавили парные!!!
           OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
       ;



    -- дата + 6 месяцев
    vbDate_6:= inOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- дата + 1 месяц
    vbDate_1:= inOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               )
               -- меняем: добавим еще 9 дней, будет от 60 дней включительно - только для СУН
             + INTERVAL '9 DAY'
             ;
    -- дата + 0 месяцев
    vbDate_0:= inOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );


     -- 3.1. все остатки, OVER (Сверх запас)
     INSERT INTO _tmpRemains_Partion_all (ContainerDescId, UnitId, ContainerId_Parent, ContainerId, GoodsId, Amount, Amount_notSold)
        WITH -- остатки - список для OVER
             tmpContainer AS (SELECT Container.DescId           AS ContainerDescId
                                   , Container.Id               AS ContainerId
                                   , Container.WhereObjectId    AS UnitId
                                   , Container.ObjectId         AS GoodsId
                                   , Container.Amount           AS Amount
                              FROM -- !!!только для таких Аптек!!!
                                   _tmpUnit_SUN
                                   INNER JOIN Container ON Container.WhereObjectId = _tmpUnit_SUN.UnitId
                                                       AND Container.Amount        <> 0
                                                       AND Container.DescId        = zc_Container_Count()
                                   -- то что НЕ попадает в потребность
                                   LEFT JOIN _tmpRemains ON _tmpRemains.UnitId       = _tmpUnit_SUN.UnitId
                                                        AND _tmpRemains.GoodsId      = Container.ObjectId
                                                        AND _tmpRemains.AmountResult > 0
                                   -- если товар среди парных
                                   LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                                             ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = Container.ObjectId

                              WHERE _tmpRemains.GoodsId IS NULL
                                    -- !!!Добавили парные!!!
                                OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0

                           -- WHERE 1=0
                             )
             -- список для OVER
           , tmpOver_list AS (SELECT tmpContainer.UnitID
                                   , tmpContainer.GoodsID
                                   , SUM (tmpContainer.Amount) AS Amount
                              FROM tmpContainer
                              GROUP BY tmpContainer.UnitID
                                     , tmpContainer.GoodsID
                             )
             -- SUN - zc_Movement_Send за X дней - если приходило, уходить уже не может
           , tmpSUN_Send AS (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                                  , MovementItem.ObjectId            AS GoodsId
                             FROM Movement
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                                  --
                                  INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                             ON MovementBoolean_SUN.MovementId = Movement.Id
                                                            AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                            AND MovementBoolean_SUN.ValueData  = TRUE
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                                                         AND MovementItem.Amount     > 0

                                  INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId

                                  -- !!!только для таких товаров!!!
                                  INNER JOIN tmpOver_list ON tmpOver_list.UnitId  = MovementLinkObject_To.ObjectId
                                                         AND tmpOver_list.GoodsID = MovementItem.ObjectId

                             WHERE Movement.OperDate BETWEEN inOperDate - (vbDaySendSUN_max :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                               AND Movement.DescId   = zc_Movement_Send()
                               AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                             GROUP BY MovementLinkObject_To.ObjectId
                                    , MovementItem.ObjectId
                             HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (_tmpUnit_SUN.DaySendSUN :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                                   THEN MovementItem.Amount
                                              ELSE 0
                                         END) > 0
                            )
             -- для SUN- всех - Сроки - zc_Movement_Send за X дней - если приходило, уходить уже не может
           , tmpSUN_SendAll AS (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                                     , MovementItem.ObjectId            AS GoodsId
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                     -- !!!только для таких Аптек!!!
                                     -- INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
                                     --
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                                            AND MovementItem.Amount     > 0

                                     LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId

                                WHERE Movement.OperDate BETWEEN inOperDate - (vbDaySendSUNAll_max :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                  AND Movement.DescId   = zc_Movement_Send()
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                GROUP BY MovementLinkObject_To.ObjectId
                                       , MovementItem.ObjectId
                                HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (_tmpUnit_SUN.DaySendSUNAll :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                                      THEN MovementItem.Amount
                                                 ELSE 0
                                            END) > 0
                            )
             -- так можно определить OVER, Но потом надо еще раз, с учетом: отложенные Чеки + не проведенные с CommentError + Перемещение - расход (ожидается)
           , tmpNotSold_all AS (SELECT tmpOver_list.UnitID
                                     , tmpOver_list.GoodsID
                                       --  Остаток
                                     , tmpOver_list.Amount

                                       -- остатки, OVER (Сверх запас) - его и будем распределять
                                     , CASE -- отдаем ВСЕ - это парный
                                            WHEN _tmpSale_not.GoodsID > 0
                                                 THEN tmpOver_list.Amount

                                            -- отдаем ВСЕ
                                            WHEN _tmpSale_not.GoodsID > 0
                                                 THEN tmpOver_list.Amount

                                            -- оставляем 1
                                            WHEN COALESCE (_tmpSale_over.Amount_t1, 0) < 1
                                                 THEN FLOOR (tmpOver_list.Amount - 1)

                                            --  Отправка: округляем ВВНИЗ: если X1 больше Y1 на 1 и больше: Y1 - продажи у отправителя в разрезе T1=60 дней;
                                            ELSE FLOOR (tmpOver_list.Amount - COALESCE (_tmpSale_over.Amount_t1, 0))
                                       END AS Amount_notSold
                                FROM tmpOver_list
                                     LEFT JOIN _tmpSale_over ON _tmpSale_over.UnitId  = tmpOver_list.UnitId
                                                            AND _tmpSale_over.GoodsID = tmpOver_list.GoodsID
                                     LEFT JOIN _tmpSale_not ON _tmpSale_not.UnitId  = tmpOver_list.UnitId
                                                           AND _tmpSale_not.GoodsID = tmpOver_list.GoodsID
                                     -- !!!SUN - за X дней - если приходило, уходить уже не может!!!
                                     LEFT JOIN tmpSUN_Send ON tmpSUN_Send.UnitId_to = tmpOver_list.UnitId
                                                          AND tmpSUN_Send.GoodsID   = tmpOver_list.GoodsID
                                     -- !!!SUN всех - за X дней - если приходило, уходить уже не может!!!
                                     LEFT JOIN tmpSUN_SendAll ON tmpSUN_SendAll.UnitId_to = tmpOver_list.UnitId
                                                             AND tmpSUN_SendAll.GoodsId   = tmpOver_list.GoodsID
                                     -- отгружать товар по СУН, если у него остаток больше чем N
                                     LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitID = tmpOver_list.UnitId

                                     -- если товар среди парных
                                     LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                                               ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = tmpOver_list.GoodsID

                                WHERE -- !!!
                                      tmpSUN_Send.GoodsId IS NULL
                                  AND tmpSUN_SendAll.GoodsId IS NULL
                                  AND CASE -- отдаем ВСЕ - это парный
                                           WHEN _tmpSale_not.GoodsID > 0
                                                THEN tmpOver_list.Amount

                                           -- отдаем ВСЕ
                                           WHEN _tmpSale_not.GoodsID > 0
                                                THEN tmpOver_list.Amount

                                           -- оставляем 1
                                           WHEN COALESCE (_tmpSale_over.Amount_t1, 0) < 1
                                                THEN FLOOR (tmpOver_list.Amount - 1)

                                           --  Отправка: округляем ВВНИЗ: если X1 больше Y1 на 1 и больше: Y1 - продажи у отправителя в разрезе T1=60 дней;
                                           ELSE FLOOR (tmpOver_list.Amount - COALESCE (_tmpSale_over.Amount_t1, 0))
                                      END > 0

                                  AND (-- остаток больше чем N
                                       COALESCE (_tmpUnit_SUN.Limit_N, 0) < tmpOver_list.Amount
                                       -- или это парный товар
                                    OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
                                      )
                               )
     -- для OVER - находим ВСЕ сроковые
   , tmpNotSold_PartionDate AS (SELECT tmpNotSold_all.UnitID
                                     , tmpNotSold_all.GoodsID
                                   --, SUM (Container.Amount) AS Amount
                                FROM tmpNotSold_all
                                     INNER JOIN tmpContainer ON tmpContainer.UnitId  = tmpNotSold_all.UnitId
                                                            AND tmpContainer.GoodsID = tmpNotSold_all.GoodsID
                                     INNER JOIN Container ON Container.ParentId = tmpContainer.ContainerId
                                                         AND Container.DescId   = zc_Container_CountPartionDate()
                                                         AND Container.Amount   > 0
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                          ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                         AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                WHERE -- !!!т.е. все сроковые категории
                                      ObjectDate_PartionGoods_Value.ValueData <= vbDate_6
                                      -- !!!т.е. все сроковые категории
                                GROUP BY tmpNotSold_all.UnitID
                                       , tmpNotSold_all.GoodsID
                                HAVING SUM (Container.Amount) > 0
                               )
                  -- Income - за X дней - если приходило, OVER уходить уже не может
                , tmpIncome AS (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                                     , MovementItem.ObjectId            AS GoodsId
                                FROM MovementDate AS MovementDate_Branch
                                     INNER JOIN Movement ON Movement.Id       = MovementDate_Branch.MovementId
                                                        AND Movement.DescId   = zc_Movement_Income()
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                                            AND MovementItem.Amount     > 0
                                     -- !!!только для таких!!!
                                     INNER JOIN tmpNotSold_all ON tmpNotSold_all.UnitId  = MovementLinkObject_To.ObjectId
                                                              AND tmpNotSold_all.GoodsId = MovementItem.ObjectId

                                     INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
                                                            AND _tmpUnit_SUN.DayIncome > 0

                                WHERE MovementDate_Branch.DescId     = zc_MovementDate_Branch()
                                  AND MovementDate_Branch.ValueData BETWEEN inOperDate - (vbDayIncome_max :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'

                                GROUP BY MovementLinkObject_To.ObjectId
                                       , MovementItem.ObjectId
                                HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (_tmpUnit_SUN.DayIncome :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                                      THEN MovementItem.Amount
                                                 ELSE 0
                                            END) > 0
                               )
                 -- все что остается для NotSold
               , tmpNotSold AS (SELECT tmpNotSold_all.UnitID
                                     , tmpNotSold_all.GoodsID
                                     , tmpNotSold_all.Amount
                                     , tmpNotSold_all.Amount_notSold
                                FROM tmpNotSold_all
                                     -- ВСЕ сроковые
                                     LEFT JOIN tmpNotSold_PartionDate ON tmpNotSold_PartionDate.UnitId  = tmpNotSold_all.UnitID
                                                                     AND tmpNotSold_PartionDate.GoodsID = tmpNotSold_all.GoodsID
                                     -- Income - за X дней - если приходило, OVER уходить уже не может
                                     LEFT JOIN tmpIncome ON tmpIncome.UnitId_to = tmpNotSold_all.UnitID
                                                        AND tmpIncome.GoodsID   = tmpNotSold_all.GoodsID
                                WHERE tmpNotSold_PartionDate.GoodsID  IS NULL
                                  AND tmpIncome.GoodsID IS NULL
                               )
       -- Перемещение SUN - расход - Erased - за СЕГОДНЯ, что б не отправлять эти товары повторно в СУН-2
     , tmpMI_SUN_out AS (SELECT DISTINCT
                                MovementLinkObject_From.ObjectId AS UnitId_from
                              , MovementItem.ObjectId            AS GoodsId
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                              -- !!!только для таких Аптек!!!
                              INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_From.ObjectId
                              INNER JOIN MovementItem AS MovementItem
                                                      ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.Amount     > 0
                              INNER JOIN MovementBoolean AS MB_SUN
                                                         ON MB_SUN.MovementId = Movement.Id
                                                        AND MB_SUN.DescId     = zc_MovementBoolean_SUN()
                                                        AND MB_SUN.ValueData  = TRUE
                              LEFT JOIN MovementBoolean AS MB_SUN_v2
                                                        ON MB_SUN_v2.MovementId = Movement.Id
                                                       AND MB_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                                       AND MB_SUN_v2.ValueData  = TRUE
                              LEFT JOIN MovementBoolean AS MB_SUN_v3
                                                        ON MB_SUN_v3.MovementId = Movement.Id
                                                       AND MB_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                                       AND MB_SUN_v3.ValueData  = TRUE
                              LEFT JOIN MovementBoolean AS MB_SUN_v4
                                                        ON MB_SUN_v4.MovementId = Movement.Id
                                                       AND MB_SUN_v4.DescId     = zc_MovementBoolean_SUN_v4()
                                                       AND MB_SUN_v4.ValueData  = TRUE
                         WHERE Movement.OperDate = inOperDate
                           AND Movement.DescId   = zc_Movement_Send()
                           AND Movement.StatusId = zc_Enum_Status_Erased()
                           -- т.е. - ТОЛЬКО СУН - там срок и без продаж 100дн.
                           AND MB_SUN_v2.MovementId IS NULL
                           AND MB_SUN_v3.MovementId IS NULL
                           AND MB_SUN_v4.MovementId IS NULL
                        )
        -- Результат
        SELECT 0 AS ContainerDescId
             , tmpNotSold.UnitId
             , 0 AS ContainerId_Parent
             , 0 AS ContainerId
             , tmpNotSold.GoodsId
               -- остатки, ВСЕ
             , tmpNotSold.Amount
               -- остатки, OVER (Сверх запас) - их и будем распределять
             , tmpNotSold.Amount_notSold AS Amount_notSold
        FROM tmpNotSold
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_in
                                     ON OB_Unit_SUN_in.ObjectId  = tmpNotSold.UnitId
                                    AND OB_Unit_SUN_in.DescId    = zc_ObjectBoolean_Unit_SUN_v2_in()
                                    AND OB_Unit_SUN_in.ValueData = TRUE
             -- !!!Перемещение SUN - расход - Erased - за СЕГОДНЯ, что б не отправлять эти товары повторно в СУН-2
             LEFT JOIN tmpMI_SUN_out ON tmpMI_SUN_out.UnitId_from = tmpNotSold.UnitId
                                    AND tmpMI_SUN_out.GoodsId     = tmpNotSold.GoodsId
        WHERE -- !!!
              OB_Unit_SUN_in.ObjectId IS NULL
              -- !!!
          AND tmpMI_SUN_out.GoodsId IS NULL
       ;


     -- 3.2. остатки, OVER (Сверх запас) - для распределения
     WITH -- Goods_sum
          tmpGoods_sum AS (SELECT _tmpRemains_Partion_all.UnitId
                                , _tmpRemains_Partion_all.GoodsId
                                  -- остатки, ВСЕ
                                , SUM (_tmpRemains_Partion_all.Amount)         AS Amount
                                  -- остатки, PI (Сверх запас) - их и будем распределять
                                , SUM (_tmpRemains_Partion_all.Amount_notSold) AS Amount_notSold
                           FROM _tmpRemains_Partion_all
                           GROUP BY _tmpRemains_Partion_all.UnitId
                                  , _tmpRemains_Partion_all.GoodsId
                          )
          -- MCS_isClose
        , tmpPrice_MCS_isClose AS (SELECT MCS_isClose.*
                                   FROM ObjectLink AS OL_Price_Unit
                                        INNER JOIN ObjectLink AS OL_Price_Goods
                                                              ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                             AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                                        -- !!!только для таких!!!
                                        INNER JOIN tmpGoods_sum ON tmpGoods_sum.UnitId  = OL_Price_Unit.ChildObjectId
                                                               AND tmpGoods_sum.GoodsId = OL_Price_Goods.ChildObjectId
                                        --
                                        INNER JOIN ObjectBoolean AS MCS_isClose
                                                                 ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                                AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                                AND MCS_isClose.ValueData = TRUE
                                   WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                  )
          -- Выкладки
        , tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                     , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                                FROM Movement
                                     LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                               ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                              AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                                WHERE Movement.DescId = zc_Movement_Layout()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               )
        , tmpLayout AS (SELECT MovementItem.ObjectId              AS GoodsId
                             , MAX (MovementItem.Amount):: TFloat AS Amount
                             , CASE WHEN SUM(CASE WHEN Movement.isPharmacyItem = TRUE THEN 1 ELSE 0 END) > 0 THEN TRUE ELSE FALSE END AS isPharmacyItem
                        FROM tmpLayoutMovement AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                                    AND MovementItem.Amount > 0
                        GROUP BY MovementItem.ObjectId
                       )
               -- MCS + Price
             , tmpMCS AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                               , OL_Price_Goods.ChildObjectId      AS GoodsId
                               , Price_Value.ValueData             AS Price
                               , MCS_Value.ValueData               AS MCSValue
                          FROM ObjectLink AS OL_Price_Unit
                               -- 25.05.20 -- временно отключил - 21.05.20
                               LEFT JOIN tmpPrice_MCS_isClose AS MCS_isClose
                                                              ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                               LEFT JOIN ObjectLink AS OL_Price_Goods
                                                    ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                   AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                               INNER JOIN Object AS Object_Goods
                                                 ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                                AND Object_Goods.isErased = FALSE
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               LEFT JOIN ObjectFloat AS MCS_Value
                                                     ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                    AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                               -- !!!только для таких!!!
                               INNER JOIN tmpGoods_sum ON tmpGoods_sum.UnitId  = OL_Price_Unit.ChildObjectId
                                                      AND tmpGoods_sum.GoodsId = OL_Price_Goods.ChildObjectId
                               -- !!!
                               LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_Price_Unit.ChildObjectId

                          WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                            -- товары "убит код" - 25.05.20 -- временно отключил - 21.05.20
                            AND (MCS_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_ClosePL = FALSE)
                         )
        -- отбросили !!холод!!
      , tmpConditionsKeep AS (SELECT OL_Goods_ConditionsKeep.ObjectId
                              FROM ObjectLink AS OL_Goods_ConditionsKeep
                                   LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = OL_Goods_ConditionsKeep.ChildObjectId
                              WHERE OL_Goods_ConditionsKeep.ObjectId IN (SELECT DISTINCT _tmpRemains_Partion_all.GoodsId FROM _tmpRemains_Partion_all)
                                AND OL_Goods_ConditionsKeep.DescId   = zc_ObjectLink_Goods_ConditionsKeep()
                                AND (Object_ConditionsKeep.ValueData ILIKE '%холод%'
                                  OR Object_ConditionsKeep.ValueData ILIKE '%прохладное%'
                                    )
                             )
             -- отбросили !!НОТ!!
           , tmpGoods_NOT AS (SELECT OB_Goods_NOT.ObjectId
                              FROM ObjectBoolean AS OB_Goods_NOT
                              WHERE OB_Goods_NOT.DescId   = zc_ObjectBoolean_Goods_NOT_Sun_v2()
                                AND OB_Goods_NOT.ValueData = TRUE
                             )
       -- Результат: все остатки, OVER (Сверх запас) - для распределения
       INSERT INTO _tmpRemains_Partion (ContainerDescId, UnitId, GoodsId, MCSValue, Layout, Amount_sale, Amount, Amount_save, Amount_real)
          SELECT 0 AS ContainerDescId
               , tmp.UnitId
               , tmp.GoodsId
               , COALESCE (tmpMCS.MCSValue, 0) AS MCSValue
               , COALESCE (tmpLayout.Amount, 0)    AS Layout

                 -- продажи у отправителя в разрезе T1=60 дней;
               , COALESCE (_tmpSale.Amount_t1, 0) AS Amount_sale

                 -- остатки, OVER (Сверх запас) - их и будем распределять
               , FLOOR ((tmp.Amount_notSold
                         -- уменьшаем - отложенные Чеки + не проведенные с CommentError
                       - COALESCE (_tmpRemains_all.AmountReserve, 0)
                         -- уменьшаем - Перемещение - расход (ожидается)
                       - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                         -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "излишки"
                       - COALESCE (tmpSUN_oth.Amount, 0)
                          -- делим на кратность
                        ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                       ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                 AS Amount

                 -- остатки, OVER (Сверх запас) без корректировки
               , tmp.Amount             AS Amount_save

                 -- остатки, OVER (Сверх запас) без корректировки
               , tmp.Amount_notSold     AS Amount_real

          FROM tmpGoods_sum AS tmp
               -- ПОТРЕБНОСТЬ
               LEFT JOIN _tmpRemains_all ON _tmpRemains_all.UnitId  = tmp.UnitId
                                        AND _tmpRemains_all.GoodsId = tmp.GoodsId
               -- НТЗ
               LEFT JOIN tmpMCS ON tmpMCS.UnitId  = tmp.UnitId
                               AND tmpMCS.GoodsId = tmp.GoodsId
               -- продажи
               LEFT JOIN _tmpSale_over AS _tmpSale ON _tmpSale.UnitId  = tmp.UnitId
                                                  AND _tmpSale.GoodsId = tmp.GoodsId

               -- товары для Кратность
               LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId  = tmp.GoodsId

               -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "излишки"
               LEFT JOIN (SELECT _tmpSUN_oth.UnitId_from, _tmpSUN_oth.GoodsId, SUM (_tmpSUN_oth.Amount) AS Amount
                          FROM _tmpSUN_oth
                          GROUP BY _tmpSUN_oth.UnitId_from, _tmpSUN_oth.GoodsId
                         ) AS tmpSUN_oth
                           ON tmpSUN_oth.UnitId_from = tmp.UnitId
                          AND tmpSUN_oth.GoodsId     = tmp.GoodsId

               -- а здесь, отбросили !!холод!!
               LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = tmp.GoodsId
               -- а здесь, отбросили !!НОТ!!
               LEFT JOIN tmpGoods_NOT ON tmpGoods_NOT.ObjectId = tmp.GoodsId

               -- Выкладки
               LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                       ON Unit_PharmacyItem.ObjectId  = tmp.UnitId
                                      AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
               LEFT JOIN tmpLayout ON tmpLayout.GoodsId = tmp.GoodsId
                                  AND (COALESCE (Unit_PharmacyItem.ValueData, False) = FALSE OR tmpLayout.isPharmacyItem = TRUE)

          -- маленькое кол-во не распределяем
          WHERE FLOOR ((tmp.Amount_notSold
                        -- уменьшаем - отложенные Чеки + не проведенные с CommentError
                      - COALESCE (_tmpRemains_all.AmountReserve, 0)
                        -- уменьшаем - Перемещение - расход (ожидается)
                      - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                        -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "излишки"
                      - COALESCE (tmpSUN_oth.Amount, 0)
                         -- делим на кратность
                       ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                      ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                > 1
            -- отбросили !!холод!!
            AND tmpConditionsKeep.ObjectId IS NULL
            -- отбросили !!НОТ!!
            AND tmpGoods_NOT.ObjectId IS NULL
          ;

     -- Правим количество распределения если остаток меньше отгружать товар по СУН , если у него остаток больше чем N
     UPDATE _tmpRemains_Partion SET Amount = FLOOR (CASE WHEN _tmpRemains_Partion.Amount_save - COALESCE(_tmpUnit_SUN.Limit_N, 0) <= 0 THEN 0
                                                         ELSE  _tmpRemains_Partion.Amount_save - COALESCE(_tmpUnit_SUN.Limit_N, 0) END)
     FROM _tmpUnit_SUN
     WHERE _tmpRemains_Partion.UnitId = _tmpUnit_SUN.UnitId
       AND COALESCE(_tmpUnit_SUN.Limit_N, 0) > 0
       AND _tmpRemains_Partion.Amount_save - _tmpRemains_Partion.Amount < COALESCE(_tmpUnit_SUN.Limit_N, 0);


     -- 4. Остатки по которым есть ПОТРЕБНОСТЬ и OVER
     INSERT INTO _tmpRemains_calc (UnitId, GoodsId, Price, MCS, Layout, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve
                                 , AmountSun_real, AmountSun_summ, AmountSun_summ_save, AmountSun_unit, AmountSun_unit_save)
        SELECT _tmpRemains.UnitId
             , _tmpRemains.GoodsId
               -- Цена
             , _tmpRemains.Price
               -- НТЗ
             , _tmpRemains.MCS
             , COALESCE(_tmpRemains_Partion.Layout, _tmpRemains.Layout) as Layout
               -- ПОТРЕБНОСТЬ у получателя
             , _tmpRemains.AmountResult
               --
             , _tmpRemains.AmountRemains
             , _tmpRemains.AmountIncome
             , _tmpRemains.AmountSend_in
             , _tmpRemains.AmountSend_out
             , _tmpRemains.AmountOrderExternal
             , _tmpRemains.AmountReserve

               -- остатки, OVER (Сверх запас) без корректировки
             , tmpRemains_Partion_sum.Amount_real       AS AmountSun_real
               -- остатки, OVER (Сверх запас) - их и будем распределять
             , tmpRemains_Partion_sum.Amount            AS AmountSun_summ
               -- остатки, ВСЕ
             , tmpRemains_Partion_sum.Amount_save       AS AmountSun_summ_save

               -- инф.=0, сроковые на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
             , COALESCE (_tmpRemains_Partion.Amount, 0)      AS AmountSun_unit
               -- инф.=0, сроковые на этой аптеке
             , COALESCE (_tmpRemains_Partion.Amount_save, 0) AS AmountSun_unit_save

        FROM _tmpRemains
             -- итого у ОТПРАВИТЕЛЯ - OVER (Сверх запас) которые будем распределять
             INNER JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.Amount) AS Amount, SUM (_tmpRemains_Partion.Amount_save) AS Amount_save, SUM (_tmpRemains_Partion.Amount_real) AS Amount_real
                         FROM _tmpRemains_Partion
                         GROUP BY _tmpRemains_Partion.GoodsId
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains.GoodsId

             -- OVER (Сверх запас) на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
             LEFT JOIN _tmpRemains_Partion ON _tmpRemains_Partion.UnitId  = _tmpRemains.UnitId
                                          AND _tmpRemains_Partion.GoodsId = _tmpRemains.GoodsId

             -- если товар среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains.GoodsId

        WHERE _tmpRemains.AmountResult >= 1.0
          -- или товар среди парных
          OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
       ;



     -- 5. из каких аптек остатки OVER "максимально" закрывают ПОТРЕБНОСТЬ
     -- CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpSumm_limit (UnitId_from, UnitId_to, Summ)
        WITH
        tmpConditionsKeep AS (SELECT OL_Goods_ConditionsKeep.ObjectId
                                   , Object_ConditionsKeep.ValueData
                              FROM ObjectLink AS OL_Goods_ConditionsKeep
                                   LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = OL_Goods_ConditionsKeep.ChildObjectId
                              WHERE OL_Goods_ConditionsKeep.ObjectId IN (SELECT DISTINCT _tmpRemains_calc.GoodsId FROM _tmpRemains_calc)
                                AND OL_Goods_ConditionsKeep.DescId   = zc_ObjectLink_Goods_ConditionsKeep()
                              )
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from
             , _tmpRemains_calc.UnitId    AS UnitId_to
               -- если OVER больше чем в ПОТРЕБНОСТЬ
             , SUM (CASE WHEN _tmpRemains_Partion.Amount >= _tmpRemains_calc.AmountResult
                              -- тогда OVER = ПОТРЕБНОСТЬ
                              THEN _tmpRemains_calc.AmountResult
                              -- иначе закрываем "частично" - т.е. сколько есть OVER
                              ELSE FLOOR (_tmpRemains_Partion.Amount / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                    END
                  * _tmpRemains_calc.Price
                   )
        FROM -- Остатки по которым есть ПОТРЕБНОСТЬ и OVER
             _tmpRemains_calc
             -- все остатки, OVER
             INNER JOIN _tmpRemains_Partion ON _tmpRemains_Partion.GoodsId = _tmpRemains_calc.GoodsId

             -- товары для Кратность
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_calc.GoodsId

             -- а здесь, отбросили !!холод!!
             LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_calc.GoodsId
                                -- AND OL_Goods_ConditionsKeep.DescId   = zc_ObjectLink_Goods_ConditionsKeep()
             --LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = OL_Goods_ConditionsKeep.ChildObjectId

             -- отбросили !!исключения!!
             LEFT JOIN _tmpUnit_SunExclusion ON _tmpUnit_SunExclusion.UnitId_from = _tmpRemains_Partion.UnitId
                                            AND _tmpUnit_SunExclusion.UnitId_to   = _tmpRemains_calc.UnitId
                                            AND _tmpUnit_SunExclusion.isMCS_to    = FALSE
             -- отбросили !!исключения!!
             LEFT JOIN _tmpUnit_SunExclusion AS _tmpUnit_SunExclusion_MCS
                                             ON _tmpUnit_SunExclusion_MCS.UnitId_from = _tmpRemains_Partion.UnitId
                                            AND _tmpUnit_SunExclusion_MCS.UnitId_to   = _tmpRemains_calc.UnitId
                                            AND _tmpUnit_SunExclusion_MCS.isMCS_to    = TRUE
                                            AND COALESCE (_tmpRemains_calc.MCS, 0)    = 0

             -- отбросили !!все что "сейчас" есть по СУН-пи!!
             LEFT JOIN _tmpSUN_oth ON _tmpSUN_oth.UnitId_from = _tmpRemains_Partion.UnitId
                                  AND _tmpSUN_oth.UnitId_to   = _tmpRemains_calc.UnitId
                                  AND _tmpSUN_oth.GoodsId     = _tmpRemains_calc.GoodsId

        WHERE ((tmpConditionsKeep.ValueData NOT ILIKE '%холод%'
            AND tmpConditionsKeep.ValueData NOT ILIKE '%прохладное%'
               )
            OR tmpConditionsKeep.ValueData IS NULL
              )
          AND _tmpUnit_SunExclusion.UnitId_to IS NULL
          AND _tmpUnit_SunExclusion_MCS.UnitId_to IS NULL
          AND _tmpSUN_oth.GoodsId IS NULL

        GROUP BY _tmpRemains_Partion.UnitId
               , _tmpRemains_calc.UnitId
       ;

     -- 6.1.1. распределяем-1 остатки OVER (Сверх запас) - по всем аптекам
     -- CREATE TEMP TABLE _tmpResult_Partion (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     --
     -- курсор1 - все остатки, OVER (Сверх запас) + OVER (Сверх запас) без корректировки
     OPEN curPartion FOR
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from, _tmpRemains_Partion.GoodsId
               --
               -- Отдаем весь товар невзирая на парный
/*             , CASE -- если у парного ост = 0, не отдаем
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND COALESCE (_tmpRemains_Partion_PairSun.Amount, 0) <=0
                         THEN 0
                    -- если у парного ост < чем у "основного", меняем на меньшее
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND _tmpRemains_Partion_PairSun.Amount < _tmpRemains_Partion.Amount
                         THEN _tmpRemains_Partion_PairSun.Amount
                    -- инче берем ост "основного"
                    ELSE _tmpRemains_Partion.Amount
               END AS Amount */
             , _tmpRemains_Partion.Amount - _tmpRemains_Partion.Layout AS Amount
               -- для получения дробной части, нужен весь ост.
/*             , CASE -- если у парного ост = 0, не отдаем
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND COALESCE (_tmpRemains_Partion_PairSun.Amount_save, 0) <=0
                         THEN 0
                    -- если у парного ост < чем у "основного", меняем на меньшее
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND _tmpRemains_Partion_PairSun.Amount_save < _tmpRemains_Partion.Amount_save
                         THEN _tmpRemains_Partion_PairSun.Amount_save
                    -- инче берем ост "основного"
                    ELSE _tmpRemains_Partion.Amount_save
               END AS Amount_save*/
             , _tmpRemains_Partion.Amount_save AS Amount_save
               --
             , COALESCE (_tmpGoods_SUN.KoeffSUN, 0)
        FROM _tmpRemains_Partion
             -- начинаем с аптек, где расход может быть максимальным
             INNER JOIN (SELECT _tmpSumm_limit.UnitId_from, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                         -- !!!больше лимита
                         WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                         GROUP BY _tmpSumm_limit.UnitId_from
                        ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_from = _tmpRemains_Partion.UnitId
             -- товары - для Кратность
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_Partion.GoodsId
             -- нашли - есть ли у товара парный
             LEFT JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = _tmpRemains_Partion.GoodsId
             LEFT JOIN _tmpRemains_Partion AS _tmpRemains_Partion_PairSun
                                           ON _tmpRemains_Partion_PairSun.GoodsId = _tmpGoods_SUN_PairSun.GoodsId_PairSun
                                          AND _tmpRemains_Partion_PairSun.UnitId  = _tmpRemains_Partion.UnitId
             -- товар есть среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_Partion.GoodsId

        WHERE -- !!!Отключили парные!!!
              _tmpGoods_SUN_PairSun_find.GoodsId_PairSun IS NULL

          AND (_tmpRemains_Partion.Amount - _tmpRemains_Partion.Layout) > 0

/*          AND CASE -- если у парного ост = 0, не отдаем
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND COALESCE (_tmpRemains_Partion_PairSun.Amount, 0) <=0
                         THEN 0
                    -- если у парного ост < чем у "основного", меняем на меньшее
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND _tmpRemains_Partion_PairSun.Amount < _tmpRemains_Partion.Amount
                         THEN _tmpRemains_Partion_PairSun.Amount
                    -- инче берем ост "основного"
                    ELSE _tmpRemains_Partion.Amount
               END > 0
*/
        ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curPartion INTO vbUnitId_from, vbGoodsId, vbAmount, vbAmount_save, vbKoeffSUN, vbGoodsId_PairSun;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         -- курсор2. - ПОТРЕБНОСТЬ МИНУС сколько уже распределили для vbGoodsId
         OPEN curResult FOR
            SELECT _tmpRemains_calc.UnitId AS UnitId_to, _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) AS AmountResult, _tmpRemains_calc.Price, COALESCE (_tmpRemains_calc_PairSun.Price, _tmpRemains_calc.Price) AS Price_PairSun
            FROM _tmpRemains_calc
                 -- сколько уже пришло после распределения-1
                 LEFT JOIN (SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId, SUM (_tmpResult_Partion.Amount) AS Amount FROM _tmpResult_Partion GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                           ) AS tmp ON tmp.UnitId_to = _tmpRemains_calc.UnitId
                                   AND tmp.GoodsId   = _tmpRemains_calc.GoodsId
                 -- + с аптек, где ПОТРЕБНОСТЬ - максимальным
                 INNER JOIN (SELECT _tmpSumm_limit.UnitId_to, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                             WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from
                               -- !!!больше лимита
                               AND _tmpSumm_limit.Summ >= vbSumm_limit
                             GROUP BY _tmpSumm_limit.UnitId_to
                            ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_to = _tmpRemains_calc.UnitId

                 -- отбросили !!исключения!!
                 LEFT JOIN _tmpUnit_SunExclusion AS _tmpUnit_SunExclusion_MCS
                                                 ON _tmpUnit_SunExclusion_MCS.UnitId_from = vbUnitId_from
                                                AND _tmpUnit_SunExclusion_MCS.UnitId_to   = _tmpRemains_calc.UnitId
                                                AND _tmpUnit_SunExclusion_MCS.isMCS_to    = TRUE
                                                AND COALESCE (_tmpRemains_calc.MCS, 0)     = 0

                 -- найдем цену для пары
                 LEFT JOIN _tmpRemains_calc AS _tmpRemains_calc_PairSun
                                            ON _tmpRemains_calc_PairSun.UnitId  = _tmpRemains_calc.UnitId
                                           AND _tmpRemains_calc_PairSun.GoodsId = vbGoodsId_PairSun

            WHERE _tmpRemains_calc.GoodsId = vbGoodsId
              AND _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) > 0
              AND _tmpUnit_SunExclusion_MCS.UnitId_to IS NULL

            ORDER BY --начинаем с аптек, где ПОТРЕБНОСТЬ - максимальным
                     _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) DESC
                   , tmpSumm_limit.Summ DESC
                   , _tmpRemains_calc.UnitId
           ;
         -- начало цикла по курсору2 - остаток сроковых - под него надо найти Автозаказ
         LOOP
             -- данные по Автозаказ
             FETCH curResult INTO vbUnitId_to, vbAmountResult, vbPrice, vbPrice_PairSun;
             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             -- если Автозаказ > Остаток
             IF vbAmountResult > vbAmount
             THEN
                 -- если в остатках "дробное" - отдаем "всю дробную часть", т.к. нельзя что б дробная была более чем в 1-ой аптеке
                 /*IF FLOOR(vbAmount) <> vbAmount
                 THEN
                     -- отбрас.дробную.Остаток + дробная часть "весь" остаток
                     vbAmount_calc:= FLOOR (vbAmount) + vbAmount_save - FLOOR (vbAmount_save);
                     -- если получилось больше чем "свободный" остаток
                     IF vbAmount_calc > vbAmount
                     THEN -- останется только целая часть
                          vbAmount:= FLOOR (vbAmount_calc);
                     ELSE -- заменили
                          vbAmount:= vbAmount_calc;
                     END IF;
                 END IF;*/
                 --
                 -- получилось в Автозаказе больше чем в остатках, т.е. отдаем весь "СРОК"
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                           -- может оказаться что для двух товаров
                         , tmpGoods.GoodsId
                           -- с учетом кратности - vbKoeffSUN
                         , CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END
                         , CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END * tmpGoods.Price
                           --
                         , 0 AS Amount_next
                         , 0 AS Summ_next
                         , 0 AS MovementId
                         , 0 AS MovementItemId
                    FROM (SELECT vbGoodsId AS GoodsId, vbPrice AS Price UNION SELECT vbGoodsId_PairSun AS GoodsId, vbPrice_PairSun AS Price WHERE vbGoodsId_PairSun > 0) AS tmpGoods
                    WHERE CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END > 0
                   ;
                 -- обнуляем кол-во что бы больше не искать
                 vbAmount     := 0;
                 vbAmount_save:= 0;
             ELSE
                 -- получилось в остатках больше чем надо, т.е. отдаем сколько надо и крутим дальше
                 --
                 -- если в Автозаказ "дробное" - отдаем "всю дробную часть", т.к. нельзя что б дробная была более чем в 1-ой аптеке
                 IF FLOOR (vbAmountResult) <> vbAmountResult
                 THEN
                     -- отбрас.дробную.Автозаказ + дробная часть "весь" остаток
                     vbAmount_calc:= FLOOR (vbAmountResult) + vbAmount_save - FLOOR (vbAmount_save);
                     -- если получилось больше чем Автозаказ
                     IF vbAmount_calc > vbAmountResult
                     THEN -- останется только целая часть
                          vbAmountResult:= FLOOR (vbAmount_calc);
                     ELSE -- заменили
                          vbAmountResult:= vbAmount_calc;
                     END IF;

                 END IF;
                 -- получилось в остатках больше чем надо, т.е. отдаем сколько надо и крутим дальше
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                           -- может оказаться что для двух товаров
                         , tmpGoods.GoodsId
                           -- здесь уже кратность учтена
                         , vbAmountResult
                         , vbAmountResult * tmpGoods.Price
                           --
                         , 0 AS Amount_next
                         , 0 AS Summ_next
                         , 0 AS MovementId
                         , 0 AS MovementItemId
                    FROM (SELECT vbGoodsId AS GoodsId, vbPrice AS Price UNION SELECT vbGoodsId_PairSun AS GoodsId, vbPrice_PairSun AS Price WHERE vbGoodsId_PairSun > 0) AS tmpGoods
                    WHERE vbAmountResult > 0
                   ;
                 -- уменьшаем на кол-во которое нашли и продолжаем поиск
                 vbAmount     := vbAmount      - vbAmountResult;
                 vbAmount_save:= vbAmount_save - vbAmountResult;
             END IF;

         END LOOP; -- финиш цикла по курсору2
         CLOSE curResult; -- закрыли курсор2.

     END LOOP; -- финиш цикла по курсору1
     CLOSE curPartion; -- закрыли курсор1


     -- !!!Удаляем НЕ получившиеся пары!!!
/*     DELETE FROM _tmpResult_Partion
     WHERE (_tmpResult_Partion.UnitId_from :: TVarChar || '_' || _tmpResult_Partion.UnitId_to :: TVarChar || '_' || _tmpResult_Partion.GoodsId :: TVarChar)
           IN (SELECT _tmpResult_Partion.UnitId_from :: TVarChar || '_' || _tmpResult_Partion.UnitId_to :: TVarChar || '_' || _tmpResult_Partion.GoodsId :: TVarChar
               FROM _tmpResult_Partion
                    -- отдаем парный
                    JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId_PairSun = _tmpResult_Partion.GoodsId
                    -- а основной не получилось
                    LEFT JOIN _tmpResult_Partion AS _tmpResult_Partion_check
                                                 ON _tmpResult_Partion_check.GoodsId     = _tmpGoods_SUN_PairSun.GoodsId
                                                AND _tmpResult_Partion_check.UnitId_from = _tmpResult_Partion.UnitId_from
                                                AND _tmpResult_Partion_check.UnitId_to   = _tmpResult_Partion.UnitId_to
               WHERE _tmpResult_Partion_check.GoodsId IS NULL
              );*/

    -- !!! Добавили парные, после распределения ...
     WITH -- Товар к которому нужна пара
          tmpResult_Partion AS (SELECT _tmpResult_Partion.*, _tmpGoods_SUN_PairSun.GoodsId_PairSun
                                FROM _tmpResult_Partion

                                     INNER JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = _tmpResult_Partion.GoodsId
                                ),
          -- Наличие парных
          tmpRemains_Pair  AS (SELECT _tmpGoods_SUN_PairSun.GoodsId
                                    , _tmpRemains.UnitId
                                    , _tmpRemains.Price
                                    , _tmpRemains.AmountRemains
                               FROM _tmpRemains

                                    INNER JOIN  _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId_PairSun = _tmpRemains.GoodsId
                               ),
          -- Распределение
          tmpResult AS (SELECT Result_Partion.*
                             , Remains_Pair.AmountRemains                AS AmountRemains
                             , Remains_Pair.Price                        AS PricePair
                             , SUM (Result_Partion.Amount) OVER (PARTITION BY Result_Partion.UnitId_from, Result_Partion.GoodsId_PairSun
                                                           ORDER BY Result_Partion.UnitId_to) AS AmountSUM
                         --    , ROW_NUMBER() OVER (PARTITION BY  Result_Partion.UnitId_from, Result_Partion.GoodsId_PairSun
                         --                         ORDER BY Result_Partion.UnitId_to DESC) AS DOrd
                       FROM tmpResult_Partion AS Result_Partion
                            INNER JOIN tmpRemains_Pair AS Remains_Pair
                                                         ON Remains_Pair.GoodsId = Result_Partion.GoodsId
                                                        AND Remains_Pair.UnitId  = Result_Partion.UnitId_from
                          )

     INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId)
     SELECT DriverId
          , UnitId_from
          , UnitId_to
          , GoodsId_PairSun
          , AmountAdd
          , (AmountAdd * PricePair)
          , 0 as Amount_next
          , 0 as Summ_next
          , 0 as MovementId
          , 0 as MovementItemId
        FROM (SELECT DD.*
                   , CASE WHEN DD.AmountRemains - DD.AmountSUM > 0 --AND DD.DOrd <> 1
                               THEN DD.Amount
                          ELSE DD.AmountRemains - DD.AmountSUM + DD.Amount
                     END AS AmountAdd
              FROM tmpResult AS DD
              WHERE DD.AmountRemains - (DD.AmountSUM - DD.Amount) > 0
             ) AS tmpItem;


/*     -- !!! Добавили парные, которых нет в Прайсе ...
     INSERT INTO _tmpRemains_calc (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve
                                 , AmountSun_real, AmountSun_summ, AmountSun_summ_save, AmountSun_unit, AmountSun_unit_save)
       SELECT _tmpResult_Partion.UnitId_to
            , _tmpResult_Partion.GoodsId
            , _tmpResult_Partion.Summ / _tmpResult_Partion.Amount AS Price
            , 0 AS MCS, 0 AS AmountResult, 0 AS AmountRemains, 0 AS AmountIncome, 0 AS AmountSend_in, 0 AS AmountSend_out, 0 AS AmountOrderExternal, 0 AS AmountReserve
            , 0 AS AmountSun_real, 0 AS AmountSun_summ, 0 AS AmountSun_summ_save, 0 AS AmountSun_unit, 0 AS AmountSun_unit_save
       FROM _tmpResult_Partion
            LEFT JOIN _tmpRemains_calc ON _tmpRemains_calc.UnitId  = _tmpResult_Partion.UnitId_to
                                      AND _tmpRemains_calc.GoodsId = _tmpResult_Partion.GoodsId
       WHERE _tmpRemains_calc.UnitId IS NULL
         AND _tmpResult_Partion.Amount > 0
      ;

     -- !!!проверка - получившиеся пары - для теста!!!
     IF (inUserId = 5 AND EXTRACT (HOUR FROM CURRENT_TIMESTAMP) >= 10)
     AND EXISTS (SELECT _tmpResult_Partion.UnitId_from :: TVarChar || '_' || _tmpResult_Partion.UnitId_to :: TVarChar || '_' || _tmpResult_Partion.GoodsId :: TVarChar
                 FROM _tmpResult_Partion
                      -- нашли пару
                      JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = _tmpResult_Partion.GoodsId
                      -- а здесь не нашли
                      LEFT JOIN _tmpResult_Partion AS _tmpResult_Partion_check
                                                   ON _tmpResult_Partion_check.GoodsId     = _tmpGoods_SUN_PairSun.GoodsId_PairSun
                                                  AND _tmpResult_Partion_check.UnitId_from = _tmpResult_Partion.UnitId_from
                                                  AND _tmpResult_Partion_check.UnitId_to   = _tmpResult_Partion.UnitId_to
                                                  AND _tmpResult_Partion_check.Amount      = _tmpResult_Partion.Amount
                 WHERE _tmpResult_Partion_check.GoodsId IS NULL
                )
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена пара в перемещении для <%>', (SELECT lfGet_Object_ValueData_sh (_tmpResult_Partion.UnitId_from) || ' => ' || lfGet_Object_ValueData_sh (_tmpResult_Partion.UnitId_to) || ' : ' || lfGet_Object_ValueData (_tmpResult_Partion.GoodsId)
                                                                          FROM _tmpResult_Partion
                                                                               -- нашли пару
                                                                               JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = _tmpResult_Partion.GoodsId
                                                                               -- а здесь не нашли
                                                                               LEFT JOIN _tmpResult_Partion AS _tmpResult_Partion_check
                                                                                                            ON _tmpResult_Partion_check.GoodsId     = _tmpGoods_SUN_PairSun.GoodsId_PairSun
                                                                                                           AND _tmpResult_Partion_check.UnitId_from = _tmpResult_Partion.UnitId_from
                                                                                                           AND _tmpResult_Partion_check.UnitId_to   = _tmpResult_Partion.UnitId_to
                                                                                                           AND _tmpResult_Partion_check.Amount      = _tmpResult_Partion.Amount
                                                                          WHERE _tmpResult_Partion_check.GoodsId IS NULL
                                                                         );
     END IF;
*/

     -- 6.1.2. !!!важно, для vbSumm_limit - оставляем только по условию!!!
     DELETE FROM _tmpResult_Partion
     WHERE _tmpResult_Partion.UnitId_from :: TVarChar || ' - ' || _tmpResult_Partion.UnitId_to :: TVarChar
       IN -- собрали в 1 перемещение
          (SELECT _tmpResult_Partion.UnitId_from :: TVarChar || ' - ' || _tmpResult_Partion.UnitId_to :: TVarChar
           FROM _tmpResult_Partion
           GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
           HAVING SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) < vbSumm_limit
          )
    ;


     -- Результат
     RETURN QUERY
       SELECT Object_Unit.Id          AS UnitId
            , Object_Unit.ValueData   AS UnitName
            , Object_Goods.Id         AS GoodsId
            , Object_Goods.ObjectCode AS GoodsCode
            , Object_Goods.ValueData  AS GoodsName
              -- продажи у получателя в разрезе T2=45
            , _tmpSale.Amount_t2 AS Amount_sale
            , _tmpSale.Summ_t2   AS Summ_sale
              -- итого сроковых по реальным остаткам, должно сходиться с AmountSun_summ_save
            , _tmpRemains_calc.AmountSun_real
            , _tmpRemains_calc.AmountSun_summ_save
              -- итого сроковые которые будем распределять
            , _tmpRemains_calc.AmountSun_summ
            , tmpRemains_Partion_sum.Amount_sun     :: TFloat AS AmountSunOnly_summ
            , tmpRemains_Partion_sum.Amount_notSold :: TFloat AS Amount_notSold_summ
              -- Автозаказ
            , _tmpRemains_calc.AmountResult
              -- итого Автозаказ по всем Аптекам
            , tmpRemains_sum.AmountResult        :: TFloat AS AmountResult_summ
              --
            , _tmpRemains_calc.AmountRemains
            , _tmpRemains_calc.AmountIncome
            , _tmpRemains_calc.AmountSend_in
            , _tmpRemains_calc.AmountSend_out
            , _tmpRemains_calc.AmountOrderExternal
            , _tmpRemains_calc.AmountReserve
              -- сроковые на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
            , _tmpRemains_calc.AmountSun_unit
            , _tmpRemains_calc.AmountSun_unit_save
              -- Цена
            , _tmpRemains_calc.Price
              -- НТЗ
            , _tmpRemains_calc.MCS
              -- Выкладка
            , _tmpRemains_calc.Layout

              -- информативно - "возможна" мнимальн сумма
            , tmpSumm.Summ_min   :: TFloat AS Summ_min
              -- информативно - "возможна" максимальн сумма
            , tmpSumm.Summ_max   :: TFloat AS Summ_max
              -- информативно - "возможно"кол-во таких накл.
            , tmpSumm.Unit_count :: TFloat AS Unit_count

              -- информативно - после распределения-1: мнимальн сумма
            , tmpSumm_res1.Summ_min   :: TFloat AS Summ_min_1
              -- информативно - после распределения-1: максимальн сумма
            , tmpSumm_res1.Summ_max   :: TFloat AS Summ_max_1
              -- информативно - после распределения-1: кол-во таких накл.
            , tmpSumm_res1.Unit_count :: TFloat AS Unit_count_1

              -- информативно - после распределения-1: мнимальн сумма
            , tmpSumm_res2.Summ_next_min :: TFloat AS Summ_min_2
              -- информативно - после распределения-1: максимальн сумма
            , tmpSumm_res2.Summ_next_max :: TFloat AS Summ_max_2
              -- информативно - после распределения-1: кол-во таких накл.
            , tmpSumm_res2.Unit_count    :: TFloat AS Unit_count_2

            , tmpSumm_res1_2.Summ_str      :: TVarChar AS Summ_str
            , tmpSumm_res2_2.Summ_next_str :: TVarChar AS Summ_next_str

            , tmpSumm_res1_3.UnitName_str      :: TVarChar AS UnitName_str
            , tmpSumm_res2_3.UnitName_next_str :: TVarChar AS UnitName_next_str

            -- !!!результат!!!
            , tmpSumm_res.Amount         :: TFloat AS Amount_res
            , tmpSumm_res.Summ           :: TFloat AS Summ_res
            , tmpSumm_res.Amount_next    :: TFloat AS Amount_next_res
            , tmpSumm_res.Summ_next      :: TFloat AS Summ_next_res

       FROM _tmpRemains_calc
            -- оставили только те, где есть Перемещения
            INNER JOIN (SELECT DISTINCT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId FROM _tmpResult_Partion
                       ) AS _tmpResult ON _tmpResult.UnitId_to = _tmpRemains_calc.UnitId
                                      AND _tmpResult.GoodsId   = _tmpRemains_calc.GoodsId
            -- ?оставили? только те, куда сумма перемещения "возможна" больше ЛИМИТА
            LEFT JOIN (SELECT _tmpSumm_limit.UnitId_to, MIN (_tmpSumm_limit.Summ) AS Summ_min, MAX (_tmpSumm_limit.Summ) AS Summ_max, COUNT(*) AS Unit_count FROM _tmpSumm_limit
                       --!!! WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                       WHERE _tmpSumm_limit.Summ > 0
                       GROUP BY _tmpSumm_limit.UnitId_to
                      ) AS tmpSumm ON tmpSumm.UnitId_to = _tmpRemains_calc.UnitId
             -- итого сроковые + notSold которые будем распределять
             LEFT JOIN (SELECT _tmpRemains_Partion.GoodsId, 0 AS Amount_sun, SUM (_tmpRemains_Partion.Amount) AS Amount_notSold
                        FROM _tmpRemains_Partion
                        GROUP BY _tmpRemains_Partion.GoodsId
                       ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains_calc.GoodsId
            -- !!!результат!!!
            LEFT JOIN (-- собрали в 1 перемещение
                       SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                            , SUM (COALESCE (_tmpResult_Partion.Amount, 0))      AS Amount
                            , SUM (COALESCE (_tmpResult_Partion.Summ, 0))        AS Summ
                            , SUM (COALESCE (_tmpResult_Partion.Amount_next, 0)) AS Amount_next
                            , SUM (COALESCE (_tmpResult_Partion.Summ_next, 0))   AS Summ_next
                       FROM _tmpResult_Partion
                       GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                      ) AS tmpSumm_res ON tmpSumm_res.UnitId_to = _tmpRemains_calc.UnitId
                                      AND tmpSumm_res.GoodsId   = _tmpRemains_calc.GoodsId

            -- !!!результат!!!
            -- после распределения-1, сумма перемещения больше ЛИМИТА
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, MIN (tmpSumm_res1.Summ) AS Summ_min, MAX (tmpSumm_res1.Summ) AS Summ_max, COUNT(*) AS Unit_count
                       FROM (-- собрали в 1 перемещение
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ) AS Summ FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
                            ) AS tmpSumm_res1
                       -- !!!больше лимита
                       --!!!WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1 ON tmpSumm_res1.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!результат!!!
            -- после распределения-2, сумма перемещения без ЛИМИТА
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, MIN (tmpSumm_res1.Summ_next) AS Summ_next_min, MAX (tmpSumm_res1.Summ_next) AS Summ_next_max, COUNT(*) AS Unit_count
                       FROM (-- собрали в 1 перемещение
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ_next) AS Summ_next FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount_next > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
                            ) AS tmpSumm_res1
                       -- !!!без лимита
                       -- WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res2 ON tmpSumm_res2.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!результат-2.1.!!!
            -- после распределения-1, сумма перемещения больше ЛИМИТА
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (zfConvert_FloatToString (tmpSumm_res1.Summ), ';') AS Summ_str
                       FROM (-- собрали в 1 перемещение
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ) AS Summ FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to ORDER BY 3 DESC
                            ) AS tmpSumm_res1
                       -- !!!больше лимита
                       --!!!WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1_2 ON tmpSumm_res1_2.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!результат-2.1.!!!
            -- после распределения-2, сумма перемещения без ЛИМИТА
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (zfConvert_FloatToString (tmpSumm_res1.Summ_next), ';') AS Summ_next_str
                       FROM (-- собрали в 1 перемещение
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ_next) AS Summ_next FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount_next > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to ORDER BY 3 DESC
                            ) AS tmpSumm_res1
                       -- !!!без лимита
                       -- WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res2_2 ON tmpSumm_res2_2.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!результат-2.2.!!!
            -- после распределения-1, сумма перемещения больше ЛИМИТА
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (Object.ValueData, ';') AS UnitName_str
                       FROM (-- собрали в 1 перемещение
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ) AS Summ FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to ORDER BY 3 DESC
                            ) AS tmpSumm_res1
                            LEFT JOIN Object ON Object.Id = tmpSumm_res1.UnitId_from
                       -- !!!больше лимита
                       --!!!WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1_3 ON tmpSumm_res1_3.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!результат-2.2.!!!
            -- после распределения-2, сумма перемещения без ЛИМИТА
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (Object.ValueData, ';') AS UnitName_next_str
                       FROM (-- собрали в 1 перемещение
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ_next) AS Summ_next FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount_next > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to ORDER BY 3 DESC
                            ) AS tmpSumm_res1
                            LEFT JOIN Object ON Object.Id = tmpSumm_res1.UnitId_from
                       -- !!!без лимита
                       -- WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res2_3 ON tmpSumm_res2_3.UnitId_to = _tmpRemains_calc.UnitId
            --
            --
            LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains_calc.UnitId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains_calc.GoodsId
            -- итого Автозаказ по всем Аптекам
            LEFT JOIN (SELECT _tmpRemains_calc.GoodsId, SUM (_tmpRemains_calc.AmountResult) AS AmountResult FROM _tmpRemains_calc GROUP BY _tmpRemains_calc.GoodsId
                      ) AS tmpRemains_sum ON tmpRemains_sum.GoodsId = _tmpRemains_calc.GoodsId
            LEFT JOIN _tmpSale_over AS _tmpSale ON _tmpSale.UnitId  = _tmpRemains_calc.UnitId
                                               AND _tmpSale.GoodsId = _tmpRemains_calc.GoodsId

-- тест для пары
--     WHERE _tmpRemains_calc.GoodsId IN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId FROM _tmpGoods_SUN_PairSun)
--        OR _tmpRemains_calc.GoodsId IN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun)

       -- ORDER BY Object_Goods.ObjectCode, Object_Unit.ValueData
       ORDER BY Object_Goods.ValueData, Object_Unit.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ObjectCode
      ;

  --  RAISE EXCEPTION '<ok>';


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.19                                        *
*/
/*
-- !!!удаленные отложенные чеки!!!
SELECT Movement.*
FROM Movement
     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 and MovementLinkObject_Unit.ObjectId = 375626 -- Аптека_1 пр_Героев_40
     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  and MovementItem.ObjectId = 40183 -- Дипроспан шприц 1мл N1
WHERE Movement.OperDate  >= '01.01.2019'
  AND Movement.DescId   = zc_Movement_Check()
  AND Movement.StatusId in (  zc_Enum_Status_Erased())
*/
-- тест
/*
     -- все Подразделения для схемы SUN-v2
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLockSale Boolean, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean) ON COMMIT DROP;
     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     CREATE TEMP TABLE _tmpUnit_SUN_balance (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. вся статистика продаж
     CREATE TEMP TABLE _tmpSale_over (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     -- 2.2. NotSold
     CREATE TEMP TABLE _tmpSale_not (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 2.3. Перемещение ВСЕ SUN-кроме текущего - Erased - за СЕГОДНЯ, что б не отправлять / не получать эти товары повторно в СУН-2
     CREATE TEMP TABLE  _tmpSUN_oth (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 2.4. товары для Кратность
     CREATE TEMP TABLE _tmpGoods_SUN (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 2.5. "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
     CREATE TEMP TABLE _tmpGoods_SUN_PairSun (GoodsId Integer, GoodsId_PairSun Integer) ON COMMIT DROP;

     -- 3.1. все остатки, СРОК
     CREATE TEMP TABLE _tmpRemains_Partion_all (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     -- 3.2. остатки, СРОК - для распределения
     CREATE TEMP TABLE _tmpRemains_Partion (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat) ON COMMIT DROP;


     -- 4. Остатки по которым есть Автозаказ и срок
     CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     -- 6.2. !!!товары - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     CREATE TEMP TABLE _tmpList_DefSUN (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. распределяем перемещения - по партиям со сроками
     CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 8. исключаем такие перемещения
     CREATE TEMP TABLE _tmpUnit_SunExclusion (UnitId_from Integer, UnitId_to Integer, isMCS_to Boolean) ON COMMIT DROP;

 SELECT * FROM lpInsert_Movement_Send_RemainsSun_over (inOperDate:= CURRENT_DATE + INTERVAL '1 DAY', inDriverId:= (SELECT MAX (OL.ChildObjectId) FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Driver()), inStep:= 1, inUserId:= 3) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
*/