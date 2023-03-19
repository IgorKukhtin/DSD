-- Function: lpInsert_Movement_Send_RemainsSun_express

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_express (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_express(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inDriverId            Integer   , -- Водитель, распределяем только по аптекам этого
    IN inStep                Integer   , -- на 1-ом шаге находим DefSUN - если 2 дня есть в перемещении, т.к. < vbSumm_limit - тогда на 2-м шаге они участвовать не будут !!!
    IN inUserId              Integer     -- пользователь
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount_sale         TFloat -- Кол-во продажа у Получателя (статистика за Х*24 часов)
             , Summ_sale           TFloat -- Сумма  продажа у Получателя (статистика за Х*24 часов)
           --, AmountSun_real      TFloat -- ***сумма сроковых по реальным остаткам, должно сходиться с AmountSun_summ_save
           --, AmountSun_summ_save TFloat -- ***сумма сроковых, без учета изменения
             , AmountSun_summ      TFloat -- Итого кол-во для распределения по всем точкам отправителям
           --, AmountSunOnly_summ  TFloat -- ***сумма сроковых, которые будем распределять
           --, Amount_notSold_summ TFloat -- ***сумма notSold, которые будем распределять

             , AmountResult        TFloat -- Потребность у точки получателя
             , AmountResult_summ   TFloat -- Итого потребность у ВСЕХ точек получателей --инф
             , AmountRemains       TFloat -- Остаток
             , AmountRemains_calc  TFloat -- Остаток
             , AmountIncome        TFloat -- Приход (ожидаемый) --инф
             , AmountSend_in       TFloat -- Перемещение - приход (ожидается) --инф
             , AmountSend_out      TFloat -- Перемещение - расход (ожидается) --инф
             , AmountOrderExternal TFloat -- Заказ (ожидаемый) --инф
             , AmountReserve       TFloat -- Резерв по чекам --инф
           --, AmountSun_unit      TFloat -- ***инф.=0, сроковые на этой аптеке, тогда перемещения с других аптек не будет, т.е. этот Автозаказ не учитываем
           --, AmountSun_unit_save TFloat -- ***инф.=0, сроковые на этой аптеке, без учета изменения
             , Price               TFloat -- Цена
             , MCS                 TFloat -- НТЗ
             , Layout              TFloat -- Выкладка
             , PromoUnit           TFloat -- Марк. план длч точки
             , Summ_min            TFloat -- информативно - мнимальн сумма
             , Summ_max            TFloat -- информативно - максимальн сумма
             , Unit_count          TFloat -- информативно - кол-во таких накл.
             , Summ_min_1          TFloat -- информативно - после распределения-1: мнимальн сумма
             , Summ_max_1          TFloat -- информативно - после распределения-1: максимальн сумма
             , Unit_count_1        TFloat -- информативно - после распределения-1: кол-во таких накл.
           --, Summ_min_2          TFloat -- ***информативно - после распределения-2: мнимальн сумма
           --, Summ_max_2          TFloat -- ***информативно - после распределения-2: максимальн сумма
           --, Unit_count_2        TFloat -- ***информативно - после распределения-2: кол-во таких накл.
             , Summ_str            TVarChar --
           --, Summ_next_str       TVarChar -- ***
             , UnitName_str        TVarChar
           --, UnitName_next_str   TVarChar -- ***
               -- !!!результат!!!
             , Amount_res          TFloat   -- Кол-во распределено - перемещение приход
             , Summ_res            TFloat   -- Сумма распределено - перемещение приход
           --, Amount_next_res     TFloat   -- ***
           --, Summ_next_res       TFloat   -- ***
              )
AS
$BODY$
   DECLARE vbObjectId Integer;

   DECLARE vbKoeff_express TFloat;

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

   DECLARE vbDOW_curr        Integer;
   DECLARE vbisEliminateColdSUN Boolean;
   DECLARE vbisOnlyColdSUN Boolean;
   DECLARE vbisShoresSUN Boolean;
   DECLARE vbisCancelBansSUN Boolean;

BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);



     -- !!!
     vbSumm_limit:= CASE WHEN 0 < (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                              THEN 0 -- (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                         ELSE 0 -- 1500
                    END;

     SELECT COALESCE(ObjectBoolean_CashSettings_EliminateColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_ShoresSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_OnlyColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_CancelBansSUN.ValueData, FALSE) 
     INTO vbisEliminateColdSUN, vbisShoresSUN, vbisOnlyColdSUN, vbisCancelBansSUN
     FROM Object AS Object_CashSettings
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_EliminateColdSUN
                                  ON ObjectBoolean_CashSettings_EliminateColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_EliminateColdSUN.DescId = zc_ObjectBoolean_CashSettings_EliminateColdSUN3()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_ShoresSUN
                                  ON ObjectBoolean_CashSettings_ShoresSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_ShoresSUN.DescId = zc_ObjectBoolean_CashSettings_ShoresSUN()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_OnlyColdSUN
                                  ON ObjectBoolean_CashSettings_OnlyColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_OnlyColdSUN.DescId = zc_ObjectBoolean_CashSettings_OnlyColdSUN3()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_CancelBansSUN
                                  ON ObjectBoolean_CashSettings_CancelBansSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_CancelBansSUN.DescId = zc_ObjectBoolean_CashSettings_CancelBansSUN()
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;

    -- дата + 6 месяцев
    vbDate_6:= inOperDate
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object AS Object_PartionDateKind
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

     -- все Подразделения для схемы SUN-v2
     DELETE FROM _tmpUnit_SUN;
     DELETE FROM _tmpGoods_Layout;
     DELETE FROM _tmpGoods_PromoUnit;
     DELETE FROM _tmpGoods_DiscountExternal;
     -- 1. все остатки, продажи => получаем ВСЕ кол-ва EXPRESS
     DELETE FROM _tmpRemains_all;
     DELETE FROM _tmpRemains;
     -- 2.1. вся статистика продаж - express: 1) у отправителя  2) у получателя
     DELETE FROM _tmpSale_express;
     -- 2.3. товары для Кратность
     DELETE FROM _tmpGoods_express;
     -- 3.2. остатки, EXPRESS - для распределения
     DELETE FROM _tmpRemains_Partion;
     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     DELETE FROM _tmpSumm_limit;
     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам - здесь НЕ только >= vbSumm_limit
     DELETE FROM _tmpResult_Partion;


     -- день недели
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  );

