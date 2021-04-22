-- Function: lpInsert_Movement_Send_RemainsSun

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun(
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
              )
AS
$BODY$
   DECLARE vbObjectId Integer;

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
   DECLARE vbAmount_sun    TFloat;
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

   DECLARE vbDate_balance_partion TDateTime;
   DECLARE vbSumm_balance_partion TFloat;

   DECLARE vbIsOut_partion Boolean;
   DECLARE vbIsIn_partion  Boolean;

   DECLARE vbDayIncome_max Integer;
   DECLARE vbDaySendSUN_max Integer;
   DECLARE vbDaySendSUNAll_max Integer;

   DECLARE vbGoodsId_PairSun Integer;
   DECLARE vbPrice_PairSun   TFloat;

BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);


/* if  inUserId = 3 then
     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := 17720082
                                 , inUserId     := inUserId);
     update Movement set OperDate = OperDate - INTERVAL '1 Year' where Id = 17720082 ;

     PERFORM lpSetErased_Movement (inMovementId := Movement.Id
                                 , inUserId     := inUserId)
     from Movement
         JOIN MovementBoolean AS MovementBoolean_SUN
                              ON MovementBoolean_SUN.MovementId = Movement.Id
                             AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                             AND MovementBoolean_SUN.ValueData = true
     where Movement.OperDate >= '12.02.2020'
        and Movement.DescId = zc_Movement_Send();
 end if;*/

     -- !!!
     vbSumm_limit:= CASE WHEN 0 < (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                              THEN (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                         ELSE 1500
                    END;


     -- !!! накопительно баланс только по срокам
     vbDate_balance_partion:= '22.01.2020';
     -- !!! шаг для зоны уравнивания приход/расход - только по срокам
     vbSumm_balance_partion:= 1000;


     -- все Подразделения для схемы SUN
     DELETE FROM _tmpUnit_SUN;
     DELETE FROM _tmpUnit_SunExclusion;
     DELETE FROM _tmpGoods_Layout;
     DELETE FROM _tmpGoods_PromoUnit;
     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     IF inStep = 1
     THEN
         DELETE FROM _tmpUnit_SUN_balance;
         DELETE FROM _tmpUnit_SUN_balance_partion;
     END IF;
     DELETE FROM _tmpGoods_TP_exception;
     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     DELETE FROM _tmpRemains_all;
     DELETE FROM _tmpRemains;
     -- 2.1. вся статистика продаж
     DELETE FROM _tmpSale;
     -- 2.2.
     IF inStep = 1
     THEN
         -- товары для Кратность
         DELETE FROM _tmpGoods_SUN;
         -- "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
         DELETE FROM _tmpGoods_SUN_PairSun;
     END IF;
     -- 3.1. все остатки, СРОК
     DELETE FROM _tmpRemains_Partion_all;
     -- 3.2. остатки, СРОК - для распределения
     DELETE FROM _tmpRemains_Partion;
     -- 4. Остатки по которым есть Автозаказ и срок
     DELETE FROM _tmpRemains_calc;
     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     DELETE FROM _tmpSumm_limit;
     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь НЕ только >= vbSumm_limit
     DELETE FROM _tmpResult_Partion;
     -- 6.2. !!!товары - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     IF inStep = 1 THEN DELETE FROM _tmpList_DefSUN; END IF;
     -- 7.1. распределяем перемещения - по партиям со сроками
     DELETE FROM _tmpResult_child;


     -- день недели
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;

     -- все Подразделения для схемы SUN
     INSERT INTO _tmpUnit_SUN (UnitId, KoeffInSUN, KoeffOutSUN, DayIncome, DaySendSUN, DaySendSUNAll, Limit_N, isLock_CheckMSC, isLock_CloseGd, isLock_ClosePL)
        SELECT OB.ObjectId
             , COALESCE (OF_KoeffInSUN.ValueData, 0)  AS KoeffInSUN
             , COALESCE (OF_KoeffOutSUN.ValueData, 0) AS KoeffOutSUN
             , CASE WHEN OF_DI.ValueData >= 0 THEN OF_DI.ValueData ELSE 0  END :: Integer AS DayIncome
             , CASE WHEN OF_DS.ValueData >  0 THEN OF_DS.ValueData ELSE 10 END :: Integer AS DaySendSUN
             , CASE WHEN OF_DSA.ValueData > 0 THEN OF_DSA.ValueData ELSE 0 END :: Integer AS DaySendSUNAll
             , CASE WHEN OF_SN.ValueData >  0 THEN OF_SN.ValueData ELSE 0  END :: TFloat  AS Limit_N
               -- TRUE = НЕ подключать чек "не для НТЗ"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 1 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLockSale
               -- TRUE = НЕТ товаров "закрыт код"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 3 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseGd
               -- TRUE = НЕТ товаров "убит код"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 5 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_ClosePL
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectFloat   AS OF_KoeffInSUN  ON OF_KoeffInSUN.ObjectId  = OB.ObjectId AND OF_KoeffInSUN.DescId  = zc_ObjectFloat_Unit_KoeffInSUN()
             LEFT JOIN ObjectFloat   AS OF_KoeffOutSUN ON OF_KoeffOutSUN.ObjectId = OB.ObjectId AND OF_KoeffOutSUN.DescId = zc_ObjectFloat_Unit_KoeffOutSUN()
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
             LEFT JOIN ObjectFloat   AS OF_DI          ON OF_DI.ObjectId          = OB.ObjectId AND OF_DI.DescId          = zc_ObjectFloat_Unit_SunIncome()
             LEFT JOIN ObjectFloat   AS OF_DS          ON OF_DS.ObjectId          = OB.ObjectId AND OF_DS.DescId          = zc_ObjectFloat_Unit_HT_SUN_v1()
             LEFT JOIN ObjectFloat   AS OF_DSA         ON OF_DSA.ObjectId         = OB.ObjectId AND OF_DSA.DescId         = zc_ObjectFloat_Unit_HT_SUN_All()
             LEFT JOIN ObjectFloat   AS OF_SN          ON OF_SN.ObjectId          = OB.ObjectId AND OF_SN.DescId          = zc_ObjectFloat_Unit_LimitSUN_N()
             LEFT JOIN ObjectString  AS OS_LL          ON OS_LL.ObjectId          = OB.ObjectId AND OS_LL.DescId          = zc_ObjectString_Unit_SUN_v1_Lock()
             -- !!!только для этого водителя!!!
             /*INNER JOIN ObjectLink AS ObjectLink_Unit_Driver
                                   ON ObjectLink_Unit_Driver.ObjectId      = OB.ObjectId
                                  AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                                  AND ObjectLink_Unit_Driver.ChildObjectId = inDriverId*/
        WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN()
          -- если указан день недели - проверим его
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = ''
        --  OR inUserId = 3 -- Админ - отладка
              )
       ;

     -- Выкладки
     WITH tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                     , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                                FROM Movement
                                     LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                               ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                              AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                                WHERE Movement.DescId = zc_Movement_Layout()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               )
        , tmpLayout AS (SELECT Movement.ID                        AS Id
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
                                 
                           WHERE (tmpLayoutUnit.UnitId = _tmpUnit_SUN.UnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) > 0)
                             AND (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR tmpLayout.isPharmacyItem = True)
                           )
                                                              
     INSERT INTO _tmpGoods_Layout (GoodsId, UnitId, Layout) 
     SELECT tmpLayoutAll.GoodsId               AS GoodsId
          , tmpLayoutAll.UnitId                AS UnitId
          , MAX (tmpLayoutAll.Amount):: TFloat AS Amount
      FROM tmpLayoutAll      
      GROUP BY tmpLayoutAll.GoodsId
             , tmpLayoutAll.UnitId;

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
      SELECT OL_UnitCategory.Objectid                AS UnitId
           , MI_Goods.Objectid                       AS GoodsId
           , MI_Goods.Amount * tmpUserUnit.CountUser AS Amount

      FROM Movement

           INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                         ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
           INNER JOIN ObjectLink AS OL_UnitCategory
                                 ON OL_UnitCategory.DescId = zc_ObjectLink_Unit_Category()
                                AND OL_UnitCategory.ChildObjectId = MovementLinkObject_UnitCategory.ObjectId
                                
           INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_UnitCategory.Objectid

           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                              AND MI_Goods.DescId = zc_MI_Master()
                                              AND MI_Goods.isErased = FALSE
                                              AND MI_Goods.Amount > 0
                                            
                                                          
           INNER JOIN tmpUserUnit ON tmpUserUnit.UnitId = OL_UnitCategory.Objectid

      WHERE Movement.StatusId = zc_Enum_Status_Complete()
        AND Movement.DescId = zc_Movement_PromoUnit()
        AND Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate);
                
     -- находим максимальный
     vbDayIncome_max := (SELECT MAX (_tmpUnit_SUN.DayIncome)  FROM _tmpUnit_SUN);

     -- находим максимальный
     vbDaySendSUN_max:= (SELECT MAX (_tmpUnit_SUN.DaySendSUN) FROM _tmpUnit_SUN);
     -- находим максимальный
     vbDaySendSUNAll_max:= (SELECT MAX (_tmpUnit_SUN.DaySendSUNAll) FROM _tmpUnit_SUN);

     IF inStep = 1
     THEN
         -- товары для Кратность
         INSERT INTO _tmpGoods_SUN (GoodsId, KoeffSUN)
            SELECT OF_KoeffSUN.ObjectId  AS GoodsId
                 , OF_KoeffSUN.ValueData AS KoeffSUN
            FROM ObjectFloat AS OF_KoeffSUN
            WHERE OF_KoeffSUN.DescId    = zc_ObjectFloat_Goods_KoeffSUN_v1()
              AND OF_KoeffSUN.ValueData > 0
           ;
         -- "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
         INSERT INTO _tmpGoods_SUN_PairSun (GoodsId, GoodsId_PairSun)
            SELECT OL_GoodsPairSun.ObjectId      AS GoodsId
                 , OL_GoodsPairSun.ChildObjectId AS GoodsId_PairSun
            FROM ObjectLink AS OL_GoodsPairSun
            WHERE OL_GoodsPairSun.ChildObjectId > 0 AND OL_GoodsPairSun.DescId = zc_ObjectLink_Goods_GoodsPairSun()
           ;

     END IF;

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

     -- исключаем такие перемещения
     INSERT INTO _tmpUnit_SunExclusion (UnitId_from, UnitId_to)
        SELECT COALESCE (ObjectLink_From.ChildObjectId, _tmpUnit_SUN_From.UnitId) AS UnitId_from
             , COALESCE (ObjectLink_To.ChildObjectId,   _tmpUnit_SUN_To.UnitId)   AS UnitId_to
        FROM Object
             INNER JOIN ObjectBoolean AS OB
                                      ON OB.ObjectId  = Object.Id
                                     AND OB.DescId    = zc_ObjectBoolean_SunExclusion_v1()
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


     IF inStep = 1
     THEN
         -- баланс-1 по Аптекам - если не соответствует, соотв приход или расход блокируется
         WITH -- SUN - за 30 дней
              tmpSUN AS (SELECT MovementLinkObject_From.ObjectId AS UnitId_from
                              , MovementLinkObject_To.ObjectId   AS UnitId_to
                              , SUM (MovementItem.Amount * COALESCE (MIF_PriceFrom.ValueData, 0)) AS Summ_out
                              , SUM (MovementItem.Amount * COALESCE (MIF_PriceTo.ValueData, 0))   AS Summ_in
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                              INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                         ON MovementBoolean_SUN.MovementId = Movement.Id
                                                        AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                        AND MovementBoolean_SUN.ValueData  = TRUE
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.Amount     > 0
                              LEFT JOIN MovementItemFloat AS MIF_PriceFrom
                                                          ON MIF_PriceFrom.MovementItemId = MovementItem.Id
                                                         AND MIF_PriceFrom.DescId         = zc_MIFloat_PriceFrom()
                              LEFT JOIN MovementItemFloat AS MIF_PriceTo
                                                          ON MIF_PriceTo.MovementItemId = MovementItem.Id
                                                         AND MIF_PriceTo.DescId         = zc_MIFloat_PriceTo()
                         WHERE Movement.OperDate BETWEEN inOperDate - INTERVAL '31 DAY' AND inOperDate - INTERVAL '1 DAY'
                           AND Movement.DescId   = zc_Movement_Send()
                           AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                         GROUP BY MovementLinkObject_From.ObjectId
                                , MovementLinkObject_To.ObjectId
                        )
         -- Результат-1
         INSERT INTO _tmpUnit_SUN_balance (UnitId, Summ_out, Summ_in, KoeffInSUN, KoeffOutSUN)
            SELECT _tmpUnit_SUN.UnitId
                  , COALESCE (tmpSumm_out.Summ_out, 0) AS Summ_out
                  , COALESCE (tmpSumm_in.Summ_in, 0)   AS Summ_in
                  , CASE WHEN tmpSumm_out.Summ_out > 0 AND tmpSumm_in.Summ_in > 0 THEN tmpSumm_in.Summ_in   / tmpSumm_out.Summ_out ELSE 0 END AS KoeffInSUN
                  , CASE WHEN tmpSumm_out.Summ_out > 0 AND tmpSumm_in.Summ_in > 0 THEN tmpSumm_out.Summ_out / tmpSumm_in.Summ_in   ELSE 0 END AS KoeffOutSUN
            FROM _tmpUnit_SUN
                 LEFT JOIN (SELECT tmpSUN.UnitId_from, SUM (tmpSUN.Summ_out) AS Summ_out FROM tmpSUN GROUP BY tmpSUN.UnitId_from
                           ) AS tmpSumm_out ON tmpSumm_out.UnitId_from = _tmpUnit_SUN.UnitId
                 LEFT JOIN (SELECT tmpSUN.UnitId_to, SUM (tmpSUN.Summ_in) AS Summ_in FROM tmpSUN GROUP BY tmpSUN.UnitId_to
                           ) AS tmpSumm_in ON tmpSumm_in.UnitId_to = _tmpUnit_SUN.UnitId
                ;

         -- баланс-2 накопительно по Аптекам - только по срокам
         WITH -- SUN - за 30 дней
          tmpSUN_all AS (SELECT MovementLinkObject_From.ObjectId AS UnitId_from
                              , MovementLinkObject_To.ObjectId   AS UnitId_to
                              , (MovementItem.Amount * COALESCE (MIF_PriceFrom.ValueData, 0)) AS Summ_out
                              , (MovementItem.Amount * COALESCE (MIF_PriceTo.ValueData, 0))   AS Summ_in
                              , MovementItem.MovementId
                              , MovementItem.Id AS MovementItemId
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                              INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                         ON MovementBoolean_SUN.MovementId = Movement.Id
                                                        AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                        AND MovementBoolean_SUN.ValueData  = TRUE
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE
                                                     AND MovementItem.Amount     > 0
                              LEFT JOIN MovementItemFloat AS MIF_PriceFrom
                                                          ON MIF_PriceFrom.MovementItemId = MovementItem.Id
                                                         AND MIF_PriceFrom.DescId         = zc_MIFloat_PriceFrom()
                              LEFT JOIN MovementItemFloat AS MIF_PriceTo
                                                          ON MIF_PriceTo.MovementItemId = MovementItem.Id
                                                         AND MIF_PriceTo.DescId         = zc_MIFloat_PriceTo()
                         WHERE Movement.OperDate BETWEEN vbDate_balance_partion AND inOperDate - INTERVAL '1 DAY'
                           AND Movement.DescId   = zc_Movement_Send()
                           AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                        )
            , tmpSUN_partion AS (SELECT DISTINCT tmpSUN_all.MovementItemId
                                 FROM tmpSUN_all
                                      INNER JOIN MovementItem ON MovementItem.MovementId = tmpSUN_all.MovementId
                                                             AND MovementItem.DescId     = zc_MI_Child()
                                                             AND MovementItem.ParentId   = tmpSUN_all.MovementItemId
                                                             AND MovementItem.isErased   = FALSE
                                                             AND MovementItem.Amount     > 0
                                )
            , tmpSUN AS (SELECT tmpSUN_all.UnitId_from
                              , tmpSUN_all.UnitId_to
                              , SUM (tmpSUN_all.Summ_out) AS Summ_out
                              , SUM (tmpSUN_all.Summ_in)  AS Summ_in
                         FROM tmpSUN_all
                              INNER JOIN tmpSUN_partion ON tmpSUN_partion.MovementItemId = tmpSUN_all.MovementItemId
                         GROUP BY tmpSUN_all.UnitId_from
                                , tmpSUN_all.UnitId_to
                        )
               , tmpData_all AS (SELECT _tmpUnit_SUN.UnitId
                                      , COALESCE (tmpSumm_out.Summ_out, 0) AS Summ_out
                                      , COALESCE (tmpSumm_in.Summ_in, 0)   AS Summ_in
                                        -- расчет макс. границы разрешенной суммы out = N * vbSumm_balance_partion
                                      , CASE WHEN tmpSumm_out.Summ_out > 0 THEN CEIL (tmpSumm_out.Summ_out / vbSumm_balance_partion) * vbSumm_balance_partion ELSE 1 * vbSumm_balance_partion END AS Summ_out_calc
                                        -- расчет макс. границы разрешенной суммы in  = N * vbSumm_balance_partion
                                      , CASE WHEN tmpSumm_in.Summ_in   > 0 THEN CEIL (tmpSumm_in.Summ_in   / vbSumm_balance_partion) * vbSumm_balance_partion ELSE 1 * vbSumm_balance_partion END AS Summ_in_calc
                                 FROM _tmpUnit_SUN
                                      LEFT JOIN (SELECT tmpSUN.UnitId_from, SUM (tmpSUN.Summ_out) AS Summ_out FROM tmpSUN GROUP BY tmpSUN.UnitId_from
                                                ) AS tmpSumm_out ON tmpSumm_out.UnitId_from = _tmpUnit_SUN.UnitId
                                      LEFT JOIN (SELECT tmpSUN.UnitId_to, SUM (tmpSUN.Summ_in) AS Summ_in FROM tmpSUN GROUP BY tmpSUN.UnitId_to
                                                ) AS tmpSumm_in ON tmpSumm_in.UnitId_to = _tmpUnit_SUN.UnitId
                                )
                     -- нашли к какой сумме будем приравнивать
                   , tmpData AS (SELECT tmpData_all.UnitId
                                      , tmpData_all.Summ_out
                                      , tmpData_all.Summ_in
                                      , CASE -- если равны, переходим на следующий уровень
                                             WHEN tmpData_all.Summ_out_calc = tmpData_all.Summ_in_calc
                                              AND tmpData_all.Summ_out_calc > 0
                                              AND tmpData_all.Summ_in_calc  > 0
                                                  THEN (1 + CEIL (tmpData_all.Summ_out / vbSumm_balance_partion)) * vbSumm_balance_partion
                                             -- если максимальная Summ_out_calc
                                             WHEN tmpData_all.Summ_out_calc >=  tmpData_all.Summ_in_calc
                                                  THEN tmpData_all.Summ_out_calc
                                             -- если максимальная Summ_in_calc
                                             WHEN tmpData_all.Summ_out_calc <=  tmpData_all.Summ_in_calc
                                                  THEN tmpData_all.Summ_in_calc
                                        END AS Summ_calc

                                      , (tmpData_all.Summ_out_calc - tmpData_all.Summ_in_calc)  / vbSumm_balance_partion AS koeff_out
                                      , (tmpData_all.Summ_in_calc  - tmpData_all.Summ_out_calc) / vbSumm_balance_partion AS koeff_in
                                 FROM tmpData_all
                                )
         -- Результат-2
         INSERT INTO _tmpUnit_SUN_balance_partion (UnitId, Summ_out, Summ_in, Summ_out_calc, Summ_in_calc)
            SELECT tmpData.UnitId
                 , tmpData.Summ_out
                 , tmpData.Summ_in
                   -- сумма разрешенного расхода
                 , CASE WHEN koeff_out <= 2 THEN tmpData.Summ_calc - tmpData.Summ_out ELSE 0 END AS Summ_out_calc
                   -- сумма разрешенного прихода
                 , CASE WHEN koeff_in <= 2  THEN tmpData.Summ_calc - tmpData.Summ_in  ELSE 0 END AS Summ_in_calc
            FROM tmpData
            WHERE 1=0
           ;

     END IF;


     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     -- CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     -- CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     --
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
                                 LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                                          AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                          AND MovementBoolean_SUN.ValueData  = TRUE
                                                          AND Movement.OperDate              >= inOperDate
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '30 DAY' AND Movement.OperDate < inOperDate + INTERVAL '30 DAY'
                           -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           -- AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                              AND MovementBoolean_SUN.MovementId IS NULL
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
                                 LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                                          AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                          AND MovementBoolean_SUN.ValueData  = TRUE
                                                          AND Movement.OperDate              >= inOperDate
                         -- WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '14 DAY' AND Movement.OperDate < inOperDate + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              AND MovementBoolean_Deferred.MovementId IS NULL
                              AND MovementBoolean_SUN.MovementId IS NULL
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

                                   LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                           ON Unit_PharmacyItem.ObjectId  = COALESCE (tmpPrice.UnitId,  tmpGoodsCategory.UnitId)
                                                          AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()

                              WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                 OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                                 OR COALESCE (tmpPrice.Price, 0) <> 0
                             )

     -- 1.1. Результат: все остатки, НТЗ => получаем кол-ва автозаказа: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains_all (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve, isCloseMCS)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             , CASE -- если НТЗ_МИН = 0 ИЛИ ост <= НТЗ_МИН
                    WHEN COALESCE (tmpObject_Price.MCSValue_min, 0) = 0 OR (COALESCE (tmpRemains.Amount, 0) <= COALESCE (tmpObject_Price.MCSValue_min, 0))
                         THEN CASE -- для такого НТЗ
                                   WHEN tmpObject_Price.MCSValue >= 0.1 AND tmpObject_Price.MCSValue < 10
                                   -- и 1 >= НТЗ - "остаток"
                                    AND 1 >= ROUND ((tmpObject_Price.MCSValue
                                                     -- МИНУС (остаток - "отложено" + "перемещ" + "приход" + "заявка")
                                                   - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                              THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                          ELSE 0
                                                     END
                                                    )
                                                    -- делим на кратность
                                                  / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                                   ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                        THEN -- округляем ВВЕРХ
                                             CEIL ((tmpObject_Price.MCSValue
                                                    -- МИНУС (остаток - "отложено" + "перемещ" + "приход" + "заявка")
                                                  - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                             THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                         ELSE 0
                                                    END
                                                   )
                                                   -- делим на кратность
                                                 / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                                  ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)

                                   -- для такого НТЗ
                                   WHEN tmpObject_Price.MCSValue >= 10
                                   -- и 1 >= НТЗ - "остаток"
                                    AND 1 >= CEIL ((tmpObject_Price.MCSValue
                                                    -- МИНУС (остаток - "отложено" + "перемещ" + "приход" + "заявка")
                                                  - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                             THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                         ELSE 0
                                                    END
                                                   )
                                                   -- делим на кратность
                                                 / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                                  ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                        THEN -- округляем
                                             ROUND ((tmpObject_Price.MCSValue
                                                     -- МИНУС (остаток - "отложено" + "перемещ" + "приход" + "заявка")
                                                   - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                              THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                          ELSE 0
                                                     END
                                                    )
                                                    -- делим на кратность
                                                  / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                                   ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)

                                   ELSE -- округляем ВВНИЗ
                                        FLOOR ((tmpObject_Price.MCSValue
                                                -- МИНУС (остаток - "отложено" + "перемещ" + "приход" + "заявка")
                                              - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                         THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                     ELSE 0
                                                END
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
             , COALESCE (tmpObject_Price.isCloseMCS, FALSE)  AS isCloseMCS
        FROM tmpObject_Price
             -- Работают по СУН - только отправка
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_out
                                     ON OB_Unit_SUN_out.ObjectId  = tmpObject_Price.UnitId
                                    AND OB_Unit_SUN_out.DescId    = zc_ObjectBoolean_Unit_SUN_out()
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

             -- товары для Кратность
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId  = tmpObject_Price.GoodsId

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
             /* -- закоментила т.к. не используется WHERE закоменчено уже было
             LEFT JOIN ObjectLink AS OL_Goods_ConditionsKeep
                                  ON OL_Goods_ConditionsKeep.ObjectId = tmpObject_Price.GoodsId
                                 AND OL_Goods_ConditionsKeep.DescId   = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = OL_Goods_ConditionsKeep.ChildObjectId
             */
        WHERE OB_Unit_SUN_out.ObjectId IS NULL
          -- товары "закрыт код"
          AND (ObjectBoolean_Goods_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_CloseGd = FALSE)
          -- Исключения по техническим переучетам
          AND COALESCE (tmpGoods_TP_exception.GoodsId, 0) = 0

        /*WHERE (Object_ConditionsKeep.ValueData NOT ILIKE '%холод%'
           AND Object_ConditionsKeep.ValueData NOT ILIKE '%прохладное%'
              )
           OR Object_ConditionsKeep.ValueData IS NULL
        */

        -- !!!только с таким НТЗ!!!
        -- WHERE tmpObject_Price.MCSValue >= 0.5
        -- !!!отключил, взяли все!!!
        /*WHERE CASE -- если НТЗ_МИН = 0 ИЛИ ост <= НТЗ_МИН
                   WHEN COALESCE (tmpObject_Price.MCSValue_min, 0) = 0 OR (COALESCE (tmpRemains.Amount, 0) <= COALESCE (tmpObject_Price.MCSValue_min, 0))
                        THEN CASE -- для такого НТЗ
                                  WHEN tmpObject_Price.MCSValue >= 0.1 AND tmpObject_Price.MCSValue < 10
                                  -- и 1 >= НТЗ - остаток - "отложено" - "перемещ" - "приход" - "заявка"
                                   AND 1 >= ROUND (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                       THEN -- округляем ВВЕРХ
                                            CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                  -- для такого НТЗ
                                  WHEN tmpObject_Price.MCSValue >= 10
                                  -- и 1 >= НТЗ - остаток - "отложено" - "перемещ" - "приход" - "заявка"
                                   AND 1 >= CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                       THEN -- округляем
                                            ROUND  (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                  ELSE -- округляем ВВНИЗ
                                       FLOOR (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                             END
                   ELSE 0
              END > 0*/
       ;

     -- 1.1. Результат: все остатки, НТЗ => получаем кол-ва автозаказа: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT _tmpRemains_all.UnitId, _tmpRemains_all.GoodsId, _tmpRemains_all.Price, _tmpRemains_all.MCS, _tmpRemains_all.AmountResult, _tmpRemains_all.AmountRemains, _tmpRemains_all.AmountIncome, _tmpRemains_all.AmountSend_in, _tmpRemains_all.AmountSend_out, _tmpRemains_all.AmountOrderExternal, _tmpRemains_all.AmountReserve
        FROM _tmpRemains_all
             -- баланс по Аптекам получателям - если не соответствует, соотв приход блокируется
             LEFT JOIN _tmpUnit_SUN_balance ON _tmpUnit_SUN_balance.UnitId = _tmpRemains_all.UnitId
             LEFT JOIN _tmpUnit_SUN         ON _tmpUnit_SUN.UnitId         = _tmpRemains_all.UnitId

             -- если товар среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_all.GoodsId

         WHERE (-- !!!только с таким НТЗ!!!
                _tmpRemains_all.MCS >= 1.0
                -- !!!Добавили парные!!!
              OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
               )
           AND (_tmpUnit_SUN.KoeffInSUN = 0 OR _tmpUnit_SUN_balance.KoeffInSUN < _tmpUnit_SUN.KoeffInSUN)
       ;


     -- 2. вся статистика продаж - 1 МЕСЯЦ
     -- CREATE TEMP TABLE _tmpSale (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpSale (UnitId, GoodsId, Amount, Summ)
      WITH
      tmp AS (SELECT MIContainer.*
              FROM MovementItemContainer AS MIContainer
              WHERE MIContainer.DescId         = zc_MIContainer_Count()
                AND MIContainer.MovementDescId = zc_Movement_Check()
                AND MIContainer.OperDate BETWEEN inOperDate + INTERVAL '1 DAY' - INTERVAL '1 MONTH' AND inOperDate + INTERVAL '1 DAY'
                AND MIContainer.WhereObjectId_analyzer IN (SELECT DISTINCT _tmpRemains.UnitId FROM _tmpRemains WHERE _tmpRemains.AmountResult <= 0)
                AND MIContainer.ObjectId_analyzer IN (SELECT DISTINCT _tmpRemains.GoodsId FROM _tmpRemains WHERE _tmpRemains.AmountResult <= 0)
              AND (COALESCE (MIContainer.Amount, 0)) <> 0
              )

        SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
             , MIContainer.ObjectId_analyzer               AS GoodsId
             , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
             , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS Summ
        FROM tmp AS MIContainer
             INNER JOIN _tmpRemains ON _tmpRemains.UnitId       = MIContainer.WhereObjectId_analyzer
                                   AND _tmpRemains.GoodsId      = MIContainer.ObjectId_analyzer
                                   AND _tmpRemains.AmountResult <= 0 -- !!!нужна только когда нет Автозаказа!!!
        GROUP BY MIContainer.ObjectId_analyzer
               , MIContainer.WhereObjectId_analyzer
        HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
       ;


     -- значения для разделения по срокам
     SELECT Date_6, Date_3, Date_1, Date_0
     INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
     FROM lpSelect_PartionDateKind_SetDate ();



     -- 3.1. все остатки ОТПРАВИТЕЛЯ, СРОК + ...
     INSERT INTO _tmpRemains_Partion_all (ContainerDescId, UnitId, ContainerId_Parent, ContainerId, GoodsId, Amount, PartionDateKindId, ExpirationDate, Amount_sun, Amount_notSold)
        WITH -- список для NotSold
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
                                   -- отключена модель "без продаж" для СУН-1
                                   LEFT JOIN ObjectBoolean AS OB_SUN_NotSold
                                                           ON OB_SUN_NotSold.ObjectId  = Container.WhereObjectId
                                                          AND OB_SUN_NotSold.DescId    = zc_ObjectBoolean_Unit_SUN_NotSold()
                                                          AND OB_SUN_NotSold.ValueData = TRUE
                              -- !!!
                              WHERE OB_SUN_NotSold.ObjectId IS NULL
                             )
             -- так можно определить NotSold - без продаж 100дн.
           , tmpNotSold_all_all AS (SELECT tmpContainer.ContainerDescId
                                         , tmpContainer.ContainerId
                                         , tmpContainer.UnitID
                                         , tmpContainer.GoodsID
                                         , tmpContainer.Amount
                                    FROM tmpContainer
                                         LEFT JOIN MovementItemContainer AS MIContainer
                                                                         ON MIContainer.WhereObjectId_Analyzer = tmpContainer.UnitId
                                                                        AND MIContainer.ObjectId_Analyzer      = tmpContainer.GoodsID
                                                                        AND MIContainer.DescId                 = zc_MIContainer_Count()
                                                                        AND MIContainer.OperDate               >= inOperDate - INTERVAL '100 DAY'
                                                                        AND MIContainer.Amount                 <> 0
                                                                        AND MIContainer.MovementDescId         = zc_Movement_Check()
                                    WHERE MIContainer.ObjectId_Analyzer IS NULL
                                   )

             -- NotSold - без продаж 100дн. + парные
           , tmpNotSold_all AS (-- NotSold
                                SELECT tmpNotSold_all_all.ContainerDescId
                                     , tmpNotSold_all_all.ContainerId
                                     , tmpNotSold_all_all.UnitID
                                     , tmpNotSold_all_all.GoodsID
                                     , tmpNotSold_all_all.Amount
                                FROM tmpNotSold_all_all
                               UNION ALL
                                -- !!!Добавили парные!!!
                                SELECT tmpContainer.ContainerDescId
                                     , tmpContainer.ContainerId
                                     , tmpContainer.UnitID
                                     , tmpContainer.GoodsID
                                     , tmpContainer.Amount
                                FROM (-- только для NotSold - его пара
                                      SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun, tmpNotSold_all_all.UnitID
                                      FROM tmpNotSold_all_all
                                           JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = tmpNotSold_all_all.GoodsId
                                     ) AS _tmpGoods_SUN_PairSun_find
                                     INNER JOIN tmpContainer ON tmpContainer.GoodsId = _tmpGoods_SUN_PairSun_find.GoodsId_PairSun
                                                            AND tmpContainer.UnitID  = _tmpGoods_SUN_PairSun_find.UnitID
                                     -- если товара нет в NotSold
                                     LEFT JOIN tmpNotSold_all_all ON tmpNotSold_all_all.GoodsId = _tmpGoods_SUN_PairSun_find.GoodsId_PairSun
                                                                 AND tmpNotSold_all_all.UnitID  = _tmpGoods_SUN_PairSun_find.UnitID
                                --!!!
                                WHERE tmpNotSold_all_all.GoodsId IS NULL
                               )
     -- для NotSold - находим "плохой" срок
   , tmpNotSold_PartionDate AS (SELECT tmpNotSold.ContainerId
                                     , tmpNotSold.UnitID
                                     , tmpNotSold.GoodsID
                                       -- Остаток "плохой" срок
                                     , SUM (Container.Amount) AS Amount
                                FROM tmpNotSold_all AS tmpNotSold
                                     INNER JOIN Container ON Container.ParentId = tmpNotSold.ContainerId
                                                         AND Container.DescId   = zc_Container_CountPartionDate()
                                                         AND Container.Amount   > 0
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                          ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                         AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                WHERE -- !!!оставили только эту категорию
                                      ObjectDate_PartionGoods_Value.ValueData <= vbDate_3
                                      -- !!!оставили только эту категорию
                                GROUP BY tmpNotSold.ContainerId
                                       , tmpNotSold.UnitID
                                       , tmpNotSold.GoodsID
                               )
            -- для NotSold - список "плохой" срок
          , tmpNotSold_list AS (SELECT DISTINCT
                                       tmpNotSold_all.UnitID
                                     , tmpNotSold_all.GoodsID
                                FROM tmpNotSold_all
                               )
                  -- Income - за X дней - если приходило, 100дней без продаж уходить уже не может
                , tmpIncome AS (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                                     , MovementItem.ObjectId            AS GoodsId
                                FROM MovementDate AS MovementDate_Branch
                                     INNER JOIN Movement ON Movement.Id       = MovementDate_Branch.MovementId
                                                        AND Movement.DescId   = zc_Movement_Income()
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                     -- отсечем ненужные подразделения
                                     INNER JOIN (SELECT DISTINCT tmpNotSold_list.UnitId FROM tmpNotSold_list) AS tmp ON tmp.UnitId  = MovementLinkObject_To.ObjectId

                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                                            AND MovementItem.Amount     > 0
                                     -- !!!только для таких!!!
                                     INNER JOIN tmpNotSold_list ON tmpNotSold_list.UnitId  = MovementLinkObject_To.ObjectId
                                                               AND tmpNotSold_list.GoodsId = MovementItem.ObjectId

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
               , tmpNotSold AS (SELECT tmpNotSold_all.ContainerDescId
                                     , tmpNotSold_all.ContainerId
                                     , tmpNotSold_all.UnitID
                                     , tmpNotSold_all.GoodsID
                                       -- Остаток "хороших" сроков
                                     , tmpNotSold_all.Amount - COALESCE (tmpNotSold_PartionDate.Amount, 0) AS Amount
                                FROM tmpNotSold_all
                                     -- "плохой" срок
                                     LEFT JOIN tmpNotSold_PartionDate ON tmpNotSold_PartionDate.ContainerId = tmpNotSold_all.ContainerId
                                     -- Income - за X дней - если приходило, 100дней без продаж уходить уже не может
                                     LEFT JOIN tmpIncome ON tmpIncome.UnitId_to = tmpNotSold_all.UnitID
                                                        AND tmpIncome.GoodsID   = tmpNotSold_all.GoodsID
                                     -- отгружать товар по СУН, если у него остаток больше чем N
                                     LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitID = tmpNotSold_all.UnitID

                                     -- если товар среди парных
                                     LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                                               ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = tmpNotSold_all.GoodsID

                                WHERE tmpNotSold_all.Amount - COALESCE (tmpNotSold_PartionDate.Amount, 0) > 0
                                  -- !!!
                                  AND tmpIncome.GoodsID IS NULL

                                  AND (-- остаток больше чем N
                                       COALESCE (_tmpUnit_SUN.Limit_N, 0) < tmpNotSold_all.Amount
                                       -- или это парный товар
                                    OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
                                      )
                               )

             -- для SUN-1 - Сроки - zc_Movement_Send за X дней - если приходило, уходить уже не может
           , tmpSUN_Send AS (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                                  , MovementItem.ObjectId            AS GoodsId
                             FROM Movement
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                  -- !!!только для таких Аптек!!!
                                  -- INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
                                  --
                                  INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                             ON MovementBoolean_SUN.MovementId = Movement.Id
                                                            AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                            AND MovementBoolean_SUN.ValueData  = TRUE
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                                                         AND MovementItem.Amount     > 0

                                  LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId

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
           -- Остатки по SUN-1 - Сроки
         , tmpRes_SUN_1 AS (SELECT Container.DescId                                           AS ContainerDescId
                                 , CLO_Unit.ObjectId                                          AS UnitId
                                 , Container.ParentId                                         AS ContainerId_Parent
                                 , Container.Id                                               AS ContainerId
                                 , Container.ObjectId                                         AS GoodsId
                                 , Container.Amount                                           AS Amount
                            FROM Container
                                 INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                ON CLO_Unit.ContainerId = Container.Id
                                                               AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                 -- !!!только для таких Аптек!!!
                                 INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = CLO_Unit.ObjectId
                                 -- !!!SUN - за X дней - если приходило, уходить уже не может!!!
                                 LEFT JOIN tmpSUN_Send ON tmpSUN_Send.UnitId_to = CLO_Unit.ObjectId
                                                      AND tmpSUN_Send.GoodsId   = Container.ObjectId
                                 -- !!!SUN всех - за X дней - если приходило, уходить уже не может!!!
                                 LEFT JOIN tmpSUN_SendAll ON tmpSUN_SendAll.UnitId_to = CLO_Unit.ObjectId
                                                         AND tmpSUN_SendAll.GoodsId   = Container.ObjectId

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.Amount <> 0
                              -- !!!
                              AND tmpSUN_Send.GoodsId IS NULL
                              AND tmpSUN_SendAll.GoodsId IS NULL
                           )
           , tmpCLO_PartionGoods AS (SELECT *
                                     FROM ContainerLinkObject
                                     WHERE ContainerLinkObject.ContainerId IN (SELECT DISTINCT tmpRes_SUN_1.ContainerId FROM tmpRes_SUN_1)
                                       AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                    )
      , tmpOD_PartionGoods_Value AS (SELECT *
                                     FROM ObjectDate
                                     WHERE ObjectDate.ObjectId IN  (SELECT DISTINCT tmpCLO_PartionGoods.ObjectId FROM tmpCLO_PartionGoods)
                                       AND ObjectDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                       -- !!!оставили только эту категорию
                                       AND ObjectDate.ValueData >  vbDate_3
                                       AND ObjectDate.ValueData <= vbDate_6
                                       -- !!!оставили только эту категорию
                                    )
         -- SUN-1 - Cроки
       , tmpRes_SUN_all AS (SELECT Container.ContainerDescId
                                 , Container.UnitId
                                 , Container.ContainerId_Parent
                                 , Container.ContainerId
                                 , Container.GoodsId
                                 , Container.Amount
                                 , CASE WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_0
                                             THEN zc_Enum_PartionDateKind_0()
                                        WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_0 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_1
                                             THEN zc_Enum_PartionDateKind_1()
                                        WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_1 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_3
                                             THEN zc_Enum_PartionDateKind_3()
                                        WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_3 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_6
                                             THEN zc_Enum_PartionDateKind_6()
                                        ELSE 0
                                   END                                                              AS PartionDateKindId
                                 , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) AS ExpirationDate
                            FROM tmpRes_SUN_1 AS Container
                                 LEFT JOIN tmpCLO_PartionGoods AS CLO_PartionGoods
                                                               ON CLO_PartionGoods.ContainerId = Container.ContainerId
                                 INNER JOIN tmpOD_PartionGoods_Value AS ObjectDate_PartionGoods_Value
                                                                     ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                 -- если товар среди парных
                                 LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                                           ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = Container.GoodsId
                            -- !!!если это парный товар, здесь его уберем, потом возьмем "весь" остаток
                            WHERE _tmpGoods_SUN_PairSun_find.GoodsId_PairSun IS NULL
                           )
             -- SUN-1 - Cроки + парные
           , tmpRes_SUN AS (-- SUN-1
                            SELECT tmpRes_SUN_all.ContainerDescId
                                 , tmpRes_SUN_all.UnitId
                                 , tmpRes_SUN_all.ContainerId_Parent
                                 , tmpRes_SUN_all.ContainerId
                                 , tmpRes_SUN_all.GoodsId
                                 , tmpRes_SUN_all.Amount
                                 , tmpRes_SUN_all.PartionDateKindId
                                 , tmpRes_SUN_all.ExpirationDate
                            FROM tmpRes_SUN_all
                           UNION ALL
                            -- !!!Добавили парные!!!
                            SELECT tmpContainer.ContainerDescId
                                 , tmpContainer.UnitID
                                 , tmpContainer.ContainerId AS ContainerId_Parent
                                 , tmpContainer.ContainerId
                                 , tmpContainer.GoodsID
                                 , tmpContainer.Amount
                                 , 0                        AS PartionDateKindId
                                 , zc_DateEnd()             AS ExpirationDate
                            FROM (-- только для SUN-1 его пара
                                  SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun, tmpRes_SUN_all.UnitID
                                  FROM tmpRes_SUN_all
                                       JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = tmpRes_SUN_all.GoodsId
                                 ) AS _tmpGoods_SUN_PairSun_find
                                 INNER JOIN tmpContainer ON tmpContainer.GoodsId = _tmpGoods_SUN_PairSun_find.GoodsId_PairSun
                                                        AND tmpContainer.UnitID  = _tmpGoods_SUN_PairSun_find.UnitID
                                 -- если товара нет в SUN-1
                                 LEFT JOIN tmpRes_SUN_all ON tmpRes_SUN_all.GoodsId = _tmpGoods_SUN_PairSun_find.GoodsId_PairSun
                                                         AND tmpRes_SUN_all.UnitID  = _tmpGoods_SUN_PairSun_find.UnitID
                            --!!!
                            WHERE tmpRes_SUN_all.GoodsId IS NULL
                           )
         -- для SUN-1 - Cроки - находим list
       , tmpIncomeSUN_list AS (SELECT DISTINCT
                                       tmpRes_SUN.UnitID
                                     , tmpRes_SUN.GoodsID
                                FROM tmpRes_SUN
                               )
               -- IncomeSUN - за X дней - если приходило, SUN уходить уже не может
             , tmpIncomeSUN AS (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                                     , MovementItem.ObjectId            AS GoodsId
                                FROM MovementDate AS MovementDate_Branch
                                     INNER JOIN Movement ON Movement.Id       = MovementDate_Branch.MovementId
                                                        AND Movement.DescId   = zc_Movement_Income()
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                     -- отсечем ненужные подразделения
                                     INNER JOIN (SELECT DISTINCT tmpIncomeSUN_list.UnitId FROM tmpIncomeSUN_list) AS tmp ON tmp.UnitId  = MovementLinkObject_To.ObjectId

                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                                            AND MovementItem.Amount     > 0
                                     -- !!!только для таких!!!
                                     INNER JOIN tmpIncomeSUN_list ON tmpIncomeSUN_list.UnitId  = MovementLinkObject_To.ObjectId
                                                                 AND tmpIncomeSUN_list.GoodsId = MovementItem.ObjectId

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
        -- Результат - SUN-1 - Cроки
        SELECT tmpRes_SUN.ContainerDescId
             , tmpRes_SUN.UnitId
             , tmpRes_SUN.ContainerId_Parent
             , tmpRes_SUN.ContainerId
             , tmpRes_SUN.GoodsId
             , tmpRes_SUN.Amount
             , tmpRes_SUN.PartionDateKindId
             , tmpRes_SUN.ExpirationDate
             , tmpRes_SUN.Amount AS Amount_sun
             , 0                 AS Amount_notSold
        FROM tmpRes_SUN
             -- если он есть в tmpNotSold, тогда распределяем только ВСЕ кол-во из tmpNotSold
             LEFT JOIN tmpNotSold ON tmpNotSold.UnitId = tmpRes_SUN.UnitId
                                 AND tmpNotSold.GoodsId = tmpRes_SUN.GoodsId
             -- IncomeSUN - за X дней - если приходило, SUN уходить уже не может
             LEFT JOIN tmpIncomeSUN ON tmpIncomeSUN.UnitId_to = tmpRes_SUN.UnitId
                                   AND tmpIncomeSUN.GoodsId   = tmpRes_SUN.GoodsId

             -- Исключения по техническим переучетам
             LEFT JOIN _tmpGoods_TP_exception AS tmpGoods_TP_exception
                                              ON tmpGoods_TP_exception.UnitId  = tmpRes_SUN.UnitId
                                             AND tmpGoods_TP_exception.GoodsId = tmpRes_SUN.GoodsId

             -- баланс по Аптекам отправителям - если не соответствует, соотв расход блокируется
             LEFT JOIN _tmpUnit_SUN_balance ON _tmpUnit_SUN_balance.UnitId = tmpRes_SUN.UnitId
             LEFT JOIN _tmpUnit_SUN         ON _tmpUnit_SUN.UnitId         = tmpRes_SUN.UnitId

             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_in
                                     ON OB_Unit_SUN_in.ObjectId  = tmpRes_SUN.UnitId
                                    AND OB_Unit_SUN_in.DescId    = zc_ObjectBoolean_Unit_SUN_in()
                                    AND OB_Unit_SUN_in.ValueData = TRUE

        WHERE -- !!!
              tmpNotSold.GoodsId IS NULL
              -- !!!
          AND tmpIncomeSUN.GoodsId IS NULL
              -- !!!
          AND (_tmpUnit_SUN.KoeffOutSUN = 0 OR _tmpUnit_SUN_balance.KoeffOutSUN < _tmpUnit_SUN.KoeffOutSUN)
          AND OB_Unit_SUN_in.ObjectId IS NULL
          AND COALESCE (tmpGoods_TP_exception.GoodsId, 0) = 0

       UNION ALL

        -- Результат - NotSold - без продаж 100дн.
        SELECT tmpNotSold.ContainerDescId
             , tmpNotSold.UnitId
             , tmpNotSold.ContainerId AS ContainerId_Parent
             , tmpNotSold.ContainerId
             , tmpNotSold.GoodsId
             , tmpNotSold.Amount
             , 0                 AS PartionDateKindId
             , zc_DateEnd()      AS ExpirationDate
             , 0                 AS Amount_sun
             , tmpNotSold.Amount AS Amount_notSold
        FROM tmpNotSold
             -- !!!SUN - за 30 дней - если приходило, уходить уже не может!!!
             LEFT JOIN tmpSUN_Send ON tmpSUN_Send.UnitId_to = tmpNotSold.UnitId
                                  AND tmpSUN_Send.GoodsId   = tmpNotSold.GoodsId
             -- !!!SUN всех - за 30 дней - если приходило, уходить уже не может!!!
             LEFT JOIN tmpSUN_SendAll ON tmpSUN_SendAll.UnitId_to = tmpNotSold.UnitId
                                     AND tmpSUN_SendAll.GoodsId   = tmpNotSold.GoodsId

             -- Исключения по техническим переучетам
             LEFT JOIN _tmpGoods_TP_exception AS tmpGoods_TP_exception
                                              ON tmpGoods_TP_exception.UnitId  = tmpNotSold.UnitId
                                             AND tmpGoods_TP_exception.GoodsId = tmpNotSold.GoodsId

             -- баланс по Аптекам отправителям - если не соответствует, соотв расход блокируется
             LEFT JOIN _tmpUnit_SUN_balance ON _tmpUnit_SUN_balance.UnitId = tmpNotSold.UnitId
             LEFT JOIN _tmpUnit_SUN         ON _tmpUnit_SUN.UnitId         = tmpNotSold.UnitId

             -- Работают по СУН - только прием
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_in
                                     ON OB_Unit_SUN_in.ObjectId  = tmpNotSold.UnitId
                                    AND OB_Unit_SUN_in.DescId    = zc_ObjectBoolean_Unit_SUN_in()
                                    AND OB_Unit_SUN_in.ValueData = TRUE
             -- если он есть в сроковых, тогда распределяем только сроковое кол-во
          -- LEFT JOIN tmpRes_SUN ON tmpRes_SUN.UnitId  = tmpNotSold.UnitId
          --                     AND tmpRes_SUN.GoodsId = tmpNotSold.GoodsId
        WHERE -- !!!
              tmpSUN_Send.GoodsId IS NULL
         AND  tmpSUN_SendAll.GoodsId IS NULL
              -- !!!
         AND (_tmpUnit_SUN.KoeffOutSUN = 0 OR _tmpUnit_SUN_balance.KoeffOutSUN < _tmpUnit_SUN.KoeffOutSUN)
             -- !!!
         AND OB_Unit_SUN_in.ObjectId IS NULL
         AND COALESCE (tmpGoods_TP_exception.GoodsId, 0) = 0
       -- AND tmpRes_SUN.GoodsId IS NULL
       ;


     -- 3.2. остатки у ОТПРАВИТЕЛЯ, SUN-1 - для распределения
     WITH tmpRemains AS (SELECT _tmpRemains_Partion_all.ContainerDescId
                              , _tmpRemains_Partion_all.UnitId
                              , _tmpRemains_Partion_all.ContainerId_Parent
                              , _tmpRemains_Partion_all.GoodsId
                              , SUM (_tmpRemains_Partion_all.Amount) AS Amount
                              , _tmpRemains_Partion_all.PartionDateKindId
                              , _tmpRemains_Partion_all.ExpirationDate
                              , SUM (_tmpRemains_Partion_all.Amount_sun)     AS Amount_sun
                              , SUM (_tmpRemains_Partion_all.Amount_notSold) AS Amount_notSold
                         FROM _tmpRemains_Partion_all
                         GROUP BY _tmpRemains_Partion_all.ContainerDescId
                                , _tmpRemains_Partion_all.UnitId
                                , _tmpRemains_Partion_all.ContainerId_Parent
                                , _tmpRemains_Partion_all.GoodsId
                                , _tmpRemains_Partion_all.PartionDateKindId
                                , _tmpRemains_Partion_all.ExpirationDate
                        )
            -- для SUN-1 нашли ContainerId_Parent - реальные остатки (для проверки)
          , tmpRemains_gr AS (SELECT DISTINCT tmpRemains.UnitId, tmpRemains.GoodsId, tmpRemains.ContainerId_Parent FROM tmpRemains
                             )
            -- получили реальные остатки по партиям Сроковых (для проверки)
          , tmpContainer_real AS (SELECT Container.Id
                                       , Container.Amount
                                  FROM Container
                                  WHERE Container.Id IN (SELECT DISTINCT tmpRemains_gr.ContainerId_Parent FROM tmpRemains_gr)
                                  AND Container.Amount <> 0
                                  )
          , tmpRemains_real AS (SELECT tmpRemains_gr.UnitId, tmpRemains_gr.GoodsId, SUM (Container.Amount) AS Amount
                                FROM tmpRemains_gr
                                     JOIN tmpContainer_real AS Container ON Container.Id = tmpRemains_gr.ContainerId_Parent
                                GROUP BY tmpRemains_gr.UnitId, tmpRemains_gr.GoodsId
                               )
              -- Goods_sum
          , tmpGoods_sum AS (SELECT tmpRemains.ContainerDescId, tmpRemains.UnitId, tmpRemains.GoodsId
                                  , SUM (tmpRemains.Amount)         AS Amount
                                  , SUM (tmpRemains.Amount_sun)     AS Amount_sun
                                  , SUM (tmpRemains.Amount_notSold) AS Amount_notSold
                             FROM tmpRemains
                             GROUP BY tmpRemains.ContainerDescId, tmpRemains.UnitId, tmpRemains.GoodsId
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
           -- MCS + Price
         , tmpMCS_all AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                               , OL_Price_Goods.ChildObjectId      AS GoodsId
                               , Price_Value.ValueData             AS Price
                               , MCS_Value.ValueData               AS MCSValue
                               , CASE WHEN Price_MCSValueMin.ValueData IS NOT NULL
                                      THEN CASE WHEN COALESCE (Price_MCSValueMin.ValueData, 0) < COALESCE (MCS_Value.ValueData, 0) THEN COALESCE (Price_MCSValueMin.ValueData, 0) ELSE MCS_Value.ValueData END
                                      ELSE 0
                                 END AS MCSValue_min
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
                               LEFT JOIN ObjectFloat AS Price_MCSValueMin
                                                     ON Price_MCSValueMin.ObjectId = OL_Price_Unit.ObjectId
                                                    AND Price_MCSValueMin.DescId = zc_ObjectFloat_Price_MCSValueMin()
                               -- !!!только для таких!!!
                               INNER JOIN tmpGoods_sum ON tmpGoods_sum.UnitId  = OL_Price_Unit.ChildObjectId
                                                      AND tmpGoods_sum.GoodsId = OL_Price_Goods.ChildObjectId
                               -- !!!
                               LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_Price_Unit.ChildObjectId

                          WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                            -- товары "убит код"
                            AND (MCS_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_ClosePL = FALSE)
                         )
               -- MCS + Price
             , tmpMCS AS (SELECT COALESCE (tmpMCS_all.UnitId,  tmpGoodsCategory.UnitId)  AS UnitId
                               , COALESCE (tmpMCS_all.GoodsId, tmpGoodsCategory.GoodsId) AS GoodsId
                               , COALESCE (tmpMCS_all.Price, 0)                :: TFloat AS Price
                               , CASE WHEN COALESCE (tmpGoodsCategory.Value, 0.0) <= COALESCE (tmpMCS_all.MCSValue, 0.0)
                                      THEN COALESCE (tmpMCS_all.MCSValue, 0.0)
                                      ELSE tmpGoodsCategory.Value
                                 END                                         :: TFloat AS MCSValue
                               , COALESCE (tmpMCS_all.MCSValue_min, 0.0)     :: TFloat AS MCSValue_min
                          FROM tmpMCS_all
                               FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpMCS_all.GoodsId
                                                         AND tmpGoodsCategory.UnitId  = tmpMCS_all.UnitId
                          WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                             OR COALESCE (tmpMCS_all.MCSValue, 0) <> 0
                             OR COALESCE (tmpMCS_all.Price, 0)    <> 0
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
                              WHERE OB_Goods_NOT.DescId   = zc_ObjectBoolean_Goods_NOT()
                                AND OB_Goods_NOT.ValueData = TRUE
                             )
       -- Результат: все остатки у ОТПРАВИТЕЛЯ - SUN-1
       INSERT INTO _tmpRemains_Partion (ContainerDescId, UnitId, GoodsId, MCSValue, Amount_sale, Amount, Amount_save, Amount_real, Amount_sun, Amount_notSold)
          SELECT tmp.ContainerDescId
               , tmp.UnitId
               , tmp.GoodsId
               , COALESCE (tmpMCS.MCSValue, 0)     AS MCSValue
               , COALESCE (_tmpSale.Amount, 0)     AS Amount_sale

                 -- уменьшаем сроковые, если были продажи но в Автозаказ не попал
               , FLOOR ((CASE -- отдаем ВСЕ - это парный
                              WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 THEN tmp.Amount
                              -- уменьшаем сроковые, если есть MCSValue
                              WHEN tmpMCS.MCSValue > 0 AND tmp.Amount > 0
                                   THEN tmp.Amount - COALESCE (tmpMCS.MCSValue, 0)
                              -- уменьшаем сроковые, если были продажи но в Автозаказ не попал
                              WHEN _tmpSale.Amount > 0 AND tmp.Amount > 0 THEN tmp.Amount - COALESCE (_tmpSale.Amount, 0)
                              ELSE tmp.Amount
                         END
                         -- уменьшаем - отложенные Чеки + не проведенные с CommentError
                       - COALESCE (_tmpRemains_all.AmountReserve, 0)
                         -- уменьшаем - Перемещение - расход (ожидается)
                       - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                          -- делим на кратность
                        ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                       ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                 AS Amount

                 -- остаток срок без корректировки
               , tmp.Amount             AS Amount_save
                 --
               , tmpRemains_real.Amount AS Amount_real
                 --
               , FLOOR ((CASE -- отдаем ВСЕ - это парный
                              WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 THEN tmp.Amount_sun
                              -- уменьшаем сроковые, если есть MCSValue
                              WHEN tmpMCS.MCSValue > 0 AND tmp.Amount_sun > 0
                                   THEN tmp.Amount_sun - COALESCE (tmpMCS.MCSValue, 0)
                              -- уменьшаем сроковые, если были продажи но в Автозаказ не попал
                              WHEN _tmpSale.Amount > 0 AND tmp.Amount_sun > 0 THEN tmp.Amount_sun - COALESCE (_tmpSale.Amount, 0)
                              ELSE tmp.Amount_sun
                         END
                         -- уменьшаем - отложенные Чеки + не проведенные с CommentError
                       - COALESCE (_tmpRemains_all.AmountReserve, 0)
                         -- уменьшаем - Перемещение - расход (ожидается)
                       - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                          -- делим на кратность
                        ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                       ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                 AS Amount_sun
                 --
               , FLOOR ((CASE -- отдаем ВСЕ - это парный
                              WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 THEN tmp.Amount_notSold
                              -- уменьшаем NotSold, если есть MCSValue
                              WHEN tmpMCS.MCSValue > 0 AND tmp.Amount_notSold > 0
                                   THEN tmp.Amount_notSold - COALESCE(tmpMCS.MCSValue, 0)
                              -- уменьшаем NotSold, если были продажи но в Автозаказ не попал
                              WHEN _tmpSale.Amount > 0 AND tmp.Amount_notSold > 0 THEN tmp.Amount_notSold - COALESCE (_tmpSale.Amount, 0)
                              ELSE tmp.Amount_notSold
                         END
                         -- уменьшаем - отложенные Чеки + не проведенные с CommentError
                       - COALESCE (_tmpRemains_all.AmountReserve, 0)
                         -- уменьшаем - Перемещение - расход (ожидается)
                       - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                          -- делим на кратность
                        ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                       ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                 AS Amount_notSold

          FROM tmpGoods_sum AS tmp
               -- автозаказ
               LEFT JOIN _tmpRemains_all ON _tmpRemains_all.UnitId  = tmp.UnitId
                                        AND _tmpRemains_all.GoodsId = tmp.GoodsId
               -- НТЗ
               LEFT JOIN tmpMCS ON tmpMCS.UnitId  = tmp.UnitId
                               AND tmpMCS.GoodsId = tmp.GoodsId
               LEFT JOIN tmpRemains_real ON tmpRemains_real.UnitId  = tmp.UnitId
                                        AND tmpRemains_real.GoodsId = tmp.GoodsId
               -- автозаказ
               LEFT JOIN _tmpRemains ON _tmpRemains.UnitId       = tmp.UnitId
                                    AND _tmpRemains.GoodsId      = tmp.GoodsId
                                    AND _tmpRemains.AmountResult > 0
               -- продажи
               LEFT JOIN _tmpSale ON _tmpSale.UnitId  = tmp.UnitId
                                 AND _tmpSale.GoodsId = tmp.GoodsId

               -- товары для Кратность
               LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId  = tmp.GoodsId

               -- а здесь, отбросили !!холод!!
               LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = tmp.GoodsId
               -- а здесь, отбросили !!НОТ!!
               LEFT JOIN tmpGoods_NOT ON tmpGoods_NOT.ObjectId = tmp.GoodsId

               -- если товар среди парных
               LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                         ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = tmp.GoodsId


          -- маленькое кол-во не распределяем
          WHERE FLOOR ((CASE -- отдаем ВСЕ - это парный
                             WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 THEN tmp.Amount
                             -- уменьшаем сроковые, если есть MCSValue
                             WHEN tmpMCS.MCSValue > 0 AND tmp.Amount > 0
                                  THEN tmp.Amount - COALESCE(tmpMCS.MCSValue, 0)
                             -- уменьшаем сроковые, если были продажи но в Автозаказ не попал
                             WHEN _tmpSale.Amount > 0 AND tmp.Amount > 0 THEN tmp.Amount - COALESCE (_tmpSale.Amount, 0)
                             ELSE tmp.Amount
                        END
                        -- уменьшаем - отложенные Чеки + не проведенные с CommentError
                      - COALESCE (_tmpRemains_all.AmountReserve, 0)
                        -- уменьшаем - Перемещение - расход (ожидается)
                      - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                         -- делим на кратность
                       ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                      ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                >= CASE WHEN tmpMCS.Price <= 100 THEN 1 ELSE 0 END

            -- !!!отбрасываем такие сроковые, по которым есть Автозаказ, т.е. распределять их пока не будем
            AND _tmpRemains.GoodsId IS NULL
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


     -- 4. Остатки по которым есть Автозаказ и срок
     INSERT INTO _tmpRemains_calc (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve
                                 , AmountSun_real, AmountSun_summ, AmountSun_summ_save, AmountSun_unit, AmountSun_unit_save)
        SELECT _tmpRemains.UnitId
             , _tmpRemains.GoodsId
               -- Цена
             , _tmpRemains.Price
               -- НТЗ
             , _tmpRemains.MCS
               -- Автозаказ
             , _tmpRemains.AmountResult
               --
             , _tmpRemains.AmountRemains
             , _tmpRemains.AmountIncome
             , _tmpRemains.AmountSend_in
             , _tmpRemains.AmountSend_out
             , _tmpRemains.AmountOrderExternal
             , _tmpRemains.AmountReserve
               -- итого сроковых по реальным остаткам, должно сходиться с AmountSun_summ
             , tmpRemains_Partion_sum.Amount_real       AS AmountSun_real
               -- итого сроковые которые будем распределять
             , tmpRemains_Partion_sum.Amount            AS AmountSun_summ
               -- итого сроковые
             , tmpRemains_Partion_sum.Amount_save       AS AmountSun_summ_save

               -- инф.=0, сроковые на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
             , COALESCE (_tmpRemains_Partion.Amount, 0)      AS AmountSun_unit
               -- инф.=0, сроковые на этой аптеке
             , COALESCE (_tmpRemains_Partion.Amount_save, 0) AS AmountSun_unit_save

        FROM -- у Получателя - AmountResult
             _tmpRemains
             -- итого у ОТПРАВИТЕЛЯ которые будем распределять - SUN-1
             INNER JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.Amount) AS Amount, SUM (_tmpRemains_Partion.Amount_save) AS Amount_save, SUM (_tmpRemains_Partion.Amount_real) AS Amount_real
                         FROM _tmpRemains_Partion
                         GROUP BY _tmpRemains_Partion.GoodsId
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains.GoodsId
             -- SUN-1 на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
             LEFT JOIN _tmpRemains_Partion ON _tmpRemains_Partion.UnitId  = _tmpRemains.UnitId
                                          AND _tmpRemains_Partion.GoodsId = _tmpRemains.GoodsId
             -- если товар среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains.GoodsId

        WHERE (_tmpRemains.AmountResult   > 0
            -- или товар среди парных
            --OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
              )
          AND _tmpRemains_Partion.UnitId IS NULL
            -- Парный потом добавим
          AND COALESCE (_tmpGoods_SUN_PairSun_find.GoodsId_PairSun, 0) = 0
        ;


     -- 5. из каких аптек остатки со сроками "максимально" закрывают АВТОЗАКАЗ
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
               -- если сроковых больше чем в Автозаказе
             , SUM (CASE WHEN _tmpRemains_Partion.Amount >= _tmpRemains_calc.AmountResult
                              -- тогда сроковых = автозаказ
                              THEN _tmpRemains_calc.AmountResult
                              -- иначе закрываем "частично" - т.е. сколько есть сроковых
                              ELSE FLOOR (_tmpRemains_Partion.Amount / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                    END
                  * _tmpRemains_calc.Price
                   )
        FROM -- Остатки по которым есть Автозаказ и срок
             _tmpRemains_calc
             -- все остатки, СРОК
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

        WHERE ((tmpConditionsKeep.ValueData NOT ILIKE '%холод%'
            AND tmpConditionsKeep.ValueData NOT ILIKE '%прохладное%'
               )
            OR tmpConditionsKeep.ValueData IS NULL
              )
          AND _tmpUnit_SunExclusion.UnitId_to IS NULL

        GROUP BY _tmpRemains_Partion.UnitId
               , _tmpRemains_calc.UnitId
       ;


     -- 6.1.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     -- CREATE TEMP TABLE _tmpResult_Partion (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     --
     -- курсор1 - все остатки, СРОК + остаток срок без корректировки
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
               END */
             , FLOOR(_tmpRemains_Partion.Amount - COALESCE(_tmpGoods_Layout.Layout, 0) - COALESCE(_tmpGoods_PromoUnit.Amount, 0)) AS Amount

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
             , _tmpRemains_Partion.Amount_sun
               --
             , COALESCE (_tmpGoods_SUN.KoeffSUN, 0)
               -- парный
             , _tmpGoods_SUN_PairSun.GoodsId_PairSun

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

        WHERE -- !!!Отключили парные!!!
              COALESCE ( _tmpGoods_SUN_PairSun_find.GoodsId_PairSun, 0) = 0

          AND FLOOR(_tmpRemains_Partion.Amount - COALESCE(_tmpGoods_Layout.Layout, 0) - COALESCE(_tmpGoods_PromoUnit.Amount, 0)) > 0

/*          CASE -- если у парного ост = 0, не отдаем
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND COALESCE (_tmpRemains_Partion_PairSun.Amount, 0) <= 0
                         THEN 0
                    -- если у парного ост < чем у "основного", меняем на меньшее
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND _tmpRemains_Partion_PairSun.Amount < _tmpRemains_Partion.Amount
                         THEN _tmpRemains_Partion_PairSun.Amount
                    -- инче берем ост "основного"
                    ELSE _tmpRemains_Partion.Amount
               END > 0*/
        ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curPartion INTO vbUnitId_from, vbGoodsId, vbAmount, vbAmount_save, vbAmount_sun, vbKoeffSUN, vbGoodsId_PairSun;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         -- курсор2. - Автозаказ МИНУС сколько уже распределили для vbGoodsId
         OPEN curResult FOR
            SELECT _tmpRemains_calc.UnitId AS UnitId_to, _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) AS AmountResult, _tmpRemains_calc.Price, COALESCE (_tmpRemains_calc_PairSun.Price, _tmpRemains_calc.Price) AS Price_PairSun
            FROM _tmpRemains_calc
                 -- сколько уже пришло после распределения-1
                 LEFT JOIN (SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId, SUM (_tmpResult_Partion.Amount) AS Amount FROM _tmpResult_Partion GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                           ) AS tmp ON tmp.UnitId_to = _tmpRemains_calc.UnitId
                                   AND tmp.GoodsId   = _tmpRemains_calc.GoodsId
                 -- начинаем с аптек, где приход может быть максимальным
                 INNER JOIN (SELECT _tmpSumm_limit.UnitId_to, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                             WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from
                               -- !!!больше лимита
                               AND _tmpSumm_limit.Summ >= vbSumm_limit
                             GROUP BY _tmpSumm_limit.UnitId_to
                            ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_to = _tmpRemains_calc.UnitId
                 -- найдем цену для пары
                 LEFT JOIN _tmpRemains_calc AS _tmpRemains_calc_PairSun
                                            ON _tmpRemains_calc_PairSun.UnitId  = _tmpRemains_calc.UnitId
                                           AND _tmpRemains_calc_PairSun.GoodsId = vbGoodsId_PairSun
            WHERE _tmpRemains_calc.GoodsId = vbGoodsId
              AND _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) > 0
              -- !!!только в те аптеки, которые удовлетворяют ЛИМИТУ!!!
              --!!! AND _tmpRemains_calc.UnitId IN (SELECT DISTINCT _tmpSumm_limit.UnitId_to FROM _tmpSumm_limit WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from AND _tmpSumm_limit.Summ >= vbSumm_limit)
            ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_calc.UnitId
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
                 -- разрешается ли РАСХОД
                 vbIsOut_partion:= vbAmount_sun = 0
                                OR
                                   -- сколько уже ушло
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from), 0)
                                 + vbAmount * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_out_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from)
                                 ;
                 -- разрешается ли ПРИХОД
                 vbIsIn_partion:= vbAmount_sun = 0
                                OR
                                   -- сколько уже пришло
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_to = vbUnitId_to), 0)
                                 + vbAmount * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_in_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to)
                                 ;
                 --
                 -- получилось в Автозаказе больше чем в остатках, т.е. отдаем весь "СРОК"
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId, Amount_not_out, Summ_not_out, Amount_not_in, Summ_not_in)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                           -- может оказаться что для двух товаров
                         , tmpGoods.GoodsId
                           -- с учетом кратности - vbKoeffSUN
                         , CASE WHEN vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE THEN CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END                  ELSE 0 END AS Amount
                         , CASE WHEN vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE THEN CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END * tmpGoods.Price ELSE 0 END AS Summ
                           --
                         , 0 AS Amount_next
                         , 0 AS Summ_next
                         , 0 AS MovementId
                         , 0 AS MovementItemId
                         , CASE WHEN vbIsOut_partion = FALSE THEN CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END                  ELSE 0 END AS Amount_not_out
                         , CASE WHEN vbIsOut_partion = FALSE THEN CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END * tmpGoods.Price ELSE 0 END AS Summ_not_out
                         , CASE WHEN vbIsIn_partion  = FALSE THEN CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END                  ELSE 0 END AS Amount_not_in
                         , CASE WHEN vbIsIn_partion  = FALSE THEN CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END * tmpGoods.Price ELSE 0 END AS Summ_not_in
                    FROM (SELECT vbGoodsId AS GoodsId, vbPrice AS Price /*UNION SELECT vbGoodsId_PairSun AS GoodsId, vbPrice_PairSun AS Price WHERE vbGoodsId_PairSun > 0*/) AS tmpGoods
                    WHERE CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END > 0
                   ;

-- if inUserId = 3 AND exists (select 1 from _tmpResult_Partion where _tmpResult_Partion.GoodsId = 42550  AND _tmpResult_Partion.Amount > 0)
-- then --  Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId, Amount_not_out, Summ_not_out, Amount_not_in, Summ_not_in)
--      RAISE EXCEPTION 'Ошибка.<%>', (select _tmpResult_Partion.Amount from _tmpResult_Partion where _tmpResult_Partion.GoodsId = 42550 AND _tmpResult_Partion.Amount > 0);
-- end if;

                 --  если все разрешено ИЛИ если расход запрещен
                 IF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                    OR vbIsOut_partion = FALSE
                 THEN
                     -- обнуляем кол-во чтобы больше не искать
                     vbAmount     := 0;
                     vbAmount_save:= 0;
                 END IF;

             -- !!!ДРУГАЯ ВЕТКА!!!
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
                 --
                 -- разрешается ли РАСХОД
                 vbIsOut_partion:= vbAmount_sun = 0
                                OR
                                   -- сколько уже ушло
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from), 0)
                                 + vbAmountResult * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_out_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from)
                                 ;
                 -- разрешается ли ПРИХОД
                 vbIsIn_partion:= vbAmount_sun = 0
                                OR
                                   -- сколько уже пришло
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_to = vbUnitId_to), 0)
                                 + vbAmountResult * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_in_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to)
                                 ;

                 --
                 -- получилось в остатках больше чем надо, т.е. отдаем сколько надо и крутим дальше
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId, Amount_not_out, Summ_not_out, Amount_not_in, Summ_not_in)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                           -- может оказаться что для двух товаров
                         , tmpGoods.GoodsId
                           -- ???здесь уже кратность учтена???
                         , CASE WHEN vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE THEN vbAmountResult                  ELSE 0 END AS Amount
                         , CASE WHEN vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE THEN vbAmountResult * tmpGoods.Price ELSE 0 END AS Summ
                           --
                         , 0 AS Amount_next
                         , 0 AS Summ_next
                         , 0 AS MovementId
                         , 0 AS MovementItemId
                         , CASE WHEN vbIsOut_partion = FALSE THEN vbAmountResult                  ELSE 0 END AS Amount_not_out
                         , CASE WHEN vbIsOut_partion = FALSE THEN vbAmountResult * tmpGoods.Price ELSE 0 END AS Summ_not_out
                         , CASE WHEN vbIsIn_partion  = FALSE THEN vbAmountResult                  ELSE 0 END AS Amount_not_in
                         , CASE WHEN vbIsIn_partion  = FALSE THEN vbAmountResult * tmpGoods.Price ELSE 0 END AS Summ_not_in
                    FROM (SELECT vbGoodsId AS GoodsId, vbPrice AS Price /*UNION SELECT vbGoodsId_PairSun AS GoodsId, vbPrice_PairSun AS Price WHERE vbGoodsId_PairSun > 0*/) AS tmpGoods
                    WHERE vbAmountResult > 0
                   ;
                 --  если расход запрещен
                 IF vbIsOut_partion = FALSE
                 THEN
                     -- обнуляем кол-во чтобы больше не искать
                     vbAmount     := 0;
                     vbAmount_save:= 0;
                 --  если все разрешено
                 ELSEIF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                 THEN
                     -- уменьшаем на кол-во которое нашли и продолжаем поиск
                     vbAmount     := vbAmount      - vbAmountResult;
                     vbAmount_save:= vbAmount_save - vbAmountResult;
                 END IF;

             END IF;

         END LOOP; -- финиш цикла по курсору2
         CLOSE curResult; -- закрыли курсор2.

     END LOOP; -- финиш цикла по курсору1
     CLOSE curPartion; -- закрыли курсор1

     -- 6.1.2. распределяем-2 остатки со сроками - по всем аптекам - здесь только !!!все что осталось!!!
     --
     -- курсор1 - все остатки, СРОК МИНУС сколько уже распределили
     OPEN curPartion_next FOR
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from, _tmpRemains_Partion.GoodsId, FLOOR(_tmpRemains_Partion.Amount -COALESCE (tmp.Amount, 0) - COALESCE(_tmpGoods_Layout.Layout, 0) - COALESCE(_tmpGoods_PromoUnit.Amount, 0)) AS Amount
             , _tmpRemains_Partion.Amount_sun
             , COALESCE (_tmpGoods_SUN.KoeffSUN, 0)
        FROM _tmpRemains_Partion
             -- сколько уже ушло после распределения - 1
             LEFT JOIN (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.GoodsId, SUM (_tmpResult_Partion.Amount) AS Amount FROM _tmpResult_Partion GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.GoodsId
                       ) AS tmp ON tmp.UnitId_from = _tmpRemains_Partion.UnitId
                               AND tmp.GoodsId     = _tmpRemains_Partion.GoodsId
             -- начинаем с аптек, где расход может быть максимальным
             LEFT JOIN (SELECT _tmpSumm_limit.UnitId_from, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                        -- !!!без лимита
                        -- WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                        GROUP BY _tmpSumm_limit.UnitId_from
                       ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_from = _tmpRemains_Partion.UnitId

             -- товары для Кратность
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_Partion.GoodsId

             LEFT JOIN _tmpGoods_PromoUnit ON _tmpGoods_PromoUnit.UnitId = _tmpRemains_Partion.UnitId
                                          AND _tmpGoods_PromoUnit.GoodsId = _tmpRemains_Partion.GoodsId

             LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = _tmpRemains_Partion.UnitId
                                       AND _tmpGoods_Layout.GoodsId = _tmpRemains_Partion.GoodsId

        WHERE FLOOR(_tmpRemains_Partion.Amount - COALESCE (tmp.Amount, 0) - COALESCE(_tmpGoods_Layout.Layout, 0) - COALESCE(_tmpGoods_PromoUnit.Amount, 0)) > 0
        ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbAmount, vbAmount_sun, vbKoeffSUN;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         -- курсор2. - Автозаказ МИНУС сколько уже распределили для vbGoodsId
         OPEN curResult_next FOR
            SELECT _tmpRemains_calc.UnitId AS UnitId_to, _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) AS AmountResult, _tmpRemains_calc.Price
            FROM _tmpRemains_calc
                 -- сколько уже пришло после распределения - 1+2
                 LEFT JOIN (SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId, SUM (_tmpResult_Partion.Amount + _tmpResult_Partion.Amount_next) AS Amount FROM _tmpResult_Partion GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                           ) AS tmp ON tmp.UnitId_to = _tmpRemains_calc.UnitId
                                   AND tmp.GoodsId   = _tmpRemains_calc.GoodsId
                 -- начинаем с аптек, где приход может быть максимальным
                 LEFT JOIN (SELECT _tmpSumm_limit.UnitId_to, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                            WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from
                              -- !!!без лимита
                              -- AND _tmpSumm_limit.Summ >= vbSumm_limit
                            GROUP BY _tmpSumm_limit.UnitId_to
                           ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_to = _tmpRemains_calc.UnitId

                 -- товары - для Кратность
                 LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_calc.GoodsId

                 -- !!!только НЕ DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit!!!
                 LEFT JOIN _tmpList_DefSUN ON _tmpList_DefSUN.UnitId_from = vbUnitId_from
                                          AND _tmpList_DefSUN.UnitId_to   = _tmpRemains_calc.UnitId
                                          AND _tmpList_DefSUN.GoodsId     = vbGoodsId
                 -- !!!только НЕ DefSUN-all - если 2 дня есть в перемещении, т.к. < vbSumm_limit!!!
                 --LEFT JOIN (SELECT DISTINCT _tmpList_DefSUN.UnitId_to, _tmpList_DefSUN.GoodsId FROM _tmpList_DefSUN
                 --          ) AS _tmpList_DefSUN_all
                 --            ON _tmpList_DefSUN_all.UnitId_to = _tmpRemains_calc.UnitId
                 --           AND _tmpList_DefSUN_all.GoodsId   = vbGoodsId

                 -- !!!НЕ распределяем если уже был этот товар в 1!!!
                 LEFT JOIN _tmpResult_Partion ON _tmpResult_Partion.UnitId_from = vbUnitId_from
                                             AND _tmpResult_Partion.UnitId_to   = _tmpRemains_calc.UnitId
                                             AND _tmpResult_Partion.GoodsId     = vbGoodsId
                                             AND _tmpResult_Partion.Amount      > 0

                 -- отбросили !!исключения!!
                 LEFT JOIN _tmpUnit_SunExclusion AS _tmpUnit_SunExclusion_MCS
                                                 ON _tmpUnit_SunExclusion_MCS.UnitId_from = vbUnitId_from
                                                AND _tmpUnit_SunExclusion_MCS.UnitId_to   = _tmpRemains_calc.UnitId

            WHERE _tmpRemains_calc.GoodsId = vbGoodsId
              AND _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) > 0
              -- !!!НЕ распределяем
              AND _tmpResult_Partion.GoodsId IS NULL
              -- !!!НЕ DefSUN
              AND _tmpList_DefSUN.GoodsId IS NULL
              -- !!!НЕ DefSUN-all
              --AND _tmpList_DefSUN_all.GoodsId IS NULL
              -- !!!без лимита
              -- AND _tmpRemains_calc.UnitId IN (SELECT DISTINCT _tmpSumm_limit.UnitId_to FROM _tmpSumm_limit WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from AND _tmpSumm_limit.Summ >= vbSumm_limit)

              -- !!!
              AND _tmpUnit_SunExclusion_MCS.UnitId_to IS NULL

            ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_calc.UnitId
           ;
         -- начало цикла по курсору2 - остаток сроковых - под него надо найти Автозаказ
         LOOP
             -- данные по Автозаказ
             FETCH curResult_next INTO vbUnitId_to, vbAmountResult, vbPrice;
             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             -- если Автозаказ > Остаток
             IF vbAmountResult > vbAmount
             THEN
                 --
                 -- разрешается ли РАСХОД
                 vbIsOut_partion:= vbAmount_sun = 0
                                OR
                                   -- сколько уже ушло
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from), 0)
                                 + vbAmount * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_out_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from)
                                 ;
                 -- разрешается ли ПРИХОД
                 vbIsIn_partion:= vbAmount_sun = 0
                                OR
                                   -- сколько уже пришло
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_to = vbUnitId_to), 0)
                                 + vbAmount * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_in_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to)
                                 ;
                 --
                 -- если НЕ отдаем, тогда проверим - может была вставка в пред итерации, поэтому повторно не надо
                 IF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                  OR ((vbIsOut_partion = FALSE OR vbIsIn_partion = FALSE)
                      AND NOT EXISTS (SELECT 1 FROM _tmpResult_Partion
                                      WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from
                                        AND _tmpResult_Partion.UnitId_to   = vbUnitId_to
                                        AND _tmpResult_Partion.GoodsId     = vbGoodsId
                                        AND (_tmpResult_Partion.Amount_not_out <> 0
                                          OR _tmpResult_Partion.Amount_not_in  <> 0
                                            )
                                     )
                      )
                 THEN

                 -- получилось в Автозаказе больше чем искали, т.е. отдаем весь "СРОК"
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId, Amount_not_out, Summ_not_out, Amount_not_in, Summ_not_in)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                         , 0                  AS Amount
                         , 0                  AS Summ
                         , CASE WHEN vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE THEN CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END           ELSE 0 END AS Amount_next
                         , CASE WHEN vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE THEN CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END * vbPrice ELSE 0 END AS Summ_next
                         , 0                  AS MovementId
                         , 0                  AS MovementItemId
                         , CASE WHEN vbIsOut_partion = FALSE THEN vbAmount           ELSE 0 END AS Amount_not_out
                         , CASE WHEN vbIsOut_partion = FALSE THEN vbAmount * vbPrice ELSE 0 END AS Summ_not_out
                         , CASE WHEN vbIsIn_partion  = FALSE THEN vbAmount           ELSE 0 END AS Amount_not_in
                         , CASE WHEN vbIsIn_partion  = FALSE THEN vbAmount * vbPrice ELSE 0 END AS Summ_not_in
                    WHERE CASE WHEN vbKoeffSUN > 0 THEN FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN ELSE vbAmount END > 0
                   -- AND NOT EXISTS (SELECT 1 FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from AND _tmpResult_Partion.UnitId_to = vbUnitId_to AND _tmpResult_Partion.GoodsId = vbGoodsId)
                   ;

                 END IF;

                 --  если все разрешено ИЛИ если расход запрещен
                 IF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                    OR vbIsOut_partion = FALSE
                 THEN
                     -- обнуляем кол-во чтобы больше не искать
                     vbAmount:= 0;
                 END IF;

             -- !!!ДРУГАЯ ВЕТКА!!!
             ELSE

                 -- разрешается ли РАСХОД
                 vbIsOut_partion:= vbAmount_sun = 0
                                OR
                                   -- сколько уже ушло
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from), 0)
                                 + vbAmountResult * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_out_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from)
                                 ;
                 -- разрешается ли ПРИХОД
                 vbIsIn_partion:= vbAmount_sun = 0
                                OR
                                   -- сколько уже пришло
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_to = vbUnitId_to), 0)
                                 + vbAmountResult * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_in_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to)
                                 ;
                 --
                 -- если НЕ отдаем, тогда проверим - может была вставка в пред итерации, поэтому повторно не надо
                 IF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                  OR ((vbIsOut_partion = FALSE OR vbIsIn_partion = FALSE)
                      AND NOT EXISTS (SELECT 1 FROM _tmpResult_Partion
                                      WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from
                                        AND _tmpResult_Partion.UnitId_to   = vbUnitId_to
                                        AND _tmpResult_Partion.GoodsId     = vbGoodsId
                                        AND (_tmpResult_Partion.Amount_not_out <> 0
                                          OR _tmpResult_Partion.Amount_not_in  <> 0
                                            )
                                     )
                      )
                 THEN

                 -- получилось в остатках меньше чем искали, !!!сохраняем в табл-результат - проводки кол-во!!!
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId, Amount_not_out, Summ_not_out, Amount_not_in, Summ_not_in)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                         , 0                        AS Amount
                         , 0                        AS Summ
                         , CASE WHEN vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE THEN vbAmountResult           ELSE 0 END AS Amount_next
                         , CASE WHEN vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE THEN vbAmountResult * vbPrice ELSE 0 END AS Summ_next
                         , 0                        AS MovementId
                         , 0                        AS MovementItemId
                         , CASE WHEN vbIsOut_partion = FALSE THEN vbAmountResult           ELSE 0 END AS Amount_not_out
                         , CASE WHEN vbIsOut_partion = FALSE THEN vbAmountResult * vbPrice ELSE 0 END AS Summ_not_out
                         , CASE WHEN vbIsIn_partion  = FALSE THEN vbAmountResult           ELSE 0 END AS Amount_not_in
                         , CASE WHEN vbIsIn_partion  = FALSE THEN vbAmountResult * vbPrice ELSE 0 END AS Summ_not_in
                    WHERE vbAmountResult > 0
                   -- AND NOT EXISTS (SELECT 1 FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from AND _tmpResult_Partion.UnitId_to = vbUnitId_to AND _tmpResult_Partion.GoodsId = vbGoodsId)
                   ;

                 END IF;

                 --  если расход запрещен
                 IF vbIsOut_partion = FALSE
                 THEN
                     -- обнуляем кол-во чтобы больше не искать
                     vbAmount     := 0;
                 --  если все разрешено ИЛИ если расход запрещен
                 ELSEIF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                 THEN
                     -- уменьшаем на кол-во которое нашли и продолжаем поиск
                     vbAmount:= vbAmount - vbAmountResult;
                 END IF;

             END IF;

         END LOOP; -- финиш цикла по курсору2
         CLOSE curResult_next; -- закрыли курсор2.

     END LOOP; -- финиш цикла по курсору1
     CLOSE curPartion_next; -- закрыли курсор1


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
              );
