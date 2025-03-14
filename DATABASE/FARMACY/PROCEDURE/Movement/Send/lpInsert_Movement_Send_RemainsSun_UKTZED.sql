-- Function: lpInsert_Movement_Send_RemainsSun_UKTZED

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_UKTZED (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_UKTZED(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inDriverId            Integer   , -- ��������, ������������ ������ �� ������� �����
    IN inUserId              Integer     -- ������������
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , UnitId_From Integer, UnitName_From TVarChar

             , UnitId_To Integer, UnitName_To TVarChar
             , Amount TFloat

             , MCS TFloat
             , AmountRemains TFloat
             , AmountSalesDay TFloat
             , AverageSales TFloat
             , StockRatio TFloat

             , MCS_From TFloat
             , Price_From TFloat
             , AmountRemains_From TFloat
             , AmountSalesDey_From TFloat
             , AmountSalesMonth_From TFloat
             , AverageSalesMonth_From TFloat
             , Need_From TFloat
             , Delt_From TFloat

             , MCS_To TFloat
             , Price_To TFloat
             , AmountRemains_To TFloat
             , AmountSalesDey_To TFloat
             , AmountSalesMonth_To TFloat
             , AverageSalesMonth_To TFloat
             , Need_To TFloat
             , Delta_To TFloat

             , AmountUse_To TFloat
              )
AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbDOW_curr        TVarChar;

   DECLARE curPartion_next refcursor;
   DECLARE curResult_next  refcursor;

   DECLARE vbUnitId_from Integer;
   DECLARE vbUnitId_To Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbSurplus TFloat;
   DECLARE vbNeed TFloat;
   DECLARE vbKoeffSUN TFloat;

   DECLARE vbPeriod_t1    Integer;
   DECLARE vbPeriod_t2    Integer;
   DECLARE vbPeriod_t_max Integer;

   DECLARE vbisEliminateColdSUN Boolean;
   DECLARE vbisOnlyColdSUN Boolean;
   DECLARE vbisShoresSUN Boolean;
   DECLARE vbisCancelBansSUN Boolean;
BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     -- ���� ������
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;
                  
     -- !!! � ����
     vbPeriod_t1    := 35;
     vbPeriod_t2    := 25;     

     SELECT COALESCE(ObjectBoolean_CashSettings_EliminateColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_ShoresSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_OnlyColdSUN.ValueData, FALSE) 
          , COALESCE(ObjectBoolean_CashSettings_CancelBansSUN.ValueData, FALSE) 
     INTO vbisEliminateColdSUN, vbisShoresSUN, vbisOnlyColdSUN, vbisCancelBansSUN
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
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;

     -- ��� ������ ��� ����� SUN UKTZED
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_UKTZED   (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;
     END IF;

     -- ��� ������������� ��� ����� SUN UKTZED
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SUN_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SUN_UKTZED (UnitId Integer, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isOutUKTZED_SUN1 Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     END IF;

     -- ������ ���������� ��������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_DiscountExternal_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpGoods_DiscountExternal_UKTZED  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_TP_exception_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpGoods_TP_exception_UKTZED   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- ��� ������������ � ������� ���
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_Sun_exception_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpGoods_Sun_exception_UKTZED   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- 2.1. ��� ���������� ������ - OVER
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSale_over'))
     THEN
       CREATE TEMP TABLE _tmpSale_over   (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     END IF;
     -- 2.2. NotSold
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpSale_not'))
     THEN
       CREATE TEMP TABLE _tmpSale_not (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_all_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpRemains_all_UKTZED (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountNotSend TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountUse TFloat) ON COMMIT DROP;
     END IF;

     -- 2. ��� �������, ���, � ����. ��������� ������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpStockRatio_all_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpStockRatio_all_UKTZED   (GoodsId Integer, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AverageSales TFloat, StockRatio TFloat) ON COMMIT DROP;
     END IF;

     -- 3. ������������-1 ������� - �� ���� �������
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_UKTZED'))
     THEN
       CREATE TEMP TABLE _tmpResult_UKTZED   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     END IF;

     -- ��� ������ ��� ����� SUN UKTZED
     DELETE FROM _tmpGoods_SUN_UKTZED;
     -- ������ ���������� ��������
     DELETE FROM _tmpGoods_DiscountExternal_UKTZED;
     -- ��� ������������� ��� ����� SUN
     DELETE FROM _tmpUnit_SUN_UKTZED;
     DELETE FROM _tmpSale_over;
     DELETE FROM _tmpSale_not;

     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     DELETE FROM _tmpGoods_TP_exception_UKTZED;
     -- ��� ������������ � ������� ���
     DELETE FROM _tmpGoods_Sun_exception_UKTZED;
     -- 1. ��� �������, ��� => �������� ���-�� ����������
     DELETE FROM _tmpRemains_all_UKTZED;
     -- 2. ��� �������, ���, � ����. ��������� ������
     DELETE FROM _tmpStockRatio_all_UKTZED;
     -- 3. ������������-1 ������� - �� ���� �������
     DELETE FROM _tmpResult_UKTZED;

     -- ��� ������������� ��� ����� SUN
     INSERT INTO _tmpUnit_SUN_UKTZED (UnitId, Value_T1, Value_T2, DayIncome, DaySendSUN, DaySendSUNAll, Limit_N, isOutUKTZED_SUN1, isColdOutSUN)
        SELECT OB.ObjectId
             , CASE WHEN OF_T1.ValueData > 0 THEN OF_T1.ValueData ELSE vbPeriod_t1 END    AS Value_T1
             , CASE WHEN OF_T2.ValueData > 0 THEN OF_T2.ValueData ELSE vbPeriod_t2 END    AS Value_T2
             , CASE WHEN OF_DI.ValueData >= 0 THEN OF_DI.ValueData ELSE 0  END :: Integer AS DayIncome
             , CASE WHEN OF_DS.ValueData >  0 THEN OF_DS.ValueData ELSE 10 END :: Integer AS DaySendSUN
             , CASE WHEN OF_DSA.ValueData > 0 THEN OF_DSA.ValueData ELSE 0 END :: Integer AS DaySendSUNAll
             , CASE WHEN OF_SN.ValueData >  0 THEN OF_SN.ValueData ELSE 0  END :: TFloat  AS Limit_N
             , COALESCE (ObjectBoolean_OutUKTZED_SUN1.ValueData, FALSE)  :: Boolean       AS isOutUKTZED_SUN1
             , COALESCE (OB_ColdOutSUN.ValueData, FALSE)                                  AS isColdOutSUN
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectFloat   AS OF_T1  ON OF_T1.ObjectId  = OB.ObjectId AND OF_T1.DescId  = zc_ObjectFloat_Unit_T1_SUN_v2()
             LEFT JOIN ObjectFloat   AS OF_T2  ON OF_T2.ObjectId  = OB.ObjectId AND OF_T2.DescId  = zc_ObjectFloat_Unit_T2_SUN_v2()
             LEFT JOIN ObjectFloat   AS OF_DI  ON OF_DI.ObjectId  = OB.ObjectId AND OF_DI.DescId  = zc_ObjectFloat_Unit_Sun_v2Income()
             LEFT JOIN ObjectFloat   AS OF_DS  ON OF_DS.ObjectId  = OB.ObjectId AND OF_DS.DescId  = zc_ObjectFloat_Unit_HT_SUN_v2()
             LEFT JOIN ObjectFloat   AS OF_DSA ON OF_DSA.ObjectId = OB.ObjectId AND OF_DSA.DescId = zc_ObjectFloat_Unit_HT_SUN_All()
             LEFT JOIN ObjectFloat   AS OF_SN  ON OF_SN.ObjectId  = OB.ObjectId AND OF_SN.DescId  = zc_ObjectFloat_Unit_LimitSUN_N()
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_OutUKTZED_SUN1
                                     ON ObjectBoolean_OutUKTZED_SUN1.ObjectId = OB.ObjectId
                                    AND ObjectBoolean_OutUKTZED_SUN1.DescId = zc_ObjectBoolean_Unit_OutUKTZED_SUN1()
             LEFT JOIN ObjectBoolean AS OB_ColdOutSUN    
                                     ON OB_ColdOutSUN.ObjectId    = OB.ObjectId 
                                     AND OB_ColdOutSUN.DescId    = zc_ObjectBoolean_Unit_ColdOutSUN()
        WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN()
          -- ���� ������ ���� ������ - �������� ���
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = '')
       ;


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
      INSERT INTO _tmpGoods_DiscountExternal_UKTZED 
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

     -- ������� ������������
     vbPeriod_t_max := (SELECT MAX (CASE WHEN _tmpUnit_SUN_UKTZED.Value_T1 > _tmpUnit_SUN_UKTZED.Value_T2 THEN _tmpUnit_SUN_UKTZED.Value_T1 ELSE _tmpUnit_SUN_UKTZED.Value_T2 END)
                        FROM _tmpUnit_SUN_UKTZED
                       );

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
                     FROM _tmpUnit_SUN_UKTZED

                          INNER JOIN tmpMovement AS Movement ON Movement.UnitId = _tmpUnit_SUN_UKTZED.UnitId

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

     INSERT INTO _tmpGoods_TP_exception_UKTZED   (UnitId, GoodsId)
     SELECT tmpGoods.UnitId, tmpGoods.GoodsId
     FROM tmpGoods;

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
     INSERT INTO _tmpGoods_Sun_exception_UKTZED (UnitId, GoodsId, Amount)
        SELECT tmpSUN.UnitId, tmpSUN.GoodsId, tmpSUN.Amount
        FROM tmpSUN;

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
     
     -- ��� ������ ��� ����� SUN UKTZED
     WITH tmpRemains AS (SELECT Container.ObjectId     AS GoodsId
                         FROM Container

                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_DivisionParties
                                                            ON ContainerLinkObject_DivisionParties.Containerid = Container.Id
                                                           AND ContainerLinkObject_DivisionParties.DescId = zc_ContainerLinkObject_DivisionParties()
                                                    
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_BanFiscalSale
                                                      ON ObjectBoolean_BanFiscalSale.ObjectId = ContainerLinkObject_DivisionParties.ObjectId
                                                     AND ObjectBoolean_BanFiscalSale.DescId = zc_ObjectBoolean_DivisionParties_BanFiscalSale()
                              

                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                           AND Container.WhereObjectId in (SELECT UnitId FROM _tmpUnit_SUN_UKTZED WHERE isOutUKTZED_SUN1 = TRUE)
                           AND COALESCE (ObjectBoolean_BanFiscalSale.ValueData, False) = True
                         GROUP BY Container.ObjectId)

     INSERT INTO _tmpGoods_SUN_UKTZED (GoodsId, KoeffSUN)
        SELECT Object_Goods_Retail.ID
             , Object_Goods_Retail.KoeffSUN_SupplementV1
        FROM tmpRemains
             INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpRemains.GoodsId;


     -- 2.1. ��� ���������� ������
     INSERT INTO _tmpSale_over (UnitId, GoodsId, Amount_t1, Summ_t1, Amount_t2, Summ_t2)
        SELECT tmp.UnitId
             , tmp.GoodsId
               -- � ����������� � ������� T1=60 ���� OR T1=30 ����
             , SUM (tmp.Amount_t1) AS Amount_t1, SUM (tmp.Summ_t1) AS Summ_t1
               -- � ���������� � ������� T2=45
             , SUM (tmp.Amount_t2) AS Amount_t2, SUM (tmp.Summ_t2) AS Summ_t2
        FROM (-- zc_Movement_Check
              SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                   , MIContainer.ObjectId_analyzer               AS GoodsId
                   , SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0)                                  ELSE 0 END) AS Amount_t1
                   , SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summ_t1
                   , SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0)                                  ELSE 0 END) AS Amount_t2
                   , SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summ_t2
              FROM MovementItemContainer AS MIContainer
                   INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = MIContainer.WhereObjectId_analyzer
                   INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = MIContainer.ObjectId_analyzer
                   LEFT JOIN MovementBoolean AS MB_NotMCS
                                             ON MB_NotMCS.MovementId = MIContainer.MovementId
                                            AND MB_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                                            AND MB_NotMCS.ValueData  = TRUE
              WHERE MIContainer.DescId         = zc_MIContainer_Count()
                AND MIContainer.MovementDescId = zc_Movement_Check()
                AND MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((vbPeriod_t_max :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate
              GROUP BY MIContainer.ObjectId_analyzer
                     , MIContainer.WhereObjectId_analyzer
              HAVING SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) <> 0
                  OR SUM (CASE WHEN MIContainer.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND MIContainer.OperDate < inOperDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) <> 0

             UNION ALL
              -- zc_Movement_Sale
              SELECT MLO_Unit.ObjectId      AS UnitId
                   , MovementItem.ObjectId  AS GoodsId
                   , SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0)                                    ELSE 0 END) AS Amount_t1
                   , SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0) * COALESCE (MIF_Price.ValueData,0) ELSE 0 END) AS Summ_t1
                   , SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0)                                    ELSE 0 END) AS Amount_t2
                   , SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0) * COALESCE (MIF_Price.ValueData,0) ELSE 0 END) AS Summ_t2
              FROM Movement
                   INNER JOIN MovementLinkObject AS MLO_Unit
                                                 ON MLO_Unit.MovementId = Movement.Id
                                                AND MLO_Unit.DescId     = zc_MovementLinkObject_Unit()
                   INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId     = MLO_Unit.ObjectId
                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                   INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = MovementItem.ObjectId
                   LEFT JOIN MovementItemFloat AS MIF_Price
                                               ON MIF_Price.MovementItemId = Movement.Id
                                              AND MIF_Price.DescId     = zc_MIFloat_Price()
              WHERE Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((vbPeriod_t_max :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate
                AND Movement.DescId   = zc_Movement_Sale()
                AND Movement.StatusId = zc_Enum_Status_Complete()
              GROUP BY MLO_Unit.ObjectId
                     , MovementItem.ObjectId
              HAVING SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T1 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END) <> 0
                  OR SUM (CASE WHEN Movement.OperDate >= inOperDate + INTERVAL '0 DAY' - ((_tmpUnit_SUN_UKTZED.Value_T2 :: Integer) :: TVarChar || ' DAY') :: INTERVAL AND Movement.OperDate < inOperDate THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END) <> 0
             ) AS tmp
        GROUP BY tmp.UnitId
               , tmp.GoodsId
       ;


     -- 2.2. NotSold
     INSERT INTO _tmpSale_not (UnitId, GoodsId, Amount)
        WITH -- ������ ��� NotSold
             tmpContainer AS (SELECT Container.Id               AS ContainerId
                                   , Container.WhereObjectId    AS UnitId
                                   , Container.ObjectId         AS GoodsId
                                   , Container.Amount           AS Amount
                              FROM -- !!!������ ��� ����� �����!!!
                                   _tmpUnit_SUN_UKTZED
                                   INNER JOIN _tmpGoods_SUN_UKTZED ON 1 = 1
                                   INNER JOIN Container ON Container.WhereObjectId = _tmpUnit_SUN_UKTZED.UnitId
                                                       AND Container.Amount        <> 0
                                                       AND Container.DescId        = zc_Container_Count()
                                                       AND Container.ObjectId      = _tmpGoods_SUN_UKTZED.GoodsId
                             )
             -- ��� ����� ���������� NotSold
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
        -- ���������
        SELECT tmpNotSold_all.UnitId
             , tmpNotSold_all.GoodsId
             , tmpNotSold_all.Amount
        FROM tmpNotSold_all
       ;


     -- 2.4. ��� �������, ������� => ������ ���-�� ����������� � ����������
     WITH -- ������ - UnComplete - �� ��������� +/-7 ���� ��� Date_Branch
         tmpMI_Income AS (SELECT MovementLinkObject_To.ObjectId  AS UnitId
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
                                -- !!!������ ��� ����� �����!!!
                                INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = MovementLinkObject_To.ObjectId
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = MovementItem.ObjectId  
                           WHERE Movement.DescId   = zc_Movement_Income()
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           GROUP BY MovementLinkObject_To.ObjectId, MovementItem.ObjectId
                           HAVING SUM (MovementItem.Amount) <> 0
                          )
       -- ����������� - ������ - UnComplete - �� ��������� +/-30 ����
     , tmpMI_Send_in AS (SELECT MovementLinkObject_To.ObjectId AS UnitId_to
                              , MovementItem.ObjectId          AS GoodsId
                              , SUM (MovementItem.Amount)      AS Amount
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                 -- !!!������ ��� ����� �����!!!
                                 INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = MovementLinkObject_To.ObjectId
                                 -- ����������� - ����� ����� ��� �����������, �� ������ ����
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
                                 INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = MovementItem.ObjectId  
                                 -- ����� ������� - ��������� "������������" ������� - ��� � ������� ����� "������" ������ - ��� �����
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
      -- ����������� - ������ - UnComplete - �� ��������� +/-14 ����
    , tmpMI_Send_out AS (SELECT MovementLinkObject_From.ObjectId AS UnitId_from
                              , MovementItem.ObjectId            AS GoodsId
                              , SUM (MovementItem.Amount)        AS Amount
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                 -- !!!������ ��� ����� �����!!!
                                 INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = MovementLinkObject_From.ObjectId
                                 -- ����������� - ����� ����� ��� �����������, �� ������ ����
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
                                 INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = MovementItem.ObjectId  
                                 -- ����� ������� - ��������� "������������" ������� - ��� � ������� ����� "������" ������ - ��� �����
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
          -- ������ - UnComplete - !���! Deferred
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
                                       -- !!!������ ��� ����� �����!!!
                                       INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = MovementLinkObject_Unit.ObjectId
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                              AND MovementItem.DescId     = zc_MI_Master()
                                                              AND MovementItem.isErased   = FALSE
                                       INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = MovementItem.ObjectId  

                                  WHERE Movement.DescId   = zc_Movement_OrderExternal()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                  GROUP BY MovementLinkObject_Unit.ObjectId, MovementItem.ObjectId
                                  HAVING SUM (MovementItem.Amount) <> 0
                                 )
          -- ���������� ���� + �� ����������� � CommentError
        , tmpMovementCheck AS (SELECT Movement.Id AS MovementId, MovementLinkObject_Unit.ObjectId AS UnitId
                               FROM MovementBoolean AS MovementBoolean_Deferred
                                    INNER JOIN Movement ON Movement.Id       = MovementBoolean_Deferred.MovementId
                                                       AND Movement.DescId   = zc_Movement_Check()
                                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    -- !!!������ ��� ����� �����!!!
                                    INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = MovementLinkObject_Unit.ObjectId
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
                                    -- !!!������ ��� ����� �����!!!
                                    INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = MovementLinkObject_Unit.ObjectId
                               WHERE MovementString_CommentError.DescId    = zc_MovementString_CommentError()
                                 AND MovementString_CommentError.ValueData <> ''
                              )
          -- ���������� ���� + �� ����������� � CommentError
        , tmpMI_Reserve AS (SELECT tmpMovementCheck.UnitId
                                 , MovementItem.ObjectId     AS GoodsId
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM tmpMovementCheck
                                 INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementCheck.MovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = MovementItem.ObjectId  
                            GROUP BY tmpMovementCheck.UnitId, MovementItem.ObjectId
                           )
          -- �������
        , tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (Container.Amount, 0)) AS Amount
                         FROM Container
                              -- !!!������ ��� ����� �����!!!
                              INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = Container.WhereObjectId
                              INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = Container.ObjectId  
                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
        , tmpRemainsNoSend AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (Container.Amount, 0)) AS Amount
                         FROM Container
                              -- !!!������ ��� ����� �����!!!
                              INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = Container.WhereObjectId
                              INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = Container.ObjectId  

                              LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ContainerId = Container.Id
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                              LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                   ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                  AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                         WHERE Container.DescId = zc_Container_CountPartionDate()
                           AND Container.Amount <> 0
                           -- !!!�������� ������ ��� ���������
                           AND ObjectDate_PartionGoods_Value.ValueData <= CURRENT_DATE + INTERVAL '30 DAY'
                           -- !!!�������� ������ ��� ���������
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
          -- MCS_isClose
        , tmpPrice_MCS_isClose AS (SELECT MCS_isClose.*
                                   FROM ObjectLink AS OL_Price_Unit
                                        -- !!!������ ��� ����� �����!!!
                                        INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = OL_Price_Unit.ChildObjectId
                                        --
                                        INNER JOIN ObjectBoolean AS MCS_isClose
                                                                 ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                                AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                                AND MCS_isClose.ValueData = TRUE
                                   WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
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
                       FROM ObjectLink AS OL_Price_Unit
                            -- !!!������ ��� ����� �����!!!
                            INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = OL_Price_Unit.ChildObjectId
                            -- 25.05.20 -- �������� �������� - 21.05.20
                            LEFT JOIN tmpPrice_MCS_isClose AS MCS_isClose
                                                           ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                            LEFT JOIN ObjectLink AS OL_Price_Goods
                                                 ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = OL_Price_Goods.ChildObjectId 
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
                                   INNER JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

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
                                   INNER JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId = ObjectLink_Child_retail.ChildObjectId
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
     -- 2.5. ���������: ��� �������, ������� => ������ ���-�� ����������� � ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains_all_UKTZED (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountNotSend, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve, AmountUse)
        --
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             , CASE WHEN 1.0 <= FLOOR (-- ������� � � ���������� � ������� T2=45
                                       (COALESCE (_tmpSale_over.Amount_t2, 0)
                                        -- ����� �������
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
                                        -- ����� ��� ��� "������" ���������� �� ��� SUN-����� �������� - ��������� "�����������"
                                      - COALESCE (tmpSUN_oth.Amount, 0)
                                       )
                                       -- ����� �� ���������
                                     / COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 1)
                                      ) * COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 1)
                         THEN -- ��������� �����
                              FLOOR (-- ������� � � ���������� � ������� T2=45
                                     (COALESCE (_tmpSale_over.Amount_t2, 0)
                                      -- ����� �������
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
                                        -- ����� ��� ��� "������" ���������� �� ��� SUN-����� �������� - ��������� "�����������"
                                      - COALESCE (tmpSUN_oth.Amount, 0)
                                     )
                                     -- ����� �� ���������
                                   / COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 1)
                                    ) * COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 1)
                    ELSE 0
               END AS AmountResult
               -- �������
             , COALESCE (tmpRemains.Amount, 0)          AS AmountRemains
             , COALESCE (tmpRemainsNoSend.Amount, 0)    AS AmountNotSend
               -- ������ - UnComplete - �� ��������� +/-7 ���� ��� Date_Branch
             , COALESCE (tmpMI_Income.Amount, 0)        AS AmountIncome
               -- ����������� - ������ - UnComplete - �� ��������� +/-30 ����
             , COALESCE (tmpMI_Send_in.Amount, 0)       AS AmountSend_In
               -- ����������� - ������ - UnComplete - �� ��������� +/-30 ����
             , COALESCE (tmpMI_Send_out.Amount, 0)      AS AmountSend_out
               -- ������ - UnComplete - !���! Deferred
             , COALESCE (tmpMI_OrderExternal.Amount,0)  AS AmountOrderExternal
               -- ���������� ���� + �� ����������� � CommentError
             , COALESCE (tmpMI_Reserve.Amount, 0)       AS AmountReserve
             , 0                                        AS AmountUse
        FROM tmpObject_Price
             LEFT JOIN tmpRemains AS tmpRemains
                                  ON tmpRemains.UnitId  = tmpObject_Price.UnitId
                                 AND tmpRemains.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpRemainsNoSend AS tmpRemainsNoSend
                                        ON tmpRemainsNoSend.UnitId  = tmpObject_Price.UnitId
                                       AND tmpRemainsNoSend.GoodsId = tmpObject_Price.GoodsId
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

             -- ������ ��� ���������
             LEFT JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsId  = tmpObject_Price.GoodsId

             -- ��� ��� "������" ���������� �� ��� SUN-����� �������� - ��������� "�����������"
             LEFT JOIN (SELECT _tmpGoods_Sun_exception_UKTZED.UnitId, _tmpGoods_Sun_exception_UKTZED.GoodsId, SUM (_tmpGoods_Sun_exception_UKTZED.Amount) AS Amount
                        FROM _tmpGoods_Sun_exception_UKTZED 
                        GROUP BY _tmpGoods_Sun_exception_UKTZED.UnitId, _tmpGoods_Sun_exception_UKTZED.GoodsId
                       ) AS tmpSUN_oth
                         ON tmpSUN_oth.UnitId    = tmpObject_Price.UnitId
                        AND tmpSUN_oth.GoodsId   = tmpObject_Price.GoodsId

             -- ��������� !!��������!!
             -- 25.05.20 -- �������� �������� - 13.05.20
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isClose
                                     ON ObjectBoolean_Goods_isClose.ObjectId  = tmpObject_Price.GoodsId
                                    AND ObjectBoolean_Goods_isClose.DescId    = zc_ObjectBoolean_Goods_Close()
                                    AND ObjectBoolean_Goods_isClose.ValueData = TRUE
             -- !!!
             LEFT JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = tmpObject_Price.UnitId

             -- ��������� !!���������!!
             INNER JOIN Object AS Object_Goods ON Object_Goods.Id        = tmpObject_Price.GoodsId
                                              AND Object_Goods.ValueData NOT ILIKE '���%'
             -- �� ��������� !!�����!!
             /*LEFT JOIN ObjectLink AS OL_Goods_ConditionsKeep
                                    ON OL_Goods_ConditionsKeep.ObjectId = tmpObject_Price.GoodsId
                                   AND OL_Goods_ConditionsKeep.DescId   = zc_ObjectLink_Goods_ConditionsKeep()
               LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = OL_Goods_ConditionsKeep.ChildObjectId
             */
       ;       
       

