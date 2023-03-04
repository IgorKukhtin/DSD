-- Function: lpInsert_Movement_Send_RemainsSun_Supplement_V2_Sum

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_Supplement_V2_Sum (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_Supplement_V2_Sum(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inDriverId            Integer   , -- Водитель, распределяем только по аптекам этого
    IN inUserId              Integer     -- пользователь
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, isClose boolean
             , UnitId_From Integer, UnitName_From TVarChar

             , UnitId_To Integer, UnitName_To TVarChar
             , Amount TFloat
             
             , MinExpirationDate TDateTime

             , MCS_From TFloat
             , Layout_From TFloat
             , PromoUnit_From TFloat
             , Price_From TFloat
             , isCloseMCS_From boolean
             , AmountRemains_From TFloat
             , Give_From TFloat

             , MCS_To TFloat
             , Price_To TFloat
             , isCloseMCS_To boolean
             , AmountRemains_To TFloat
             , Need_To TFloat

             , AmountUse_To TFloat
              )
AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbDOW_curr   TVarChar;
   DECLARE vbDate_6     TDateTime;
   DECLARE vbDate_3     TDateTime;
   DECLARE vbDate_1     TDateTime;
   DECLARE vbDate_0     TDateTime;

   DECLARE curPartion_next refcursor;
   DECLARE curResult_next  refcursor;

   DECLARE vbUnitId_from Integer;
   DECLARE vbUnitId_To Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbSurplus TFloat;
   DECLARE vbNeed TFloat;
   DECLARE vbKoeffSUN TFloat;
   DECLARE vbisEliminateColdSUN Boolean;
   DECLARE vbisOnlyColdSUN Boolean;
   DECLARE vbTurnoverMoreSUN2 TFloat;
BEGIN
     --
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     -- день недели
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;

     SELECT COALESCE(ObjectBoolean_CashSettings_EliminateColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectFloat_CashSettings_TurnoverMoreSUN2.ValueData, 1500000) 
          , COALESCE(ObjectBoolean_CashSettings_OnlyColdSUN.ValueData, FALSE) 
     INTO vbisEliminateColdSUN, vbTurnoverMoreSUN2, vbisOnlyColdSUN
     FROM Object AS Object_CashSettings
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_EliminateColdSUN
                                  ON ObjectBoolean_CashSettings_EliminateColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_EliminateColdSUN.DescId = zc_ObjectBoolean_CashSettings_EliminateColdSUN2()
          LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_TurnoverMoreSUN2
                                ON ObjectFloat_CashSettings_TurnoverMoreSUN2.ObjectId = Object_CashSettings.Id 
                               AND ObjectFloat_CashSettings_TurnoverMoreSUN2.DescId = zc_ObjectFloat_CashSettings_TurnoverMoreSUN2()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_OnlyColdSUN
                                  ON ObjectBoolean_CashSettings_OnlyColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_OnlyColdSUN.DescId = zc_ObjectBoolean_CashSettings_OnlyColdSUN2()
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;

     -- все Подразделения для схемы SUN Supplement_V2
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SUN_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SUN_Supplement_V2 (UnitId Integer, DeySupplOut Integer, DeySupplIn Integer, isSUN_Supplement_V2_in Boolean, isSUN_Supplement_V2_out Boolean, isSUN_Supplement_V2_Priority Boolean, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     END IF;

     -- все Товары для схемы SUN Supplement_V2
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_Supplement_V2 (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;
     END IF;

     -- Выкладки
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoodsLayout_SUN_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoodsLayout_SUN_Supplement_V2 (GoodsId Integer, UnitId Integer, Layout TFloat, isNotMoveRemainder6 boolean, MovementLayoutId Integer) ON COMMIT DROP;
     END IF;

     -- Маркетинговый план для точек
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_PromoUnit_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_PromoUnit_Supplement_V2 (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- Товары дисконтных проектов
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_DiscountExternal_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_DiscountExternal_Supplement_V2  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_TP_exception_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_TP_exception_Supplement_V2   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- Уже использовано в текущем СУН
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_Sun_exception_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_Sun_exception_Supplement_V2   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- Что приходило по СУН и не отдаем
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSUN_Send_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpSUN_Send_Supplement_V2 (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- Что приходило по СУН и не отдаем
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSUN_Send_SupplementAll_V2'))
     THEN
       CREATE TEMP TABLE _tmpSUN_Send_SupplementAll_V2 (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- исключаем такие перемещения
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SunExclusion_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SunExclusion_Supplement_V2 (UnitId_from Integer, UnitId_to Integer) ON COMMIT DROP;
     END IF;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_all_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpRemains_all_Supplement_V2   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountRemains TFloat, AmountNotSend TFloat, 
                                                       AmountSalesDay TFloat, Need TFloat, Give TFloat, AmountUse TFloat, 
                                                       MinExpirationDate TDateTime, isCloseMCS boolean) ON COMMIT DROP;
     END IF;

     -- 3. распределяем-1 остатки - по всем аптекам
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpResult_Supplement_V2   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     END IF;

     -- все Подразделения для схемы SUN
     DELETE FROM _tmpUnit_SUN_Supplement_V2;
     -- все Товары для схемы SUN Supplement_V2
     DELETE FROM _tmpGoods_SUN_Supplement_V2;
     -- Выкладки
     DELETE FROM _tmpGoodsLayout_SUN_Supplement_V2;
     -- Маркетинговый план для точек
     DELETE FROM _tmpGoods_PromoUnit_Supplement_V2;
     -- Товары дисконтных проектов
     DELETE FROM _tmpGoods_DiscountExternal_Supplement_V2;
     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     DELETE FROM _tmpGoods_TP_exception_Supplement_V2;
     -- Уже использовано в текущем СУН
     DELETE FROM _tmpGoods_Sun_exception_Supplement_V2;
     -- Что приходило по СУН и не отдаем
     DELETE FROM _tmpSUN_Send_Supplement_V2;
     DELETE FROM _tmpSUN_Send_SupplementAll_V2;
     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     DELETE FROM _tmpRemains_all_Supplement_V2;
     -- 3. распределяем-1 остатки - по всем аптекам
     DELETE FROM _tmpResult_Supplement_V2;
     DELETE FROM _tmpUnit_SunExclusion_Supplement_V2;
          
     WITH tmpSummaCheck AS (SELECT AnalysisContainerItem.UnitID                    AS UnitID
                                 , SUM(AnalysisContainerItem.AmountCheckSum)       AS Summa
                            FROM AnalysisContainerItem 
                            WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - Interval '31 DAY'
                            GROUP BY AnalysisContainerItem.UnitID
                            HAVING SUM(AnalysisContainerItem.AmountCheckSum) >= vbTurnoverMoreSUN2)


     -- все Подразделения для схемы SUN
     INSERT INTO _tmpUnit_SUN_Supplement_V2 (UnitId, isSUN_Supplement_V2_in, isSUN_Supplement_V2_out, isColdOutSUN)
        SELECT OB.ObjectId
             , COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_in.ValueData, FALSE)  :: Boolean   AS isSUN_Supplement_V2_in
             , COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_out.ValueData, FALSE) :: Boolean   AS isSUN_Supplement_V2_out             
             , COALESCE (OB_ColdOutSUN.ValueData, FALSE)                                       AS isColdOutSUN
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_Supplement_V2_in
                                     ON ObjectBoolean_SUN_v2_Supplement_V2_in.ObjectId = OB.ObjectId
                                    AND ObjectBoolean_SUN_v2_Supplement_V2_in.DescId = zc_ObjectBoolean_Unit_SUN_v2_Supplement_in()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_Supplement_V2_out
                                     ON ObjectBoolean_SUN_v2_Supplement_V2_out.ObjectId = OB.ObjectId
                                    AND ObjectBoolean_SUN_v2_Supplement_V2_out.DescId = zc_ObjectBoolean_Unit_SUN_v2_Supplement_out()   
             LEFT JOIN ObjectBoolean AS OB_ColdOutSUN    
                                     ON OB_ColdOutSUN.ObjectId = OB.ObjectId 
                                    AND OB_ColdOutSUN.DescId = zc_ObjectBoolean_Unit_ColdOutSUN()
             LEFT JOIN tmpSummaCheck ON tmpSummaCheck.UnitID = OB.ObjectId
        WHERE OB.ValueData = TRUE AND OB.DescId in (zc_ObjectBoolean_Unit_SUN_v2_Supplement_in(), zc_ObjectBoolean_Unit_SUN_v2_Supplement_out())
          -- если указан день недели - проверим его
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = '')
          AND (COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_in.ValueData, FALSE) = TRUE AND COALESCE (tmpSummaCheck.UnitID, 0) > 0
            OR COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_out.ValueData, FALSE) = TRUE)         
       ;

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
      INSERT INTO _tmpGoods_DiscountExternal_Supplement_V2
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
                     FROM _tmpUnit_SUN_Supplement_V2

                          INNER JOIN tmpMovement AS Movement ON Movement.UnitId = _tmpUnit_SUN_Supplement_V2.UnitId

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

     INSERT INTO _tmpGoods_TP_exception_Supplement_V2   (UnitId, GoodsId)
     SELECT tmpGoods.UnitId, tmpGoods.GoodsId
     FROM tmpGoods;

     -- Уже использовано в текущем СУН
     WITH
          tmpSUN AS (SELECT MovementLinkObject_From.ObjectId AS UnitId
                          , MovementItem.ObjectId            AS GoodsId
                          , SUM (MovementItem.Amount)        AS Amount
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
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
                            , MovementItem.ObjectId
                    )
     -- Результат-1
     INSERT INTO _tmpGoods_Sun_exception_Supplement_V2 (UnitId, GoodsId, Amount)
        SELECT tmpSUN.UnitId, tmpSUN.GoodsId, tmpSUN.Amount
        FROM tmpSUN;
     
     -- исключаем такие перемещения
     INSERT INTO _tmpUnit_SunExclusion_Supplement_V2 (UnitId_from, UnitId_to)
        SELECT COALESCE (ObjectLink_From.ChildObjectId, 0) AS UnitId_from
             , COALESCE (ObjectLink_To.ChildObjectId,   0) AS UnitId_to
        FROM Object
             INNER JOIN ObjectBoolean AS OB
                                      ON OB.ObjectId  = Object.Id
                                     AND OB.DescId    = zc_ObjectBoolean_SunExclusion_v1()
                                     AND OB.ValueData = TRUE
             LEFT JOIN ObjectLink AS ObjectLink_From
                                  ON ObjectLink_From.ObjectId = Object.Id
                                 AND ObjectLink_From.DescId   = zc_ObjectLink_SunExclusion_From()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN_Supplement_V2 AS _tmpUnit_SUN_From ON ObjectLink_From.ChildObjectId IS NULL

             LEFT JOIN ObjectLink AS ObjectLink_To
                                  ON ObjectLink_To.ObjectId = Object.Id
                                 AND ObjectLink_To.DescId   = zc_ObjectLink_SunExclusion_To()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN_Supplement_V2 AS _tmpUnit_SUN_To ON ObjectLink_To.ChildObjectId IS NULL

        WHERE Object.DescId   = zc_Object_SunExclusion()
          AND Object.isErased = FALSE
           ;

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
     
           
     -- Что приходило по СУН и не отдаем
     WITH
     tmpUnit AS (SELECT OB.ObjectId AS UnitId
                      ,  COALESCE(NULLIF(OF_DS.ValueData, 0), 10):: Integer AS DaySendSUN
                 FROM ObjectBoolean AS OB
                      LEFT JOIN ObjectFloat   AS OF_DS            ON OF_DS.ObjectId            = OB.ObjectId AND OF_DS.DescId            = zc_ObjectFloat_Unit_HT_SUN_v2()
                 WHERE OB.ValueData = TRUE AND OB.DescId in (zc_ObjectBoolean_Unit_SUN_v2_Supplement_in(), zc_ObjectBoolean_Unit_SUN_v2_Supplement_out())
                 ),
     tmpSUN_Send AS (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                          , MovementItem.ObjectId            AS GoodsId
                     FROM Movement
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

                          LEFT JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                     WHERE Movement.OperDate BETWEEN inOperDate - ((SELECT MAX(tmpUnit.DaySendSUN) AS DaySendSUNAll FROM tmpUnit) :: TVarChar || ' DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                       AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                     GROUP BY MovementLinkObject_To.ObjectId
                            , MovementItem.ObjectId
                     HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (tmpUnit.DaySendSUN :: TVarChar || ' DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                           THEN MovementItem.Amount
                                      ELSE 0
                                 END) > 0
                    )
                            
     INSERT INTO _tmpSUN_Send_Supplement_V2 (UnitId, GoodsId)
     SELECT tmpSUN_Send.UnitId_to, tmpSUN_Send.GoodsId FROM tmpSUN_Send;     

     -- Что приходило по СУН и не отдаем
     WITH
     tmpUnit AS (SELECT OB.ObjectId AS UnitId
                      , COALESCE (OF_DSA.ValueData, 0):: Integer AS DaySendSUN
                 FROM ObjectBoolean AS OB
                      LEFT JOIN ObjectFloat   AS OF_DSA           ON OF_DSA.ObjectId           = OB.ObjectId AND OF_DSA.DescId           = zc_ObjectFloat_Unit_HT_SUN_All()
                 WHERE OB.ValueData = TRUE AND OB.DescId in (zc_ObjectBoolean_Unit_SUN_v2_Supplement_in(), zc_ObjectBoolean_Unit_SUN_v2_Supplement_out()) AND COALESCE (OF_DSA.ValueData, 0) > 0
                 ),
     tmpSUN_Send AS (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                          , MovementItem.ObjectId            AS GoodsId
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                          LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                                   AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                   
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                                                 AND MovementItem.Amount     > 0

                          LEFT JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                     WHERE Movement.OperDate BETWEEN inOperDate - ((SELECT MAX(tmpUnit.DaySendSUN) AS DaySendSUNAll FROM tmpUnit) :: TVarChar || ' DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                       AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                       AND COALESCE (MovementBoolean_SUN.ValueData, False) = False
                     GROUP BY MovementLinkObject_To.ObjectId
                            , MovementItem.ObjectId
                     HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (tmpUnit.DaySendSUN :: TVarChar || ' DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                           THEN MovementItem.Amount
                                      ELSE 0
                                 END) > 0
                    )
                            
     INSERT INTO _tmpSUN_Send_SupplementAll_V2 (UnitId, GoodsId)
     SELECT tmpSUN_Send.UnitId_to, tmpSUN_Send.GoodsId FROM tmpSUN_Send;
     
     -- исключаем такие перемещения
     INSERT INTO _tmpUnit_SunExclusion_Supplement_V2 (UnitId_from, UnitId_to)
        SELECT COALESCE (ObjectLink_From.ChildObjectId, 0) AS UnitId_from
             , COALESCE (ObjectLink_To.ChildObjectId,   0) AS UnitId_to
        FROM Object
             INNER JOIN ObjectBoolean AS OB
                                      ON OB.ObjectId  = Object.Id
                                     AND OB.DescId    = zc_ObjectBoolean_SunExclusion_v1()
                                     AND OB.ValueData = TRUE
             LEFT JOIN ObjectLink AS ObjectLink_From
                                  ON ObjectLink_From.ObjectId = Object.Id
                                 AND ObjectLink_From.DescId   = zc_ObjectLink_SunExclusion_From()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN_Supplement_V2 AS _tmpUnit_SUN_From ON ObjectLink_From.ChildObjectId IS NULL

             LEFT JOIN ObjectLink AS ObjectLink_To
                                  ON ObjectLink_To.ObjectId = Object.Id
                                 AND ObjectLink_To.DescId   = zc_ObjectLink_SunExclusion_To()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN_Supplement_V2 AS _tmpUnit_SUN_To ON ObjectLink_To.ChildObjectId IS NULL

        WHERE Object.DescId   = zc_Object_SunExclusion()
          AND Object.isErased = FALSE
           ;

     -- все Товары для схемы SUN Supplement_V2
     INSERT INTO _tmpGoods_SUN_Supplement_V2 (GoodsId, KoeffSUN)
        SELECT Object_Goods_Retail.ID
             , Object_Goods_Retail.KoeffSUN_V2
        FROM Object_Goods_Retail
             INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                         AND Object_Goods_Main.isSupplementSUN2 = TRUE
                                         AND Object_Goods_Main.isNOT_SUN_v2 = False
             LEFT JOIN ObjectBoolean AS ObjectBoolean_ColdSUN
                                     ON ObjectBoolean_ColdSUN.ObjectId = Object_Goods_Main.ConditionsKeepId
                                    AND ObjectBoolean_ColdSUN.DescId = zc_ObjectBoolean_ConditionsKeep_ColdSUN()
        WHERE Object_Goods_Retail.RetailID = vbObjectId
          AND ((COALESCE (ObjectBoolean_ColdSUN.ValueData, FALSE) = FALSE AND
               Object_Goods_Main.isColdSUN = FALSE OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
               (COALESCE (ObjectBoolean_ColdSUN.ValueData, FALSE) = TRUE OR
               Object_Goods_Main.isColdSUN = TRUE) AND vbisOnlyColdSUN = TRUE
               );
               
                             
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
        , tmpLayoutAll AS (SELECT _tmpGoods_SUN_Supplement_V2.GoodsId              AS GoodsId
                                , _tmpUnit_SUN_Supplement_V2.UnitId                AS UnitId
                                , tmpLayout.Amount                              AS Amount
                           FROM _tmpGoods_SUN_Supplement_V2
                           
                                INNER JOIN _tmpUnit_SUN_Supplement_V2 ON 1 = 1
                                
                                LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                        ON Unit_PharmacyItem.ObjectId  = _tmpUnit_SUN_Supplement_V2.UnitId
                                                       AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
                                 
                                INNER JOIN tmpLayout ON tmpLayout.GoodsId = _tmpGoods_SUN_Supplement_V2.GoodsId

                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = _tmpUnit_SUN_Supplement_V2.UnitId

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                           WHERE (tmpLayoutUnit.UnitId = _tmpUnit_SUN_Supplement_V2.UnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                             AND (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR tmpLayout.isPharmacyItem = True)
                           )
                                                              
     INSERT INTO  _tmpGoodsLayout_SUN_Supplement_V2 (GoodsId, UnitId, Layout) 
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

      INSERT INTO _tmpGoods_PromoUnit_Supplement_V2
      SELECT MI_Goods.UnitId                         AS UnitId
           , MI_Goods.GoodsId                        AS GoodsId
           , MI_Goods.Amount * tmpUserUnit.CountUser AS Amount

      FROM gpSelect_PromoUnit_UnitGoods (inOperDate := inOperDate, inSession := inUserId::TVarChar) AS MI_Goods

           INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = MI_Goods.UnitId
                                                          
           INNER JOIN _tmpGoods_SUN_Supplement_V2 ON _tmpGoods_SUN_Supplement_V2.GoodsId = MI_Goods.GoodsId
           
           INNER JOIN tmpUserUnit ON tmpUserUnit.UnitId = MI_Goods.UnitId           
      ;
      
 --raise notice 'Value 05: %', (select Count(*) from _tmpGoods_PromoUnit_Supplement_V2);      

     -- 1. все остатки
     --
     WITH tmpRemainsPD AS (SELECT Container.ParentId
                                , Container.Amount
                                , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())    AS ExpirationDate
                           FROM Container
                                -- !!!только для таких Аптек!!!
                                INNER JOIN _tmpGoods_SUN_Supplement_V2 ON _tmpGoods_SUN_Supplement_V2.GoodsId = Container.ObjectId
                                INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = Container.WhereObjectId
                                LEFT JOIN _tmpGoods_TP_exception_Supplement_V2 ON _tmpGoods_TP_exception_Supplement_V2.GoodsId = Container.ObjectId
                                                                AND _tmpGoods_TP_exception_Supplement_V2.UnitId = Container.WhereObjectId

                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = Container.Id
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                     ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                    AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                           WHERE Container.DescId = zc_Container_CountPartionDate()
                             AND Container.Amount <> 0
                             AND COALESCE (_tmpGoods_TP_exception_Supplement_V2.GoodsId, 0) = 0
                          )
        , tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (tmpRemainsPD.Amount, Container.Amount, 0))                              AS Amount
                              , SUM (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) <= CURRENT_DATE + INTERVAL '100 DAY'
                                          THEN COALESCE (tmpRemainsPD.Amount, Container.Amount, 0)
                                          ELSE 0 END)                                                                         AS AmountNotSend
                              , MIN (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) >= CURRENT_DATE + INTERVAL '100 DAY'
                                          THEN COALESCE (tmpRemainsPD.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd())
                                          ELSE zc_DateEnd() END)                                                              AS MinExpirationDate
                         FROM Container
                              -- !!!только для таких Аптек!!!
                              INNER JOIN _tmpGoods_SUN_Supplement_V2 ON _tmpGoods_SUN_Supplement_V2.GoodsId = Container.ObjectId
                              INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = Container.WhereObjectId
                              LEFT JOIN _tmpGoods_TP_exception_Supplement_V2 ON _tmpGoods_TP_exception_Supplement_V2.GoodsId = Container.ObjectId
                                                              AND _tmpGoods_TP_exception_Supplement_V2.UnitId = Container.WhereObjectId
                                                              
                              LEFT JOIN tmpRemainsPD ON tmpRemainsPD.ParentId = Container.Id
 
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                              -- элемент прихода
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                              LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                               ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id, MI_Income.Id) 
                                                              AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                           AND COALESCE (_tmpGoods_TP_exception_Supplement_V2.GoodsId, 0) = 0
                           --AND COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) > CURRENT_DATE + INTERVAL '30 DAY'
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
                            INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = OL_Price_Unit.ChildObjectId
                            INNER JOIN ObjectLink AS OL_Price_Goods
                                                  ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                 AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            INNER JOIN _tmpGoods_SUN_Supplement_V2 ON _tmpGoods_SUN_Supplement_V2.GoodsId = OL_Price_Goods.ChildObjectId
                            INNER JOIN Object AS Object_Goods
                                              ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                            -- AND Object_Goods.isErased = FALSE
                            LEFT JOIN ObjectBoolean AS MCS_isClose
                                                    ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                   AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
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
                       --  AND COALESCE(MCS_isClose.ValueData, FALSE) = TRUE
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
                                   INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

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
                               --    INNER JOIN _tmpGoods_SUN_Supplement_V2 ON _tmpGoods_SUN_Supplement_V2.GoodsId = ObjectLink_Child_retail.ChildObjectId
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
     -- 1. Результат: все остатки, НТЗ => получаем кол-ва автозаказа: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains_all_Supplement_V2 (UnitId, GoodsId, Price, MCS, AmountRemains, AmountNotSend,  
                                              MinExpirationDate, isCloseMCS)
        SELECT _tmpUnit_SUN_Supplement_V2.UnitId
             , _tmpGoods_SUN_Supplement_V2.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue

               -- остаток
             , CASE WHEN COALESCE (tmpRemains.Amount - COALESCE (_tmpGoods_Sun_exception_Supplement_V2.Amount, 0), 0) > 0
                    THEN COALESCE (tmpRemains.Amount - COALESCE (_tmpGoods_Sun_exception_Supplement_V2.Amount, 0), 0) ELSE 0 END AS AmountRemains
             , COALESCE (tmpRemains.AmountNotSend, 0)                                                                         AS AmountNotSend
               -- реализация
             , tmpRemains.MinExpirationDate
             , COALESCE (tmpObject_Price.isCloseMCS, FALSE)  AS isCloseMCS
             
        FROM _tmpGoods_SUN_Supplement_V2
        
             LEFT JOIN _tmpUnit_SUN_Supplement_V2 ON 1 = 1
        
        
             LEFT JOIN tmpPrice AS tmpObject_Price ON tmpObject_Price.UnitId = _tmpUnit_SUN_Supplement_V2.UnitId
                                                  AND tmpObject_Price.GoodsId = _tmpGoods_SUN_Supplement_V2.GoodsId

             LEFT JOIN tmpRemains AS tmpRemains
                                  ON tmpRemains.UnitId  = _tmpUnit_SUN_Supplement_V2.UnitId
                                 AND tmpRemains.GoodsId = _tmpGoods_SUN_Supplement_V2.GoodsId
                                 
             LEFT JOIN _tmpGoods_Sun_exception_Supplement_V2 ON _tmpGoods_Sun_exception_Supplement_V2.UnitId  = tmpObject_Price.UnitId
                                              AND _tmpGoods_Sun_exception_Supplement_V2.GoodsId = tmpObject_Price.GoodsId
                                              
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id =  tmpObject_Price.UnitId

       ;
       
       UPDATE _tmpRemains_all_Supplement_V2 SET Need = T1.Need
       FROM (SELECT _tmpRemains_all_Supplement_V2.GoodsId
                  , SUM(_tmpRemains_all_Supplement_V2.AmountRemains) / Count(*) AS Need
             FROM _tmpRemains_all_Supplement_V2
             GROUP BY _tmpRemains_all_Supplement_V2.GoodsId) AS T1
       WHERE _tmpRemains_all_Supplement_V2.GoodsId = T1.GoodsId;

       UPDATE _tmpRemains_all_Supplement_V2 SET Give = T1.Give 
       FROM (SELECT _tmpRemains_all_Supplement_V2.UnitId
                  , _tmpRemains_all_Supplement_V2.GoodsId
                  , COALESCE (_tmpRemains_all_Supplement_V2.AmountRemains, 0) - 
                    CASE WHEN COALESCE (_tmpRemains_all_Supplement_V2.AmountNotSend, 0) > COALESCE (_tmpRemains_all_Supplement_V2.Need, 0)
                         THEN COALESCE (_tmpRemains_all_Supplement_V2.AmountNotSend, 0)
                         ELSE COALESCE (_tmpRemains_all_Supplement_V2.Need, 0) END AS Give 
             FROM _tmpRemains_all_Supplement_V2) AS T1
       WHERE _tmpRemains_all_Supplement_V2.GoodsId = T1.GoodsId
         AND _tmpRemains_all_Supplement_V2.UnitId = T1.UnitId
         AND _tmpRemains_all_Supplement_V2.UnitId in (SELECT _tmpUnit_SUN_Supplement_V2.UnitId 
                                                      FROM _tmpUnit_SUN_Supplement_V2 
                                                      WHERE _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_out = TRUE);
              
    /*RAISE EXCEPTION 'Подразделений <%> Товаров <%> Остатков <%>', 
                    (SELECT Count(*) FROM _tmpUnit_SUN_Supplement_V2), 
                    (SELECT Count(*) FROM _tmpGoods_SUN_Supplement_V2), 
                    (SELECT Count(*) FROM _tmpRemains_all_Supplement_V2 WHERE _tmpRemains_all_Supplement_V2.Need > 0);
     */

     -- 3. распределяем
     --
     -- курсор1 - все что можно распределить
     OPEN curPartion_next FOR
        SELECT _tmpRemains_all_Supplement_V2.UnitId
             , _tmpRemains_all_Supplement_V2.GoodsId
             , COALESCE (_tmpRemains_all_Supplement_V2.Give, 0) AS Give
             , COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0)
       FROM _tmpRemains_all_Supplement_V2

            LEFT JOIN _tmpGoods_SUN_Supplement_V2 ON _tmpGoods_SUN_Supplement_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId

            LEFT JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId
            
            LEFT JOIN _tmpGoodsLayout_SUN_Supplement_V2 ON _tmpGoodsLayout_SUN_Supplement_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId
                                                    AND _tmpGoodsLayout_SUN_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId  

            LEFT JOIN _tmpGoods_PromoUnit_Supplement_V2 ON _tmpGoods_PromoUnit_Supplement_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId
                                                    AND _tmpGoods_PromoUnit_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId  
                                                                            
            -- найдем дисконтній товар
            LEFT JOIN _tmpGoods_DiscountExternal_Supplement_V2 AS _tmpGoods_DiscountExternal
                                                            ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_all_Supplement_V2.UnitId
                                                           AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_all_Supplement_V2.GoodsId

            LEFT JOIN _tmpSUN_Send_Supplement_V2 ON _tmpSUN_Send_Supplement_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId
                                                AND _tmpSUN_Send_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId  

            LEFT JOIN _tmpSUN_Send_SupplementAll_V2 ON _tmpSUN_Send_SupplementAll_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId
                                                   AND _tmpSUN_Send_SupplementAll_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId  

            -- а здесь, отбросили !!холод!!
            LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_all_Supplement_V2.GoodsId

       WHERE COALESCE (_tmpRemains_all_Supplement_V2.Give, 0) > 0
         AND _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_out = True
         AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
         AND COALESCE(_tmpSUN_Send_Supplement_V2.GoodsID, 0) = 0
         AND COALESCE(_tmpSUN_Send_SupplementAll_V2.GoodsID, 0) = 0
             -- отбросили !!холод!!
         AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
             tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE OR
             _tmpUnit_SUN_Supplement_V2.isColdOutSUN = TRUE)
       ORDER BY _tmpRemains_all_Supplement_V2.Give DESC
              , _tmpRemains_all_Supplement_V2.UnitId
              , _tmpRemains_all_Supplement_V2.GoodsId
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbSurplus, vbKoeffSUN;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