raise notice 'Value 1: %', CLOCK_TIMESTAMP();

     -- все Подразделения для схемы SUN-v3
     INSERT INTO _tmpUnit_SUN (UnitId, isSUN_out, isSUN_in, isColdOutSUN)
        SELECT OB.ObjectId AS UnitId
               -- коэф суточного запаса получателя - определяется приход
             , COALESCE (OB_Unit_SUN_out.ValueData, False)
               -- коэф суточного запаса отправителя - определяется расход
             , COALESCE (OB_Unit_SUN_in.ValueData, False)
             , COALESCE (OB_ColdOutSUN.ValueData, FALSE)                       AS isColdOutSUN
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectString  AS OS_ListDaySUN    ON OS_ListDaySUN.ObjectId    = OB.ObjectId AND OS_ListDaySUN.DescId    = zc_ObjectString_Unit_ListDaySUN()

             -- Работают по СУН - только отправка
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_out
                                     ON OB_Unit_SUN_out.ObjectId  = OB.ObjectId 
                                    AND OB_Unit_SUN_out.DescId    = zc_ObjectBoolean_Unit_SUN_v3_out()

             -- Работают по СУН - только прием
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_in
                                     ON OB_Unit_SUN_in.ObjectId  =  OB.ObjectId 
                                    AND OB_Unit_SUN_in.DescId    = zc_ObjectBoolean_Unit_SUN_v3_in()
                                    
             -- !!!только для этого водителя!!!
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Driver
                                  ON ObjectLink_Unit_Driver.ObjectId      = OB.ObjectId 
                                 AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
             LEFT JOIN Object AS Object_Driver ON Object_Driver.Id = ObjectLink_Unit_Driver.ChildObjectId

             LEFT JOIN ObjectBoolean AS OB_ColdOutSUN    
                                     ON OB_ColdOutSUN.ObjectId    = OB.ObjectId 
                                    AND OB_ColdOutSUN.DescId    = zc_ObjectBoolean_Unit_ColdOutSUN()
                                    
        WHERE (OB.ValueData = TRUE) AND (OB_Unit_SUN_out.ValueData = TRUE OR OB_Unit_SUN_in.ValueData = TRUE)
          AND OB.DescId = zc_ObjectBoolean_Unit_SUN_v3()          
          -- если указан день недели - проверим его
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' AND vbisShoresSUN = False  OR
               OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 4 OR
               OS_ListDaySUN.ValueData ILIKE '%' || CASE WHEN vbDOW_curr - 1 = 0 THEN 7 ELSE vbDOW_curr - 1 END::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 3)
                 ;
                 
     ANALYSE _tmpUnit_SUN;

raise notice 'Value 2: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM _tmpUnit_SUN);

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

raise notice 'Value 3: %', CLOCK_TIMESTAMP();


      -- товары для Кратность
      INSERT INTO _tmpGoods_express (GoodsId, KoeffSUN)
         SELECT OF_KoeffSUN.ObjectId  AS GoodsId
              , OF_KoeffSUN.ValueData AS KoeffSUN
         FROM ObjectFloat AS OF_KoeffSUN
         WHERE OF_KoeffSUN.DescId    = zc_ObjectFloat_Goods_KoeffSUN_v1()
           AND OF_KoeffSUN.ValueData > 0
        ;
        
      ANALYSE _tmpGoods_express;

