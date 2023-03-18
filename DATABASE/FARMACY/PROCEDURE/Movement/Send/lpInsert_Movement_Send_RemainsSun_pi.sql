-- Function: lpInsert_Movement_Send_RemainsSun_pi

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_pi (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_pi(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inDriverId            Integer   , -- Водитель, распределяем только по аптекам этого
    IN inStep                Integer   , -- на 1-ом шаге находим DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда на 2-м шаге они участвовать не будут !!!
    IN inUserId              Integer     -- пользователь
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, isClose boolean
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
             , PromoUnit           TFloat -- Марк. план длч точки
             , isCloseMCS          boolean -- убить код
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
   DECLARE vbDate_3     TDateTime;
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

   DECLARE vbDOW_curr        Integer;

   DECLARE vbDayIncome_max   Integer;
   DECLARE vbDaySendSUN_max  Integer;
   DECLARE vbDaySendSUNAll_max Integer;

   DECLARE vbGoodsId_PairSun Integer;
   DECLARE vbPrice_PairSun   TFloat;
   DECLARE vbisEliminateColdSUN Boolean;
   DECLARE vbisOnlyColdSUN Boolean;
   DECLARE vbisShoresSUN Boolean;
   DECLARE vbisCancelBansSUN Boolean;

BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     -- !!!
     vbKoeff_over:= 2;

     -- !!! в днях
     vbPeriod_t1    := 30;
     vbPeriod_t2    := 0;

     -- !!!
     vbSumm_limit:= CASE WHEN 0 < (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                              THEN (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                         ELSE 1500
                    END;

     SELECT COALESCE(ObjectBoolean_CashSettings_EliminateColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_ShoresSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_OnlyColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_CancelBansSUN.ValueData, FALSE) 
     INTO vbisEliminateColdSUN, vbisShoresSUN, vbisOnlyColdSUN, vbisCancelBansSUN
     FROM Object AS Object_CashSettings
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_EliminateColdSUN
                                  ON ObjectBoolean_CashSettings_EliminateColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_EliminateColdSUN.DescId = zc_ObjectBoolean_CashSettings_EliminateColdSUN4()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_ShoresSUN
                                  ON ObjectBoolean_CashSettings_ShoresSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_ShoresSUN.DescId = zc_ObjectBoolean_CashSettings_ShoresSUN()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_OnlyColdSUN
                                  ON ObjectBoolean_CashSettings_OnlyColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_OnlyColdSUN.DescId = zc_ObjectBoolean_CashSettings_OnlyColdSUN4()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_CancelBansSUN
                                  ON ObjectBoolean_CashSettings_CancelBansSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_CancelBansSUN.DescId = zc_ObjectBoolean_CashSettings_CancelBansSUN()
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;

     -- все Подразделения для схемы SUN-v2
     DELETE FROM _tmpUnit_SUN;
     DELETE FROM _tmpGoods_Layout;
     DELETE FROM _tmpGoods_PromoUnit;
     DELETE FROM _tmpGoods_DiscountExternal;
     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     IF inStep = 1 THEN DELETE FROM _tmpUnit_SUN_balance; END IF;
     -- 1. все остатки, продажи => получаем кол-ва ПОТРЕБНОСТЬ у получателя
     DELETE FROM _tmpRemains_all;
     DELETE FROM _tmpRemains;
     DELETE FROM _tmpGoods_TP_exception;
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
     -- 3.1. все остатки, PI (Сверх запас)
     DELETE FROM _tmpRemains_Partion_all;
     -- 3.2. остатки, PI (Сверх запас) - для распределения
     DELETE FROM _tmpRemains_Partion;
     -- 4. Остатки по которым есть ПОТРЕБНОСТЬ и PI (Сверх запас)
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
        WHERE OF_KoeffSUN.DescId    = zc_ObjectFloat_Goods_KoeffSUN_v4()
          AND OF_KoeffSUN.ValueData > 0
       ;

     -- день недели
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  );

raise notice 'Value 1: %', CLOCK_TIMESTAMP();

     -- все Подразделения для схемы SUN-v4
     INSERT INTO _tmpUnit_SUN (UnitId, KoeffInSUN, KoeffOutSUN, Value_T1, Value_T2, DayIncome, DaySendSUN, DaySendSUNAll, Limit_N, isLock_CheckMSC, isLock_CloseGd, isLock_ClosePL, isLock_CheckMa, isColdOutSUN)
        SELECT OB.ObjectId AS UnitId
             , 0           AS KoeffInSUN
             , 0           AS KoeffOutSUN
             , CASE WHEN OF_T1.ValueData > 0 THEN OF_T1.ValueData ELSE vbPeriod_t1 END AS Value_T1
             , 0           AS Value_T2
             , CASE WHEN OF_DI.ValueData >= 0 THEN OF_DI.ValueData ELSE 0  END :: Integer AS DayIncome
             , CASE WHEN OF_DS.ValueData >  0 THEN OF_DS.ValueData ELSE 10 END :: Integer AS DaySendSUN
             , CASE WHEN OF_DSA.ValueData > 0 THEN OF_DSA.ValueData ELSE 0 END :: Integer AS DaySendSUNAll
             , CASE WHEN OF_SN.ValueData >  0 THEN OF_SN.ValueData ELSE 0  END :: TFloat   AS Limit_N
               -- TRUE = НЕ подключать чек "не для НТЗ"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 1 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLockSale
               -- TRUE = НЕТ товаров "закрыт код"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 3 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseGd
               -- TRUE = НЕТ товаров "убит код"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 5 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_ClosePL
               -- TRUE = НЕТ товаров "маркетинг"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 7 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseMa
             , COALESCE (OB_ColdOutSUN.ValueData, FALSE)                       AS isColdOutSUN
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN_pi()
             LEFT JOIN ObjectFloat   AS OF_T1  ON OF_T1.ObjectId  = OB.ObjectId AND OF_T1.DescId  = zc_ObjectFloat_Unit_T1_SUN_v4()
             LEFT JOIN ObjectFloat   AS OF_DI  ON OF_DI.ObjectId  = OB.ObjectId AND OF_DI.DescId  = zc_ObjectFloat_Unit_Sun_v2Income()
             LEFT JOIN ObjectFloat   AS OF_DS  ON OF_DS.ObjectId  = OB.ObjectId AND OF_DS.DescId  = zc_ObjectFloat_Unit_HT_SUN_v2()
             LEFT JOIN ObjectFloat   AS OF_DSA ON OF_DSA.ObjectId = OB.ObjectId AND OF_DSA.DescId = zc_ObjectFloat_Unit_HT_SUN_All()
             LEFT JOIN ObjectFloat   AS OF_SN  ON OF_SN.ObjectId  = OB.ObjectId AND OF_SN.DescId  = zc_ObjectFloat_Unit_LimitSUN_N()
             LEFT JOIN ObjectBoolean AS OB_ColdOutSUN    ON OB_ColdOutSUN.ObjectId    = OB.ObjectId AND OB_ColdOutSUN.DescId    = zc_ObjectBoolean_Unit_ColdOutSUN()
             LEFT JOIN ObjectString  AS OS_LL  ON OS_LL.ObjectId  = OB.ObjectId AND OS_LL.DescId  = zc_ObjectString_Unit_SUN_v4_Lock()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Driver
                                  ON ObjectLink_Unit_Driver.ObjectId      = OB.ObjectId
                                 AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
             LEFT JOIN Object AS Object_Driver ON Object_Driver.Id = ObjectLink_Unit_Driver.ChildObjectId
        WHERE OB.ValueData = TRUE
          AND OB.DescId = zc_ObjectBoolean_Unit_SUN_v4()
          -- если указан день недели - проверим его
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' AND vbisShoresSUN = FALSE OR
               OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 4 OR
               OS_ListDaySUN.ValueData ILIKE '%' || CASE WHEN vbDOW_curr - 1 = 0 THEN 7 ELSE vbDOW_curr - 1 END::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 3
        --  OR inUserId = 3 -- Админ - отладка
              )
       ;

     ANALYSE _tmpUnit_SUN;  

raise notice 'Value 2: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM _tmpUnit_SUN);

      -- Выкладки
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpLayoutMovement'))
     THEN
       DROP TABLE tmpLayoutMovement;
     END IF;

     CREATE TEMP TABLE tmpLayoutMovement ON COMMIT DROP AS
                               (SELECT Movement.Id                                                   AS Id
                                     , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE)      AS isPharmacyItem
                                     , COALESCE(MovementBoolean_NotMoveRemainder6.ValueData, FALSE) AS isNotMoveRemainder6
                                FROM Movement
                                     LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                               ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                              AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                                     LEFT JOIN MovementBoolean AS MovementBoolean_NotMoveRemainder6
                                                               ON MovementBoolean_NotMoveRemainder6.MovementId = Movement.Id
                                                              AND MovementBoolean_NotMoveRemainder6.DescId = zc_MovementBoolean_NotMoveRemainder6()
                                WHERE Movement.DescId = zc_Movement_Layout()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               );
     ANALYSE tmpLayoutMovement;

     WITH tmpLayout AS (SELECT Movement.ID                        AS Id
                             , MovementItem.ObjectId              AS GoodsId
                             , MovementItem.Amount                AS Amount
                             , Movement.isPharmacyItem            AS isPharmacyItem
                        FROM tmpLayoutMovement AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                                    AND MovementItem.Amount > 0
                       )
        , tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                                 , MovementItem.ObjectId              AS UnitId
                                 , MovementItem.Amount                AS Amount
                            FROM tmpLayoutMovement AS Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                                        AND MovementItem.Amount > 0
                           )
                               
        , tmpLayoutUnitCount AS (SELECT tmpLayoutUnit.ID                  AS Id
                                      , count(*)                          AS CountUnit
                                 FROM tmpLayoutUnit
                                 GROUP BY tmpLayoutUnit.ID
                                 )
        , tmpLayoutAll AS (SELECT tmpLayout.GoodsId                  AS GoodsId
                                , _tmpUnit_SUN.UnitId                AS UnitId
                                , tmpLayout.Amount                              AS Amount
                           FROM tmpLayout
                           
                                INNER JOIN _tmpUnit_SUN ON 1 = 1
                                
                                LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                        ON Unit_PharmacyItem.ObjectId  = _tmpUnit_SUN.UnitId
                                                       AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
                                 
                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = _tmpUnit_SUN.UnitId

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                           WHERE (tmpLayoutUnit.UnitId = _tmpUnit_SUN.UnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                             AND (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR tmpLayout.isPharmacyItem = True)
                           )
                                                              
     INSERT INTO _tmpGoods_Layout (GoodsId, UnitId, Layout) 
     SELECT tmpLayoutAll.GoodsId               AS GoodsId
          , tmpLayoutAll.UnitId                AS UnitId
          , MAX (tmpLayoutAll.Amount):: TFloat AS Amount
      FROM tmpLayoutAll      
      GROUP BY tmpLayoutAll.GoodsId
             , tmpLayoutAll.UnitId;
             
     ANALYSE _tmpGoods_Layout;
             
raise notice 'Value 3: %', CLOCK_TIMESTAMP();             

     -- Маркетинговый план для точек
      WITH tmpUserUnit AS (SELECT COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId) AS UnitId
                                , Count(*)                                                                   AS CountUser
                           FROM Movement
                                  
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                        AND MovementItem.DescId = zc_MI_Master()

                                 LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                      ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
   
                                 LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                                      ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                     AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

                                 LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                      ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                     AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                            
                           WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                             AND Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate)
                             AND ObjectLink_Member_Position.ChildObjectId = 1672498
                           GROUP BY COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId))

      INSERT INTO _tmpGoods_PromoUnit
      SELECT MI_Goods.UnitId                         AS UnitId
           , MI_Goods.GoodsId                        AS GoodsId
           , MI_Goods.Amount * tmpUserUnit.CountUser AS Amount

      FROM gpSelect_PromoUnit_UnitGoods (inOperDate := inOperDate, inSession := inUserId::TVarChar) AS MI_Goods

           INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MI_Goods.UnitId
                                                          
           INNER JOIN tmpUserUnit ON tmpUserUnit.UnitId = MI_Goods.UnitId           
      ;

     ANALYSE _tmpGoods_PromoUnit;
             