*/


     -- 6.1.3. Проверка
     IF EXISTS (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                     , SUM (_tmpResult_Partion.Amount) AS Amount, SUM (_tmpResult_Partion.Amount_next) AS Amount_next
                FROM _tmpResult_Partion
                GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                HAVING SUM (_tmpResult_Partion.Amount)      <> 0
                   AND SUM (_tmpResult_Partion.Amount_next) <> 0
               )
               AND 1=0
     THEN
         RAISE EXCEPTION 'Дублируется перемещение. <%> <%> <%> <%> <%> <%> <%>.'
             , -- UnitId_from
               lfGet_Object_ValueData_sh (
               (SELECT _tmpResult_Partion.UnitId_from
                FROM _tmpResult_Partion
                GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                HAVING SUM (_tmpResult_Partion.Amount)      <> 0
                   AND SUM (_tmpResult_Partion.Amount_next) <> 0
                ORDER BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                LIMIT 1
               ))
             , -- UnitId_to
               lfGet_Object_ValueData_sh (
               (SELECT _tmpResult_Partion.UnitId_to
                FROM _tmpResult_Partion
                GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                HAVING SUM (_tmpResult_Partion.Amount)      <> 0
                   AND SUM (_tmpResult_Partion.Amount_next) <> 0
                ORDER BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                LIMIT 1
               ))
             , -- GoodsId
               lfGet_Object_ValueData (
               (SELECT _tmpResult_Partion.GoodsId
                FROM _tmpResult_Partion
                GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                HAVING SUM (_tmpResult_Partion.Amount)      <> 0
                   AND SUM (_tmpResult_Partion.Amount_next) <> 0
                ORDER BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                LIMIT 1
               ))
             , -- Amount
               zfConvert_FloatToString (
               (SELECT SUM (_tmpResult_Partion.Amount)
                FROM _tmpResult_Partion
                GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                HAVING SUM (_tmpResult_Partion.Amount)      <> 0
                   AND SUM (_tmpResult_Partion.Amount_next) <> 0
                ORDER BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                LIMIT 1
               ))
             , -- Amount_next
               zfConvert_FloatToString (
               (SELECT SUM (_tmpResult_Partion.Amount_next)
                FROM _tmpResult_Partion
                GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                HAVING SUM (_tmpResult_Partion.Amount)      <> 0
                   AND SUM (_tmpResult_Partion.Amount_next) <> 0
                ORDER BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                LIMIT 1
               ))
             , -- Summ
               zfConvert_FloatToString (
               (SELECT SUM (_tmpResult_Partion.Summ)
                FROM _tmpResult_Partion
                GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                HAVING SUM (_tmpResult_Partion.Amount)      <> 0
                   AND SUM (_tmpResult_Partion.Amount_next) <> 0
                ORDER BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                LIMIT 1
               ))
             , -- Summ_next
               zfConvert_FloatToString (
               (SELECT SUM (_tmpResult_Partion.Summ_next)
                FROM _tmpResult_Partion
                GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                HAVING SUM (_tmpResult_Partion.Amount)      <> 0
                   AND SUM (_tmpResult_Partion.Amount_next) <> 0
                ORDER BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                LIMIT 1
               ))
              ;

     END IF;

     -- 6.1.4.1. !!!важно, для vbSumm_limit - переносим из отложенных в Amount!!!
     UPDATE _tmpResult_Partion SET Amount      = CASE WHEN _tmpResult_Partion.Amount_next > 0 THEN _tmpResult_Partion.Amount + _tmpResult_Partion.Amount_next  ELSE _tmpResult_Partion.Amount END
                                 , Summ        = CASE WHEN _tmpResult_Partion.Summ_next   > 0 THEN _tmpResult_Partion.Summ   + _tmpResult_Partion.Summ_next    ELSE _tmpResult_Partion.Summ   END
                                 , Amount_next = 0
                                 , Summ_next   = 0
     FROM -- собрали в 1 перемещение
          (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
           FROM _tmpResult_Partion
           GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
           HAVING SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) >= vbSumm_limit
          ) AS tmp
     WHERE _tmpResult_Partion.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Partion.UnitId_to   = tmp.UnitId_to
       AND _tmpResult_Partion.Amount_next > 0
    ;

     -- 6.1.4.2. !!!важно, если остатка не хватило для vbSumm_limit - переносим в отложенные!!!
     UPDATE _tmpResult_Partion SET Amount      = CASE WHEN _tmpResult_Partion.Amount_next = 0 THEN 0                         ELSE _tmpResult_Partion.Amount      END
                                 , Summ        = CASE WHEN _tmpResult_Partion.Summ_next   = 0 THEN 0                         ELSE _tmpResult_Partion.Summ        END
                                 , Amount_next = CASE WHEN _tmpResult_Partion.Amount_next = 0 THEN _tmpResult_Partion.Amount ELSE _tmpResult_Partion.Amount_next END
                                 , Summ_next   = CASE WHEN _tmpResult_Partion.Summ_next   = 0 THEN _tmpResult_Partion.Summ   ELSE _tmpResult_Partion.Summ_next   END
     FROM -- собрали в 1 перемещение
          (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
           FROM _tmpResult_Partion
           GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
           HAVING SUM (_tmpResult_Partion.Summ) < vbSumm_limit
          ) AS tmp
     WHERE _tmpResult_Partion.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Partion.UnitId_to   = tmp.UnitId_to
    ;


     -- 6.1.5. !!!важно, ОТКЛЮЧИЛИ отложенные!!!
     UPDATE _tmpResult_Partion SET Amount_next = 0, Summ_next = 0;
     DELETE FROM _tmpResult_Partion WHERE Amount = 0 AND Amount_next = 0;


     -- Добавили парные согласно наличия