raise notice 'Value 4: %', CLOCK_TIMESTAMP();

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

raise notice 'Value 5: %', CLOCK_TIMESTAMP();


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

raise notice 'Value 6: %', CLOCK_TIMESTAMP();

     -- 1.1. вся статистика продаж
     INSERT INTO _tmpSale_express (UnitId, GoodsId, Amount, Summ)
        SELECT MIContainer.WhereObjectId_analyzer                                                      AS UnitId
             , MIContainer.ObjectId_analyzer                                                           AS GoodsId
             , SUM (COALESCE (-1 * MIContainer.Amount, 0))                                             AS Amount
             , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0))            AS Summ
        FROM MovementItemContainer AS MIContainer
             -- !!!только для таких Аптек!!!
             INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MIContainer.WhereObjectId_analyzer
                                    AND _tmpUnit_SUN.isSUN_in = TRUE
        WHERE MIContainer.DescId         = zc_MIContainer_Count()
          AND MIContainer.MovementDescId = zc_Movement_Check()
          AND MIContainer.OperDate BETWEEN inOperDate - INTERVAL '61 DAY' AND inOperDate
        GROUP BY MIContainer.ObjectId_analyzer
               , MIContainer.WhereObjectId_analyzer
        HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
       ;
       
     ANALYSE _tmpSale_express;

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

