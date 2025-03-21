-- Function: lpInsert_Movement_Send_RemainsSun_Supplement

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_Supplement (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_Supplement(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inDriverId            Integer   , -- ��������, ������������ ������ �� ������� �����
    IN inUserId              Integer     -- ������������
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, isClose boolean
             , UnitId_From Integer, UnitName_From TVarChar

             , UnitId_To Integer, UnitName_To TVarChar
             , Amount TFloat
             
             , MinExpirationDate TDateTime

             , MCS TFloat
             , AmountRemains TFloat
             , AmountSalesDay TFloat
             , AverageSales TFloat
             , StockRatio TFloat

             , MCS_From TFloat
             , Layout_From TFloat
             , PromoUnit_From TFloat
             , Price_From TFloat
             , isCloseMCS_From boolean
             , AmountRemains_From TFloat
             , AmountSalesDey_From TFloat
             , AmountSalesMonth_From TFloat
             , AverageSalesMonth_From TFloat
             , Need_From TFloat
             , Delt_From TFloat

             , MCS_To TFloat
             , Price_To TFloat
             , isCloseMCS_To boolean
             , AmountRemains_To TFloat
             , AmountSalesDey_To TFloat
             , AmountSalesMonth_To TFloat
             , AverageSalesMonth_To TFloat
             , Need_To TFloat
             , Delta_To TFloat

             , AmountUse_To TFloat

             , InvNumberLayout TVarChar
             , LayoutName TVarChar
              )
AS
$BODY$
   DECLARE vbObjectId   Integer;
   DECLARE vbDOW_curr   Integer;
   DECLARE vbDate_6     TDateTime;
   DECLARE vbDate_3     TDateTime;
   DECLARE vbDate_1     TDateTime;
   DECLARE vbDate_0     TDateTime;

   DECLARE curPartion_next refcursor;
   DECLARE curResult_next  refcursor;

   DECLARE vbUnitId_from Integer;
   DECLARE vbUnitId_To Integer;
   DECLARE vbGoodsId TFloat;
   DECLARE vbSurplus TFloat;
   DECLARE vbNeed TFloat;
   DECLARE vbKoeffSUN TFloat;
   DECLARE vbisEliminateColdSUN Boolean;
   DECLARE vbisOnlyColdSUN Boolean;
   DECLARE vbisShoresSUN Boolean;
   DECLARE vbisCancelBansSUN Boolean;
   DECLARE vbisLegalEntitiesSUN Boolean;
   DECLARE vbDays TFloat;
   DECLARE vbJuridicalId Integer;
BEGIN
     --
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     -- ���� ������
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  );

     SELECT COALESCE(ObjectBoolean_CashSettings_EliminateColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_ShoresSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_OnlyColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_CancelBansSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_LegalEntitiesSUN.ValueData, FALSE) 
     INTO vbisEliminateColdSUN, vbisShoresSUN, vbisOnlyColdSUN, vbisCancelBansSUN, vbisLegalEntitiesSUN
     FROM Object AS Object_CashSettings
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_EliminateColdSUN
                                  ON ObjectBoolean_CashSettings_EliminateColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_EliminateColdSUN.DescId = zc_ObjectBoolean_CashSettings_EliminateColdSUN()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_ShoresSUN
                                  ON ObjectBoolean_CashSettings_ShoresSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_ShoresSUN.DescId = zc_ObjectBoolean_CashSettings_ShoresSUN()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_OnlyColdSUN
                                  ON ObjectBoolean_CashSettings_OnlyColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_OnlyColdSUN.DescId = zc_ObjectBoolean_CashSettings_OnlyColdSUN()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_CancelBansSUN
                                  ON ObjectBoolean_CashSettings_CancelBansSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_CancelBansSUN.DescId = zc_ObjectBoolean_CashSettings_CancelBansSUN()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_LegalEntitiesSUN
                                  ON ObjectBoolean_CashSettings_LegalEntitiesSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_LegalEntitiesSUN.DescId = zc_ObjectBoolean_CashSettings_LegalEntitiesSUN()
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;

     -- ��� ������ ��� ����� SUN Supplement
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_Supplement   (GoodsId Integer, KoeffSUN TFloat, isSupplementMarkSUN1 Boolean, isSmudge Boolean, SupplementMin Integer, SupplementMinPP Integer, UnitSupplementSUN1InId Integer, isMarcCalc Boolean) ON COMMIT DROP;
     END IF;

     -- ��� ������������� �������� ����� SUN Supplement
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoodsUnit_SUN_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoodsUnit_SUN_Supplement   (GoodsId Integer, UnitOutId Integer) ON COMMIT DROP;
     END IF;

     -- ��� ������������� ��� ����� SUN Supplement
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SUN_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SUN_Supplement (UnitId Integer, DeySupplSun1 Integer, MonthSupplSun1 Integer, isSUN_Supplement_in Boolean, isSUN_Supplement_out Boolean, isSUN_Supplement_Priority Boolean, SalesRatio TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     END IF;

     -- ��������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoodsLayout_SUN_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoodsLayout_SUN_Supplement (GoodsId Integer, UnitId Integer, Layout TFloat, isNotMoveRemainder6 boolean, MovementLayoutId Integer) ON COMMIT DROP;
     END IF;

     -- ������������� ���� ��� �����
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_PromoUnit_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_PromoUnit_Supplement (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- ������ ���������� ��������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_DiscountExternal_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_DiscountExternal_Supplement  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_TP_exception_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_TP_exception_Supplement   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- ��� ������������ � ������� ���
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_Sun_exception_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_Sun_exception_Supplement   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;
     
     -- ��� ��������� �� ��� � �� ������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSUN_Send_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpSUN_Send_Supplement (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;
     
     -- ��� ��������� �� ��� � �� ������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSUN_Send_SupplementAll'))
     THEN
       CREATE TEMP TABLE _tmpSUN_Send_SupplementAll (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- ��������� ����� �����������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SunExclusion_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SunExclusion_Supplement (UnitId_from Integer, UnitId_to Integer) ON COMMIT DROP;
     END IF;

     -- "���� ������ � ���"... ���� � ����� �� ����� ��� ������������ ����� X, �� � ������������ ������� ������ ������������ ����� Y � ��� �� ����������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_PairSun_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_PairSun_Supplement (GoodsId Integer, GoodsId_PairSun Integer, PairSunAmount TFloat) ON COMMIT DROP;
     END IF;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_all_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpRemains_all_Supplement   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Layout TFloat, AmountRemains TFloat, AmountNotSend TFloat, 
                                                       AmountSalesDay TFloat, AmountSalesMonth TFloat, AverageSalesMonth TFloat, Need TFloat, GiveAway TFloat, AmountUse TFloat, 
                                                       MinExpirationDate TDateTime, isCloseMCS boolean, SupplementMin Integer, SurplusCalc TFloat, NeedCalc TFloat) ON COMMIT DROP;
     END IF;

     -- 2. ��� �������, ���, � ����. ��������� ������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpStockRatio_all_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpStockRatio_all_Supplement   (GoodsId Integer, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AverageSales TFloat, StockRatio TFloat) ON COMMIT DROP;
     END IF;

     -- 3. ������������-1 ������� - �� ���� �������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpResult_Supplement   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     END IF;

     -- ��� ������ ��� ����� SUN Supplement
     DELETE FROM _tmpGoods_SUN_Supplement;
     -- ��� ������������� �������� ����� SUN Supplement
     DELETE FROM _tmpGoodsUnit_SUN_Supplement;
     -- ��� ������������� ��� ����� SUN
     DELETE FROM _tmpUnit_SUN_Supplement;
     -- ��������
     DELETE FROM _tmpGoodsLayout_SUN_Supplement;
     -- ������������� ���� ��� �����
     DELETE FROM _tmpGoods_PromoUnit_Supplement;
     -- ������ ���������� ��������
     DELETE FROM _tmpGoods_DiscountExternal_Supplement;
     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     DELETE FROM _tmpGoods_TP_exception_Supplement;
     -- ��� ������������ � ������� ���
     DELETE FROM _tmpGoods_Sun_exception_Supplement;
     -- ��� ��������� �� ��� � �� ������
     DELETE FROM _tmpSUN_Send_Supplement;
     DELETE FROM _tmpSUN_Send_SupplementAll;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     DELETE FROM _tmpRemains_all_Supplement;
     -- 2. ��� �������, ���, � ����. ��������� ������
     DELETE FROM _tmpStockRatio_all_Supplement;
     -- 3. ������������-1 ������� - �� ���� �������
     DELETE FROM _tmpResult_Supplement;
     DELETE FROM _tmpUnit_SunExclusion_Supplement;

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

     -- ��� ������������� ��� ����� SUN
     INSERT INTO _tmpUnit_SUN_Supplement (UnitId, DeySupplSun1, MonthSupplSun1, isSUN_Supplement_in, isSUN_Supplement_out, isSUN_Supplement_Priority, SalesRatio, isLock_CheckMSC, isLock_CloseGd, isLock_ClosePL, isLock_CheckMa, isColdOutSUN)
        SELECT Object_Unit.Id
             , COALESCE (NULLIF(OF_DeySupplSun1.ValueData, 0), 30)::Integer              AS DeySupplSun1
             , COALESCE (NULLIF(OF_MonthSupplSun1.ValueData, 0), 8)::Integer             AS MonthSupplSun1
             , (COALESCE (ObjectBoolean_SUN_Supplement_in.ValueData, FALSE) OR
               COALESCE (ObjectBoolean_SUN_Supplement_in.ValueData, FALSE) = FALSE AND
               COALESCE (ObjectBoolean_SUN_Supplement_out.ValueData, FALSE) = FALSE) :: Boolean   AS isSUN_Supplement_in
             , COALESCE (ObjectBoolean_SUN_Supplement_out.ValueData, FALSE) :: Boolean   AS isSUN_Supplement_out             
             , COALESCE (ObjectBoolean_SUN_Supplement_Priority.ValueData, FALSE) :: Boolean   AS isSUN_Supplement_Priority             
             , CASE WHEN ObjectDate_FirstCheck.ValueData IS NOT NULL AND
                         (inOperDate::Date - ObjectDate_FirstCheck.ValueData::Date) <
                         (inOperDate::Date - (inOperDate::Date - (COALESCE (NULLIF(OF_MonthSupplSun1.ValueData, 0), 8)::Integer::TVarChar||' MONTH')::INTERVAL)::Date)
                    THEN (inOperDate::Date - (inOperDate::Date - (COALESCE (NULLIF(OF_MonthSupplSun1.ValueData, 0), 8)::Integer::TVarChar||' MONTH')::INTERVAL)::Date)::TFloat / (CURRENT_DATE - ObjectDate_FirstCheck.ValueData::Date)::TFloat
                    ELSE 1 END     
               -- TRUE = �� ���������� ��� "�� ��� ���"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 1 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLockSale
               -- TRUE = ��� ������� "������ ���"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 3 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseGd
               -- TRUE = ��� ������� "���� ���"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 5 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_ClosePL
               -- TRUE = ��� ������� "���������"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 7 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseMa
             , COALESCE (OB_ColdOutSUN.ValueData, FALSE)                                                          AS isColdOutSUN
        FROM Object AS Object_Unit
             LEFT JOIN ObjectFloat   AS OF_DeySupplSun1  ON OF_DeySupplSun1.ObjectId  = Object_Unit.Id AND OF_DeySupplSun1.DescId     = zc_ObjectFloat_Unit_DeySupplSun1()
             LEFT JOIN ObjectFloat   AS OF_MonthSupplSun1 ON OF_MonthSupplSun1.ObjectId = Object_Unit.Id AND OF_MonthSupplSun1.DescId = zc_ObjectFloat_Unit_MonthSupplSun1()
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = Object_Unit.Id AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_Supplement_in
                                     ON ObjectBoolean_SUN_Supplement_in.ObjectId = Object_Unit.Id
                                    AND ObjectBoolean_SUN_Supplement_in.DescId = zc_ObjectBoolean_Unit_SUN_Supplement_in()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_Supplement_out
                                     ON ObjectBoolean_SUN_Supplement_out.ObjectId = Object_Unit.Id
                                    AND ObjectBoolean_SUN_Supplement_out.DescId = zc_ObjectBoolean_Unit_SUN_Supplement_out()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_Supplement_Priority
                                     ON ObjectBoolean_SUN_Supplement_Priority.ObjectId = Object_Unit.Id
                                    AND ObjectBoolean_SUN_Supplement_Priority.DescId = zc_ObjectBoolean_Unit_SUN_Supplement_Priority()
             LEFT JOIN ObjectBoolean AS OB_ColdOutSUN    
                                     ON OB_ColdOutSUN.ObjectId = Object_Unit.Id
                                    AND OB_ColdOutSUN.DescId = zc_ObjectBoolean_Unit_ColdOutSUN()
             LEFT JOIN ObjectDate AS ObjectDate_FirstCheck
                                  ON ObjectDate_FirstCheck.ObjectId = Object_Unit.Id
                                 AND ObjectDate_FirstCheck.DescId = zc_ObjectDate_Unit_FirstCheck()
             LEFT JOIN ObjectString  AS OS_LL  ON OS_LL.ObjectId  = Object_Unit.Id AND OS_LL.DescId  = zc_ObjectString_Unit_SUN_v1_Lock()                                    
             -- !!!������ ��� ����� ��������!!!
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Driver
                                  ON ObjectLink_Unit_Driver.ObjectId      = Object_Unit.Id
                                 AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
             LEFT JOIN Object AS Object_Driver ON Object_Driver.Id = ObjectLink_Unit_Driver.ChildObjectId
        WHERE Object_Unit.DescId = zc_Object_Unit()
          -- ���� ������ ���� ������ - �������� ���
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' AND vbisShoresSUN = False OR
               OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 4 OR
               OS_ListDaySUN.ValueData ILIKE '%' || CASE WHEN vbDOW_curr - 1 = 0 THEN 7 ELSE vbDOW_curr - 1 END::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 3)

          AND (COALESCE (ObjectBoolean_SUN_Supplement_in.ValueData, FALSE) = TRUE OR 
               COALESCE (ObjectBoolean_SUN_Supplement_out.ValueData, FALSE) = TRUE OR
               Object_Unit.Id IN (SELECT DISTINCT tmpGoodsUnit.GoodsId FROM gpSelect_GoodsUnitSupplementSUN1_All(inSession := inUserId::TVarChar) AS tmpGoodsUnit))
       ;
       
     ANALYSE _tmpUnit_SUN_Supplement;
     
     vbDays := (CURRENT_DATE -  (CURRENT_DATE - (((SELECT MAX(_tmpUnit_SUN_Supplement.MonthSupplSun1) FROM _tmpUnit_SUN_Supplement))::TVarChar || ' MONTH') :: INTERVAL)::Date);


--raise notice 'Value 2: % % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM _tmpUnit_SUN_Supplement), vbDays;

     -- ������ ���������� ��������
     
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
      INSERT INTO _tmpGoods_DiscountExternal_Supplement
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
             
      ANALYSE _tmpGoods_DiscountExternal_Supplement;

--raise notice 'Value 3: %', CLOCK_TIMESTAMP();

     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
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
                     FROM _tmpUnit_SUN_Supplement

                          INNER JOIN tmpMovement AS Movement ON Movement.UnitId = _tmpUnit_SUN_Supplement.UnitId

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

     INSERT INTO _tmpGoods_TP_exception_Supplement   (UnitId, GoodsId, Amount)
     SELECT tmpGoods.UnitId, tmpGoods.GoodsId, tmpGoods.Amount
     FROM tmpGoods;
     
     ANALYSE _tmpGoods_TP_exception_Supplement;

--raise notice 'Value 4: %', CLOCK_TIMESTAMP();

     -- ��� ������������ � ������� ���
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
     -- ���������-1
     INSERT INTO _tmpGoods_Sun_exception_Supplement (UnitId, GoodsId, Amount)
        SELECT tmpSUN.UnitId, tmpSUN.GoodsId, tmpSUN.Amount
        FROM tmpSUN;
        
     ANALYSE _tmpGoods_Sun_exception_Supplement;
        
--raise notice 'Value 5: %', CLOCK_TIMESTAMP();

        -- X����
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

       -- ������� ��� ����������
/*     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpSalesGoods'))
     THEN
       DROP TABLE tmpSalesGoods;
     END IF;

     CREATE TEMP TABLE tmpSalesGoods ON COMMIT DROP AS
        SELECT MIContainer.whereobjectid_analyzer   AS UnitId
             , MIContainer.objectid_analyzer        AS GoodsId
        FROM MovementItemContainer AS MIContainer
             LEFT JOIN MovementBoolean AS MB_CorrectMarketing
                                       ON MB_CorrectMarketing.MovementId = MIContainer.MovementId
                                      AND MB_CorrectMarketing.DescId     = zc_MovementBoolean_CorrectMarketing()
                                      AND MB_CorrectMarketing.ValueData  = TRUE
        WHERE MIContainer.OperDate >= CURRENT_DATE - INTERVAL '40 DAY'
          AND MIContainer.DescId         = zc_MIContainer_Count()
          AND MIContainer.MovementDescId = zc_Movement_Check()
          AND vbisCancelBansSUN = True
        GROUP BY MIContainer.whereobjectid_analyzer
               , MIContainer.objectid_analyzer;
               
     ANALYSE tmpSalesGoods;  */    
                           
     -- ��� ��������� �� ��� � �� ������
     WITH
     tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                      , COALESCE(NULLIF(OF_DS.ValueData, 0), 10):: Integer AS DaySendSUN
                 FROM Object AS Object_Unit
                      LEFT JOIN ObjectFloat   AS OF_DS            ON OF_DS.ObjectId            = Object_Unit.Id AND OF_DS.DescId            = zc_ObjectFloat_Unit_HT_SUN_v1()
                 WHERE Object_Unit.DescId = zc_Object_Unit()
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

                            
     INSERT INTO _tmpSUN_Send_Supplement (UnitId, GoodsId)
     SELECT tmpSUN_Send.UnitId_to, tmpSUN_Send.GoodsId FROM tmpSUN_Send
     ;
     
     ANALYSE _tmpSUN_Send_Supplement;
          
--raise notice 'Value 6: %', CLOCK_TIMESTAMP();

     -- ��� ��������� �� ��� � �� ������
     WITH
     tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                      , COALESCE(NULLIF(OF_DS.ValueData, 0), 10):: Integer AS DaySendSUN
                 FROM Object AS Object_Unit
                      LEFT JOIN ObjectFloat   AS OF_DS            ON OF_DS.ObjectId            = Object_Unit.Id AND OF_DS.DescId            = zc_ObjectFloat_Unit_HT_SUN_v1()
                 WHERE Object_Unit.DescId = zc_Object_Unit()
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
                            
     INSERT INTO _tmpSUN_Send_SupplementAll (UnitId, GoodsId)
     SELECT tmpSUN_Send.UnitId_to, tmpSUN_Send.GoodsId FROM tmpSUN_Send
     ;
     
     ANALYSE _tmpSUN_Send_SupplementAll;

--raise notice 'Value 7: %', CLOCK_TIMESTAMP();

     -- ��������� ����� �����������
     INSERT INTO _tmpUnit_SunExclusion_Supplement (UnitId_from, UnitId_to)
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
             -- � ���� ������ ������� ����
             LEFT JOIN _tmpUnit_SUN_Supplement AS _tmpUnit_SUN_From ON ObjectLink_From.ChildObjectId IS NULL

             LEFT JOIN ObjectLink AS ObjectLink_To
                                  ON ObjectLink_To.ObjectId = Object.Id
                                 AND ObjectLink_To.DescId   = zc_ObjectLink_SunExclusion_To()
             -- � ���� ������ ������� ����
             LEFT JOIN _tmpUnit_SUN_Supplement AS _tmpUnit_SUN_To ON ObjectLink_To.ChildObjectId IS NULL

        WHERE Object.DescId   = zc_Object_SunExclusion()
          AND Object.isErased = FALSE
           ;
           
        ANALYSE _tmpUnit_SunExclusion_Supplement;
           
--raise notice 'Value 9: %', CLOCK_TIMESTAMP();

         -- "���� ������ � ���"... ���� � ����� �� ����� ��� ������������ ����� X, �� � ������������ ������� ������ ������������ ����� Y � ��� �� ����������
         INSERT INTO _tmpGoods_SUN_PairSun_Supplement (GoodsId, GoodsId_PairSun, PairSunAmount)
            SELECT OL_GoodsPairSun.ObjectId      AS GoodsId
                 , OL_GoodsPairSun.ChildObjectId            AS GoodsId_PairSun
                 , COALESCE (OF_PairSunAmount.ValueData, 1) AS PairSunAmount
            FROM ObjectLink AS OL_GoodsPairSun

                 LEFT JOIN ObjectFloat AS OF_PairSunAmount
                                       ON OF_PairSunAmount.ObjectId  = OL_GoodsPairSun.ObjectId 
                                      AND OF_PairSunAmount.DescId    = zc_ObjectFloat_Goods_PairSunAmount()

            WHERE OL_GoodsPairSun.ChildObjectId > 0 AND OL_GoodsPairSun.DescId = zc_ObjectLink_Goods_GoodsPairSun()
           ;
           
         ANALYSE _tmpGoods_SUN_PairSun_Supplement;
                    
           
     -- ����� �� �����������
/*     IF inOperDate = '01.02.2021'
     THEN
     
       INSERT INTO _tmpGoods_SUN_Supplement (GoodsId, KoeffSUN, UnitOutId)
       SELECT MovementItem.ObjectId
            , Object_Goods_Retail.KoeffSUN_Supplementv1
            , MovementLinkObject_To.ObjectId
       FROM Movement

            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.Amount > 0
                                   AND MovementItem.isErased = False
                                     
            INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.ObjectId

       WHERE Movement.DescId = zc_Movement_Send()
         AND Movement.InvNumber = '110120'
         AND Movement.StatusId = zc_Enum_Status_Complete();
       
     END IF;*/

     -- ��� ������ ��� ����� SUN Supplement
     INSERT INTO _tmpGoods_SUN_Supplement (GoodsId, KoeffSUN, isSupplementMarkSUN1, isSmudge, SupplementMin, SupplementMinPP, UnitSupplementSUN1InId, isMarcCalc)
        SELECT Object_Goods_Retail.ID
             , Object_Goods_Retail.KoeffSUN_Supplementv1
             , Object_Goods_Main.isSupplementMarkSUN1
             , Object_Goods_Main.isSupplementSmudge
             , Object_Goods_Main.SupplementMin
             , Object_Goods_Main.SupplementMinPP 
             , Object_Goods_Main.UnitSupplementSUN1InId 
             , tmpGoodsUnit_SUN.GoodsId IS NULL AND  
               Object_Goods_Main.isSupplementSmudge = False AND  
               COALESCE(Object_Goods_Main.SupplementMin, 0) = 0 AND  
               COALESCE(Object_Goods_Main.SupplementMinPP , 0) = 0 AND
               COALESCE (Object_Goods_Main.isSupplementMarkSUN1, False) = TRUE AND
               Object_Goods_Main.isSupplementSUN1 = TRUE
        FROM Object_Goods_Retail
             INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                         AND (Object_Goods_Main.isSupplementSUN1 = TRUE OR 
                                              Object_Goods_Main.ID IN (SELECT Object_Goods_Retail.GoodsMainId 
                                                                       FROM Object_Goods_Retail 
                                                                            INNER JOIN _tmpGoods_SUN_PairSun_Supplement ON _tmpGoods_SUN_PairSun_Supplement.GoodsId_PairSun = Object_Goods_Retail.Id))
                                         AND Object_Goods_Main.isNot = FALSE
                                         
             LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = Object_Goods_Retail.ID

             LEFT JOIN (SELECT DISTINCT tmpGoodsUnit.GoodsId 
                        FROM gpSelect_GoodsUnitSupplementSUN1_All(inSession := inUserId::TVarChar) AS tmpGoodsUnit) AS tmpGoodsUnit_SUN ON tmpGoodsUnit_SUN.GoodsId = Object_Goods_Retail.ID
        WHERE Object_Goods_Retail.RetailID = vbObjectId
          AND COALESCE(_tmpGoods_SUN_Supplement.GoodsId, 0) = 0
        ;
               
        ANALYSE _tmpGoods_SUN_Supplement;

--raise notice 'Value 10: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM _tmpGoods_SUN_Supplement where _tmpGoods_SUN_Supplement.GoodsId = 21185549);


/*     INSERT INTO _tmpGoods_SUN_Supplement (GoodsId, KoeffSUN, UnitOutId, UnitOut2Id)
        SELECT Object_Goods_Retail.ID
             , Object_Goods_Retail.KoeffSUN_Supplementv1
             , Null
             , Null
        FROM Object_Goods_Retail
             INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
             INNER JOIN Container ON Container.ObjectId = Object_Goods_Retail.ID
                                 AND Container.Amount <> 0 
                                 AND Container.WhereObjectId in (SELECT OB.ObjectId
                                                                 FROM ObjectBoolean AS OB
                                                                 WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN())
        WHERE Object_Goods_Retail.RetailID = vbObjectId
          AND Object_Goods_Retail.ID > 389398
        GROUP BY Object_Goods_Retail.ID
              , Object_Goods_Retail.KoeffSUN_Supplementv1;*/
              
              
--raise notice 'Value 11: %', CLOCK_TIMESTAMP();

     -- ��� ������������� �������� ����� SUN Supplement
     INSERT INTO _tmpGoodsUnit_SUN_Supplement (GoodsId, UnitOutId)
     SELECT T1.GoodsId, T1.UnitId FROM gpSelect_GoodsUnitSupplementSUN1_All(inSession := inUserId::TVarChar) AS T1

           LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = T1.GoodsId
           
     WHERE COALESCE (_tmpGoods_SUN_Supplement.isSupplementMarkSUN1, False) = False;
     
     ANALYSE _tmpGoodsUnit_SUN_Supplement;
         

      -- ��������
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpLayoutMovement'))
     THEN
       DROP TABLE tmpLayoutMovement;
     END IF;

     CREATE TEMP TABLE tmpLayoutMovement ON COMMIT DROP AS
                               (SELECT Movement.Id                                                  AS Id
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

     -- ��������
     WITH tmpLayout AS (SELECT Movement.ID                        AS Id
                             , MovementItem.ObjectId              AS GoodsId
                             , MovementItem.Amount                AS Amount
                             , Movement.isPharmacyItem            AS isPharmacyItem
                             , Movement.isNotMoveRemainder6       AS isNotMoveRemainder6
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
        , tmpLayoutAll AS (SELECT tmpLayout.GoodsId                             AS GoodsId
                                , _tmpUnit_SUN_Supplement.UnitId                AS UnitId
                                , tmpLayout.Amount                              AS Amount
                                , tmpLayout.isNotMoveRemainder6                 AS isNotMoveRemainder6
                                , tmpLayout.ID                                  AS MovementLayoutId
                           FROM _tmpUnit_SUN_Supplement
                                
                                LEFT JOIN Object AS Object_Unit
                                                 ON Object_Unit.Id        = _tmpUnit_SUN_Supplement.UnitId
                                                AND Object_Unit.DescId    = zc_Object_Unit()
                                 
                                INNER JOIN tmpLayout ON 1 = 1 

                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = _tmpUnit_SUN_Supplement.UnitId

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                           WHERE (tmpLayoutUnit.UnitId = _tmpUnit_SUN_Supplement.UnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                             AND (Object_Unit.ValueData NOT ILIKE '���. ����� %' OR tmpLayout.isPharmacyItem = True)
                           )
                                                              
     INSERT INTO  _tmpGoodsLayout_SUN_Supplement (GoodsId, UnitId, Layout, isNotMoveRemainder6, MovementLayoutId) 
     SELECT tmpLayoutAll.GoodsId                 AS GoodsId
          , tmpLayoutAll.UnitId                  AS UnitId
          , MAX (tmpLayoutAll.Amount):: TFloat   AS Amount
          , SUM (CASE WHEN tmpLayoutAll.isNotMoveRemainder6 = TRUE THEN 1 ELSE 0 END) > 0   AS isNotMoveRemainder6
          , MAX (tmpLayoutAll.MovementLayoutId)  AS MovementLayoutId
      FROM tmpLayoutAll      
      GROUP BY tmpLayoutAll.GoodsId
             , tmpLayoutAll.UnitId;
             
     ANALYSE _tmpGoodsLayout_SUN_Supplement;
      
--raise notice 'Value 12: %', CLOCK_TIMESTAMP();

     -- ������������� ���� ��� �����
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

      INSERT INTO _tmpGoods_PromoUnit_Supplement
      SELECT MI_Goods.UnitId                         AS UnitId
           , MI_Goods.GoodsId                        AS GoodsId
           , MI_Goods.Amount * tmpUserUnit.CountUser AS Amount

      FROM gpSelect_PromoUnit_UnitGoods (inOperDate := inOperDate, inSession := inUserId::TVarChar) AS MI_Goods

           INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = MI_Goods.UnitId
                                                          
           INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = MI_Goods.GoodsId
           
           INNER JOIN tmpUserUnit ON tmpUserUnit.UnitId = MI_Goods.UnitId
           
      ;
      
     ANALYSE _tmpGoods_PromoUnit_Supplement;
     
--raise notice 'Value 13: %', CLOCK_TIMESTAMP();

 ----raise notice 'Value 05: %', (select Count(*) from _tmpGoods_PromoUnit_Supplement);      

     -- 1. ��� �������
     --
     WITH tmpRemainsPD AS (SELECT Container.ParentId
                                , Container.Amount
                                , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())    AS ExpirationDate
                           FROM Container
                                -- !!!������ ��� ����� �����!!!
                                INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = Container.ObjectId
                                INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = Container.WhereObjectId

                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = Container.Id
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                     ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                    AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                           WHERE Container.DescId = zc_Container_CountPartionDate()
                             AND Container.Amount <> 0
                          )
        , tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (tmpRemainsPD.Amount, Container.Amount, 0))                              AS Amount
                              , SUM (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) <= CURRENT_DATE + (CASE WHEN _tmpGoods_SUN_Supplement.isSupplementMarkSUN1 = TRUE THEN 30 ELSE 90 END::TVarChar||' DAY')::INTERVAL
                                          THEN COALESCE (tmpRemainsPD.Amount, Container.Amount, 0)
                                          ELSE 0 END)                                                                         AS AmountNotSend
                              , SUM (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) <= CURRENT_DATE + INTERVAL '6 MONTH'
                                          THEN COALESCE (tmpRemainsPD.Amount, Container.Amount, 0)
                                          ELSE 0 END)                                                                         AS Amount6Month
                              , MIN (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) >= CURRENT_DATE + (CASE WHEN _tmpGoods_SUN_Supplement.isSupplementMarkSUN1 = TRUE THEN 30 ELSE 90 END::TVarChar||' DAY')::INTERVAL
                                          THEN COALESCE (tmpRemainsPD.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd())
                                          ELSE zc_DateEnd() END)                                                              AS MinExpirationDate
                         FROM Container
                              -- !!!������ ��� ����� �����!!!
                              INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = Container.ObjectId
                              INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = Container.WhereObjectId
                                                              
                              LEFT JOIN tmpRemainsPD ON tmpRemainsPD.ParentId = Container.Id
 
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                              -- ������� �������
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                              LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                               ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id, MI_Income.Id) 
                                                              AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                           --AND COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) > CURRENT_DATE + INTERVAL '30 DAY'
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
          -- �������
        , tmpSalesDay AS (SELECT _tmpUnit_SUN_Supplement.UnitId
                               , _tmpGoods_SUN_Supplement.GoodsId
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0) ) AS AmountSalesDay
                          FROM MovementItemContainer AS MIContainer
                               INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = MIContainer.ObjectId_analyzer
                               INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = MIContainer.WhereObjectId_analyzer
                               LEFT JOIN MovementBoolean AS MB_NotMCS
                                                         ON MB_NotMCS.MovementId = MIContainer.MovementId
                                                        AND MB_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                                                        AND MB_NotMCS.ValueData  = TRUE
                               LEFT JOIN MovementBoolean AS MB_CorrectMarketing
                                                         ON MB_CorrectMarketing.MovementId = MIContainer.MovementId
                                                        AND MB_CorrectMarketing.DescId     = zc_MovementBoolean_CorrectMarketing()
                                                        AND MB_CorrectMarketing.ValueData  = TRUE
                          WHERE MIContainer.OperDate >= CURRENT_DATE - (_tmpUnit_SUN_Supplement.DeySupplSun1::TVarChar ||' DAY') :: INTERVAL
                            AND MIContainer.DescId         = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            -- !!!�� ��������� ���� ����� "�� ��� ���"
                            AND (MB_NotMCS.MovementId IS NULL OR _tmpUnit_SUN_Supplement.isLock_CheckMSC = FALSE)
                            -- !!!�� ��������� ���� ����� "������������� ����� ���������� � ��"
                            AND (MB_CorrectMarketing.MovementId IS NULL OR _tmpUnit_SUN_Supplement.isLock_CheckMa = FALSE)        
                          GROUP BY _tmpUnit_SUN_Supplement.UnitId
                                 , _tmpGoods_SUN_Supplement.GoodsId
                      )
        , tmpSalesMonth AS (SELECT _tmpUnit_SUN_Supplement.UnitId
                                 , _tmpGoods_SUN_Supplement.GoodsId
                                 , CASE WHEN _tmpGoods_SUN_Supplement.isMarcCalc = TRUE
                                        THEN SUM (COALESCE (-1 * MIContainer.Amount * 
                                                 CASE WHEN MIContainer.OperDate > CURRENT_DATE - ((vbDays / 2)::TVarChar||' DAY')::Interval 
                                                 THEN 0.5 ELSE 1.0 END, 0)) * _tmpUnit_SUN_Supplement.SalesRatio                                    
                                        ELSE SUM (COALESCE (-1 * MIContainer.Amount, 0)) * _tmpUnit_SUN_Supplement.SalesRatio 
                                        END AS AmountSalesMonth
                            FROM MovementItemContainer AS MIContainer
                                 INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = MIContainer.ObjectId_analyzer
                                 INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = MIContainer.WhereObjectId_analyzer
                                 LEFT JOIN MovementBoolean AS MB_NotMCS
                                                           ON MB_NotMCS.MovementId = MIContainer.MovementId
                                                          AND MB_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                                                          AND MB_NotMCS.ValueData  = TRUE
                                 LEFT JOIN MovementBoolean AS MB_CorrectMarketing
                                                           ON MB_CorrectMarketing.MovementId = MIContainer.MovementId
                                                          AND MB_CorrectMarketing.DescId     = zc_MovementBoolean_CorrectMarketing()
                                                          AND MB_CorrectMarketing.ValueData  = TRUE
                            WHERE MIContainer.OperDate >= CURRENT_DATE - (CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE
                                                                               THEN _tmpUnit_SUN_Supplement.MonthSupplSun1
                                                                               ELSE _tmpUnit_SUN_Supplement.MonthSupplSun1 END::TVarChar ||' MONTH') :: INTERVAL
                              AND MIContainer.DescId         = zc_MIContainer_Count()
                              AND MIContainer.MovementDescId = zc_Movement_Check()
                              -- !!!�� ��������� ���� ����� "�� ��� ���"
                              AND (MB_NotMCS.MovementId IS NULL OR _tmpUnit_SUN_Supplement.isLock_CheckMSC = FALSE)
                              -- !!!�� ��������� ���� ����� "������������� ����� ���������� � ��"
                              AND (MB_CorrectMarketing.MovementId IS NULL OR _tmpUnit_SUN_Supplement.isLock_CheckMa = FALSE)   
                            GROUP BY _tmpUnit_SUN_Supplement.UnitId
                                   , _tmpGoods_SUN_Supplement.GoodsId
                                   , _tmpUnit_SUN_Supplement.SalesRatio
                                   , _tmpGoods_SUN_Supplement.isMarcCalc
                        )
          -- ����
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
                            -- !!!������ ��� ����� �����!!!
                            INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = OL_Price_Unit.ChildObjectId
                            INNER JOIN ObjectLink AS OL_Price_Goods
                                                  ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                 AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = OL_Price_Goods.ChildObjectId
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
          -- ������ �� ������. �������
        , tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjectFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!������ ��� ����� �����!!!
                                   INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                         ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                   INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                         AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                   -- ������� �� ����� ����
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
                               --    INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = ObjectLink_Child_retail.ChildObjectId
                               WHERE Object_GoodsCategory.DescId   = zc_Object_GoodsCategory()
                                 AND Object_GoodsCategory.isErased = FALSE
                               )
          -- ��������� ��� �� �������� �� ������. �������, ���� � ������. ������� �������� ������
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
        , tmpUnitSupplementSUN1In AS ((SELECT DISTINCT Object_Goods_Main.UnitSupplementSUN1InId AS UnitId FROM Object_Goods_Main WHERE Object_Goods_Main.UnitSupplementSUN1InId IS NOT NULL))
        
     -- 1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains_all_Supplement (UnitId, GoodsId, Price, MCS, Layout, AmountRemains, AmountNotSend, AmountSalesDay, AmountSalesMonth, 
                                              MinExpirationDate, isCloseMCS, SupplementMin)
        SELECT _tmpUnit_SUN_Supplement.UnitId
             , _tmpGoods_SUN_Supplement.GoodsId
             , tmpObject_Price.Price
             , COALESCE(tmpObject_Price.MCSValue, 0)
             
             , _tmpGoodsLayout_SUN_Supplement.Layout

             /*, CASE WHEN _tmpGoodsLayout_SUN_Supplement.isNotMoveRemainder6 = TRUE
                      OR (COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0) - 
                          COALESCE(tmpRemains.Amount6Month, 0))  > _tmpGoodsLayout_SUN_Supplement.Layout
                      OR COALESCE(tmpRemains.Amount6Month, 0) = 0
                    THEN _tmpGoodsLayout_SUN_Supplement.Layout
                    WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0) - 
                                                            COALESCE(tmpRemains.Amount6Month, 0)) >= 0
                    THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0) - 
                                                            COALESCE(tmpRemains.Amount6Month, 0)) 
                    ELSE 0  END  AS Layout*/

               -- �������
             , CASE WHEN COALESCE (tmpRemains.Amount - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0) + COALESCE (_tmpGoods_TP_exception_Supplement.Amount, 0), 0) > 0
                    THEN COALESCE (tmpRemains.Amount - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0) + COALESCE (_tmpGoods_TP_exception_Supplement.Amount, 0), 0) ELSE 0 END AS AmountRemains
             , COALESCE (tmpRemains.AmountNotSend, 0)                                                                         AS AmountNotSend
               -- ����������
             , COALESCE (tmpSalesDay.AmountSalesDay, 0)      AS AmountSalesDay
             , COALESCE (tmpSalesMonth.AmountSalesMonth, 0)  AS AmountSalesMonth
             , tmpRemains.MinExpirationDate
             , COALESCE (tmpObject_Price.isCloseMCS, FALSE)  AS isCloseMCS
             , CASE WHEN Object_Unit.ValueData LIKE '���. ����� %' THEN _tmpGoods_SUN_Supplement.SupplementMinPP ELSE _tmpGoods_SUN_Supplement.SupplementMin END
             
        FROM _tmpGoods_SUN_Supplement
        
             LEFT JOIN _tmpUnit_SUN_Supplement ON 1 = 1
             
             LEFT JOIN tmpUnitSupplementSUN1In ON tmpUnitSupplementSUN1In.UnitId = _tmpUnit_SUN_Supplement.UnitId
        
             LEFT JOIN tmpPrice AS tmpObject_Price 
                                ON tmpObject_Price.UnitId  = _tmpUnit_SUN_Supplement.UnitId
                               AND tmpObject_Price.GoodsId = _tmpGoods_SUN_Supplement.GoodsId

             LEFT JOIN tmpRemains AS tmpRemains
                                  ON tmpRemains.UnitId  = _tmpUnit_SUN_Supplement.UnitId
                                 AND tmpRemains.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
                                 
             LEFT JOIN tmpSalesDay AS tmpSalesDay
                                   ON tmpSalesDay.UnitId  = _tmpUnit_SUN_Supplement.UnitId
                                  AND tmpSalesDay.GoodsId = _tmpGoods_SUN_Supplement.GoodsId

             LEFT JOIN tmpSalesMonth AS tmpSalesMonth
                                     ON tmpSalesMonth.UnitId  = _tmpUnit_SUN_Supplement.UnitId
                                    AND tmpSalesMonth.GoodsId = _tmpGoods_SUN_Supplement.GoodsId

             LEFT JOIN _tmpGoods_Sun_exception_Supplement ON _tmpGoods_Sun_exception_Supplement.UnitId  = _tmpUnit_SUN_Supplement.UnitId
                                              AND _tmpGoods_Sun_exception_Supplement.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
                                              
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id =  _tmpUnit_SUN_Supplement.UnitId

             LEFT JOIN _tmpGoodsLayout_SUN_Supplement ON _tmpGoodsLayout_SUN_Supplement.GoodsID = _tmpGoods_SUN_Supplement.GoodsId
                                                     AND _tmpGoodsLayout_SUN_Supplement.UnitId = _tmpUnit_SUN_Supplement.UnitId
                                                     
             LEFT JOIN _tmpGoods_TP_exception_Supplement ON _tmpGoods_TP_exception_Supplement.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
                                                        AND _tmpGoods_TP_exception_Supplement.UnitId = _tmpUnit_SUN_Supplement.UnitId
                                                        
        WHERE (COALESCE (tmpUnitSupplementSUN1In.UnitId, 0) = 0
           OR tmpUnitSupplementSUN1In.UnitId = _tmpGoods_SUN_Supplement.UnitSupplementSUN1InId)
       ;
       
     ANALYSE _tmpRemains_all_Supplement;
                                     