/*     IF inUserId = '3'
     THEN

        UPDATE _tmpRemains set AmountRemains = 1
        WHERE _tmpRemains.UnitId = 377610 AND _tmpRemains.GoodsId = 366794;

        UPDATE _tmpRemains set AmountRemains = 1
        WHERE _tmpRemains.UnitId = 377574 AND _tmpRemains.GoodsId = 366788;

        raise notice 'Ошибка. % % %',
                     (SELECT count(*) FROM _tmpResult_Partion),
                     (SELECT count(*) FROM _tmpResult_Partion WHERE _tmpResult_Partion.GoodsId in (SELECT GoodsId_PairSun FROM _tmpGoods_SUN_PairSun)),
                     (SELECT count(*) FROM _tmpRemains WHERE _tmpRemains.UnitId = 377610 AND _tmpRemains.GoodsId = 366794);
     END IF;
*/

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

     INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId, Amount_not_out, Summ_not_out, Amount_not_in, Summ_not_in)
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
          , 0 as Amount_not_out
          , 0 as Summ_not_out
          , 0 as Amount_not_in
          , 0 as Summ_not_in
        FROM (SELECT DD.*
                   , CASE WHEN DD.AmountRemains - DD.AmountSUM > 0 --AND DD.DOrd <> 1
                               THEN DD.Amount
                          ELSE DD.AmountRemains - DD.AmountSUM + DD.Amount
                     END AS AmountAdd
              FROM tmpResult AS DD
              WHERE DD.AmountRemains - (DD.AmountSUM - DD.Amount) > 0
             ) AS tmpItem;