raise notice 'Value 7: %', CLOCK_TIMESTAMP();


     -- 2.1. все остатки, продажи => расчет кол-ва ПОТРЕБНОСТЬ у получателя
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
                                 LEFT JOIN MovementBoolean AS MB_SUN_v3
                                                           ON MB_SUN_v3.MovementId = Movement.Id
                                                          AND MB_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                                          AND MB_SUN_v3.ValueData  = TRUE
                                                          AND Movement.OperDate    >= inOperDate
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '30 DAY' AND Movement.OperDate < inOperDate + INTERVAL '30 DAY'
                           -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           -- AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                              AND MB_SUN_v3.MovementId IS NULL
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
                                 LEFT JOIN MovementBoolean AS MB_SUN_v3
                                                           ON MB_SUN_v3.MovementId = Movement.Id
                                                          AND MB_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                                          AND MB_SUN_v3.ValueData  = TRUE
                                                          AND Movement.OperDate    >= inOperDate
                         -- WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '14 DAY' AND Movement.OperDate < inOperDate + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              AND MovementBoolean_Deferred.MovementId IS NULL
                              AND MB_SUN_v3.MovementId IS NULL
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
                           AND (Container.Amount <> 0 OR _tmpUnit_SUN.isSUN_in = TRUE)
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
    -- цены
  , tmpObject_Price AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                             , OL_Price_Goods.ChildObjectId      AS GoodsId
                             , ROUND (Price_Value.ValueData, 2)  AS Price
                             , MCS_Value.ValueData               AS MCSValue
                        FROM ObjectLink AS OL_Price_Unit
                             -- !!!только для таких Аптек!!!
                             INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_Price_Unit.ChildObjectId
                           --LEFT JOIN ObjectBoolean AS MCS_isClose
                           --                        ON MCS_isClose.ObjectId = OL_Price_Unit.ObjectId
                           --                       AND MCS_isClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
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
                        WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        --AND COALESCE (MCS_isClose.ValueData, FALSE) = FALSE
                       )

     -- 2.1. Результат: EXPRESS - все остатки, продажи => расчет кол-во ПОТРЕБНОСТЬ у получателя: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains_all (UnitId, GoodsId, Price, MCS, Amount_sale, Summ_sale
                                 , AmountResult_in, AmountResult_out
                                 , AmountRemains, AmountRemains_calc_in, AmountRemains_calc_out
                                 , AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue

               -- продажа у Отправителя/Получателя (статистика за Х*24 часов - накопительно) 
             , COALESCE (_tmpSale_express.Amount, 0) AS Amount_sale
             , COALESCE (_tmpSale_express.Summ, 0)   AS Summ_sale

               -- потребность у Получателя, EXPRESS
             , CASE WHEN 0 < FLOOR (-- продажи - статистика за Х*24 часов
                                    (COALESCE (_tmpSale_express.Amount * CASE WHEN COALESCE (tmpRemains.Amount, 0) = 0 THEN 2 ELSE 0 END, 0)
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
                                     END)
                                    -- делим на кратность
                                    / COALESCE(_tmpGoods_express.KoeffSUN, 1)
                                   ) * COALESCE(_tmpGoods_express.KoeffSUN, 1)
                         AND _tmpUnit_SUN.isSUN_in = TRUE
                        THEN FLOOR (-- продажи - статистика за Х*24 часов
                                    (COALESCE (_tmpSale_express.Amount * CASE WHEN COALESCE (tmpRemains.Amount, 0) = 0 THEN 2 ELSE 0 END, 0)
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
                                     END)
                                    -- делим на кратность
                                    / COALESCE(_tmpGoods_express.KoeffSUN, 1)
                                   ) * COALESCE(_tmpGoods_express.KoeffSUN, 1)
                        ELSE 0
               END AS AmountResult_in

               -- Остаток у Отправителя, EXPRESS - можно отдать с учетом кратности
             , CASE WHEN 0 < FLOOR (-- остаток
                                    (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) - COALESCE (tmpMI_Send_out.Amount, 0)
                                    )
                                    -- делим на кратность
                                    / COALESCE(_tmpGoods_express.KoeffSUN, 1)
                                   ) * COALESCE(_tmpGoods_express.KoeffSUN, 1)
                         AND _tmpUnit_SUN.isSUN_out = TRUE AND _tmpUnit_SUN.isSUN_in = FALSE
                        THEN FLOOR (-- остаток
                                    (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) - COALESCE (tmpMI_Send_out.Amount, 0)
                                    )
                                    -- делим на кратность
                                    / COALESCE(_tmpGoods_express.KoeffSUN, 1)
                                   ) * COALESCE(_tmpGoods_express.KoeffSUN, 1)
                        ELSE 0
               END AS AmountResult_out

               -- Остаток без корректировки
             , COALESCE (tmpRemains.Amount, 0)           AS AmountRemains

               -- остаток - расчет - для получателя
             , COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) - COALESCE (tmpMI_Send_out.Amount, 0)
             + COALESCE (tmpMI_Send_in.Amount, 0)
             + COALESCE (tmpMI_Income.Amount, 0)
             + COALESCE (tmpMI_OrderExternal.Amount, 0) 
               AS AmountRemains_calc_in

               -- остаток - расчет - для отправителя
             , COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
               AS AmountRemains_calc_out

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

        FROM tmpRemains 

             LEFT JOIN tmpObject_Price AS tmpObject_Price
                                       ON tmpObject_Price.UnitId = tmpRemains.UnitId
                                      AND tmpObject_Price.GoodsId = tmpRemains.GoodsId

             LEFT JOIN _tmpGoods_express ON _tmpGoods_express.GoodsId  = tmpObject_Price.GoodsId
             LEFT JOIN _tmpUnit_SUN      ON _tmpUnit_SUN.UnitId        = tmpObject_Price.UnitId

             LEFT JOIN _tmpSale_express AS _tmpSale_express
                                        ON _tmpSale_express.UnitId  = tmpObject_Price.UnitId
                                       AND _tmpSale_express.GoodsId = tmpObject_Price.GoodsId

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

             -- отбросили !!закрытые!!
           --INNER JOIN Object_Goods_View ON Object_Goods_View.Id      = tmpObject_Price.GoodsId
           --                            AND Object_Goods_View.IsClose = FALSE
             -- отбросили !!акционные!!
           --INNER JOIN Object AS Object_Goods ON Object_Goods.Id        = tmpObject_Price.GoodsId
           --                                 AND Object_Goods.ValueData NOT ILIKE 'ААА%' 
       ;
     
  ANALYSE _tmpRemains_all;
       
raise notice 'Value 8: %', CLOCK_TIMESTAMP();

       
     -- 2.2. Результат: все остатки, продажи => получаем кол-ва ПОТРЕБНОСТЬ у получателя
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, AmountResult)
        SELECT _tmpRemains_all.UnitId, _tmpRemains_all.GoodsId, _tmpRemains_all.Price, _tmpRemains_all.AmountResult_in
        FROM _tmpRemains_all
        -- !!!только с таким AmountResult!!!
        WHERE _tmpRemains_all.AmountResult_in > 0.0
       ;
       
     ANALYSE _tmpRemains;

