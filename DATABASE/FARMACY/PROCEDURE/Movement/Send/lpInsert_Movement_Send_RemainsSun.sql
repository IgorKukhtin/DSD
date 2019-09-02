-- Function: lpInsert_Movement_Send_RemainsSun

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun (TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun(
    IN inOperDate            TDateTime , -- ���� ������ ������
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
   
BEGIN
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);


     -- !!!
     vbSumm_limit:= CASE WHEN 0 < (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                              THEN (SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = vbObjectId AND ObjectFloat.DescId = zc_ObjectFloat_Retail_SummSUN())
                         ELSE 1000
                    END;


     -- ��� ������������� ��� ����� SUN
     DELETE FROM _tmpUnit_SUN;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     IF inStep = 1 THEN DELETE FROM _tmpUnit_SUN_balance; END IF;
     -- 1. ��� �������, ��� => �������� ���-�� ����������
     DELETE FROM _tmpRemains_all;
     DELETE FROM _tmpRemains;
     -- 2. ��� ���������� ������
     DELETE FROM _tmpSale;
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



     -- ��� ������������� ��� ����� SUN
     -- CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_SUN (UnitId, KoeffInSUN, KoeffOutSUN)
        SELECT ObjectBoolean_SUN.ObjectId
             , COALESCE (OF_KoeffInSUN.ValueData, 0)  AS KoeffInSUN
             , COALESCE (OF_KoeffOutSUN.ValueData, 0) AS KoeffOutSUN
        FROM ObjectBoolean AS ObjectBoolean_SUN
             LEFT JOIN ObjectFloat AS OF_KoeffInSUN  ON OF_KoeffInSUN.ObjectId  = ObjectBoolean_SUN.ObjectId AND OF_KoeffInSUN.DescId  = zc_ObjectFloat_Unit_KoeffInSUN()
             LEFT JOIN ObjectFloat AS OF_KoeffOutSUN ON OF_KoeffOutSUN.ObjectId = ObjectBoolean_SUN.ObjectId AND OF_KoeffOutSUN.DescId = zc_ObjectFloat_Unit_KoeffOutSUN()
        WHERE ObjectBoolean_SUN.ValueData = TRUE AND ObjectBoolean_SUN.DescId = zc_ObjectBoolean_Unit_SUN();

     IF inStep = 1
     THEN
         -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
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
                         WHERE Movement.OperDate BETWEEN inOperDate - INTERVAL '30 DAY' AND inOperDate - INTERVAL '1 DAY'
                           AND Movement.DescId   = zc_Movement_Send()
                           AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                         GROUP BY MovementLinkObject_From.ObjectId
                                , MovementLinkObject_To.ObjectId
                        )
         -- ���������
         INSERT INTO _tmpUnit_SUN_balance (UnitId, Summ_out, Summ_in, KoeffInSUN, KoeffOutSUN)
            SELECT _tmpUnit_SUN.UnitId
                  , COALESCE (tmpSumm_out.Summ_out) AS Summ_out
                  , COALESCE (tmpSumm_in.Summ_in)   AS Summ_in
                  , CASE WHEN tmpSumm_out.Summ_out > 0 AND tmpSumm_in.Summ_in > 0 THEN tmpSumm_in.Summ_in   / tmpSumm_out.Summ_out ELSE 0 END AS KoeffInSUN
                  , CASE WHEN tmpSumm_out.Summ_out > 0 AND tmpSumm_in.Summ_in > 0 THEN tmpSumm_out.Summ_out / tmpSumm_in.Summ_in   ELSE 0 END AS KoeffOutSUN
            FROM _tmpUnit_SUN
                 LEFT JOIN (SELECT tmpSUN.UnitId_from, SUM (tmpSUN.Summ_out) AS Summ_out FROM tmpSUN GROUP BY tmpSUN.UnitId_from
                           ) AS tmpSumm_out ON tmpSumm_out.UnitId_from = _tmpUnit_SUN.UnitId
                 LEFT JOIN (SELECT tmpSUN.UnitId_to, SUM (tmpSUN.Summ_in) AS Summ_in FROM tmpSUN GROUP BY tmpSUN.UnitId_to
                           ) AS tmpSumm_in ON tmpSumm_in.UnitId_to = _tmpUnit_SUN.UnitId
                ;
     END IF;
        

     -- 1. ��� �������, ��� => �������� ���-�� ����������
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
      -- ����������� - ������ - UnComplete - �� ��������� +/-10 ����
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
                            LEFT JOIN ObjecTFloat AS Price_Value
                                                  ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_Value.DescId = zc_ObjecTFloat_Price_Value()
                            LEFT JOIN ObjecTFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjecTFloat_Price_MCSValue()
                            LEFT JOIN ObjecTFloat AS Price_MCSValueMin
                                                  ON Price_MCSValueMin.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_MCSValueMin.DescId = zc_ObjecTFloat_Price_MCSValueMin()
                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND COALESCE (MCS_isClose.ValueData, FALSE) = FALSE
                      )
          -- ������ �� ������. �������
        , tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjecTFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!������ ��� ����� �����!!!
                                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                         ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                   INNER JOIN ObjecTFloat AS ObjecTFloat_Value
                                                          ON ObjecTFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                         AND ObjecTFloat_Value.DescId = zc_ObjecTFloat_GoodsCategory_Value()
                                                         AND COALESCE (ObjecTFloat_Value.ValueData,0) <> 0
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
                              FROM tmpPrice
                                   FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpPrice.GoodsId
                                                             AND tmpGoodsCategory.UnitId  = tmpPrice.UnitId
                              WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                 OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                                 OR COALESCE (tmpPrice.Price, 0) <> 0
                             )
     -- 1.1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains_all (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             , CASE -- ���� ���_��� = 0 ��� ��� <= ���_���
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
               END AS AmountResult
               -- �������
             , COALESCE (tmpRemains.Amount, 0)          AS AmountRemains
               -- ������ - UnComplete - �� ��������� +/-7 ���� ��� Date_Branch
             , COALESCE (tmpMI_Income.Amount, 0)        AS AmountIncome
               -- ����������� - ������ - UnComplete - �� ��������� +/-30 ����
             , COALESCE (tmpMI_Send_in.Amount, 0)       AS AmountSend_In
               -- ����������� - ������ - UnComplete - �� ��������� +/-30 ����
             , COALESCE (tmpMI_Send_out.Amount, 0)       AS AmountSend_out
               -- ������ - UnComplete - !���! Deferred
             , COALESCE (tmpMI_OrderExternal.Amount,0)  AS AmountOrderExternal
               -- ���������� ���� + �� ����������� � CommentError
             , COALESCE (tmpMI_Reserve.Amount, 0)       AS AmountReserve
        FROM tmpObject_Price
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
             INNER JOIN Object_Goods_View ON Object_Goods_View.Id      = tmpObject_Price.GoodsId
                                         AND Object_Goods_View.IsClose = FALSE
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
     -- 1.1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend_in, AmountSend_out, AmountOrderExternal, AmountReserve)
        SELECT _tmpRemains_all.UnitId, _tmpRemains_all.GoodsId, _tmpRemains_all.Price, _tmpRemains_all.MCS, _tmpRemains_all.AmountResult, _tmpRemains_all.AmountRemains, _tmpRemains_all.AmountIncome, _tmpRemains_all.AmountSend_in, _tmpRemains_all.AmountSend_out, _tmpRemains_all.AmountOrderExternal, _tmpRemains_all.AmountReserve
        FROM _tmpRemains_all
             -- ������ �� ������� ����������� - ���� �� �������������, ����� ������ �����������
             LEFT JOIN _tmpUnit_SUN_balance ON _tmpUnit_SUN_balance.UnitId = _tmpRemains_all.UnitId
             LEFT JOIN _tmpUnit_SUN         ON _tmpUnit_SUN.UnitId         = _tmpRemains_all.UnitId
        -- !!!������ � ����� ���!!!
         WHERE _tmpRemains_all.MCS >= 1.0
         AND (_tmpUnit_SUN.KoeffInSUN = 0 OR _tmpUnit_SUN_balance.KoeffInSUN < _tmpUnit_SUN.KoeffInSUN)
       ;


     -- 2. ��� ���������� ������ - 1 �����
     -- CREATE TEMP TABLE _tmpSale (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpSale (UnitId, GoodsId, Amount, Summ)
        SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
             , MIContainer.ObjectId_analyzer               AS GoodsId
             , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
             , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS Summ
        FROM MovementItemContainer AS MIContainer
             INNER JOIN _tmpRemains ON _tmpRemains.UnitId       = MIContainer.WhereObjectId_analyzer
                                   AND _tmpRemains.GoodsId      = MIContainer.ObjectId_analyzer
                                   AND _tmpRemains.AmountResult <= 0 -- !!!����� ������ ����� ��� ����������!!!
        WHERE MIContainer.DescId         = zc_MIContainer_Count()
          AND MIContainer.MovementDescId = zc_Movement_Check()
          AND MIContainer.OperDate BETWEEN CURRENT_DATE + INTERVAL '1 DAY' - INTERVAL '1 MONTH' AND CURRENT_DATE + INTERVAL '1 DAY'
        GROUP BY MIContainer.ObjectId_analyzer
               , MIContainer.WhereObjectId_analyzer
        HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
       ;


    -- ���� + 6 �������
    vbDate_6:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );
    -- ���� + 1 �����
    vbDate_1:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               )
               -- ������: ������� ��� 9 ����, ����� �� 60 ���� ������������ - ������ ��� ���
             + INTERVAL '9 DAY'
             ;
    -- ���� + 0 �������
    vbDate_0:= CURRENT_DATE
             + (WITH tmp AS (SELECT CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN ObjecTFloat_Day.ValueData ELSE COALESCE (ObjecTFloat_Month.ValueData, 0) END AS Value
                                  , CASE WHEN ObjecTFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END AS isMonth
                             FROM Object  AS Object_PartionDateKind
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Month
                                                        ON ObjecTFloat_Month.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Month.DescId = zc_ObjecTFloat_PartionDateKind_Month()
                                  LEFT JOIN ObjecTFloat AS ObjecTFloat_Day
                                                        ON ObjecTFloat_Day.ObjectId = Object_PartionDateKind.Id
                                                       AND ObjecTFloat_Day.DescId = zc_ObjecTFloat_PartionDateKind_Day()
                             WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0()
                            )
                SELECT CASE WHEN tmp.isMonth = TRUE THEN tmp.Value ||' MONTH'  ELSE tmp.Value ||' DAY' END :: INTERVAL FROM tmp
               );


     -- 3.1. ��� �������, ����
     -- CREATE TEMP TABLE _tmpRemains_Partion_all (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold) ON COMMIT DROP;
     --
     INSERT INTO _tmpRemains_Partion_all (ContainerDescId, UnitId, ContainerId_Parent, ContainerId, GoodsId, Amount, PartionDateKindId, ExpirationDate, Amount_sun, Amount_notSold)
        WITH -- SUN - �� 14 ���� - ���� ���������, ������� ��� �� �����
             tmpSUN AS (SELECT DISTINCT
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
                        WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '14 DAY' AND CURRENT_DATE - INTERVAL '1 DAY'
                          AND Movement.DescId   = zc_Movement_Send()
                          AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
                       )
                   -- ������ ��� NotSold
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
                -- ������ Sold
            /*, tmpSold_all AS (SELECT DISTINCT
                                       Container.WhereObjectId AS UnitID
                                     , Container.ObjectId      AS GoodsID
                                FROM -- !!!������ ��� ����� �����!!!
                                     _tmpUnit_SUN
                                     INNER JOIN Container ON Container.WhereObjectId = _tmpUnit_SUN.UnitId
                                                      -- !!!���!!
                                                      -- AND Container.Amount        <> 0
                                                         AND Container.DescId        = zc_Container_Count()
                                     INNER JOIN MovementItemContainer AS MIContainer
                                                                      ON MIContainer.ContainerId            = Container.Id
                                                                  -- AND MIContainer.WhereObjectId_Analyzer = Container.WhereObjectId
                                                                  -- AND MIContainer.ObjectId_Analyzer      = Container.ObjectId
                                                                  -- AND MIContainer.DescId                 = zc_MIContainer_Count()
                                                                     AND MIContainer.OperDate               >= CURRENT_DATE - INTERVAL '100 DAY'
                                                                     AND MIContainer.Amount                 <> 0
                                                                     AND MIContainer.MovementDescId         = zc_Movement_Check()
                               )
             -- ��� ��� ����� ���������� NotSold
           , tmpNotSold_all AS (SELECT tmpContainer.ContainerId
                                     , tmpContainer.UnitID
                                     , tmpContainer.GoodsID
                                     , tmpContainer.Amount
                                FROM tmpContainer
                                     LEFT JOIN tmpSold_all ON tmpSold_all.UnitID  = tmpContainer.UnitID
                                                          AND tmpSold_all.GoodsID = tmpContainer.GoodsID
                                WHERE tmpSold_all.GoodsID IS NULL
                               )*/
             -- ��� ��� ����� ���������� NotSold
           , tmpNotSold_all AS (SELECT tmpContainer.ContainerDescId
                                     , tmpContainer.ContainerId
                                     , tmpContainer.UnitID
                                     , tmpContainer.GoodsID
                                     , tmpContainer.Amount
                                FROM tmpContainer
                                     LEFT JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.WhereObjectId_Analyzer = tmpContainer.UnitId
                                                                    AND MIContainer.ObjectId_Analyzer      = tmpContainer.GoodsID
                                                                    AND MIContainer.DescId                 = zc_MIContainer_Count()
                                                                    AND MIContainer.OperDate               >= CURRENT_DATE - INTERVAL '100 DAY'
                                                                    AND MIContainer.Amount                 <> 0
                                                                    AND MIContainer.MovementDescId         = zc_Movement_Check()
                                WHERE MIContainer.ObjectId_Analyzer IS NULL
                               )
     -- ��� NotSold - ������� ������ �����
   , tmpNotSold_PartionDate AS (SELECT tmpNotSold.ContainerId
                                     , tmpNotSold.UnitID
                                     , tmpNotSold.GoodsID
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
                                      ObjectDate_PartionGoods_Value.ValueData <= vbDate_1
                                      -- !!!�������� ������ ��� ���������
                                GROUP BY tmpNotSold.ContainerId
                                       , tmpNotSold.UnitID
                                       , tmpNotSold.GoodsID
                               )
            -- ��� NotSold - ������� ������ �����
          , tmpNotSold_list AS (SELECT DISTINCT
                                       tmpNotSold_all.UnitID
                                     , tmpNotSold_all.GoodsID
                                FROM tmpNotSold_all
                               )
                  -- Income - �� 7 ���� - ���� ���������, 100���� ��� ������ ������� ��� �� �����
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
                                     INNER JOIN tmpNotSold_list ON tmpNotSold_list.UnitId  = MovementLinkObject_To.ObjectId
                                                               AND tmpNotSold_list.GoodsId = MovementItem.ObjectId
                                WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '7 DAY' AND CURRENT_DATE - INTERVAL '1 DAY'
                                  AND Movement.DescId   = zc_Movement_Income()
                                  AND Movement.StatusId IN (zc_Enum_Status_Complete())
                               )
                 -- ��� ��� �������� ��� NotSold
               , tmpNotSold AS (SELECT tmpNotSold_all.ContainerDescId
                                     , tmpNotSold_all.ContainerId
                                     , tmpNotSold_all.UnitID
                                     , tmpNotSold_all.GoodsID
                                     , tmpNotSold_all.Amount - COALESCE (tmpNotSold_PartionDate.Amount, 0) AS Amount
                                FROM tmpNotSold_all
                                     LEFT JOIN tmpNotSold_PartionDate ON tmpNotSold_PartionDate.ContainerId = tmpNotSold_all.ContainerId
                                     LEFT JOIN tmpIncome ON tmpIncome.UnitId_to = tmpNotSold_all.UnitID
                                                        AND tmpIncome.GoodsID   = tmpNotSold_all.GoodsID
                                WHERE tmpNotSold_all.Amount - COALESCE (tmpNotSold_PartionDate.Amount, 0) > 0
                                  AND tmpIncome.GoodsID IS NULL
                               )
             -- ��������� �� ��������
           , tmpRes_SUN AS (SELECT Container.DescId                                           AS ContainerDescId
                                 , CLO_Unit.ObjectId                                          AS UnitId
                                 , Container.ParentId                                         AS ContainerId_Parent
                                 , Container.Id                                               AS ContainerId
                                 , Container.ObjectId                                         AS GoodsId
                                 , Container.Amount                                           AS Amount
                                 , CASE WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_0
                                             THEN zc_Enum_PartionDateKind_0()
                                        WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_0 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_1
                                             THEN zc_Enum_PartionDateKind_1()
                                        WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_1 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_6
                                             THEN zc_Enum_PartionDateKind_6()
                                        ELSE 0
                                   END                                                        AS PartionDateKindId
                                 , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) AS ExpirationDate
                            FROM Container
                                 INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                ON CLO_Unit.ContainerId = Container.Id
                                                               AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                 -- !!!������ ��� ����� �����!!!
                                 INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = CLO_Unit.ObjectId
                                 -- !!!SUN - �� 14 ���� - ���� ���������, ������� ��� �� �����!!!
                                 LEFT JOIN tmpSUN ON tmpSUN.UnitId_to = CLO_Unit.ObjectId
                                                 AND tmpSUN.GoodsId   = Container.ObjectId
                    
                                 LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                               ON CLO_PartionGoods.ContainerId = Container.Id
                                                              AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                 LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                      ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                     AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                    
                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.Amount <> 0
                              -- !!!
                              AND tmpSUN.GoodsId IS NULL
                              -- !!!�������� ������ ��� ���������
                              AND ObjectDate_PartionGoods_Value.ValueData >  vbDate_1
                              AND ObjectDate_PartionGoods_Value.ValueData <= vbDate_6
                              -- !!!�������� ������ ��� ���������
                           )
        -- ���������
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
             -- ���� �� ���� � tmpNotSold, ����� ������������ ������ ��� ���-�� �� tmpNotSold
             LEFT JOIN tmpNotSold ON tmpNotSold.UnitId  = tmpRes_SUN.UnitId
                                AND tmpNotSold.GoodsId = tmpRes_SUN.GoodsId
             -- ������ �� ������� ������������ - ���� �� �������������, ����� ������ �����������
             LEFT JOIN _tmpUnit_SUN_balance ON _tmpUnit_SUN_balance.UnitId = tmpRes_SUN.UnitId
             LEFT JOIN _tmpUnit_SUN         ON _tmpUnit_SUN.UnitId         = tmpRes_SUN.UnitId
        WHERE -- !!!
              tmpNotSold.GoodsId IS NULL
              -- !!!
         AND (_tmpUnit_SUN.KoeffOutSUN = 0 OR _tmpUnit_SUN_balance.KoeffOutSUN < _tmpUnit_SUN.KoeffOutSUN)

       UNION ALL
        -- 
        SELECT tmpNotSold.ContainerDescId
             , tmpNotSold.UnitId
             , tmpNotSold.ContainerId AS ContainerId_Parent
             , tmpNotSold.ContainerId
             , tmpNotSold.GoodsId
             , tmpNotSold.Amount
          -- , 0 AS Amount
             , 0 AS PartionDateKindId
             , zc_DateEnd() AS ExpirationDate
             , 0                 AS Amount_sun
             , tmpNotSold.Amount AS Amount_notSold
        FROM tmpNotSold
             -- !!!SUN - �� 14 ���� - ���� ���������, ������� ��� �� �����!!!
             LEFT JOIN tmpSUN ON tmpSUN.UnitId_to = tmpNotSold.UnitId
                             AND tmpSUN.GoodsId   = tmpNotSold.GoodsId
             -- ������ �� ������� ������������ - ���� �� �������������, ����� ������ �����������
             LEFT JOIN _tmpUnit_SUN_balance ON _tmpUnit_SUN_balance.UnitId = tmpNotSold.UnitId
             LEFT JOIN _tmpUnit_SUN         ON _tmpUnit_SUN.UnitId         = tmpNotSold.UnitId

             -- ���� �� ���� � ��������, ����� ������������ ������ �������� ���-��
          -- LEFT JOIN tmpRes_SUN ON tmpRes_SUN.UnitId  = tmpNotSold.UnitId
          --                     AND tmpRes_SUN.GoodsId = tmpNotSold.GoodsId
        WHERE -- !!!
              tmpSUN.GoodsId IS NULL
              -- !!!
         AND (_tmpUnit_SUN.KoeffOutSUN = 0 OR _tmpUnit_SUN_balance.KoeffOutSUN < _tmpUnit_SUN.KoeffOutSUN)
             -- !!!
       -- AND tmpRes_SUN.GoodsId IS NULL
              
       ;


     -- 3.2. �������, ���� - ��� �������������
     -- CREATE TEMP TABLE _tmpRemains_Partion (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     --
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
            -- ��� �������� ����� ContainerId_Parent - �������� ������� (��� ��������)
          , tmpRemains_gr AS (SELECT DISTINCT tmpRemains.UnitId, tmpRemains.GoodsId, tmpRemains.ContainerId_Parent FROM tmpRemains
                             )
            -- �������� �������� ������� �� ������� �������� (��� ��������)
          , tmpRemains_real AS (SELECT tmpRemains_gr.UnitId, tmpRemains_gr.GoodsId, SUM (Container.Amount) AS Amount
                                FROM tmpRemains_gr
                                     JOIN Container ON Container.Id = tmpRemains_gr.ContainerId_Parent
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
          -- ������ �� ������. �������
        , tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjecTFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!������ ��� ����� �����!!!
                                   INNER JOIN _tmpUnit_SUN ON _tmpUnit_SUN.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                         ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                   INNER JOIN ObjecTFloat AS ObjecTFloat_Value
                                                          ON ObjecTFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                         AND ObjecTFloat_Value.DescId = zc_ObjecTFloat_GoodsCategory_Value()
                                                         AND COALESCE (ObjecTFloat_Value.ValueData,0) <> 0
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
                                                       ON MCS_isClose.ObjectId = OL_Price_Unit.ObjectId
                                                      AND MCS_isClose.DescId   = zc_ObjectBoolean_Price_MCSIsClose()
                               LEFT JOIN ObjectLink AS OL_Price_Goods
                                                    ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                   AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                               INNER JOIN Object AS Object_Goods
                                                 ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                                AND Object_Goods.isErased = FALSE
                               LEFT JOIN ObjecTFloat AS Price_Value
                                                     ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                    AND Price_Value.DescId = zc_ObjecTFloat_Price_Value()
                               LEFT JOIN ObjecTFloat AS MCS_Value
                                                     ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                    AND MCS_Value.DescId = zc_ObjecTFloat_Price_MCSValue()
                               LEFT JOIN ObjecTFloat AS Price_MCSValueMin
                                                     ON Price_MCSValueMin.ObjectId = OL_Price_Unit.ObjectId
                                                    AND Price_MCSValueMin.DescId = zc_ObjecTFloat_Price_MCSValueMin()
                               -- !!!������ ��� �����!!!
                               INNER JOIN tmpGoods_sum ON tmpGoods_sum.UnitId  = OL_Price_Unit.ChildObjectId
                                                      AND tmpGoods_sum.GoodsId = OL_Price_Goods.ChildObjectId
                          WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                            AND COALESCE (MCS_isClose.ValueData, FALSE) = FALSE
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
       -- ���������: ��� �������, ����
       INSERT INTO _tmpRemains_Partion (ContainerDescId, UnitId, GoodsId, MCSValue, Amount_sale, Amount, Amount_save, Amount_real, Amount_sun, Amount_notSold)
          SELECT tmp.ContainerDescId
               , tmp.UnitId
               , tmp.GoodsId
               , COALESCE (tmpMCS.MCSValue, 0) AS MCSValue
               , COALESCE (_tmpSale.Amount, 0) AS Amount_sale
                 -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
               , CASE -- ��������� ��������, ���� ���� MCSValue
                      WHEN tmpMCS.MCSValue > 0 AND tmp.Amount > 0 THEN tmp.Amount - COALESCE (tmpMCS.MCSValue, 0)
                      -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
                      WHEN _tmpSale.Amount > 0 AND tmp.Amount > 0 THEN tmp.Amount - COALESCE (_tmpSale.Amount, 0)
                      ELSE tmp.Amount
                 END
                   -- ��������� - ���������� ���� + �� ����������� � CommentError
                 - COALESCE (_tmpRemains_all.AmountReserve, 0)
                   -- ��������� - ����������� - ������ (���������)
                 - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                 AS Amount
                 -- ������� ���� ��� �������������
               , tmp.Amount             AS Amount_save
                 --
               , tmpRemains_real.Amount AS Amount_real
                 --
               , CASE -- ��������� ��������, ���� ���� MCSValue
                      WHEN tmpMCS.MCSValue > 0 AND tmp.Amount_sun > 0 THEN tmp.Amount_sun - COALESCE (tmpMCS.MCSValue, 0)
                      -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
                      WHEN _tmpSale.Amount > 0 AND tmp.Amount_sun > 0 THEN tmp.Amount_sun - COALESCE (_tmpSale.Amount, 0)
                      ELSE tmp.Amount_sun
                 END
                   -- ��������� - ���������� ���� + �� ����������� � CommentError
                 - COALESCE (_tmpRemains_all.AmountReserve, 0)
                   -- ��������� - ����������� - ������ (���������)
                 - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                 AS Amount_sun
                 --
               , CASE -- ��������� , ���� ���� MCSValue
                      WHEN tmpMCS.MCSValue > 0 AND tmp.Amount_notSold > 0 THEN tmp.Amount_notSold - COALESCE (tmpMCS.MCSValue, 0)
                      -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
                      WHEN _tmpSale.Amount > 0 AND tmp.Amount_notSold > 0 THEN tmp.Amount_notSold - COALESCE (_tmpSale.Amount, 0)
                      ELSE tmp.Amount_notSold
                 END
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
               LEFT JOIN tmpRemains_real ON tmpRemains_real.UnitId  = tmp.UnitId
                                        AND tmpRemains_real.GoodsId = tmp.GoodsId
               -- ���������
               LEFT JOIN _tmpRemains ON _tmpRemains.UnitId       = tmp.UnitId
                                    AND _tmpRemains.GoodsId      = tmp.GoodsId
                                    AND _tmpRemains.AmountResult > 0
               -- �������
               LEFT JOIN _tmpSale ON _tmpSale.UnitId  = tmp.UnitId
                                 AND _tmpSale.GoodsId = tmp.GoodsId
          -- ��������� ���-�� �� ������������
          WHERE CASE -- ��������� ��������, ���� ���� MCSValue
                      WHEN tmpMCS.MCSValue > 0 AND tmp.Amount > 0 THEN tmp.Amount - COALESCE (tmpMCS.MCSValue, 0)
                      -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
                      WHEN _tmpSale.Amount > 0 AND tmp.Amount > 0 THEN tmp.Amount - COALESCE (_tmpSale.Amount, 0)
                      ELSE tmp.Amount
                END
                -- ��������� - ���������� ���� + �� ����������� � CommentError
              - COALESCE (_tmpRemains_all.AmountReserve, 0)
                -- ��������� - ����������� - ������ (���������)
              - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                >= CASE WHEN tmpMCS.Price <= 100 THEN 1 ELSE 0 END
              /*(CASE -- ��������� ��������, ���� ���� MCSValue
                      WHEN tmpMCS.MCSValue > 0 AND tmp.Amount_sun > 0 THEN tmp.Amount_sun - COALESCE (tmpMCS.MCSValue, 0)
                      -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
                      WHEN _tmpSale.Amount > 0 AND tmp.Amount_sun > 0 THEN tmp.Amount_sun - COALESCE (_tmpSale.Amount, 0)
                      ELSE tmp.Amount_sun
                 END
                   -- ��������� - ���������� ���� + �� ����������� � CommentError
                 - COALESCE (_tmpRemains_all.AmountReserve, 0)
                   -- ��������� - ����������� - ������ (���������)
                 - COALESCE (_tmpRemains_all.AmountSend_out, 0)
              >= CASE WHEN tmpMCS.Price <= 100 THEN 1 ELSE 0 END
              OR CASE -- ��������� , ���� ���� MCSValue
                      WHEN tmpMCS.MCSValue > 0 AND tmp.Amount_notSold > 0 THEN tmp.Amount_notSold - COALESCE (tmpMCS.MCSValue, 0)
                      -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
                      WHEN _tmpSale.Amount > 0 AND tmp.Amount_notSold > 0 THEN tmp.Amount_notSold - COALESCE (_tmpSale.Amount, 0)
                      ELSE tmp.Amount_notSold
                 END
                   -- ��������� - ���������� ���� + �� ����������� � CommentError
                 - COALESCE (_tmpRemains_all.AmountReserve, 0)
                   -- ��������� - ����������� - ������ (���������)
                 - COALESCE (_tmpRemains_all.AmountSend_out, 0)
                >= CASE WHEN tmpMCS.Price <= 100 THEN 1 ELSE 0 END 
               )*/
            -- !!!����������� ����� ��������, �� ������� ���� ���������, �.�. ������������ �� ���� �� �����
            AND _tmpRemains.GoodsId IS NULL
          ;


     -- 4. ������� �� ������� ���� ��������� � ����
     -- CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;
     --
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

        FROM _tmpRemains
             -- ����� �������� ������� ����� ������������
             INNER JOIN (SELECT _tmpRemains_Partion.GoodsId, SUM (_tmpRemains_Partion.Amount) AS Amount, SUM (_tmpRemains_Partion.Amount_save) AS Amount_save, SUM (_tmpRemains_Partion.Amount_real) AS Amount_real
                         FROM _tmpRemains_Partion
                         GROUP BY _tmpRemains_Partion.GoodsId
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains.GoodsId
             -- �������� �� ���� ������, ����� ����������� � ������ ����� �� �����, �.�. ���� ��������� �� ���������
             LEFT JOIN _tmpRemains_Partion ON _tmpRemains_Partion.UnitId  = _tmpRemains.UnitId
                                          AND _tmpRemains_Partion.GoodsId = _tmpRemains.GoodsId
        WHERE _tmpRemains.AmountResult   > 0
          AND _tmpRemains_Partion.UnitId IS NULL
       ;


     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
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
                              ELSE _tmpRemains_Partion.Amount
                    END
                  * _tmpRemains_calc.Price
                   )
        FROM -- ������� �� ������� ���� ��������� � ����
             _tmpRemains_calc
             -- ��� �������, ����
             INNER JOIN _tmpRemains_Partion ON _tmpRemains_Partion.GoodsId = _tmpRemains_calc.GoodsId
        GROUP BY _tmpRemains_Partion.UnitId
               , _tmpRemains_calc.UnitId
       ;


     -- 6.1.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     -- CREATE TEMP TABLE _tmpResult_Partion (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
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
                 INSERT INTO _tmpResult_Partion (UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId)
                    SELECT vbUnitId_from
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
                 INSERT INTO _tmpResult_Partion (UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next, MovementId, MovementItemId)
                    SELECT vbUnitId_from
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


     -- 6.1.2. ������������-2 ������� �� ������� - �� ���� ������� - ����� ������ !!!��� ��� ��������!!!
     --
     -- ������1 - ��� �������, ���� ����� ������� ��� ������������
     OPEN curPartion_next FOR
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from, _tmpRemains_Partion.GoodsId, _tmpRemains_Partion.Amount - COALESCE (tmp.Amount, 0) AS Amount
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
        ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
       ;
     -- ������ ����� �� �������1
     LOOP
         -- ������ �� �������1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbAmount;
         -- ���� ������ �����������, ����� �����
         IF NOT FOUND THEN EXIT; END IF;

         -- ������2. - ��������� ����� ������� ��� ������������ ��� vbGoodsId
         OPEN curResult_next FOR
            SELECT _tmpRemains_calc.UnitId AS UnitId_to, _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) AS AmountResult, _tmpRemains_calc.Price
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
                 -- !!!������ �� DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit!!!
                 LEFT JOIN _tmpList_DefSUN ON _tmpList_DefSUN.UnitId_from = vbUnitId_from
                                          AND _tmpList_DefSUN.UnitId_to   = _tmpRemains_calc.UnitId
                                          AND _tmpList_DefSUN.GoodsId     = vbGoodsId
                 -- !!!������ �� DefSUN-all - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit!!!
                 --LEFT JOIN (SELECT DISTINCT _tmpList_DefSUN.UnitId_to, _tmpList_DefSUN.GoodsId FROM _tmpList_DefSUN
                 --          ) AS _tmpList_DefSUN_all
                 --            ON _tmpList_DefSUN_all.UnitId_to = _tmpRemains_calc.UnitId
                 --           AND _tmpList_DefSUN_all.GoodsId   = vbGoodsId
                 
            WHERE _tmpRemains_calc.GoodsId = vbGoodsId
              AND _tmpRemains_calc.AmountResult - COALESCE (tmp.Amount, 0) > 0
              -- !!!�� DefSUN
              AND _tmpList_DefSUN.GoodsId IS NULL
              -- !!!�� DefSUN-all
              --AND _tmpList_DefSUN_all.GoodsId IS NULL
              -- !!!��� ������
              -- AND _tmpRemains_calc.UnitId IN (SELECT DISTINCT _tmpSumm_limit.UnitId_to FROM _tmpSumm_limit WHERE _tmpSumm_limit.UnitId_from = vbUnitId_from AND _tmpSumm_limit.Summ >= vbSumm_limit)
            ORDER BY tmpSumm_limit.Summ DESC, _tmpRemains_calc.UnitId
           ;
         -- ������ ����� �� �������2 - ������� �������� - ��� ���� ���� ����� ���������
         LOOP
             -- ������ �� ���������
             FETCH curResult_next INTO vbUnitId_to, vbAmountResult, vbPrice;
             -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
             IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

             --
             IF vbAmountResult > vbAmount
             THEN
                 -- ���������� � ���������� ������ ��� ������
                 INSERT INTO _tmpResult_Partion (UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next)
                    SELECT vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                         , 0                  AS Amount
                         , 0                  AS Summ
                         , vbAmount           AS Amount_next
                         , vbAmount * vbPrice AS Summ_next
                          ;
                 -- �������� ���-�� ��� �� ������ �� ������
                 vbAmount:= 0;
             ELSE
                 -- ���������� � �������� ������ ��� ������, !!!��������� � ����-��������� - �������� ���-��!!!
                 INSERT INTO _tmpResult_Partion (UnitId_from, UnitId_to, GoodsId, Amount, Summ, Amount_next, Summ_next)
                    SELECT vbUnitId_from
                         , vbUnitId_to
                         , vbGoodsId
                         , 0                        AS Amount
                         , 0                        AS Summ
                         , vbAmountResult           AS Amount_next
                         , vbAmountResult * vbPrice AS Summ_next
                          ;
                 -- ��������� �� ���-�� ������� ����� � ���������� �����
                 vbAmount:= vbAmount - vbAmountResult;
             END IF;

         END LOOP; -- ����� ����� �� �������2
         CLOSE curResult_next; -- ������� ������2.

     END LOOP; -- ����� ����� �� �������1
     CLOSE curPartion_next; -- ������� ������1


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
                               WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '2 DAY' AND CURRENT_DATE - INTERVAL '1 DAY'
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
                                                      , inStep    := 2
                                                      , inUserId  := inUserId
                                                       );
         END IF;

     END IF;


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
            ORDER BY _tmpRemains_Partion_all.ExpirationDate DESC, _tmpRemains_Partion_all.ContainerId
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

                 -- �������� ���-�� ��� �� ������ �� ������
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
            , Object_Goods.ObjectCode AS GoodsCode
            , Object_Goods.ValueData  AS GoodsName
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
            LEFT JOIN _tmpSale ON _tmpSale.UnitId  = _tmpRemains_calc.UnitId
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
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     CREATE TEMP TABLE _tmpUnit_SUN_balance (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains_all (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2. ��� ���������� ������
     CREATE TEMP TABLE _tmpSale (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;

     -- 3.1. ��� �������, ����
     CREATE TEMP TABLE _tmpRemains_Partion_all (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     -- 3.2. �������, ���� - ��� �������������
     CREATE TEMP TABLE _tmpRemains_Partion (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;


     -- 4. ������� �� ������� ���� ��������� � ����
     CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     -- 6.2. !!!������ - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     CREATE TEMP TABLE _tmpList_DefSUN (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. ������������ ����������� - �� ������� �� �������
     CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

 SELECT * FROM lpInsert_Movement_Send_RemainsSun (inOperDate:= CURRENT_DATE - INTERVAL '0 DAY', inStep:= 1, inUserId:= 3) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
*/
