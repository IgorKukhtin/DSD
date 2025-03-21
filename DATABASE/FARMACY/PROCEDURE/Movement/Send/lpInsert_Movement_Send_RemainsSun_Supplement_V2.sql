-- Function: lpInsert_Movement_Send_RemainsSun_Supplement_V2

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_Supplement_V2 (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_Supplement_V2(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inDriverId            Integer   , -- ��������, ������������ ������ �� ������� �����
    IN inUserId              Integer     -- ������������
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
             , AmountSalesDey_From TFloat
             , Give_From TFloat

             , MCS_To TFloat
             , Price_To TFloat
             , isCloseMCS_To boolean
             , AmountRemains_To TFloat
             , AmountSalesDey_To TFloat
             , Need_To TFloat

             , AmountUse_To TFloat

             , InvNumberLayout TVarChar
             , LayoutName TVarChar
             
             , isHT_SUN_v2 boolean
             , isHT_SUNAll_v2 boolean
             
              )
AS
$BODY$
   DECLARE vbObjectId Integer;
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
   DECLARE vbDeySupplOut TFloat;
   DECLARE vbDeySupplIn TFloat;
   DECLARE vbisShoresSUN Boolean;
   DECLARE vbisCancelBansSUN Boolean;
   DECLARE vbisLegalEntitiesSUN Boolean;
   DECLARE vbJuridicalId Integer;
BEGIN
     --
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     -- ���� ������
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;

     SELECT COALESCE(ObjectBoolean_CashSettings_EliminateColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectFloat_CashSettings_DeySupplOutSUN2.ValueData, 40)::Integer 
          , COALESCE(ObjectFloat_CashSettings_DeySupplInSUN2.ValueData, 30)::Integer 
          , COALESCE(ObjectBoolean_CashSettings_ShoresSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_OnlyColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_CancelBansSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_LegalEntitiesSUN.ValueData, FALSE) 
     INTO vbisEliminateColdSUN
        , vbDeySupplOut
        , vbDeySupplIn
        , vbisShoresSUN
        , vbisOnlyColdSUN
        , vbisCancelBansSUN
        , vbisLegalEntitiesSUN
     FROM Object AS Object_CashSettings
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_EliminateColdSUN
                                  ON ObjectBoolean_CashSettings_EliminateColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_EliminateColdSUN.DescId = zc_ObjectBoolean_CashSettings_EliminateColdSUN2()
          LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DeySupplOutSUN2
                                ON ObjectFloat_CashSettings_DeySupplOutSUN2.ObjectId = Object_CashSettings.Id 
                               AND ObjectFloat_CashSettings_DeySupplOutSUN2.DescId = zc_ObjectFloat_CashSettings_DeySupplOutSUN2()
          LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DeySupplInSUN2
                                ON ObjectFloat_CashSettings_DeySupplInSUN2.ObjectId = Object_CashSettings.Id 
                               AND ObjectFloat_CashSettings_DeySupplInSUN2.DescId = zc_ObjectFloat_CashSettings_DeySupplInSUN2()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_ShoresSUN
                                  ON ObjectBoolean_CashSettings_ShoresSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_ShoresSUN.DescId = zc_ObjectBoolean_CashSettings_ShoresSUN()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_OnlyColdSUN
                                  ON ObjectBoolean_CashSettings_OnlyColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_OnlyColdSUN.DescId = zc_ObjectBoolean_CashSettings_OnlyColdSUN2()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_CancelBansSUN
                                  ON ObjectBoolean_CashSettings_CancelBansSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_CancelBansSUN.DescId = zc_ObjectBoolean_CashSettings_CancelBansSUN()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_LegalEntitiesSUN
                                  ON ObjectBoolean_CashSettings_LegalEntitiesSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_LegalEntitiesSUN.DescId = zc_ObjectBoolean_CashSettings_LegalEntitiesSUN()
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;

     -- ��� ������������� ��� ����� SUN Supplement_V2
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SUN_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SUN_Supplement_V2 (UnitId Integer, DeySupplOut Integer, DeySupplIn Integer, isSUN_Supplement_V2_in Boolean, isSUN_Supplement_V2_out Boolean, isSUN_Supplement_V2_Priority Boolean, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     END IF;

     -- ��������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoodsLayout_SUN_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoodsLayout_SUN_Supplement_V2 (GoodsId Integer, UnitId Integer, Layout TFloat, isNotMoveRemainder6 boolean, MovementLayoutId Integer) ON COMMIT DROP;
     END IF;

     -- ������������� ���� ��� �����
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_PromoUnit_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_PromoUnit_Supplement_V2 (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- ������ ���������� ��������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_DiscountExternal_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_DiscountExternal_Supplement_V2  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_TP_exception_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_TP_exception_Supplement_V2   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- ��� ������������ � ������� ���
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_Sun_exception_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_Sun_exception_Supplement_V2   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- ��� ��������� �� ��� � �� ������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSUN_Send_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpSUN_Send_Supplement_V2 (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- ��� ��������� �� ��� � �� ������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSUN_Send_SupplementAll_V2'))
     THEN
       CREATE TEMP TABLE _tmpSUN_Send_SupplementAll_V2 (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- ��������� ����� �����������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SunExclusion_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SunExclusion_Supplement_V2 (UnitId_from Integer, UnitId_to Integer) ON COMMIT DROP;
     END IF;

     -- "���� ������ � ���"... ���� � ����� �� ����� ��� ������������ ����� X, �� � ������������ ������� ������ ������������ ����� Y � ��� �� ����������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_PairSun_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_PairSun_Supplement_V2 (GoodsId Integer, GoodsId_PairSun Integer, PairSunAmount TFloat) ON COMMIT DROP;
     END IF;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_all_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpRemains_all_Supplement_V2   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Layout TFloat, PromoUnit TFloat, AmountRemains TFloat, AmountNotSend TFloat, 
                                                       AmountSalesDay TFloat, Need TFloat, Give TFloat, AmountUse TFloat, 
                                                       MinExpirationDate TDateTime, isCloseMCS boolean) ON COMMIT DROP;
     END IF;

     -- 3. ������������-1 ������� - �� ���� �������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_Supplement_V2'))
     THEN
       CREATE TEMP TABLE _tmpResult_Supplement_V2   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     END IF;

     -- ��� ������������� ��� ����� SUN
     DELETE FROM _tmpUnit_SUN_Supplement_V2;
     -- ��������
     DELETE FROM _tmpGoodsLayout_SUN_Supplement_V2;
     -- ������������� ���� ��� �����
     DELETE FROM _tmpGoods_PromoUnit_Supplement_V2;
     -- ������ ���������� ��������
     DELETE FROM _tmpGoods_DiscountExternal_Supplement_V2;
     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     DELETE FROM _tmpGoods_TP_exception_Supplement_V2;
     -- ��� ������������ � ������� ���
     DELETE FROM _tmpGoods_Sun_exception_Supplement_V2;
     -- ��� ��������� �� ��� � �� ������
     DELETE FROM _tmpSUN_Send_Supplement_V2;
     DELETE FROM _tmpSUN_Send_SupplementAll_V2;
     -- 1. ��� �������, ��� => �������� ���-�� ����������
     DELETE FROM _tmpRemains_all_Supplement_V2;
     -- 3. ������������-1 ������� - �� ���� �������
     DELETE FROM _tmpResult_Supplement_V2;
     DELETE FROM _tmpUnit_SunExclusion_Supplement_V2;

raise notice 'Value 1: %', CLOCK_TIMESTAMP();

     -- ��� ������������� ��� ����� SUN
     INSERT INTO _tmpUnit_SUN_Supplement_V2 (UnitId, DeySupplOut, DeySupplIn, isSUN_Supplement_V2_in, isSUN_Supplement_V2_out, isLock_CheckMSC, isLock_CloseGd, isLock_ClosePL, isLock_CheckMa, isColdOutSUN)
        SELECT OB.ObjectId
             , vbDeySupplOut            AS DeySupplOut  -- 120
             , vbDeySupplIn             AS DeySupplIn   -- 60
             , COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_in.ValueData, FALSE)  :: Boolean   AS isSUN_Supplement_V2_in
             , COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_out.ValueData, FALSE) :: Boolean   AS isSUN_Supplement_V2_out             
               -- TRUE = �� ���������� ��� "�� ��� ���"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 1 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLockSale
               -- TRUE = ��� ������� "������ ���"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 3 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseGd
               -- TRUE = ��� ������� "���� ���"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 5 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_ClosePL
               -- TRUE = ��� ������� "���������"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 7 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseMa
             , COALESCE (OB_ColdOutSUN.ValueData, FALSE)                       AS isColdOutSUN
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
             LEFT JOIN ObjectString  AS OS_LL  ON OS_LL.ObjectId  = OB.ObjectId AND OS_LL.DescId  = zc_ObjectString_Unit_SUN_v2_Lock()
             -- !!!������ ��� ����� ��������!!!
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Driver
                                  ON ObjectLink_Unit_Driver.ObjectId      = OB.ObjectId
                                 AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
             LEFT JOIN Object AS Object_Driver ON Object_Driver.Id = ObjectLink_Unit_Driver.ChildObjectId
        WHERE OB.ValueData = TRUE AND OB.DescId in (zc_ObjectBoolean_Unit_SUN_v2_Supplement_in(), zc_ObjectBoolean_Unit_SUN_v2_Supplement_out())
          -- ���� ������ ���� ������ - �������� ���
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' AND vbisShoresSUN = FALSE OR
               OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 4 OR
               OS_ListDaySUN.ValueData ILIKE '%' || CASE WHEN vbDOW_curr - 1 = 0 THEN 7 ELSE vbDOW_curr - 1 END::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 3
        --  OR inUserId = 3 -- ����� - �������
              )
          AND (COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_in.ValueData, FALSE) = TRUE 
            OR COALESCE (ObjectBoolean_SUN_v2_Supplement_V2_out.ValueData, FALSE) = TRUE)         
       ;

     ANALYSE _tmpUnit_SUN_Supplement_V2;  