raise notice 'Value 9: %', CLOCK_TIMESTAMP();


     -- 3.1. остатки, EXPRESS (можно отдать с учетом кратности) - для распределения
     WITH -- так можно определить EXPRESS
             tmpExpress_all AS (SELECT *
                                FROM _tmpRemains_all
                                WHERE _tmpRemains_all.AmountResult_out > 0
                             -- WHERE 1=0
                               )
     -- для EXPRESS - находим ВСЕ сроковые
   , tmpExpress_PartionDate AS (SELECT tmpExpress_all.UnitID
                                     , tmpExpress_all.GoodsID
                                     , SUM (Container.Amount) AS Amount
                                FROM tmpExpress_all
                                     INNER JOIN Container AS Container_main ON Container_main.WhereObjectId = tmpExpress_all.UnitId
                                                                           AND Container_main.ObjectId      = tmpExpress_all.GoodsID
                                     INNER JOIN Container ON Container.ParentId = Container_main.Id
                                                         AND Container.DescId   = zc_Container_CountPartionDate()
                                                         AND Container.Amount   > 0
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                          ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                         AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                WHERE ObjectDate_PartionGoods_Value.ValueData <= CURRENT_DATE + INTERVAL '200 DAY'
                                GROUP BY tmpExpress_all.UnitID
                                       , tmpExpress_all.GoodsID
                                HAVING SUM (Container.Amount) > 0
                               )
       -- Перемещение EXPRESS - расход - Erased - за СЕГОДНЯ, что б не отправлять эти товары повторно в СУН-3
     , tmpMI_SUN_out AS (SELECT MovementLinkObject_From.ObjectId AS UnitId_from
                              , MovementItem.ObjectId            AS GoodsId
                              , SUM(MovementItem.Amount)         AS Amount
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
                              LEFT JOIN MovementBoolean AS MB_SUN_v3
                                                        ON MB_SUN_v3.MovementId = Movement.Id
                                                       AND MB_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                                       AND MB_SUN_v3.ValueData  = TRUE
                         WHERE Movement.OperDate = inOperDate
                           AND Movement.DescId   = zc_Movement_Send()
                           AND Movement.StatusId = zc_Enum_Status_Erased()
                           AND MB_SUN_v3.MovementId IS NULL
                         GROUP BY MovementLinkObject_From.ObjectId
                                , MovementItem.ObjectId  
                        )
                 -- все что остается для NotSold
               , tmpExpress AS (SELECT tmpExpress_all.UnitID
                                     , tmpExpress_all.GoodsID
                                     , tmpExpress_all.AmountRemains - COALESCE (tmpExpress_PartionDate.Amount, 0) - COALESCE (tmpMI_SUN_out.Amount, 0) AS AmountRemains
                                     , tmpExpress_all.AmountResult_out - COALESCE (tmpExpress_PartionDate.Amount, 0) - COALESCE (tmpMI_SUN_out.Amount, 0) AS AmountResult_out
                                FROM tmpExpress_all
                                     -- ВСЕ сроковые
                                     LEFT JOIN tmpExpress_PartionDate ON tmpExpress_PartionDate.UnitId  = tmpExpress_all.UnitID
                                                                     AND tmpExpress_PartionDate.GoodsID = tmpExpress_all.GoodsID
                                     -- !!!Перемещение SUN - расход - Erased - за СЕГОДНЯ, что б не отправлять эти товары повторно в СУН-3
                                     LEFT JOIN tmpMI_SUN_out ON tmpMI_SUN_out.UnitId_from = tmpExpress_all.UnitID
                                                            AND tmpMI_SUN_out.GoodsId     = tmpExpress_all.GoodsId
                               )
       -- Результат: все остатки, EXPRESS - для распределения
       INSERT INTO _tmpRemains_Partion (UnitId, GoodsId, AmountRemains, AmountResult)
          SELECT tmpExpress.UnitId
               , tmpExpress.GoodsId
               , tmpExpress.AmountRemains
                 -- остаток - расчет реал., EXPRESS (можно отдать с учетом кратности)
               , tmpExpress.AmountResult_out AS AmountResult
          FROM tmpExpress
          -- маленькое кол-во не распределяем
          WHERE tmpExpress.AmountResult_out > 0
         ;
         
       ANALYSE _tmpRemains_Partion;

raise notice 'Value 10: %', CLOCK_TIMESTAMP();

     -- 5. из каких аптек остатки EXPRESS "максимально" закрывают ПОТРЕБНОСТЬ
     INSERT INTO _tmpSumm_limit (UnitId_from, UnitId_to, Summ)
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from
             , _tmpRemains.UnitId         AS UnitId_to
               -- если EXPRESS больше чем в ПОТРЕБНОСТЬ
             , SUM (CASE WHEN _tmpRemains_Partion.AmountResult >= _tmpRemains.AmountResult
                              -- тогда EXPRESS = ПОТРЕБНОСТЬ
                              THEN _tmpRemains.AmountResult
                              -- иначе закрываем "частично" - т.е. сколько есть EXPRESS - с учетом Кратности
                              ELSE FLOOR (_tmpRemains_Partion.AmountResult / COALESCE(_tmpGoods_express.KoeffSUN, 1)) * COALESCE(_tmpGoods_express.KoeffSUN, 1)
                    END
                  * _tmpRemains.Price
                   )
        FROM -- Остатки по которым есть ПОТРЕБНОСТЬ
             _tmpRemains
             -- все остатки, EXPRESS
             INNER JOIN _tmpRemains_Partion ON _tmpRemains_Partion.GoodsId = _tmpRemains.GoodsId
             -- все товары для статистики продаж - express
             LEFT JOIN _tmpGoods_express ON _tmpGoods_express.GoodsId = _tmpRemains.GoodsId
        GROUP BY _tmpRemains_Partion.UnitId
               , _tmpRemains.UnitId
       ;
       
     ANALYSE _tmpSumm_limit;

