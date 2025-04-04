-- Function: lpInsert_Movement_Send_RemainsSun

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inDriverId            Integer   , -- ��������, ������������ ������ �� ������� �����
    IN inStep                Integer   , -- �� 1-�� ���� ������� DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� �� 2-� ���� ��� ����������� �� ����� !!!
    IN inUserId              Integer     -- ������������
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, isClose boolean
             , Amount_sale         TFloat --
             , Summ_sale           TFloat --
             , AmountSun_real      TFloat -- ����� �������� �� �������� ��������, ������ ��������� � AmountSun_summ_save
             , AmountSun_summ_save TFloat -- ����� ��������, ��� ����� ���������
             , AmountSun_summ      TFloat -- ����� �������� + notSold, ������� ����� ������������
             , AmountSunOnly_summ  TFloat -- ����� ��������, ������� ����� ������������
             , Amount_notSold_summ TFloat -- ����� notSold, ������� ����� ������������

             , AmountResult        TFloat -- ���������    -- ����� ������� ����� � ��� ������
             , AmountResult_summ   TFloat -- ����� ��������� �� ���� ������� --���
             , AmountRemains       TFloat -- �������
             , AmountIncome        TFloat -- ������ (���������)--���
             , AmountSend_in       TFloat -- ����������� - ������ (���������)--���
             , AmountSend_out      TFloat -- ����������� - ������ (���������)--���
             , AmountOrderExternal TFloat -- ����� (���������)
             , AmountReserve       TFloat -- ������ �� �����
             , AmountSun_unit      TFloat -- ���.=0, �������� �� ���� ������, ����� ����������� � ������ ����� �� �����, �.�. ���� ��������� �� ���������
             , AmountSun_unit_save TFloat -- ���.=0, �������� �� ���� ������, ��� ����� ���������
             , Price               TFloat -- ����
             , MCS                 TFloat -- ���
             , Layout              TFloat -- ��������
             , PromoUnit           TFloat -- ����. ���� ��� �����
             , isCloseMCS          boolean -- ����� ���
             , Summ_min            TFloat -- ������������ - �������� �����
             , Summ_max            TFloat -- ������������ - ���������� �����
             , Unit_count          TFloat -- ������������ - ���-�� ����� ����.
             , Summ_min_1          TFloat -- ������������ - ����� �������������-1: �������� �����
             , Summ_max_1          TFloat -- ������������ - ����� �������������-1: ���������� �����
             , Unit_count_1        TFloat -- ������������ - ����� �������������-1: ���-�� ����� ����.
             , Summ_min_2          TFloat -- ������������ - ����� �������������-2: �������� �����
             , Summ_max_2          TFloat -- ������������ - ����� �������������-2: ���������� �����
             , Unit_count_2        TFloat -- ������������ - ����� �������������-2: ���-�� ����� ����.
             , Summ_str            TVarChar
             , Summ_next_str       TVarChar
             , UnitName_str        TVarChar
             , UnitName_next_str   TVarChar
            -- !!!���������!!!
             , Amount_res          TFloat
             , Summ_res            TFloat
             , Amount_next_res     TFloat
             , Summ_next_res       TFloat
             , Amount_not_out_res  TFloat
             , Summ_not_out_res    TFloat
             , Amount_not_in_res   TFloat
             , Summ_not_in_res     TFloat

             , InvNumberLayout TVarChar
             , LayoutName TVarChar
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

   DECLARE vbDOW_curr        Integer;

   DECLARE vbDate_balance_partion TDateTime;
   DECLARE vbSumm_balance_partion TFloat;

   DECLARE vbIsOut_partion Boolean;
   DECLARE vbIsIn_partion  Boolean;

   DECLARE vbDayIncome_max Integer;
   DECLARE vbDaySendSUN_max Integer;
   DECLARE vbDaySendSUNAll_max Integer;

   DECLARE vbGoodsId_PairSun Integer;
   DECLARE vbPrice_PairSun   TFloat;
   DECLARE vbisEliminateColdSUN Boolean;
   DECLARE vbisOnlyColdSUN Boolean;
   DECLARE vbisNotSold100  Boolean;
   DECLARE vbisNotSoldIn Boolean;
   
   DECLARE vbisShoresSUN Boolean;
   DECLARE vbisCancelBansSUN Boolean;
   DECLARE vbisLegalEntitiesSUN Boolean;
   DECLARE vbJuridicalId Integer;

BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);