-- raise notice 'Value 14: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM _tmpRemains_all_Supplement);


     IF EXISTS (SELECT 1
                FROM _tmpGoods_SUN_Supplement 
                     INNER JOIN _tmpGoodsUnit_SUN_Supplement ON _tmpGoodsUnit_SUN_Supplement.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
                WHERE _tmpGoods_SUN_Supplement.isSmudge = True)
     THEN

       UPDATE _tmpRemains_all_Supplement SET GiveAway = (SELECT FLOOR(SUM(tmpRemains.AmountRemains - COALESCE(tmpRemains.MCS, 0)
                                                            - CASE WHEN COALESCE(tmpRemains.AmountNotSend, 0) > 
                                                                       COALESCE(tmpRemains.Layout, 0) 
                                                                       + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                   THEN COALESCE(tmpRemains.AmountNotSend, 0)
                                                                   ELSE COALESCE(tmpRemains.Layout, 0) 
                                                                      + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END))
                                                         FROM _tmpRemains_all_Supplement AS tmpRemains 
                                                         
                                                              LEFT JOIN _tmpGoods_PromoUnit_Supplement ON _tmpGoods_PromoUnit_Supplement.GoodsID = tmpRemains.GoodsId
                                                                                                      AND _tmpGoods_PromoUnit_Supplement.UnitId = tmpRemains.UnitId  
                                                                                                      
                                                         WHERE tmpRemains.GoodsId = _tmpRemains_all_Supplement.GoodsId
                                                           AND (tmpRemains.AmountRemains - COALESCE(tmpRemains.AmountNotSend, 0)) > 0
                                                           AND tmpRemains.UnitId = _tmpRemains_all_Supplement.UnitId)
       FROM (SELECT _tmpGoods_SUN_Supplement.GoodsId
                  , _tmpGoodsUnit_SUN_Supplement.UnitOutId
             FROM _tmpGoods_SUN_Supplement 
                  INNER JOIN _tmpGoodsUnit_SUN_Supplement ON _tmpGoodsUnit_SUN_Supplement.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
             WHERE _tmpGoods_SUN_Supplement.isSmudge = True) AS _tmpGoods_SUN_Supplement 
       WHERE _tmpGoods_SUN_Supplement.GoodsId = _tmpRemains_all_Supplement.GoodsId
         AND COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0)  = _tmpRemains_all_Supplement.UnitId;