raise notice 'Value 4: %', CLOCK_TIMESTAMP();             

     -- Товары дисконтных проектов
     
      WITH tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId 
                                    , ObjectLink_Unit.ChildObjectId                 AS UnitId
                               FROM Object AS Object_DiscountExternalTools
                                     LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                          ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                         AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                     LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                          ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                         AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                                  AND Object_DiscountExternalTools.isErased = False
                                )
      INSERT INTO _tmpGoods_DiscountExternal
      SELECT 
             tmpUnitDiscount.UnitId  
           , ObjectLink_BarCode_Goods.ChildObjectId AS GoodsId
                                               
      FROM Object AS Object_BarCode
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                     
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

           LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId 

      WHERE Object_BarCode.DescId = zc_Object_BarCode()
        AND Object_BarCode.isErased = False
        AND Object_Object.isErased = False
        AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
      GROUP BY ObjectLink_BarCode_Goods.ChildObjectId
             , tmpUnitDiscount.UnitId;

     ANALYSE _tmpGoods_DiscountExternal;
             
raise notice 'Value 5: %', CLOCK_TIMESTAMP();             

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
     INSERT INTO _tmpGoods_SUN_PairSun (GoodsId, GoodsId_PairSun, PairSunAmount)
        SELECT OL_GoodsPairSun.ObjectId      AS GoodsId
             , OL_GoodsPairSun.ChildObjectId            AS GoodsId_PairSun
             , COALESCE (OF_PairSunAmount.ValueData, 1) AS PairSunAmount
        FROM ObjectLink AS OL_GoodsPairSun

             LEFT JOIN ObjectFloat AS OF_PairSunAmount
                                   ON OF_PairSunAmount.ObjectId  = OL_GoodsPairSun.ObjectId 
                                  AND OF_PairSunAmount.DescId    = zc_ObjectFloat_Goods_PairSunAmount()

        WHERE OL_GoodsPairSun.ChildObjectId > 0 AND OL_GoodsPairSun.DescId = zc_ObjectLink_Goods_GoodsPairSun()
       ;

     ANALYSE _tmpGoods_SUN_PairSun;
             