/*     -- 2.2. ���������� ����� ��� �������� ����� ���������� ������ ��� �������
     UPDATE _tmpRemains_all_UKTZED SET Need = - floor(_tmpRemains_all_UKTZED.AmountRemains)
     WHERE (_tmpRemains_all_UKTZED.AmountRemains + _tmpRemains_all_UKTZED.Need) < 0;
*/

     -- 3. ������������
     --
     -- ������1 - ��� ��� ����� ������������
     OPEN curPartion_next FOR
        SELECT _tmpRemains_all_UKTZED.UnitId
             , _tmpRemains_all_UKTZED.GoodsId
             , _tmpRemains_all_UKTZED.AmountRemains - _tmpRemains_all_UKTZED.AmountNotSend AS Need
             , COALESCE (_tmpGoods_SUN_UKTZED.KoeffSUN, 0)
       FROM _tmpRemains_all_UKTZED

            LEFT JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsID = _tmpRemains_all_UKTZED.GoodsId

            LEFT JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = _tmpRemains_all_UKTZED.UnitId

            -- ������ ���������� �����
            LEFT JOIN _tmpGoods_DiscountExternal_UKTZED AS _tmpGoods_DiscountExternal
                                                        ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_all_UKTZED.UnitId
                                                       AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_all_UKTZED.GoodsId

            -- � �����, ��������� !!�����!!
            LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_all_UKTZED.GoodsId

       WHERE _tmpUnit_SUN_UKTZED.isOutUKTZED_SUN1 = True
         AND _tmpRemains_all_UKTZED.AmountRemains - _tmpRemains_all_UKTZED.AmountNotSend > 0
         AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
             -- ��������� !!�����!!
         AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
             tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE OR
             _tmpUnit_SUN_UKTZED.isColdOutSUN = TRUE)
       ORDER BY _tmpRemains_all_UKTZED.UnitId
              , _tmpRemains_all_UKTZED.GoodsId
       ;
     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbSurplus, vbKoeffSUN;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