/*       --raise notice 'Value 05: % % %', 
                    (SELECT count(*) FROM _tmpRemains_all_Supplement WHERE _tmpRemains_all_Supplement.GiveAway > 0),
                    (SELECT count(*) FROM _tmpGoodsUnit_SUN_Supplement WHERE _tmpGoodsUnit_SUN_Supplement.GoodsId = 15982622),
                    (SELECT FLOOR(tmpRemains.AmountRemains - tmpRemains.MCS
                                                            - CASE WHEN COALESCE(tmpRemains.AmountNotSend, 0) > 
                                                                       COALESCE(tmpRemains.Layout, 0) 
                                                                       + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                   THEN COALESCE(tmpRemains.AmountNotSend, 0)
                                                                   ELSE COALESCE(tmpRemains.Layout, 0) 
                                                                      + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END))
                                                         FROM _tmpRemains_all_Supplement AS tmpRemains 
                                                         
                                                              LEFT JOIN _tmpGoods_PromoUnit_Supplement ON _tmpGoods_PromoUnit_Supplement.GoodsID = tmpRemains.GoodsId
                                                                                                      AND _tmpGoods_PromoUnit_Supplement.UnitId = tmpRemains.UnitId  
                                                                                                      
                                                         WHERE tmpRemains.GoodsId = 15982622
                                                           AND (tmpRemains.AmountRemains - COALESCE(tmpRemains.AmountNotSend, 0)) > 0
                                                           AND tmpRemains.UnitId = 4135547);*/
       
       UPDATE _tmpRemains_all_Supplement SET GiveAway = - CEIL((SELECT SUM(tmpRemains.GiveAway) 
                                                                FROM _tmpRemains_all_Supplement AS tmpRemains
                                                                WHERE tmpRemains.GoodsId = _tmpRemains_all_Supplement.GoodsId
                                                                  AND tmpRemains.GiveAway > 0) / 
                                                               (SELECT COUNT(*)
                                                                FROM _tmpRemains_all_Supplement AS tmpRemains
                                                                     LEFT JOIN _tmpGoodsUnit_SUN_Supplement ON _tmpGoodsUnit_SUN_Supplement.GoodsId = tmpRemains.GoodsId
                                                                                                           AND _tmpGoodsUnit_SUN_Supplement.UnitOutId = tmpRemains.UnitId 
                                                                WHERE tmpRemains.GoodsId = _tmpRemains_all_Supplement.GoodsId
                                                                  AND COALESCE (_tmpGoodsUnit_SUN_Supplement.GoodsId, 0) = 0))
       FROM (SELECT _tmpRemains_all_Supplement.GoodsId
                  , _tmpRemains_all_Supplement.UnitId
             FROM _tmpGoods_SUN_Supplement 
             
                  INNER JOIN _tmpRemains_all_Supplement ON _tmpRemains_all_Supplement.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
                  
                  LEFT JOIN _tmpGoodsUnit_SUN_Supplement ON _tmpGoodsUnit_SUN_Supplement.GoodsId = _tmpRemains_all_Supplement.GoodsId
                                                        AND _tmpGoodsUnit_SUN_Supplement.UnitOutId = _tmpRemains_all_Supplement.UnitId
                                                        
             WHERE _tmpGoods_SUN_Supplement.isSmudge = True
               AND COALESCE (_tmpGoodsUnit_SUN_Supplement.GoodsId, 0) = 0) AS _tmpGoods_SUN_Supplement 
       WHERE _tmpGoods_SUN_Supplement.GoodsId = _tmpRemains_all_Supplement.GoodsId
         AND _tmpGoods_SUN_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId;
     
     END IF;

       