/* if  inUserId = 3 then
     -- ������� ��������
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
          
     -- !!! ������������ ������ ������ �� ������
     vbDate_balance_partion:= '22.01.2020';
     -- !!! ��� ��� ���� ����������� ������/������ - ������ �� ������
     vbSumm_balance_partion:= 1000;


     -- ��� ������������� ��� ����� SUN
     DELETE FROM _tmpUnit_SUN;
     DELETE FROM _tmpUnit_SunExclusion;
     DELETE FROM _tmpGoods_Layout;
     DELETE FROM _tmpGoods_PromoUnit;
     DELETE FROM _tmpGoods_DiscountExternal;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     IF inStep = 1
     THEN
         DELETE FROM _tmpUnit_SUN_balance;
         DELETE FROM _tmpUnit_SUN_balance_partion;
     END IF;
     DELETE FROM _tmpGoods_TP_exception;
     -- 1. ��� �������, ��� => �������� ���-�� ����������
     DELETE FROM _tmpRemains_all;
     DELETE FROM _tmpRemains;
     -- 2.1. ��� ���������� ������
     DELETE FROM _tmpSale;
     -- 2.2.
     IF inStep = 1
     THEN
         -- ������ ��� ���������
         DELETE FROM _tmpGoods_SUN;
         -- "���� ������ � ���"... ���� � ����� �� ����� ��� ������������ ����� X, �� � ������������ ������� ������ ������������ ����� Y � ��� �� ����������
         DELETE FROM _tmpGoods_SUN_PairSun;
     END IF;
     -- 2.4. ��� ������������ � ������� ���
     DELETE FROM _tmpGoods_Sun_exception;
     -- 3.1. ��� �������, ����
     DELETE FROM _tmpRemains_Partion_all;
     -- 3.2. �������, ���� - ��� �������������
     DELETE FROM _tmpRemains_Partion;
     -- 4. ������� �� ������� ���� ��������� � ����
     DELETE FROM _tmpRemains_calc;
     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     DELETE FROM _tmpSumm_limit;
     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� �� ������ >= vbSumm_limit
     DELETE FROM _tmpResult_Partion;
     -- 6.2. !!!������ - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     IF inStep = 1 THEN DELETE FROM _tmpList_DefSUN; END IF;
     -- 7.1. ������������ ����������� - �� ������� �� �������
     DELETE FROM _tmpResult_child;


     -- ���� ������
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  );

raise notice 'Value 1: % % %', CLOCK_TIMESTAMP(), vbisEliminateColdSUN, vbisOnlyColdSUN;

     -- ��� ������������� ��� ����� SUN
     INSERT INTO _tmpUnit_SUN (UnitId, KoeffInSUN, KoeffOutSUN, DayIncome, DaySendSUN, DaySendSUNAll, Limit_N, isLock_CheckMSC, isLock_CloseGd, isLock_ClosePL, isLock_CheckMa, isOnlyTimingSUN, isColdOutSUN)
        SELECT OB.ObjectId
             , COALESCE (OF_KoeffInSUN.ValueData, 0)  AS KoeffInSUN
             , COALESCE (OF_KoeffOutSUN.ValueData, 0) AS KoeffOutSUN
             , CASE WHEN OF_DI.ValueData >= 0 THEN OF_DI.ValueData ELSE 0  END :: Integer AS DayIncome
             , CASE WHEN OF_DS.ValueData >  0 THEN OF_DS.ValueData ELSE 10 END :: Integer AS DaySendSUN
             , CASE WHEN OF_DSA.ValueData > 0 THEN OF_DSA.ValueData ELSE 0 END :: Integer AS DaySendSUNAll
             , CASE WHEN OF_SN.ValueData >  0 THEN OF_SN.ValueData ELSE 0  END :: TFloat  AS Limit_N
               -- TRUE = �� ���������� ��� "�� ��� ���"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 1 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLockSale
               -- TRUE = ��� ������� "������ ���"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 3 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseGd
               -- TRUE = ��� ������� "���� ���"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 5 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_ClosePL
               -- TRUE = ��� ������� "���������"
             , COALESCE (CASE WHEN SUBSTRING (OS_LL.ValueData FROM 7 FOR 1) = '1' THEN TRUE ELSE FALSE END, TRUE) AS isLock_CloseMa
             , COALESCE (OB_OnlyTimingSUN.ValueData, FALSE)                               AS isOnlyTimingSUN
             , COALESCE (OB_ColdOutSUN.ValueData, FALSE)                                  AS isColdOutSUN
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectFloat   AS OF_KoeffInSUN    ON OF_KoeffInSUN.ObjectId    = OB.ObjectId AND OF_KoeffInSUN.DescId    = zc_ObjectFloat_Unit_KoeffInSUN()
             LEFT JOIN ObjectFloat   AS OF_KoeffOutSUN   ON OF_KoeffOutSUN.ObjectId   = OB.ObjectId AND OF_KoeffOutSUN.DescId   = zc_ObjectFloat_Unit_KoeffOutSUN()
             LEFT JOIN ObjectString  AS OS_ListDaySUN    ON OS_ListDaySUN.ObjectId    = OB.ObjectId AND OS_ListDaySUN.DescId    = zc_ObjectString_Unit_ListDaySUN()
             LEFT JOIN ObjectFloat   AS OF_DI            ON OF_DI.ObjectId            = OB.ObjectId AND OF_DI.DescId            = zc_ObjectFloat_Unit_SunIncome()
             LEFT JOIN ObjectFloat   AS OF_DS            ON OF_DS.ObjectId            = OB.ObjectId AND OF_DS.DescId            = zc_ObjectFloat_Unit_HT_SUN_v1()
             LEFT JOIN ObjectFloat   AS OF_DSA           ON OF_DSA.ObjectId           = OB.ObjectId AND OF_DSA.DescId           = zc_ObjectFloat_Unit_HT_SUN_All()
             LEFT JOIN ObjectFloat   AS OF_SN            ON OF_SN.ObjectId            = OB.ObjectId AND OF_SN.DescId            = zc_ObjectFloat_Unit_LimitSUN_N()
             LEFT JOIN ObjectString  AS OS_LL            ON OS_LL.ObjectId            = OB.ObjectId AND OS_LL.DescId            = zc_ObjectString_Unit_SUN_v1_Lock()
             LEFT JOIN ObjectBoolean AS OB_OnlyTimingSUN ON OB_OnlyTimingSUN.ObjectId = OB.ObjectId AND OB_OnlyTimingSUN.DescId = zc_ObjectBoolean_Unit_SUN_OnlyTiming()
             LEFT JOIN ObjectBoolean AS OB_ColdOutSUN    ON OB_ColdOutSUN.ObjectId    = OB.ObjectId AND OB_ColdOutSUN.DescId    = zc_ObjectBoolean_Unit_ColdOutSUN()
             -- !!!������ ��� ����� ��������!!!
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Driver
                                  ON ObjectLink_Unit_Driver.ObjectId      = OB.ObjectId
                                 AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
             LEFT JOIN Object AS Object_Driver ON Object_Driver.Id = ObjectLink_Unit_Driver.ChildObjectId
        WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN()
          -- ���� ������ ���� ������ - �������� ���
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' AND vbisShoresSUN = FALSE OR
               OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 4 OR
               OS_ListDaySUN.ValueData ILIKE '%' || CASE WHEN vbDOW_curr - 1 = 0 THEN 7 ELSE vbDOW_curr - 1 END::TVarChar || '%' AND vbisShoresSUN = TRUE AND Object_Driver.ObjectCode = 3
        --  OR inUserId = 3 -- ����� - �������
              )
       ;
       
     ANALYSE _tmpUnit_SUN;  

raise notice 'Value 2: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM _tmpUnit_SUN);

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
                               
     WITH 
          tmpLayout AS (SELECT Movement.ID                        AS Id
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
                                , _tmpUnit_SUN.UnitId                AS UnitId
                                , tmpLayout.Amount                              AS Amount
                                , tmpLayout.isNotMoveRemainder6                 AS isNotMoveRemainder6
                                , tmpLayout.ID                                  AS MovementLayoutId
                           FROM _tmpUnit_SUN
                                
                                LEFT JOIN Object AS Object_Unit
                                                 ON Object_Unit.Id        = _tmpUnit_SUN.UnitId
                                                AND Object_Unit.DescId    = zc_Object_Unit()
                                 
                                INNER JOIN tmpLayout ON 1 = 1 

                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = _tmpUnit_SUN.UnitId

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                           WHERE (tmpLayoutUnit.UnitId = _tmpUnit_SUN.UnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                             AND (Object_Unit.ValueData NOT ILIKE '���. ����� %' OR tmpLayout.isPharmacyItem = True)
                           )
                                                              
     INSERT INTO  _tmpGoods_Layout (GoodsId, UnitId, Layout, isNotMoveRemainder6, MovementLayoutId) 
     SELECT tmpLayoutAll.GoodsId                 AS GoodsId
          , tmpLayoutAll.UnitId                  AS UnitId
          , MAX (tmpLayoutAll.Amount):: TFloat   AS Amount
          , SUM (CASE WHEN tmpLayoutAll.isNotMoveRemainder6 = TRUE THEN 1 ELSE 0 END) > 0   AS isNotMoveRemainder6
          , MAX (tmpLayoutAll.MovementLayoutId)  AS MovementLayoutId
      FROM tmpLayoutAll      
      GROUP BY tmpLayoutAll.GoodsId
             , tmpLayoutAll.UnitId;
             
     ANALYSE _tmpGoods_Layout;

raise notice 'Value 3: %', CLOCK_TIMESTAMP();

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

                
     -- ������� ������������
     vbDayIncome_max := (SELECT MAX (_tmpUnit_SUN.DayIncome)  FROM _tmpUnit_SUN);

     -- ������� ������������
     vbDaySendSUN_max:= (SELECT MAX (_tmpUnit_SUN.DaySendSUN) FROM _tmpUnit_SUN);
     -- ������� ������������
     vbDaySendSUNAll_max:= (SELECT MAX (_tmpUnit_SUN.DaySendSUNAll) FROM _tmpUnit_SUN);

     IF inStep = 1
     THEN
         -- ������ ��� ���������
         INSERT INTO _tmpGoods_SUN (GoodsId, KoeffSUN)
            SELECT OF_KoeffSUN.ObjectId  AS GoodsId
                 , OF_KoeffSUN.ValueData AS KoeffSUN
            FROM ObjectFloat AS OF_KoeffSUN
            WHERE OF_KoeffSUN.DescId    = zc_ObjectFloat_Goods_KoeffSUN_v1()
              AND OF_KoeffSUN.ValueData > 0
           ;
         
         ANALYSE _tmpGoods_SUN;

raise notice 'Value 6: %', CLOCK_TIMESTAMP();

         
         -- "���� ������ � ���"... ���� � ����� �� ����� ��� ������������ ����� X, �� � ������������ ������� ������ ������������ ����� Y � ��� �� ����������
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

raise notice 'Value 7: %', CLOCK_TIMESTAMP();

     END IF;

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

raise notice 'Value 8: %', CLOCK_TIMESTAMP();

     -- ��������� ����� �����������
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
             -- � ���� ������ ������� ����
             LEFT JOIN _tmpUnit_SUN AS _tmpUnit_SUN_From ON ObjectLink_From.ChildObjectId IS NULL

             LEFT JOIN ObjectLink AS ObjectLink_To
                                  ON ObjectLink_To.ObjectId = Object.Id
                                 AND ObjectLink_To.DescId   = zc_ObjectLink_SunExclusion_To()
             -- � ���� ������ ������� ����
             LEFT JOIN _tmpUnit_SUN AS _tmpUnit_SUN_To ON ObjectLink_To.ChildObjectId IS NULL

        WHERE Object.DescId   = zc_Object_SunExclusion()
          AND Object.isErased = FALSE
           ;
           
     ANALYSE _tmpUnit_SunExclusion;

raise notice 'Value 9: %', CLOCK_TIMESTAMP();

     IF inStep = 1
     THEN
         -- ������-1 �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
         WITH -- SUN - �� 30 ����
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
         -- ���������-1
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
                
         ANALYSE _tmpUnit_SUN_balance;

raise notice 'Value 10: %', CLOCK_TIMESTAMP();

         -- ������-2 ������������ �� ������� - ������ �� ������
         WITH -- SUN - �� 30 ����
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
                                        -- ������ ����. ������� ����������� ����� out = N * vbSumm_balance_partion
                                      , CASE WHEN tmpSumm_out.Summ_out > 0 THEN CEIL (tmpSumm_out.Summ_out / vbSumm_balance_partion) * vbSumm_balance_partion ELSE 1 * vbSumm_balance_partion END AS Summ_out_calc
                                        -- ������ ����. ������� ����������� ����� in  = N * vbSumm_balance_partion
                                      , CASE WHEN tmpSumm_in.Summ_in   > 0 THEN CEIL (tmpSumm_in.Summ_in   / vbSumm_balance_partion) * vbSumm_balance_partion ELSE 1 * vbSumm_balance_partion END AS Summ_in_calc
                                 FROM _tmpUnit_SUN
                                      LEFT JOIN (SELECT tmpSUN.UnitId_from, SUM (tmpSUN.Summ_out) AS Summ_out FROM tmpSUN GROUP BY tmpSUN.UnitId_from
                                                ) AS tmpSumm_out ON tmpSumm_out.UnitId_from = _tmpUnit_SUN.UnitId
                                      LEFT JOIN (SELECT tmpSUN.UnitId_to, SUM (tmpSUN.Summ_in) AS Summ_in FROM tmpSUN GROUP BY tmpSUN.UnitId_to
                                                ) AS tmpSumm_in ON tmpSumm_in.UnitId_to = _tmpUnit_SUN.UnitId
                                )
                     -- ����� � ����� ����� ����� ������������
                   , tmpData AS (SELECT tmpData_all.UnitId
                                      , tmpData_all.Summ_out
                                      , tmpData_all.Summ_in
                                      , CASE -- ���� �����, ��������� �� ��������� �������
                                             WHEN tmpData_all.Summ_out_calc = tmpData_all.Summ_in_calc
                                              AND tmpData_all.Summ_out_calc > 0
                                              AND tmpData_all.Summ_in_calc  > 0
                                                  THEN (1 + CEIL (tmpData_all.Summ_out / vbSumm_balance_partion)) * vbSumm_balance_partion
                                             -- ���� ������������ Summ_out_calc
                                             WHEN tmpData_all.Summ_out_calc >=  tmpData_all.Summ_in_calc
                                                  THEN tmpData_all.Summ_out_calc
                                             -- ���� ������������ Summ_in_calc
                                             WHEN tmpData_all.Summ_out_calc <=  tmpData_all.Summ_in_calc
                                                  THEN tmpData_all.Summ_in_calc
                                        END AS Summ_calc

                                      , (tmpData_all.Summ_out_calc - tmpData_all.Summ_in_calc)  / vbSumm_balance_partion AS koeff_out
                                      , (tmpData_all.Summ_in_calc  - tmpData_all.Summ_out_calc) / vbSumm_balance_partion AS koeff_in
                                 FROM tmpData_all
                                )
         -- ���������-2
         INSERT INTO _tmpUnit_SUN_balance_partion (UnitId, Summ_out, Summ_in, Summ_out_calc, Summ_in_calc)
            SELECT tmpData.UnitId
                 , tmpData.Summ_out
                 , tmpData.Summ_in
                   -- ����� ������������ �������
                 , CASE WHEN koeff_out <= 2 THEN tmpData.Summ_calc - tmpData.Summ_out ELSE 0 END AS Summ_out_calc
                   -- ����� ������������ �������
                 , CASE WHEN koeff_in <= 2  THEN tmpData.Summ_calc - tmpData.Summ_in  ELSE 0 END AS Summ_in_calc
            FROM tmpData
            WHERE 1=0
           ;

     END IF;
     
     ANALYSE _tmpUnit_SUN_balance_partion;

raise notice 'Value 11: %', CLOCK_TIMESTAMP();

       -- ������� ��� ����������
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpSalesGoods'))
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
               
     ANALYSE tmpSalesGoods;      
                           
raise notice 'Value 11_1: % %', CLOCK_TIMESTAMP(), (SELECT count(*) FROM  tmpSalesGoods);

     
     -- ������ - UnComplete - �� ��������� +/-7 ���� ��� Date_Branch
     CREATE TEMP TABLE tmpMI_Income ON COMMIT DROP AS
                          (SELECT MovementLinkObject_To.ObjectId AS UnitId
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
                                INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                           WHERE Movement.DescId   = zc_Movement_Income()
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           GROUP BY MovementLinkObject_To.ObjectId, MovementItem.ObjectId
                           HAVING SUM (MovementItem.Amount) <> 0
                          );
                          
     ANALYSE tmpMI_Income;         

raise notice 'Value 11_1: %', CLOCK_TIMESTAMP();

       -- ����������� - ������ - UnComplete - �� ��������� +/-30 ����
     CREATE TEMP TABLE tmpMI_Send_in ON COMMIT DROP AS
                           (SELECT MovementLinkObject_To.ObjectId AS UnitId_to
                              , MovementItem.ObjectId          AS GoodsId
                              , SUM (MovementItem.Amount)      AS Amount
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                 -- !!!������ ��� ����� �����!!!
                                 INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
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
                           );
                          
     ANALYSE tmpMI_Send_in; 
     
raise notice 'Value 11_2: %', CLOCK_TIMESTAMP();

      -- ����������� - ������ - UnComplete - �� ��������� +/-14 ����
     CREATE TEMP TABLE tmpMI_Send_out ON COMMIT DROP AS
                        (SELECT MovementLinkObject_From.ObjectId AS UnitId_from
                              , MovementItem.ObjectId            AS GoodsId
                              , SUM (MovementItem.Amount)        AS Amount
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                 -- !!!������ ��� ����� �����!!!
                                 INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_From.ObjectId
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
                           );
                          
     ANALYSE tmpMI_Send_out; 
                           
raise notice 'Value 11_3: %', CLOCK_TIMESTAMP();

          -- ������ - UnComplete - !���! Deferred
     CREATE TEMP TABLE tmpMI_OrderExternal ON COMMIT DROP AS
                                 (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
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
                                       INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_Unit.ObjectId
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                              AND MovementItem.DescId     = zc_MI_Master()
                                                              AND MovementItem.isErased   = FALSE

                                  WHERE Movement.DescId   = zc_Movement_OrderExternal()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                  GROUP BY MovementLinkObject_Unit.ObjectId, MovementItem.ObjectId
                                  HAVING SUM (MovementItem.Amount) <> 0
                                 );
                          
     ANALYSE tmpMI_OrderExternal; 
                           
raise notice 'Value 11_4: %', CLOCK_TIMESTAMP();

          -- ���������� ���� + �� ����������� � CommentError
     CREATE TEMP TABLE tmpMI_Reserve ON COMMIT DROP AS (
        WITH
          tmpMovementCheck AS (SELECT Movement.Id AS MovementId, MovementLinkObject_Unit.ObjectId AS UnitId
                               FROM MovementBoolean AS MovementBoolean_Deferred
                                    INNER JOIN Movement ON Movement.Id       = MovementBoolean_Deferred.MovementId
                                                       AND Movement.DescId   = zc_Movement_Check()
                                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    -- !!!������ ��� ����� �����!!!
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
                                    -- !!!������ ��� ����� �����!!!
                                    INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_Unit.ObjectId
                               WHERE MovementString_CommentError.DescId    = zc_MovementString_CommentError()
                                 AND MovementString_CommentError.ValueData <> ''
                              )
                          
                            SELECT tmpMovementCheck.UnitId
                                 , MovementItem.ObjectId     AS GoodsId
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM tmpMovementCheck
                                 INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementCheck.MovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                            GROUP BY tmpMovementCheck.UnitId, MovementItem.ObjectId
                           );
                           
     ANALYSE tmpMI_Reserve; 
     
     
raise notice 'Value 11_5: %', CLOCK_TIMESTAMP();

       -- �������
     CREATE TEMP TABLE tmpRemains ON COMMIT DROP AS
                        (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (Container.Amount, 0)) AS Amount
                         FROM Container
                              -- !!!������ ��� ����� �����!!!
                              INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = Container.WhereObjectId
                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        );
                          
     ANALYSE tmpRemains; 
                           
raise notice 'Value 11_6: %', CLOCK_TIMESTAMP();

          -- ����
     CREATE TEMP TABLE tmpPrice ON COMMIT DROP AS
     WITH SalesGoods AS (SELECT DISTINCT tmpSalesGoods.GoodsId FROM tmpSalesGoods)
     
                      (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , ROUND (Price_Value.ValueData, 2)  AS Price
                            , MCS_Value.ValueData               AS MCSValue
                            , CASE WHEN Price_MCSValueMin.ValueData IS NOT NULL
                                   THEN CASE WHEN COALESCE (Price_MCSValueMin.ValueData, 0) < COALESCE (MCS_Value.ValueData, 0) THEN COALESCE (Price_MCSValueMin.ValueData, 0) ELSE MCS_Value.ValueData END
                                   ELSE 0
                              END AS MCSValue_min
                            , COALESCE (MCS_isClose.ValueData, FALSE)                 AS isCloseMCS
                            , COALESCE (ObjectBoolean_Goods_isClose.ValueData, FALSE) AS isClose
                       FROM ObjectLink AS OL_Price_Unit
                            -- !!!������ ��� ����� �����!!!
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
                            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isClose
                                                    ON ObjectBoolean_Goods_isClose.ObjectId  =  OL_Price_Goods.ChildObjectId
                                                   AND ObjectBoolean_Goods_isClose.DescId    = zc_ObjectBoolean_Goods_Close()
                            LEFT JOIN SalesGoods ON SalesGoods.GoodsId = OL_Price_Goods.ChildObjectId
                                                   
                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         -- ������ "���� ���"
                         AND (MCS_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_ClosePL = FALSE OR COALESCE (SalesGoods.GoodsId, 0) > 0)
                      );
                          
     ANALYSE tmpPrice; 
                           
raise notice 'Value 11_7: %', CLOCK_TIMESTAMP();
                        
     -- 1. ��� �������, ��� => �������� ���-�� ����������
     -- CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     -- CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     --
     WITH 
          -- ������ �� ������. �������
          tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjectFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!������ ��� ����� �����!!!
                                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

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
                                   , COALESCE (tmpGoodsCategory.Value, 0.0) > COALESCE (tmpPrice.MCSValue, 0.0) AS isGoodsCategory
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

     -- 1.1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains_all (UnitId, GoodsId, Price, MCS, isGoodsCategory, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve, isCloseMCS)
     WITH SalesGoods AS (SELECT DISTINCT tmpSalesGoods.GoodsId FROM tmpSalesGoods)

        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             , tmpObject_Price.isGoodsCategory
             , CASE -- ���� ���_��� = 0 ��� ��� <= ���_���
                    WHEN COALESCE (tmpObject_Price.MCSValue_min, 0) = 0 OR (COALESCE (tmpRemains.Amount, 0) <= COALESCE (tmpObject_Price.MCSValue_min, 0))
                         THEN CASE -- ��� ������ ���
                                   WHEN tmpObject_Price.MCSValue + COALESCE(_tmpGoods_Layout.Layout, 0)  >= 0.1 AND tmpObject_Price.MCSValue + COALESCE(_tmpGoods_Layout.Layout, 0) < 10
                                   -- � 1 >= ��� - "�������"
                                    AND 1 >= ROUND ((tmpObject_Price.MCSValue + COALESCE(_tmpGoods_Layout.Layout, 0)
                                                     -- ����� (������� - "��������" + "�������" + "������" + "������")
                                                   - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                              THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                          ELSE 0
                                                     END
                                                    )
                                                    -- ����� �� ���������
                                                  / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                                   ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                        THEN -- ��������� �����
                                             CEIL ((tmpObject_Price.MCSValue + COALESCE(_tmpGoods_Layout.Layout, 0)
                                                    -- ����� (������� - "��������" + "�������" + "������" + "������")
                                                  - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                             THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                         ELSE 0
                                                    END
                                                   )
                                                   -- ����� �� ���������
                                                 / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                                  ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)

                                   -- ��� ������ ���
                                   WHEN tmpObject_Price.MCSValue + COALESCE(_tmpGoods_Layout.Layout, 0) >= 10
                                   -- � 1 >= ��� - "�������"
                                    AND 1 >= CEIL ((tmpObject_Price.MCSValue + COALESCE(_tmpGoods_Layout.Layout, 0)
                                                    -- ����� (������� - "��������" + "�������" + "������" + "������")
                                                  - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                             THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                         ELSE 0
                                                    END
                                                   )
                                                   -- ����� �� ���������
                                                 / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                                  ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                        THEN -- ���������
                                             ROUND ((tmpObject_Price.MCSValue + COALESCE(_tmpGoods_Layout.Layout, 0)
                                                     -- ����� (������� - "��������" + "�������" + "������" + "������")
                                                   - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                              THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                          ELSE 0
                                                     END
                                                    )
                                                    -- ����� �� ���������
                                                  / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                                   ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)

                                   ELSE -- ��������� �����
                                        FLOOR ((tmpObject_Price.MCSValue + COALESCE(_tmpGoods_Layout.Layout, 0)
                                                -- ����� (������� - "��������" + "�������" + "������" + "������")
                                              - CASE WHEN 0 < COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                         THEN COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) + COALESCE (tmpMI_Send_in.Amount, 0) + COALESCE (tmpMI_Income.Amount, 0) + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                                     ELSE 0
                                                END
                                               )
                                                -- ����� �� ���������
                                             / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                                              ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                              END
                    ELSE 0
               END AS AmountResult
               -- �������
             , COALESCE (tmpRemains.Amount, 0)          AS AmountRemains
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
             , COALESCE (tmpObject_Price.isCloseMCS, FALSE)  AS isCloseMCS
        FROM tmpObject_Price
             -- �������� �� ��� - ������ ��������
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_out
                                     ON OB_Unit_SUN_out.ObjectId  = tmpObject_Price.UnitId
                                    AND OB_Unit_SUN_out.DescId    = zc_ObjectBoolean_Unit_SUN_out()
                                    AND OB_Unit_SUN_out.ValueData = TRUE
             -- ���������� �� ����������� ����������
             LEFT JOIN _tmpGoods_TP_exception AS tmpGoods_TP_exception
                                              ON tmpGoods_TP_exception.UnitId  = tmpObject_Price.UnitId
                                             AND tmpGoods_TP_exception.GoodsId = tmpObject_Price.GoodsId

             LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = tmpObject_Price.UnitId
                                       AND _tmpGoods_Layout.GoodsId = tmpObject_Price.GoodsId

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

             -- ������ ��� ���������
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId  = tmpObject_Price.GoodsId

             -- ��������� !!��������!!
             -- 25.05.20 -- �������� �������� - 13.05.20
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isClose
                                     ON ObjectBoolean_Goods_isClose.ObjectId  = tmpObject_Price.GoodsId
                                    AND ObjectBoolean_Goods_isClose.DescId    = zc_ObjectBoolean_Goods_Close()
                                    AND ObjectBoolean_Goods_isClose.ValueData = TRUE
             -- !!!
             LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = tmpObject_Price.UnitId

             -- ��������� !!���������!!
             INNER JOIN Object AS Object_Goods ON Object_Goods.Id        = tmpObject_Price.GoodsId
                                              AND Object_Goods.ValueData NOT ILIKE '���%'

             -- ���� ����� ����� ������
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = tmpObject_Price.GoodsId
                       
             LEFT JOIN SalesGoods ON SalesGoods.GoodsId = tmpObject_Price.GoodsId
                       
        WHERE OB_Unit_SUN_out.ObjectId IS NULL
          -- ������ "������ ���"
          AND (ObjectBoolean_Goods_isClose.ObjectId IS NULL OR _tmpUnit_SUN.isLock_CloseGd = FALSE OR 
               COALESCE (SalesGoods.GoodsId, 0) > 0 OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0)
          -- ���������� �� ����������� ����������
          AND COALESCE (tmpGoods_TP_exception.GoodsId, 0) = 0

        -- !!!������ � ����� ���!!!
        -- WHERE tmpObject_Price.MCSValue >= 0.5
        -- !!!��������, ����� ���!!!
        /*WHERE CASE -- ���� ���_��� = 0 ��� ��� <= ���_���
                   WHEN COALESCE (tmpObject_Price.MCSValue_min, 0) = 0 OR (COALESCE (tmpRemains.Amount, 0) <= COALESCE (tmpObject_Price.MCSValue_min, 0))
                        THEN CASE -- ��� ������ ���
                                  WHEN tmpObject_Price.MCSValue >= 0.1 AND tmpObject_Price.MCSValue < 10
                                  -- � 1 >= ��� - ������� - "��������" - "�������" - "������" - "������"
                                   AND 1 >= ROUND (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                       THEN -- ��������� �����
                                            CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                  -- ��� ������ ���
                                  WHEN tmpObject_Price.MCSValue >= 10
                                  -- � 1 >= ��� - ������� - "��������" - "�������" - "������" - "������"
                                   AND 1 >= CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                       THEN -- ���������
                                            ROUND  (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                  ELSE -- ��������� �����
                                       FLOOR (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send_in.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                             END
                   ELSE 0
              END > 0*/
       ;
       
     ANALYSE _tmpRemains_all;