--         raise notice 'Value 01: % % % %', vbUnitId_from, vbGoodsId, vbSurplus, vbKoeffSUN;

         -- ������2. - ����������� ��� vbGoodsId
         OPEN curResult_next FOR
             SELECT _tmpRemains_all_UKTZED.UnitId
                  , _tmpRemains_all_UKTZED.AmountResult - _tmpRemains_all_UKTZED.AmountUse
             FROM _tmpRemains_all_UKTZED

                  LEFT JOIN _tmpGoods_SUN_UKTZED ON _tmpGoods_SUN_UKTZED.GoodsID = _tmpRemains_all_UKTZED.GoodsId

                  LEFT JOIN _tmpUnit_SUN_UKTZED ON _tmpUnit_SUN_UKTZED.UnitId = _tmpRemains_all_UKTZED.UnitId

                  -- ������ ���������� �����
                  LEFT JOIN _tmpGoods_DiscountExternal_UKTZED AS _tmpGoods_DiscountExternal
                                                              ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_all_UKTZED.UnitId
                                                             AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_all_UKTZED.GoodsId
             WHERE (_tmpRemains_all_UKTZED.AmountResult - _tmpRemains_all_UKTZED.AmountUse) > 0
               AND _tmpRemains_all_UKTZED.GoodsId = vbGoodsId
               AND _tmpUnit_SUN_UKTZED.isOutUKTZED_SUN1 = False
               AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
             ORDER BY _tmpRemains_all_UKTZED.AmountResult - _tmpRemains_all_UKTZED.AmountUse DESC
                    , _tmpRemains_all_UKTZED.UnitId
                    , _tmpRemains_all_UKTZED.GoodsId;
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� ���������
         LOOP
             -- ������ �� ���������
             FETCH curResult_next INTO vbUnitId_to, vbNeed;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR vbSurplus = 0 THEN EXIT; END IF;