/*     IF CURRENT_DATE <= '20.10.2021'
     THEN

       ---------
       UPDATE _tmpRemains_all_Supplement SET GiveAway = (SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (26661170, 26987077))
       WHERE _tmpRemains_all_Supplement.UnitId = 9951517
         AND _tmpRemains_all_Supplement.GoodsId = 880570 ;
       
       UPDATE _tmpRemains_all_Supplement SET GiveAway = - CEIL((SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (26661170, 26987077)) / 
                                                               (SELECT count(*) FROM _tmpRemains_all_Supplement
                                                                WHERE _tmpRemains_all_Supplement.UnitId <> 9951517
                                                                  AND _tmpRemains_all_Supplement.GoodsId = 880570 ))
       WHERE _tmpRemains_all_Supplement.UnitId <> 9951517
         AND _tmpRemains_all_Supplement.GoodsId = 880570 ;
         
        
       ---------
       UPDATE _tmpRemains_all_Supplement SET GiveAway = (SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (28561767))
       WHERE _tmpRemains_all_Supplement.UnitId = 11152911
         AND _tmpRemains_all_Supplement.GoodsId = 2485 ;
       
       UPDATE _tmpRemains_all_Supplement SET GiveAway = - CEIL((SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (28561767)) / 
                                                               (SELECT count(*) FROM _tmpRemains_all_Supplement
                                                                WHERE _tmpRemains_all_Supplement.UnitId <> 11152911
                                                                  AND _tmpRemains_all_Supplement.GoodsId = 2485 ))
       WHERE _tmpRemains_all_Supplement.UnitId <> 11152911
         AND _tmpRemains_all_Supplement.GoodsId = 2485 ;

       ---------
       UPDATE _tmpRemains_all_Supplement SET GiveAway = (SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (28942901, 28958572))
       WHERE _tmpRemains_all_Supplement.UnitId = 8156016
         AND _tmpRemains_all_Supplement.GoodsId = 25516 ;
       
       UPDATE _tmpRemains_all_Supplement SET GiveAway = - CEIL((SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (28942901, 28958572)) / 
                                                               (SELECT count(*) FROM _tmpRemains_all_Supplement
                                                                WHERE _tmpRemains_all_Supplement.UnitId <> 8156016
                                                                  AND _tmpRemains_all_Supplement.GoodsId = 25516 ))
       WHERE _tmpRemains_all_Supplement.UnitId <> 8156016
         AND _tmpRemains_all_Supplement.GoodsId = 25516 ;

     END IF;*/

     -- 2. ��� �������, ���, � ����. ��������� ������
     --
     WITH tmpResult AS (SELECT _tmpRemains_all_Supplement.GoodsId                               AS GoodsId
                             , SUM(_tmpRemains_all_Supplement.MCS)                              AS MCS

                               -- �������
                             , SUM(COALESCE (_tmpRemains_all_Supplement.AmountRemains, 0))      AS AmountRemains
                               -- ����������
                             , SUM(COALESCE (_tmpRemains_all_Supplement.AmountSalesDay, 0))     AS AmountSalesDay

                        FROM _tmpRemains_all_Supplement
                        GROUP BY _tmpRemains_all_Supplement.GoodsId
                        )
        , tmpUnit AS (SELECT max(_tmpUnit_SUN_Supplement.DeySupplSun1)  AS DeySupplSun1
                      FROM _tmpUnit_SUN_Supplement
                      )

     -- 2. ���������: ��� �������, ��� �������, ���, � ����. ��������� ������
     INSERT INTO  _tmpStockRatio_all_Supplement (GoodsId, MCS, AmountRemains, AmountSalesDay, AverageSales, StockRatio)
        SELECT tmpResult.GoodsId
             , tmpResult.MCS

               -- �������
             , tmpResult.AmountRemains
               -- ����������
             , tmpResult.AmountSalesDay

             , CASE WHEN (tmpResult.AmountRemains - tmpResult.MCS) > 0
                    THEN tmpResult.AmountSalesDay / (tmpResult.AmountRemains - tmpResult.MCS)
                    ELSE 0 END ::TFloat AS  AverageSales
             , CASE WHEN (tmpResult.AmountRemains - tmpResult.MCS) > 0
                    THEN tmpResult.AmountSalesDay / (tmpResult.AmountRemains - tmpResult.MCS) * tmpUnit.DeySupplSun1
                    ELSE 0 END ::TFloat AS  StockRatio

        FROM tmpResult

             LEFT JOIN tmpUnit ON 1 = 1

       ;
       
       ANALYSE _tmpStockRatio_all_Supplement;