raise notice 'Value 6: %', CLOCK_TIMESTAMP();             

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     WITH
         tmpMovement AS (SELECT Movement.Id
                              , MovementLinkObject_Unit.ObjectId AS UnitId
                         FROM Movement

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                         WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                            AND Movement.StatusId = zc_Enum_Status_UnComplete())
      , tmpGoods AS (SELECT Movement.UnitId
                          , MovementItem.ObjectId       AS GoodsId
                          , SUM(MovementItem.Amount)    AS Amount
                     FROM _tmpUnit_SUN

                          INNER JOIN tmpMovement AS Movement ON Movement.UnitId = _tmpUnit_SUN.UnitId

                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased  = FALSE
                                         AND MovementItem.Amount < 0
                          INNER JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                            ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                          INNER JOIN ObjectBoolean AS ObjectBoolean_CommentTR_BlockFormSUN
                                                   ON ObjectBoolean_CommentTR_BlockFormSUN.ObjectId = MILinkObject_CommentTR.ObjectId
                                                  AND ObjectBoolean_CommentTR_BlockFormSUN.DescId = zc_ObjectFloat_CommentTR_BlockFormSUN()
                                                  AND ObjectBoolean_CommentTR_BlockFormSUN.ValueData = True
                     GROUP BY Movement.UnitId
                            , MovementItem.ObjectId
                     )

     INSERT INTO _tmpGoods_TP_exception   (UnitId, GoodsId)
     SELECT tmpGoods.UnitId, tmpGoods.GoodsId
     FROM tmpGoods;

     ANALYSE _tmpGoods_TP_exception;
             
raise notice 'Value 7: %', CLOCK_TIMESTAMP();             

     -- исключаем такие перемещения
     INSERT INTO _tmpUnit_SunExclusion (UnitId_from, UnitId_to, isMCS_to)
        SELECT COALESCE (ObjectLink_From.ChildObjectId, ObjectLink_Unit_Area_From.ObjectId, _tmpUnit_SUN_From.UnitId) AS UnitId_from
             , COALESCE (ObjectLink_To.ChildObjectId,   ObjectLink_Unit_Area_To.ObjectId,   _tmpUnit_SUN_To.UnitId)   AS UnitId_to
             , FALSE                                                              AS isMCS_to
        FROM Object
             INNER JOIN ObjectBoolean AS OB
                                      ON OB.ObjectId  = Object.Id
                                     AND OB.DescId    = zc_ObjectBoolean_SunExclusion_v4()
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
       ;

     ANALYSE _tmpUnit_SunExclusion;
             