raise notice 'Value 12: %', CLOCK_TIMESTAMP();

     -- 1.1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, MCS, isGoodsCategory, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT _tmpRemains_all.UnitId, _tmpRemains_all.GoodsId, _tmpRemains_all.Price, _tmpRemains_all.MCS, _tmpRemains_all.isGoodsCategory, _tmpRemains_all.AmountResult, _tmpRemains_all.AmountRemains, _tmpRemains_all.AmountIncome, _tmpRemains_all.AmountSend_in, _tmpRemains_all.AmountSend_out, _tmpRemains_all.AmountOrderExternal, _tmpRemains_all.AmountReserve
        FROM _tmpRemains_all
             -- ������ �� ������� ����������� - ���� �� �������������, ����� ������ �����������
             LEFT JOIN _tmpUnit_SUN_balance ON _tmpUnit_SUN_balance.UnitId = _tmpRemains_all.UnitId
             LEFT JOIN _tmpUnit_SUN         ON _tmpUnit_SUN.UnitId         = _tmpRemains_all.UnitId
             -- ��������
             LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = _tmpRemains_all.UnitId
                                       AND _tmpGoods_Layout.GoodsId = _tmpRemains_all.GoodsId

             -- ���� ����� ����� ������
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_all.GoodsId

         WHERE (-- !!!������ � ����� ��� + ��������!!!
                _tmpRemains_all.MCS + COALESCE(_tmpGoods_Layout.Layout, 0) >= 1.0
                -- !!!�������� ������!!!
              OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
               )
           AND (_tmpUnit_SUN.KoeffInSUN = 0 OR _tmpUnit_SUN_balance.KoeffInSUN < _tmpUnit_SUN.KoeffInSUN)
       ;
       
     ANALYSE _tmpRemains_all;

raise notice 'Value 13: % % % % %', CLOCK_TIMESTAMP(),
                                  (SELECT COUNT(*) FROM _tmpRemains_all), 
                                  (SELECT COUNT(*) FROM _tmpRemains_all WHERE _tmpRemains_all.GoodsId = 52945 AND _tmpRemains_all.UnitId = 375626),
                                  (SELECT COUNT(*) FROM _tmpRemains), 
                                  (SELECT COUNT(*) FROM _tmpRemains WHERE _tmpRemains.GoodsId = 52945 AND _tmpRemains.UnitId = 375626);


/*     raise notice '������. % % %',
                     (SELECT count(*) FROM _tmpRemains),
                     (SELECT count(*) FROM _tmpRemains_all WHERE _tmpRemains_all.GoodsId in (SELECT GoodsId_PairSun FROM _tmpGoods_SUN_PairSun)),
                     (SELECT count(*) FROM _tmpRemains_all WHERE _tmpRemains_all.UnitId = 13311246 AND _tmpRemains_all.GoodsId = 42460);
*/                     
     -- 2. ��� ���������� ������ - 1 �����
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
                                   AND _tmpRemains.AmountResult <= 0 -- !!!����� ������ ����� ��� ����������!!!
             INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MIContainer.WhereObjectId_analyzer
             LEFT JOIN MovementBoolean AS MB_NotMCS
                                       ON MB_NotMCS.MovementId = MIContainer.MovementId
                                      AND MB_NotMCS.DescId     = zc_MovementBoolean_NotMCS()
                                      AND MB_NotMCS.ValueData  = TRUE
             LEFT JOIN MovementBoolean AS MB_CorrectMarketing
                                       ON MB_CorrectMarketing.MovementId = MIContainer.MovementId
                                      AND MB_CorrectMarketing.DescId     = zc_MovementBoolean_CorrectMarketing()
                                      AND MB_CorrectMarketing.ValueData  = TRUE
        WHERE
          -- !!!�� ��������� ���� ����� "�� ��� ���"
              (MB_NotMCS.MovementId IS NULL OR _tmpUnit_SUN.isLock_CheckMSC = FALSE)        
          -- !!!�� ��������� ���� ����� "������������� ����� ���������� � ��"
          AND (MB_CorrectMarketing.MovementId IS NULL OR _tmpUnit_SUN.isLock_CheckMa = FALSE)        
        GROUP BY MIContainer.ObjectId_analyzer
               , MIContainer.WhereObjectId_analyzer
        HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
       ;
       
      ANALYSE _tmpSale;

raise notice 'Value 14: %', CLOCK_TIMESTAMP();


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
     INSERT INTO _tmpGoods_Sun_exception (UnitId, GoodsId, Amount)
        SELECT tmpSUN.UnitId, tmpSUN.GoodsId, tmpSUN.Amount
        FROM tmpSUN;
        
     ANALYSE _tmpGoods_Sun_exception;

raise notice 'Value 15: %', CLOCK_TIMESTAMP();


     -- �������� ��� ���������� �� ������
     SELECT Date_6, Date_3, Date_1, Date_0
     INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
     FROM lpSelect_PartionDateKind_SetDate ();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpContainer'))
     THEN
       DROP TABLE tmpContainer;
     END IF;

     -- ������� - �����������
     CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS
                             (SELECT Container.DescId           AS ContainerDescId
                                   , Container.Id               AS ContainerId
                                   , Container.WhereObjectId    AS UnitId
                                   , Container.ObjectId         AS GoodsId
                                   , Container.Amount           AS Amount
                              FROM -- !!!������ ��� ����� �����!!!
                                   _tmpUnit_SUN
                                   INNER JOIN Container ON Container.WhereObjectId = _tmpUnit_SUN.UnitId
                                                       AND Container.Amount        <> 0
                                                       AND Container.DescId        = zc_Container_Count()
                                   -- ��������� ������ "��� ������" ��� ���-1
                                   LEFT JOIN ObjectBoolean AS OB_SUN_NotSold
                                                           ON OB_SUN_NotSold.ObjectId  = Container.WhereObjectId
                                                          AND OB_SUN_NotSold.DescId    = zc_ObjectBoolean_Unit_SUN_NotSold()
                                                          AND OB_SUN_NotSold.ValueData = TRUE
                              -- !!!
                              WHERE OB_SUN_NotSold.ObjectId IS NULL
                             );
                             
     ANALYSE tmpContainer;

raise notice 'Value 15_1: %', CLOCK_TIMESTAMP();

     -- Income - �� X ���� - ���� ���������, 100���� ��� ������ ������� ��� �� �����
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpIncome'))
     THEN
       DROP TABLE tmpIncome;
     END IF;

     CREATE TEMP TABLE tmpIncome ON COMMIT DROP AS
                               (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
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

                                     -- ������� �������� �������������

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
                               );
                               
     ANALYSE tmpIncome;

raise notice 'Value 15_2: %', CLOCK_TIMESTAMP();

             -- ��� SUN-1 - ����� - zc_Movement_Send �� X ���� - ���� ���������, ������� ��� �� �����
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpSUN_Send'))
     THEN
       DROP TABLE tmpSUN_Send;
     END IF;

     CREATE TEMP TABLE tmpSUN_Send ON COMMIT DROP AS
                            (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                                  , MovementItem.ObjectId            AS GoodsId
                             FROM Movement
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                                               AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                  -- !!!������ ��� ����� �����!!!
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
                            );
                               
     ANALYSE tmpSUN_Send;

raise notice 'Value 15_3: %', CLOCK_TIMESTAMP();

             -- ��� SUN- ���� - ����� - zc_Movement_Send �� X ���� - ���� ���������, ������� ��� �� �����
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpSUN_SendAll'))
     THEN
       DROP TABLE tmpSUN_SendAll;
     END IF;

     CREATE TEMP TABLE tmpSUN_SendAll ON COMMIT DROP AS
                               (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
                                     , MovementItem.ObjectId            AS GoodsId
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                     -- !!!������ ��� ����� �����!!!
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
                            );


     ANALYSE tmpSUN_SendAll;

raise notice 'Value 15_4: %', CLOCK_TIMESTAMP();

           -- ������� �� SUN-1 - �����
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpRes_SUN_1'))
     THEN
       DROP TABLE tmpRes_SUN_1;
     END IF;

     CREATE TEMP TABLE tmpRes_SUN_1 ON COMMIT DROP AS
                           (SELECT Container.DescId                                           AS ContainerDescId
                                 , Container.WhereObjectId                                    AS UnitId
                                 , Container.ParentId                                         AS ContainerId_Parent
                                 , Container.Id                                               AS ContainerId
                                 , Container.ObjectId                                         AS GoodsId
                                 , Container.Amount                                           AS Amount
                            FROM Container
                                 -- !!!������ ��� ����� �����!!!
                                 INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = Container.WhereObjectId
                                 -- !!!SUN - �� X ���� - ���� ���������, ������� ��� �� �����!!!
                                 LEFT JOIN tmpSUN_Send ON tmpSUN_Send.UnitId_to = Container.WhereObjectId
                                                      AND tmpSUN_Send.GoodsId   = Container.ObjectId
                                 -- !!!SUN ���� - �� X ���� - ���� ���������, ������� ��� �� �����!!!
                                 LEFT JOIN tmpSUN_SendAll ON tmpSUN_SendAll.UnitId_to = Container.WhereObjectId
                                                         AND tmpSUN_SendAll.GoodsId   = Container.ObjectId

                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.Amount <> 0
                              -- !!!
                              AND tmpSUN_Send.GoodsId IS NULL
                              AND tmpSUN_SendAll.GoodsId IS NULL
                           );

     ANALYSE tmpRes_SUN_1;

raise notice 'Value 15_5: %', CLOCK_TIMESTAMP();

     -- IncomeSUN - �� X ���� - ���� ���������, SUN ������� ��� �� �����
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpIncomeSUN'))
     THEN
       DROP TABLE tmpIncomeSUN;
     END IF;

     CREATE TEMP TABLE tmpIncomeSUN ON COMMIT DROP AS
                               (SELECT MovementLinkObject_To.ObjectId   AS UnitId_to
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
                                     -- !!!������ ��� �����!!!
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
                               );

     ANALYSE tmpIncomeSUN;
          
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
     