--raise notice 'Value 15: %', CLOCK_TIMESTAMP();


     -- ������������� ������������ �� ����� ����� ��� � �������
     CREATE TEMP TABLE tmpNeed_all_Supplement ON COMMIT DROP AS
     (WITH
               -- ���������� ��� �������������
               tmpMI_Master AS (SELECT _tmpRemains_all_Supplement.GoodsId                             AS GoodsId
                                     , SUM (_tmpRemains_all_Supplement.AmountRemains - 
                                            _tmpRemains_all_Supplement.AmountNotSend):: TFloat        AS Amount
                                     , SUM (COALESCE (_tmpRemains_all_Supplement.AmountRemains,0))    AS Remains
                                     , SUM (COALESCE (_tmpRemains_all_Supplement.AmountSalesMonth,0)) AS AmountOut_real
                                     
                                FROM _tmpRemains_all_Supplement
                                
                                     INNER JOIN _tmpGoods_SUN_Supplement ON  _tmpGoods_SUN_Supplement.GoodsId    = _tmpRemains_all_Supplement.GoodsId
                                                                        AND  _tmpGoods_SUN_Supplement.isMarcCalc = TRUE  
                                                                        
                                GROUP BY _tmpRemains_all_Supplement.GoodsId    
                                )
             -- ������ ���-�� ���� �������
             , tmpRemainsDay AS (SELECT tmpMI_Master.GoodsId
                                      , tmpMI_Master.Amount        AS Amount_Master
                                      , CASE WHEN COALESCE (tmpMI_Master.AmountOut_real,0) <> 0 AND COALESCE (vbDays,0) <> 0
                                             THEN (COALESCE (tmpMI_Master.Remains,0) + COALESCE (tmpMI_Master.Amount,0)) / (COALESCE (tmpMI_Master.AmountOut_real,0) / vbDays)
                                             ELSE 0
                                        END AS RemainsDay
                                 FROM tmpMI_Master
                                )
            -- ������ �����.
             , tmpMI_Child_Calc AS (SELECT tmpMI_Child.GoodsId
                                         , tmpMI_Child.UnitId
                                         , tmpRemainsDay.Amount_Master
                                         , tmpMI_Child.AmountRemains     AS Remains
                                         , tmpMI_Child.AmountSalesMonth  AS AmountOut_real
                                         , (((tmpMI_Child.AmountSalesMonth / vbDays) * tmpRemainsDay.RemainsDay - COALESCE (tmpMI_Child.AmountRemains,0)) / tmpRemainsDay.RemainsDay) :: TFloat AS Koeff
                                    FROM _tmpRemains_all_Supplement AS tmpMI_Child
                                         LEFT JOIN tmpRemainsDay ON tmpRemainsDay.GoodsId = tmpMI_Child.GoodsId
                                    WHERE COALESCE(tmpRemainsDay.RemainsDay, 0) > 0
                                   )
             -- ������������� ���-�� ���� ������� ��� ����� � �����. �����.
             , tmpRemainsDay2 AS (SELECT tmpMI_Master.GoodsId
                                      , CASE WHEN (COALESCE (tmpChild.AmountOut_real,0) / vbDays) <> 0
                                             THEN (COALESCE (tmpChild.Remains,0) + COALESCE (tmpMI_Master.Amount,0)) / (COALESCE (tmpChild.AmountOut_real,0) / vbDays)
                                             ELSE 0
                                        END AS RemainsDay
                                  FROM tmpMI_Master
                                      LEFT JOIN (SELECT MovementItem.GoodsId
                                                      , SUM (COALESCE (MovementItem.Remains,0))        AS Remains
                                                      , SUM (COALESCE (MovementItem.AmountOut_real,0)) AS AmountOut_real
                                                 FROM tmpMI_Child_Calc AS MovementItem
                                                 WHERE COALESCE (MovementItem.Koeff,0) > 0
                                                 GROUP BY MovementItem.GoodsId
                                                 ) AS tmpChild ON tmpChild.GoodsId = tmpMI_Master.GoodsId
                                 )
             , tmpData AS (SELECT tmpData_all.GoodsId
                                , tmpData_all.UnitId
                                , tmpData_all.AmountOut_real
                                , (((tmpData_all.AmountOut_real /vbDays )* tmpRemainsDay2.RemainsDay - 
                                     COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) AS AmountOut
                                , tmpData_all.Remains
                                , tmpData_all.Amount_Master
                                , SUM (((tmpData_all.AmountOut_real /vbDays )* tmpRemainsDay2.RemainsDay - 
                                         COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) OVER (PARTITION BY tmpData_all.GoodsId) AS AmountOutSUM
                           FROM tmpMI_Child_Calc AS tmpData_all
                                LEFT JOIN tmpRemainsDay2 ON tmpRemainsDay2.GoodsId = tmpData_all.GoodsId
                           WHERE COALESCE (tmpData_all.Koeff,0) > 0
                             AND (((tmpData_all.AmountOut_real /vbDays )* tmpRemainsDay2.RemainsDay - COALESCE (tmpData_all.Remains,0))/tmpRemainsDay2.RemainsDay) > 0
                           )
             , tmpData1 AS (SELECT tmpData.GoodsId
                                 , tmpData.UnitId
                                 , tmpData.AmountOut
                                 , tmpData.AmountOut_real
                                 , tmpData.Remains
                                 , CASE WHEN tmpData.AmountOutSUM <> 0
                                        THEN ROUND ( tmpData.Amount_Master / tmpData.AmountOutSUM * tmpData.AmountOut, 0)
                                        ELSE 0
                                   END   AS Amount_Calc
                           FROM tmpData
                           )                                
              -- ��������������� ������� ��� ������������� ������
             , tmpData111 AS (SELECT tmpData1.GoodsId
                                   , tmpData1.UnitId
                                   , tmpMI_Master.Amount          AS Amount_Master
                                   , tmpData1.Amount_Calc
                                   , tmpData1.AmountOut
                                   , tmpData1.AmountOut_real
                                   , tmpData1.Remains
                                   , SUM (tmpData1.Amount_Calc) OVER (PARTITION BY tmpData1.GoodsId ORDER BY tmpData1.AmountOut, tmpMI_Master.GoodsId) AS Amount_CalcSUM
                                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_Master.GoodsId ORDER BY tmpData1.AmountOut DESC) AS DOrd
                              FROM tmpMI_Master
                                   INNER JOIN tmpData1 AS tmpData1 ON tmpData1.GoodsId = tmpMI_Master.GoodsId
                              )
             -- ��������������� �������������
             , tmpCalc AS (SELECT DD.GoodsId
                                , DD.UnitId
                                , DD.AmountOut_real AS AmountOut
                                , DD.Remains
                                , CASE WHEN DD.Amount_Master - DD.Amount_CalcSUM > 0 AND DD.DOrd <> 1
                                            THEN ceil (DD.Amount_Calc)                                           ---ceil
                                       ELSE ceil ( DD.Amount_Master - DD.Amount_CalcSUM + DD.Amount_Calc)
                                  END AS AmountIn
                           FROM tmpData111 AS DD
                           WHERE DD.Amount_Master - (DD.Amount_CalcSUM - DD.Amount_Calc) > 0
                          )

       SELECT _tmpRemains_all_Supplement.GoodsId                             AS GoodsId
            , _tmpRemains_all_Supplement.UnitId                              AS UnitId
            , COALESCE (tmpCalc.AmountIn) :: TFloat                          AS Need
       FROM _tmpRemains_all_Supplement
       
            INNER JOIN _tmpGoods_SUN_Supplement ON  _tmpGoods_SUN_Supplement.GoodsId    = _tmpRemains_all_Supplement.GoodsId
                                               AND  _tmpGoods_SUN_Supplement.isMarcCalc = TRUE    
                                               
            LEFT JOIN tmpCalc ON tmpCalc.GoodsId    = _tmpRemains_all_Supplement.GoodsId      
                             AND tmpCalc.UnitId     = _tmpRemains_all_Supplement.UnitId      
       
     );
     
     ANALYSE tmpNeed_all_Supplement;

   -- 2.1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     UPDATE _tmpRemains_all_Supplement SET AverageSalesMonth =(COALESCE (_tmpRemains_all_Supplement.AmountSalesMonth, 0) / extract('DAY' from CURRENT_DATE -
                                                              (CURRENT_DATE - (T1.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL)))
                                         , Need = COALESCE (T1.need,
                                                  CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 THEN 0
                                                  ELSE (_tmpRemains_all_Supplement.AmountSalesMonth / extract('DAY' from CURRENT_DATE -
                                                       (CURRENT_DATE - (T1.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL))) *
                                                       T1.StockRatio END)
                                         , AmountUse = 0
     FROM (SELECT _tmpStockRatio_all_Supplement.GoodsId
                , _tmpUnit_SUN_Supplement.UnitId
                , _tmpStockRatio_all_Supplement.StockRatio
                , CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE
                       THEN _tmpUnit_SUN_Supplement.MonthSupplSun1
                       ELSE _tmpUnit_SUN_Supplement.MonthSupplSun1 END AS MonthSupplSun1
                , tmpNeed_all_Supplement.Need
           FROM _tmpStockRatio_all_Supplement
                LEFT JOIN _tmpUnit_SUN_Supplement ON 1 = 1
                LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = _tmpStockRatio_all_Supplement.GoodsId
                LEFT JOIN tmpNeed_all_Supplement ON tmpNeed_all_Supplement.GoodsId = _tmpStockRatio_all_Supplement.GoodsId
                                                AND tmpNeed_all_Supplement.UnitId = _tmpUnit_SUN_Supplement.UnitId
                ) AS T1
                           
     WHERE _tmpRemains_all_Supplement.GoodsId = T1.GoodsId
       AND _tmpRemains_all_Supplement.UnitId = T1.UnitId;
       
--raise notice 'Value 16: %', CLOCK_TIMESTAMP();

       
     -- 2.2. ���������� ����� �� �������� �� �����
     IF EXISTS(SELECT 1 FROM _tmpRemains_all_Supplement WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0)
     THEN
       UPDATE _tmpRemains_all_Supplement SET Need = ceil(COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) + _tmpRemains_all_Supplement.AmountRemains)
       WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
         AND _tmpRemains_all_Supplement.AmountRemains < COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0)
         AND _tmpRemains_all_Supplement.Need < ceil(COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) + _tmpRemains_all_Supplement.AmountRemains)
         AND (_tmpRemains_all_Supplement.UnitId IN (SELECT _tmpUnit_SUN_Supplement.UnitId FROM _tmpUnit_SUN_Supplement WHERE _tmpUnit_SUN_Supplement.isSUN_Supplement_in = TRUE) OR
              _tmpRemains_all_Supplement.GoodsId IN (SELECT DISTINCT _tmpGoods_SUN_Supplement.GoodsId FROM _tmpGoods_SUN_Supplement WHERE _tmpGoods_SUN_Supplement.isSupplementMarkSUN1 = TRUE));

        UPDATE _tmpRemains_all_Supplement SET Need = CASE WHEN Need - T1.Amount < 0 THEN 0 ELSE Need - T1.Amount END
        FROM (WITH tmpNeedSum AS (SELECT _tmpRemains_all_Supplement.GoodsId
                                       , SUM(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)  AS NeedSum
                                  FROM _tmpRemains_all_Supplement
                                  WHERE _tmpRemains_all_Supplement.GoodsId in (SELECT DISTINCT _tmpRemains_all_Supplement.GoodsId 
                                                                               FROM _tmpRemains_all_Supplement 
                                                                               WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0)
                                  GROUP BY _tmpRemains_all_Supplement.GoodsId
                                  HAVING SUM(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains) > 0)
                 , tmpNeedCount AS (SELECT _tmpRemains_all_Supplement.GoodsId
                                         , COUNT (*)                             AS CountNeed 
                                    FROM _tmpRemains_all_Supplement
                                    WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
                                      AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) * 1.2 < (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)
                                    GROUP BY _tmpRemains_all_Supplement.GoodsId
                                    HAVING COUNT (*) > 0
                                    )
   
              SELECT _tmpRemains_all_Supplement.GoodsId
                   , _tmpRemains_all_Supplement.UnitId
                   , ceil(tmpNeedSum.NeedSum / tmpNeedCount.CountNeed) AS Amount
              FROM _tmpRemains_all_Supplement
                   INNER JOIN tmpNeedSum ON tmpNeedSum.GoodsId = _tmpRemains_all_Supplement.GoodsId
                   INNER JOIN tmpNeedCount ON tmpNeedCount.GoodsId = _tmpRemains_all_Supplement.GoodsId
              WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
                AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains) - ceil(tmpNeedSum.NeedSum / tmpNeedCount.CountNeed)
              ) AS T1
        WHERE _tmpRemains_all_Supplement.GoodsId = T1.GoodsId
          AND _tmpRemains_all_Supplement.UnitId = T1.UnitId
          AND _tmpRemains_all_Supplement.Need > 0;

     END IF;
              