raise notice 'Value 8: %', CLOCK_TIMESTAMP();             

     -- 2.1. вся статистика продаж - PI (Сверх запас)
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
                   LEFT JOIN MovementBoolean AS MB_CorrectMarketing
                                             ON MB_CorrectMarketing.MovementId = MIContainer.MovementId
                                            AND MB_CorrectMarketing.DescId     = zc_MovementBoolean_CorrectMarketing()
                                            AND MB_CorrectMarketing.ValueData  = TRUE
              WHERE MIContainer.DescId         = zc_MIContainer_Count()
                AND MIContainer.MovementDescId = zc_Movement_Check()
                AND MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((vbPeriod_t_max :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate
                -- !!!не учитывать если галка "не для СУН"
                AND (MB_NotMCS.MovementId IS NULL OR _tmpUnit_SUN.isLock_CheckMSC = FALSE)
                -- !!!не учитывать если галка "Корректировка суммы маркетинга в ЗП"
                AND (MB_CorrectMarketing.MovementId IS NULL OR _tmpUnit_SUN.isLock_CheckMa = FALSE)        
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
                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MLO_Unit.ObjectId
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

     ANALYSE _tmpSale_over;
             
raise notice 'Value 9: %', CLOCK_TIMESTAMP();             

     -- 2.2. NotSold
     -- CREATE TEMP TABLE _tmpSale_not (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
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

     ANALYSE _tmpSale_not;
             
raise notice 'Value 10: %', CLOCK_TIMESTAMP();             

     -- 2.3. Перемещение ВСЕ SUN-кроме текущего - Erased - за СЕГОДНЯ, что б не отправлять / не получать эти товары повторно в СУН-2-пи
     -- CREATE TEMP TABLE  _tmpSUN_oth (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
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
             LEFT JOIN MovementBoolean AS MB_SUN_v4
                                       ON MB_SUN_v4.MovementId = Movement.Id
                                      AND MB_SUN_v4.DescId     = zc_MovementBoolean_SUN_v4()
                                      AND MB_SUN_v4.ValueData  = TRUE
        WHERE Movement.OperDate = inOperDate
          AND Movement.DescId   = zc_Movement_Send()
          AND Movement.StatusId = zc_Enum_Status_Erased()
          -- исключили текущие
          AND MB_SUN_v4.MovementId IS NULL
        --AND 1=0
       ;

     ANALYSE _tmpSUN_oth;
     
        -- Xолод
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpConditionsKeep'))
     THEN
       DROP TABLE tmpConditionsKeep;
     END IF;

     CREATE TEMP TABLE tmpConditionsKeep ON COMMIT DROP AS
     SELECT Object_Goods.ID AS ObjectId
     FROM Object_Goods_Retail AS Object_Goods 
          LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
          LEFT JOIN ObjectBoolean AS ObjectBoolean_ColdSUN
                                  ON ObjectBoolean_ColdSUN.ObjectId = Object_Goods_Main.ConditionsKeepId
                                 AND ObjectBoolean_ColdSUN.DescId = zc_ObjectBoolean_ConditionsKeep_ColdSUN()
     WHERE Object_Goods.RetailId = 4
       AND (COALESCE (ObjectBoolean_ColdSUN.ValueData, FALSE) = TRUE
            OR Object_Goods_Main.isColdSUN = TRUE);
     
     ANALYSE tmpConditionsKeep;
     
             
raise notice 'Value 11: %', CLOCK_TIMESTAMP();             

     -- 2.4. все остатки у ПОЛУЧАТЕЛЯ, продажи => расчет кол-ва ПОТРЕБНОСТЬ
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
                                 LEFT JOIN MovementBoolean AS MB_SUN_v4
                                                           ON MB_SUN_v4.MovementId = Movement.Id
                                                          AND MB_SUN_v4.DescId     = zc_MovementBoolean_SUN_v4()
                                                          AND MB_SUN_v4.ValueData  = TRUE
                                                          AND Movement.OperDate    >= inOperDate
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '30 DAY' AND Movement.OperDate < inOperDate + INTERVAL '30 DAY'
                           -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           -- AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                              AND MB_SUN_v4.MovementId IS NULL
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
                                 LEFT JOIN MovementBoolean AS MB_SUN_v4
                                                           ON MB_SUN_v4.MovementId = Movement.Id
                                                          AND MB_SUN_v4.DescId     = zc_MovementBoolean_SUN_v4()
                                                          AND MB_SUN_v4.ValueData  = TRUE
                                                          AND Movement.OperDate    >= inOperDate
                         -- WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '14 DAY' AND Movement.OperDate < inOperDate + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              AND MovementBoolean_Deferred.MovementId IS NULL
                              AND MB_SUN_v4.MovementId IS NULL
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
          -- цены
        , tmpPrice AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , ROUND (Price_Value.ValueData, 2)  AS Price
                            , MCS_Value.ValueData               AS MCSValue
                            , CASE WHEN Price_MCSValueMin.ValueData IS NOT NULL
                                   THEN CASE WHEN COALESCE (Price_MCSValueMin.ValueData, 0) < COALESCE (MCS_Value.ValueData, 0) THEN COALESCE (Price_MCSValueMin.ValueData, 0) ELSE MCS_Value.ValueData END
                                   ELSE 0
                              END AS MCSValue_min
                            , COALESCE (MCS_isClose.ValueData, FALSE) AS isCloseMCS
                       FROM ObjectLink AS OL_Price_Unit
                            -- !!!только для таких Аптек!!!
                            INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_Price_Unit.ChildObjectId
                            LEFT JOIN ObjectBoolean AS MCS_isClose
                                                    ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                   AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                   AND MCS_isClose.ValueData = TRUE
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
                         -- товары "убит код"
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
                                   , COALESCE (tmpPrice.isCloseMCS, FALSE)                 AS isCloseMCS
                              FROM tmpPrice
                                   FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpPrice.GoodsId
                                                             AND tmpGoodsCategory.UnitId  = tmpPrice.UnitId
                              WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                 OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                                 OR COALESCE (tmpPrice.Price, 0) <> 0
                             )
     -- 2.5. Результат: все остатки у ПОЛУЧАТЕЛЯ, продажи => расчет кол-во ПОТРЕБНОСТЬ: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains_all (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve, isCloseMCS)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             , -- расчет ПОТРЕБНОСТЬ
               CASE -- если НТЗ_МИН = 0 ИЛИ ост <= НТЗ_МИН
                    WHEN COALESCE (tmpObject_Price.MCSValue_min, 0) = 0 OR (COALESCE (tmpRemains.Amount, 0) <= COALESCE (tmpObject_Price.MCSValue_min, 0))
                         THEN CASE -- для такого НТЗ
                                   WHEN tmpObject_Price.MCSValue >= 0.1 AND tmpObject_Price.MCSValue < 10
                                   -- и 1 >= НТЗ - "остаток"
                                    AND 1 >= ROUND ((tmpObject_Price.MCSValue
                                                     -- МИНУС остаток - "отложено" + "перемещ" + "приход" + "заявка"
                                                   - CASE WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
                                                              + COALESCE (tmpMI_Send_in.Amount, 0)
                                                              + COALESCE (tmpMI_Income.Amount, 0)
                                                              + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                               ) > 0
                                                          THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
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
                                        THEN -- округляем ВВЕРХ
                                             CEIL ((tmpObject_Price.MCSValue
                                                    -- МИНУС остаток - "отложено" + "перемещ" + "приход" + "заявка"
                                                  - CASE WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
                                                             + COALESCE (tmpMI_Send_in.Amount, 0)
                                                             + COALESCE (tmpMI_Income.Amount, 0)
                                                             + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                              ) > 0
                                                         THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
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
                                   -- для такого НТЗ
                                   WHEN tmpObject_Price.MCSValue >= 10
                                   -- и 1 >= НТЗ - "остаток"
                                    AND 1 >= CEIL ((tmpObject_Price.MCSValue
                                                    -- МИНУС остаток - "отложено" + "перемещ" + "приход" + "заявка"
                                                  - CASE WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
                                                             + COALESCE (tmpMI_Send_in.Amount, 0)
                                                             + COALESCE (tmpMI_Income.Amount, 0)
                                                             + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                              ) > 0
                                                         THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
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
                                        THEN -- округляем
                                             ROUND ((tmpObject_Price.MCSValue
                                                     -- МИНУС остаток - "отложено" + "перемещ" + "приход" + "заявка"
                                                   - CASE WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
                                                              + COALESCE (tmpMI_Send_in.Amount, 0)
                                                              + COALESCE (tmpMI_Income.Amount, 0)
                                                              + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                               ) > 0
                                                          THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
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
                                   ELSE -- округляем ВВНИЗ
                                        FLOOR ((tmpObject_Price.MCSValue
                                                -- МИНУС остаток - "отложено" + "перемещ" + "приход" + "заявка"
                                              - CASE WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
                                                         + COALESCE (tmpMI_Send_in.Amount, 0)
                                                         + COALESCE (tmpMI_Income.Amount, 0)
                                                         + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                          ) > 0
                                                     THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
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
                              END
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
               -- Убить код
             , COALESCE (tmpObject_Price.isCloseMCS, FALSE)    AS isCloseMCS
        FROM tmpObject_Price
             -- Работают по СУН - только отправка
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_out
                                     ON OB_Unit_SUN_out.ObjectId  = tmpObject_Price.UnitId
                                    AND OB_Unit_SUN_out.DescId    = zc_ObjectBoolean_Unit_SUN_v4_out()
                                    AND OB_Unit_SUN_out.ValueData = TRUE
             -- Исключения по техническим переучетам
             LEFT JOIN _tmpGoods_TP_exception AS tmpGoods_TP_exception
                                              ON tmpGoods_TP_exception.UnitId  = tmpObject_Price.UnitId
                                             AND tmpGoods_TP_exception.GoodsId = tmpObject_Price.GoodsId
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
             -- если товар среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = tmpObject_Price.GoodsId

             -- НЕ отбросили !!холод!!
             /*LEFT JOIN ObjectLink AS OL_Goods_ConditionsKeep
                                    ON OL_Goods_ConditionsKeep.ObjectId = tmpObject_Price.GoodsId
                                   AND OL_Goods_ConditionsKeep.DescId   = zc_ObjectLink_Goods_ConditionsKeep()
               LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = OL_Goods_ConditionsKeep.ChildObjectId
             */
        WHERE OB_Unit_SUN_out.ObjectId IS NULL
          -- товары "закрыт код"
          AND (ObjectBoolean_Goods_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_CloseGd = FALSE OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0)
          -- Исключения по техническим переучетам
          AND COALESCE (tmpGoods_TP_exception.GoodsId, 0) = 0
       ;
     -- 2.6. Результат: все остатки ПОЛУЧАТЕЛЯ, продажи => получаем кол-ва ПОТРЕБНОСТЬ
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT _tmpRemains_all.UnitId, _tmpRemains_all.GoodsId, _tmpRemains_all.Price, _tmpRemains_all.MCS, _tmpRemains_all.AmountResult, _tmpRemains_all.AmountRemains, _tmpRemains_all.AmountIncome, _tmpRemains_all.AmountSend_in, _tmpRemains_all.AmountSend_out, _tmpRemains_all.AmountOrderExternal, _tmpRemains_all.AmountReserve
        FROM _tmpRemains_all
             -- если товар среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_all.GoodsId

        WHERE -- !!!только с таким AmountResult!!!
              _tmpRemains_all.AmountResult >= 1.0
              -- !!!Добавили парные!!!
           OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
       ;

     ANALYSE _tmpRemains_all;
             
raise notice 'Value 12: %', CLOCK_TIMESTAMP();             

     -- значения для разделения по срокам
     SELECT Date_6, Date_3, Date_1, Date_0
     INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
     FROM lpSelect_PartionDateKind_SetDate ();

     -- 3.1. все остатки ОТПРАВИТЕЛЯ, PI (Сверх запас)
     INSERT INTO _tmpRemains_Partion_all (ContainerDescId, UnitId, ContainerId_Parent, ContainerId, GoodsId, Amount, Amount_notSold)
        WITH -- остатки - список для PI
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
             -- список ОТПРАВИТЕЛЯ для PI (Сверх запас)
           , tmpOver_list AS (SELECT tmpContainer.UnitID
                                   , tmpContainer.GoodsID
                                   , SUM (tmpContainer.Amount) AS Amount
                              FROM tmpContainer
                              GROUP BY tmpContainer.UnitID
                                     , tmpContainer.GoodsID
                             )
               -- MCS + Price
             , tmpMCS AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                               , OL_Price_Goods.ChildObjectId      AS GoodsId
                               , MCS_Value.ValueData               AS MCSValue
                          FROM ObjectLink AS OL_Price_Unit
                               LEFT JOIN ObjectBoolean AS MCS_isClose
                                                       ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                      AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                      AND MCS_isClose.ValueData = TRUE
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
                               INNER JOIN tmpOver_list ON tmpOver_list.UnitId  = OL_Price_Unit.ChildObjectId
                                                      AND tmpOver_list.GoodsId = OL_Price_Goods.ChildObjectId
                               -- !!!
                               LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_Price_Unit.ChildObjectId

                          WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                            -- товары "убит код"
                            AND (MCS_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_ClosePL = FALSE)
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

                                     LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                                ON MovementBoolean_SUN.MovementId = Movement.Id
                                                               AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()

                                     LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId

                                WHERE Movement.OperDate BETWEEN inOperDate - (vbDaySendSUNAll_max :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                  AND Movement.DescId   = zc_Movement_Send()
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                  AND COALESCE (MovementBoolean_SUN.ValueData, FALSE)  = FALSE
                                GROUP BY MovementLinkObject_To.ObjectId
                                       , MovementItem.ObjectId
                                HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (_tmpUnit_SUN.DaySendSUNAll :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                                      THEN MovementItem.Amount
                                                 ELSE 0
                                            END) > 0
                            )
             -- так можно определить PI (Сверх запас), Но потом надо еще раз, с учетом: отложенные Чеки + не проведенные с CommentError + Перемещение - расход (ожидается)
           , tmpNotSold_all AS (SELECT tmpOver_list.UnitID
                                     , tmpOver_list.GoodsID
                                       -- Остаток
                                     , tmpOver_list.Amount
                                       -- остатки, PI (Сверх запас) - его и будем распределять
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
                                            ELSE FLOOR (tmpOver_list.Amount - CASE WHEN COALESCE (tmpMCS.MCSValue, 0) > COALESCE (_tmpSale_over.Amount_t1, 0)
                                                                                        THEN COALESCE (tmpMCS.MCSValue, 0)
                                                                                   ELSE COALESCE (_tmpSale_over.Amount_t1, 0)
                                                                              END
                                                       )
                                       END AS Amount_notSold
                                FROM tmpOver_list
                                     LEFT JOIN _tmpSale_over ON _tmpSale_over.UnitId  = tmpOver_list.UnitId
                                                            AND _tmpSale_over.GoodsID = tmpOver_list.GoodsID
                                     LEFT JOIN _tmpSale_not ON _tmpSale_not.UnitId  = tmpOver_list.UnitId
                                                           AND _tmpSale_not.GoodsID = tmpOver_list.GoodsID
                                     LEFT JOIN tmpMCS ON tmpMCS.UnitId  = tmpOver_list.UnitId
                                                     AND tmpMCS.GoodsID = tmpOver_list.GoodsID
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
                                      -- !!!
                                  AND CASE -- отдаем ВСЕ - это парный
                                           WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
                                                THEN tmpOver_list.Amount

                                           -- отдаем ВСЕ
                                           WHEN _tmpSale_not.GoodsID > 0
                                                THEN tmpOver_list.Amount

                                           -- оставляем 1
                                           WHEN COALESCE (_tmpSale_over.Amount_t1, 0) < 1
                                                THEN FLOOR (tmpOver_list.Amount - 1)

                                           --  Отправка: округляем ВВНИЗ: если X1 больше Y1 на 1 и больше: Y1 - продажи у отправителя в разрезе T1=60 дней;
                                           ELSE FLOOR (tmpOver_list.Amount - CASE WHEN COALESCE (tmpMCS.MCSValue, 0) > COALESCE (_tmpSale_over.Amount_t1, 0)
                                                                                       THEN COALESCE (tmpMCS.MCSValue, 0)
                                                                                  ELSE COALESCE (_tmpSale_over.Amount_t1, 0)
                                                                             END)
                                      END > 0

                                  AND (-- остаток больше чем N
                                       COALESCE (_tmpUnit_SUN.Limit_N, 0) < tmpOver_list.Amount
                                       -- или это парный товар
                                    OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
                                      )
                               )
     -- для PI - находим ВСЕ сроковые
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
                  -- Income - за X дней - если приходило, PI уходить уже не может
                , tmpIncome AS (SELECT DISTINCT
                                       MovementLinkObject_To.ObjectId   AS UnitId_to
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
                 -- все что остается для PI
               , tmpNotSold AS (SELECT tmpNotSold_all.UnitID
                                     , tmpNotSold_all.GoodsID
                                       -- Остаток
                                     , tmpNotSold_all.Amount
                                       -- остатки, PI (Сверх запас) - его и будем распределять
                                     , tmpNotSold_all.Amount_notSold
                                FROM tmpNotSold_all
                                     -- ВСЕ сроковые
                                     LEFT JOIN tmpNotSold_PartionDate ON tmpNotSold_PartionDate.UnitId  = tmpNotSold_all.UnitID
                                                                     AND tmpNotSold_PartionDate.GoodsID = tmpNotSold_all.GoodsID
                                     -- Income - за X дней - если приходило, PI уходить уже не может
                                     LEFT JOIN tmpIncome ON tmpIncome.UnitId_to = tmpNotSold_all.UnitID
                                                        AND tmpIncome.GoodsID   = tmpNotSold_all.GoodsID
                                WHERE tmpNotSold_PartionDate.GoodsID  IS NULL
                                  AND tmpIncome.GoodsID IS NULL
                               )
       -- Перемещение SUN - расход - Erased - за СЕГОДНЯ, что б не отправлять эти товары повторно в СУН-пи
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
               -- остатки, PI (Сверх запас) - их и будем распределять
             , tmpNotSold.Amount_notSold AS Amount_notSold

        FROM tmpNotSold
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_in
                                     ON OB_Unit_SUN_in.ObjectId  = tmpNotSold.UnitId
                                    AND OB_Unit_SUN_in.DescId    = zc_ObjectBoolean_Unit_SUN_v4_in()
                                    AND OB_Unit_SUN_in.ValueData = TRUE
             -- !!!Перемещение SUN - расход - Erased - за СЕГОДНЯ, что б не отправлять эти товары повторно в СУН-2
             LEFT JOIN tmpMI_SUN_out ON tmpMI_SUN_out.UnitId_from = tmpNotSold.UnitId
                                    AND tmpMI_SUN_out.GoodsId     = tmpNotSold.GoodsId
        WHERE -- !!!
              OB_Unit_SUN_in.ObjectId IS NULL
              -- !!!
          AND tmpMI_SUN_out.GoodsId IS NULL
       ;

     ANALYSE _tmpRemains_Partion_all;
             
raise notice 'Value 13: %', CLOCK_TIMESTAMP();             

     -- 3.2. остатки ОТПРАВИТЕЛЯ, PI (Сверх запас) - для распределения
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
               -- MCS + Price
             , tmpMCS AS (SELECT OL_Price_Unit.ChildObjectId             AS UnitId
                               , OL_Price_Goods.ChildObjectId            AS GoodsId
                               , Price_Value.ValueData                   AS Price
                               , MCS_Value.ValueData                     AS MCSValue
                               , COALESCE (MCS_isClose.ValueData, FALSE) AS isCloseMCS
                          FROM ObjectLink AS OL_Price_Unit
                               LEFT JOIN ObjectBoolean AS MCS_isClose
                                                       ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                      AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                      AND MCS_isClose.ValueData = TRUE
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
                            -- товары "убит код"
                            AND (MCS_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_ClosePL = FALSE)
                         )
             -- отбросили !!НОТ!!
           , tmpGoods_NOT AS (SELECT OB_Goods_NOT.ObjectId
                              FROM ObjectBoolean AS OB_Goods_NOT
                              WHERE OB_Goods_NOT.DescId   = zc_ObjectBoolean_Goods_NOT_Sun_v4()
                                AND OB_Goods_NOT.ValueData = TRUE
                              --AND 1=0
                             )
       -- Результат: все остатки, PI (Сверх запас) - для распределения
       INSERT INTO _tmpRemains_Partion (ContainerDescId, UnitId, GoodsId, MCSValue, Amount_sale, Amount, Amount_save, Amount_real)
          SELECT 0 AS ContainerDescId
               , tmp.UnitId
               , tmp.GoodsId
               , COALESCE (tmpMCS.MCSValue, 0) AS MCSValue

                 -- продажи у отправителя в разрезе T1=60 дней
               , COALESCE (_tmpSale.Amount_t1, 0) AS Amount_sale

                 -- остатки, PI (Сверх запас) - их и будем распределять
               , FLOOR ((tmp.Amount_notSold
                       - COALESCE (_tmpRemains_all.AmountReserve, 0)
                         -- уменьшаем - Перемещение - расход (ожидается)
                       - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                         -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "излишки"
                       - COALESCE (tmpSUN_oth.Amount, 0)
                         -- НЕ уменьшаем еще на НТЗ
                         -- - COALESCE (tmpMCS.MCSValue, 0)
                          -- делим на кратность
                        ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                       ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                 AS Amount

                 -- остатки, ВСЕ
               , tmp.Amount             AS Amount_save

                 -- остатки, PI (Сверх запас) без корректировки
               , tmp.Amount_notSold     AS Amount_real

          FROM tmpGoods_sum AS tmp
               -- остатки ОТПРАВИТЕЛЯ
               LEFT JOIN _tmpRemains_all ON _tmpRemains_all.UnitId  = tmp.UnitId
                                        AND _tmpRemains_all.GoodsId = tmp.GoodsId
               -- НТЗ
               LEFT JOIN tmpMCS ON tmpMCS.UnitId  = tmp.UnitId
                               AND tmpMCS.GoodsId = tmp.GoodsId
               -- продажи
               LEFT JOIN _tmpSale_over AS _tmpSale ON _tmpSale.UnitId  = tmp.UnitId
                                                  AND _tmpSale.GoodsId = tmp.GoodsId
               -- товары для Кратность
               LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = tmp.GoodsId
               -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "излишки"
               LEFT JOIN (SELECT _tmpSUN_oth.UnitId_from, _tmpSUN_oth.GoodsId, SUM (_tmpSUN_oth.Amount) AS Amount
                          FROM _tmpSUN_oth
                          GROUP BY _tmpSUN_oth.UnitId_from, _tmpSUN_oth.GoodsId
                         ) AS tmpSUN_oth
                           ON tmpSUN_oth.UnitId_from = tmp.UnitId
                          AND tmpSUN_oth.GoodsId     = tmp.GoodsId
               -- а здесь, отбросили !!НОТ!!
               LEFT JOIN tmpGoods_NOT ON tmpGoods_NOT.ObjectId = tmp.GoodsId

          -- маленькое кол-во не распределяем
          WHERE FLOOR ((tmp.Amount_notSold
                        -- уменьшаем - отложенные Чеки + не проведенные с CommentError
                      - COALESCE (_tmpRemains_all.AmountReserve, 0)
                        -- уменьшаем - Перемещение - расход (ожидается)
                      - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                        -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "излишки"
                      - COALESCE (tmpSUN_oth.Amount, 0)
                        -- НЕ уменьшаем еще на НТЗ
                        -- - COALESCE (tmpMCS.MCSValue, 0)
                         -- делим на кратность
                       ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                      ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                > 1
            -- отбросили !!НОТ!!
            AND tmpGoods_NOT.ObjectId IS NULL
          ;

     ANALYSE _tmpRemains_Partion;
             
raise notice 'Value 14: %', CLOCK_TIMESTAMP();             


     -- Правим количество распределения если остаток меньше отгружать товар по СУН , если у него остаток больше чем N
     UPDATE _tmpRemains_Partion SET Amount = FLOOR (CASE WHEN _tmpRemains_Partion.Amount_save - COALESCE(_tmpUnit_SUN.Limit_N, 0) <= 0 THEN 0
                                                         ELSE  _tmpRemains_Partion.Amount_save - COALESCE(_tmpUnit_SUN.Limit_N, 0) END)
     FROM _tmpUnit_SUN
     WHERE _tmpRemains_Partion.UnitId = _tmpUnit_SUN.UnitId
       AND COALESCE(_tmpUnit_SUN.Limit_N, 0) > 0
       AND _tmpRemains_Partion.Amount_save - _tmpRemains_Partion.Amount < COALESCE(_tmpUnit_SUN.Limit_N, 0);


     ANALYSE _tmpRemains_Partion;
             
raise notice 'Value 15: %', CLOCK_TIMESTAMP();             

     -- 4. Остатки по которым есть ПОТРЕБНОСТЬ и PI (Сверх запас)
     INSERT INTO _tmpRemains_calc (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve
                                 , AmountSun_real, AmountSun_summ, AmountSun_summ_save, AmountSun_unit, AmountSun_unit_save)
        SELECT _tmpRemains.UnitId
             , _tmpRemains.GoodsId
               -- Цена
             , _tmpRemains.Price
               -- НТЗ
             , _tmpRemains.MCS
               -- ПОТРЕБНОСТЬ у получателя
             , _tmpRemains.AmountResult
               --
             , _tmpRemains.AmountRemains
             , _tmpRemains.AmountIncome
             , _tmpRemains.AmountSend_in
             , _tmpRemains.AmountSend_out
             , _tmpRemains.AmountOrderExternal
             , _tmpRemains.AmountReserve

               -- остатки, PI (Сверх запас) без корректировки
             , tmpRemains_Partion_sum.Amount_real       AS AmountSun_real
               -- остатки, PI (Сверх запас) - их и будем распределять
             , tmpRemains_Partion_sum.Amount            AS AmountSun_summ
               -- остатки, ВСЕ
             , tmpRemains_Partion_sum.Amount_save       AS AmountSun_summ_save

               -- инф.=0, сроковые на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
             , COALESCE (_tmpRemains_Partion.Amount, 0)      AS AmountSun_unit
               -- инф.=0, сроковые на этой аптеке
             , COALESCE (_tmpRemains_Partion.Amount_save, 0) AS AmountSun_unit_save

        FROM -- у Получателя - AmountResult
             _tmpRemains
             -- итого у ОТПРАВИТЕЛЯ - PI (Сверх запас) которые будем распределять - здесь и парные и обычные
             INNER JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.Amount) AS Amount, SUM (_tmpRemains_Partion.Amount_save) AS Amount_save, SUM (_tmpRemains_Partion.Amount_real) AS Amount_real
                         FROM _tmpRemains_Partion
                         GROUP BY _tmpRemains_Partion.GoodsId
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains.GoodsId

             -- PI (Сверх запас) на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
             LEFT JOIN _tmpRemains_Partion ON _tmpRemains_Partion.UnitId  = _tmpRemains.UnitId
                                          AND _tmpRemains_Partion.GoodsId = _tmpRemains.GoodsId
             -- если товар среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains.GoodsId

        WHERE _tmpRemains.AmountResult >= 1.0
          -- или товар среди парных
          -- OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
          AND _tmpGoods_SUN_PairSun_find.GoodsId_PairSun IS NULL

 --        AND (tmpRemains_Partion_sum.GoodsId > 0
 --         OR _tmpRemains.GoodsId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = 20392))
       ;

     ANALYSE _tmpRemains_calc;
             
raise notice 'Value 16: %', CLOCK_TIMESTAMP();             

     -- 5. из каких аптек остатки PI (Сверх запас) - "максимально" закрывают ПОТРЕБНОСТЬ
     INSERT INTO _tmpSumm_limit (UnitId_from, UnitId_to, Summ)
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from
             , _tmpRemains_calc.UnitId    AS UnitId_to
               -- если PI больше чем в ПОТРЕБНОСТЬ
             , SUM (CASE WHEN _tmpRemains_Partion.Amount >= _tmpRemains_calc.AmountResult
                              -- тогда в PI достаточно для ПОТРЕБНОСТЬ
                              THEN _tmpRemains_calc.AmountResult
                              -- иначе закрываем "частично" - т.е. сколько есть PI (Сверх запас)
                              ELSE FLOOR (_tmpRemains_Partion.Amount / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                    END
                  * _tmpRemains_calc.Price
                   )
        FROM -- Остатки по которым есть ПОТРЕБНОСТЬ и PI (Сверх запас)
             _tmpRemains_calc
             -- все остатки, PI (Сверх запас)
             INNER JOIN _tmpRemains_Partion ON _tmpRemains_Partion.GoodsId = _tmpRemains_calc.GoodsId

             -- товары для Кратность
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_calc.GoodsId

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

        WHERE _tmpUnit_SunExclusion.UnitId_to IS NULL
          AND _tmpUnit_SunExclusion_MCS.UnitId_to IS NULL

        GROUP BY _tmpRemains_Partion.UnitId
               , _tmpRemains_calc.UnitId
       ;

     ANALYSE _tmpSumm_limit;
             
raise notice 'Value 16: %', CLOCK_TIMESTAMP();             

     -- 6.1.1. распределяем-1 остатки PI (Сверх запас) - по всем аптекам
     -- CREATE TEMP TABLE _tmpResult_Partion (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     --
     -- курсор1 - все остатки ОТПРАВИТЕЛЯ, PI (Сверх запас) + остатки без корректировки
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
              , _tmpRemains_Partion.Amount - COALESCE(_tmpGoods_Layout.Layout, 0) - COALESCE(_tmpGoods_PromoUnit.Amount, 0) AS Amount

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
               -- парный
             ,  _tmpGoods_SUN_PairSun.GoodsId_PairSun

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

             LEFT JOIN _tmpGoods_PromoUnit ON _tmpGoods_PromoUnit.UnitId = _tmpRemains_Partion.UnitId
                                          AND _tmpGoods_PromoUnit.GoodsId = _tmpRemains_Partion.GoodsId
                                          
             LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = _tmpRemains_Partion.UnitId
                                       AND _tmpGoods_Layout.GoodsId = _tmpRemains_Partion.GoodsId

             -- найдем дисконтній товар
             LEFT JOIN _tmpGoods_DiscountExternal AS _tmpGoods_DiscountExternal
                                                  ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_Partion.UnitId
                                                 AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_Partion.GoodsId

             LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId  = _tmpRemains_Partion.UnitId

             -- а здесь, отбросили !!холод!!
             LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_Partion.GoodsId

        WHERE -- !!!Отключили парные!!!
              _tmpGoods_SUN_PairSun_find.GoodsId_PairSun IS NULL

          AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0

          AND _tmpRemains_Partion.Amount - COALESCE(_tmpGoods_Layout.Layout, 0) - COALESCE(_tmpGoods_PromoUnit.Amount, 0) > 0

              -- отбросили !!холод!!
          AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
              tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE OR
              _tmpUnit_SUN.isColdOutSUN = TRUE)

/*          AND CASE -- если у парного ост = 0, не отдаем
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND COALESCE (_tmpRemains_Partion_PairSun.Amount, 0) <= 0
                         THEN 0
                    -- если у парного ост < чем у "основного", меняем на меньшее
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND _tmpRemains_Partion_PairSun.Amount < _tmpRemains_Partion.Amount
                         THEN _tmpRemains_Partion_PairSun.Amount
                    -- инче берем ост "основного"
                    ELSE _tmpRemains_Partion.Amount
               END > 0
*/        ORDER BY 3 /*tmpSumm_limit.Summ*/ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curPartion INTO vbUnitId_from, vbGoodsId, vbAmount, vbAmount_save, vbKoeffSUN, vbGoodsId_PairSun;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         -- курсор2. - для ПОЛУЧАТЕЛЯ - потребность МИНУС сколько уже распределили для vbGoodsId
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

                 -- найдем дисконтній товар
                 LEFT JOIN _tmpGoods_DiscountExternal AS _tmpGoods_DiscountExternal
                                                      ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_calc.UnitId
                                                     AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_calc.GoodsId
            WHERE _tmpRemains_calc.GoodsId = vbGoodsId
              AND _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) > 0
              AND _tmpUnit_SunExclusion_MCS.UnitId_to IS NULL
              AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0

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
                    FROM (SELECT vbGoodsId AS GoodsId, vbPrice AS Price /*UNION SELECT vbGoodsId_PairSun AS GoodsId, vbPrice_PairSun AS Price WHERE vbGoodsId_PairSun > 0*/) AS tmpGoods
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
                    FROM (SELECT vbGoodsId AS GoodsId, vbPrice AS Price /*UNION SELECT vbGoodsId_PairSun AS GoodsId, vbPrice_PairSun AS Price WHERE vbGoodsId_PairSun > 0*/) AS tmpGoods
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

raise notice 'Value 17: %', CLOCK_TIMESTAMP();             

    -- !!! Добавили парные, после распределения ...
     WITH -- Товар к которому нужна пара
          tmpResult_Partion AS (SELECT _tmpResult_Partion.*, _tmpGoods_SUN_PairSun.GoodsId_PairSun, _tmpGoods_SUN_PairSun.PairSunAmount
                                FROM _tmpResult_Partion

                                     INNER JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = _tmpResult_Partion.GoodsId
                                ),
          -- Наличие парных
          tmpRemains_Pair  AS (SELECT _tmpRemains.GoodsId
                                    , _tmpRemains.UnitId
                                    , _tmpRemains.Price
                                    , _tmpRemains.AmountRemains
                               FROM _tmpRemains
                               WHERE _tmpRemains.GoodsId IN (SELECT DISTINCT  _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM  _tmpGoods_SUN_PairSun)
                               ),
          -- Распределение
          tmpResult AS (SELECT Result_Partion.*
                             , Result_Partion.Amount * Result_Partion.PairSunAmount AS AmountPair
                             , Remains_Pair.AmountRemains                AS AmountRemains
                             , Remains_Pair.Price                        AS PricePair
                             , SUM (Result_Partion.Amount * Result_Partion.PairSunAmount) 
                               OVER (PARTITION BY Result_Partion.UnitId_from, Result_Partion.GoodsId_PairSun
                                                           ORDER BY Result_Partion.UnitId_to) AS AmountSUM
                       FROM tmpResult_Partion AS Result_Partion
                            INNER JOIN tmpRemains_Pair AS Remains_Pair
                                                         ON Remains_Pair.GoodsId = Result_Partion.GoodsId_PairSun
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
                               THEN DD.AmountPair
                          ELSE DD.AmountRemains - DD.AmountSUM + DD.AmountPair
                     END AS AmountAdd
              FROM tmpResult AS DD
              WHERE DD.AmountRemains - (DD.AmountSUM - DD.AmountPair) > 0
             ) AS tmpItem;
             
     ANALYSE _tmpResult_Partion;

raise notice 'Value 18: %', CLOCK_TIMESTAMP();             

/*     -- !!!Удаляем НЕ получившиеся пары!!!
     DELETE FROM _tmpResult_Partion
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
              );

     -- !!! Добавили парные, которых нет в Прайсе ...
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
     IF (inUserId <> 5 OR EXTRACT (HOUR FROM CURRENT_TIMESTAMP) > 11)
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
            , Object_Goods_Main.ObjectCode AS GoodsCode
            , Object_Goods_Main.Name       AS GoodsName
            , Object_Goods_Main.isClose    AS isClose
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
            , _tmpGoods_Layout.Layout
            , _tmpGoods_PromoUnit.Amount
              -- Убить код
            , _tmpRemains_all.isCloseMCS

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
            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = _tmpRemains_calc.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
            -- итого Автозаказ по всем Аптекам
            LEFT JOIN (SELECT _tmpRemains_calc.GoodsId, SUM (_tmpRemains_calc.AmountResult) AS AmountResult FROM _tmpRemains_calc GROUP BY _tmpRemains_calc.GoodsId
                      ) AS tmpRemains_sum ON tmpRemains_sum.GoodsId = _tmpRemains_calc.GoodsId
            LEFT JOIN _tmpSale_over AS _tmpSale ON _tmpSale.UnitId  = _tmpRemains_calc.UnitId
                                               AND _tmpSale.GoodsId = _tmpRemains_calc.GoodsId

            LEFT JOIN _tmpGoods_PromoUnit ON _tmpGoods_PromoUnit.UnitId = _tmpRemains_calc.UnitId
                                         AND _tmpGoods_PromoUnit.GoodsId = _tmpRemains_calc.GoodsId

            LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = _tmpRemains_calc.UnitId
                                      AND _tmpGoods_Layout.GoodsId = _tmpRemains_calc.GoodsId
                                      
            LEFT JOIN _tmpRemains_all ON _tmpRemains_all.UnitId = _tmpRemains_calc.UnitId
                                     AND _tmpRemains_all.GoodsId = _tmpRemains_calc.GoodsId
-- тест для пары
--     WHERE _tmpRemains_calc.GoodsId IN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId FROM _tmpGoods_SUN_PairSun)
--        OR _tmpRemains_calc.GoodsId IN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun)

     -- ORDER BY Object_Goods.ObjectCode, Object_Unit.ValueData
       ORDER BY Object_Goods_Main.Name, Object_Unit.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ObjectCode
      ;

raise notice 'Value 20: %', CLOCK_TIMESTAMP();             

    -- RAISE EXCEPTION '<ok>';


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
     -- все Подразделения для схемы SUN-v4
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     CREATE TEMP TABLE _tmpUnit_SUN_balance (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. вся статистика продаж
     CREATE TEMP TABLE _tmpSale_over (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     -- 2.2. NotSold
     CREATE TEMP TABLE _tmpSale_not (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 2.3. Перемещение ВСЕ SUN-кроме текущего - Erased - за СЕГОДНЯ, что б не отправлять / не получать эти товары повторно в СУН-2-пи
     CREATE TEMP TABLE _tmpSUN_oth (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

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

 SELECT * FROM lpInsert_Movement_Send_RemainsSun_pi (inOperDate:= CURRENT_DATE + INTERVAL '4 DAY', inDriverId:= (SELECT MAX (OL.ChildObjectId) FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Driver()), inStep:= 1, inUserId:= 3) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
*/


--
select * from gpReport_Movement_Send_RemainsSun_pi(inOperDate := ('16.01.2023')::TDateTime ,  inSession := '3');