raise notice 'Value 2: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM _tmpUnit_SUN_Supplement_V2);

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


     ANALYSE _tmpGoods_DiscountExternal_Supplement_V2;

raise notice 'Value 3: %', CLOCK_TIMESTAMP();

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

     ANALYSE _tmpGoods_TP_exception_Supplement_V2;

raise notice 'Value 4: %', CLOCK_TIMESTAMP();

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
     INSERT INTO _tmpGoods_Sun_exception_Supplement_V2 (UnitId, GoodsId, Amount)
        SELECT tmpSUN.UnitId, tmpSUN.GoodsId, tmpSUN.Amount
        FROM tmpSUN;
     
     ANALYSE _tmpGoods_Sun_exception_Supplement_V2;

raise notice 'Value 5: %', CLOCK_TIMESTAMP();

     -- ��� ��������� �� ��� � �� ������
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

     ANALYSE _tmpSUN_Send_Supplement_V2;

raise notice 'Value 6: %', CLOCK_TIMESTAMP();

     -- ��� ��������� �� ��� � �� ������
     WITH
     tmpUnit AS (SELECT OB.ObjectId AS UnitId
                      , COALESCE (OF_DSA.ValueData, 0):: Integer AS DaySendSUN
                 FROM ObjectBoolean AS OB
                      LEFT JOIN ObjectFloat   AS OF_DS            ON OF_DS.ObjectId            = OB.ObjectId AND OF_DS.DescId            = zc_ObjectFloat_Unit_HT_SUN_v2()
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

     ANALYSE _tmpSUN_Send_SupplementAll_V2;

raise notice 'Value 7: %', CLOCK_TIMESTAMP();
     
     -- ��������� ����� �����������
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
             -- � ���� ������ ������� ����
             LEFT JOIN _tmpUnit_SUN_Supplement_V2 AS _tmpUnit_SUN_From ON ObjectLink_From.ChildObjectId IS NULL

             LEFT JOIN ObjectLink AS ObjectLink_To
                                  ON ObjectLink_To.ObjectId = Object.Id
                                 AND ObjectLink_To.DescId   = zc_ObjectLink_SunExclusion_To()
             -- � ���� ������ ������� ����
             LEFT JOIN _tmpUnit_SUN_Supplement_V2 AS _tmpUnit_SUN_To ON ObjectLink_To.ChildObjectId IS NULL

        WHERE Object.DescId   = zc_Object_SunExclusion()
          AND Object.isErased = FALSE
           ;

     ANALYSE _tmpUnit_SunExclusion_Supplement_V2;

raise notice 'Value 8: %', CLOCK_TIMESTAMP();
                         
      -- ��������
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
                                , _tmpUnit_SUN_Supplement_V2.UnitId             AS UnitId
                                , tmpLayout.Amount                              AS Amount
                                , tmpLayout.isNotMoveRemainder6                 AS isNotMoveRemainder6
                                , tmpLayout.ID                                  AS MovementLayoutId
                           FROM _tmpUnit_SUN_Supplement_V2 
                                
                                LEFT JOIN Object AS Object_Unit
                                                 ON Object_Unit.Id        = _tmpUnit_SUN_Supplement_V2.UnitId
                                                AND Object_Unit.DescId    = zc_Object_Unit()
                                 
                                INNER JOIN tmpLayout ON 1 = 1 

                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = _tmpUnit_SUN_Supplement_V2.UnitId

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                           WHERE (tmpLayoutUnit.UnitId = _tmpUnit_SUN_Supplement_V2.UnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                             AND (Object_Unit.ValueData NOT ILIKE '���. ����� %' OR tmpLayout.isPharmacyItem = True)
                           )
                                                              
     INSERT INTO  _tmpGoodsLayout_SUN_Supplement_V2 (GoodsId, UnitId, Layout, isNotMoveRemainder6, MovementLayoutId) 
     SELECT tmpLayoutAll.GoodsId                 AS GoodsId
          , tmpLayoutAll.UnitId                  AS UnitId
          , MAX (tmpLayoutAll.Amount):: TFloat   AS Amount
          , SUM (CASE WHEN tmpLayoutAll.isNotMoveRemainder6 = TRUE THEN 1 ELSE 0 END) > 0   AS isNotMoveRemainder6
          , MAX (tmpLayoutAll.MovementLayoutId)  AS MovementLayoutId
      FROM tmpLayoutAll      
      GROUP BY tmpLayoutAll.GoodsId
             , tmpLayoutAll.UnitId;

     ANALYSE _tmpGoodsLayout_SUN_Supplement_V2;

raise notice 'Value 9: %', CLOCK_TIMESTAMP();
      
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

      INSERT INTO _tmpGoods_PromoUnit_Supplement_V2
      SELECT MI_Goods.UnitId                         AS UnitId
           , MI_Goods.GoodsId                        AS GoodsId
           , MI_Goods.Amount * tmpUserUnit.CountUser AS Amount

      FROM gpSelect_PromoUnit_UnitGoods (inOperDate := inOperDate, inSession := inUserId::TVarChar) AS MI_Goods

           INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = MI_Goods.UnitId
                                                                     
           INNER JOIN tmpUserUnit ON tmpUserUnit.UnitId = MI_Goods.UnitId           
      ;

     ANALYSE _tmpGoods_PromoUnit_Supplement_V2;

raise notice 'Value 10: %', CLOCK_TIMESTAMP();

         -- "���� ������ � ���"... ���� � ����� �� ����� ��� ������������ ����� X, �� � ������������ ������� ������ ������������ ����� Y � ��� �� ����������
         INSERT INTO _tmpGoods_SUN_PairSun_Supplement_V2 (GoodsId, GoodsId_PairSun, PairSunAmount)
            SELECT OL_GoodsPairSun.ObjectId      AS GoodsId
                 , OL_GoodsPairSun.ChildObjectId            AS GoodsId_PairSun
                 , COALESCE (OF_PairSunAmount.ValueData, 1) AS PairSunAmount
            FROM ObjectLink AS OL_GoodsPairSun

                 LEFT JOIN ObjectFloat AS OF_PairSunAmount
                                       ON OF_PairSunAmount.ObjectId  = OL_GoodsPairSun.ObjectId 
                                      AND OF_PairSunAmount.DescId    = zc_ObjectFloat_Goods_PairSunAmount()

            WHERE OL_GoodsPairSun.ChildObjectId > 0 AND OL_GoodsPairSun.DescId = zc_ObjectLink_Goods_GoodsPairSun()
           ;
      
     ANALYSE _tmpGoods_SUN_PairSun_Supplement_V2;
     
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
     
     

raise notice 'Value 11: %', CLOCK_TIMESTAMP();

     -- 1. ��� �������
     --
     WITH tmpRemainsPD AS (SELECT Container.ParentId
                                , Container.Amount
                                , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())    AS ExpirationDate
                           FROM Container
                                -- !!!������ ��� ����� �����!!!
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
          -- ��������� !!���!!
        , tmpGoods_NOT AS (SELECT OB_Goods_NOT.ObjectId
                           FROM ObjectBoolean AS OB_Goods_NOT
                           WHERE OB_Goods_NOT.DescId   = zc_ObjectBoolean_Goods_NOT_Sun_v2()
                             AND OB_Goods_NOT.ValueData = TRUE
                          )
        , tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (tmpRemainsPD.Amount, Container.Amount, 0))                              AS Amount
                              , SUM (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) <= CURRENT_DATE + INTERVAL '100 DAY'
                                          THEN COALESCE (tmpRemainsPD.Amount, Container.Amount, 0)
                                          ELSE 0 END)                                                                         AS AmountNotSend
                              , SUM (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) <= CURRENT_DATE + INTERVAL '6 MONTH'
                                          THEN COALESCE (tmpRemainsPD.Amount, Container.Amount, 0)
                                          ELSE 0 END)                                                                         AS Amount6Month
                              , MIN (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) >= CURRENT_DATE + INTERVAL '100 DAY'
                                          THEN COALESCE (tmpRemainsPD.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd())
                                          ELSE zc_DateEnd() END)                                                              AS MinExpirationDate
                         FROM Container
                              -- !!!������ ��� ����� �����!!!
                              INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = Container.WhereObjectId
                              LEFT JOIN _tmpGoods_TP_exception_Supplement_V2 ON _tmpGoods_TP_exception_Supplement_V2.GoodsId = Container.ObjectId
                                                              AND _tmpGoods_TP_exception_Supplement_V2.UnitId = Container.WhereObjectId
                                                              
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

                              -- � �����, ��������� !!���!!
                              LEFT JOIN tmpGoods_NOT ON tmpGoods_NOT.ObjectId = Container.ObjectId

                              -- ������ ���������� �����
                              LEFT JOIN _tmpGoods_DiscountExternal_Supplement_v2 AS _tmpGoods_DiscountExternal
                                                                                 ON _tmpGoods_DiscountExternal.UnitId  = Container.WhereObjectId
                                                                                AND _tmpGoods_DiscountExternal.GoodsId = Container.ObjectId

                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                           AND COALESCE (_tmpGoods_TP_exception_Supplement_V2.GoodsId, 0) = 0
                           AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
                           -- ��������� !!���!!
                           AND tmpGoods_NOT.ObjectId IS NULL
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
          -- �������
        , tmpSalesDay AS (SELECT _tmpUnit_SUN_Supplement_V2.UnitId
                               , MIContainer.ObjectId_analyzer                AS GoodsId 
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0) ) AS AmountSalesDay
                          FROM MovementItemContainer AS MIContainer
                               INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = MIContainer.WhereObjectId_analyzer
                               LEFT JOIN MovementBoolean AS MB_NotMCS
                                                         ON MB_NotMCS.MovementId = MIContainer.MovementId
                                                        AND MB_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                                                        AND MB_NotMCS.ValueData  = TRUE
                               LEFT JOIN MovementBoolean AS MB_CorrectMarketing
                                                         ON MB_CorrectMarketing.MovementId = MIContainer.MovementId
                                                        AND MB_CorrectMarketing.DescId     = zc_MovementBoolean_CorrectMarketing()
                                                        AND MB_CorrectMarketing.ValueData  = TRUE
                          WHERE MIContainer.OperDate >= CURRENT_DATE - (CASE WHEN _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_out = TRUE
                                                                                       THEN _tmpUnit_SUN_Supplement_V2.DeySupplOut 
                                                                                       ELSE _tmpUnit_SUN_Supplement_V2.DeySupplIn END::TVarChar ||' DAY') :: INTERVAL
                            AND MIContainer.DescId         = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            -- !!!�� ��������� ���� ����� "�� ��� ���"
                            AND (MB_NotMCS.MovementId IS NULL OR _tmpUnit_SUN_Supplement_V2.isLock_CheckMSC = FALSE)
                            -- !!!�� ��������� ���� ����� "������������� ����� ���������� � ��"
                            AND (MB_CorrectMarketing.MovementId IS NULL OR _tmpUnit_SUN_Supplement_V2.isLock_CheckMa = FALSE)        
                          GROUP BY _tmpUnit_SUN_Supplement_V2.UnitId
                                 , MIContainer.ObjectId_analyzer
                      )
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
                            INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = OL_Price_Unit.ChildObjectId
                            INNER JOIN ObjectLink AS OL_Price_Goods
                                                  ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                 AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
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
                                   INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

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
        , tmpNotMCS AS (SELECT MovementItemContainer.WhereObjectId_Analyzer AS UnitId
                             , MovementItemContainer.ObjectId_Analyzer      AS GoodsId
                             , SUM(- MovementItemContainer.Amount)          AS Amount
                        FROM MovementBoolean

                             INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = MovementBoolean.MovementId              
                             
                             INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = MovementItemContainer.WhereObjectId_Analyzer
                                               
                        WHERE MovementBoolean.DescId = zc_MovementBoolean_NotMCS()
                          AND MovementBoolean.ValueData = TRUE
                          AND MovementItemContainer.OperDate >= CURRENT_DATE - (CASE WHEN _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_out = TRUE
                                                                                     THEN _tmpUnit_SUN_Supplement_V2.DeySupplOut 
                                                                                     ELSE _tmpUnit_SUN_Supplement_V2.DeySupplIn END::TVarChar ||' DAY') :: INTERVAL                     
                        GROUP BY MovementItemContainer.WhereObjectId_Analyzer
                               , MovementItemContainer.ObjectId_Analyzer
                             )
     -- 1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains_all_Supplement_V2 (UnitId, GoodsId, Price, MCS, Layout, PromoUnit, AmountRemains, AmountNotSend, AmountSalesDay, 
                                                 MinExpirationDate, isCloseMCS, AmountUse)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             
             , _tmpGoodsLayout_SUN_Supplement_V2.Layout
             , _tmpGoods_PromoUnit_Supplement_V2.Amount
             
             /*, CASE WHEN _tmpGoodsLayout_SUN_Supplement_V2.isNotMoveRemainder6 = TRUE
                      OR (COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement_V2.Amount, 0) - 
                          COALESCE(tmpRemains.Amount6Month, 0))  > _tmpGoodsLayout_SUN_Supplement_V2.Layout
                      OR COALESCE(tmpRemains.Amount6Month, 0) = 0
                    THEN _tmpGoodsLayout_SUN_Supplement_V2.Layout
                    WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement_V2.Amount, 0) - 
                                                            COALESCE(tmpRemains.Amount6Month, 0)) >= 0
                    THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement_V2.Amount, 0) - 
                                                            COALESCE(tmpRemains.Amount6Month, 0)) 
                    ELSE 0 END  AS Layout*/
                    

               -- �������
             , CASE WHEN COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement_V2.Amount, 0) > 0
                    THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement_V2.Amount, 0) ELSE 0 END AS AmountRemains
             , COALESCE (tmpRemains.AmountNotSend, 0)                                                                            AS AmountNotSend
               -- ����������
             , COALESCE (tmpSalesDay.AmountSalesDay, 0) - COALESCE (tmpNotMCS.Amount, 0)      AS AmountSalesDay
             , tmpRemains.MinExpirationDate
             , COALESCE (tmpObject_Price.isCloseMCS, FALSE)  AS isCloseMCS
             , 0
        FROM tmpRemains  AS tmpRemains

             FULL JOIN tmpSalesDay AS tmpSalesDay
                                   ON tmpSalesDay.UnitId  = tmpRemains.UnitId
                                  AND tmpSalesDay.GoodsId = tmpRemains.GoodsId

             INNER JOIN tmpPrice AS tmpObject_Price
                                 ON tmpObject_Price.UnitId  = COALESCE(tmpRemains.UnitId, tmpSalesDay.UnitId)
                                AND tmpObject_Price.GoodsId = COALESCE(tmpRemains.GoodsId, tmpSalesDay.GoodsId)
                                
             LEFT JOIN tmpNotMCS ON tmpNotMCS.UnitId  = COALESCE(tmpRemains.UnitId, tmpSalesDay.UnitId)
                                AND tmpNotMCS.GoodsId = COALESCE(tmpRemains.GoodsId, tmpSalesDay.GoodsId)
                                 
             LEFT JOIN _tmpGoods_Sun_exception_Supplement_V2 ON _tmpGoods_Sun_exception_Supplement_V2.UnitId  = COALESCE(tmpRemains.UnitId, tmpSalesDay.UnitId)
                                              AND _tmpGoods_Sun_exception_Supplement_V2.GoodsId = COALESCE(tmpRemains.GoodsId, tmpSalesDay.GoodsId)
                                              

             LEFT JOIN _tmpGoodsLayout_SUN_Supplement_V2 ON _tmpGoodsLayout_SUN_Supplement_V2.GoodsID = COALESCE(tmpRemains.GoodsId, tmpSalesDay.GoodsId)
                                                        AND _tmpGoodsLayout_SUN_Supplement_V2.UnitId = COALESCE(tmpRemains.UnitId, tmpSalesDay.UnitId)
                                                        
             LEFT JOIN _tmpGoods_PromoUnit_Supplement_V2 ON _tmpGoods_PromoUnit_Supplement_V2.GoodsID = COALESCE(tmpRemains.GoodsId, tmpSalesDay.GoodsId)
                                                        AND _tmpGoods_PromoUnit_Supplement_V2.UnitId = COALESCE(tmpRemains.UnitId, tmpSalesDay.UnitId)             
       ;
       
     ANALYSE _tmpRemains_all_Supplement_V2;