--raise notice 'Value 17: %', CLOCK_TIMESTAMP();

             
     -- 2.2. ���������� ����� ��� �������� ����� ���������� ������ ��� �������
     UPDATE _tmpRemains_all_Supplement SET Need = - floor(_tmpRemains_all_Supplement.AmountRemains)
     WHERE (_tmpRemains_all_Supplement.AmountRemains + _tmpRemains_all_Supplement.Need) < 0;
                  
                  
    -- 2.3 ������� ������� �������
    
    UPDATE _tmpRemains_all_Supplement SET SurplusCalc = T1.Need
    FROM 
       (-- Income - �� X ���� - ���� ���������, 100���� ��� ������ ������� ��� �� �����
        WITH tmpIncome AS (SELECT MovementLinkObject_To.ObjectId   AS UnitId
                                , MovementItem.ObjectId            AS GoodsId
                           FROM MovementDate AS MovementDate_Branch
                                INNER JOIN Movement ON Movement.Id       = MovementDate_Branch.MovementId
                                                   AND Movement.DescId   = zc_Movement_Income()
                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                -- ������� �������� �������������
                                INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId  = MovementLinkObject_To.ObjectId

                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                                       AND MovementItem.Amount     > 0
                                -- !!!������ ��� �����!!!
                                INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = MovementItem.ObjectId
                                                          
                                INNER JOIN ObjectFloat AS OF_DI            
                                                       ON OF_DI.ObjectId  = MovementLinkObject_To.ObjectId
                                                      AND OF_DI.DescId    = zc_ObjectFloat_Unit_SunIncome()
                                                      AND OF_DI.ValueData >= 0

                           WHERE MovementDate_Branch.DescId     = zc_MovementDate_Branch()
                             AND MovementDate_Branch.ValueData BETWEEN inOperDate - (
                                                (SELECT MAX(OF_DI.ValueData)
                                                 FROM ObjectFloat AS OF_DI            
                                                 WHERE OF_DI.DescId    = zc_ObjectFloat_Unit_SunIncome()
                                                   AND OF_DI.ValueData >= 0) :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'

                           GROUP BY MovementLinkObject_To.ObjectId
                                  , MovementItem.ObjectId
                           HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (OF_DI.ValueData :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                                 THEN MovementItem.Amount
                                            ELSE 0
                                       END) > 0
                           )
       
        SELECT _tmpRemains_all_Supplement.UnitId
             , _tmpRemains_all_Supplement.GoodsId
             , CASE WHEN COALESCE (_tmpRemains_all_Supplement.GiveAway, 0) > 0 THEN COALESCE (_tmpRemains_all_Supplement.GiveAway, 0) ELSE 
               - CASE WHEN COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0) = 0 THEN
                 CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE
                      THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                             CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                                  THEN _tmpRemains_all_Supplement.AmountNotSend
                                                  ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) END) >= 1                               
                                THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                             CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                                  THEN _tmpRemains_all_Supplement.AmountNotSend
                                                  ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) END)
                                ELSE 0 END
                      WHEN (_tmpRemains_all_Supplement.AmountSalesMonth = 0 OR _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = True) AND 
                           COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                      THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                             CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0)
                                                  THEN _tmpRemains_all_Supplement.AmountNotSend
                                                  ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) END) > 0 
                                THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                             CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0)
                                                  THEN _tmpRemains_all_Supplement.AmountNotSend
                                                  ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) END)
                                ELSE 0 END
                      ELSE TRUNC(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains 
                                                            + CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > 
                                                                       COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                       + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                   THEN _tmpRemains_all_Supplement.AmountNotSend
                                                                   ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                      + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END)
                      END
                 ELSE
                 TRUNC (CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE
                             THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                                    CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                                         THEN _tmpRemains_all_Supplement.AmountNotSend
                                                         ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) END) >= 1                               
                                       THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                                    CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                                         THEN _tmpRemains_all_Supplement.AmountNotSend
                                                         ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) END)
                                       ELSE 0 END
                             WHEN (_tmpRemains_all_Supplement.AmountSalesMonth = 0 OR _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = True) AND 
                                  COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                             THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                                    CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0)
                                                         THEN _tmpRemains_all_Supplement.AmountNotSend
                                                         ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) END) > 0 
                                       THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                                    CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0)
                                                         THEN _tmpRemains_all_Supplement.AmountNotSend
                                                         ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) END)
                                       ELSE 0 END
                             ELSE FLOOR(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains 
                                                                   + CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > 
                                                                              COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                              + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                          THEN _tmpRemains_all_Supplement.AmountNotSend
                                                                          ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                             + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END)
                             END / COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)
                 END END AS Need
       FROM _tmpRemains_all_Supplement

            LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId

            LEFT JOIN _tmpGoodsUnit_SUN_Supplement ON _tmpGoodsUnit_SUN_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId
                                                  AND _tmpGoodsUnit_SUN_Supplement.UnitOutId = _tmpRemains_all_Supplement.UnitId

            LEFT JOIN (SELECT DISTINCT _tmpGoodsUnit_SUN_Supplement.GoodsId FROM _tmpGoodsUnit_SUN_Supplement) AS _tmpGoodsUnit_SUN_Supplement_All 
                                                                                                               ON _tmpGoodsUnit_SUN_Supplement_All.GoodsID = _tmpRemains_all_Supplement.GoodsId

            LEFT JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId
            
            LEFT JOIN _tmpGoods_PromoUnit_Supplement ON _tmpGoods_PromoUnit_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId
                                                    AND _tmpGoods_PromoUnit_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId  
                                                                            
            -- ������ ���������� �����
            LEFT JOIN _tmpGoods_DiscountExternal_Supplement AS _tmpGoods_DiscountExternal
                                                            ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_all_Supplement.UnitId
                                                           AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_all_Supplement.GoodsId
                                                           
            LEFT JOIN _tmpSUN_Send_Supplement ON _tmpSUN_Send_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId
                                             AND _tmpSUN_Send_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId  
            LEFT JOIN _tmpSUN_Send_SupplementAll ON _tmpSUN_Send_SupplementAll.GoodsID = _tmpRemains_all_Supplement.GoodsId
                                                AND _tmpSUN_Send_SupplementAll.UnitId = _tmpRemains_all_Supplement.UnitId  
                                                
            LEFT JOIN tmpIncome ON tmpIncome.GoodsID = _tmpRemains_all_Supplement.GoodsId
                               AND tmpIncome.UnitId = _tmpRemains_all_Supplement.UnitId  

       WHERE CASE WHEN COALESCE (_tmpRemains_all_Supplement.GiveAway, 0) > 0 THEN COALESCE (_tmpRemains_all_Supplement.GiveAway, 0) ELSE 
               - CASE WHEN COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0) = 0 THEN
                 CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE
                      THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                             CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                                  THEN _tmpRemains_all_Supplement.AmountNotSend
                                                  ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) END) >= 1                               
                                THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                             CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                                  THEN _tmpRemains_all_Supplement.AmountNotSend
                                                  ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) END)
                                ELSE 0 END
                      WHEN (_tmpRemains_all_Supplement.AmountSalesMonth = 0 OR _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = True) AND 
                           COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                      THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                             CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0)
                                                  THEN _tmpRemains_all_Supplement.AmountNotSend
                                                  ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) END) > 0 
                                THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                             CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0)
                                                  THEN _tmpRemains_all_Supplement.AmountNotSend
                                                  ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) END)
                                ELSE 0 END
                      ELSE TRUNC(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains 
                                                            + CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > 
                                                                       COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                       + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                   THEN _tmpRemains_all_Supplement.AmountNotSend
                                                                   ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                      + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END)
                      END
                 ELSE
                 TRUNC (CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE
                             THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                                    CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                                         THEN _tmpRemains_all_Supplement.AmountNotSend
                                                         ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) END) >= 1                               
                                       THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                                    CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                                         THEN _tmpRemains_all_Supplement.AmountNotSend
                                                         ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) + COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) END)
                                       ELSE 0 END
                             WHEN (_tmpRemains_all_Supplement.AmountSalesMonth = 0 OR _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = True) AND 
                                  COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                             THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                                    CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0)
                                                         THEN _tmpRemains_all_Supplement.AmountNotSend
                                                         ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) END) > 0 
                                       THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - 
                                                    CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > COALESCE(_tmpRemains_all_Supplement.Layout, 0)
                                                         THEN _tmpRemains_all_Supplement.AmountNotSend
                                                         ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) END)
                                       ELSE 0 END
                             ELSE FLOOR(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains 
                                                                   + CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > 
                                                                              COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                              + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                          THEN _tmpRemains_all_Supplement.AmountNotSend
                                                                          ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                             + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END)
                             END / COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)
                 END END > 0
                 
         AND (_tmpUnit_SUN_Supplement.isSUN_Supplement_out = True OR 
             COALESCE(_tmpGoods_SUN_Supplement.isSupplementMarkSUN1, FALSE) = TRUE AND 
             COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0)
         AND (COALESCE(_tmpGoodsUnit_SUN_Supplement_All.GoodsId, 0) = 0 
           OR COALESCE(_tmpGoodsUnit_SUN_Supplement.UnitOutId, 0) = _tmpRemains_all_Supplement.UnitId)
         AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
         AND COALESCE(_tmpSUN_Send_Supplement.GoodsID, 0) = 0
         AND COALESCE(_tmpSUN_Send_Supplement.GoodsID, 0) = 0
         --AND COALESCE(tmpIncome.GoodsID, 0) = 0
         ) AS T1
         
    WHERE _tmpRemains_all_Supplement.UnitId = T1.UnitId
      AND _tmpRemains_all_Supplement.GoodsId = T1.GoodsId 
       ;
        