/*     IF inUserId = '3'
     THEN
        raise notice 'Ошибка. % %', (SELECT count(*) FROM _tmpResult_Partion)
                                  , (SELECT count(*) FROM _tmpResult_Partion WHERE _tmpResult_Partion.GoodsId in (SELECT GoodsId_PairSun FROM _tmpGoods_SUN_PairSun));
     END IF;
*/


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

     -- 6.2.1. !!!важно, документы - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     IF inStep = 1
     THEN
         -- список DefSUN
         INSERT INTO _tmpList_DefSUN (UnitId_from , UnitId_to, GoodsId)
            WITH -- DefSUN - за предыдущие 2 дня
                 tmpDefSUN AS (SELECT DISTINCT
                                      MovementLinkObject_From.ObjectId AS UnitId_from
                                    , MovementLinkObject_To.ObjectId   AS UnitId_to
                                    , MovementItem.ObjectId            AS GoodsId
                                    , Movement.OperDate                AS OperDate
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                                 AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                                 AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                    INNER JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                               ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                              AND MovementBoolean_DefSUN.DescId     = zc_MovementBoolean_DefSUN()
                                                              AND MovementBoolean_DefSUN.ValueData = TRUE
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                                           AND MovementItem.Amount     > 0
                               WHERE Movement.OperDate BETWEEN inOperDate - INTERVAL '2 DAY' AND inOperDate - INTERVAL '1 DAY'
                                 AND Movement.DescId   = zc_Movement_Send()
                                 AND Movement.StatusId = zc_Enum_Status_Erased()
                              )
                 -- DefSUN - 2 дня подряд
               , tmpResult AS (SELECT tmpDefSUN.UnitId_from, tmpDefSUN.UnitId_to, tmpDefSUN.GoodsId
                              FROM tmpDefSUN
                              GROUP BY tmpDefSUN.UnitId_from, tmpDefSUN.UnitId_to, tmpDefSUN.GoodsId
                              HAVING COUNT (*) = 2
                             )
            -- Результат
            SELECT DISTINCT
                   _tmpResult_Partion.UnitId_from
                 , _tmpResult_Partion.UnitId_to
                 , _tmpResult_Partion.GoodsId
            FROM _tmpResult_Partion
                 JOIN tmpResult ON tmpResult.UnitId_from = _tmpResult_Partion.UnitId_from
                               AND tmpResult.UnitId_to   = _tmpResult_Partion.UnitId_to
                               AND tmpResult.GoodsId     = _tmpResult_Partion.GoodsId
            WHERE _tmpResult_Partion.Amount_next > 0
           ;
         -- 6.2.2. !!!если нашлись товары - DefSUN!!!
         IF EXISTS (SELECT 1 FROM _tmpList_DefSUN)
         THEN
             -- тогда на 2-м шаге они участвовать не будут !!!
             PERFORM lpInsert_Movement_Send_RemainsSun (inOperDate:= inOperDate
                                                      , inDriverId:= inDriverId
                                                      , inStep    := 2
                                                      , inUserId  := inUserId
                                                       );
         END IF;

     END IF;


     IF inStep = 2
     THEN
         -- !!!Выход!!!
         RETURN;
     END IF;


     -- 7.1. распределяем перемещения - по партиям со сроками
     -- CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     --
     -- !!!Т.к. товар дублируется - Распределим через курсор!!!
     -- курсор1 - элементы перемещения
     OPEN curResult_partion FOR (SELECT _tmpResult_Partion.MovementId
                                      , _tmpResult_Partion.UnitId_from
                                      , _tmpResult_Partion.UnitId_to
                                      , _tmpResult_Partion.MovementItemId AS ParentId
                                      , _tmpResult_Partion.GoodsId
                                      , SUM (_tmpResult_Partion.Amount + _tmpResult_Partion.Amount_next) AS Amount
                                 FROM _tmpResult_Partion
                                 GROUP BY _tmpResult_Partion.MovementItemId
                                        , _tmpResult_Partion.MovementId
                                        , _tmpResult_Partion.GoodsId
                                        , _tmpResult_Partion.UnitId_from
                                        , _tmpResult_Partion.UnitId_to
                                );
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curResult_partion INTO vbMovementId, vbUnitId_from, vbUnitId_to, vbParentId, vbGoodsId, vbAmount;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         -- курсор2. - остатки МИНУС сколько уже распределили для vbUnitId_from + vbGoodsId
         OPEN curRemains FOR
            SELECT _tmpRemains_Partion_all.ContainerId, _tmpRemains_Partion_all.Amount - COALESCE (tmp.Amount, 0)
            FROM _tmpRemains_Partion_all
                 LEFT JOIN (SELECT _tmpResult_child.ContainerId, SUM (_tmpResult_child.Amount) AS Amount FROM _tmpResult_child GROUP BY _tmpResult_child.ContainerId
                           ) AS tmp ON tmp.ContainerId = _tmpRemains_Partion_all.ContainerId
            WHERE _tmpRemains_Partion_all.UnitId  = vbUnitId_from
              AND _tmpRemains_Partion_all.GoodsId = vbGoodsId
              AND _tmpRemains_Partion_all.Amount - COALESCE (tmp.Amount, 0) > 0
              -- !!!только если партии со сроками, т.е. не 100 дней!!!
              AND _tmpRemains_Partion_all.ContainerDescId = zc_Container_CountPartionDate()
            -- сначала с "хорошей" датой
            -- ORDER BY _tmpRemains_Partion_all.ExpirationDate DESC, _tmpRemains_Partion_all.ContainerId
            -- сначала с "плохой" датой
            ORDER BY _tmpRemains_Partion_all.ExpirationDate ASC, _tmpRemains_Partion_all.ContainerId
           ;
         -- начало цикла по курсору2. - остатки
         LOOP
             -- данные по остаткам
             FETCH curRemains INTO vbContainerId, vbAmount_remains;
             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             --
             IF vbAmount_remains > vbAmount
             THEN
                 -- получилось в остатках больше чем искали
                 INSERT INTO _tmpResult_child (MovementId, UnitId_from, UnitId_to, ParentId, ContainerId, GoodsId, Amount)
                    SELECT vbMovementId, vbUnitId_from, vbUnitId_to, vbParentId, vbContainerId, vbGoodsId, vbAmount;

                 -- обнуляем кол-во чтобы больше не искать
                 vbAmount:= 0;
             ELSE
                 -- получилось в остатках меньше чем искали
                 INSERT INTO _tmpResult_child (MovementId, UnitId_from, UnitId_to, ParentId, ContainerId, GoodsId, Amount)
                    SELECT vbMovementId, vbUnitId_from, vbUnitId_to, vbParentId, vbContainerId, vbGoodsId, vbAmount_remains;

                 -- уменьшаем на кол-во которое нашли и продолжаем поиск
                 vbAmount:= vbAmount - vbAmount_remains;
             END IF;

         END LOOP; -- финиш цикла по курсору2. - остатки
         CLOSE curRemains; -- закрыли курсор2. - остатки

     END LOOP; -- финиш цикла по курсору1 - перемещения
     CLOSE curResult_partion; -- закрыли курсор1 - перемещения