raise notice 'Value 12: %', CLOCK_TIMESTAMP();
              
     -- ��� ������
     UPDATE _tmpRemains_all_Supplement_V2 SET Give = floor(_tmpRemains_all_Supplement_V2.AmountRemains - COALESCE(_tmpRemains_all_Supplement_V2.AmountNotSend, 0) -
                                                                           CASE WHEN (COALESCE(_tmpRemains_all_Supplement_V2.MCS, 0) + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0)) < 1 
                                                                                  AND 1 > COALESCE(_tmpRemains_all_Supplement_V2.AmountSalesDay, 0) 
                                                                                THEN CASE WHEN (COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0)) > 1 
                                                                                          THEN COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0) ELSE 1 END 
                                                                                WHEN (COALESCE(_tmpRemains_all_Supplement_V2.MCS, 0) + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0))  > COALESCE(_tmpRemains_all_Supplement_V2.AmountSalesDay, 0) 
                                                                                THEN (COALESCE(_tmpRemains_all_Supplement_V2.MCS, 0) + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0))  
                                                                                ELSE COALESCE(_tmpRemains_all_Supplement_V2.AmountSalesDay, 0) END)
     WHERE _tmpRemains_all_Supplement_V2.UnitId IN (SELECT _tmpUnit_SUN_Supplement_V2.UnitId 
                                                    FROM _tmpUnit_SUN_Supplement_V2 
                                                    WHERE _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_out = TRUE)
       AND floor(_tmpRemains_all_Supplement_V2.AmountRemains - COALESCE(_tmpRemains_all_Supplement_V2.AmountNotSend, 0) -
                                                               CASE WHEN (COALESCE(_tmpRemains_all_Supplement_V2.MCS, 0) + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0))  < 1 AND 1 > COALESCE(_tmpRemains_all_Supplement_V2.AmountSalesDay, 0) 
                                                                    THEN 1 
                                                                    WHEN (COALESCE(_tmpRemains_all_Supplement_V2.MCS, 0) + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0))  > COALESCE(_tmpRemains_all_Supplement_V2.AmountSalesDay, 0) 
                                                                    THEN (COALESCE(_tmpRemains_all_Supplement_V2.MCS, 0) + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0))  
                                                                    ELSE COALESCE(_tmpRemains_all_Supplement_V2.AmountSalesDay, 0) END) > 0;
     
     -- ��� ����� ��������
     UPDATE _tmpRemains_all_Supplement_V2 SET Need = ceil(_tmpRemains_all_Supplement_V2.AmountSalesDay - _tmpRemains_all_Supplement_V2.AmountRemains)
     WHERE _tmpRemains_all_Supplement_V2.UnitId IN (SELECT _tmpUnit_SUN_Supplement_V2.UnitId 
                                                    FROM _tmpUnit_SUN_Supplement_V2 
                                                    WHERE _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_out = FALSE
                                                      AND _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_in = TRUE)
       AND ceil(_tmpRemains_all_Supplement_V2.AmountSalesDay - _tmpRemains_all_Supplement_V2.AmountRemains) > 0;
              