raise notice 'Value 15_6: %', CLOCK_TIMESTAMP();

     -- 3.1. ��� ������� �����������, ���� + ...
     INSERT INTO _tmpRemains_Partion_all (ContainerDescId, UnitId, ContainerId_Parent, ContainerId, GoodsId, Amount, PartionDateKindId, ExpirationDate, Amount_sun, Amount_notSold, Amount_6Month, isNotSold100)
        WITH -- ������ ��� NotSold
             -- ��� ����� ���������� NotSold - ��� ������ 100��.
             tmpNotSold_all_all AS (SELECT tmpContainer.ContainerDescId
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

             -- NotSold - ��� ������ 100��. + ������
           , tmpNotSold_all AS (-- NotSold
                                SELECT tmpNotSold_all_all.ContainerDescId
                                     , tmpNotSold_all_all.ContainerId
                                     , tmpNotSold_all_all.UnitID
                                     , tmpNotSold_all_all.GoodsID
                                     , tmpNotSold_all_all.Amount
                                FROM tmpNotSold_all_all
                               UNION ALL
                                -- !!!�������� ������!!!
                                SELECT tmpContainer.ContainerDescId
                                     , tmpContainer.ContainerId
                                     , tmpContainer.UnitID
                                     , tmpContainer.GoodsID
                                     , tmpContainer.Amount
                                FROM (-- ������ ��� NotSold - ��� ����
                                      SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun, tmpNotSold_all_all.UnitID
                                      FROM tmpNotSold_all_all
                                           JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = tmpNotSold_all_all.GoodsId
                                     ) AS _tmpGoods_SUN_PairSun_find
                                     INNER JOIN tmpContainer ON tmpContainer.GoodsId = _tmpGoods_SUN_PairSun_find.GoodsId_PairSun
                                                            AND tmpContainer.UnitID  = _tmpGoods_SUN_PairSun_find.UnitID
                                     -- ���� ������ ��� � NotSold
                                     LEFT JOIN tmpNotSold_all_all ON tmpNotSold_all_all.GoodsId = _tmpGoods_SUN_PairSun_find.GoodsId_PairSun
                                                                 AND tmpNotSold_all_all.UnitID  = _tmpGoods_SUN_PairSun_find.UnitID
                                --!!!
                                WHERE tmpNotSold_all_all.GoodsId IS NULL
                               )
     -- ��� NotSold - ������� "������" ����
   , tmpNotSold_PartionDate AS (SELECT tmpNotSold.ContainerId
                                     , tmpNotSold.UnitID
                                     , tmpNotSold.GoodsID
                                       -- ������� "������" ����
                                     , SUM (Container.Amount) AS Amount
                                FROM tmpNotSold_all AS tmpNotSold
                                     INNER JOIN Container ON Container.ParentId = tmpNotSold.ContainerId
                                                         AND Container.DescId   = zc_Container_CountPartionDate()
                                                         AND Container.Amount   > 0
                                     LEFT JOIN _tmpRemains_all AS _tmpRemains 
                                                               ON _tmpRemains.UnitID = tmpNotSold.UnitID
                                                              AND _tmpRemains.GoodsID =  tmpNotSold.GoodsID
                                     LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                                   ON CLO_PartionGoods.ContainerId = Container.Id
                                                                  AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                     LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                          ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                         AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                                WHERE -- !!!�������� ������ ��� ���������
                                      ObjectDate_PartionGoods_Value.ValueData <= CURRENT_DATE + 
                                        (CASE WHEN COALESCE(_tmpRemains.isGoodsCategory, FALSE) = True THEN '200' ELSE '90' END||' DAY')::INTERVAL  --vbDate_3
                                      -- !!!�������� ������ ��� ���������
                                GROUP BY tmpNotSold.ContainerId
                                       , tmpNotSold.UnitID
                                       , tmpNotSold.GoodsID
                               )
     -- ��� NotSold - ������� ���� ����� 6 �������
   , tmpNotSold_PartionDate6Month AS (SELECT tmpNotSold.ContainerId
                                           , tmpNotSold.UnitID
                                           , tmpNotSold.GoodsID
                                             -- ������� ���� ����� 6 �������
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
                                      WHERE -- !!!�������� ������ ��� ���������
                                            ObjectDate_PartionGoods_Value.ValueData <= CURRENT_DATE + INTERVAL '6 MONTH'
                                            -- !!!�������� ������ ��� ���������
                                      GROUP BY tmpNotSold.ContainerId
                                             , tmpNotSold.UnitID
                                             , tmpNotSold.GoodsID
                                     )
            -- ��� NotSold - ������ "������" ����
          , tmpNotSold_list AS (SELECT DISTINCT
                                       tmpNotSold_all.UnitID
                                     , tmpNotSold_all.GoodsID
                                FROM tmpNotSold_all
                               )
             -- ��� ��� �������� ��� NotSold
           , tmpNotSold AS (SELECT tmpNotSold_all.ContainerDescId
                                 , tmpNotSold_all.ContainerId
                                 , tmpNotSold_all.UnitID
                                 , tmpNotSold_all.GoodsID
                                   -- ������� "�������" ������
                                 , tmpNotSold_all.Amount - COALESCE (tmpNotSold_PartionDate.Amount, 0) AS Amount
                                 , COALESCE (tmpNotSold_PartionDate6Month.Amount, 0) - COALESCE (tmpNotSold_PartionDate.Amount, 0) AS Amount_6Month
                            FROM tmpNotSold_all
                                 -- "������" ����
                                 LEFT JOIN tmpNotSold_PartionDate ON tmpNotSold_PartionDate.ContainerId = tmpNotSold_all.ContainerId
                                 -- ������� ���� ����� 6 �������
                                 LEFT JOIN tmpNotSold_PartionDate6Month ON tmpNotSold_PartionDate6Month.ContainerId = tmpNotSold_all.ContainerId
                                 -- Income - �� X ���� - ���� ���������, 100���� ��� ������ ������� ��� �� �����
                                 LEFT JOIN tmpIncome ON tmpIncome.UnitId_to = tmpNotSold_all.UnitID
                                                    AND tmpIncome.GoodsID   = tmpNotSold_all.GoodsID
                                 -- ��������� ����� �� ���, ���� � ���� ������� ������ ��� N
                                 LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitID = tmpNotSold_all.UnitID

                                 -- ���� ����� ����� ������
                                 LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                                           ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = tmpNotSold_all.GoodsID

                            WHERE tmpNotSold_all.Amount - COALESCE (tmpNotSold_PartionDate.Amount, 0) > 0
                              -- !!!
                              AND tmpIncome.GoodsID IS NULL

                              AND (-- ������� ������ ��� N
                                   COALESCE (_tmpUnit_SUN.Limit_N, 0) < tmpNotSold_all.Amount
                                   -- ��� ��� ������ �����
                                OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
                                  )
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
                                        -- !!!�������� ������ ��� ���������
                                        AND ObjectDate.ValueData >  CURRENT_DATE + INTERVAL '90 DAY' -- vbDate_3
                                        AND ObjectDate.ValueData <= vbDate_6
                                        -- !!!�������� ������ ��� ���������
                                     )
         -- SUN-1 - C����
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
                                 INNER JOIN _tmpRemains_all AS _tmpRemains 
                                                            ON _tmpRemains.UnitID = Container.UnitID
                                                           AND _tmpRemains.GoodsID =  Container.GoodsID
                                 -- ���� ����� ����� ������
                                 LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                                           ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = Container.GoodsId
                            -- !!!���� ��� ������ �����, ����� ��� ������, ����� ������� "����" �������
                            WHERE _tmpGoods_SUN_PairSun_find.GoodsId_PairSun IS NULL
                              AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > CURRENT_DATE + 
                                  (CASE WHEN COALESCE(_tmpRemains.isGoodsCategory, FALSE) = True THEN '200' ELSE '90' END||' DAY')::INTERVAL  --vbDate_3

                           )
             -- SUN-1 - C���� + ������
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
                            -- !!!�������� ������!!!
                            SELECT tmpContainer.ContainerDescId
                                 , tmpContainer.UnitID
                                 , tmpContainer.ContainerId AS ContainerId_Parent
                                 , tmpContainer.ContainerId
                                 , tmpContainer.GoodsID
                                 , tmpContainer.Amount
                                 , 0                        AS PartionDateKindId
                                 , zc_DateEnd()             AS ExpirationDate
                            FROM (-- ������ ��� SUN-1 ��� ����
                                  SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun, tmpRes_SUN_all.UnitID
                                  FROM tmpRes_SUN_all
                                       JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = tmpRes_SUN_all.GoodsId
                                 ) AS _tmpGoods_SUN_PairSun_find
                                 INNER JOIN tmpContainer ON tmpContainer.GoodsId = _tmpGoods_SUN_PairSun_find.GoodsId_PairSun
                                                        AND tmpContainer.UnitID  = _tmpGoods_SUN_PairSun_find.UnitID
                                 -- ���� ������ ��� � SUN-1
                                 LEFT JOIN tmpRes_SUN_all ON tmpRes_SUN_all.GoodsId = _tmpGoods_SUN_PairSun_find.GoodsId_PairSun
                                                         AND tmpRes_SUN_all.UnitID  = _tmpGoods_SUN_PairSun_find.UnitID
                            --!!!
                            WHERE tmpRes_SUN_all.GoodsId IS NULL
                           )
                               
        -- ��������� - SUN-1 - C����
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
             , 0                 AS Amount_6Month
             , COALESCE(tmpNotSold_all_all.ContainerId, 0) <> 0 AS isNotSold100
        FROM tmpRes_SUN
             -- ���� �� ���� � tmpNotSold, ����� ������������ ������ ��� ���-�� �� tmpNotSold
             LEFT JOIN tmpNotSold ON tmpNotSold.UnitId = tmpRes_SUN.UnitId
                                 AND tmpNotSold.GoodsId = tmpRes_SUN.GoodsId
             -- IncomeSUN - �� X ���� - ���� ���������, SUN ������� ��� �� �����
             LEFT JOIN tmpIncomeSUN ON tmpIncomeSUN.UnitId_to = tmpRes_SUN.UnitId
                                   AND tmpIncomeSUN.GoodsId   = tmpRes_SUN.GoodsId

             -- ���������� �� ����������� ����������
             LEFT JOIN _tmpGoods_TP_exception AS tmpGoods_TP_exception
                                              ON tmpGoods_TP_exception.UnitId  = tmpRes_SUN.UnitId
                                             AND tmpGoods_TP_exception.GoodsId = tmpRes_SUN.GoodsId

             -- ������ �� ������� ������������ - ���� �� �������������, ����� ������ �����������
             LEFT JOIN _tmpUnit_SUN_balance ON _tmpUnit_SUN_balance.UnitId = tmpRes_SUN.UnitId
             LEFT JOIN _tmpUnit_SUN         ON _tmpUnit_SUN.UnitId         = tmpRes_SUN.UnitId

             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_in
                                     ON OB_Unit_SUN_in.ObjectId  = tmpRes_SUN.UnitId
                                    AND OB_Unit_SUN_in.DescId    = zc_ObjectBoolean_Unit_SUN_in()
                                    AND OB_Unit_SUN_in.ValueData = TRUE
                                    
             LEFT JOIN tmpNotSold_all_all ON tmpNotSold_all_all.ContainerId = tmpRes_SUN.ContainerId
                                    
                                    

        WHERE -- !!!
              tmpNotSold.GoodsId IS NULL
              -- !!!
          AND tmpIncomeSUN.GoodsId IS NULL
              -- !!!
          AND (_tmpUnit_SUN.KoeffOutSUN = 0 OR _tmpUnit_SUN_balance.KoeffOutSUN < _tmpUnit_SUN.KoeffOutSUN)
          AND OB_Unit_SUN_in.ObjectId IS NULL
          AND COALESCE (tmpGoods_TP_exception.GoodsId, 0) = 0

       UNION ALL

        -- ��������� - NotSold - ��� ������ 100��.
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
             , tmpNotSold.Amount_6Month AS Amount_6Month
             , COALESCE(tmpNotSold_all_all.ContainerId, 0) <> 0 AS isNotSold100
        FROM tmpNotSold
             -- !!!SUN - �� 30 ���� - ���� ���������, ������� ��� �� �����!!!
             LEFT JOIN tmpSUN_Send ON tmpSUN_Send.UnitId_to = tmpNotSold.UnitId
                                  AND tmpSUN_Send.GoodsId   = tmpNotSold.GoodsId
             -- !!!SUN ���� - �� 30 ���� - ���� ���������, ������� ��� �� �����!!!
             LEFT JOIN tmpSUN_SendAll ON tmpSUN_SendAll.UnitId_to = tmpNotSold.UnitId
                                     AND tmpSUN_SendAll.GoodsId   = tmpNotSold.GoodsId

             -- ���������� �� ����������� ����������
             LEFT JOIN _tmpGoods_TP_exception AS tmpGoods_TP_exception
                                              ON tmpGoods_TP_exception.UnitId  = tmpNotSold.UnitId
                                             AND tmpGoods_TP_exception.GoodsId = tmpNotSold.GoodsId

             -- ������ �� ������� ������������ - ���� �� �������������, ����� ������ �����������
             LEFT JOIN _tmpUnit_SUN_balance ON _tmpUnit_SUN_balance.UnitId = tmpNotSold.UnitId
             LEFT JOIN _tmpUnit_SUN         ON _tmpUnit_SUN.UnitId         = tmpNotSold.UnitId

             -- �������� �� ��� - ������ �����
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_in
                                     ON OB_Unit_SUN_in.ObjectId  = tmpNotSold.UnitId
                                    AND OB_Unit_SUN_in.DescId    = zc_ObjectBoolean_Unit_SUN_in()
                                    AND OB_Unit_SUN_in.ValueData = TRUE

             LEFT JOIN tmpNotSold_all_all ON tmpNotSold_all_all.ContainerId = tmpNotSold.ContainerId

             -- ���� �� ���� � ��������, ����� ������������ ������ �������� ���-��
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
       
     ANALYSE _tmpRemains_Partion_all;
          