/*
!!!
     -- 7.2. создали строки Child - по СУН
     PERFORM lpInsertUpdate_MovementItem_Send_Child (ioId         := 0
                                                   , inParentId   := _tmpResult_child.ParentId
                                                   , inMovementId := _tmpResult_child.MovementId
                                                   , inGoodsId    := _tmpResult_child.GoodsId
                                                   , inAmount     := _tmpResult_child.Amount
                                                   , inContainerId:= _tmpResult_child.ContainerId
                                                   , inUserId     := inUserId
                                                    )
     FROM _tmpResult_child;


     -- 8. Удаляем документы, что б не мешали
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := inUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Partion.MovementId FROM _tmpResult_Partion WHERE _tmpResult_Partion.MovementId > 0
          ) AS tmp;
*/

     -- Результат
     RETURN QUERY
       SELECT Object_Unit.Id          AS UnitId
            , Object_Unit.ValueData   AS UnitName
            , Object_Goods.Id         AS GoodsId
            , Object_Goods_Main.ObjectCode AS GoodsCode
            , Object_Goods_Main.Name       AS GoodsName
            , Object_Goods_Main.isClose    AS isClose
              -- продажи
            , _tmpSale.Amount AS Amount_sale
            , _tmpSale.Summ   AS Summ_sale
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
            , tmpSumm_res.Amount_not_out :: TFloat AS Amount_not_out_res
            , tmpSumm_res.Summ_not_out   :: TFloat AS Summ_not_out_res
            , tmpSumm_res.Amount_not_in  :: TFloat AS Amount_not_in_res
            , tmpSumm_res.Summ_not_in    :: TFloat AS Summ_not_in_res

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
             LEFT JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.Amount_sun) AS Amount_sun, SUM (_tmpRemains_Partion.Amount_notSold) AS Amount_notSold
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

                            , SUM (_tmpResult_Partion.Amount_not_out) AS Amount_not_out
                            , SUM (_tmpResult_Partion.Summ_not_out)   AS Summ_not_out
                            , SUM (_tmpResult_Partion.Amount_not_in)  AS Amount_not_in
                            , SUM (_tmpResult_Partion.Summ_not_in)    AS Summ_not_in
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
            LEFT JOIN _tmpSale ON _tmpSale.UnitId  = _tmpRemains_calc.UnitId
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

