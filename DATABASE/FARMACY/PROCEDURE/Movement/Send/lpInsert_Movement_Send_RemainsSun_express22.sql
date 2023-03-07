-- Function: lpInsert_Movement_Send_RemainsSun_express

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_express22 (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_express22(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inDriverId            Integer   , -- ��������, ������������ ������ �� ������� �����
    IN inStep                Integer   , -- �� 1-�� ���� ������� DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� �� 2-� ���� ��� ����������� �� ����� !!!
    IN inUserId              Integer     -- ������������
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount_sale         TFloat -- ���-�� ������� � ���������� (���������� �� �*24 �����)
             , Summ_sale           TFloat -- �����  ������� � ���������� (���������� �� �*24 �����)
           --, AmountSun_real      TFloat -- ***����� �������� �� �������� ��������, ������ ��������� � AmountSun_summ_save
           --, AmountSun_summ_save TFloat -- ***����� ��������, ��� ����� ���������
             , AmountSun_summ      TFloat -- ����� ���-�� ��� ������������� �� ���� ������ ������������
           --, AmountSunOnly_summ  TFloat -- ***����� ��������, ������� ����� ������������
           --, Amount_notSold_summ TFloat -- ***����� notSold, ������� ����� ������������

             , AmountResult        TFloat -- ����������� � ����� ����������
             , AmountResult_summ   TFloat -- ����� ����������� � ���� ����� ����������� --���
             , AmountRemains       TFloat -- �������
             , AmountRemains_calc  TFloat -- �������
             , AmountIncome        TFloat -- ������ (���������) --���
             , AmountSend_in       TFloat -- ����������� - ������ (���������) --���
             , AmountSend_out      TFloat -- ����������� - ������ (���������) --���
             , AmountOrderExternal TFloat -- ����� (���������) --���
             , AmountReserve       TFloat -- ������ �� ����� --���
           --, AmountSun_unit      TFloat -- ***���.=0, �������� �� ���� ������, ����� ����������� � ������ ����� �� �����, �.�. ���� ��������� �� ���������
           --, AmountSun_unit_save TFloat -- ***���.=0, �������� �� ���� ������, ��� ����� ���������
             , Price               TFloat -- ����
             , MCS                 TFloat -- ���
             , Summ_min            TFloat -- ������������ - �������� �����
             , Summ_max            TFloat -- ������������ - ���������� �����
             , Unit_count          TFloat -- ������������ - ���-�� ����� ����.
             , Summ_min_1          TFloat -- ������������ - ����� �������������-1: �������� �����
             , Summ_max_1          TFloat -- ������������ - ����� �������������-1: ���������� �����
             , Unit_count_1        TFloat -- ������������ - ����� �������������-1: ���-�� ����� ����.
           --, Summ_min_2          TFloat -- ***������������ - ����� �������������-2: �������� �����
           --, Summ_max_2          TFloat -- ***������������ - ����� �������������-2: ���������� �����
           --, Unit_count_2        TFloat -- ***������������ - ����� �������������-2: ���-�� ����� ����.
             , Summ_str            TVarChar --
           --, Summ_next_str       TVarChar -- ***
             , UnitName_str        TVarChar
           --, UnitName_next_str   TVarChar -- ***
               -- !!!���������!!!
             , Amount_res          TFloat   -- ���-�� ������������ - ����������� ������
             , Summ_res            TFloat   -- ����� ������������ - ����������� ������
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

   DECLARE vbDOW_curr        TVarChar;

BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);



     -- !!!
     vbSumm_limit:= CASE WHEN 0 < (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                              THEN 0 -- (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                         ELSE 0 -- 1500
                    END;

    -- ���� + 6 �������
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

     -- ��� ������������� ��� ����� SUN-v2
     DELETE FROM _tmpUnit_SUN;
     DELETE FROM _tmpGoods_DiscountExternal;
     -- 1. ��� �������, ������� => �������� ��� ���-�� EXPRESS
     DELETE FROM _tmpRemains_all;
     DELETE FROM _tmpRemains;
     -- 2.1. ��� ���������� ������ - express: 1) � �����������  2) � ����������
     DELETE FROM _tmpSale_express;
     -- 2.3. ��� ������ ��� ���������� ������ - express + ���������
     DELETE FROM _tmpGoods_SUN;
     -- 3.2. �������, EXPRESS - ��� �������������
     DELETE FROM _tmpRemains_Partion;
     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     DELETE FROM _tmpSumm_limit;
     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� �� ������ >= vbSumm_limit
     DELETE FROM _tmpResult_Partion;


     -- ���� ������
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;


     -- ��� ������������� ��� ����� SUN-v3
     INSERT INTO _tmpUnit_SUN (UnitId, KoeffInSUN, KoeffOutSUN)
        SELECT OB.ObjectId AS UnitId
               -- ���� ��������� ������ ���������� - ������������ ������
             , CASE WHEN COALESCE (OF_KoeffInSUN.ValueData, 0) = 0  THEN 1 ELSE OF_KoeffInSUN.ValueData  END AS KoeffInSUN
               -- ���� ��������� ������ ����������� - ������������ ������
             , CASE WHEN COALESCE (OF_KoeffOutSUN.ValueData, 0) = 0 THEN 1 ELSE OF_KoeffOutSUN.ValueData END AS KoeffOutSUN
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectFloat  AS OF_KoeffInSUN  ON OF_KoeffInSUN.ObjectId  = OB.ObjectId AND OF_KoeffInSUN.DescId  = zc_ObjectFloat_Unit_KoeffInSUN_v3()
             LEFT JOIN ObjectFloat  AS OF_KoeffOutSUN ON OF_KoeffOutSUN.ObjectId = OB.ObjectId AND OF_KoeffOutSUN.DescId = zc_ObjectFloat_Unit_KoeffOutSUN_v3()
        WHERE (OB.ValueData = TRUE
          --OR OB.ObjectId in (183292, 9771036) -- select * from object where Id in (183292, 9771036)
              )
          AND OB.DescId = zc_ObjectBoolean_Unit_SUN_v3()
          -- ���� ������ ���� ������ - �������� ���
        --AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = '')
    /*  UNION 
        SELECT Object.Id AS UnitId
               -- ���� ��������� ������ ���������� - ������������ ������
             , CASE WHEN COALESCE (OF_KoeffInSUN.ValueData, 0) = 0  THEN 1 ELSE OF_KoeffInSUN.ValueData  END AS KoeffInSUN
               -- ���� ��������� ������ ����������� - ������������ ������
             , CASE WHEN COALESCE (OF_KoeffOutSUN.ValueData, 0) = 0 THEN 1 ELSE OF_KoeffOutSUN.ValueData END AS KoeffOutSUN
        FROM Object
             LEFT JOIN ObjectFloat  AS OF_KoeffInSUN  ON OF_KoeffInSUN.ObjectId  = Object.Id AND OF_KoeffInSUN.DescId  = zc_ObjectFloat_Unit_KoeffInSUN_v3()
             LEFT JOIN ObjectFloat  AS OF_KoeffOutSUN ON OF_KoeffOutSUN.ObjectId = Object.Id AND OF_KoeffOutSUN.DescId = zc_ObjectFloat_Unit_KoeffOutSUN_v3()
        WHERE Object.DescId = zc_Object_Unit()
          -- ���� ������ ���� ������ - �������� ���
        --AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = '')
      */  
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

     -- ��� ������ ��� ����� SUN-v3 + ���������
     INSERT INTO _tmpGoods_SUN (GoodsId, KoeffSUN)
        SELECT OB.ObjectId AS GoodsId
               -- ��������� �� �-���  
             , CASE WHEN COALESCE (OF_KoeffSUN.ValueData, 0) = 0  THEN 1 ELSE OF_KoeffSUN.ValueData  END AS KoeffSUN
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectFloat AS OF_KoeffSUN ON OF_KoeffSUN.ObjectId = OB.ObjectId AND OF_KoeffSUN.DescId = zc_ObjectFloat_Goods_KoeffSUN_v3()
        WHERE (OB.ValueData = TRUE
          --OR OB.ObjectId in (183292, 9771036) -- select * from object where Id in (183292, 9771036)
              )
          AND OB.DescId = zc_ObjectBoolean_Goods_SUN_v3()
      /*UNION
        SELECT Object.Id AS GoodsId
               -- ��������� �� �-���  
             , CASE WHEN COALESCE (OF_KoeffSUN.ValueData, 0) = 0  THEN 1 ELSE OF_KoeffSUN.ValueData  END AS KoeffSUN
        FROM Object
             LEFT JOIN ObjectFloat AS OF_KoeffSUN ON OF_KoeffSUN.ObjectId = Object.Id AND OF_KoeffSUN.DescId = zc_ObjectFloat_Goods_KoeffSUN_v3()
        WHERE Object.DescId = zc_Object_Goods()
        --AND Object.ValueData ILIKE '����� �����%'
        and Object.ObjectCode = 1054 --1163
       */
       ;


     -- 1.1. ��� ���������� ������
     -- CREATE TEMP TABLE _tmpSale_express (DayOrd Integer, DayOrd_real Integer, UnitId Integer, GoodsId Integer, Amount TFloat, Amount_sum TFloat, Summ TFloat) ON COMMIT DROP;
     INSERT INTO _tmpSale_express (DayOrd, DayOrd_real, UnitId, GoodsId, Amount, Amount_sum, Summ, Summ_sum)
        SELECT ROW_NUMBER() OVER (PARTITION BY tmp.UnitId, tmp.GoodsId ORDER BY tmp.DayOrd ASC) AS DayOrd
             , tmp.DayOrd
             , tmp.UnitId
             , tmp.GoodsId
               -- �� 32 ���
             , tmp.Amount
               -- ������������ � 1 �� 32 ���
             , SUM (tmp.Amount) OVER (PARTITION BY tmp.UnitId, tmp.GoodsId ORDER BY tmp.DayOrd ASC) AS Amount_sum
               -- �� 32 ���
             , tmp.Summ
               -- ������������ � 1 �� 32 ���
             , SUM (tmp.Summ)   OVER (PARTITION BY tmp.UnitId, tmp.GoodsId ORDER BY tmp.DayOrd ASC) AS Summ_sum
        FROM 
       (SELECT tmp.DayOrd
             , tmp.UnitId
             , tmp.GoodsId
               -- �� 32 ���
             , tmp.Amount
             , tmp.Summ
        FROM (SELECT MIContainer.WhereObjectId_analyzer                                                      AS UnitId
                   , MIContainer.ObjectId_analyzer                                                           AS GoodsId
                   , SUM (COALESCE (-1 * MIContainer.Amount, 0))                                             AS Amount
                   , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0))            AS Summ
                   , DATE_PART ('DAY', AGE (inOperDate :: TIMESTAMP, MIContainer.OperDate :: TIMESTAMP)) + 1 AS DayOrd
              FROM MovementItemContainer AS MIContainer
                   -- !!!������ ��� ����� �����!!!
                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MIContainer.WhereObjectId_analyzer
                   -- !!!������ ��� ����� �������!!!
                   INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = MIContainer.ObjectId_analyzer
              WHERE MIContainer.DescId         = zc_MIContainer_Count()
                AND MIContainer.MovementDescId = zc_Movement_Check()
                AND MIContainer.OperDate BETWEEN inOperDate - INTERVAL '32 DAY' AND inOperDate
              GROUP BY MIContainer.ObjectId_analyzer
                     , MIContainer.WhereObjectId_analyzer
                     , DATE_PART ('DAY', AGE (inOperDate :: TIMESTAMP, MIContainer.OperDate :: TIMESTAMP))
              HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
             ) AS tmp
       ) AS tmp
       ;


     -- 2.1. ��� �������, ������� => ������ ���-�� ����������� � ����������
     WITH -- ������ - UnComplete - �� ��������� +/-7 ���� ��� Date_Branch
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
                                -- !!!������ ��� ����� �����!!!
                                INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_To.ObjectId
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                -- !!!������ ��� ����� �������!!!
                                INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = MovementItem.ObjectId
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
                                 -- ����� ������� - ��������� "������������" ������� - ��� � ������� ����� "������" ������ - ��� �����
                                 LEFT JOIN MovementBoolean AS MB_SUN_v3
                                                           ON MB_SUN_v3.MovementId = Movement.Id
                                                          AND MB_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                                          AND MB_SUN_v3.ValueData  = TRUE
                                                          AND Movement.OperDate    >= inOperDate
                                 -- !!!������ ��� ����� �������!!!
                                 INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = MovementItem.ObjectId
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '30 DAY' AND Movement.OperDate < inOperDate + INTERVAL '30 DAY'
                           -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           -- AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
                              AND MB_SUN_v3.MovementId IS NULL
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
                                 -- ����� ������� - ��������� "������������" ������� - ��� � ������� ����� "������" ������ - ��� �����
                                 LEFT JOIN MovementBoolean AS MB_SUN_v3
                                                           ON MB_SUN_v3.MovementId = Movement.Id
                                                          AND MB_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                                          AND MB_SUN_v3.ValueData  = TRUE
                                                          AND Movement.OperDate    >= inOperDate
                                 -- !!!������ ��� ����� �������!!!
                                 INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = MovementItem.ObjectId
                         -- WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                            WHERE Movement.OperDate >= inOperDate - INTERVAL '14 DAY' AND Movement.OperDate < inOperDate + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              AND MovementBoolean_Deferred.MovementId IS NULL
                              AND MB_SUN_v3.MovementId IS NULL
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
                                       INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MovementLinkObject_Unit.ObjectId
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                              AND MovementItem.DescId     = zc_MI_Master()
                                                              AND MovementItem.isErased   = FALSE

                                       -- !!!������ ��� ����� �������!!!
                                       INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = MovementItem.ObjectId
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
          -- ���������� ���� + �� ����������� � CommentError
        , tmpMI_Reserve AS (SELECT tmpMovementCheck.UnitId
                                 , MovementItem.ObjectId     AS GoodsId
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM tmpMovementCheck
                                 INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementCheck.MovementId
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                                 -- !!!������ ��� ����� �������!!!
                                 INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = MovementItem.ObjectId

                            GROUP BY tmpMovementCheck.UnitId, MovementItem.ObjectId
                           )
          -- �������
        , tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (Container.Amount, 0)) AS Amount
                         FROM Container
                              -- !!!������ ��� ����� �����!!!
                              INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = Container.WhereObjectId
                              -- !!!������ ��� ����� �������!!!
                              INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = Container.ObjectId

                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
    -- ����
  , tmpObject_Price AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                             , OL_Price_Goods.ChildObjectId      AS GoodsId
                             , ROUND (Price_Value.ValueData, 2)  AS Price
                             , MCS_Value.ValueData               AS MCSValue
                        FROM ObjectLink AS OL_Price_Unit
                             -- !!!������ ��� ����� �����!!!
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
                             -- !!!������ ��� ����� �������!!!
                             INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = OL_Price_Goods.ChildObjectId
                             LEFT JOIN ObjectFloat AS Price_Value
                                                   ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                  AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                             LEFT JOIN ObjectFloat AS MCS_Value
                                                   ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                  AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                        WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        --AND COALESCE (MCS_isClose.ValueData, FALSE) = FALSE
                       )
     -- 2.1. ���������: EXPRESS - ��� �������, ������� => ������ ���-�� ����������� � ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains_all (UnitId, GoodsId, Price, MCS, Amount_sale, Summ_sale
                                 , AmountResult_in, AmountResult_out
                                 , AmountRemains, AmountRemains_calc_in, AmountRemains_calc_out
                                 , AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)

        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue

               -- ������� � �����������/���������� (���������� �� �*24 ����� - ������������) 
             , COALESCE (_tmpSale_express.Amount_sum, 0) AS Amount_sale
             , COALESCE (_tmpSale_express.Summ_sum, 0)   AS Summ_sale

               -- ����������� � ����������, EXPRESS
             , CASE WHEN 0 < FLOOR (-- ������� - ���������� �� �*24 �����
                                    (COALESCE (_tmpSale_express.Amount_sum, 0)
                                     -- ����� �������
                                   - CASE WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) 
                                            - COALESCE (tmpMI_Send_out.Amount, 0)
                                              + COALESCE (tmpMI_Send_in.Amount, 0)
                                              + COALESCE (tmpMI_Income.Amount, 0)
                                              + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                               ) > 0
                                          THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) 
                                            - COALESCE (tmpMI_Send_out.Amount, 0)
                                              + COALESCE (tmpMI_Send_in.Amount, 0)
                                              + COALESCE (tmpMI_Income.Amount, 0)
                                              + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                               )
                                          ELSE 0
                                     END)
                                    -- ����� �� ���������
                                    / _tmpGoods_SUN.KoeffSUN
                                   ) * _tmpGoods_SUN.KoeffSUN
                        THEN FLOOR (-- ������� - ���������� �� �*24 �����
                                    (COALESCE (_tmpSale_express.Amount_sum, 0)
                                     -- ����� �������
                                   - CASE WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) 
                                            - COALESCE (tmpMI_Send_out.Amount, 0)
                                              + COALESCE (tmpMI_Send_in.Amount, 0)
                                              + COALESCE (tmpMI_Income.Amount, 0)
                                              + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                               ) > 0
                                          THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) 
                                            - COALESCE (tmpMI_Send_out.Amount, 0)
                                              + COALESCE (tmpMI_Send_in.Amount, 0)
                                              + COALESCE (tmpMI_Income.Amount, 0)
                                              + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                               )
                                          ELSE 0
                                     END)
                                    -- ����� �� ���������
                                    / _tmpGoods_SUN.KoeffSUN
                                   ) * _tmpGoods_SUN.KoeffSUN
                        ELSE 0
               END AS AmountResult_in

               -- ������� � �����������, EXPRESS - ����� ������ � ������ ���������
             , CASE WHEN 0 < FLOOR (-- �������
                                    (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) - COALESCE (tmpMI_Send_out.Amount, 0)
                                     -- ����� ������� - ���������� �� �*24 �����
                                   - COALESCE (_tmpSale_express.Amount_sum, 0)
                                    )
                                    -- ����� �� ���������
                                    / _tmpGoods_SUN.KoeffSUN
                                   ) * _tmpGoods_SUN.KoeffSUN
                        THEN FLOOR (-- �������
                                    (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) - COALESCE (tmpMI_Send_out.Amount, 0)
                                     -- ����� ������� - ���������� �� �*24 �����
                                   - COALESCE (_tmpSale_express.Amount_sum, 0)
                                    )
                                    -- ����� �� ���������
                                    / _tmpGoods_SUN.KoeffSUN
                                   ) * _tmpGoods_SUN.KoeffSUN
                        ELSE 0
               END AS AmountResult_out

               -- ������� ��� �������������
             , COALESCE (tmpRemains.Amount, 0)           AS AmountRemains

               -- ������� - ������ - ��� ����������
             , COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) - COALESCE (tmpMI_Send_out.Amount, 0)
             + COALESCE (tmpMI_Send_in.Amount, 0)
             + COALESCE (tmpMI_Income.Amount, 0)
             + COALESCE (tmpMI_OrderExternal.Amount, 0) 
               AS AmountRemains_calc_in

               -- ������� - ������ - ��� �����������
             , COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0) - COALESCE (tmpMI_Send_out.Amount, 0)
               AS AmountRemains_calc_out

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

        FROM tmpObject_Price
             -- �������� �� ��� - ������ ��������
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_out
                                     ON OB_Unit_SUN_out.ObjectId  = tmpObject_Price.UnitId
                                    AND OB_Unit_SUN_out.DescId    = zc_ObjectBoolean_Unit_SUN_v3_out()
                                    AND OB_Unit_SUN_out.ValueData = TRUE

             LEFT JOIN _tmpUnit_SUN  ON _tmpUnit_SUN.UnitId    = tmpObject_Price.UnitId
             LEFT JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId  = tmpObject_Price.GoodsId

             LEFT JOIN _tmpSale_express AS _tmpSale_express
                                        ON _tmpSale_express.UnitId  = tmpObject_Price.UnitId
                                       AND _tmpSale_express.GoodsId = tmpObject_Price.GoodsId
                                       AND _tmpSale_express.DayOrd  = _tmpUnit_SUN.KoeffInSUN

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
             -- ��������� !!��������!!
           --INNER JOIN Object_Goods_View ON Object_Goods_View.Id      = tmpObject_Price.GoodsId
           --                            AND Object_Goods_View.IsClose = FALSE
             -- ��������� !!���������!!
           --INNER JOIN Object AS Object_Goods ON Object_Goods.Id        = tmpObject_Price.GoodsId
           --                                 AND Object_Goods.ValueData NOT ILIKE '���%'

        WHERE OB_Unit_SUN_out.ObjectId IS NULL
          AND _tmpGoods_SUN.KoeffSUN > 0
       ;
     -- 2.2. ���������: ��� �������, ������� => �������� ���-�� ����������� � ����������
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, AmountResult)
        SELECT _tmpRemains_all.UnitId, _tmpRemains_all.GoodsId, _tmpRemains_all.Price, _tmpRemains_all.AmountResult_in
        FROM _tmpRemains_all
        -- !!!������ � ����� AmountResult!!!
        WHERE _tmpRemains_all.AmountResult_in > 0.0
       ;


     -- 3.1. �������, EXPRESS (����� ������ � ������ ���������) - ��� �������������
     WITH -- ��� ����� ���������� EXPRESS
             tmpExpress_all AS (SELECT *
                                FROM _tmpRemains_all
                                WHERE _tmpRemains_all.AmountResult_out > 0
                             -- WHERE 1=0
                               )
     -- ��� EXPRESS - ������� ��� ��������
   , tmpExpress_PartionDate AS (SELECT tmpExpress_all.UnitID
                                     , tmpExpress_all.GoodsID
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
                                WHERE 1=0 -- !!!�.�. ���� ��������
                              /*WHERE -- !!!�.�. ��� �������� ���������
                                      ObjectDate_PartionGoods_Value.ValueData <= vbDate_6
                                      -- !!!�.�. ��� �������� ���������
                              */
                                GROUP BY tmpExpress_all.UnitID
                                       , tmpExpress_all.GoodsID
                                HAVING SUM (Container.Amount) > 0
                               )
       -- ����������� EXPRESS - ������ - Erased - �� �������, ��� � �� ���������� ��� ������ �������� � ���-3
     , tmpMI_SUN_out AS (SELECT DISTINCT
                                MovementLinkObject_From.ObjectId AS UnitId_from
                              , MovementItem.ObjectId            AS GoodsId
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                              -- !!!������ ��� ����� �����!!!
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
                        )
                 -- ��� ��� �������� ��� NotSold
               , tmpExpress AS (SELECT tmpExpress_all.UnitID
                                     , tmpExpress_all.GoodsID
                                     , tmpExpress_all.AmountRemains
                                     , tmpExpress_all.AmountResult_out
                                FROM tmpExpress_all
                                     -- ��� ��������
                                     LEFT JOIN tmpExpress_PartionDate ON tmpExpress_PartionDate.UnitId  = tmpExpress_all.UnitID
                                                                     AND tmpExpress_PartionDate.GoodsID = tmpExpress_all.GoodsID
                                     LEFT JOIN ObjectBoolean AS OB_Unit_SUN_in
                                                             ON OB_Unit_SUN_in.ObjectId  = tmpExpress_all.UnitID
                                                            AND OB_Unit_SUN_in.DescId    = zc_ObjectBoolean_Unit_SUN_v3_in()
                                                            AND OB_Unit_SUN_in.ValueData = TRUE
                                     -- !!!����������� SUN - ������ - Erased - �� �������, ��� � �� ���������� ��� ������ �������� � ���-3
                                     LEFT JOIN tmpMI_SUN_out ON tmpMI_SUN_out.UnitId_from = tmpExpress_all.UnitID
                                                            AND tmpMI_SUN_out.GoodsId     = tmpExpress_all.GoodsId
                                WHERE -- !!!
                                      OB_Unit_SUN_in.ObjectId IS NULL
                                      -- !!!
                                  AND tmpMI_SUN_out.GoodsId IS NULL
                                      -- !!!
                                  AND tmpExpress_PartionDate.GoodsID  IS NULL
                               )
       -- ���������: ��� �������, EXPRESS - ��� �������������
       INSERT INTO _tmpRemains_Partion (UnitId, GoodsId, AmountRemains, AmountResult)
          SELECT tmpExpress.UnitId
               , tmpExpress.GoodsId
               , tmpExpress.AmountRemains
                 -- ������� - ������ ����., EXPRESS (����� ������ � ������ ���������)
               , tmpExpress.AmountResult_out AS AmountResult
          FROM tmpExpress
          -- ��������� ���-�� �� ������������
          WHERE tmpExpress.AmountResult_out > 0
         ;



     -- 5. �� ����� ����� ������� EXPRESS "�����������" ��������� �����������
     INSERT INTO _tmpSumm_limit (UnitId_from, UnitId_to, Summ)
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from
             , _tmpRemains.UnitId         AS UnitId_to
               -- ���� EXPRESS ������ ��� � �����������
             , SUM (CASE WHEN _tmpRemains_Partion.AmountResult >= _tmpRemains.AmountResult
                              -- ����� EXPRESS = �����������
                              THEN _tmpRemains.AmountResult
                              -- ����� ��������� "��������" - �.�. ������� ���� EXPRESS - � ������ ���������
                              ELSE FLOOR (_tmpRemains_Partion.AmountResult / _tmpGoods_SUN.KoeffSUN) * _tmpGoods_SUN.KoeffSUN
                    END
                  * _tmpRemains.Price
                   )
        FROM -- ������� �� ������� ���� �����������
             _tmpRemains
             -- ��� �������, EXPRESS
             INNER JOIN _tmpRemains_Partion ON _tmpRemains_Partion.GoodsId = _tmpRemains.GoodsId
             -- ��� ������ ��� ���������� ������ - express
             INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains.GoodsId
        GROUP BY _tmpRemains_Partion.UnitId
               , _tmpRemains.UnitId
       ;

     -- 6.1.1. ������������-1 ������� EXPRESS (����� �����) - �� ���� �������
     -- ������1 - ��� �������, EXPRESS (����� �����) + EXPRESS (����� �����) ��� �������������
     OPEN curPartion FOR
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from, _tmpRemains_Partion.GoodsId, _tmpRemains_Partion.AmountResult, _tmpRemains_Partion.AmountRemains, _tmpGoods_SUN.KoeffSUN
        FROM _tmpRemains_Partion
             -- �������� � �����, ��� ������ ����� ���� ������������
             INNER JOIN (SELECT _tmpSumm_limit.UnitId_from, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                         -- !!!������ ������
                       --WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                         GROUP BY _tmpSumm_limit.UnitId_from
                        ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_from = _tmpRemains_Partion.UnitId
             -- ��� ������ ��� ���������� ������ - express
             INNER JOIN _tmpGoods_SUN ON _tmpGoods_SUN.GoodsId = _tmpRemains_Partion.GoodsId
             -- ������ ��������� �����
             LEFT JOIN _tmpGoods_DiscountExternal AS _tmpGoods_DiscountExternal
                                                  ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_Partion.UnitId
                                                 AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_Partion.GoodsId
        WHERE COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
        ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
       ;
     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curPartion INTO vbUnitId_from, vbGoodsId, vbAmount, vbAmount_save, vbKoeffSUN;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         -- ������2. - ����������� ����� ������� ��� ������������ ��� vbGoodsId
         OPEN curResult FOR
            SELECT _tmpRemains.UnitId AS UnitId_to, _tmpRemains.AmountResult - COALESCE (tmp.Amount, 0) AS AmountResult, _tmpRemains.Price
            FROM _tmpRemains
                 -- ������� ��� ������ ����� �������������-1
                 LEFT JOIN (SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId, SUM (_tmpResult_Partion.Amount) AS Amount FROM _tmpResult_Partion GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                           ) AS tmp ON tmp.UnitId_to = _tmpRemains.UnitId
                                   AND tmp.GoodsId   = _tmpRemains.GoodsId
                 -- + ������ � �����, ��� ����������� - ������������
                 INNER JOIN (SELECT _tmpSumm_limit.UnitId_to, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                             WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from
                               -- !!!������ ������
                             --AND _tmpSumm_limit.Summ >= vbSumm_limit
                             GROUP BY _tmpSumm_limit.UnitId_to
                            ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_to = _tmpRemains.UnitId
                 -- ������ ��������� �����
                 LEFT JOIN _tmpGoods_DiscountExternal AS _tmpGoods_DiscountExternal
                                                      ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains.UnitId
                                                     AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains.GoodsId
            WHERE _tmpRemains.GoodsId = vbGoodsId
              AND _tmpRemains.AmountResult - COALESCE (tmp.Amount, 0) > 0
              AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
            ORDER BY --�������� � �����, ��� ����������� - ������������
                     _tmpRemains.AmountResult - COALESCE (tmp.Amount, 0) DESC
                   , tmpSumm_limit.Summ DESC
                   , _tmpRemains.UnitId
           ;
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� �����������
         LOOP
             -- ������ �� �����������
             FETCH curResult INTO vbUnitId_to, vbAmountResult, vbPrice;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             -- ���� ����������� > �������
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
                 -- ���������� � ����������� ������ ��� � ��������, �.�. ������ ���� "�������"
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, MovementId, MovementItemId)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                           -- � ������ ��������� - vbKoeffSUN
                         , FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN
                         , FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN * vbPrice
                           --
                         , 0 AS MovementId
                         , 0 AS MovementItemId
                    WHERE FLOOR (vbAmount / vbKoeffSUN) * vbKoeffSUN > 0
                   ;
                 -- �������� ���-�� ��� �� ������ �� ������
                 vbAmount     := 0;
                 vbAmount_save:= 0;
             ELSE
                 -- ���� � ��������� "�������" - ������ "��� ������� �����", �.�. ������ ��� � ������� ���� ����� ��� � 1-�� ������
                 /*IF FLOOR (vbAmountResult) <> vbAmountResult
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

                 END IF;*/
                 --
                 -- ���������� � �������� ������ ��� ����, �.�. ������ ������� ���� � ������ ������
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, MovementId, MovementItemId)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                           -- ����� ��� ��������� ������
                         , vbAmountResult
                         , vbAmountResult * vbPrice
                           --
                         , 0 AS MovementId
                         , 0 AS MovementItemId
                    WHERE vbAmountResult > 0
                   ;
                 -- ��������� �� ���-�� ������� ����� � ���������� �����
                 vbAmount     := vbAmount      - vbAmountResult;
                 vbAmount_save:= vbAmount_save - vbAmountResult;
             END IF;

         END LOOP; -- ����� ����� �� �������2
         CLOSE curResult; -- ������� ������2.

     END LOOP; -- ����� ����� �� �������1
     CLOSE curPartion; -- ������� ������1


     -- ���������
     RETURN QUERY
       WITH -- ����� Result �� ������������/�����������
            tmpSumm_res_list AS (SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ) AS Summ FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount > 0 GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to)
       -- ���������
       SELECT Object_Unit.Id          AS UnitId
            , Object_Unit.ValueData   AS UnitName
            , Object_Goods.Id         AS GoodsId
            , Object_Goods.ObjectCode AS GoodsCode
            , Object_Goods.ValueData  AS GoodsName

              -- ������� � ���������� (���������� �� �*24 �����)
            , _tmpRemains_calc.Amount_sale AS Amount_sale
            , _tmpRemains_calc.Summ_sale   AS Summ_sale

              -- ����� ���-�� ��� ������������� �� ���� ������ ������������
            , tmpRemains_Partion_sum.AmountResult :: TFloat AS AmountSun_summ

              -- ����������� � ����� ����������
            , _tmpRemains_calc.AmountResult_in    :: TFloat AS AmountResult
              -- ����� ����������� � ���� ����� ����������� --���
            , tmpRemains_sum.AmountResult         :: TFloat AS AmountResult_summ

              -- �������
            , _tmpRemains_calc.AmountRemains         AS AmountRemains
            , _tmpRemains_calc.AmountRemains_calc_in AS AmountRemains_calc

              -- ������ (���������)--���
            , _tmpRemains_calc.AmountIncome
              -- ����������� - ������ (���������)--���
            , _tmpRemains_calc.AmountSend_in
              -- ����������� - ������ (���������)--���
            , _tmpRemains_calc.AmountSend_out
              -- ����� (���������)--���
            , _tmpRemains_calc.AmountOrderExternal
              -- ������ �� ����� + �� ����������� � CommentError--���
            , _tmpRemains_calc.AmountReserve

              -- ����
            , _tmpRemains_calc.Price
              -- ���
            , _tmpRemains_calc.MCS

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

            , tmpSumm_res1_2.Summ_str      :: TVarChar AS Summ_str
            , tmpSumm_res1_3.UnitName_str  :: TVarChar AS UnitName_str

              -- !!!��������� - ������!!!
            , tmpSumm_res.Amount         :: TFloat AS Amount_res
            , tmpSumm_res.Summ           :: TFloat AS Summ_res

       FROM _tmpRemains
            INNER JOIN _tmpRemains_all AS _tmpRemains_calc
                                       ON _tmpRemains_calc.UnitId  = _tmpRemains.UnitId
                                      AND _tmpRemains_calc.GoodsId = _tmpRemains.GoodsId
            -- �������� ������ ��, ��� ���� �����������
            INNER JOIN (SELECT DISTINCT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId FROM _tmpResult_Partion
                       ) AS _tmpResult ON _tmpResult.UnitId_to = _tmpRemains_calc.UnitId
                                      AND _tmpResult.GoodsId   = _tmpRemains_calc.GoodsId

            -- ������������ - "��������" �����-�� �����
            LEFT JOIN (SELECT _tmpSumm_limit.UnitId_to, MIN (_tmpSumm_limit.Summ) AS Summ_min, MAX (_tmpSumm_limit.Summ) AS Summ_max, COUNT(*) AS Unit_count FROM _tmpSumm_limit
                       WHERE _tmpSumm_limit.Summ > 0
                       GROUP BY _tmpSumm_limit.UnitId_to
                      ) AS tmpSumm ON tmpSumm.UnitId_to = _tmpRemains_calc.UnitId

             -- ����� ���-�� ��� ������������� �� ���� ������ ������������ --���
             LEFT JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.AmountResult) AS AmountResult
                        FROM _tmpRemains_Partion
                        GROUP BY _tmpRemains_Partion.GoodsId
                       ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains_calc.GoodsId
            -- ����� ����������� � ���� ����� ����������� --���
            LEFT JOIN (SELECT _tmpRemains.GoodsId, SUM (_tmpRemains.AmountResult) AS AmountResult FROM _tmpRemains GROUP BY _tmpRemains.GoodsId
                      ) AS tmpRemains_sum ON tmpRemains_sum.GoodsId = _tmpRemains_calc.GoodsId


            -- !!!���������!!!
            LEFT JOIN (-- ������� � 1 �����������
                       SELECT _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                            , SUM (COALESCE (_tmpResult_Partion.Amount, 0))      AS Amount
                            , SUM (COALESCE (_tmpResult_Partion.Summ, 0))        AS Summ
                       FROM _tmpResult_Partion
                       GROUP BY _tmpResult_Partion.UnitId_to, _tmpResult_Partion.GoodsId
                      ) AS tmpSumm_res ON tmpSumm_res.UnitId_to = _tmpRemains_calc.UnitId
                                      AND tmpSumm_res.GoodsId   = _tmpRemains_calc.GoodsId

            -- !!!������������-1.!!!
            -- ����� �������������, ���/���� � ���-�� ������������
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, MIN (tmpSumm_res1.Summ) AS Summ_min, MAX (tmpSumm_res1.Summ) AS Summ_max, COUNT(*) AS Unit_count
                       FROM tmpSumm_res_list AS tmpSumm_res1
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1 ON tmpSumm_res1.UnitId_to = _tmpRemains_calc.UnitId

            -- !!!������������-2.1.!!!
            -- ����� �������������, ������� �����
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (zfConvert_FloatToString (tmpSumm_res1.Summ), ';') AS Summ_str
                       FROM tmpSumm_res_list AS tmpSumm_res1
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1_2 ON tmpSumm_res1_2.UnitId_to = _tmpRemains_calc.UnitId
            -- !!!������������-2.2.!!!
            -- ����� �������������, ������� �����
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, STRING_AGG (Object.ValueData, ';') AS UnitName_str
                       FROM tmpSumm_res_list AS tmpSumm_res1
                            LEFT JOIN Object ON Object.Id = tmpSumm_res1.UnitId_from
                       -- !!!������ ������
                       --!!!WHERE tmpSumm_res1.Summ >= vbSumm_limit
                       WHERE tmpSumm_res1.Summ > 0
                       GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1_3 ON tmpSumm_res1_3.UnitId_to = _tmpRemains_calc.UnitId

            --
            --
            LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains_calc.UnitId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains_calc.GoodsId

            LEFT JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId        = _tmpRemains_calc.UnitId

       -- ORDER BY Object_Goods.ObjectCode, Object_Unit.ValueData
       ORDER BY Object_Goods.ValueData, Object_Unit.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ValueData
       -- ORDER BY Object_Unit.ValueData, Object_Goods.ObjectCode
      ;

    -- RAISE EXCEPTION '<ok>';


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.04.20                                        *
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
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, isColdOutSUN Boolean) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Amount_sale TFloat, Summ_sale TFloat, AmountResult_in TFloat, AmountResult_out TFloat, AmountRemains TFloat, AmountRemains_calc_in TFloat, AmountRemains_calc_out TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains       (UnitId Integer, GoodsId Integer, Price TFloat, AmountResult TFloat) ON COMMIT DROP;

     -- 2.1. ��� ���������� ������
     CREATE TEMP TABLE _tmpSale_express   (DayOrd Integer, DayOrd_real Integer, UnitId Integer, GoodsId Integer, Amount TFloat, Amount_sum TFloat, Summ TFloat, Summ_sum TFloat) ON COMMIT DROP;
     -- 2.3. ��� ������ ��� ���������� ������ - EXPRESS + ���������
     CREATE TEMP TABLE _tmpGoods_SUN (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 3.2. �������, ���� - ��� �������������
     CREATE TEMP TABLE _tmpRemains_Partion   (UnitId Integer, GoodsId Integer, AmountRemains TFloat, AmountResult TFloat) ON COMMIT DROP;

     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. ������������-1 ������� �� ������� - �� ���� �������
     CREATE TEMP TABLE _tmpResult_Partion   (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;

 SELECT * FROM lpInsert_Movement_Send_RemainsSun_express22 (inOperDate:= CURRENT_DATE + INTERVAL '3 DAY', inDriverId:= (SELECT MAX (OL.ChildObjectId) FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Driver()), inStep:= 1, inUserId:= 3) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
*/