raise notice 'Value 16: %', CLOCK_TIMESTAMP();

     -- 3.2. ������� � �����������, SUN-1 - ��� �������������
     WITH tmpRemains AS (SELECT _tmpRemains_Partion_all.ContainerDescId
                              , _tmpRemains_Partion_all.UnitId
                              , _tmpRemains_Partion_all.ContainerId_Parent
                              , _tmpRemains_Partion_all.GoodsId
                              , SUM (_tmpRemains_Partion_all.Amount) AS Amount
                              , _tmpRemains_Partion_all.PartionDateKindId
                              , _tmpRemains_Partion_all.ExpirationDate
                              , SUM (_tmpRemains_Partion_all.Amount_sun)     AS Amount_sun
                              , SUM (_tmpRemains_Partion_all.Amount_notSold) AS Amount_notSold
                              , SUM (_tmpRemains_Partion_all.Amount_6Month) AS Amount_6Month
                              , SUM (CASE WHEN _tmpRemains_Partion_all.isNotSold100 = FALSE THEN 1 ELSE 0 END) = 0 AS isNotSold100
                         FROM _tmpRemains_Partion_all
                         GROUP BY _tmpRemains_Partion_all.ContainerDescId
                                , _tmpRemains_Partion_all.UnitId
                                , _tmpRemains_Partion_all.ContainerId_Parent
                                , _tmpRemains_Partion_all.GoodsId
                                , _tmpRemains_Partion_all.PartionDateKindId
                                , _tmpRemains_Partion_all.ExpirationDate
                        )
            -- ��� SUN-1 ����� ContainerId_Parent - �������� ������� (��� ��������)
          , tmpRemains_gr AS (SELECT DISTINCT tmpRemains.UnitId, tmpRemains.GoodsId, tmpRemains.ContainerId_Parent FROM tmpRemains
                             )
            -- �������� �������� ������� �� ������� �������� (��� ��������)
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
                                  , SUM (tmpRemains.Amount_6Month)  AS Amount_6Month
                                  , SUM (CASE WHEN tmpRemains.isNotSold100 = FALSE THEN 1 ELSE 0 END) = 0 AS isNotSold100
                             FROM tmpRemains
                             GROUP BY tmpRemains.ContainerDescId, tmpRemains.UnitId, tmpRemains.GoodsId
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
                                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

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
         , SalesGoods AS (SELECT DISTINCT tmpSalesGoods.GoodsId FROM tmpSalesGoods)

           -- MCS + Price
         , tmpMCS AS (SELECT COALESCE (tmpMCS_all.UnitId,  tmpGoodsCategory.UnitId)  AS UnitId
                           , COALESCE (tmpMCS_all.GoodsId, tmpGoodsCategory.GoodsId) AS GoodsId
                           , COALESCE (tmpMCS_all.Price, 0)                :: TFloat AS Price
                           , CASE WHEN COALESCE (tmpGoodsCategory.Value, 0.0) <= COALESCE (tmpMCS_all.MCSValue, 0.0)
                                  THEN COALESCE (tmpMCS_all.MCSValue, 0.0)
                                  ELSE tmpGoodsCategory.Value
                             END                                         :: TFloat AS MCSValue
                           , COALESCE (tmpMCS_all.MCSValue_min, 0.0)     :: TFloat AS MCSValue_min
                      FROM tmpPrice AS tmpMCS_all
                           FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpMCS_all.GoodsId
                                                     AND tmpGoodsCategory.UnitId  = tmpMCS_all.UnitId
                      WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                         OR COALESCE (tmpMCS_all.MCSValue, 0) <> 0
                         OR COALESCE (tmpMCS_all.Price, 0)    <> 0
                     )
           -- ��������� !!���!!
         , tmpGoods_NOT AS (SELECT OB_Goods_NOT.ObjectId
                            FROM ObjectBoolean AS OB_Goods_NOT
                            WHERE OB_Goods_NOT.DescId   = zc_ObjectBoolean_Goods_NOT()
                              AND OB_Goods_NOT.ValueData = TRUE
                           )
       -- ���������: ��� ������� � ����������� - SUN-1
       INSERT INTO _tmpRemains_Partion (ContainerDescId, UnitId, GoodsId, MCSValue, Amount_sale, Amount, Amount_save, Amount_real, Amount_sun, Amount_notSold, Amount_6Month, isNotSold100)
          SELECT tmp.ContainerDescId
               , tmp.UnitId
               , tmp.GoodsId
               , COALESCE (tmpMCS.MCSValue, 0)     AS MCSValue
               , COALESCE (_tmpSale.Amount, 0)     AS Amount_sale

                 -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
               , FLOOR ((CASE -- ������ ��� - ��� ������
                              WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 THEN tmp.Amount
                              -- ��������� ��������, ���� ���� MCSValue
                              WHEN tmpMCS.MCSValue > 0 AND tmp.Amount > 0
                                   THEN tmp.Amount - COALESCE (tmpMCS.MCSValue, 0)
                              -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
                              WHEN _tmpSale.Amount > 0 AND tmp.Amount > 0 THEN tmp.Amount - COALESCE (_tmpSale.Amount, 0)
                              ELSE tmp.Amount
                         END
                         -- ��������� - ���������� ���� + �� ����������� � CommentError
                       - COALESCE (_tmpRemains_all.AmountReserve, 0)
                         -- ��������� - ����������� - ������ (���������)
                       - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                         -- ��������� - ������� ����������
                       - COALESCE (_tmpGoods_Sun_exception.Amount, 0)
                         -- ��������� ��������
                       - COALESCE(_tmpGoods_Layout.Layout, 0)
                       /*- CASE WHEN _tmpGoods_Layout.isNotMoveRemainder6 = TRUE  OR 
                                   tmp.Amount - COALESCE (tmp.Amount_6Month, 0) >=  COALESCE(_tmpGoods_Layout.Layout, 0) OR
                                   COALESCE (tmp.Amount_6Month, 0) = 0
                              THEN COALESCE(_tmpGoods_Layout.Layout, 0) 
                              WHEN (tmp.Amount - COALESCE (tmp.Amount_6Month, 0)) >= 0
                              THEN tmp.Amount - COALESCE (tmp.Amount_6Month, 0)
                              ELSE 0 END*/
                         -- ��������� ���������� ����� �� �����
                       - COALESCE(_tmpGoods_PromoUnit.Amount, 0)
                          -- ����� �� ���������
                        ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                       ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                 AS Amount

                 -- ������� ���� ��� �������������
               , tmp.Amount             AS Amount_save
                 --
               , tmpRemains_real.Amount AS Amount_real
                 --
               , FLOOR ((CASE -- ������ ��� - ��� ������
                              WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 THEN tmp.Amount_sun
                              -- ��������� ��������, ���� ���� MCSValue
                              WHEN tmpMCS.MCSValue > 0 AND tmp.Amount_sun > 0
                                   THEN tmp.Amount_sun - COALESCE (tmpMCS.MCSValue, 0)
                              -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
                              WHEN _tmpSale.Amount > 0 AND tmp.Amount_sun > 0 THEN tmp.Amount_sun - COALESCE (_tmpSale.Amount, 0)
                              ELSE tmp.Amount_sun
                         END
                         -- ��������� - ���������� ���� + �� ����������� � CommentError
                       - COALESCE (_tmpRemains_all.AmountReserve, 0)
                         -- ��������� - ����������� - ������ (���������)
                       - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                         -- ��������� - ������� ����������
                       - COALESCE (_tmpGoods_Sun_exception.Amount, 0)
                         -- ��������� ��������
                       - COALESCE(_tmpGoods_Layout.Layout, 0)
                       /*- CASE WHEN _tmpGoods_Layout.isNotMoveRemainder6 = TRUE  OR
                                   tmp.Amount - COALESCE (tmp.Amount_6Month, 0) >=  COALESCE(_tmpGoods_Layout.Layout, 0) OR
                                   COALESCE (tmp.Amount_6Month, 0) = 0
                              THEN COALESCE(_tmpGoods_Layout.Layout, 0) 
                              WHEN (tmp.Amount - COALESCE (tmp.Amount_6Month, 0)) >= 0
                              THEN (tmp.Amount - COALESCE (tmp.Amount_6Month, 0))
                              ELSE 0 END*/
                         -- ��������� ���������� ����� �� �����
                       - COALESCE(_tmpGoods_PromoUnit.Amount, 0)
                          -- ����� �� ���������
                        ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                       ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                 AS Amount_sun
                 --
               , FLOOR ((CASE -- ������ ��� - ��� ������
                              WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 THEN tmp.Amount_notSold
                              -- ��������� NotSold, ���� ���� MCSValue
                              WHEN tmpMCS.MCSValue > 0 AND tmp.Amount_notSold > 0
                                   THEN tmp.Amount_notSold - COALESCE(tmpMCS.MCSValue, 0)
                              -- ��������� NotSold, ���� ���� ������� �� � ��������� �� �����
                              WHEN _tmpSale.Amount > 0 AND tmp.Amount_notSold > 0 THEN tmp.Amount_notSold - COALESCE (_tmpSale.Amount, 0)
                              ELSE tmp.Amount_notSold
                         END
                         -- ��������� - ���������� ���� + �� ����������� � CommentError
                       - COALESCE (_tmpRemains_all.AmountReserve, 0)
                         -- ��������� - ����������� - ������ (���������)
                       - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                         -- ��������� - ������� ����������
                       - COALESCE (_tmpGoods_Sun_exception.Amount, 0)
                         -- ��������� ��������
                       - COALESCE(_tmpGoods_Layout.Layout, 0)
                       /*- CASE WHEN _tmpGoods_Layout.isNotMoveRemainder6 = TRUE  OR 
                                   tmp.Amount - COALESCE (tmp.Amount_6Month, 0) >=  COALESCE(_tmpGoods_Layout.Layout, 0) OR
                                   COALESCE (tmp.Amount_6Month, 0) = 0
                              THEN COALESCE(_tmpGoods_Layout.Layout, 0) 
                              WHEN (tmp.Amount - COALESCE (tmp.Amount_6Month, 0)) >= 0
                              THEN (tmp.Amount - COALESCE (tmp.Amount_6Month, 0))
                              ELSE 0 END*/
                         -- ��������� ���������� ����� �� �����
                       - COALESCE(_tmpGoods_PromoUnit.Amount, 0)
                          -- ����� �� ���������
                        ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                       ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                 AS Amount_notSold
               , tmp.Amount_6Month  
               , tmp.isNotSold100

          FROM tmpGoods_sum AS tmp
               -- ���������
               LEFT JOIN _tmpRemains_all ON _tmpRemains_all.UnitId  = tmp.UnitId
                                        AND _tmpRemains_all.GoodsId = tmp.GoodsId
               -- ���
               LEFT JOIN tmpMCS ON tmpMCS.UnitId  = tmp.UnitId
                               AND tmpMCS.GoodsId = tmp.GoodsId
               LEFT JOIN tmpRemains_real ON tmpRemains_real.UnitId  = tmp.UnitId
                                        AND tmpRemains_real.GoodsId = tmp.GoodsId
               -- ���������
               LEFT JOIN _tmpRemains ON _tmpRemains.UnitId       = tmp.UnitId
                                    AND _tmpRemains.GoodsId      = tmp.GoodsId
                                    AND _tmpRemains.AmountResult > 0
               -- �������
               LEFT JOIN _tmpSale ON _tmpSale.UnitId  = tmp.UnitId
                                 AND _tmpSale.GoodsId = tmp.GoodsId
                                 
               -- ������ ��� ���������
               LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId  = tmp.GoodsId

               -- � �����, ��������� !!�����!!
               -- LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = tmp.GoodsId
               -- � �����, ��������� !!���!!
               LEFT JOIN tmpGoods_NOT ON tmpGoods_NOT.ObjectId = tmp.GoodsId

               LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = tmp.UnitId
                                         AND _tmpGoods_Layout.GoodsId = tmp.GoodsId

               LEFT JOIN _tmpGoods_PromoUnit ON _tmpGoods_PromoUnit.UnitId = tmp.UnitId
                                            AND _tmpGoods_PromoUnit.GoodsId = tmp.GoodsId

               -- ���� ����� ����� ������
               LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                         ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = tmp.GoodsId

               LEFT JOIN _tmpGoods_Sun_exception ON _tmpGoods_Sun_exception.UnitId  = tmp.UnitId
                                                AND _tmpGoods_Sun_exception.GoodsId = tmp.GoodsId


          -- ��������� ���-�� �� ������������
          WHERE FLOOR ((CASE -- ������ ��� - ��� ������
                             WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 THEN tmp.Amount
                             -- ��������� ��������, ���� ���� MCSValue
                             WHEN tmpMCS.MCSValue > 0 AND tmp.Amount > 0
                                  THEN tmp.Amount - COALESCE(tmpMCS.MCSValue, 0)
                             -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
                             WHEN _tmpSale.Amount > 0 AND tmp.Amount > 0 THEN tmp.Amount - COALESCE (_tmpSale.Amount, 0) 
                             ELSE tmp.Amount
                        END
                        -- ��������� - ���������� ���� + �� ����������� � CommentError
                      - COALESCE (_tmpRemains_all.AmountReserve, 0)
                        -- ��������� - ����������� - ������ (���������)
                      - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                        -- ��������� - ������� ����������
                      - COALESCE (_tmpGoods_Sun_exception.Amount, 0)
                        -- ��������� ��������
                      - COALESCE(_tmpGoods_Layout.Layout, 0)
                      /*- CASE WHEN _tmpGoods_Layout.isNotMoveRemainder6 = TRUE  OR 
                                  tmp.Amount - COALESCE (tmp.Amount_6Month, 0) >=  COALESCE(_tmpGoods_Layout.Layout, 0) OR
                                  COALESCE (tmp.Amount_6Month, 0) = 0
                             THEN COALESCE(_tmpGoods_Layout.Layout, 0) 
                             WHEN (tmp.Amount - COALESCE (tmp.Amount_6Month, 0)) >= 0
                             THEN (tmp.Amount - COALESCE (tmp.Amount_6Month, 0))
                             ELSE 0 
                             END*/
                        -- ��������� ���������� ����� �� �����
                      - COALESCE(_tmpGoods_PromoUnit.Amount, 0)
                         -- ����� �� ���������
                       ) / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                      ) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                >= CASE WHEN tmpMCS.Price <= 100 THEN 1 ELSE 0 END

            -- !!!����������� ����� ��������, �� ������� ���� ���������, �.�. ������������ �� ���� �� �����
            AND _tmpRemains.GoodsId IS NULL
            -- ��������� !!�����!!
            -- AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
            --      tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE)
            -- ��������� !!���!!
            AND tmpGoods_NOT.ObjectId IS NULL

          ;
          
      ANALYSE _tmpRemains_Partion;

raise notice 'Value 17: %', CLOCK_TIMESTAMP();


 /*RAISE EXCEPTION '������.<%> <%> ', (select count(*) FROM _tmpRemains_Partion WHERE _tmpRemains_Partion.GoodsId in (42364)),
                               (SELECT tmpGoods.GoodsID AS ObjectId
                              FROM (SELECT DISTINCT _tmpRemains_Partion_all.GoodsId FROM _tmpRemains_Partion_all) AS tmpGoods
                                   LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsID
                                   LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_ColdSUN
                                                           ON ObjectBoolean_ColdSUN.ObjectId = Object_Goods_Main.ConditionsKeepId
                                                          AND ObjectBoolean_ColdSUN.DescId = zc_ObjectBoolean_ConditionsKeep_ColdSUN()
                              WHERE (COALESCE (ObjectBoolean_ColdSUN.ValueData, FALSE) = TRUE
                                 OR Object_Goods_Main.isColdSUN = TRUE 
                                    )
                                AND vbisEliminateColdSUN = TRUE
                                AND tmpGoods.GoodsId in (42364)
                             ); */

     -- ������ ���������� ������������� ���� ������� ������ ��������� ����� �� ��� , ���� � ���� ������� ������ ��� N
     UPDATE _tmpRemains_Partion SET Amount = FLOOR (CASE WHEN _tmpRemains_Partion.Amount_save - COALESCE(_tmpUnit_SUN.Limit_N, 0) <= 0 THEN 0
                                                         ELSE  _tmpRemains_Partion.Amount_save - COALESCE(_tmpUnit_SUN.Limit_N, 0) END)
     FROM _tmpUnit_SUN
     WHERE _tmpRemains_Partion.UnitId = _tmpUnit_SUN.UnitId
       AND COALESCE(_tmpUnit_SUN.Limit_N, 0) > 0
       AND _tmpRemains_Partion.Amount_save - _tmpRemains_Partion.Amount < COALESCE(_tmpUnit_SUN.Limit_N, 0);


     -- 4. ������� �� ������� ���� ��������� � ����
     INSERT INTO _tmpRemains_calc (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve
                                 , AmountSun_real, AmountSun_summ, AmountSun_summ_save, AmountSun_unit, AmountSun_unit_save)
        SELECT _tmpRemains.UnitId
             , _tmpRemains.GoodsId
               -- ����
             , _tmpRemains.Price
               -- ���
             , _tmpRemains.MCS
               -- ���������
             , _tmpRemains.AmountResult
               --
             , _tmpRemains.AmountRemains
             , _tmpRemains.AmountIncome
             , _tmpRemains.AmountSend_in
             , _tmpRemains.AmountSend_out
             , _tmpRemains.AmountOrderExternal
             , _tmpRemains.AmountReserve
               -- ����� �������� �� �������� ��������, ������ ��������� � AmountSun_summ
             , tmpRemains_Partion_sum.Amount_real       AS AmountSun_real
               -- ����� �������� ������� ����� ������������
             , tmpRemains_Partion_sum.Amount            AS AmountSun_summ
               -- ����� ��������
             , tmpRemains_Partion_sum.Amount_save       AS AmountSun_summ_save

               -- ���.=0, �������� �� ���� ������, ����� ����������� � ������ ����� �� �����, �.�. ���� ��������� �� ���������
             , COALESCE (_tmpRemains_Partion.Amount, 0)      AS AmountSun_unit
               -- ���.=0, �������� �� ���� ������
             , COALESCE (_tmpRemains_Partion.Amount_save, 0) AS AmountSun_unit_save

        FROM -- � ���������� - AmountResult
             _tmpRemains
             -- ����� � ����������� ������� ����� ������������ - SUN-1
             INNER JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.Amount) AS Amount, SUM (_tmpRemains_Partion.Amount_save) AS Amount_save, SUM (_tmpRemains_Partion.Amount_real) AS Amount_real
                         FROM _tmpRemains_Partion
                         GROUP BY _tmpRemains_Partion.GoodsId
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains.GoodsId
             -- SUN-1 �� ���� ������, ����� ����������� � ������ ����� �� �����, �.�. ���� ��������� �� ���������
             LEFT JOIN _tmpRemains_Partion ON _tmpRemains_Partion.UnitId  = _tmpRemains.UnitId
                                          AND _tmpRemains_Partion.GoodsId = _tmpRemains.GoodsId
             -- ���� ����� ����� ������
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains.GoodsId

        WHERE (_tmpRemains.AmountResult   > 0
            -- ��� ����� ����� ������
            --OR _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0
              )
          AND _tmpRemains_Partion.UnitId IS NULL
            -- ������ ����� �������
          AND COALESCE (_tmpGoods_SUN_PairSun_find.GoodsId_PairSun, 0) = 0
        ;
        
     ANALYSE _tmpRemains_calc;

raise notice 'Value 18: %', CLOCK_TIMESTAMP();


     -- 5. �� ����� ����� ������� �� ������� "�����������" ��������� ���������
     -- CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpSumm_limit (UnitId_from, UnitId_to, Summ)
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from
             , _tmpRemains_calc.UnitId    AS UnitId_to
               -- ���� �������� ������ ��� � ����������
             , SUM (CASE WHEN _tmpRemains_Partion.Amount >= _tmpRemains_calc.AmountResult
                              -- ����� �������� = ���������
                              THEN _tmpRemains_calc.AmountResult
                              -- ����� ��������� "��������" - �.�. ������� ���� ��������
                              ELSE FLOOR (_tmpRemains_Partion.Amount / COALESCE (_tmpGoods_SUN.KoeffSUN, 1)) * COALESCE (_tmpGoods_SUN.KoeffSUN, 1)
                    END
                  * _tmpRemains_calc.Price
                   )
        FROM -- ������� �� ������� ���� ��������� � ����
             _tmpRemains_calc
             -- ��� �������, ����
             INNER JOIN _tmpRemains_Partion ON _tmpRemains_Partion.GoodsId = _tmpRemains_calc.GoodsId

             -- ������ ��� ���������
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_calc.GoodsId

             -- � �����, ��������� !!�����!!
             -- LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_calc.GoodsId

             -- ��������� !!����������!!
             LEFT JOIN _tmpUnit_SunExclusion ON _tmpUnit_SunExclusion.UnitId_from = _tmpRemains_Partion.UnitId
                                            AND _tmpUnit_SunExclusion.UnitId_to   = _tmpRemains_calc.UnitId

        WHERE _tmpUnit_SunExclusion.UnitId_to IS NULL
          --AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
          --     tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE)

        GROUP BY _tmpRemains_Partion.UnitId
               , _tmpRemains_calc.UnitId
       ;
       
     ANALYSE _tmpSumm_limit;

raise notice 'Value 19: %', CLOCK_TIMESTAMP();


     -- 6.1.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     -- CREATE TEMP TABLE _tmpResult_Partion (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     --
     -- ������1 - ��� �������, ���� + ������� ���� ��� �������������
     OPEN curPartion FOR
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from, _tmpRemains_Partion.GoodsId
               --
               -- ������ ���� ����� �������� �� ������
/*             , CASE -- ���� � ������� ��� = 0, �� ������
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND COALESCE (_tmpRemains_Partion_PairSun.Amount, 0) <=0
                         THEN 0
                    -- ���� � ������� ��� < ��� � "���������", ������ �� �������
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND _tmpRemains_Partion_PairSun.Amount < _tmpRemains_Partion.Amount
                         THEN _tmpRemains_Partion_PairSun.Amount
                    -- ���� ����� ��� "���������"
                    ELSE _tmpRemains_Partion.Amount
               END */
             , FLOOR(_tmpRemains_Partion.Amount) AS Amount

               -- ��� ��������� ������� �����, ����� ���� ���.
/*             , CASE -- ���� � ������� ��� = 0, �� ������
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND COALESCE (_tmpRemains_Partion_PairSun.Amount_save, 0) <=0
                         THEN 0
                    -- ���� � ������� ��� < ��� � "���������", ������ �� �������
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND _tmpRemains_Partion_PairSun.Amount_save < _tmpRemains_Partion.Amount_save
                         THEN _tmpRemains_Partion_PairSun.Amount_save
                    -- ���� ����� ��� "���������"
                    ELSE _tmpRemains_Partion.Amount_save
               END AS Amount_save*/
             , _tmpRemains_Partion.Amount_save AS Amount_save
               --
             , _tmpRemains_Partion.Amount_sun
               --
             , COALESCE (_tmpGoods_SUN.KoeffSUN, 0)
               -- ������
             , _tmpGoods_SUN_PairSun.GoodsId_PairSun
             
             , _tmpRemains_Partion.isNotSold100
             
             , ObjectLink_Unit_Juridical.ChildObjectId         

        FROM _tmpRemains_Partion
             -- �������� � �����, ��� ������ ����� ���� ������������
             INNER JOIN (SELECT _tmpSumm_limit.UnitId_from, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                         -- !!!������ ������
                         WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                         GROUP BY _tmpSumm_limit.UnitId_from
                        ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_from = _tmpRemains_Partion.UnitId
             -- ������ - ��� ���������
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_Partion.GoodsId

             -- ����� - ���� �� � ������ ������
             LEFT JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = _tmpRemains_Partion.GoodsId
             LEFT JOIN _tmpRemains_Partion AS _tmpRemains_Partion_PairSun
                                           ON _tmpRemains_Partion_PairSun.GoodsId = _tmpGoods_SUN_PairSun.GoodsId_PairSun
                                          AND _tmpRemains_Partion_PairSun.UnitId  = _tmpRemains_Partion.UnitId
             -- ����� ���� ����� ������
             LEFT JOIN (SELECT DISTINCT _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM _tmpGoods_SUN_PairSun
                       ) AS _tmpGoods_SUN_PairSun_find ON _tmpGoods_SUN_PairSun_find.GoodsId_PairSun = _tmpRemains_Partion.GoodsId
                       
             -- ������ ���������� �����
             LEFT JOIN _tmpGoods_DiscountExternal AS _tmpGoods_DiscountExternal
                                                  ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_Partion.UnitId
                                                 AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_Partion.GoodsId
                                                 
             LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId  = _tmpRemains_Partion.UnitId
             
             LEFT JOIN (SELECT tmp.GoodsId FROM gpSelect_Object_GoodsPromo(inOperDate := CURRENT_DATE , inRetailId := 4 , inSession := inUserId::TVarChar) AS tmp 
                        WHERE tmp.isNotUseSUN = TRUE) AS tmpGoodsPromo ON tmpGoodsPromo.GoodsId = _tmpRemains_Partion.GoodsId
             
             -- � �����, ��������� !!�����!!
             LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_Partion.GoodsId
             
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_Partion.UnitId
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             

        WHERE -- !!!��������� ������!!!
              COALESCE ( _tmpGoods_SUN_PairSun_find.GoodsId_PairSun, 0) = 0

          AND FLOOR(_tmpRemains_Partion.Amount) > 0

          AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
          
          AND COALESCE(tmpGoodsPromo.GoodsId, 0) = 0
          
          AND (_tmpUnit_SUN.isOnlyTimingSUN = False OR _tmpRemains_Partion.ContainerDescId = zc_Container_CountPartionDate())
          
              -- ��������� !!�����!!
          AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
              tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE OR
              _tmpUnit_SUN.isColdOutSUN = TRUE)

          
/*          CASE -- ���� � ������� ��� = 0, �� ������
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND COALESCE (_tmpRemains_Partion_PairSun.Amount, 0) <= 0
                         THEN 0
                    -- ���� � ������� ��� < ��� � "���������", ������ �� �������
                    WHEN _tmpGoods_SUN_PairSun_find.GoodsId_PairSun > 0 AND _tmpRemains_Partion_PairSun.Amount < _tmpRemains_Partion.Amount
                         THEN _tmpRemains_Partion_PairSun.Amount
                    -- ���� ����� ��� "���������"
                    ELSE _tmpRemains_Partion.Amount
               END > 0*/
        ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
       ;
     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curPartion INTO vbUnitId_from, vbGoodsId, vbAmount, vbAmount_save, vbAmount_sun, vbKoeffSUN, vbGoodsId_PairSun, vbisNotSold100, vbJuridicalId;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

        /* IF vbGoodsId = 17674567
         THEN
           raise notice 'Value 05: % % %', vbUnitId_from, vbGoodsId, vbAmount;
         END IF;*/

         -- ������2. - ��������� ����� ������� ��� ������������ ��� vbGoodsId
         OPEN curResult FOR
            SELECT _tmpRemains_calc.UnitId AS UnitId_to
                 , _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) AS AmountResult
                 , _tmpRemains_calc.Price
                 , COALESCE (_tmpRemains_calc_PairSun.Price, _tmpRemains_calc.Price) AS Price_PairSun
                 , COALESCE (OB_SUN_NotSoldIn.ValueData, FALSE)           AS isNotSoldIn
            FROM _tmpRemains_calc
                 -- ������� ��� ������ ����� �������������-1
                 LEFT JOIN (SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId, SUM (_tmpResult_Partion.Amount) AS Amount FROM _tmpResult_Partion GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                           ) AS tmp ON tmp.UnitId_to = _tmpRemains_calc.UnitId
                                   AND tmp.GoodsId   = _tmpRemains_calc.GoodsId
                 -- �������� � �����, ��� ������ ����� ���� ������������
                 INNER JOIN (SELECT _tmpSumm_limit.UnitId_to, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                             WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from
                               -- !!!������ ������
                               AND _tmpSumm_limit.Summ >= vbSumm_limit
                             GROUP BY _tmpSumm_limit.UnitId_to
                            ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_to = _tmpRemains_calc.UnitId
                 -- ������ ���� ��� ����
                 LEFT JOIN _tmpRemains_calc AS _tmpRemains_calc_PairSun
                                            ON _tmpRemains_calc_PairSun.UnitId  = _tmpRemains_calc.UnitId
                                           AND _tmpRemains_calc_PairSun.GoodsId = vbGoodsId_PairSun
                 -- ������ ���������� �����
                 LEFT JOIN _tmpGoods_DiscountExternal AS _tmpGoods_DiscountExternal
                                                      ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_calc.UnitId
                                                     AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_calc.GoodsId
                 
                 -- ��������� �������� ������ ����� "��� ������" ��� ���-1
                 LEFT JOIN ObjectBoolean AS OB_SUN_NotSoldIn
                                         ON OB_SUN_NotSoldIn.ObjectId  = _tmpRemains_calc.UnitId
                                        AND OB_SUN_NotSoldIn.DescId    = zc_ObjectBoolean_Unit_SUN_NotSoldIn()
                                        
                 -- ��������� �������� ����� ������� ���������
                 LEFT JOIN _tmpGoods_Sun_exception AS _tmpGoods_Sun_exception
                                                   ON _tmpGoods_Sun_exception.UnitId  = _tmpRemains_calc.UnitId
                                                  AND _tmpGoods_Sun_exception.GoodsId = _tmpRemains_calc.GoodsId

                 -- � �����, ��������� !!�����!!
                 LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_calc.GoodsId
                 
                 
                 LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId  = _tmpRemains_calc.UnitId

                 -- ��������� !!��������!!
                 LEFT JOIN tmpPrice ON tmpPrice.UnitId  = _tmpRemains_calc.UnitId
                                   AND tmpPrice.GoodsId = _tmpRemains_calc.GoodsId

                 -- ���� ������� �� ������
                 LEFT JOIN tmpSalesGoods ON tmpSalesGoods.UnitId  = _tmpRemains_calc.UnitId 
                                        AND tmpSalesGoods.GoodsId = _tmpRemains_calc.GoodsId 
                                        
                 -- ��������� !!����������!!
                 LEFT JOIN _tmpUnit_SunExclusion AS _tmpUnit_SunExclusion_MCS
                                                 ON _tmpUnit_SunExclusion_MCS.UnitId_from = vbUnitId_from
                                                AND _tmpUnit_SunExclusion_MCS.UnitId_to   = _tmpRemains_calc.UnitId

                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                      ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_calc.UnitId
                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                     
            WHERE _tmpRemains_calc.GoodsId = vbGoodsId
              AND _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) > 0
              AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
              AND COALESCE(_tmpGoods_Sun_exception.Amount, 0) = 0
              AND COALESCE(_tmpUnit_SunExclusion_MCS.UnitId_to, 0) = 0
              AND ((COALESCE(tmpPrice.isCloseMCS, FALSE) = FALSE OR _tmpUnit_SUN.isLock_ClosePL = FALSE) AND
                   (COALESCE(tmpPrice.isClose, FALSE) = FALSE OR _tmpUnit_SUN.isLock_CloseGd = FALSE) OR
                    COALESCE (tmpSalesGoods.GoodsId, 0) <> 0)
              AND (vbisLegalEntitiesSUN = FALSE OR ObjectLink_Unit_Juridical.ChildObjectId = vbJuridicalId)
              -- !!!������ � �� ������, ������� ������������� ������!!!
              --!!! AND _tmpRemains_calc.UnitId IN (SELECT DISTINCT _tmpSumm_limit.UnitId_to FROM _tmpSumm_limit WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from AND _tmpSumm_limit.Summ >= vbSumm_limit)
            ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_calc.UnitId
           ;
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� ���������
         LOOP
             -- ������ �� ���������
             FETCH curResult INTO vbUnitId_to, vbAmountResult, vbPrice, vbPrice_PairSun, vbisNotSoldIn;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             IF vbisNotSold100 = FALSE AND vbisNotSoldIn = TRUE THEN CONTINUE; END IF;

             -- ���� ��������� > �������
             IF vbAmountResult > vbAmount
             THEN
                 -- ���� � �������� "�������" - ������ "��� ������� �����", �.�. ������ ��� � ������� ���� ����� ��� � 1-�� ������
                 /*IF FLOOR(vbAmount) <> vbAmount
                 THEN
                     -- ������.�������.������� + ������� ����� "����" �������
                     vbAmount_calc:= FLOOR (vbAmount) + vbAmount_save - FLOOR (vbAmount_save);
                     -- ���� ���������� ������ ��� "���������" �������
                     IF vbAmount_calc > vbAmount
                     THEN -- ��������� ������ ����� �����
                          vbAmount:= FLOOR (vbAmount_calc);
                     ELSE -- ��������
                          vbAmount:= vbAmount_calc;
                     END IF;
                 END IF;*/
                 --
                 -- ����������� �� ������
                 vbIsOut_partion:= vbAmount_sun = 0
                                OR
                                   -- ������� ��� ����
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from), 0)
                                 + vbAmount * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_out_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from)
                                 ;
                 -- ����������� �� ������
                 vbIsIn_partion:= vbAmount_sun = 0
                                OR
                                   -- ������� ��� ������
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_to = vbUnitId_to), 0)
                                 + vbAmount * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_in_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to)
                                 ;
                 --
                 -- ���������� � ���������� ������ ��� � ��������, �.�. ������ ���� "����"
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId, Amount_not_out, Summ_not_out, Amount_not_in, Summ_not_in)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                           -- ����� ��������� ��� ��� ���� �������
                         , tmpGoods.GoodsId
                           -- � ������ ��������� - vbKoeffSUN
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
--      RAISE EXCEPTION '������.<%>', (select _tmpResult_Partion.Amount from _tmpResult_Partion where _tmpResult_Partion.GoodsId = 42550 AND _tmpResult_Partion.Amount > 0);
-- end if;

                 --  ���� ��� ��������� ��� ���� ������ ��������
                 IF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                    OR vbIsOut_partion = FALSE
                 THEN
                     -- �������� ���-�� ����� ������ �� ������
                     vbAmount     := 0;
                     vbAmount_save:= 0;
                 END IF;

             -- !!!������ �����!!!
             ELSE

                 -- ���������� � �������� ������ ��� ����, �.�. ������ ������� ���� � ������ ������
                 --
                 -- ���� � ��������� "�������" - ������ "��� ������� �����", �.�. ������ ��� � ������� ���� ����� ��� � 1-�� ������
                 IF FLOOR (vbAmountResult) <> vbAmountResult
                 THEN
                     -- ������.�������.��������� + ������� ����� "����" �������
                     vbAmount_calc:= FLOOR (vbAmountResult) + vbAmount_save - FLOOR (vbAmount_save);
                     -- ���� ���������� ������ ��� ���������
                     IF vbAmount_calc > vbAmountResult
                     THEN -- ��������� ������ ����� �����
                          vbAmountResult:= FLOOR (vbAmount_calc);
                     ELSE -- ��������
                          vbAmountResult:= vbAmount_calc;
                     END IF;

                 END IF;
                 --
                 -- ����������� �� ������
                 vbIsOut_partion:= vbAmount_sun = 0
                                OR
                                   -- ������� ��� ����
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from), 0)
                                 + vbAmountResult * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_out_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from)
                                 ;
                 -- ����������� �� ������
                 vbIsIn_partion:= vbAmount_sun = 0
                                OR
                                   -- ������� ��� ������
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_to = vbUnitId_to), 0)
                                 + vbAmountResult * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_in_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to)
                                 ;

                 --
                 -- ���������� � �������� ������ ��� ����, �.�. ������ ������� ���� � ������ ������
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId, Amount_not_out, Summ_not_out, Amount_not_in, Summ_not_in)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                           -- ����� ��������� ��� ��� ���� �������
                         , tmpGoods.GoodsId
                           -- ???����� ��� ��������� ������???
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
                 --  ���� ������ ��������
                 IF vbIsOut_partion = FALSE
                 THEN
                     -- �������� ���-�� ����� ������ �� ������
                     vbAmount     := 0;
                     vbAmount_save:= 0;
                 --  ���� ��� ���������
                 ELSEIF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                 THEN
                     -- ��������� �� ���-�� ������� ����� � ���������� �����
                     vbAmount     := vbAmount      - vbAmountResult;
                     vbAmount_save:= vbAmount_save - vbAmountResult;
                 END IF;

             END IF;

         END LOOP; -- ����� ����� �� �������2
         CLOSE curResult; -- ������� ������2.

     END LOOP; -- ����� ����� �� �������1
     CLOSE curPartion; -- ������� ������1
     
     ANALYSE _tmpResult_Partion;