--             IF vbUnitId_to = 8393158 AND vbGoodsId = 21310
--             THEN
               raise notice 'Value 05: % % % % % % %', vbUnitId_from, vbUnitId_to, vbGoodsId, vbKoeffSUN, vbNeed, vbSurplus, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END;
--             END IF;

             IF COALESCE(vbKoeffSUN, 0) <= 1 OR vbSurplus >= vbNeed
             THEN
               INSERT INTO _tmpResult_UKTZED (UnitId_from, UnitId_to, GoodsId, Amount)
                 VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END);

               UPDATE _tmpRemains_all_UKTZED SET AmountUse = AmountUse + CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END
               WHERE _tmpRemains_all_UKTZED.UnitId = vbUnitId_to
                 AND _tmpRemains_all_UKTZED.GoodsId = vbGoodsId;

               vbSurplus := vbSurplus - CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END;
             ELSEIF vbKoeffSUN > 1 AND (FLOOR (vbSurplus / vbKoeffSUN) * vbKoeffSUN) > 0
             THEN
               INSERT INTO _tmpResult_UKTZED (UnitId_from, UnitId_to, GoodsId, Amount)
                 VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, FLOOR (vbSurplus / vbKoeffSUN) * vbKoeffSUN);

               UPDATE _tmpRemains_all_UKTZED SET AmountUse = AmountUse + FLOOR (vbSurplus / vbKoeffSUN) * vbKoeffSUN
               WHERE _tmpRemains_all_UKTZED.UnitId = vbUnitId_to
                 AND _tmpRemains_all_UKTZED.GoodsId = vbGoodsId;

               vbSurplus := vbSurplus - FLOOR (vbSurplus / vbKoeffSUN) * vbKoeffSUN;             
             END IF;

         END LOOP; -- ����� ����� �� �������2
         CLOSE curResult_next; -- ������� ������2.

     END LOOP; -- ����� ����� �� �������1
     CLOSE curPartion_next; -- ������� ������1