raise notice 'Value 11: %', CLOCK_TIMESTAMP();

     -- 6.1.1. распределяем-1 остатки EXPRESS (Сверх запас) - по всем аптекам
     -- курсор1 - все остатки, EXPRESS (Сверх запас) + EXPRESS (Сверх запас) без корректировки
     OPEN curPartion FOR
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from
             , _tmpRemains_Partion.GoodsId
             , _tmpRemains_Partion.AmountResult - COALESCE(_tmpRemains_all.MCS, 0) - COALESCE(_tmpGoods_Layout.Layout, 0) - COALESCE(_tmpGoods_PromoUnit.Amount, 0)
             , _tmpRemains_Partion.AmountRemains
             , COALESCE(_tmpGoods_express.KoeffSUN, 1)
        FROM _tmpRemains_Partion
             -- начинаем с аптек, где расход может быть максимальным
             INNER JOIN (SELECT _tmpSumm_limit.UnitId_from, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                         -- !!!больше лимита
                       --WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                         GROUP BY _tmpSumm_limit.UnitId_from
                        ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_from = _tmpRemains_Partion.UnitId
             -- все товары для статистики продаж - express
             LEFT JOIN _tmpGoods_express ON _tmpGoods_express.GoodsId = _tmpRemains_Partion.GoodsId
             
             LEFT JOIN _tmpRemains_all ON _tmpRemains_all.UnitId = _tmpRemains_Partion.UnitId
                                      AND _tmpRemains_all.GoodsId = _tmpRemains_Partion.GoodsId

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
                                                 
        WHERE _tmpRemains_Partion.AmountResult - COALESCE(_tmpRemains_all.MCS, 0) - COALESCE(_tmpGoods_Layout.Layout, 0) - COALESCE(_tmpGoods_PromoUnit.Amount, 0) >= 1
          AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
              -- отбросили !!холод!!
          AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
              tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE OR
              _tmpUnit_SUN.isColdOutSUN = TRUE)
        ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curPartion INTO vbUnitId_from, vbGoodsId, vbAmount, vbAmount_save, vbKoeffSUN;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

         -- курсор2. - ПОТРЕБНОСТЬ МИНУС сколько уже распределили для vbGoodsId
         OPEN curResult FOR
            SELECT _tmpRemains.UnitId AS UnitId_to, _tmpRemains.AmountResult - COALESCE (tmp.Amount, 0) AS AmountResult, _tmpRemains.Price
            FROM _tmpRemains
                 -- сколько уже пришло после распределения-1
                 LEFT JOIN (SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId, SUM (_tmpResult_Partion.Amount) AS Amount FROM _tmpResult_Partion GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                           ) AS tmp ON tmp.UnitId_to = _tmpRemains.UnitId
                                   AND tmp.GoodsId   = _tmpRemains.GoodsId
                 -- + начнем с аптек, где ПОТРЕБНОСТЬ - максимальным
                 INNER JOIN (SELECT _tmpSumm_limit.UnitId_to, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                             WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from
                               -- !!!больше лимита
                             --AND _tmpSumm_limit.Summ >= vbSumm_limit
                             GROUP BY _tmpSumm_limit.UnitId_to
                            ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_to = _tmpRemains.UnitId
                 -- найдем дисконтній товар
                 LEFT JOIN _tmpGoods_DiscountExternal AS _tmpGoods_DiscountExternal
                                                      ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains.UnitId
                                                     AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains.GoodsId
            WHERE _tmpRemains.GoodsId = vbGoodsId
              AND _tmpRemains.AmountResult - COALESCE (tmp.Amount, 0) > 0
              AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
            ORDER BY --начинаем с аптек, где ПОТРЕБНОСТЬ - максимальным
                     _tmpRemains.AmountResult - COALESCE (tmp.Amount, 0) DESC
                   , tmpSumm_limit.Summ DESC
                   , _tmpRemains.UnitId
           ;
         -- начало цикла по курсору2 - остаток сроковых - под него надо найти Потребность
         LOOP
             -- данные по Потребность
             FETCH curResult INTO vbUnitId_to, vbAmountResult, vbPrice;
             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             -- если Потребность > Остаток
             IF vbAmountResult > vbAmount
             THEN
                 -- если в остатках "дробное" - отдаем "всю дробную часть", т.к. нельзя что б дробная была более чем в 1-ой аптеке
                 -- получилось в Потребность больше чем в остатках, т.е. отдаем весь "Остаток"
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, MovementId, MovementItemId)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                           -- с учетом кратности - vbKoeffSUN
                         , FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN
                         , FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN * vbPrice
                           --
                         , 0 AS MovementId
                         , 0 AS MovementItemId
                    WHERE FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN > 0
                   ;
                 -- обнуляем кол-во что бы больше не искать
                 vbAmount     := 0;
                 vbAmount_save:= 0;
             ELSE
                 -- если в Автозаказ "дробное" - отдаем "всю дробную часть", т.к. нельзя что б дробная была более чем в 1-ой аптеке
                 -- получилось в остатках больше чем надо, т.е. отдаем сколько надо и крутим дальше
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, MovementId, MovementItemId)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                           -- здесь уже кратность учтена
                         , vbAmountResult
                         , vbAmountResult * vbPrice
                           --
                         , 0 AS MovementId
                         , 0 AS MovementItemId
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