--raise notice 'Value 18: %', CLOCK_TIMESTAMP();

       
    -- 2.4 ������� ������� ����� ������
                     
    UPDATE _tmpRemains_all_Supplement SET NeedCalc = T1.Need
    FROM 
      (SELECT _tmpRemains_all_Supplement.UnitId
            , _tmpRemains_all_Supplement.GoodsId
            , FLOOR(CASE WHEN COALESCE (GiveAway, 0) < 0 THEN - COALESCE (GiveAway, 0) ELSE 
                    CASE WHEN COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0) = 0 THEN
                    CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
                         THEN CASE WHEN _tmpRemains_all_Supplement.AmountRemains + 1 < COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                   THEN TRUNC(COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0))
                                   ELSE 0 END
                         WHEN _tmpGoods_SUN_Supplement.isSmudge = FALSE AND _tmpGoods_SUN_Supplement.isSupplementMarkSUN1 = TRUE
                          AND COALESCE (_tmpRemains_all_Supplement.SupplementMin, 0) > 0 
                         THEN CASE WHEN FLOOR(_tmpRemains_all_Supplement.SupplementMin - _tmpRemains_all_Supplement.AmountRemains) > 0
                                   THEN FLOOR(_tmpRemains_all_Supplement.SupplementMin - _tmpRemains_all_Supplement.AmountRemains)
                                   ELSE 0 END
                         WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) = 0
                         THEN CASE WHEN TRUNC(COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) - _tmpRemains_all_Supplement.AmountRemains) >= 1
                                   THEN TRUNC(COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) - _tmpRemains_all_Supplement.AmountRemains)
                                   ELSE 0 END
                         WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                         THEN - _tmpRemains_all_Supplement.AmountRemains
                         ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                         END  - _tmpRemains_all_Supplement.AmountUse
                    ELSE
                    FLOOR ((CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
                                 THEN CASE WHEN _tmpRemains_all_Supplement.AmountRemains + 1 < COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                           THEN TRUNC(COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0))
                                           ELSE 0 END
                                 WHEN _tmpGoods_SUN_Supplement.isSmudge = FALSE AND _tmpGoods_SUN_Supplement.isSupplementMarkSUN1 = TRUE
                                  AND COALESCE (_tmpRemains_all_Supplement.SupplementMin, 0) > 0 
                                 THEN CASE WHEN FLOOR(_tmpRemains_all_Supplement.SupplementMin - _tmpRemains_all_Supplement.AmountRemains) > 0
                                           THEN FLOOR(_tmpRemains_all_Supplement.SupplementMin - _tmpRemains_all_Supplement.AmountRemains)
                                           ELSE 0 END
                                 WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) = 0
                                 THEN CASE WHEN TRUNC(COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) - _tmpRemains_all_Supplement.AmountRemains) >= 1
                                           THEN TRUNC(COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) - _tmpRemains_all_Supplement.AmountRemains)
                                           ELSE 0 END
                                 WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0)<= 0
                                 THEN - _tmpRemains_all_Supplement.AmountRemains
                                 ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                                 END  - _tmpRemains_all_Supplement.AmountUse) / COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)

                    END END) AS Need
       FROM _tmpRemains_all_Supplement

            LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId

            LEFT JOIN _tmpGoodsUnit_SUN_Supplement ON _tmpGoodsUnit_SUN_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId
                                                  AND _tmpGoodsUnit_SUN_Supplement.UnitOutId = _tmpRemains_all_Supplement.UnitId

            LEFT JOIN (SELECT DISTINCT _tmpGoodsUnit_SUN_Supplement.GoodsId FROM _tmpGoodsUnit_SUN_Supplement) AS _tmpGoodsUnit_SUN_Supplement_All 
                                                                                                               ON _tmpGoodsUnit_SUN_Supplement_All.GoodsID = _tmpRemains_all_Supplement.GoodsId

            LEFT JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId

            -- ������ ���������� �����
            LEFT JOIN _tmpGoods_DiscountExternal_Supplement AS _tmpGoods_DiscountExternal
                                                            ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_all_Supplement.UnitId
                                                           AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_all_Supplement.GoodsId

            -- ��������� �������� ����� ������� ���������
            LEFT JOIN _tmpGoods_Sun_exception_Supplement AS _tmpGoods_Sun_exception_Supplement
                                                         ON _tmpGoods_Sun_exception_Supplement.UnitId  = _tmpRemains_all_Supplement.UnitId
                                                        AND _tmpGoods_Sun_exception_Supplement.GoodsId = _tmpRemains_all_Supplement.GoodsId
                                                        
            -- ���� ����� ����� ������
            LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun_Supplement.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun_Supplement
                      ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_all_Supplement.GoodsId

       WHERE FLOOR(CASE WHEN COALESCE (GiveAway, 0) < 0 THEN - COALESCE (GiveAway, 0) ELSE 
                        CASE WHEN COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0) = 0 THEN
                        CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
                             THEN CASE WHEN _tmpRemains_all_Supplement.AmountRemains + 1 < COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                       THEN TRUNC(COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0))
                                       ELSE 0 END
                             WHEN _tmpGoods_SUN_Supplement.isSmudge = FALSE AND _tmpGoods_SUN_Supplement.isSupplementMarkSUN1 = TRUE
                              AND COALESCE (_tmpRemains_all_Supplement.SupplementMin, 0) > 0 
                             THEN CASE WHEN FLOOR(_tmpRemains_all_Supplement.SupplementMin - _tmpRemains_all_Supplement.AmountRemains) > 0
                                       THEN FLOOR(_tmpRemains_all_Supplement.SupplementMin - _tmpRemains_all_Supplement.AmountRemains)
                                       ELSE 0 END
                             WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) = 0
                             THEN CASE WHEN TRUNC(COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) - _tmpRemains_all_Supplement.AmountRemains) >= 1
                                       THEN TRUNC(COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) - _tmpRemains_all_Supplement.AmountRemains)
                                       ELSE 0 END
                             WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                             THEN - _tmpRemains_all_Supplement.AmountRemains
                             ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                             END  - _tmpRemains_all_Supplement.AmountUse
                        ELSE
                        FLOOR ((CASE WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
                                     THEN CASE WHEN _tmpRemains_all_Supplement.AmountRemains + 1 < COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0)
                                               THEN TRUNC(COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0))
                                               ELSE 0 END
                                     WHEN _tmpGoods_SUN_Supplement.isSmudge = FALSE AND _tmpGoods_SUN_Supplement.isSupplementMarkSUN1 = TRUE
                                      AND COALESCE (_tmpRemains_all_Supplement.SupplementMin, 0) > 0 
                                     THEN CASE WHEN FLOOR(_tmpRemains_all_Supplement.SupplementMin - _tmpRemains_all_Supplement.AmountRemains) > 0
                                               THEN FLOOR(_tmpRemains_all_Supplement.SupplementMin - _tmpRemains_all_Supplement.AmountRemains)
                                               ELSE 0 END
                                     WHEN _tmpGoods_SUN_Supplement.isSmudge = TRUE AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) = 0
                                     THEN CASE WHEN TRUNC(COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) - _tmpRemains_all_Supplement.AmountRemains) >= 1
                                               THEN TRUNC(COALESCE(_tmpRemains_all_Supplement.AmountSalesMonth, 0) - _tmpRemains_all_Supplement.AmountRemains)
                                               ELSE 0 END
                                     WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                                     THEN - _tmpRemains_all_Supplement.AmountRemains
                                     ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                                     END  - _tmpRemains_all_Supplement.AmountUse) / COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)

                        END END) > 0
         AND _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = False
         AND _tmpUnit_SUN_Supplement.isSUN_Supplement_in = True /*OR 
             COALESCE(_tmpGoods_SUN_Supplement.isSupplementMarkSUN1, FALSE) = TRUE AND 
             COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0)*/
         AND (COALESCE(_tmpGoodsUnit_SUN_Supplement_All.GoodsId, 0) = 0 
           OR COALESCE(_tmpGoodsUnit_SUN_Supplement.UnitOutId, 0) = 0)
         AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
         AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) >= 0
         AND COALESCE(_tmpGoods_Sun_exception_Supplement.Amount, 0) = 0
         AND NOT (_tmpGoods_SUN_Supplement.isSmudge = FALSE AND _tmpGoods_SUN_Supplement.isSupplementMarkSUN1 = TRUE
                  AND COALESCE (_tmpRemains_all_Supplement.SupplementMin, 0) > 0 
                  AND FLOOR(_tmpRemains_all_Supplement.SupplementMin - _tmpRemains_all_Supplement.AmountRemains) < 0)
         AND (COALESCE(_tmpGoods_SUN_Supplement.isSupplementMarkSUN1, False) = False OR COALESCE (_tmpRemains_all_Supplement.SupplementMin, 0) >= 0)
         AND COALESCE (_tmpGoods_SUN_PairSun_find.GoodsId_PairSun, 0) = 0) AS T1
         
    WHERE _tmpRemains_all_Supplement.UnitId = T1.UnitId
      AND _tmpRemains_all_Supplement.GoodsId = T1.GoodsId
      AND COALESCE (_tmpRemains_all_Supplement.SurplusCalc, 0) = 0;
                  
--raise notice 'Value 19: %', CLOCK_TIMESTAMP();
    