raise notice 'Value 20: %', CLOCK_TIMESTAMP();

     -- raise notice 'Value 01: %', (SELECT COUNT(*) FROM _tmpResult_Partion WHERE  _tmpResult_Partion.UnitId_to = 6741875 );

     -- 6.1.2. ������������-2 ������� �� ������� - �� ���� ������� - ����� ������ !!!��� ��� ��������!!!
     --
     -- ������1 - ��� �������, ���� ����� ������� ��� ������������
     OPEN curPartion_next FOR
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from
             , _tmpRemains_Partion.GoodsId
             , FLOOR(_tmpRemains_Partion.Amount -COALESCE (tmp.Amount, 0)) AS Amount
             , _tmpRemains_Partion.Amount_sun
             , COALESCE (_tmpGoods_SUN.KoeffSUN, 0)
             , _tmpRemains_Partion.isNotSold100
             , ObjectLink_Unit_Juridical.ChildObjectId         
        FROM _tmpRemains_Partion
             -- ������� ��� ���� ����� ������������� - 1
             LEFT JOIN (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.GoodsId, SUM (_tmpResult_Partion.Amount) AS Amount FROM _tmpResult_Partion GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.GoodsId
                       ) AS tmp ON tmp.UnitId_from = _tmpRemains_Partion.UnitId
                               AND tmp.GoodsId     = _tmpRemains_Partion.GoodsId
             -- �������� � �����, ��� ������ ����� ���� ������������
             LEFT JOIN (SELECT _tmpSumm_limit.UnitId_from, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                        -- !!!��� ������
                        -- WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                        GROUP BY _tmpSumm_limit.UnitId_from
                       ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_from = _tmpRemains_Partion.UnitId

             -- ������ ��� ���������
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_Partion.GoodsId

             -- ������ ���������� �����
             LEFT JOIN _tmpGoods_DiscountExternal AS _tmpGoods_DiscountExternal
                                                  ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_Partion.UnitId
                                                 AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_Partion.GoodsId

             LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId  = _tmpRemains_Partion.UnitId

             LEFT JOIN (SELECT tmp.GoodsId FROM gpSelect_Object_GoodsPromo(inOperDate := CURRENT_DATE , inRetailId := 4 , inSession := inUserId::TVarChar) AS tmp 
                        WHERE tmp.isNotUseSUN = TRUE) AS tmpGoodsPromo ON tmpGoodsPromo.GoodsId = _tmpRemains_Partion.GoodsId

             -- � �����, ��������� !!�����!!
             LEFT JOIN tmpConditionsKeep ON tmpConditionsKeep.ObjectId = _tmpRemains_Partion.GoodsId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_Partion.UnitId
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

        WHERE FLOOR(_tmpRemains_Partion.Amount - COALESCE (tmp.Amount, 0)) > 0
          AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
          AND COALESCE(tmpGoodsPromo.GoodsId, 0) = 0
          AND (_tmpUnit_SUN.isOnlyTimingSUN = False OR _tmpRemains_Partion.ContainerDescId = zc_Container_CountPartionDate())
              -- ��������� !!�����!!
          AND ((tmpConditionsKeep.ObjectId IS NULL OR vbisEliminateColdSUN = FALSE) AND vbisOnlyColdSUN = FALSE OR
              tmpConditionsKeep.ObjectId IS NOT NULL AND vbisOnlyColdSUN = TRUE OR
              _tmpUnit_SUN.isColdOutSUN = TRUE)
        ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId;
     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbAmount, vbAmount_sun, vbKoeffSUN, vbisNotSold100, vbJuridicalId;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         /*IF vbGoodsId = 17674567
         THEN
           raise notice 'Value 10: % % %', vbUnitId_from, vbGoodsId, vbAmount;
         END IF;*/

         -- ������2. - ��������� ����� ������� ��� ������������ ��� vbGoodsId
         OPEN curResult_next FOR
            SELECT _tmpRemains_calc.UnitId AS UnitId_to
                 , _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) AS AmountResult
                 , _tmpRemains_calc.Price
                 , COALESCE (ObjectBoolean_SUN_NotSoldIn.ValueData, FALSE)  AS isNotSoldIn
            FROM _tmpRemains_calc
                 -- ������� ��� ������ ����� ������������� - 1+2
                 LEFT JOIN (SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId, SUM (_tmpResult_Partion.Amount + _tmpResult_Partion.Amount_next) AS Amount FROM _tmpResult_Partion GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                           ) AS tmp ON tmp.UnitId_to = _tmpRemains_calc.UnitId
                                   AND tmp.GoodsId   = _tmpRemains_calc.GoodsId
                 -- �������� � �����, ��� ������ ����� ���� ������������
                 LEFT JOIN (SELECT _tmpSumm_limit.UnitId_to, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                            WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from
                              -- !!!��� ������
                              -- AND _tmpSumm_limit.Summ >= vbSumm_limit
                            GROUP BY _tmpSumm_limit.UnitId_to
                           ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_to = _tmpRemains_calc.UnitId

                 -- ������ - ��� ���������
                 LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_calc.GoodsId

                 -- !!!������ �� DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit!!!
                 LEFT JOIN _tmpList_DefSUN ON _tmpList_DefSUN.UnitId_from = vbUnitId_from
                                          AND _tmpList_DefSUN.UnitId_to   = _tmpRemains_calc.UnitId
                                          AND _tmpList_DefSUN.GoodsId     = vbGoodsId
                 -- !!!������ �� DefSUN-all - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit!!!
                 --LEFT JOIN (SELECT DISTINCT _tmpList_DefSUN.UnitId_to, _tmpList_DefSUN.GoodsId FROM _tmpList_DefSUN
                 --          ) AS _tmpList_DefSUN_all
                 --            ON _tmpList_DefSUN_all.UnitId_to = _tmpRemains_calc.UnitId
                 --           AND _tmpList_DefSUN_all.GoodsId   = vbGoodsId

                 -- !!!�� ������������ ���� ��� ��� ���� ����� � 1!!!
                 LEFT JOIN _tmpResult_Partion ON _tmpResult_Partion.UnitId_from = vbUnitId_from
                                             AND _tmpResult_Partion.UnitId_to   = _tmpRemains_calc.UnitId
                                             AND _tmpResult_Partion.GoodsId     = vbGoodsId
                                             AND _tmpResult_Partion.Amount      > 0

                 -- ��������� !!����������!!
                 LEFT JOIN _tmpUnit_SunExclusion AS _tmpUnit_SunExclusion_MCS
                                                 ON _tmpUnit_SunExclusion_MCS.UnitId_from = vbUnitId_from
                                                AND _tmpUnit_SunExclusion_MCS.UnitId_to   = _tmpRemains_calc.UnitId

                 -- ������ ���������� �����
                 LEFT JOIN _tmpGoods_DiscountExternal AS _tmpGoods_DiscountExternal
                                                      ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_calc.UnitId
                                                     AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_calc.GoodsId

                 LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_NotSoldIn
                                         ON ObjectBoolean_SUN_NotSoldIn.ObjectId = _tmpRemains_calc.UnitId
                                        AND ObjectBoolean_SUN_NotSoldIn.DescId = zc_ObjectBoolean_Unit_SUN_NotSoldIn()

                 -- ��������� �������� ����� ������� ���������
                 LEFT JOIN _tmpGoods_Sun_exception AS _tmpGoods_Sun_exception
                                                   ON _tmpGoods_Sun_exception.UnitId  = _tmpRemains_calc.UnitId
                                                  AND _tmpGoods_Sun_exception.GoodsId = _tmpRemains_calc.GoodsId

                 LEFT JOIN _tmpRemains_all ON _tmpRemains_all.UnitId  = _tmpRemains_calc.UnitId
                                          AND _tmpRemains_all.GoodsId = _tmpRemains_calc.GoodsId
                 
                 LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId  = _tmpRemains_calc.UnitId

                 -- ��������� !!��������!!
                 LEFT JOIN tmpPrice ON tmpPrice.UnitId  = _tmpRemains_calc.UnitId
                                    AND tmpPrice.GoodsId = _tmpRemains_calc.GoodsId

                 -- ���� ������� �� ������
                 LEFT JOIN tmpSalesGoods ON tmpSalesGoods.UnitId  = _tmpRemains_calc.UnitId 
                                        AND tmpSalesGoods.GoodsId = _tmpRemains_calc.GoodsId 

                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                      ON ObjectLink_Unit_Juridical.ObjectId = _tmpRemains_calc.UnitId
                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                     
            WHERE _tmpRemains_calc.GoodsId = vbGoodsId
              AND _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) > 0
              -- !!!�� ������������
              AND _tmpResult_Partion.GoodsId IS NULL
              -- !!!�� DefSUN
              AND _tmpList_DefSUN.GoodsId IS NULL
              -- !!!�� DefSUN-all
              --AND _tmpList_DefSUN_all.GoodsId IS NULL
              -- !!!��� ������
              -- AND _tmpRemains_calc.UnitId IN (SELECT DISTINCT _tmpSumm_limit.UnitId_to FROM _tmpSumm_limit WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from AND _tmpSumm_limit.Summ >= vbSumm_limit)

              -- !!!
              AND _tmpUnit_SunExclusion_MCS.UnitId_to IS NULL
              AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
              AND COALESCE(_tmpGoods_Sun_exception.Amount, 0) = 0
              AND ((COALESCE(_tmpRemains_all.isCloseMCS, FALSE) = FALSE OR _tmpUnit_SUN.isLock_ClosePL = FALSE) AND
                   (COALESCE(tmpPrice.isClose, FALSE) = FALSE OR _tmpUnit_SUN.isLock_CloseGd = FALSE) OR
                    COALESCE (tmpSalesGoods.GoodsId, 0) <> 0)
              AND (vbisLegalEntitiesSUN = FALSE OR ObjectLink_Unit_Juridical.ChildObjectId = vbJuridicalId)

            ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_calc.UnitId
           ;
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� ���������
         LOOP
             -- ������ �� ���������
             FETCH curResult_next INTO vbUnitId_to, vbAmountResult, vbPrice, vbisNotSoldIn;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;
             
             IF vbisNotSold100 = FALSE AND vbisNotSoldIn = TRUE THEN CONTINUE; END IF;

             -- ���� ��������� > �������
             IF vbAmountResult > vbAmount
             THEN
                 --
                 -- ����������� �� ������
                 vbIsOut_partion:= vbAmount_sun = 0
                                OR
                                   -- ������� ��� ����
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from), 0)
                                 + vbAmount * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_out_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from)
                                 ;
                 -- ����������� �� ������
                 vbIsIn_partion:= vbAmount_sun = 0
                                OR
                                   -- ������� ��� ������
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_to = vbUnitId_to), 0)
                                 + vbAmount * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_in_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to)
                                 ;
                 --
                 -- ���� �� ������, ����� �������� - ����� ���� ������� � ���� ��������, ������� �������� �� ����
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

                 -- ���������� � ���������� ������ ��� ������, �.�. ������ ���� "����"
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

                 --  ���� ��� ��������� ��� ���� ������ ��������
                 IF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                    OR vbIsOut_partion = FALSE
                 THEN
                     -- �������� ���-�� ����� ������ �� ������
                     vbAmount:= 0;
                 END IF;

             -- !!!������ �����!!!
             ELSE

                 -- ����������� �� ������
                 vbIsOut_partion:= vbAmount_sun = 0
                                OR
                                   -- ������� ��� ����
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_from = vbUnitId_from), 0)
                                 + vbAmountResult * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_out_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_from)
                                 ;
                 -- ����������� �� ������
                 vbIsIn_partion:= vbAmount_sun = 0
                                OR
                                   -- ������� ��� ������
                                   COALESCE ((SELECT SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) FROM _tmpResult_Partion WHERE _tmpResult_Partion.UnitId_to = vbUnitId_to), 0)
                                 + vbAmountResult * vbPrice
                                   <=
                                   COALESCE ((SELECT _tmpUnit_SUN_balance_partion.Summ_in_calc FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to), 0)
                                OR
                                   NOT EXISTS (SELECT 1 FROM _tmpUnit_SUN_balance_partion WHERE _tmpUnit_SUN_balance_partion.UnitId = vbUnitId_to)
                                 ;
                 --
                 -- ���� �� ������, ����� �������� - ����� ���� ������� � ���� ��������, ������� �������� �� ����
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

                 -- ���������� � �������� ������ ��� ������, !!!��������� � ����-��������� - �������� ���-��!!!
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

                 --  ���� ������ ��������
                 IF vbIsOut_partion = FALSE
                 THEN
                     -- �������� ���-�� ����� ������ �� ������
                     vbAmount     := 0;
                 --  ���� ��� ��������� ��� ���� ������ ��������
                 ELSEIF (vbIsOut_partion = TRUE AND vbIsIn_partion = TRUE)
                 THEN
                     -- ��������� �� ���-�� ������� ����� � ���������� �����
                     vbAmount:= vbAmount - vbAmountResult;
                 END IF;

             END IF;

         END LOOP; -- ����� ����� �� �������2
         CLOSE curResult_next; -- ������� ������2.

     END LOOP; -- ����� ����� �� �������1
     CLOSE curPartion_next; -- ������� ������1
     
     ANALYSE _tmpResult_Partion;