raise notice 'Value 12: %', CLOCK_TIMESTAMP();


     -- Результат
     RETURN QUERY
       WITH -- итоги Result по отправителям/получателям
            tmpSumm_res_list AS (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ) AS Summ FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to)
       -- Результат
       SELECT Object_Unit.Id          AS UnitId
            , Object_Unit.ValueData   AS UnitName
            , Object_Goods.Id         AS GoodsId
            , Object_Goods.ObjectCode AS GoodsCode
            , Object_Goods.ValueData  AS GoodsName

              -- продажа у Получателя (статистика за Х*24 часов)
            , _tmpRemains_calc.Amount_sale AS Amount_sale
            , _tmpRemains_calc.Summ_sale   AS Summ_sale

              -- Итого кол-во для распределения по всем точкам отправителям
            , tmpRemains_Partion_sum.AmountResult :: TFloat AS AmountSun_summ

              -- Потребность у точки получателя
            , _tmpRemains_calc.AmountResult_in    :: TFloat AS AmountResult
              -- Итого потребность у ВСЕХ точек получателей --инф
            , tmpRemains_sum.AmountResult         :: TFloat AS AmountResult_summ

              -- Остаток
            , _tmpRemains_calc.AmountRemains         AS AmountRemains
            , _tmpRemains_calc.AmountRemains_calc_in AS AmountRemains_calc

              -- Приход (ожидаемый)--инф
            , _tmpRemains_calc.AmountIncome
              -- Перемещение - приход (ожидается)--инф
            , _tmpRemains_calc.AmountSend_in
              -- Перемещение - расход (ожидается)--инф
            , _tmpRemains_calc.AmountSend_out
              -- Заказ (ожидаемый)--инф
            , _tmpRemains_calc.AmountOrderExternal
              -- Резерв по чекам + не проведенные с CommentError--инф
            , _tmpRemains_calc.AmountReserve

              -- Цена
            , _tmpRemains_calc.Price
              -- НТЗ
            , _tmpRemains_calc.MCS
              -- Выкладка
            , _tmpGoods_Layout.Layout
            , _tmpGoods_PromoUnit.Amount

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

            , tmpSumm_res1_2.Summ_str      :: TVarChar AS Summ_str
            , tmpSumm_res1_3.UnitName_str  :: TVarChar AS UnitName_str

              -- !!!результат - приход!!!
            , tmpSumm_res.Amount         :: TFloat AS Amount_res
            , tmpSumm_res.Summ           :: TFloat AS Summ_res

       FROM _tmpRemains
            INNER JOIN _tmpRemains_all AS _tmpRemains_calc
                                       ON _tmpRemains_calc.UnitId  = _tmpRemains.UnitId
                                      AND _tmpRemains_calc.GoodsId = _tmpRemains.GoodsId
            -- оставили только те, где есть Перемещения
            INNER JOIN (SELECT DISTINCT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId FROM _tmpResult_Partion
                       ) AS _tmpResult ON _tmpResult.UnitId_to = _tmpRemains_calc.UnitId
                                      AND _tmpResult.GoodsId   = _tmpRemains_calc.GoodsId

            -- информативно - "возможны" такие-то суммы
            LEFT JOIN (SELECT _tmpSumm_limit.UnitId_to, MIN (_tmpSumm_limit.Summ) AS Summ_min, MAX (_tmpSumm_limit.Summ) AS Summ_max, COUNT(*) AS Unit_count FROM _tmpSumm_limit
                       WHERE _tmpSumm_limit.Summ > 0
                       GROUP BY _tmpSumm_limit.UnitId_to
                      ) AS tmpSumm ON tmpSumm.UnitId_to = _tmpRemains_calc.UnitId

             -- Итого кол-во для распределения по всем точкам отправителям --инф
             LEFT JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.AmountResult) AS AmountResult
                        FROM _tmpRemains_Partion
                        GROUP BY _tmpRemains_Partion.GoodsId
                       ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains_calc.GoodsId
            -- Итого потребность у ВСЕХ точек получателей --инф
            LEFT JOIN (SELECT _tmpRemains.GoodsId, SUM (_tmpRemains.AmountResult) AS AmountResult FROM _tmpRemains GROUP BY _tmpRemains.GoodsId
                      ) AS tmpRemains_sum ON tmpRemains_sum.GoodsId = _tmpRemains_calc.GoodsId


            -- !!!результат!!!
            LEFT JOIN (-- собрали в 1 перемещение
                       SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                            , SUM (COALESCE (_tmpResult_Partion.Amount, 0))      AS Amount
                            , SUM (COALESCE (_tmpResult_Partion.Summ, 0))        AS Summ
                       FROM _tmpResult_Partion
                       GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                      ) AS tmpSumm_res ON tmpSumm_res.UnitId_to = _tmpRemains_calc.UnitId
                                      AND tmpSumm_res.GoodsId   = _tmpRemains_calc.GoodsId

            -- !!!информативно-1.!!!
            -- после распределения, мин/макс и кол-во отправителей
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, MIN (tmpSumm_res1.Summ) AS Summ_min, MAX (tmpSumm_res1.Summ) AS Summ_max, COUNT(*) AS Unit_count
                       FROM tmpSumm_res_list AS tmpSumm_res1
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1 ON tmpSumm_res1.UnitId_to = _tmpRemains_calc.UnitId

            -- !!!информативно-2.1.!!!
            -- после распределения, списком суммы
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (zfConvert_FloatToString (tmpSumm_res1.Summ), ';') AS Summ_str
                       FROM tmpSumm_res_list AS tmpSumm_res1
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1_2 ON tmpSumm_res1_2.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!информативно-2.2.!!!
            -- после распределения, списком суммы
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (Object.ValueData, ';') AS UnitName_str
                       FROM tmpSumm_res_list AS tmpSumm_res1
                            LEFT JOIN Object ON Object.Id = tmpSumm_res1.UnitId_from
                       -- !!!больше лимита
                       --!!!WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1_3 ON tmpSumm_res1_3.UnitId_to = _tmpRemains_calc.UnitId

            --
            --
            LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains_calc.UnitId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains_calc.GoodsId

            LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId        = _tmpRemains_calc.UnitId


            LEFT JOIN _tmpGoods_PromoUnit ON _tmpGoods_PromoUnit.UnitId = _tmpRemains.UnitId
                                         AND _tmpGoods_PromoUnit.GoodsId = _tmpRemains.GoodsId

            LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = _tmpRemains.UnitId
                                      AND _tmpGoods_Layout.GoodsId = _tmpRemains.GoodsId

       -- ORDER BY Object_Goods.ObjectCode, Object_Unit.ValueData
       ORDER BY Object_Goods.ValueData, Object_Unit.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ObjectCode
      ;

    -- RAISE EXCEPTION '<ok>';