raise notice 'Value 13: %', CLOCK_TIMESTAMP();
     
     -- 3. ������������ �� ���
     --
     -- ������1 - ��� ��� ����� ������������
     OPEN curPartion_next FOR
        -- Income - �� X ���� - ���� ���������, 100���� ��� ������ ������� ��� �� �����
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
                                INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId  = MovementLinkObject_To.ObjectId

                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                                       AND MovementItem.Amount     > 0
                                -- !!!������ ��� �����!!!
                                INNER JOIN _tmpRemains_all_Supplement_V2 ON _tmpRemains_all_Supplement_V2.GoodsId = MovementItem.ObjectId
                                                                        AND _tmpRemains_all_Supplement_V2.UnitId  = MovementLinkObject_To.ObjectId
                                                          
                                INNER JOIN ObjectFloat AS OF_DI            
                                                       ON OF_DI.ObjectId  = MovementLinkObject_To.ObjectId
                                                      AND OF_DI.DescId    = zc_ObjectFloat_Unit_Sun_v2Income()
                                                      AND OF_DI.ValueData >= 0

                           WHERE MovementDate_Branch.DescId     = zc_MovementDate_Branch()
                             AND MovementDate_Branch.ValueData BETWEEN inOperDate - (
                                                (SELECT MAX(OF_DI.ValueData)
                                                 FROM ObjectFloat AS OF_DI            
                                                 WHERE OF_DI.DescId    = zc_ObjectFloat_Unit_Sun_v2Income()
                                                   AND OF_DI.ValueData >= 0) :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'

                           GROUP BY MovementLinkObject_To.ObjectId
                                  , MovementItem.ObjectId
                           HAVING SUM (CASE WHEN Movement.OperDate BETWEEN inOperDate - (OF_DI.ValueData :: TVarChar || 'DAY') :: INTERVAL AND inOperDate - INTERVAL '1 DAY'
                                                 THEN MovementItem.Amount
                                            ELSE 0
                                       END) > 0
                           )

        SELECT _tmpRemains_all_Supplement_V2.UnitId
             , _tmpRemains_all_Supplement_V2.GoodsId
             , _tmpRemains_all_Supplement_V2.Give
             , COALESCE (OF_KoeffSUN.ValueData, 0)
             , ObjectLink_Unit_Juridical.ChildObjectId         
       FROM _tmpRemains_all_Supplement_V2

            INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId
                                                 AND _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_out = TRUE

            LEFT JOIN ObjectFloat AS OF_KoeffSUN ON OF_KoeffSUN.ObjectId = _tmpRemains_all_Supplement_V2.GoodsId
                                                AND OF_KoeffSUN.DescId    = zc_ObjectFloat_Goods_KoeffSUN_v2()
                                                
            LEFT JOIN _tmpSUN_Send_Supplement_V2 ON _tmpSUN_Send_Supplement_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId
                                                AND _tmpSUN_Send_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId  

            LEFT JOIN _tmpSUN_Send_SupplementAll_V2 ON _tmpSUN_Send_SupplementAll_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId
                                                   AND _tmpSUN_Send_SupplementAll_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId  
                                                                                                                            
            -- ���� ����� ����� ������
            LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun_Supplement_V2.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun_Supplement_V2
                      ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_all_Supplement_V2.GoodsId

            LEFT JOIN tmpIncome ON tmpIncome.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId
                               AND tmpIncome.UnitId = _tmpRemains_all_Supplement_V2.UnitId  

             -- � �����, ��������� !!�����!!
             LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_all_Supplement_V2.GoodsId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_all_Supplement_V2.UnitId
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                    
       WHERE _tmpRemains_all_Supplement_V2.Give > 0
         AND COALESCE(_tmpSUN_Send_Supplement_V2.GoodsID, 0) = 0
         AND COALESCE(_tmpSUN_Send_SupplementAll_V2.GoodsID, 0) = 0
         AND COALESCE (_tmpGoods_SUN_PairSun_find.GoodsId_PairSun, 0) = 0
         AND COALESCE(tmpIncome.GoodsID, 0) = 0
             -- ��������� !!�����!!
         AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
             tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE OR
             _tmpUnit_SUN_Supplement_V2.isColdOutSUN = TRUE)
       ORDER BY _tmpRemains_all_Supplement_V2.Give DESC
              , _tmpRemains_all_Supplement_V2.UnitId
              , _tmpRemains_all_Supplement_V2.GoodsId
       ;
       
     -- ������ ����� �� �������1 
     LOOP
         -- ������ �� �������1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbSurplus, vbKoeffSUN, vbJuridicalId;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         -- ������2. - ����������� ��� vbGoodsId
         OPEN curResult_next FOR
             SELECT _tmpRemains_all_Supplement_v2.UnitId
                  , CASE WHEN COALESCE (vbKoeffSUN, 0) = 0 
                         THEN FLOOR((COALESCE(_tmpRemains_all_Supplement_v2.MCS, 0)  + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0))  - _tmpRemains_all_Supplement_v2.AmountRemains - _tmpRemains_all_Supplement_v2.AmountUse)
                         ELSE FLOOR (FLOOR((COALESCE(_tmpRemains_all_Supplement_v2.MCS, 0)  + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0)) - _tmpRemains_all_Supplement_v2.AmountRemains - _tmpRemains_all_Supplement_v2.AmountUse) / vbKoeffSUN) * vbKoeffSUN END
             FROM _tmpRemains_all_Supplement_v2

                  INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId
                                                       AND _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_in = TRUE

                  -- ��������� !!����������!!
                  LEFT JOIN _tmpUnit_SunExclusion_Supplement_v2 ON _tmpUnit_SunExclusion_Supplement_v2.UnitId_from = vbUnitId_from
                                                               AND _tmpUnit_SunExclusion_Supplement_v2.UnitId_to   = _tmpRemains_all_Supplement_v2.UnitId
                  
                  -- ��������� �������� ����� ������� ���������
                  LEFT JOIN _tmpGoods_Sun_exception_Supplement_V2 AS _tmpGoods_Sun_exception_Supplement_V2
                                                                  ON _tmpGoods_Sun_exception_Supplement_V2.UnitId  = _tmpRemains_all_Supplement_v2.UnitId
                                                                 AND _tmpGoods_Sun_exception_Supplement_V2.GoodsId = _tmpRemains_all_Supplement_v2.GoodsId

                  LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                       ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_all_Supplement_v2.UnitId
                                      AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

             WHERE CASE WHEN COALESCE (vbKoeffSUN, 0) = 0 
                        THEN FLOOR((COALESCE(_tmpRemains_all_Supplement_v2.MCS, 0)  + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0)) - _tmpRemains_all_Supplement_v2.AmountRemains - _tmpRemains_all_Supplement_v2.AmountUse)
                        ELSE FLOOR (FLOOR((COALESCE(_tmpRemains_all_Supplement_v2.MCS, 0)  + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0)) - _tmpRemains_all_Supplement_v2.AmountRemains - _tmpRemains_all_Supplement_v2.AmountUse) / vbKoeffSUN) * vbKoeffSUN END > 0
               AND _tmpRemains_all_Supplement_v2.UnitId <> vbUnitId_from
               AND _tmpRemains_all_Supplement_v2.GoodsId = vbGoodsId
               AND _tmpUnit_SunExclusion_Supplement_v2.UnitId_to IS NULL
               AND  COALESCE(_tmpGoods_Sun_exception_Supplement_V2.Amount, 0) = 0
               AND (vbisLegalEntitiesSUN = FALSE OR ObjectLink_Unit_Juridical.ChildObjectId = vbJuridicalId)
             ORDER BY FLOOR((COALESCE(_tmpRemains_all_Supplement_v2.MCS, 0)  + COALESCE(_tmpRemains_all_Supplement_V2.Layout, 0) + COALESCE(_tmpRemains_all_Supplement_V2.PromoUnit, 0)) - _tmpRemains_all_Supplement_v2.AmountRemains - _tmpRemains_all_Supplement_v2.AmountUse) DESC
                    , _tmpRemains_all_Supplement_v2.UnitId
                    , _tmpRemains_all_Supplement_v2.GoodsId;
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� ���������
         LOOP
             -- ������ �� ���������
             FETCH curResult_next INTO vbUnitId_to, vbNeed;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR (vbSurplus) <= 0 THEN EXIT; END IF;

             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR FLOOR (vbSurplus) <= 0 THEN EXIT; END IF;
             
             INSERT INTO _tmpResult_Supplement_V2 (UnitId_from, UnitId_to, GoodsId, Amount)
               VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END);

             UPDATE _tmpRemains_all_Supplement_v2 SET AmountUse = AmountUse + CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END
             WHERE _tmpRemains_all_Supplement_v2.UnitId = vbUnitId_to
               AND _tmpRemains_all_Supplement_v2.GoodsId = vbGoodsId;

             UPDATE _tmpRemains_all_Supplement_v2 SET AmountUse = AmountUse + CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END
             WHERE _tmpRemains_all_Supplement_v2.UnitId = vbUnitId_from
               AND _tmpRemains_all_Supplement_v2.GoodsId = vbGoodsId;

             vbSurplus := vbSurplus - CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END;

         END LOOP; -- ����� ����� �� �������2
         CLOSE curResult_next; -- ������� ������2.

     END LOOP; -- ����� ����� �� �������1
     CLOSE curPartion_next; -- ������� ������1