raise notice 'Value 21: %', CLOCK_TIMESTAMP();

     --raise notice 'Value 02: %', (SELECT COUNT(*) FROM _tmpResult_Partion WHERE  _tmpResult_Partion.UnitId_to = 6741875 );

     -- !!!������� �� ������������ ����!!!
/*     DELETE FROM _tmpResult_Partion
     WHERE (_tmpResult_Partion.UnitId_from :: TVarChar || '_' || _tmpResult_Partion.UnitId_to :: TVarChar || '_' || _tmpResult_Partion.GoodsId :: TVarChar)
           IN (SELECT _tmpResult_Partion.UnitId_from :: TVarChar || '_' || _tmpResult_Partion.UnitId_to :: TVarChar || '_' || _tmpResult_Partion.GoodsId :: TVarChar
               FROM _tmpResult_Partion
                    -- ������ ������
                    JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId_PairSun = _tmpResult_Partion.GoodsId
                    -- � �������� �� ����������
                    LEFT JOIN _tmpResult_Partion AS _tmpResult_Partion_check
                                                 ON _tmpResult_Partion_check.GoodsId     = _tmpGoods_SUN_PairSun.GoodsId
                                                AND _tmpResult_Partion_check.UnitId_from = _tmpResult_Partion.UnitId_from
                                                AND _tmpResult_Partion_check.UnitId_to   = _tmpResult_Partion.UnitId_to
               WHERE _tmpResult_Partion_check.GoodsId IS NULL
              );
*/


     -- 6.1.3. ��������
     IF EXISTS (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                     , SUM (_tmpResult_Partion.Amount) AS Amount, SUM (_tmpResult_Partion.Amount_next) AS Amount_next
                FROM _tmpResult_Partion
                GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                HAVING SUM (_tmpResult_Partion.Amount)      <> 0
                   AND SUM (_tmpResult_Partion.Amount_next) <> 0
               )
               AND 1=0
     THEN
         RAISE EXCEPTION '����������� �����������. <%> <%> <%> <%> <%> <%> <%>.'
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

     -- 6.1.4.1. !!!�����, ��� vbSumm_limit - ��������� �� ���������� � Amount!!!
     UPDATE _tmpResult_Partion SET Amount      = CASE WHEN _tmpResult_Partion.Amount_next > 0 THEN _tmpResult_Partion.Amount + _tmpResult_Partion.Amount_next  ELSE _tmpResult_Partion.Amount END
                                 , Summ        = CASE WHEN _tmpResult_Partion.Summ_next   > 0 THEN _tmpResult_Partion.Summ   + _tmpResult_Partion.Summ_next    ELSE _tmpResult_Partion.Summ   END
                                 , Amount_next = 0
                                 , Summ_next   = 0
     FROM -- ������� � 1 �����������
          (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
           FROM _tmpResult_Partion
           GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
           HAVING SUM (_tmpResult_Partion.Summ + _tmpResult_Partion.Summ_next) >= vbSumm_limit
          ) AS tmp
     WHERE _tmpResult_Partion.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Partion.UnitId_to   = tmp.UnitId_to
       AND _tmpResult_Partion.Amount_next > 0
    ;
    
    ANALYSE _tmpResult_Partion;

     -- 6.1.4.2. !!!�����, ���� ������� �� ������� ��� vbSumm_limit - ��������� � ����������!!!
     UPDATE _tmpResult_Partion SET Amount      = CASE WHEN _tmpResult_Partion.Amount_next = 0 THEN 0                         ELSE _tmpResult_Partion.Amount      END
                                 , Summ        = CASE WHEN _tmpResult_Partion.Summ_next   = 0 THEN 0                         ELSE _tmpResult_Partion.Summ        END
                                 , Amount_next = CASE WHEN _tmpResult_Partion.Amount_next = 0 THEN _tmpResult_Partion.Amount ELSE _tmpResult_Partion.Amount_next END
                                 , Summ_next   = CASE WHEN _tmpResult_Partion.Summ_next   = 0 THEN _tmpResult_Partion.Summ   ELSE _tmpResult_Partion.Summ_next   END
     FROM -- ������� � 1 �����������
          (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
           FROM _tmpResult_Partion
           GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
           HAVING SUM (_tmpResult_Partion.Summ) < vbSumm_limit
          ) AS tmp
     WHERE _tmpResult_Partion.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Partion.UnitId_to   = tmp.UnitId_to
    ;
    
    ANALYSE _tmpResult_Partion;


     -- 6.1.5. !!!�����, ��������� ����������!!!
     UPDATE _tmpResult_Partion SET Amount_next = 0, Summ_next = 0;
     DELETE FROM _tmpResult_Partion WHERE Amount = 0 AND Amount_next = 0;
     
    ANALYSE _tmpResult_Partion;

raise notice 'Value 23: %', CLOCK_TIMESTAMP();

     -- �������� ������ �������� �������

/*     IF inUserId = '3'
     THEN

        UPDATE _tmpRemains set AmountRemains = 1
        WHERE _tmpRemains.UnitId = 377610 AND _tmpRemains.GoodsId = 366794;

        UPDATE _tmpRemains set AmountRemains = 1
        WHERE _tmpRemains.UnitId = 377574 AND _tmpRemains.GoodsId = 366788;

        raise notice '������. % % %',
                     (SELECT count(*) FROM _tmpResult_Partion),
                     (SELECT count(*) FROM _tmpResult_Partion WHERE _tmpResult_Partion.GoodsId in (SELECT GoodsId_PairSun FROM _tmpGoods_SUN_PairSun)),
                     (SELECT count(*) FROM _tmpRemains WHERE _tmpRemains.UnitId = 377610 AND _tmpRemains.GoodsId = 366794);
     END IF;
*/

    -- !!! �������� ������, ����� ������������� ...
     WITH -- ����� � �������� ����� ����
          tmpResult_Partion AS (SELECT _tmpResult_Partion.*, _tmpGoods_SUN_PairSun.GoodsId_PairSun, _tmpGoods_SUN_PairSun.PairSunAmount
                                FROM _tmpResult_Partion

                                     INNER JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = _tmpResult_Partion.GoodsId
                                ),
          -- ������� ������
          tmpRemains_Pair  AS (SELECT _tmpRemains.GoodsId
                                    , _tmpRemains.UnitId
                                    , _tmpRemains.Price
                                    , _tmpRemains.AmountRemains
                               FROM _tmpRemains
                               WHERE _tmpRemains.GoodsId IN (SELECT DISTINCT  _tmpGoods_SUN_PairSun.GoodsId_PairSun FROM  _tmpGoods_SUN_PairSun)
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
                               THEN DD.AmountPair
                          ELSE DD.AmountRemains - DD.AmountSUM + DD.AmountPair
                     END AS AmountAdd
              FROM tmpResult AS DD
              WHERE DD.AmountRemains - (DD.AmountSUM - DD.AmountPair) > 0
             ) AS tmpItem;
             
     ANALYSE _tmpResult_Partion; 

raise notice 'Value 24: %', CLOCK_TIMESTAMP();

/*     IF inUserId = '3'
     THEN
        raise notice '������. % %', (SELECT count(*) FROM _tmpResult_Partion)
                                  , (SELECT count(*) FROM _tmpResult_Partion WHERE _tmpResult_Partion.GoodsId in (SELECT GoodsId_PairSun FROM _tmpGoods_SUN_PairSun));
     END IF;
*/


/*     -- !!! �������� ������, ������� ��� � ������ ...
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



     -- !!!�������� - ������������ ���� - ��� �����!!!
     IF (inUserId <> 5 OR EXTRACT (HOUR FROM CURRENT_TIMESTAMP) > 11)
     AND EXISTS (SELECT _tmpResult_Partion.UnitId_from :: TVarChar || '_' || _tmpResult_Partion.UnitId_to :: TVarChar || '_' || _tmpResult_Partion.GoodsId :: TVarChar
                 FROM _tmpResult_Partion
                      -- ����� ����
                      JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = _tmpResult_Partion.GoodsId
                      -- � ����� �� �����
                      LEFT JOIN _tmpResult_Partion AS _tmpResult_Partion_check
                                                   ON _tmpResult_Partion_check.GoodsId     = _tmpGoods_SUN_PairSun.GoodsId_PairSun
                                                  AND _tmpResult_Partion_check.UnitId_from = _tmpResult_Partion.UnitId_from
                                                  AND _tmpResult_Partion_check.UnitId_to   = _tmpResult_Partion.UnitId_to
                                                  AND _tmpResult_Partion_check.Amount      = _tmpResult_Partion.Amount
                 WHERE _tmpResult_Partion_check.GoodsId IS NULL
                )
     THEN
         RAISE EXCEPTION '������.�� ������� ���� � ����������� ��� <%>', (SELECT lfGet_Object_ValueData_sh (_tmpResult_Partion.UnitId_from) || ' => ' || lfGet_Object_ValueData_sh (_tmpResult_Partion.UnitId_to) || ' : ' || lfGet_Object_ValueData (_tmpResult_Partion.GoodsId)
                                                                          FROM _tmpResult_Partion
                                                                               -- ����� ����
                                                                               JOIN _tmpGoods_SUN_PairSun ON _tmpGoods_SUN_PairSun.GoodsId = _tmpResult_Partion.GoodsId
                                                                               -- � ����� �� �����
                                                                               LEFT JOIN _tmpResult_Partion AS _tmpResult_Partion_check
                                                                                                            ON _tmpResult_Partion_check.GoodsId     = _tmpGoods_SUN_PairSun.GoodsId_PairSun
                                                                                                           AND _tmpResult_Partion_check.UnitId_from = _tmpResult_Partion.UnitId_from
                                                                                                           AND _tmpResult_Partion_check.UnitId_to   = _tmpResult_Partion.UnitId_to
                                                                                                           AND _tmpResult_Partion_check.Amount      = _tmpResult_Partion.Amount
                                                                          WHERE _tmpResult_Partion_check.GoodsId IS NULL
                                                                         );
     END IF;

*/

     -- 6.2.1. !!!�����, ��������� - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     IF inStep = 1
     THEN
         -- ������ DefSUN
         INSERT INTO _tmpList_DefSUN (UnitId_from , UnitId_to, GoodsId)
            WITH -- DefSUN - �� ���������� 2 ���
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
                 -- DefSUN - 2 ��� ������
               , tmpResult AS (SELECT tmpDefSUN.UnitId_from, tmpDefSUN.UnitId_to, tmpDefSUN.GoodsId
                              FROM tmpDefSUN
                              GROUP BY tmpDefSUN.UnitId_from, tmpDefSUN.UnitId_to, tmpDefSUN.GoodsId
                              HAVING COUNT (*) = 2
                             )
            -- ���������
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
         -- 6.2.2. !!!���� ������� ������ - DefSUN!!!
         IF EXISTS (SELECT 1 FROM _tmpList_DefSUN)
         THEN
             -- ����� �� 2-� ���� ��� ����������� �� ����� !!!
             PERFORM lpInsert_Movement_Send_RemainsSun (inOperDate:= inOperDate
                                                      , inDriverId:= inDriverId
                                                      , inStep    := 2
                                                      , inUserId  := inUserId
                                                       );
         END IF;

     END IF;

