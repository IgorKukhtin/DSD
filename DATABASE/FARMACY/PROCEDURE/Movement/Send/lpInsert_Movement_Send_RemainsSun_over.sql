-- Function: lpInsert_Movement_Send_RemainsSun_over

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_over (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_over(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inDriverId            Integer   , -- ��������, ������������ ������ �� ������� �����
    IN inStep                Integer   , -- �� 1-�� ���� ������� DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� �� 2-� ���� ��� ����������� �� ����� !!!
    IN inUserId              Integer     -- ������������
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
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
              )
AS
$BODY$
   DECLARE vbObjectId Integer;

   DECLARE vbKoeff_over TFloat;

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
     vbKoeff_over:= 2;


     -- !!!
     vbSumm_limit:= 0;
                  /*CASE WHEN 0 < (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                              THEN (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                         ELSE 1500
                    END;*/


     -- ��� ������������� ��� ����� SUN-v2
     DELETE FROM _tmpUnit_SUN;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     IF inStep = 1 THEN DELETE FROM _tmpUnit_SUN_balance; END IF;
     -- 1. ��� �������, ������� => �������� ���-�� ����������� � ����������
     DELETE FROM _tmpRemains_all;
     DELETE FROM _tmpRemains;
     -- 2. ��� ���������� ������: 1) � ����������� � ������� T1=60 ���� 2) � ���������� � ������� T2=45
     DELETE FROM _tmpSale_over;
     -- 3.1. ��� �������, OVER (����� �����)
     DELETE FROM _tmpRemains_Partion_all;
     -- 3.2. �������, OVER (����� �����) - ��� �������������
     DELETE FROM _tmpRemains_Partion;
     -- 4. ������� �� ������� ���� ����������� � OVER
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
                  ) :: TVarChar;


     -- ��� ������������� ��� ����� SUN-v2
     -- CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_SUN (UnitId, KoeffInSUN, KoeffOutSUN)
        SELECT OB.ObjectId AS UnitId
             , 0           AS KoeffInSUN
             , 0           AS KoeffOutSUN
      --FROM ObjectBoolean AS OB WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN_v2();
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectString AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
        WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN()
          -- ���� ������ ���� ������ - �������� ���
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = '')
       ;

       
     -- 1. ��� ���������� ������: 1) � ����������� � ������� T1=60 ���� 2) � ���������� � ������� T2=45
     -- CREATE TEMP TABLE _tmpSale_over (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     INSERT INTO _tmpSale_over (UnitId, GoodsId, Amount_t1, Summ_t1, Amount_t2, Summ_t2)
        SELECT tmp.UnitId
             , tmp.GoodsId
             , tmp.Amount_t1, tmp.Summ_t1
             , tmp.Amount_t2, tmp.Summ_t2
        FROM (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                   , MIContainer.ObjectId_analyzer               AS GoodsId
                   , SUM (CASE WHEN MIContainer.OperDate BETWEEN CURRENT_DATE + INTERVAL '1 DAY' - INTERVAL '60 DAY'  AND CURRENT_DATE THEN COALESCE (-1 * MIContainer.Amount, 0)                                  ELSE 0 END) AS Amount_t1
                   , SUM (CASE WHEN MIContainer.OperDate BETWEEN CURRENT_DATE + INTERVAL '1 DAY' - INTERVAL '60 DAY'  AND CURRENT_DATE THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summ_t1
                   , SUM (CASE WHEN MIContainer.OperDate BETWEEN CURRENT_DATE + INTERVAL '1 DAY' - INTERVAL '45 DAY'  AND CURRENT_DATE THEN COALESCE (-1 * MIContainer.Amount, 0)                                  ELSE 0 END) AS Amount_t2
                   , SUM (CASE WHEN MIContainer.OperDate BETWEEN CURRENT_DATE + INTERVAL '1 DAY' - INTERVAL '45 DAY'  AND CURRENT_DATE THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summ_t2
              FROM MovementItemContainer AS MIContainer
                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = MIContainer.WhereObjectId_analyzer
              WHERE MIContainer.DescId         = zc_MIContainer_Count()
                AND MIContainer.MovementDescId = zc_Movement_Check()
                AND MIContainer.OperDate BETWEEN CURRENT_DATE + INTERVAL '1 DAY' - INTERVAL '60 DAY' AND CURRENT_DATE
              GROUP BY MIContainer.ObjectId_analyzer
                     , MIContainer.WhereObjectId_analyzer
              HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
             ) AS tmp
       ;


     -- 2.1. ��� �������, ������� => ������ ���-�� ����������� � ����������
     -- CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     -- CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     --
     WITH -- ������ - UnComplete - �� ��������� +/-7 ���� ��� Date_Branch
         tmpMI_Income AS (SELECT MovementLinkObject_To.ObjectId AS UnitId
                                , MovementItem.ObjectId          AS GoodsId
                                , SUM (MovementItem.Amount)      AS Amount
                           FROM Movement
                                INNER JOIN MovementDate AS MovementDate_Branch
                                                        ON MovementDate_Branch.MovementId = Movement.Id
                                                       AND MovementDate_Branch.DescId     = zc_MovementDate_Branch()
                                                       -- AND MovementDate_Branch.ValueData >= CURRENT_DATE
                                                       AND MovementDate_Branch.ValueData BETWEEN CURRENT_DATE - INTERVAL '7 DAY' AND CURRENT_DATE + INTERVAL '7 DAY'
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
                            WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                           -- AND Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           -- AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
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
                                 /*LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                           ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                          AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()*/
                                 INNER JOIN MovementItem AS MovementItem
                                                         ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId     = zc_MI_Master()
                                                        AND MovementItem.isErased   = FALSE
                         -- WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '30 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '30 DAY'
                            WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '14 DAY' AND Movement.OperDate < CURRENT_DATE + INTERVAL '14 DAY'
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           -- AND COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE
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
                            GROUP BY tmpMovementCheck.UnitId, MovementItem.ObjectId
                           )
          -- �������
        , tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (Container.Amount, 0)) AS Amount
                         FROM Container
                              -- !!!������ ��� ����� �����!!!
                              INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = Container.WhereObjectId
                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
    -- ����
  , tmpObject_Price AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                             , OL_Price_Goods.ChildObjectId      AS GoodsId
                             , ROUND (Price_Value.ValueData, 2)  AS Price
                        FROM ObjectLink AS OL_Price_Unit
                             -- !!!������ ��� ����� �����!!!
                             INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = OL_Price_Unit.ChildObjectId
                             LEFT JOIN ObjectBoolean AS MCS_isClose
                                                     ON MCS_isClose.ObjectId = OL_Price_Unit.ObjectId
                                                    AND MCS_isClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                             LEFT JOIN ObjectLink AS OL_Price_Goods
                                                  ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                 AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                             INNER JOIN Object AS Object_Goods
                                               ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                              AND Object_Goods.isErased = FALSE
                             LEFT JOIN ObjectFloat AS Price_Value
                                                   ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                  AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                        WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND COALESCE (MCS_isClose.ValueData, FALSE) = FALSE
                       )
     -- 2.1. ���������: ��� �������, ������� => ������ ���-�� ����������� � ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains_all (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , 0 AS MCSValue
             , CASE -- ��� ������
                    WHEN 1 < FLOOR (-- ������� � � ���������� � ������� T2=45
                                    COALESCE (_tmpSale_over.Amount_t2, 0)
                                    -- ����� �������
                                  - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
                                   + COALESCE (tmpMI_Send_in.Amount, 0)
                                   + COALESCE (tmpMI_Income.Amount, 0)
                                   + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                    )
                                   )
                         THEN -- ��������� �����
                              FLOOR (-- ������� � � ���������� � ������� T2=45
                                     COALESCE (_tmpSale_over.Amount_t2, 0)
                                     -- ����� �������
                                   - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)
                                    + COALESCE (tmpMI_Send_in.Amount, 0)
                                    + COALESCE (tmpMI_Income.Amount, 0)
                                    + COALESCE (tmpMI_OrderExternal.Amount, 0)
                                     )
                                    )
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
        FROM tmpObject_Price
             -- �������� �� ��� - ������ ��������
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_out
                                     ON OB_Unit_SUN_out.ObjectId  = tmpObject_Price.UnitId
                                    AND OB_Unit_SUN_out.DescId    = zc_ObjectBoolean_Unit_SUN_out()
                                    AND OB_Unit_SUN_out.ValueData = TRUE
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
             -- ��������� !!��������!!
             INNER JOIN Object_Goods_View ON Object_Goods_View.Id      = tmpObject_Price.GoodsId
                                         AND Object_Goods_View.IsClose = FALSE
             -- ��������� !!���������!!
             INNER JOIN Object AS Object_Goods ON Object_Goods.Id        = tmpObject_Price.GoodsId
                                              AND Object_Goods.ValueData NOT ILIKE '���%'
             -- �� ��������� !!�����!!
             /*LEFT JOIN ObjectLink AS OL_Goods_ConditionsKeep
                                    ON OL_Goods_ConditionsKeep.ObjectId = tmpObject_Price.GoodsId
                                   AND OL_Goods_ConditionsKeep.DescId   = zc_ObjectLink_Goods_ConditionsKeep()
               LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = OL_Goods_ConditionsKeep.ChildObjectId
             */
        WHERE OB_Unit_SUN_out.ObjectId IS NULL
       ;
     -- 2.2. ���������: ��� �������, ������� => �������� ���-�� ����������� � ����������
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT _tmpRemains_all.UnitId, _tmpRemains_all.GoodsId, _tmpRemains_all.Price, _tmpRemains_all.MCS, _tmpRemains_all.AmountResult, _tmpRemains_all.AmountRemains, _tmpRemains_all.AmountIncome, _tmpRemains_all.AmountSend_in, _tmpRemains_all.AmountSend_out, _tmpRemains_all.AmountOrderExternal, _tmpRemains_all.AmountReserve
        FROM _tmpRemains_all
        -- !!!������ � ����� AmountResult!!!
         WHERE _tmpRemains_all.AmountResult > 1.0
       ;



    -- ���� + 6 �������
    vbDate_6:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
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
    -- ���� + 1 �����
    vbDate_1:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               )
               -- ������: ������� ��� 9 ����, ����� �� 60 ���� ������������ - ������ ��� ���
             + INTERVAL '9 DAY'
             ;
    -- ���� + 0 �������
    vbDate_0:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                                        ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                                        ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );


     -- 3.1. ��� �������, OVER (����� �����)
     -- CREATE TEMP TABLE _tmpRemains_Partion_all (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold) ON COMMIT DROP;
     INSERT INTO _tmpRemains_Partion_all (ContainerDescId, UnitId, ContainerId_Parent, ContainerId, GoodsId, Amount, PartionDateKindId, ExpirationDate, Amount_sun, Amount_notSold)
        WITH -- SUN + OVER - zc_Movement_Send - �� 30 ���� - ���� ���������, ������� ��� �� �����
             tmpSUN_Send AS (SELECT DISTINCT
                                    MovementLinkObject_To.ObjectId   AS UnitId_to
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
                             WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '31 DAY' AND CURRENT_DATE - INTERVAL '1 DAY'
                               AND Movement.DescId   = zc_Movement_Send()
                               AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                            )
                   -- ������ ��� OVER
                 , tmpContainer AS (SELECT Container.DescId           AS ContainerDescId
                                         , Container.Id               AS ContainerId
                                         , Container.WhereObjectId    AS UnitId
                                         , Container.ObjectId         AS GoodsId
                                         , Container.Amount           AS Amount
                                    FROM -- !!!������ ��� ����� �����!!!
                                         _tmpUnit_SUN
                                         INNER JOIN Container ON Container.WhereObjectId = _tmpUnit_SUN.UnitId
                                                             AND Container.Amount        <> 0
                                                             AND Container.DescId        = zc_Container_Count()
                                 -- WHERE 1=0
                                   )
                   -- ������ ��� OVER
                 , tmpOver_list AS (SELECT tmpContainer.UnitID
                                         , tmpContainer.GoodsID
                                         , SUM (tmpContainer.Amount) AS Amount
                                    FROM tmpContainer
                                    GROUP BY tmpContainer.UnitID
                                           , tmpContainer.GoodsID
                                   )
             -- ��� ����� ���������� OVER, �� ����� ���� ��� ���, � ������: ���������� ���� + �� ����������� � CommentError + ����������� - ������ (���������)
           , tmpNotSold_all AS (SELECT tmpOver_list.UnitID
                                     , tmpOver_list.GoodsID
                                       --  �������
                                     , tmpOver_list.Amount
                                       --  ��������: ��������� �����: ���� X1 ������ Y1 �� 1 � ������
                                     , FLOOR (tmpOver_list.Amount - COALESCE (_tmpSale_over.Amount_t1, 0)) AS Amount_notSold
                                FROM tmpOver_list
                                     LEFT JOIN _tmpSale_over ON _tmpSale_over.UnitId  = tmpOver_list.UnitId
                                                            AND _tmpSale_over.GoodsID = tmpOver_list.GoodsID
                                WHERE --  ��������: ���� X1 ������ Y1 �� 1 � ������
                                      tmpOver_list.Amount - COALESCE (_tmpSale_over.Amount_t1, 0) > 1
                               )
     -- ��� OVER - ������� ��� ��������
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
                                WHERE -- !!!�.�. ��� �������� ���������
                                      ObjectDate_PartionGoods_Value.ValueData <= vbDate_6
                                      -- !!!�.�. ��� �������� ���������
                                GROUP BY tmpNotSold_all.UnitID
                                       , tmpNotSold_all.GoodsID
                                HAVING SUM (Container.Amount) > 0
                               )
                  -- Income - �� 30 ���� - ���� ���������, OVER ������� ��� �� �����
                , tmpIncome AS (SELECT DISTINCT
                                       MovementLinkObject_To.ObjectId   AS UnitId_to
                                     , MovementItem.ObjectId            AS GoodsId
                                FROM Movement
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                                            AND MovementItem.Amount     > 0
                                     -- !!!������ ��� �����!!!
                                     INNER JOIN tmpNotSold_all ON tmpNotSold_all.UnitId  = MovementLinkObject_To.ObjectId
                                                              AND tmpNotSold_all.GoodsId = MovementItem.ObjectId
                                WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '31 DAY' AND CURRENT_DATE - INTERVAL '1 DAY'
                                  AND Movement.DescId   = zc_Movement_Income()
                                  AND Movement.StatusId IN (zc_Enum_Status_Complete())
                               )
                 -- ��� ��� �������� ��� NotSold
               , tmpNotSold AS (SELECT tmpNotSold_all.UnitID
                                     , tmpNotSold_all.GoodsID
                                     , tmpNotSold_all.Amount
                                     , tmpNotSold_all.Amount_notSold
                                FROM tmpNotSold_all
                                     -- ��� ��������
                                     LEFT JOIN tmpNotSold_PartionDate ON tmpNotSold_PartionDate.UnitId  = tmpNotSold_all.UnitID
                                                                     AND tmpNotSold_PartionDate.GoodsID = tmpNotSold_all.GoodsID
                                     -- Income - �� 30 ���� - ���� ���������, OVER ������� ��� �� �����
                                     LEFT JOIN tmpIncome ON tmpIncome.UnitId_to = tmpNotSold_all.UnitID
                                                        AND tmpIncome.GoodsID   = tmpNotSold_all.GoodsID
                                WHERE tmpNotSold_PartionDate.GoodsID  IS NULL
                                  AND tmpIncome.GoodsID IS NULL
                               )
        -- ���������
        SELECT 0 AS ContainerDescId
             , tmpNotSold.UnitId
             , 0 AS ContainerId_Parent
             , 0 AS ContainerId
             , tmpNotSold.GoodsId
               -- �������, ���
             , tmpNotSold.Amount
             , 0 AS PartionDateKindId
             , zc_DateEnd()              AS ExpirationDate
             , 0                         AS Amount_sun
               -- �������, OVER (����� �����)
             , tmpNotSold.Amount_notSold AS Amount_notSold
        FROM tmpNotSold
             LEFT JOIN ObjectBoolean AS OB_Unit_SUN_in
                                     ON OB_Unit_SUN_in.ObjectId  = tmpNotSold.UnitId
                                    AND OB_Unit_SUN_in.DescId    = zc_ObjectBoolean_Unit_SUN_in()
                                    AND OB_Unit_SUN_in.ValueData = TRUE
        WHERE -- !!!
              OB_Unit_SUN_in.ObjectId IS NULL
              -- !!!
       ;


     -- 3.2. �������, OVER (����� �����) - ��� �������������
     -- CREATE TEMP TABLE _tmpRemains_Partion (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     --
     WITH -- Goods_sum
          tmpGoods_sum AS (SELECT _tmpRemains_Partion_all.UnitId
                                , _tmpRemains_Partion_all.GoodsId
                                , SUM (_tmpRemains_Partion_all.Amount)         AS Amount
                                , SUM (_tmpRemains_Partion_all.Amount_notSold) AS Amount_notSold
                           FROM _tmpRemains_Partion_all
                           GROUP BY _tmpRemains_Partion_all.UnitId
                                  , _tmpRemains_Partion_all.GoodsId
                          )
               -- MCS + Price
             , tmpMCS AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                               , OL_Price_Goods.ChildObjectId      AS GoodsId
                               , Price_Value.ValueData             AS Price
                          FROM ObjectLink AS OL_Price_Unit
                               LEFT JOIN ObjectBoolean AS MCS_isClose
                                                       ON MCS_isClose.ObjectId = OL_Price_Unit.ObjectId
                                                      AND MCS_isClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                               LEFT JOIN ObjectLink AS OL_Price_Goods
                                                    ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                   AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                               INNER JOIN Object AS Object_Goods
                                                 ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                                AND Object_Goods.isErased = FALSE
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               -- !!!������ ��� �����!!!
                               INNER JOIN tmpGoods_sum ON tmpGoods_sum.UnitId  = OL_Price_Unit.ChildObjectId
                                                      AND tmpGoods_sum.GoodsId = OL_Price_Goods.ChildObjectId
                          WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                            AND COALESCE (MCS_isClose.ValueData, FALSE) = FALSE
                         )
       -- ���������: ��� �������, OVER (����� �����) - ��� �������������
       INSERT INTO _tmpRemains_Partion (ContainerDescId, UnitId, GoodsId, MCSValue, Amount_sale, Amount, Amount_save, Amount_real, Amount_sun, Amount_notSold)
          SELECT 0 AS ContainerDescId
               , tmp.UnitId
               , tmp.GoodsId
               , 0 AS MCSValue
               , COALESCE (_tmpSale.Amount_t2, 0) AS Amount_sale
                 -- �������, OVER (����� �����)
               , tmp.Amount_notSold
                   -- ��������� - ���������� ���� + �� ����������� � CommentError
                 - COALESCE (_tmpRemains_all.AmountReserve, 0)
                   -- ��������� - ����������� - ������ (���������)
                 - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                 AS Amount
                 -- �������, OVER (����� �����) ��� �������������
               , tmp.Amount             AS Amount_save
                 --
               , tmp.Amount             AS Amount_real
                 --
               , 0 AS Amount_sun
                 --
               , tmp.Amount_notSold
                   -- ��������� - ���������� ���� + �� ����������� � CommentError
                 - COALESCE (_tmpRemains_all.AmountReserve, 0)
                   -- ��������� - ����������� - ������ (���������)
                 - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                 AS Amount_notSold

          FROM tmpGoods_sum AS tmp
               -- ���������
               LEFT JOIN _tmpRemains_all ON _tmpRemains_all.UnitId  = tmp.UnitId
                                        AND _tmpRemains_all.GoodsId = tmp.GoodsId
               -- ���
               LEFT JOIN tmpMCS ON tmpMCS.UnitId  = tmp.UnitId
                               AND tmpMCS.GoodsId = tmp.GoodsId
               -- ���������
               LEFT JOIN _tmpRemains ON _tmpRemains.UnitId       = tmp.UnitId
                                    AND _tmpRemains.GoodsId      = tmp.GoodsId
                                    AND _tmpRemains.AmountResult > 0
               -- �������
               LEFT JOIN _tmpSale_over AS _tmpSale ON _tmpSale.UnitId  = tmp.UnitId
                                                  AND _tmpSale.GoodsId = tmp.GoodsId
          -- ��������� ���-�� �� ������������
          WHERE tmp.Amount_notSold
                   -- ��������� - ���������� ���� + �� ����������� � CommentError
                 - COALESCE (_tmpRemains_all.AmountReserve, 0)
                   -- ��������� - ����������� - ������ (���������)
                 - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                > 1
          ;


     -- 4. ������� �� ������� ���� ����������� � OVER
     -- CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;
     INSERT INTO _tmpRemains_calc (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve
                                 , AmountSun_real, AmountSun_summ, AmountSun_summ_save, AmountSun_unit, AmountSun_unit_save)
        SELECT _tmpRemains.UnitId
             , _tmpRemains.GoodsId
               -- ����
             , _tmpRemains.Price
               -- ���
             , 0 AS MCS
               -- ����������� � ����������
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

        FROM _tmpRemains
             -- ����� OVER (����� �����) ������� ����� ������������
             INNER JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.Amount) AS Amount, SUM (_tmpRemains_Partion.Amount_save) AS Amount_save, SUM (_tmpRemains_Partion.Amount_real) AS Amount_real
                         FROM _tmpRemains_Partion
                         GROUP BY _tmpRemains_Partion.GoodsId
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains.GoodsId
             -- OVER (����� �����) �� ���� ������, ����� ����������� � ������ ����� �� �����, �.�. ���� ��������� �� ���������
             LEFT JOIN _tmpRemains_Partion ON _tmpRemains_Partion.UnitId  = _tmpRemains.UnitId
                                          AND _tmpRemains_Partion.GoodsId = _tmpRemains.GoodsId
        WHERE _tmpRemains.AmountResult   > 1
       ;



     -- 6.1.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     -- CREATE TEMP TABLE _tmpResult_Partion (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     --
     -- ������1 - ��� �������, ���� + ������� ���� ��� �������������
     OPEN curPartion FOR
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from, _tmpRemains_Partion.GoodsId, _tmpRemains_Partion.Amount, _tmpRemains_Partion.Amount_save
        FROM _tmpRemains_Partion
             -- �������� � �����, ��� ������ ����� ���� ������������
             INNER JOIN (SELECT _tmpSumm_limit.UnitId_from, MAX (_tmpSumm_limit.Summ) AS Summ FROM _tmpSumm_limit
                         -- !!!������ ������
                         WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                         GROUP BY _tmpSumm_limit.UnitId_from
                        ) AS tmpSumm_limit ON tmpSumm_limit.UnitId_from = _tmpRemains_Partion.UnitId
        ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
       ;
     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curPartion INTO vbUnitId_from, vbGoodsId, vbAmount, vbAmount_save;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         -- ������2. - ��������� ����� ������� ��� ������������ ��� vbGoodsId
         OPEN curResult FOR
            SELECT _tmpRemains_calc.UnitId AS UnitId_to, _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) AS AmountResult, _tmpRemains_calc.Price
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
            WHERE _tmpRemains_calc.GoodsId = vbGoodsId
              AND _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) > 0
              -- !!!������ � �� ������, ������� ������������� ������!!!
              --!!! AND _tmpRemains_calc.UnitId IN (SELECT DISTINCT _tmpSumm_limit.UnitId_to FROM _tmpSumm_limit WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from AND _tmpSumm_limit.Summ >= vbSumm_limit)
            ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_calc.UnitId
           ;
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� ���������
         LOOP
             -- ������ �� ���������
             FETCH curResult INTO vbUnitId_to, vbAmountResult, vbPrice;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

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
                 -- ���������� � ���������� ������ ��� � ��������, �.�. ������ ���� "����"
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                         , vbAmount
                         , vbAmount * vbPrice
                         , 0 AS Amount_next
                         , 0 AS Summ_next
                         , 0 AS MovementId
                         , 0 AS MovementItemId
                    WHERE vbAmount > 0
                   ;
                 -- �������� ���-�� ��� �� ������ �� ������
                 vbAmount     := 0;
                 vbAmount_save:= 0;
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
                 -- ���������� � �������� ������ ��� ����, �.�. ������ ������� ���� � ������ ������
                 INSERT INTO _tmpResult_Partion (DriverId, UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId)
                    SELECT inDriverId
                         , vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                         , vbAmountResult
                         , vbAmountResult * vbPrice
                         , 0 AS Amount_next
                         , 0 AS Summ_next
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
       SELECT Object_Unit.Id          AS UnitId
            , Object_Unit.ValueData   AS UnitName
            , Object_Goods.Id         AS GoodsId
            , Object_Goods.ObjectCode AS GoodsCode
            , Object_Goods.ValueData  AS GoodsName
              -- �������
            , _tmpSale.Amount_t1 AS Amount_sale
            , _tmpSale.Summ_t1   AS Summ_sale
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
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains_calc.GoodsId
            -- ����� ��������� �� ���� �������
            LEFT JOIN (SELECT _tmpRemains_calc.GoodsId, SUM (_tmpRemains_calc.AmountResult) AS AmountResult FROM _tmpRemains_calc GROUP BY _tmpRemains_calc.GoodsId
                      ) AS tmpRemains_sum ON tmpRemains_sum.GoodsId = _tmpRemains_calc.GoodsId
            LEFT JOIN _tmpSale_over AS _tmpSale ON _tmpSale.UnitId  = _tmpRemains_calc.UnitId
                                               AND _tmpSale.GoodsId = _tmpRemains_calc.GoodsId
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
 16.11.19                                        *
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

     -- ��� ������������� ��� ����� SUN
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     CREATE TEMP TABLE _tmpUnit_SUN_balance (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2. ��� ���������� ������
     CREATE TEMP TABLE _tmpSale_over (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;

     -- 3.1. ��� �������, ����
     CREATE TEMP TABLE _tmpRemains_Partion_all (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     -- 3.2. �������, ���� - ��� �������������
     CREATE TEMP TABLE _tmpRemains_Partion (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;


     -- 4. ������� �� ������� ���� ��������� � ����
     CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     -- 6.2. !!!������ - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     CREATE TEMP TABLE _tmpList_DefSUN (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. ������������ ����������� - �� ������� �� �������
     CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

 SELECT * FROM lpInsert_Movement_Send_RemainsSun_over (inOperDate:= CURRENT_DATE - INTERVAL '0 DAY', inDriverId:= (SELECT MAX (OL.ChildObjectId) FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Driver()), inStep:= 1, inUserId:= 3) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