raise notice 'Value 14: %', CLOCK_TIMESTAMP();

     -- 3. ������������ �� �����������
     --
     -- ������1 - ��� ��� ����� ������������
     OPEN curPartion_next FOR
        SELECT _tmpRemains_all_Supplement_V2.UnitId
             , _tmpRemains_all_Supplement_V2.GoodsId
             , _tmpRemains_all_Supplement_V2.Give - _tmpRemains_all_Supplement_V2.AmountUse
             , COALESCE (OF_KoeffSUN.ValueData, 0)
             , ObjectLink_Unit_Juridical.ChildObjectId         
       FROM _tmpRemains_all_Supplement_V2

            INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId
                                                 AND _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_out = TRUE

            LEFT JOIN ObjectFloat AS OF_KoeffSUN ON OF_KoeffSUN.ObjectId = _tmpRemains_all_Supplement_V2.GoodsId
                                                AND OF_KoeffSUN.DescId    = zc_ObjectFloat_Goods_KoeffSUN_v2()
                                                                            
            LEFT JOIN _tmpSUN_Send_Supplement_V2 ON _tmpSUN_Send_Supplement_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId
                                                AND _tmpSUN_Send_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId  

            LEFT JOIN _tmpSUN_Send_SupplementAll_V2 ON _tmpSUN_Send_SupplementAll_V2.GoodsID = _tmpRemains_all_Supplement_V2.GoodsId
                                                   AND _tmpSUN_Send_SupplementAll_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId  

            -- ���� ����� ����� ������
            LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun_Supplement_V2.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun_Supplement_V2
                      ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_all_Supplement_V2.GoodsId                                                                                                                            

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_all_Supplement_V2.UnitId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

       WHERE _tmpRemains_all_Supplement_V2.Give - _tmpRemains_all_Supplement_V2.AmountUse > 0
         AND COALESCE(_tmpSUN_Send_Supplement_V2.GoodsID, 0) = 0
         AND COALESCE(_tmpSUN_Send_SupplementAll_V2.GoodsID, 0) = 0
         AND COALESCE (_tmpGoods_SUN_PairSun_find.GoodsId_PairSun, 0) = 0
       ORDER BY _tmpRemains_all_Supplement_V2.Give DESC
              , _tmpRemains_all_Supplement_V2.UnitId
              , _tmpRemains_all_Supplement_V2.GoodsId
       ;
       
     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbSurplus, vbKoeffSUN, vbJuridicalId;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         -- ������2. - ����������� ��� vbGoodsId
         OPEN curResult_next FOR
             SELECT _tmpRemains_all_Supplement_v2.UnitId
                  , CASE WHEN COALESCE (vbKoeffSUN, 0) = 0 
                         THEN FLOOR(_tmpRemains_all_Supplement_v2.Need - _tmpRemains_all_Supplement_v2.AmountUse)
                         ELSE FLOOR (FLOOR(_tmpRemains_all_Supplement_v2.Need - _tmpRemains_all_Supplement_v2.AmountUse) / vbKoeffSUN) * vbKoeffSUN END
             FROM _tmpRemains_all_Supplement_v2

                  INNER JOIN _tmpUnit_SUN_Supplement_V2 ON _tmpUnit_SUN_Supplement_V2.UnitId = _tmpRemains_all_Supplement_V2.UnitId
                                                       AND _tmpUnit_SUN_Supplement_V2.isSUN_Supplement_V2_in = TRUE

                  -- ��������� !!����������!!
                  LEFT JOIN _tmpUnit_SunExclusion_Supplement_v2 ON _tmpUnit_SunExclusion_Supplement_v2.UnitId_from = vbUnitId_from
                                                               AND _tmpUnit_SunExclusion_Supplement_v2.UnitId_to   = _tmpRemains_all_Supplement_v2.UnitId

                  -- � �����, ��������� !!�����!!
                  LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_Partion.GoodsId

                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                      ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_all_Supplement_v2.UnitId
                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

             WHERE CASE WHEN COALESCE (vbKoeffSUN, 0) = 0 
                        THEN FLOOR(_tmpRemains_all_Supplement_v2.Need - _tmpRemains_all_Supplement_v2.AmountUse)
                        ELSE FLOOR (FLOOR(_tmpRemains_all_Supplement_v2.Need - _tmpRemains_all_Supplement_v2.AmountUse) / vbKoeffSUN) * vbKoeffSUN END > 0
               AND _tmpRemains_all_Supplement_v2.UnitId <> vbUnitId_from
               AND _tmpRemains_all_Supplement_v2.GoodsId = vbGoodsId
               AND _tmpUnit_SunExclusion_Supplement_v2.UnitId_to IS NULL
                   -- ��������� !!�����!!
               AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
                   tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE OR
                   _tmpUnit_SUN_Supplement_V2.isColdOutSUN = TRUE)
               AND (vbisLegalEntitiesSUN = FALSE OR ObjectLink_Unit_Juridical.ChildObjectId = vbJuridicalId)
             ORDER BY _tmpRemains_all_Supplement_v2.AmountUse
                    , FLOOR(_tmpRemains_all_Supplement_v2.Need - _tmpRemains_all_Supplement_v2.AmountUse) DESC
                    , _tmpRemains_all_Supplement_v2.UnitId
                    , _tmpRemains_all_Supplement_v2.GoodsId;
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� ���������
         LOOP
             -- ������ �� ���������
             FETCH curResult_next INTO vbUnitId_to, vbNeed;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR (vbSurplus) <= 0 THEN EXIT; END IF;

             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR FLOOR (vbSurplus) <= 0 THEN EXIT; END IF;
             
             IF EXISTS(SELECT * 
                       FROM _tmpResult_Supplement_V2
                       WHERE _tmpResult_Supplement_V2.UnitId_from = vbUnitId_from
                         AND _tmpResult_Supplement_V2.UnitId_to = vbUnitId_to
                         AND _tmpResult_Supplement_V2.GoodsId = vbGoodsId)
             THEN
               UPDATE _tmpResult_Supplement_V2 SET Amount = _tmpResult_Supplement_V2.Amount + CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END
               WHERE _tmpResult_Supplement_V2.UnitId_from = vbUnitId_from
                 AND _tmpResult_Supplement_V2.UnitId_to = vbUnitId_to
                 AND _tmpResult_Supplement_V2.GoodsId = vbGoodsId;
             ELSE
               INSERT INTO _tmpResult_Supplement_V2 (UnitId_from, UnitId_to, GoodsId, Amount)
                 VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END);
             END IF;

             UPDATE _tmpRemains_all_Supplement_v2 SET AmountUse = AmountUse + CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END
             WHERE _tmpRemains_all_Supplement_v2.UnitId = vbUnitId_to
               AND _tmpRemains_all_Supplement_v2.GoodsId = vbGoodsId;

             vbSurplus := vbSurplus - CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END;

         END LOOP; -- ����� ����� �� �������2
         CLOSE curResult_next; -- ������� ������2.

     END LOOP; -- ����� ����� �� �������1
     CLOSE curPartion_next; -- ������� ������1