raise notice 'Value 13: %', CLOCK_TIMESTAMP();


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.04.20                                        *
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
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, isColdOutSUN Boolean) ON COMMIT DROP;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Amount_sale TFloat, Summ_sale TFloat, AmountResult_in TFloat, AmountResult_out TFloat, AmountRemains TFloat, AmountRemains_calc_in TFloat, AmountRemains_calc_out TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains       (UnitId Integer, GoodsId Integer, Price TFloat, AmountResult TFloat) ON COMMIT DROP;

     -- 2.1. вся статистика продаж
     CREATE TEMP TABLE _tmpSale_express   (DayOrd Integer, DayOrd_real Integer, UnitId Integer, GoodsId Integer, Amount TFloat, Amount_sum TFloat, Summ TFloat, Summ_sum TFloat) ON COMMIT DROP;
     -- 2.3. все товары для статистики продаж - express
     CREATE TEMP TABLE _tmpGoods_express   (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 3.2. остатки, СРОК - для распределения
     CREATE TEMP TABLE _tmpRemains_Partion   (UnitId Integer, GoodsId Integer, AmountRemains TFloat, AmountResult TFloat) ON COMMIT DROP;

     -- 5. из каких аптек остатки со сроками "полностью" закрывают АВТОЗАКАЗ
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. распределяем-1 остатки со сроками - по всем аптекам
     CREATE TEMP TABLE _tmpResult_Partion   (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;

 SELECT * FROM lpInsert_Movement_Send_RemainsSun_express (inOperDate:= CURRENT_DATE + INTERVAL '3 DAY', inDriverId:= (SELECT MAX (OL.ChildObjectId) FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Driver()), inStep:= 1, inUserId:= 3) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
*/

select * from gpReport_Movement_Send_RemainsSun_express(inOperDate := ('06.03.2023')::TDateTime ,  inSession := '3');