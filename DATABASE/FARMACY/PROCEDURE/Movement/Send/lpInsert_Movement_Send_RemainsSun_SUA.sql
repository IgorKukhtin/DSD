-- Function: lpInsert_Movement_Send_RemainsSun_SUA

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_SUA (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_SUA(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inDriverId            Integer   , -- Водитель, распределяем только по аптекам этого
    IN inUserId              Integer     -- пользователь
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, isClose boolean
             , UnitId_From Integer, UnitName_From TVarChar
             , Remains_From TFloat, Layout_From TFloat, PromoUnit_From TFloat

             , UnitId_To Integer, UnitName_To TVarChar, Remains_To TFloat
             , Amount TFloat
             , Price_From TFloat, Price_To TFloat
             , isCloseMCS_From boolean, isCloseMCS_To boolean

              )
AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbDOW_curr TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbMovementId Integer;

   DECLARE curPartion_next refcursor;
   DECLARE curResult_next  refcursor;

   DECLARE vbUnitId_from Integer;
   DECLARE vbUnitId_To Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbSurplus TFloat;
   DECLARE vbNeed TFloat;
   DECLARE vbKoeffSUN TFloat;

   DECLARE vbDate_6     TDateTime;
   DECLARE vbDate_3     TDateTime;
   DECLARE vbDate_1     TDateTime;
   DECLARE vbDate_0     TDateTime;
   DECLARE vbSumm_limit TFloat;

   DECLARE vbPeriod_t1    Integer;
   DECLARE vbPeriod_t2    Integer;
   DECLARE vbPeriod_t_max Integer;

   DECLARE vbDayIncome_max   Integer;
   DECLARE vbDaySendSUN_max  Integer;
   DECLARE vbDaySendSUNAll_max Integer;
BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     vbSumm_limit:= CASE WHEN 0 < (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                              THEN (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                         ELSE 1500
                    END;

     -- день недели
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;

     vbOperDate := inOperDate - ((date_part('DOW', inOperDate)::Integer - 1)::TVarChar||' DAY')::INTERVAL;

     -- все Товары для схемы SUN SUA
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_SUA'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_SUA   (GoodsId Integer, KoeffSUN TFloat, UnitOutId Integer) ON COMMIT DROP;
     END IF;

     -- все Подразделения для схемы SUN SUA
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SUN_SUA'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SUN_SUA   (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean) ON COMMIT DROP;
     END IF;

     -- Выкладки
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoodsLayout_SUN_SUA'))
     THEN
       CREATE TEMP TABLE _tmpGoodsLayout_SUN_SUA (GoodsId Integer, UnitId Integer, Layout TFloat) ON COMMIT DROP;
     END IF;

     -- Маркетинговый план для точек
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_PromoUnit_SUA'))
     THEN
       CREATE TEMP TABLE _tmpGoods_PromoUnit_SUA (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_TP_exception_SUA'))
     THEN
       CREATE TEMP TABLE _tmpGoods_TP_exception_SUA   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- Уже использовано в текущем СУН
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_Sun_exception_SUA'))
     THEN
       CREATE TEMP TABLE _tmpGoods_Sun_exception_SUA   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_all_SUA'))
     THEN
       CREATE TEMP TABLE _tmpRemains_all_SUA   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     END IF;

     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_SUA'))
     THEN
       CREATE TEMP TABLE _tmpRemains_SUA   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     END IF;

     -- 2.1. вся статистика продаж - OVER
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSale_over_SUA'))
     THEN
       CREATE TEMP TABLE _tmpSale_over_SUA   (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     END IF;
     -- 2.2. NotSold
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSale_not_SUA'))
     THEN
       CREATE TEMP TABLE _tmpSale_not_SUA (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpStockRatio_all_SUA'))
     THEN
       CREATE TEMP TABLE _tmpStockRatio_all_SUA   (GoodsId Integer, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AverageSales TFloat, StockRatio TFloat) ON COMMIT DROP;
     END IF;

     -- 2.5. "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_PairSun_SUA'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_PairSun_SUA (GoodsId Integer, GoodsId_PairSun Integer) ON COMMIT DROP;
     END IF;

     -- 3.1. все остатки, СРОК
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_Partion_all_SUA'))
     THEN
       CREATE TEMP TABLE _tmpRemains_Partion_all_SUA   (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     END IF;

     -- 3.2. остатки, СРОК - для распределения
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_Partion_SUA'))
     THEN
       CREATE TEMP TABLE _tmpRemains_Partion_SUA   (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     END IF;

     -- 4. Остатки по которым есть Автозаказ и срок
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_calc_SUA'))
     THEN
       CREATE TEMP TABLE _tmpRemains_calc_SUA   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat, AmountUse TFloat) ON COMMIT DROP;
     END IF;

     -- 5. распределяем-1 остатки - по всем аптекам
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_SUA'))
     THEN
       CREATE TEMP TABLE _tmpResult_SUA   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     END IF;

     IF NOT EXISTS(SELECT Movement.id
                   FROM Movement
                   WHERE Movement.OperDate = vbOperDate
                     AND Movement.DescId = zc_Movement_FinalSUA()
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                   )
     THEN
       RETURN;
     END IF;

     SELECT Movement.id
     INTO vbMovementId
     FROM Movement
     WHERE Movement.OperDate = vbOperDate
       AND Movement.DescId = zc_Movement_FinalSUA()
       AND Movement.StatusId = zc_Enum_Status_Complete();

     -- все Товары для схемы SUN SUA
     DELETE FROM _tmpGoods_SUN_SUA;
     -- все Подразделения для схемы SUN
     DELETE FROM _tmpUnit_SUN_SUA;
     -- Выкладки
     DELETE FROM _tmpGoodsLayout_SUN_SUA;
     -- Маркетинговый план для точек
     DELETE FROM _tmpGoods_PromoUnit_SUA;
     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     DELETE FROM _tmpGoods_TP_exception_SUA;
     -- Уже использовано в текущем СУН
     DELETE FROM _tmpGoods_Sun_exception_SUA;
     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     DELETE FROM _tmpRemains_all_SUA;
     DELETE FROM _tmpRemains_SUA;
     -- 2.1 вся статистика продаж - OVER
     DELETE FROM _tmpSale_over_SUA;
     -- 2.2. NotSold
     DELETE FROM _tmpSale_not_SUA;
     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     DELETE FROM _tmpStockRatio_all_SUA;
     -- 2.5. "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
     DELETE FROM _tmpGoods_SUN_PairSun_SUA;
     -- 3.1. все остатки, СРОК
     DELETE FROM _tmpRemains_Partion_all_SUA;
     -- 3.2. остатки, СРОК - для распределения
     DELETE FROM _tmpRemains_Partion_SUA;
     -- 4. Остатки по которым есть Автозаказ и срок
     DELETE FROM _tmpRemains_calc_SUA;
     -- 5. распределяем-1 остатки - по всем аптекам
     DELETE FROM _tmpResult_SUA;



     -- все Подразделения для схемы SUN
     INSERT INTO _tmpUnit_SUN_SUA (UnitId, KoeffInSUN, KoeffOutSUN, Value_T1, Value_T2, DayIncome, DaySendSUN, DaySendSUNAll, Limit_N, isLock_CheckMSC, isLock_CloseGd, isLock_ClosePL)
        SELECT OB.ObjectId
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
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
             -- !!!только для этого водителя!!!
             /*INNER JOIN ObjectLink AS ObjectLink_Unit_Driver
                                   ON ObjectLink_Unit_Driver.ObjectId      = OB.ObjectId
                                  AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                                  AND ObjectLink_Unit_Driver.ChildObjectId = inDriverId*/
             LEFT JOIN ObjectFloat   AS OF_T1  ON OF_T1.ObjectId  = OB.ObjectId AND OF_T1.DescId  = zc_ObjectFloat_Unit_T1_SUN_v4()
             LEFT JOIN ObjectFloat   AS OF_DI  ON OF_DI.ObjectId  = OB.ObjectId AND OF_DI.DescId  = zc_ObjectFloat_Unit_Sun_v2Income()
             LEFT JOIN ObjectFloat   AS OF_DS  ON OF_DS.ObjectId  = OB.ObjectId AND OF_DS.DescId  = zc_ObjectFloat_Unit_HT_SUN_v2()
             LEFT JOIN ObjectFloat   AS OF_DSA ON OF_DSA.ObjectId = OB.ObjectId AND OF_DSA.DescId = zc_ObjectFloat_Unit_HT_SUN_All()
             LEFT JOIN ObjectFloat   AS OF_SN  ON OF_SN.ObjectId  = OB.ObjectId AND OF_SN.DescId  = zc_ObjectFloat_Unit_LimitSUN_N()
             LEFT JOIN ObjectString  AS OS_LL  ON OS_LL.ObjectId  = OB.ObjectId AND OS_LL.DescId  = zc_ObjectString_Unit_SUN_v4_Lock()
        WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUA()
          -- если указан день недели - проверим его
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = '')
       ;

     -- находим максимальный
     vbDayIncome_max:= (SELECT MAX (_tmpUnit_SUN_SUA.DayIncome) FROM _tmpUnit_SUN_SUA);

     -- находим максимальный
     vbDaySendSUN_max:= (SELECT MAX (_tmpUnit_SUN_SUA.DaySendSUN) FROM _tmpUnit_SUN_SUA);
     -- находим максимальный
     vbDaySendSUNAll_max:= (SELECT MAX (_tmpUnit_SUN_SUA.DaySendSUNAll) FROM _tmpUnit_SUN_SUA);

     -- находим максимальный
     vbPeriod_t_max := (SELECT MAX (CASE WHEN _tmpUnit_SUN_SUA.Value_T1 > _tmpUnit_SUN_SUA.Value_T2 THEN _tmpUnit_SUN_SUA.Value_T1 ELSE _tmpUnit_SUN_SUA.Value_T2 END)
                        FROM _tmpUnit_SUN_SUA
                       );

     -- значения для разделения по срокам
     SELECT Date_6, Date_3, Date_1, Date_0
     INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
     FROM lpSelect_PartionDateKind_SetDate ();


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
                     FROM _tmpUnit_SUN_SUA

                          INNER JOIN tmpMovement AS Movement ON Movement.UnitId = _tmpUnit_SUN_SUA.UnitId

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

     INSERT INTO _tmpGoods_TP_exception_SUA   (UnitId, GoodsId)
     SELECT tmpGoods.UnitId, tmpGoods.GoodsId
     FROM tmpGoods;

     -- Уже использовано в текущем СУН
     WITH
          tmpSUN AS (SELECT MovementLinkObject_From.ObjectId AS UnitId_from
                          , MovementLinkObject_To.ObjectId   AS UnitId_to
                          , MovementItem.ObjectId            AS GoodsId
                          , SUM (MovementItem.Amount)        AS Amount
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
                     WHERE Movement.OperDate = inOperDate
                       AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                     GROUP BY MovementLinkObject_From.ObjectId
                            , MovementLinkObject_To.ObjectId
                            , MovementItem.ObjectId
                    )
     -- Результат-1
     INSERT INTO _tmpGoods_Sun_exception_SUA (UnitId_from, UnitId_to, GoodsId, Amount)
        SELECT tmpSUN.UnitId_from, tmpSUN.UnitId_to, tmpSUN.GoodsId, tmpSUN.Amount
        FROM tmpSUN;

     -- все Товары для схемы SUN SUA
     INSERT INTO _tmpGoods_SUN_SUA (GoodsId, KoeffSUN)
     SELECT MovementItem.ObjectId                   AS GoodsId
          , Object_Goods_Retail.KoeffSUN_Supplementv1
     FROM MovementItem

          INNER JOIN  Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.ObjectId

     WHERE MovementItem.MovementId = vbMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = False
       AND MovementItem.Amount  > 0
     GROUP BY MovementItem.ObjectId
            , Object_Goods_Retail.KoeffSUN_Supplementv1;

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
        , tmpLayoutAll AS (SELECT _tmpGoods_SUN_SUA.GoodsId              AS GoodsId
                                , _tmpUnit_SUN_SUA.UnitId                AS UnitId
                                , tmpLayout.Amount                              AS Amount
                           FROM _tmpGoods_SUN_SUA
                           
                                INNER JOIN _tmpUnit_SUN_SUA ON 1 = 1
                                
                                LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                        ON Unit_PharmacyItem.ObjectId  = _tmpUnit_SUN_SUA.UnitId
                                                       AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
                                 
                                INNER JOIN tmpLayout ON tmpLayout.GoodsId = _tmpGoods_SUN_SUA.GoodsId

                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = _tmpUnit_SUN_SUA.UnitId

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                           WHERE (tmpLayoutUnit.UnitId = _tmpUnit_SUN_SUA.UnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) > 0)
                             AND (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR tmpLayout.isPharmacyItem = True)
                           )
                                                              
     INSERT INTO  _tmpGoodsLayout_SUN_SUA (GoodsId, UnitId, Layout) 
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

      INSERT INTO _tmpGoods_PromoUnit_SUA
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
                                
           INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = OL_UnitCategory.Objectid

           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                              AND MI_Goods.DescId = zc_MI_Master()
                                              AND MI_Goods.isErased = FALSE
                                              AND MI_Goods.Amount > 0
                                            
           INNER JOIN _tmpGoods_SUN_SUA ON _tmpGoods_SUN_SUA.GoodsId = MI_Goods.Objectid 
                                                          
           INNER JOIN tmpUserUnit ON tmpUserUnit.UnitId = OL_UnitCategory.Objectid

      WHERE Movement.StatusId = zc_Enum_Status_Complete()
        AND Movement.DescId = zc_Movement_PromoUnit()
        AND Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate);

     -- 2.2. NotSold
     -- CREATE TEMP TABLE _tmpSale_not (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     INSERT INTO _tmpSale_not_SUA (UnitId, GoodsId, Amount)
        WITH -- список для NotSold
             tmpContainer AS (SELECT Container.Id               AS ContainerId
                                   , Container.WhereObjectId    AS UnitId
                                   , Container.ObjectId         AS GoodsId
                                   , Container.Amount           AS Amount
                              FROM -- !!!только для таких Аптек!!!
                                   _tmpUnit_SUN_SUA
                                   INNER JOIN Container ON Container.WhereObjectId = _tmpUnit_SUN_SUA.UnitId
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
                                INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_To.ObjectId
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
                                 INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_To.ObjectId
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
                                 INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_From.ObjectId
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
                                       INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_Unit.ObjectId
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
                                    INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_Unit.ObjectId
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
                                    INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_Unit.ObjectId
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
                              INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = Container.WhereObjectId
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
                            INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = OL_Price_Unit.ChildObjectId
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
                         AND (MCS_isClose.ObjectId IS NULL OR _tmpUnit_SUN_SUA.isLock_ClosePL = FALSE)
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
                                   INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

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
                                   , COALESCE(tmpPrice.isCloseMCS, FALSE)                  AS isCloseMCS
                              FROM tmpPrice
                                   FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpPrice.GoodsId
                                                             AND tmpGoodsCategory.UnitId  = tmpPrice.UnitId
                              WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                 OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                                 OR COALESCE (tmpPrice.Price, 0) <> 0
                             )
     -- 2.5. Результат: все остатки у ПОЛУЧАТЕЛЯ, продажи => расчет кол-во ПОТРЕБНОСТЬ: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains_all_SUA (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve, isCloseMCS)
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
                                                  / COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
                                                   ) * COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
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
                                                 / COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
                                                  ) * COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
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
                                                 / COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
                                                  ) * COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
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
                                                  / COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
                                                   ) * COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
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
                                             / COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
                                              ) * COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
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
             , tmpObject_Price.isCloseMCS
        FROM tmpObject_Price
             -- Работают по СУН - только отправка
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_out
                                     ON OB_Unit_SUN_out.ObjectId  = tmpObject_Price.UnitId
                                    AND OB_Unit_SUN_out.DescId    = zc_ObjectBoolean_Unit_SUN_v4_out()
                                    AND OB_Unit_SUN_out.ValueData = TRUE
             -- Исключения по техническим переучетам
             LEFT JOIN _tmpGoods_TP_exception_SUA AS tmpGoods_TP_exception
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
             LEFT JOIN _tmpSale_over_SUA ON _tmpSale_over_SUA.UnitId  = tmpObject_Price.UnitId
                                    AND _tmpSale_over_SUA.GoodsId = tmpObject_Price.GoodsId

             -- товары для Кратность
             LEFT JOIN _tmpGoods_SUN_SUA ON _tmpGoods_SUN_SUA.GoodsId  = tmpObject_Price.GoodsId

             -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "потребность"
             LEFT JOIN (SELECT _tmpGoods_Sun_exception_SUA.UnitId_to, _tmpGoods_Sun_exception_SUA.GoodsId, SUM (_tmpGoods_Sun_exception_SUA.Amount) AS Amount
                        FROM _tmpGoods_Sun_exception_SUA
                        GROUP BY _tmpGoods_Sun_exception_SUA.UnitId_to, _tmpGoods_Sun_exception_SUA.GoodsId
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
             LEFT JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = tmpObject_Price.UnitId

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
          AND (ObjectBoolean_Goods_isClose.ObjectId IS NULL OR _tmpUnit_SUN_SUA.isLock_CloseGd = FALSE)
          -- Исключения по техническим переучетам
          AND COALESCE (tmpGoods_TP_exception.GoodsId, 0) = 0
       ;

     -- "Пара товара в СУН"... если в одном из видов СУН перемещается товар X, то в обязательном порядке должен перемещаться товар Y в том же количестве
     INSERT INTO _tmpGoods_SUN_PairSun_SUA (GoodsId, GoodsId_PairSun)
        SELECT OL_GoodsPairSun.ObjectId      AS GoodsId
             , OL_GoodsPairSun.ChildObjectId AS GoodsId_PairSun
        FROM ObjectLink AS OL_GoodsPairSun
        WHERE OL_GoodsPairSun.ChildObjectId > 0 AND OL_GoodsPairSun.DescId = zc_ObjectLink_Goods_GoodsPairSun()
       ;

     -- 2.6. Результат: все остатки ПОЛУЧАТЕЛЯ, продажи => получаем кол-ва ПОТРЕБНОСТЬ
     INSERT INTO  _tmpRemains_SUA (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT _tmpRemains_all_SUA.UnitId, _tmpRemains_all_SUA.GoodsId, _tmpRemains_all_SUA.Price, _tmpRemains_all_SUA.MCS, _tmpRemains_all_SUA.AmountResult, _tmpRemains_all_SUA.AmountRemains, _tmpRemains_all_SUA.AmountIncome, _tmpRemains_all_SUA.AmountSend_in, _tmpRemains_all_SUA.AmountSend_out, _tmpRemains_all_SUA.AmountOrderExternal, _tmpRemains_all_SUA.AmountReserve
        FROM _tmpRemains_all_SUA
             -- если товар среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun_SUA.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun_SUA
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_all_SUA.GoodsId

        WHERE -- !!!только с таким AmountResult!!!
              _tmpRemains_all_SUA.AmountResult >= 1.0
              -- !!!Добавили парные!!!
           OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
       ;

     -- 3.1. все остатки ОТПРАВИТЕЛЯ, PI (Сверх запас)
     INSERT INTO _tmpRemains_Partion_all_SUA (ContainerDescId, UnitId, ContainerId_Parent, ContainerId, GoodsId, Amount, Amount_notSold)
        WITH -- остатки - список для PI
             tmpContainer AS (SELECT Container.DescId           AS ContainerDescId
                                   , Container.Id               AS ContainerId
                                   , Container.WhereObjectId    AS UnitId
                                   , Container.ObjectId         AS GoodsId
                                   , Container.Amount           AS Amount
                              FROM -- !!!только для таких Аптек!!!
                                   _tmpUnit_SUN_SUA
                                   INNER JOIN Container ON Container.WhereObjectId = _tmpUnit_SUN_SUA.UnitId
                                                       AND Container.Amount        <> 0
                                                       AND Container.DescId        = zc_Container_Count()
                                   -- то что НЕ попадает в потребность
                                   LEFT JOIN _tmpRemains_SUA ON _tmpRemains_SUA.UnitId       = _tmpUnit_SUN_SUA.UnitId
                                                            AND _tmpRemains_SUA.GoodsId      = Container.ObjectId
                                                            AND _tmpRemains_SUA.AmountResult > 0
                                   -- если товар среди парных
                                   LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun_SUA.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun_SUA
                                             ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = Container.ObjectId
                              WHERE _tmpRemains_SUA.GoodsId IS NULL
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
                               LEFT JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = OL_Price_Unit.ChildObjectId

                          WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                            -- товары "убит код"
                            AND (MCS_isClose.ObjectId IS NULL OR _tmpUnit_SUN_SUA.isLock_ClosePL = FALSE)
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

                                  INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_To.ObjectId

                                  -- !!!только для таких товаров!!!
                                  INNER JOIN tmpOver_list ON tmpOver_list.UnitId  = MovementLinkObject_To.ObjectId
                                                         AND tmpOver_list.GoodsID = MovementItem.ObjectId

                             WHERE Movement.OperDate BETWEEN inOperDate - (vbDaySendSUN_max :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                               AND Movement.DescId   = zc_Movement_Send()
                               AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                             GROUP BY MovementLinkObject_To.ObjectId
                                    , MovementItem.ObjectId
                             HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (_tmpUnit_SUN_SUA.DaySendSUN :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
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
                                     -- INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_To.ObjectId
                                     --
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                                            AND MovementItem.Amount     > 0

                                     LEFT JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_To.ObjectId

                                WHERE Movement.OperDate BETWEEN inOperDate - (vbDaySendSUNAll_max :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                  AND Movement.DescId   = zc_Movement_Send()
                                  AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                                GROUP BY MovementLinkObject_To.ObjectId
                                       , MovementItem.ObjectId
                                HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (_tmpUnit_SUN_SUA.DaySendSUNAll :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
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
                                            WHEN _tmpSale_not_SUA.GoodsID > 0
                                                 THEN tmpOver_list.Amount

                                            -- отдаем ВСЕ
                                            WHEN _tmpSale_not_SUA.GoodsID > 0
                                                 THEN tmpOver_list.Amount

                                            -- оставляем 1
                                            WHEN COALESCE (_tmpSale_over_SUA.Amount_t1, 0) < 1
                                                 THEN FLOOR (tmpOver_list.Amount - 1)

                                            --  Отправка: округляем ВВНИЗ: если X1 больше Y1 на 1 и больше: Y1 - продажи у отправителя в разрезе T1=60 дней;
                                            ELSE FLOOR (tmpOver_list.Amount - CASE WHEN COALESCE (tmpMCS.MCSValue, 0) > COALESCE (_tmpSale_over_SUA.Amount_t1, 0)
                                                                                        THEN COALESCE (tmpMCS.MCSValue, 0)
                                                                                   ELSE COALESCE (_tmpSale_over_SUA.Amount_t1, 0)
                                                                              END
                                                       )
                                       END AS Amount_notSold
                                FROM tmpOver_list
                                     LEFT JOIN _tmpSale_over_SUA ON _tmpSale_over_SUA.UnitId  = tmpOver_list.UnitId
                                                            AND _tmpSale_over_SUA.GoodsID = tmpOver_list.GoodsID
                                     LEFT JOIN _tmpSale_not_SUA ON _tmpSale_not_SUA.UnitId  = tmpOver_list.UnitId
                                                           AND _tmpSale_not_SUA.GoodsID = tmpOver_list.GoodsID
                                     LEFT JOIN tmpMCS ON tmpMCS.UnitId  = tmpOver_list.UnitId
                                                     AND tmpMCS.GoodsID = tmpOver_list.GoodsID
                                     -- !!!SUN - за X дней - если приходило, уходить уже не может!!!
                                     LEFT JOIN tmpSUN_Send ON tmpSUN_Send.UnitId_to = tmpOver_list.UnitId
                                                          AND tmpSUN_Send.GoodsID   = tmpOver_list.GoodsID
                                     -- !!!SUN всех - за X дней - если приходило, уходить уже не может!!!
                                     LEFT JOIN tmpSUN_SendAll ON tmpSUN_SendAll.UnitId_to = tmpOver_list.UnitId
                                                             AND tmpSUN_SendAll.GoodsId   = tmpOver_list.GoodsID
                                     -- отгружать товар по СУН, если у него остаток больше чем N
                                     LEFT JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitID = tmpOver_list.UnitId

                                    -- если товар среди парных
                                    LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun_SUA.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun_SUA
                                              ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = tmpOver_list.GoodsID

                                WHERE -- !!!
                                      tmpSUN_Send.GoodsId IS NULL
                                  AND tmpSUN_SendAll.GoodsId IS NULL
                                      -- !!!
                                  AND CASE -- отдаем ВСЕ - это парный
                                           WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
                                                THEN tmpOver_list.Amount

                                           -- отдаем ВСЕ
                                           WHEN _tmpSale_not_SUA.GoodsID > 0
                                                THEN tmpOver_list.Amount

                                           -- оставляем 1
                                           WHEN COALESCE (_tmpSale_over_SUA.Amount_t1, 0) < 1
                                                THEN FLOOR (tmpOver_list.Amount - 1)

                                           --  Отправка: округляем ВВНИЗ: если X1 больше Y1 на 1 и больше: Y1 - продажи у отправителя в разрезе T1=60 дней;
                                           ELSE FLOOR (tmpOver_list.Amount - CASE WHEN COALESCE (tmpMCS.MCSValue, 0) > COALESCE (_tmpSale_over_SUA.Amount_t1, 0)
                                                                                       THEN COALESCE (tmpMCS.MCSValue, 0)
                                                                                  ELSE COALESCE (_tmpSale_over_SUA.Amount_t1, 0)
                                                                             END)
                                      END > 0

                                  AND (-- остаток больше чем N
                                       COALESCE (_tmpUnit_SUN_SUA.Limit_N, 0) < tmpOver_list.Amount
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

                                     INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_To.ObjectId
                                                                AND _tmpUnit_SUN_SUA.DayIncome > 0

                                WHERE MovementDate_Branch.DescId     = zc_MovementDate_Branch()
                                  AND MovementDate_Branch.ValueData BETWEEN inOperDate - (vbDayIncome_max :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'

                                GROUP BY MovementLinkObject_To.ObjectId
                                       , MovementItem.ObjectId
                                HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (_tmpUnit_SUN_SUA.DayIncome :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
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
                              INNER JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = MovementLinkObject_From.ObjectId
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

     -- 3.2. остатки ОТПРАВИТЕЛЯ, PI (Сверх запас) - для распределения
     WITH -- Goods_sum
          tmpGoods_sum AS (SELECT _tmpRemains_Partion_all_SUA.UnitId
                                , _tmpRemains_Partion_all_SUA.GoodsId
                                  -- остатки, ВСЕ
                                , SUM (_tmpRemains_Partion_all_SUA.Amount)         AS Amount
                                  -- остатки, PI (Сверх запас) - их и будем распределять
                                , SUM (_tmpRemains_Partion_all_SUA.Amount_notSold) AS Amount_notSold
                           FROM _tmpRemains_Partion_all_SUA
                           GROUP BY _tmpRemains_Partion_all_SUA.UnitId
                                  , _tmpRemains_Partion_all_SUA.GoodsId
                          )
               -- MCS + Price
             , tmpMCS AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                               , OL_Price_Goods.ChildObjectId      AS GoodsId
                               , Price_Value.ValueData             AS Price
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
                               INNER JOIN tmpGoods_sum ON tmpGoods_sum.UnitId  = OL_Price_Unit.ChildObjectId
                                                      AND tmpGoods_sum.GoodsId = OL_Price_Goods.ChildObjectId
                               -- !!!
                               LEFT JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = OL_Price_Unit.ChildObjectId

                          WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                            -- товары "убит код"
                            AND (MCS_isClose.ObjectId IS NULL OR _tmpUnit_SUN_SUA.isLock_ClosePL = FALSE)
                         )
        -- отбросили !!холод!!
      , tmpConditionsKeep AS (SELECT OL_Goods_ConditionsKeep.ObjectId
                              FROM ObjectLink AS OL_Goods_ConditionsKeep
                                   LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = OL_Goods_ConditionsKeep.ChildObjectId
                              WHERE OL_Goods_ConditionsKeep.ObjectId IN (SELECT DISTINCT _tmpRemains_Partion_all_SUA.GoodsId FROM _tmpRemains_Partion_all_SUA)
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
                              --AND 1=0
                             )
       -- Результат: все остатки, PI (Сверх запас) - для распределения
       INSERT INTO _tmpRemains_Partion_SUA (ContainerDescId, UnitId, GoodsId, MCSValue, Amount_sale, Amount, Amount_save, Amount_real)
          SELECT 0 AS ContainerDescId
               , tmp.UnitId
               , tmp.GoodsId
               , COALESCE (tmpMCS.MCSValue, 0) AS MCSValue

                 -- продажи у отправителя в разрезе T1=60 дней
               , COALESCE (_tmpSale.Amount_t1, 0) AS Amount_sale

                 -- остатки, PI (Сверх запас) - их и будем распределять
               , FLOOR ((tmp.Amount_notSold
                       - COALESCE (_tmpRemains_all_SUA.AmountReserve, 0)
                         -- уменьшаем - Перемещение - расход (ожидается)
                       - COALESCE (_tmpRemains_all_SUA.AmountSend_out, 0)
                         -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "излишки"
                       - COALESCE (tmpSUN_oth.Amount, 0)
                         -- НЕ уменьшаем еще на НТЗ
                         -- - COALESCE (tmpMCS.MCSValue, 0)
                          -- делим на кратность
                        ) / COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
                       ) * COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
                 AS Amount

                 -- остатки, ВСЕ
               , tmp.Amount             AS Amount_save

                 -- остатки, PI (Сверх запас) без корректировки
               , tmp.Amount_notSold     AS Amount_real


          FROM tmpGoods_sum AS tmp
               -- остатки ОТПРАВИТЕЛЯ
               LEFT JOIN _tmpRemains_all_SUA ON _tmpRemains_all_SUA.UnitId  = tmp.UnitId
                                        AND _tmpRemains_all_SUA.GoodsId = tmp.GoodsId
               -- НТЗ
               LEFT JOIN tmpMCS ON tmpMCS.UnitId  = tmp.UnitId
                               AND tmpMCS.GoodsId = tmp.GoodsId
               -- продажи
               LEFT JOIN _tmpSale_over_SUA AS _tmpSale ON _tmpSale.UnitId  = tmp.UnitId
                                                      AND _tmpSale.GoodsId = tmp.GoodsId
               -- товары для Кратность
               LEFT JOIN _tmpGoods_SUN_SUA ON _tmpGoods_SUN_SUA.GoodsId = tmp.GoodsId
               -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "излишки"
               LEFT JOIN (SELECT _tmpGoods_Sun_exception_SUA.UnitId_from, _tmpGoods_Sun_exception_SUA.GoodsId, SUM (_tmpGoods_Sun_exception_SUA.Amount) AS Amount
                          FROM _tmpGoods_Sun_exception_SUA
                          GROUP BY _tmpGoods_Sun_exception_SUA.UnitId_from, _tmpGoods_Sun_exception_SUA.GoodsId
                         ) AS tmpSUN_oth
                           ON tmpSUN_oth.UnitId_from = tmp.UnitId
                          AND tmpSUN_oth.GoodsId     = tmp.GoodsId
               -- а здесь, отбросили !!холод!!
               LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = tmp.GoodsId
               -- а здесь, отбросили !!НОТ!!
               LEFT JOIN tmpGoods_NOT ON tmpGoods_NOT.ObjectId = tmp.GoodsId

          -- маленькое кол-во не распределяем
          WHERE FLOOR ((tmp.Amount_notSold
                        -- уменьшаем - отложенные Чеки + не проведенные с CommentError
                      - COALESCE (_tmpRemains_all_SUA.AmountReserve, 0)
                        -- уменьшаем - Перемещение - расход (ожидается)
                      - COALESCE (_tmpRemains_all_SUA.AmountSend_out, 0)
                        -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "излишки"
                      - COALESCE (tmpSUN_oth.Amount, 0)
                        -- НЕ уменьшаем еще на НТЗ
                        -- - COALESCE (tmpMCS.MCSValue, 0)
                         -- делим на кратность
                       ) / COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
                      ) * COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 1)
                > 1
            -- отбросили !!холод!!
            AND tmpConditionsKeep.ObjectId IS NULL
            -- отбросили !!НОТ!!
            AND tmpGoods_NOT.ObjectId IS NULL
          ;

     -- Правим количество распределения если остаток меньше отгружать товар по СУН , если у него остаток больше чем N
     UPDATE _tmpRemains_Partion_SUA SET Amount = FLOOR (CASE WHEN _tmpRemains_Partion_SUA.Amount_save - COALESCE(_tmpUnit_SUN_SUA.Limit_N, 0) <= 0 THEN 0
                                                         ELSE  _tmpRemains_Partion_SUA.Amount_save - COALESCE(_tmpUnit_SUN_SUA.Limit_N, 0) END)
     FROM _tmpUnit_SUN_SUA
     WHERE _tmpRemains_Partion_SUA.UnitId = _tmpUnit_SUN_SUA.UnitId
       AND COALESCE(_tmpUnit_SUN_SUA.Limit_N, 0) > 0
       AND _tmpRemains_Partion_SUA.Amount_save - _tmpRemains_Partion_SUA.Amount < COALESCE(_tmpUnit_SUN_SUA.Limit_N, 0);

               WITH
                   MI_Master AS (SELECT MovementItem.ObjectId                   AS GoodsId
                                      , MILinkObject_Unit.ObjectId              AS UnitId
                                      , SUM(MovementItem.Amount)                AS Amount
                                 FROM MovementItem

                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                      ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                 WHERE MovementItem.MovementId = vbMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.isErased = False
                                   AND MovementItem.Amount > 0
                                 GROUP BY MovementItem.ObjectId
                                        , MILinkObject_Unit.ObjectId
                                 )
                 , tmpContainer AS (SELECT MI_Master.GoodsId                  AS GoodsId
                                         , MI_Master.UnitId                   AS UnitId
                                         , Sum(Container.Amount)::TFloat      AS Amount
                                    FROM MI_Master
                                      
                                         INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                             AND Container.ObjectId = MI_Master.GoodsId
                                                             AND Container.WhereObjectId = MI_Master.UnitId
                                                             AND Container.Amount <> 0
                                    GROUP BY MI_Master.GoodsId
                                           , MI_Master.UnitId
                                    )
                 , tmpObject_Price AS (
                        SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , COALESCE (ObjectBoolean_Price_MCSIsClose.ValueData, False) AS MCSIsClose
                             , Price_Goods.ChildObjectId               AS GoodsId
                             , ObjectLink_Price_Unit.ChildObjectId     AS UnitId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Price_MCSIsClose
                                                   ON ObjectBoolean_Price_MCSIsClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND ObjectBoolean_Price_MCSIsClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId IN (SELECT MI_Master.UnitId FROM MI_Master)
                        )

     -- 4. Остатки по которым есть ПОТРЕБНОСТЬ и СУА
     INSERT INTO _tmpRemains_calc_SUA (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve
                                 , AmountSun_real, AmountSun_summ, AmountSun_summ_save, AmountSun_unit, AmountSun_unit_save, AmountUse)
        SELECT MovementItem.UnitId          AS UnitId
             , MovementItem.GoodsId         AS GoodsId
               -- Цена
             , _tmpRemains_SUA.Price
               -- НТЗ
             , _tmpRemains_SUA.MCS
               -- ПОТРЕБНОСТЬ у получателя - что перемещено - остаток
             , CEIL(MovementItem.Amount - COALESCE (tmpSUN_oth.Amount, 0) - COALESCE (Container.Amount, 0)) AS AmountResult
               --
             , _tmpRemains_SUA.AmountRemains
             , _tmpRemains_SUA.AmountIncome
             , _tmpRemains_SUA.AmountSend_in
             , _tmpRemains_SUA.AmountSend_out
             , _tmpRemains_SUA.AmountOrderExternal
             , _tmpRemains_SUA.AmountReserve

               -- остатки, PI (Сверх запас) без корректировки
             , tmpRemains_Partion_sum.Amount_real       AS AmountSun_real
               -- остатки, PI (Сверх запас) - их и будем распределять
             , tmpRemains_Partion_sum.Amount            AS AmountSun_summ
               -- остатки, ВСЕ
             , tmpRemains_Partion_sum.Amount_save       AS AmountSun_summ_save

               -- инф.=0, сроковые на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
             , COALESCE (_tmpRemains_Partion_SUA.Amount, 0)      AS AmountSun_unit
               -- инф.=0, сроковые на этой аптеке
             , COALESCE (_tmpRemains_Partion_SUA.Amount_save, 0) AS AmountSun_unit_save
             , 0                                                 AS AmountUse

        FROM MI_Master AS MovementItem


             LEFT JOIN _tmpRemains_SUA ON _tmpRemains_SUA.UnitId  = MovementItem.UnitId
                                       AND _tmpRemains_SUA.GoodsId = MovementItem.GoodsId

             -- итого у ОТПРАВИТЕЛЯ - PI (Сверх запас) которые будем распределять - здесь и парные и обычные
             LEFT JOIN (SELECT _tmpRemains_Partion_SUA.GoodsId, SUM (_tmpRemains_Partion_SUA.Amount) AS Amount, SUM (_tmpRemains_Partion_SUA.Amount_save) AS Amount_save, SUM (_tmpRemains_Partion_SUA.Amount_real) AS Amount_real
                         FROM _tmpRemains_Partion_SUA
                         GROUP BY _tmpRemains_Partion_SUA.GoodsId
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = MovementItem.GoodsId

             -- PI (Сверх запас) на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
             LEFT JOIN _tmpRemains_Partion_SUA ON _tmpRemains_Partion_SUA.UnitId  = MovementItem.UnitId
                                              AND _tmpRemains_Partion_SUA.GoodsId = MovementItem.GoodsId
             -- если товар среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun_SUA.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun_SUA
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = MovementItem.GoodsId

             -- все что "сейчас" отправлено по ВСЕ SUN-кроме текущего - уменьшаем "потребность"
             LEFT JOIN (SELECT _tmpGoods_Sun_exception_SUA.UnitId_to, _tmpGoods_Sun_exception_SUA.GoodsId, SUM (_tmpGoods_Sun_exception_SUA.Amount) AS Amount
                        FROM _tmpGoods_Sun_exception_SUA
                        GROUP BY _tmpGoods_Sun_exception_SUA.UnitId_to, _tmpGoods_Sun_exception_SUA.GoodsId
                       ) AS tmpSUN_oth
                         ON tmpSUN_oth.UnitId_to = MovementItem.UnitId
                        AND tmpSUN_oth.GoodsId   = MovementItem.GoodsId
                        
             LEFT JOIN tmpContainer AS Container
                                    ON Container.UnitId = MovementItem.UnitId
                                   AND Container.GoodsId   = MovementItem.GoodsId  

             LEFT JOIN tmpObject_Price ON tmpObject_Price.UnitId = MovementItem.UnitId
                                      AND tmpObject_Price.GoodsId   = MovementItem.GoodsId  

        WHERE CEIL(MovementItem.Amount - COALESCE (tmpSUN_oth.Amount, 0) - COALESCE (Container.Amount, 0)) >= 1
          AND _tmpGoods_SUN_PairSun_find.GoodsId_PairSun IS NULL
          AND COALESCE (tmpObject_Price.MCSIsClose, False) = False
     ;


/*
raise notice 'Value: %', (select Count(*) from _tmpRemains_calc_SUA);

return;
*/


     -- 6. распределяем
     --
     -- курсор1 - все что можно распределить
     OPEN curPartion_next FOR
        SELECT _tmpRemains_Partion_SUA.UnitId AS UnitId_from
             , _tmpRemains_Partion_SUA.GoodsId
             , FLOOR (_tmpRemains_Partion_SUA.Amount - 
                         CASE WHEN (Amount_save - _tmpRemains_Partion_SUA.Amount) < 
                                   (COALESCE(_tmpGoodsLayout_SUN_SUA.Layout, 0) + COALESCE(_tmpGoods_PromoUnit_SUA.Amount, 0))
                              THEN (COALESCE(_tmpGoodsLayout_SUN_SUA.Layout, 0) + COALESCE(_tmpGoods_PromoUnit_SUA.Amount, 0)) -
                                   (Amount_save - _tmpRemains_Partion_SUA.Amount)
                              ELSE 0 END)  AS Amount
            -- , _tmpRemains_Partion_SUA.Amount_save AS Amount_save
             , COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 0)

        FROM _tmpRemains_Partion_SUA
             -- товары - для Кратность
             LEFT JOIN _tmpGoods_SUN_SUA ON _tmpGoods_SUN_SUA.GoodsId = _tmpRemains_Partion_SUA.GoodsId
             -- товар есть среди парных
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun_SUA.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun_SUA
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_Partion_SUA.GoodsId

             LEFT JOIN _tmpGoodsLayout_SUN_SUA ON _tmpGoodsLayout_SUN_SUA.GoodsID = _tmpRemains_Partion_SUA.GoodsId
                                                     AND _tmpGoodsLayout_SUN_SUA.UnitId = _tmpRemains_Partion_SUA.UnitId  

             LEFT JOIN _tmpGoods_PromoUnit_SUA ON _tmpGoods_PromoUnit_SUA.GoodsID = _tmpRemains_Partion_SUA.GoodsId
                                                    AND _tmpGoods_PromoUnit_SUA.UnitId = _tmpRemains_Partion_SUA.UnitId  
                        

        WHERE -- !!!Отключили парные!!!
              _tmpGoods_SUN_PairSun_find.GoodsId_PairSun IS NULL
          AND FLOOR (_tmpRemains_Partion_SUA.Amount  - 
                         CASE WHEN (Amount_save - _tmpRemains_Partion_SUA.Amount) < 
                                   (COALESCE(_tmpGoodsLayout_SUN_SUA.Layout, 0) + COALESCE(_tmpGoods_PromoUnit_SUA.Amount, 0))
                              THEN (COALESCE(_tmpGoodsLayout_SUN_SUA.Layout, 0) + COALESCE(_tmpGoods_PromoUnit_SUA.Amount, 0)) -
                                   (Amount_save - _tmpRemains_Partion_SUA.Amount)
                              ELSE 0 END) >= 1
        ORDER BY _tmpRemains_Partion_SUA.Amount DESC, _tmpRemains_Partion_SUA.UnitId, _tmpRemains_Partion_SUA.GoodsId
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbSurplus, vbKoeffSUN;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         -- курсор2. - Потребность для vbGoodsId
         OPEN curResult_next FOR
             SELECT _tmpRemains_calc_SUA.UnitId
                  , CASE WHEN COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 0) = 0 THEN
                      FLOOR (_tmpRemains_calc_SUA.AmountResult  - _tmpRemains_calc_SUA.AmountUse)
                    ELSE
                      FLOOR ((_tmpRemains_calc_SUA.AmountResult  - _tmpRemains_calc_SUA.AmountUse) / COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 0)

                    END
             FROM _tmpRemains_calc_SUA

                  LEFT JOIN _tmpGoods_SUN_SUA ON _tmpGoods_SUN_SUA.GoodsID = _tmpRemains_calc_SUA.GoodsId
                  LEFT JOIN _tmpUnit_SUN_SUA ON _tmpUnit_SUN_SUA.UnitId = _tmpRemains_calc_SUA.UnitId

             WHERE (CASE WHEN COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 0) = 0 THEN
                      FLOOR (_tmpRemains_calc_SUA.AmountResult  - _tmpRemains_calc_SUA.AmountUse)
                    ELSE
                      FLOOR ((_tmpRemains_calc_SUA.AmountResult  - _tmpRemains_calc_SUA.AmountUse) / COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_SUA.KoeffSUN, 0)

                    END) >= 1
               AND _tmpRemains_calc_SUA.GoodsId = vbGoodsId
               AND _tmpRemains_calc_SUA.UnitId <> vbUnitId_from
             ORDER BY 2 DESC
                    , _tmpRemains_calc_SUA.UnitId;
         -- начало цикла по курсору2 - остаток сроковых - под него надо найти Автозаказ
         LOOP
             -- данные по Автозаказ
             FETCH curResult_next INTO vbUnitId_to, vbNeed;
             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR vbSurplus < 1 THEN EXIT; END IF;

/*             IF vbUnitId_to = 377610 AND vbGoodsId = 12918138
             THEN
               raise notice 'Value 05: % % % % % %', vbUnitId_from, vbUnitId_to, vbGoodsId, vbNeed, vbSurplus, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END;
             END IF;

*/
             INSERT INTO _tmpResult_SUA (UnitId_from, UnitId_to, GoodsId, Amount)
               VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END);

             UPDATE _tmpRemains_calc_SUA SET AmountUse = AmountUse + CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END
             WHERE _tmpRemains_calc_SUA.UnitId = vbUnitId_to
               AND _tmpRemains_calc_SUA.GoodsId = vbGoodsId;

             vbSurplus := vbSurplus - CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END;

         END LOOP; -- финиш цикла по курсору2
         CLOSE curResult_next; -- закрыли курсор2.

     END LOOP; -- финиш цикла по курсору1
     CLOSE curPartion_next; -- закрыли курсор1

     -- Результат
     RETURN QUERY
       SELECT Object_Goods.Id                            AS GoodsId
            , Object_Goods_Main.ObjectCode               AS GoodsCode
            , Object_Goods_Main.Name                     AS GoodsName
            , Object_Goods_Main.isClose                  AS isClose

            , Object_Unit_From.Id                        AS UnitId_From
            , Object_Unit_From.ValueData                 AS UnitName_From
            , tmpRemains_From.AmountRemains              AS Remains_From
            , _tmpGoodsLayout_SUN_SUA.Layout             AS Layout_From
            , _tmpGoods_PromoUnit_SUA.Amount             AS PromoUnit_From

            , Object_Unit_To.Id                          AS UnitId_To
            , Object_Unit_To.ValueData                   AS UnitName_To

            , tmpRemains_To.AmountRemains                AS Remains_To
            , _tmpResult_SUA.Amount                      AS Amount

            , tmpRemains_From.Price
            , tmpRemains_To.Price
            
            , COALESCE(tmpRemains_From.isCloseMCS, FALSE)
            , COALESCE(tmpRemains_To.isCloseMCS, FALSE)


       FROM _tmpResult_SUA

            LEFT JOIN Object AS Object_Unit_From  ON Object_Unit_From.Id  = _tmpResult_SUA.UnitId_From


            LEFT JOIN Object AS Object_Unit_To  ON Object_Unit_To.Id  = _tmpResult_SUA.UnitId_to

            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = _tmpResult_SUA.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

            LEFT JOIN _tmpRemains_all_SUA AS tmpRemains_From
                                          ON tmpRemains_From.UnitId = _tmpResult_SUA.UnitId_From
                                         AND tmpRemains_From.GoodsId = _tmpResult_SUA.GoodsId

            LEFT JOIN _tmpRemains_all_SUA AS tmpRemains_To
                                          ON tmpRemains_To.UnitId = _tmpResult_SUA.UnitId_To
                                         AND tmpRemains_To.GoodsId = _tmpResult_SUA.GoodsId

            LEFT JOIN _tmpGoodsLayout_SUN_SUA ON _tmpGoodsLayout_SUN_SUA.GoodsID = _tmpResult_SUA.GoodsId
                                             AND _tmpGoodsLayout_SUN_SUA.UnitId = _tmpResult_SUA.UnitId_from

            LEFT JOIN _tmpGoods_PromoUnit_SUA ON _tmpGoods_PromoUnit_SUA.GoodsID = _tmpResult_SUA.GoodsId
                                             AND _tmpGoods_PromoUnit_SUA.UnitId = _tmpResult_SUA.UnitId_from 

       ORDER BY Object_Goods.Id
              , Object_Unit_From.ValueData
              , Object_Unit_To.ValueData
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий 0.В.
 12.02.21                                                     *
*/

--
--
--SELECT * FROM lpInsert_Movement_Send_RemainsSun_SUA (inOperDate:= ('19.04.2021')::TDateTime, inDriverId:= 0, inUserId:= 3); -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ

-- 
-- select * from gpReport_Movement_Send_RemainsSun_SUA(inOperDate := ('12.04.2021')::TDateTime ,  inSession := '3');