raise notice 'Value 15: %', CLOCK_TIMESTAMP();

     -- !!! �������� ������, ����� ������������� ...
     WITH -- ����� � �������� ����� ����
          tmpResult_Partion AS (SELECT _tmpResult_Supplement_v2.*, _tmpGoods_SUN_PairSun_Supplement_v2.GoodsId_PairSun, _tmpGoods_SUN_PairSun_Supplement_v2.PairSunAmount
                                FROM _tmpResult_Supplement_v2

                                     INNER JOIN _tmpGoods_SUN_PairSun_Supplement_v2 ON _tmpGoods_SUN_PairSun_Supplement_v2.GoodsId = _tmpResult_Supplement_v2.GoodsId
                                ),
          -- ������� ������
          tmpRemains_Pair  AS (SELECT _tmpRemains_all_Supplement_v2.GoodsId
                                    , _tmpRemains_all_Supplement_v2.UnitId
                                    , _tmpRemains_all_Supplement_v2.Price
                                    , _tmpRemains_all_Supplement_v2.AmountRemains - COALESCE(_tmpRemains_all_Supplement_v2.AmountNotSend, 0) AS AmountRemains
                               FROM _tmpRemains_all_Supplement_v2
                               WHERE _tmpRemains_all_Supplement_v2.GoodsId IN (SELECT DISTINCT  _tmpGoods_SUN_PairSun_Supplement_v2.GoodsId_PairSun FROM  _tmpGoods_SUN_PairSun_Supplement_v2)
                                 AND _tmpRemains_all_Supplement_v2.AmountRemains - COALESCE(_tmpRemains_all_Supplement_v2.AmountNotSend, 0) > 0
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

     INSERT INTO _tmpResult_Supplement_v2 (UnitId_from, UnitId_to, GoodsId, Amount)
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
     
raise notice 'Value 16: %', CLOCK_TIMESTAMP();

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

            , _tmpResult_Supplement_V2.Amount            AS Amount

            , tmpRemains_all_From.MinExpirationDate

            , tmpRemains_all_From.MCS                    AS MCS_From
            , _tmpGoodsLayout_SUN_Supplement_V2.Layout   AS Layout_From
            , _tmpGoods_PromoUnit_Supplement_V2.Amount   AS PromoUnit_From
            
            , tmpRemains_all_From.Price                  AS Price_From
            , tmpRemains_all_From.isCloseMCS             AS isCloseMCS_From
            , tmpRemains_all_From.AmountRemains          AS AmountRemains_From
            , tmpRemains_all_From.AmountSalesDay         AS AmountSalesDay_From
            , tmpRemains_all_From.Give                   AS Give_From

            , tmpRemains_all_To.MCS                      AS MCS_To
            , tmpRemains_all_To.Price                    AS Price_To
            , tmpRemains_all_To.isCloseMCS               AS isCloseMCS_To
            , tmpRemains_all_To.AmountRemains            AS AmountRemains_To
            , tmpRemains_all_To.AmountSalesDay           AS AmountSalesDay_To

            , tmpRemains_all_To.Need                     AS Need_To

            , tmpRemains_all_To.AmountUse                AS AmountUse_To

            , Movement_Layout.InvNumber                  AS InvNumberLayout
            , Object_Layout.ValueData                    AS LayoutName
            
            , COALESCE(_tmpSUN_Send_Supplement_V2.GoodsID, 0) <> 0     AS isHT_SUN_v2
            , COALESCE(_tmpSUN_Send_SupplementAll_V2.GoodsID, 0) <> 0  AS isHT_SUNAll_v2


       FROM _tmpResult_Supplement_V2

            LEFT JOIN _tmpRemains_all_Supplement_V2 AS tmpRemains_all_From
                                                 ON tmpRemains_all_From.UnitId  = _tmpResult_Supplement_V2.UnitId_from
                                                AND tmpRemains_all_From.GoodsId = _tmpResult_Supplement_V2.GoodsId
            LEFT JOIN Object AS Object_Unit_From  ON Object_Unit_From.Id  = _tmpResult_Supplement_V2.UnitId_from


            LEFT JOIN _tmpRemains_all_Supplement_V2 AS tmpRemains_all_To
                                                 ON tmpRemains_all_To.UnitId  = _tmpResult_Supplement_V2.UnitId_to
                                                AND tmpRemains_all_To.GoodsId = _tmpResult_Supplement_V2.GoodsId
            LEFT JOIN Object AS Object_Unit_To  ON Object_Unit_To.Id  = tmpRemains_all_To.UnitId

            LEFT JOIN _tmpGoodsLayout_SUN_Supplement_V2 ON _tmpGoodsLayout_SUN_Supplement_V2.GoodsID = _tmpResult_Supplement_V2.GoodsId
                                                    AND _tmpGoodsLayout_SUN_Supplement_V2.UnitId = _tmpResult_Supplement_V2.UnitId_from

            LEFT JOIN _tmpGoods_PromoUnit_Supplement_V2 ON _tmpGoods_PromoUnit_Supplement_V2.GoodsID = _tmpResult_Supplement_V2.GoodsId
                                                    AND _tmpGoods_PromoUnit_Supplement_V2.UnitId = _tmpResult_Supplement_V2.UnitId_from

            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = _tmpResult_Supplement_V2.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
            
            LEFT JOIN Movement AS Movement_Layout ON Movement_Layout.Id = _tmpGoodsLayout_SUN_Supplement_V2.MovementLayoutId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Layout
                                         ON MovementLinkObject_Layout.MovementId = Movement_Layout.Id
                                        AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
            LEFT JOIN Object AS Object_Layout ON Object_Layout.Id = MovementLinkObject_Layout.ObjectId

            LEFT JOIN _tmpSUN_Send_Supplement_V2 ON _tmpSUN_Send_Supplement_V2.GoodsID = _tmpResult_Supplement_V2.GoodsId
                                                AND _tmpSUN_Send_Supplement_V2.UnitId = _tmpResult_Supplement_V2.UnitId_from  

            LEFT JOIN _tmpSUN_Send_SupplementAll_V2 ON _tmpSUN_Send_SupplementAll_V2.GoodsID = _tmpResult_Supplement_V2.GoodsId
                                                   AND _tmpSUN_Send_SupplementAll_V2.UnitId = _tmpResult_Supplement_V2.UnitId_from  
            
       ORDER BY Object_Goods.Id
              , Object_Unit_From.ValueData
              --, Object_Unit_To.ValueData
       ;

raise notice 'Value 17: %', CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ 0.�.
 10.06.20                                                     *
*/

-- 

SELECT * FROM lpInsert_Movement_Send_RemainsSun_Supplement_V2 (inOperDate:= CURRENT_DATE + INTERVAL '2 DAY', inDriverId:= 0, inUserId:= 3);