/*               raise notice 'Value 05: % % % % % %', 
                 vbUnitId_from, vbUnitId_to, vbGoodsId, vbNeed, vbSurplus, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END;*/

         -- курсор2. - Потребность для vbGoodsId
         OPEN curResult_next FOR
             SELECT _tmpRemains_all_Supplement_V2.UnitId
                  , FLOOR(CASE WHEN COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0) = 0 
                               THEN (_tmpRemains_all_Supplement_V2.Need - COALESCE(_tmpRemains_all_Supplement_V2.AmountRemains, 0))::Integer -
                                    COALESCE(_tmpRemains_all_Supplement_V2.AmountUse, 0)
                               ELSE
                               FLOOR (((_tmpRemains_all_Supplement_V2.Need - COALESCE(_tmpRemains_all_Supplement_V2.AmountRemains, 0))::Integer -
                                       COALESCE(_tmpRemains_all_Supplement_V2.AmountUse, 0)) / COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0)
                               END)
             FROM _tmpRemains_all_Supplement_V2

                  LEFT JOIN _tmpGoods_SUN_Supplement_V2 ON _tmpGoods_SUN_Supplement_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId

                  LEFT JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId

                  -- найдем дисконтній товар
                  LEFT JOIN _tmpGoods_DiscountExternal_Supplement_V2 AS _tmpGoods_DiscountExternal
                                                                 ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_all_Supplement_V2.UnitId
                                                                AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_all_Supplement_V2.GoodsId

                  -- отбросили !!исключения!!
                  LEFT JOIN _tmpUnit_SunExclusion_Supplement_V2 ON _tmpUnit_SunExclusion_Supplement_V2.UnitId_from = vbUnitId_from
                                                            AND _tmpUnit_SunExclusion_Supplement_V2.UnitId_to   = _tmpRemains_all_Supplement_V2.UnitId

             WHERE  FLOOR(CASE WHEN COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0) = 0 
                               THEN (_tmpRemains_all_Supplement_V2.Need - COALESCE(_tmpRemains_all_Supplement_V2.AmountRemains, 0))::Integer -
                                    COALESCE(_tmpRemains_all_Supplement_V2.AmountUse, 0)
                               ELSE
                               FLOOR (((_tmpRemains_all_Supplement_V2.Need - COALESCE(_tmpRemains_all_Supplement_V2.AmountRemains, 0))::Integer -
                                       COALESCE(_tmpRemains_all_Supplement_V2.AmountUse, 0)) / COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0)
                               END) > 0
               AND _tmpRemains_all_Supplement_V2.UnitId <> vbUnitId_from
               AND _tmpRemains_all_Supplement_V2.GoodsId = vbGoodsId
               AND _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_in = True
               AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
               AND _tmpUnit_SunExclusion_Supplement_V2.UnitId_to IS NULL
             ORDER BY FLOOR(CASE WHEN COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0) = 0 
                               THEN (_tmpRemains_all_Supplement_V2.Need - COALESCE(_tmpRemains_all_Supplement_V2.AmountRemains, 0))::Integer -
                                    COALESCE(_tmpRemains_all_Supplement_V2.AmountUse, 0)
                               ELSE
                               FLOOR (((_tmpRemains_all_Supplement_V2.Need - COALESCE(_tmpRemains_all_Supplement_V2.AmountRemains, 0))::Integer -
                                       COALESCE(_tmpRemains_all_Supplement_V2.AmountUse, 0)) / COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement_V2.KoeffSUN, 0)
                               END)  DESC
                    , _tmpRemains_all_Supplement_V2.UnitId
                    , _tmpRemains_all_Supplement_V2.GoodsId;
         -- начало цикла по курсору2 - остаток сроковых - под него надо найти Автозаказ
         LOOP
             -- данные по Автозаказ
             FETCH curResult_next INTO vbUnitId_to, vbNeed;
             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR (vbSurplus) <= 0 THEN EXIT; END IF;

             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR FLOOR (vbSurplus) <= 0 THEN EXIT; END IF;
             
             /*  raise notice 'Value 05: % % % % % %', 
                 vbUnitId_from, vbUnitId_to, vbGoodsId, vbNeed, vbSurplus, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END;*/

             INSERT INTO _tmpResult_Supplement_V2 (UnitId_from, UnitId_to, GoodsId, Amount)
               VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END);

             UPDATE _tmpRemains_all_Supplement_V2 SET AmountUse = AmountUse + CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END
             WHERE _tmpRemains_all_Supplement_V2.UnitId = vbUnitId_to
               AND _tmpRemains_all_Supplement_V2.GoodsId = vbGoodsId;

             vbSurplus := vbSurplus - CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END;

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

            , Object_Unit_To.Id                          AS UnitId_To
            , Object_Unit_To.ValueData                   AS UnitName_To

            , _tmpResult_Supplement_V2.Amount               AS Amount

            , tmpRemains_all_From.MinExpirationDate

            , tmpRemains_all_From.MCS                    AS MCS_From
            , _tmpGoodsLayout_SUN_Supplement_V2.Layout      AS Layout_From
            , _tmpGoods_PromoUnit_Supplement_V2.Amount      AS PromoUnit_From
            
            , tmpRemains_all_From.Price                  AS Price_From
            , tmpRemains_all_From.isCloseMCS             AS isCloseMCS_From
            , tmpRemains_all_From.AmountRemains          AS AmountRemains_From

            , tmpRemains_all_From.Give                   AS Give_From

            , tmpRemains_all_To.MCS                      AS MCS_To
            , tmpRemains_all_To.Price                    AS Price_To
            , tmpRemains_all_To.isCloseMCS               AS isCloseMCS_To
            , tmpRemains_all_To.AmountRemains            AS AmountRemains_To

            , tmpRemains_all_To.Need                     AS Need_To
            , tmpRemains_all_To.AmountUse                AS AmountUse_To

       FROM _tmpResult_Supplement_V2

            LEFT JOIN _tmpRemains_all_Supplement_V2 AS tmpRemains_all_From
                                                 ON tmpRemains_all_From.UnitId  = _tmpResult_Supplement_V2.UnitId_from
                                                AND tmpRemains_all_From.GoodsId = _tmpResult_Supplement_V2.GoodsId
            LEFT JOIN Object AS Object_Unit_From  ON Object_Unit_From.Id  = tmpRemains_all_From.UnitId


            LEFT JOIN _tmpRemains_all_Supplement_V2 AS tmpRemains_all_To
                                                 ON tmpRemains_all_To.UnitId  = _tmpResult_Supplement_V2.UnitId_to
                                                AND tmpRemains_all_To.GoodsId = _tmpResult_Supplement_V2.GoodsId
            LEFT JOIN Object AS Object_Unit_To  ON Object_Unit_To.Id  = tmpRemains_all_To.UnitId

            LEFT JOIN _tmpGoodsLayout_SUN_Supplement_V2 ON _tmpGoodsLayout_SUN_Supplement_V2.GoodsID = _tmpResult_Supplement_V2.GoodsId
                                                    AND _tmpGoodsLayout_SUN_Supplement_V2.UnitId = _tmpResult_Supplement_V2.UnitId_from

            LEFT JOIN _tmpGoods_PromoUnit_Supplement_V2 ON _tmpGoods_PromoUnit_Supplement_V2.GoodsID = _tmpResult_Supplement_V2.GoodsId
                                                    AND _tmpGoods_PromoUnit_Supplement_V2.UnitId = _tmpResult_Supplement_V2.UnitId_from 

            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmpRemains_all_To.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
            
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
 10.06.20                                                     *
*/

-- 

SELECT * FROM lpInsert_Movement_Send_RemainsSun_Supplement_V2_Sum (inOperDate:= CURRENT_DATE + INTERVAL '3 DAY', inDriverId:= 0, inUserId:= 3);