-- raise notice 'Value 10: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM _tmpRemains_all_Supplement  where _tmpRemains_all_Supplement.GoodsId = 21185549 and _tmpRemains_all_Supplement.NeedCalc > 0);

                      
     -- 3. ������������
     --
     -- ������1 - ��� �����������
     OPEN curPartion_next FOR 
         SELECT _tmpRemains_all_Supplement.UnitId
              , _tmpRemains_all_Supplement.GoodsId
              , _tmpRemains_all_Supplement.NeedCalc
              , ObjectLink_Unit_Juridical.ChildObjectId         
         FROM _tmpRemains_all_Supplement

              LEFT JOIN (SELECT tmp.GoodsId FROM gpSelect_Object_GoodsPromo(inOperDate := CURRENT_DATE , inRetailId := 4 , inSession := inUserId::TVarChar) AS tmp 
                         WHERE tmp.isNotUseSUN = TRUE) AS tmpGoodsPromo ON tmpGoodsPromo.GoodsId = _tmpRemains_all_Supplement.GoodsId

              LEFT JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId

              -- � �����, ��������� !!�����!!
              LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_all_Supplement.GoodsId

              LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_all_Supplement.UnitId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                    
         WHERE _tmpRemains_all_Supplement.NeedCalc > 0
           AND COALESCE(tmpGoodsPromo.GoodsId, 0) = 0
              -- ��������� !!�����!!
           AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
               tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE OR
               _tmpUnit_SUN_Supplement.isColdOutSUN = TRUE)
         ORDER BY _tmpRemains_all_Supplement.NeedCalc DESC
                , _tmpRemains_all_Supplement.UnitId
                , _tmpRemains_all_Supplement.GoodsId;

     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curPartion_next INTO vbUnitId_to, vbGoodsId, vbNeed, vbJuridicalId;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         -- ������2. - ��� ����� ������ ��� vbGoodsId
         OPEN curResult_next FOR
           SELECT _tmpRemains_all_Supplement.UnitId
                , _tmpRemains_all_Supplement.SurplusCalc
           FROM _tmpRemains_all_Supplement

                LEFT JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId
                
                LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = _tmpRemains_all_Supplement.GoodsId

                -- ��������� !!����������!!
                LEFT JOIN _tmpUnit_SunExclusion_Supplement ON _tmpUnit_SunExclusion_Supplement.UnitId_from = _tmpRemains_all_Supplement.UnitId
                                                          AND _tmpUnit_SunExclusion_Supplement.UnitId_to   = vbUnitId_to
                
                LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                     ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_all_Supplement.UnitId
                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

           WHERE _tmpRemains_all_Supplement.SurplusCalc > 0
             AND _tmpRemains_all_Supplement.UnitId <> vbUnitId_to
             AND _tmpRemains_all_Supplement.GoodsId = vbGoodsId
             AND COALESCE(_tmpUnit_SunExclusion_Supplement.UnitId_to, 0) = 0
             AND (vbisLegalEntitiesSUN = FALSE /*OR _tmpGoods_SUN_Supplement.isSupplementMarkSUN1 = TRUE*/ OR ObjectLink_Unit_Juridical.ChildObjectId = vbJuridicalId)
           ORDER BY _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority DESC
                  , _tmpRemains_all_Supplement.SurplusCalc DESC
                  , _tmpRemains_all_Supplement.UnitId
                  , _tmpRemains_all_Supplement.GoodsId
           ;
                    
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� ���������
         LOOP
             -- ������ �� ���������
             FETCH curResult_next INTO vbUnitId_From, vbSurplus;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR (vbNeed) <= 0 THEN EXIT; END IF;

             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR FLOOR (vbSurplus) <= 0 THEN EXIT; END IF;
             
             INSERT INTO _tmpResult_Supplement (UnitId_from, UnitId_to, GoodsId, Amount)
               VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END);

             UPDATE _tmpRemains_all_Supplement SET AmountUse = AmountUse + CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END
                                                 ,  NeedCalc = NeedCalc - CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END  
             WHERE _tmpRemains_all_Supplement.UnitId = vbUnitId_to
               AND _tmpRemains_all_Supplement.GoodsId = vbGoodsId;
               
             UPDATE _tmpRemains_all_Supplement SET SurplusCalc = SurplusCalc - CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END  
             WHERE _tmpRemains_all_Supplement.UnitId = vbUnitId_from
               AND _tmpRemains_all_Supplement.GoodsId = vbGoodsId;

             vbNeed := vbNeed - CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END;

         END LOOP; -- ����� ����� �� �������2
         CLOSE curResult_next; -- ������� ������2.

     END LOOP; -- ����� ����� �� �������1
     CLOSE curPartion_next; -- ������� ������1
     
     ANALYSE _tmpResult_Supplement;

--raise notice 'Value 20: %', CLOCK_TIMESTAMP();

     -- !!! �������� ������, ����� ������������� ...
     WITH -- ����� � �������� ����� ����
          tmpResult_Partion AS (SELECT _tmpResult_Supplement.*, _tmpGoods_SUN_PairSun_Supplement.GoodsId_PairSun, _tmpGoods_SUN_PairSun_Supplement.PairSunAmount
                                FROM _tmpResult_Supplement

                                     INNER JOIN _tmpGoods_SUN_PairSun_Supplement ON _tmpGoods_SUN_PairSun_Supplement.GoodsId = _tmpResult_Supplement.GoodsId
                                ),
          -- ������� ������
          tmpRemains_Pair  AS (SELECT _tmpRemains_all_Supplement.GoodsId
                                    , _tmpRemains_all_Supplement.UnitId
                                    , _tmpRemains_all_Supplement.Price
                                    , _tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.AmountNotSend, 0) AS AmountRemains
                               FROM _tmpRemains_all_Supplement
                               WHERE _tmpRemains_all_Supplement.GoodsId IN (SELECT DISTINCT  _tmpGoods_SUN_PairSun_Supplement.GoodsId_PairSun FROM  _tmpGoods_SUN_PairSun_Supplement)
                                 AND _tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.AmountNotSend, 0) > 0
                               ),
          -- �������������
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

     INSERT INTO _tmpResult_Supplement (UnitId_from, UnitId_to, GoodsId, Amount)
     SELECT tmpItem.UnitId_from
          , tmpItem.UnitId_to
          , tmpItem.GoodsId_PairSun
          , tmpItem.AmountAdd
        FROM (SELECT DD.*
                   , CASE WHEN DD.AmountRemains - DD.AmountSUM > 0 --AND DD.DOrd <> 1
                               THEN DD.AmountPair
                          ELSE DD.AmountRemains - DD.AmountSUM + DD.AmountPair
                     END AS AmountAdd
              FROM tmpResult AS DD
              WHERE DD.AmountRemains - (DD.AmountSUM - DD.AmountPair) > 0
             ) AS tmpItem;
             
     ANALYSE _tmpResult_Supplement;

--raise notice 'Value 21: %', CLOCK_TIMESTAMP();

     -- ���������
     RETURN QUERY
       SELECT Object_Goods.Id                            AS GoodsId
            , Object_Goods_Main.ObjectCode               AS GoodsCode
            , Object_Goods_Main.Name                     AS GoodsName
            , Object_Goods_Main.isClose                  AS isClose

            , Object_Unit_From.Id                        AS UnitId_From
            , Object_Unit_From.ValueData                 AS UnitName_From

            , Object_Unit_To.Id                          AS UnitId_To
            , Object_Unit_To.ValueData                   AS UnitName_To

            , _tmpResult_Supplement.Amount               AS Amount

            , tmpRemains_all_From.MinExpirationDate

            , _tmpStockRatio_all_Supplement.MCS
            , _tmpStockRatio_all_Supplement.AmountRemains
            , _tmpStockRatio_all_Supplement.AmountSalesDay
            , _tmpStockRatio_all_Supplement.AverageSales
            , _tmpStockRatio_all_Supplement.StockRatio

            , tmpRemains_all_From.MCS                    AS MCS_From
            , _tmpGoodsLayout_SUN_Supplement.Layout      AS Layout_From
            , _tmpGoods_PromoUnit_Supplement.Amount      AS PromoUnit_From
            
            , tmpRemains_all_From.Price                  AS Price_From
            , tmpRemains_all_From.isCloseMCS             AS isCloseMCS_From
            , tmpRemains_all_From.AmountRemains          AS AmountRemains_From
            , tmpRemains_all_From.AmountSalesDay         AS AmountSalesDay_From
            , tmpRemains_all_From.AmountSalesMonth       AS AmountSalesMonth_From

            , tmpRemains_all_From.AverageSalesMonth      AS AverageSalesMonth_From
            , tmpRemains_all_From.Need                   AS Surplus_From
            , CASE WHEN tmpRemains_all_From.AmountSalesMonth = 0
                   THEN - tmpRemains_all_From.AmountRemains
                   ELSE (tmpRemains_all_From.Need -tmpRemains_all_From.AmountRemains)::Integer
              END::TFloat                                       AS Delta_From

            , tmpRemains_all_To.MCS                      AS MCS_To
            , tmpRemains_all_To.Price                    AS Price_To
            , tmpRemains_all_To.isCloseMCS               AS isCloseMCS_To
            , tmpRemains_all_To.AmountRemains            AS AmountRemains_To
            , tmpRemains_all_To.AmountSalesDay           AS AmountSalesDay_To
            , tmpRemains_all_To.AmountSalesMonth         AS AmountSalesMonth_To

            , tmpRemains_all_To.AverageSalesMonth        AS AverageSalesMonth_To
            , tmpRemains_all_To.Need                     AS Surplus_To
            , CASE WHEN tmpRemains_all_To.AmountSalesMonth = 0
                   THEN - tmpRemains_all_To.AmountRemains
                   ELSE (tmpRemains_all_To.Need -tmpRemains_all_To.AmountRemains)::Integer
              END::TFloat                                       AS Delta_To
            , tmpRemains_all_To.AmountUse                       AS AmountUse_To

            , Movement_Layout.InvNumber                  AS InvNumberLayout
            , Object_Layout.ValueData                    AS LayoutName

       FROM _tmpResult_Supplement

            INNER JOIN _tmpStockRatio_all_Supplement ON _tmpStockRatio_all_Supplement.GoodsId = _tmpResult_Supplement.GoodsId

            LEFT JOIN _tmpRemains_all_Supplement AS tmpRemains_all_From
                                                 ON tmpRemains_all_From.UnitId  = _tmpResult_Supplement.UnitId_from
                                                AND tmpRemains_all_From.GoodsId = _tmpResult_Supplement.GoodsId
            LEFT JOIN Object AS Object_Unit_From  ON Object_Unit_From.Id  = tmpRemains_all_From.UnitId


            LEFT JOIN _tmpRemains_all_Supplement AS tmpRemains_all_To
                                                 ON tmpRemains_all_To.UnitId  = _tmpResult_Supplement.UnitId_to
                                                AND tmpRemains_all_To.GoodsId = _tmpResult_Supplement.GoodsId
            LEFT JOIN Object AS Object_Unit_To  ON Object_Unit_To.Id  = tmpRemains_all_To.UnitId

            LEFT JOIN _tmpGoodsLayout_SUN_Supplement ON _tmpGoodsLayout_SUN_Supplement.GoodsID = _tmpResult_Supplement.GoodsId
                                                    AND _tmpGoodsLayout_SUN_Supplement.UnitId = _tmpResult_Supplement.UnitId_from

            LEFT JOIN _tmpGoods_PromoUnit_Supplement ON _tmpGoods_PromoUnit_Supplement.GoodsID = _tmpResult_Supplement.GoodsId
                                                    AND _tmpGoods_PromoUnit_Supplement.UnitId = _tmpResult_Supplement.UnitId_from 

            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmpRemains_all_To.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

            LEFT JOIN Movement AS Movement_Layout ON Movement_Layout.Id = _tmpGoodsLayout_SUN_Supplement.MovementLayoutId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Layout
                                         ON MovementLinkObject_Layout.MovementId = Movement_Layout.Id
                                        AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
            LEFT JOIN Object AS Object_Layout ON Object_Layout.Id = MovementLinkObject_Layout.ObjectId
            
       ORDER BY Object_Goods.Id
              , Object_Unit_From.ValueData
              , Object_Unit_To.ValueData
       ;

--raise notice 'Value 22: %', CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ 0.�.
 10.06.20                                                     *
*/

-- select * from gpReport_Movement_Send_RemainsSun_Supplement(inOperDate := ('16.11.2021')::TDateTime ,  inSession := '3');

-- 
SELECT * FROM lpInsert_Movement_Send_RemainsSun_Supplement (inOperDate:= CURRENT_DATE + INTERVAL '5 DAY', inDriverId:= 0, inUserId:= 3);