raise notice 'Value 25: %', CLOCK_TIMESTAMP();

     IF inStep = 2
     THEN
         -- !!!�����!!!
         RETURN;
     END IF;


     -- 7.1. ������������ ����������� - �� ������� �� �������
     -- CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     --
     -- !!!�.�. ����� ����������� - ����������� ����� ������!!!
     -- ������1 - �������� �����������
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
     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curResult_partion INTO vbMovementId, vbUnitId_from, vbUnitId_to, vbParentId, vbGoodsId, vbAmount;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         -- ������2. - ������� ����� ������� ��� ������������ ��� vbUnitId_from + vbGoodsId
         OPEN curRemains FOR
            SELECT _tmpRemains_Partion_all.ContainerId, _tmpRemains_Partion_all.Amount - COALESCE (tmp.Amount, 0)
            FROM _tmpRemains_Partion_all
                 LEFT JOIN (SELECT _tmpResult_child.ContainerId, SUM (_tmpResult_child.Amount) AS Amount FROM _tmpResult_child GROUP BY _tmpResult_child.ContainerId
                           ) AS tmp ON tmp.ContainerId = _tmpRemains_Partion_all.ContainerId
            WHERE _tmpRemains_Partion_all.UnitId  = vbUnitId_from
              AND _tmpRemains_Partion_all.GoodsId = vbGoodsId
              AND _tmpRemains_Partion_all.Amount - COALESCE (tmp.Amount, 0) > 0
              -- !!!������ ���� ������ �� �������, �.�. �� 100 ����!!!
              AND _tmpRemains_Partion_all.ContainerDescId = zc_Container_CountPartionDate()
            -- ������� � "�������" �����
            -- ORDER BY _tmpRemains_Partion_all.ExpirationDate DESC, _tmpRemains_Partion_all.ContainerId
            -- ������� � "������" �����
            ORDER BY _tmpRemains_Partion_all.ExpirationDate ASC, _tmpRemains_Partion_all.ContainerId
           ;
         -- ������ ����� �� �������2. - �������
         LOOP
             -- ������ �� ��������
             FETCH curRemains INTO vbContainerId, vbAmount_remains;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             --
             IF vbAmount_remains > vbAmount
             THEN
                 -- ���������� � �������� ������ ��� ������
                 INSERT INTO _tmpResult_child (MovementId, UnitId_from, UnitId_to, ParentId, ContainerId, GoodsId, Amount)
                    SELECT vbMovementId, vbUnitId_from, vbUnitId_to, vbParentId, vbContainerId, vbGoodsId, vbAmount;

                 -- �������� ���-�� ����� ������ �� ������
                 vbAmount:= 0;
             ELSE
                 -- ���������� � �������� ������ ��� ������
                 INSERT INTO _tmpResult_child (MovementId, UnitId_from, UnitId_to, ParentId, ContainerId, GoodsId, Amount)
                    SELECT vbMovementId, vbUnitId_from, vbUnitId_to, vbParentId, vbContainerId, vbGoodsId, vbAmount_remains;

                 -- ��������� �� ���-�� ������� ����� � ���������� �����
                 vbAmount:= vbAmount - vbAmount_remains;
             END IF;

         END LOOP; -- ����� ����� �� �������2. - �������
         CLOSE curRemains; -- ������� ������2. - �������

     END LOOP; -- ����� ����� �� �������1 - �����������
     CLOSE curResult_partion; -- ������� ������1 - �����������

raise notice 'Value 26: %', CLOCK_TIMESTAMP();

/*
!!!
     -- 7.2. ������� ������ Child - �� ���
     PERFORM lpInsertUpdate_MovementItem_Send_Child (ioId         := 0
                                                   , inParentId   := _tmpResult_child.ParentId
                                                   , inMovementId := _tmpResult_child.MovementId
                                                   , inGoodsId    := _tmpResult_child.GoodsId
                                                   , inAmount     := _tmpResult_child.Amount
                                                   , inContainerId:= _tmpResult_child.ContainerId
                                                   , inUserId     := inUserId
                                                    )
     FROM _tmpResult_child;


     -- 8. ������� ���������, ��� � �� ������
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := inUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Partion.MovementId FROM _tmpResult_Partion WHERE _tmpResult_Partion.MovementId > 0
          ) AS tmp;
*/

     -- ���������
     RETURN QUERY
       SELECT Object_Unit.Id          AS UnitId
            , Object_Unit.ValueData   AS UnitName
            , Object_Goods.Id         AS GoodsId
            , Object_Goods_Main.ObjectCode AS GoodsCode
            , Object_Goods_Main.Name       AS GoodsName
            , Object_Goods_Main.isClose    AS isClose
              -- �������
            , _tmpSale.Amount AS Amount_sale
            , _tmpSale.Summ   AS Summ_sale
              -- ����� �������� �� �������� ��������, ������ ��������� � AmountSun_summ_save
            , _tmpRemains_calc.AmountSun_real
            , _tmpRemains_calc.AmountSun_summ_save
              -- ����� �������� ������� ����� ������������
            , _tmpRemains_calc.AmountSun_summ
            , tmpRemains_Partion_sum.Amount_sun     :: TFloat AS AmountSunOnly_summ
            , tmpRemains_Partion_sum.Amount_notSold :: TFloat AS Amount_notSold_summ
              -- ���������
            , _tmpRemains_calc.AmountResult
              -- ����� ��������� �� ���� �������
            , tmpRemains_sum.AmountResult        :: TFloat AS AmountResult_summ
              --
            , _tmpRemains_calc.AmountRemains
            , _tmpRemains_calc.AmountIncome
            , _tmpRemains_calc.AmountSend_in
            , _tmpRemains_calc.AmountSend_out
            , _tmpRemains_calc.AmountOrderExternal
            , _tmpRemains_calc.AmountReserve
              -- �������� �� ���� ������, ����� ����������� � ������ ����� �� �����, �.�. ���� ��������� �� ���������
            , _tmpRemains_calc.AmountSun_unit
            , _tmpRemains_calc.AmountSun_unit_save
              -- ����
            , _tmpRemains_calc.Price
              -- ���
            , _tmpRemains_calc.MCS
            , _tmpGoods_Layout.Layout
            , _tmpGoods_PromoUnit.Amount
              -- ����� ���
            , _tmpRemains_all.isCloseMCS

              -- ������������ - "��������" �������� �����
            , tmpSumm.Summ_min   :: TFloat AS Summ_min
              -- ������������ - "��������" ���������� �����
            , tmpSumm.Summ_max   :: TFloat AS Summ_max
              -- ������������ - "��������"���-�� ����� ����.
            , tmpSumm.Unit_count :: TFloat AS Unit_count

              -- ������������ - ����� �������������-1: �������� �����
            , tmpSumm_res1.Summ_min   :: TFloat AS Summ_min_1
              -- ������������ - ����� �������������-1: ���������� �����
            , tmpSumm_res1.Summ_max   :: TFloat AS Summ_max_1
              -- ������������ - ����� �������������-1: ���-�� ����� ����.
            , tmpSumm_res1.Unit_count :: TFloat AS Unit_count_1

              -- ������������ - ����� �������������-1: �������� �����
            , tmpSumm_res2.Summ_next_min :: TFloat AS Summ_min_2
              -- ������������ - ����� �������������-1: ���������� �����
            , tmpSumm_res2.Summ_next_max :: TFloat AS Summ_max_2
              -- ������������ - ����� �������������-1: ���-�� ����� ����.
            , tmpSumm_res2.Unit_count    :: TFloat AS Unit_count_2

            , tmpSumm_res1_2.Summ_str      :: TVarChar AS Summ_str
            , tmpSumm_res2_2.Summ_next_str :: TVarChar AS Summ_next_str

            , tmpSumm_res1_3.UnitName_str      :: TVarChar AS UnitName_str
            , tmpSumm_res2_3.UnitName_next_str :: TVarChar AS UnitName_next_str

            -- !!!���������!!!
            , tmpSumm_res.Amount         :: TFloat AS Amount_res
            , tmpSumm_res.Summ           :: TFloat AS Summ_res
            , tmpSumm_res.Amount_next    :: TFloat AS Amount_next_res
            , tmpSumm_res.Summ_next      :: TFloat AS Summ_next_res
            , tmpSumm_res.Amount_not_out :: TFloat AS Amount_not_out_res
            , tmpSumm_res.Summ_not_out   :: TFloat AS Summ_not_out_res
            , tmpSumm_res.Amount_not_in  :: TFloat AS Amount_not_in_res
            , tmpSumm_res.Summ_not_in    :: TFloat AS Summ_not_in_res

            , Movement_Layout.InvNumber                  AS InvNumberLayout
            , Object_Layout.ValueData                    AS LayoutName

       FROM _tmpRemains_calc
            -- �������� ������ ��, ��� ���� �����������
            INNER JOIN (SELECT DISTINCT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId FROM _tmpResult_Partion
                       ) AS _tmpResult ON _tmpResult.UnitId_to = _tmpRemains_calc.UnitId
                                      AND _tmpResult.GoodsId   = _tmpRemains_calc.GoodsId
            -- ?��������? ������ ��, ���� ����� ����������� "��������" ������ ������
            LEFT JOIN (SELECT _tmpSumm_limit.UnitId_to, MIN (_tmpSumm_limit.Summ) AS Summ_min, MAX (_tmpSumm_limit.Summ) AS Summ_max, COUNT(*) AS Unit_count FROM _tmpSumm_limit
                       --!!! WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                       WHERE _tmpSumm_limit.Summ > 0
                       GROUP BY _tmpSumm_limit.UnitId_to
                      ) AS tmpSumm ON tmpSumm.UnitId_to = _tmpRemains_calc.UnitId
             -- ����� �������� + notSold ������� ����� ������������
             LEFT JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.Amount_sun) AS Amount_sun, SUM (_tmpRemains_Partion.Amount_notSold) AS Amount_notSold
                        FROM _tmpRemains_Partion
                        GROUP BY _tmpRemains_Partion.GoodsId
                       ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains_calc.GoodsId
            -- !!!���������!!!
            LEFT JOIN (-- ������� � 1 �����������
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

            -- !!!���������!!!
            -- ����� �������������-1, ����� ����������� ������ ������
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, MIN (tmpSumm_res1.Summ) AS Summ_min, MAX (tmpSumm_res1.Summ) AS Summ_max, COUNT(*) AS Unit_count
                       FROM (-- ������� � 1 �����������
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ) AS Summ FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
                            ) AS tmpSumm_res1
                       -- !!!������ ������
                       --!!!WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1 ON tmpSumm_res1.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!���������!!!
            -- ����� �������������-2, ����� ����������� ��� ������
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, MIN (tmpSumm_res1.Summ_next) AS Summ_next_min, MAX (tmpSumm_res1.Summ_next) AS Summ_next_max, COUNT(*) AS Unit_count
                       FROM (-- ������� � 1 �����������
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ_next) AS Summ_next FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount_next > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
                            ) AS tmpSumm_res1
                       -- !!!��� ������
                       -- WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res2 ON tmpSumm_res2.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!���������-2.1.!!!
            -- ����� �������������-1, ����� ����������� ������ ������
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (zfConvert_FloatToString (tmpSumm_res1.Summ), ';') AS Summ_str
                       FROM (-- ������� � 1 �����������
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ) AS Summ FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to ORDER BY 3 DESC
                            ) AS tmpSumm_res1
                       -- !!!������ ������
                       --!!!WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1_2 ON tmpSumm_res1_2.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!���������-2.1.!!!
            -- ����� �������������-2, ����� ����������� ��� ������
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (zfConvert_FloatToString (tmpSumm_res1.Summ_next), ';') AS Summ_next_str
                       FROM (-- ������� � 1 �����������
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ_next) AS Summ_next FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount_next > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to ORDER BY 3 DESC
                            ) AS tmpSumm_res1
                       -- !!!��� ������
                       -- WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res2_2 ON tmpSumm_res2_2.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!���������-2.2.!!!
            -- ����� �������������-1, ����� ����������� ������ ������
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (Object.ValueData, ';') AS UnitName_str
                       FROM (-- ������� � 1 �����������
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ) AS Summ FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to ORDER BY 3 DESC
                            ) AS tmpSumm_res1
                            LEFT JOIN Object ON Object.Id = tmpSumm_res1.UnitId_from
                       -- !!!������ ������
                       --!!!WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1_3 ON tmpSumm_res1_3.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!���������-2.2.!!!
            -- ����� �������������-2, ����� ����������� ��� ������
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (Object.ValueData, ';') AS UnitName_next_str
                       FROM (-- ������� � 1 �����������
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ_next) AS Summ_next FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount_next > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to ORDER BY 3 DESC
                            ) AS tmpSumm_res1
                            LEFT JOIN Object ON Object.Id = tmpSumm_res1.UnitId_from
                       -- !!!��� ������
                       -- WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res2_3 ON tmpSumm_res2_3.UnitId_to = _tmpRemains_calc.UnitId
            --
            --
            LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains_calc.UnitId
            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = _tmpRemains_calc.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
            -- ����� ��������� �� ���� �������
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

            LEFT JOIN Movement AS Movement_Layout ON Movement_Layout.Id = _tmpGoods_Layout.MovementLayoutId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Layout
                                         ON MovementLinkObject_Layout.MovementId = Movement_Layout.Id
                                        AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
            LEFT JOIN Object AS Object_Layout ON Object_Layout.Id = MovementLinkObject_Layout.ObjectId

-- ���� ��� ����
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

raise notice 'Value 27: %', CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.19         *
 18.07.19                                        *
*/
/*
-- !!!��������� ���������� ����!!!
SELECT Movement.*
FROM Movement
     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 and MovementLinkObject_Unit.ObjectId = 375626 -- ������_1 ��_������_40
     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  and MovementItem.ObjectId = 40183 -- ��������� ����� 1�� N1
WHERE Movement.OperDate  >= '01.01.2019'
  AND Movement.DescId   = zc_Movement_Check()
  AND Movement.StatusId in (  zc_Enum_Status_Erased())
*/
-- ����
/*
     -- ��� ������������� ��� ����� SUN
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     CREATE TEMP TABLE _tmpUnit_SUN_balance (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_partion (UnitId Integer, Summ_out TFloat, Summ_in TFloat, Summ_out_calc TFloat, Summ_in_calc TFloat) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. ��� ���������� ������
     CREATE TEMP TABLE _tmpSale   (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     -- 2.2. ������ ��� ���������
     CREATE TEMP TABLE _tmpGoods_SUN (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;
     -- 2.3. "���� ������ � ���"... ���� � ����� �� ����� ��� ������������ ����� X, �� � ������������ ������� ������ ������������ ����� Y � ��� �� ����������
     CREATE TEMP TABLE _tmpGoods_SUN_PairSun (GoodsId Integer, GoodsId_PairSun Integer) ON COMMIT DROP;

     -- 3.1. ��� �������, ����
     CREATE TEMP TABLE _tmpRemains_Partion_all (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     -- 3.2. �������, ���� - ��� �������������
     CREATE TEMP TABLE _tmpRemains_Partion (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;


     -- 4. ������� �� ������� ���� ��������� � ����
     CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer, Amount_not_out TFloat, Summ_not_out TFloat, Amount_not_in TFloat, Summ_not_in TFloat) ON COMMIT DROP;
     -- 6.2. !!!������ - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     CREATE TEMP TABLE _tmpList_DefSUN (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. ������������ ����������� - �� ������� �� �������
     CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 8. ��������� ����� �����������
     CREATE TEMP TABLE _tmpUnit_SunExclusion (UnitId_from Integer, UnitId_to Integer, isMCS_to Boolean) ON COMMIT DROP;

 SELECT * FROM lpInsert_Movement_Send_RemainsSun (inOperDate:= CURRENT_DATE + INTERVAL '5 DAY', inDriverId:= (SELECT MAX (OL.ChildObjectId) FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Driver()), inStep:= 1, inUserId:= 3) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
*/

select * from gpReport_Movement_Send_RemainsSun(inOperDate := ('20.02.2023')::TDateTime ,  inSession := '3');