-- raise notice 'Value 06: %', (select Count(*) from _tmpResult_UKTZED );
 
     -- ���������
     RETURN QUERY
       SELECT Object_Goods.Id                            AS GoodsId
            , Object_Goods.ObjectCode                    AS GoodsCode
            , Object_Goods.ValueData                     AS GoodsName

            , Object_Unit_From.Id                        AS UnitId_From
            , Object_Unit_From.ValueData                 AS UnitName_From

            , Object_Unit_To.Id                          AS UnitId_To
            , Object_Unit_To.ValueData                   AS UnitName_To

            , _tmpResult_UKTZED.Amount               AS Amount

            , _tmpStockRatio_all_UKTZED.MCS
            , _tmpStockRatio_all_UKTZED.AmountRemains
            , _tmpStockRatio_all_UKTZED.AmountSalesDay
            , _tmpStockRatio_all_UKTZED.AverageSales
            , _tmpStockRatio_all_UKTZED.StockRatio

            , tmpRemains_all_From.MCS                    AS MCS_From
            , tmpRemains_all_From.Price                  AS Price_From
            , tmpRemains_all_From.AmountRemains          AS AmountRemains_From
            , 0::TFloat /*tmpRemains_all_From.AmountSalesDay*/         AS AmountSalesDay_From
            , 0::TFloat /*tmpRemains_all_From.AmountSalesMonth*/       AS AmountSalesMonth_From

            , 0::TFloat /*tmpRemains_all_From.AverageSalesMonth*/      AS AverageSalesMonth_From
            , tmpRemains_all_From.AmountRemains /*Need */                 AS Surplus_From
            , 0::TFloat /*CASE WHEN tmpRemains_all_From.AmountSalesMonth = 0
                   THEN - tmpRemains_all_From.AmountRemains
                   ELSE (tmpRemains_all_From.Need -tmpRemains_all_From.AmountRemains)::Integer
              END::TFloat */                                      AS Delta_From

            , tmpRemains_all_To.MCS                      AS MCS_To
            , tmpRemains_all_To.Price                    AS Price_To
            , tmpRemains_all_To.AmountRemains            AS AmountRemains_To
            , 0::TFloat /*tmpRemains_all_To.AmountSalesDay*/           AS AmountSalesDay_To
            , 0::TFloat /*tmpRemains_all_To.AmountSalesMonth*/         AS AmountSalesMonth_To

            , 0::TFloat /*tmpRemains_all_To.AverageSalesMonth*/        AS AverageSalesMonth_To
            , tmpRemains_all_To.AmountRemains /*Need*/                    AS Surplus_To
            , 0::TFloat /*CASE WHEN tmpRemains_all_To.AmountSalesMonth = 0
                   THEN - tmpRemains_all_To.AmountRemains
                   ELSE (tmpRemains_all_To.Need -tmpRemains_all_To.AmountRemains)::Integer
              END::TFloat             */                          AS Delta_To
            , 0::TFloat /*tmpRemains_all_To.AmountUse */                      AS AmountUse_To

       FROM _tmpResult_UKTZED

            LEFT JOIN _tmpStockRatio_all_UKTZED ON _tmpStockRatio_all_UKTZED.GoodsId = _tmpResult_UKTZED.GoodsId

            LEFT JOIN _tmpRemains_all_UKTZED AS tmpRemains_all_From
                                                 ON tmpRemains_all_From.UnitId  = _tmpResult_UKTZED.UnitId_from
                                                AND tmpRemains_all_From.GoodsId = _tmpResult_UKTZED.GoodsId
            LEFT JOIN Object AS Object_Unit_From  ON Object_Unit_From.Id  = tmpRemains_all_From.UnitId


            LEFT JOIN _tmpRemains_all_UKTZED AS tmpRemains_all_To
                                                 ON tmpRemains_all_To.UnitId  = _tmpResult_UKTZED.UnitId_to
                                                AND tmpRemains_all_To.GoodsId = _tmpResult_UKTZED.GoodsId
            LEFT JOIN Object AS Object_Unit_To  ON Object_Unit_To.Id  = tmpRemains_all_To.UnitId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpRemains_all_To.GoodsId
       ORDER BY Object_Goods.Id
              , Object_Unit_From.ValueData
              , Object_Unit_To.ValueData
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ 0.�.
 30.01.21                                                     *
*/

--SELECT * FROM lpInsert_Movement_Send_RemainsSun_UKTZED (inOperDate:= CURRENT_DATE + INTERVAL '0 DAY', inDriverId:= 0, inUserId:= 3); -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ

-- select * from gpReport_Movement_Send_RemainsSun_UKTZED(inOperDate := ('28.12.2020')::TDateTime ,  inSession := '3');

--
 select * from gpReport_Movement_Send_RemainsSun_UKTZED(inOperDate := ('12.04.2021')::TDateTime ,  inSession := '3');