-- if  inUserId = 3 then
--    RAISE EXCEPTION '<ok>  %  %'
--      , (SELECT _tmpResult_Partion.Amount   FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from =183292 AND  _tmpResult_Partion.UnitId_to = 375626 and _tmpResult_Partion.goodsId = 270005)
--      , (SELECT _tmpResult_Partion.Amount   FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from =183292 AND  _tmpResult_Partion.UnitId_to = 375626 and _tmpResult_Partion.goodsId = 270005)
--      ;
-- end if;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.19         *
 18.07.19                                        *
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
     -- все Подразделения для схемы SUN
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean) ON COMMIT DROP;
     -- баланс по Аптекам - если не соответствует, соотв приход или расход блокируется
     CREATE TEMP TABLE _tmpUnit_SUN_balance (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_partion (UnitId Integer, Summ_out TFloat, Summ_in TFloat, Summ_out_calc TFloat, Summ_in_calc TFloat) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. вся статистика продаж
     CREATE TEMP TABLE _tmpSale   (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     -- 2.2. товары для Кратность
     CREATE TEMP TABLE _tmpGoods_SUN (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;
     -- 2.3. "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
     CREATE TEMP TABLE _tmpGoods_SUN_PairSun (GoodsId Integer, GoodsId_PairSun Integer) ON COMMIT DROP;

     -- 3.1. все остатки, СРОК
     CREATE TEMP TABLE _tmpRemains_Partion_all (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     -- 3.2. остатки, СРОК - для распределения
     CREATE TEMP TABLE _tmpRemains_Partion (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;


     -- 4. Остатки по которым есть Автозаказ и срок
     CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь только >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer, Amount_not_out TFloat, Summ_not_out TFloat, Amount_not_in TFloat, Summ_not_in TFloat) ON COMMIT DROP;
     -- 6.2. !!!товары - DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда они участвовать не будут !!!
     CREATE TEMP TABLE _tmpList_DefSUN (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. распределяем перемещения - по партиям со сроками
     CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 8. исключаем такие перемещения
     CREATE TEMP TABLE _tmpUnit_SunExclusion (UnitId_from Integer, UnitId_to Integer, isMCS_to Boolean) ON COMMIT DROP;

 SELECT * FROM lpInsert_Movement_Send_RemainsSun (inOperDate:= CURRENT_DATE + INTERVAL '5 DAY', inDriverId:= (SELECT MAX (OL.ChildObjectId) FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Driver()), inStep:= 1, inUserId:= 3) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
*/