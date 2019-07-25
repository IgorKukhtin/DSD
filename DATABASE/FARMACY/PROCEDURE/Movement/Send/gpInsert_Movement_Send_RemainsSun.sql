DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount_sale         TFloat --
             , Summ_sale           TFloat --
             , AmountSun_real      TFloat -- ����� �������� �� �������� ��������, ������ ��������� � AmountSun_summ_save
             , AmountSun_summ_save TFloat -- ����� ��������, ��� ����� ���������
             , AmountSun_summ      TFloat -- ����� ��������, ������� ����� ������������
             , AmountResult        TFloat -- ���������
             , AmountResult_summ   TFloat -- ����� ��������� �� ���� �������
             , AmountRemains       TFloat -- �������
             , AmountIncome        TFloat -- ������ (���������)
             , AmountSend          TFloat -- ����������� (���������)
             , AmountOrderExternal TFloat -- ����� (���������)
             , AmountReserve       TFloat -- ������ �� �����
             , AmountSun_unit      TFloat -- ���.=0, �������� �� ���� ������, ����� ����������� � ������ ����� �� �����, �.�. ���� ��������� �� ���������
             , AmountSun_unit_save TFloat -- ���.=0, �������� �� ���� ������, ��� ����� ���������
             , Price               TFloat -- ����
             , MCS                 TFloat -- ���
             , Summ_min            TFLoat -- ������������ - �������� �����
             , Summ_max            TFLoat -- ������������ - ���������� �����
             , Unit_count          TFLoat -- ������������ - ���-�� ����� ����.
             , Summ_min_1          TFLoat -- ������������ - ����� �������������-1: �������� �����
             , Summ_max_1          TFLoat -- ������������ - ����� �������������-1: ���������� �����
             , Unit_count_1        TFLoat -- ������������ - ����� �������������-1: ���-�� ����� ����.
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbDate_6     TDateTime;
   DECLARE vbDate_1     TDateTime;
   DECLARE vbDate_0     TDateTime;
   DECLARE vbSumm_limit TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;

     --
     vbSumm_limit:= 1000;

     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- ��� ������������� ��� ����� SUN
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer) ON COMMIT DROP;
     INSERT INTO _tmpUnit_SUN (UnitId)
        SELECT ObjectBoolean_SUN.ObjectId FROM ObjectBoolean AS ObjectBoolean_SUN WHERE ObjectBoolean_SUN.DescId = zc_ObjectBoolean_Unit_SUN();


     -- ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
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
          -- ����������� - UnComplete - �� ��������� +/-30 ����
        , tmpMI_Send AS (SELECT MovementLinkObject_To.ObjectId AS UnitId
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
                         AND COALESCE (MCS_isClose.ValueData, FALSE) = FALSE
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
          -- ��������� ��� �� �������� �� ������. �������, ���� � ������. ������� �������� ������
        , tmpObject_Price AS (SELECT COALESCE (tmpPrice.UnitId,  tmpGoodsCategory.UnitId)  AS UnitId
                                   , COALESCE (tmpPrice.GoodsId, tmpGoodsCategory.GoodsId) AS GoodsId
                                   , COALESCE (tmpPrice.Price, 0)                :: TFloat AS Price
                                   , CASE WHEN COALESCE (tmpGoodsCategory.Value, 0) <= COALESCE (tmpPrice.MCSValue, 0)
                                          THEN COALESCE (tmpPrice.MCSValue,0)
                                          ELSE tmpGoodsCategory.Value
                                     END                                         :: TFloat AS MCSValue
                                   , COALESCE (tmpPrice.MCSValue_min, 0)         :: TFloat AS MCSValue_min
                              FROM tmpPrice
                                   FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpPrice.GoodsId
                                                             AND tmpGoodsCategory.UnitId  = tmpPrice.UnitId
                              WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                 OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                             )

     -- 1. ���������: ��� �������, ��� => �������� ���-�� ����������: �� ������� ������� ������ ������ �� ���������� ����� - ��������� �������� ������� �� �����
     INSERT INTO  _tmpRemains (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend, AmountOrderExternal, AmountReserve)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             , CASE -- ���� ���_��� = 0 ��� ��� <= ���_���
                    WHEN COALESCE (tmpObject_Price.MCSValue_min, 0) = 0 OR (COALESCE (tmpRemains.Amount, 0) <= COALESCE (tmpObject_Price.MCSValue_min, 0))
                         THEN CASE -- ��� ������ ���
                                   WHEN tmpObject_Price.MCSValue >= 0.1 AND tmpObject_Price.MCSValue < 10
                                   -- � 1 >= ��� - ������� - "��������" - "�������" - "������" - "������"
                                    AND 1 >= ROUND (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                        THEN -- ��������� �����
                                             CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                   -- ��� ������ ���
                                   WHEN tmpObject_Price.MCSValue >= 10
                                   -- � 1 >= ��� - ������� - "��������" - "�������" - "������" - "������"
                                    AND 1 >= CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                        THEN -- ���������
                                             ROUND  (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                   ELSE -- ��������� �����
                                        FLOOR (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                              END
                    ELSE 0
               END AS AmountResult
             , COALESCE (tmpRemains.Amount, 0)          AS AmountRemains
             , COALESCE (tmpMI_Income.Amount, 0)        AS AmountIncome
             , COALESCE (tmpMI_Send.Amount, 0)          AS AmountSend
             , COALESCE (tmpMI_OrderExternal.Amount,0)  AS AmountOrderExternal
             , COALESCE (tmpMI_Reserve.Amount, 0)       AS AmountReserve
        FROM tmpObject_Price
             LEFT JOIN tmpRemains AS tmpRemains
                                  ON tmpRemains.UnitId  = tmpObject_Price.UnitId
                                 AND tmpRemains.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Income ON tmpMI_Income.UnitId  = tmpObject_Price.UnitId
                                   AND tmpMI_Income.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Send ON tmpMI_Send.UnitId  = tmpObject_Price.UnitId
                                 AND tmpMI_Send.GoodsId = tmpObject_Price.GoodsId
             LEFT OUTER JOIN tmpMI_OrderExternal ON tmpMI_OrderExternal.UnitId  = tmpObject_Price.UnitId
                                                AND tmpMI_OrderExternal.GoodsId = tmpObject_Price.GoodsId
             LEFT JOIN tmpMI_Reserve ON tmpMI_Reserve.UnitId  = tmpObject_Price.UnitId
                                    AND tmpMI_Reserve.GoodsId = tmpObject_Price.GoodsId
             -- ��������� !!��������!!
             INNER JOIN Object_Goods_View ON Object_Goods_View.Id      = tmpObject_Price.GoodsId
                                         AND Object_Goods_View.IsClose = FALSE
        -- !!!��������, ����� ���!!!
        /*WHERE CASE -- ���� ���_��� = 0 ��� ��� <= ���_���
                   WHEN COALESCE (tmpObject_Price.MCSValue_min, 0) = 0 OR (COALESCE (tmpRemains.Amount, 0) <= COALESCE (tmpObject_Price.MCSValue_min, 0))
                        THEN CASE -- ��� ������ ���
                                  WHEN tmpObject_Price.MCSValue >= 0.1 AND tmpObject_Price.MCSValue < 10
                                  -- � 1 >= ��� - ������� - "��������" - "�������" - "������" - "������"
                                   AND 1 >= ROUND (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                       THEN -- ��������� �����
                                            CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                  -- ��� ������ ���
                                  WHEN tmpObject_Price.MCSValue >= 10
                                  -- � 1 >= ��� - ������� - "��������" - "�������" - "������" - "������"
                                   AND 1 >= CEIL (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                                       THEN -- ���������
                                            ROUND  (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))

                                  ELSE -- ��������� �����
                                       FLOOR (tmpObject_Price.MCSValue - (COALESCE (tmpRemains.Amount, 0) - COALESCE (tmpMI_Reserve.Amount, 0)) - COALESCE (tmpMI_Send.Amount, 0) - COALESCE (tmpMI_Income.Amount, 0) - COALESCE (tmpMI_OrderExternal.Amount,0))
                             END
                   ELSE 0
              END > 0*/
       ;


     -- 2. ��� ���������� ������
     CREATE TEMP TABLE _tmpSale (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
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
               );
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


     -- 2. ��� �������, ����
     CREATE TEMP TABLE _tmpRemains_Partion (UnitId Integer, GoodsId Integer, Amount TFloat, Amount_save TFloat, Amount_real TFloat) ON COMMIT DROP;
     --
     WITH tmpRemains AS (SELECT CLO_Unit.ObjectId                                          AS UnitId
                              , Container.ParentId                                         AS ContainerId_Parent
                              , Container.ObjectId                                         AS GoodsId
                              , SUM (Container.Amount)                                     AS Amount
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

                              LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ContainerId = Container.Id
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                              LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                   ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                  AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

                         WHERE Container.DescId = zc_Container_CountPartionDate()
                           AND Container.Amount > 0
                           -- !!!�������� ������ ��� ���������
                           AND ObjectDate_PartionGoods_Value.ValueData >  vbDate_1
                           AND ObjectDate_PartionGoods_Value.ValueData <= vbDate_6
                         GROUP BY CLO_Unit.ObjectId
                                , Container.ParentId
                                , Container.ObjectId
                                , CASE WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_0
                                            THEN zc_Enum_PartionDateKind_0()
                                       WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_0 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_1
                                            THEN zc_Enum_PartionDateKind_1()
                                       WHEN COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) > vbDate_1 AND COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd()) <= vbDate_6
                                            THEN zc_Enum_PartionDateKind_6()
                                       ELSE 0
                                  END
                                , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())
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
       -- ���������: ��� �������, ����
       INSERT INTO _tmpRemains_Partion (UnitId, GoodsId, Amount, Amount_save, Amount_real)
          SELECT tmp.UnitId
               , tmp.GoodsId
                 -- ��������� ��������, ���� ���� ������� �� � ��������� �� �����
               , CASE WHEN _tmpSale.Amount > 0 THEN tmp.Amount - COALESCE (_tmpRemains_MSC.MCS, 0) ELSE tmp.Amount END AS Amount
                 -- ������� ���� ��� �������������
               , tmp.Amount             AS Amount_save
                 --
               , tmpRemains_real.Amount AS Amount_real
          FROM (SELECT tmpRemains.UnitId, tmpRemains.GoodsId, SUM (tmpRemains.Amount) AS Amount FROM tmpRemains GROUP BY tmpRemains.UnitId, tmpRemains.GoodsId
               ) AS tmp
               LEFT JOIN tmpRemains_real ON tmpRemains_real.UnitId  = tmp.UnitId
                                        AND tmpRemains_real.GoodsId = tmp.GoodsId
               -- ���������
               LEFT JOIN _tmpRemains ON _tmpRemains.UnitId       = tmp.UnitId
                                    AND _tmpRemains.GoodsId      = tmp.GoodsId
                                    AND _tmpRemains.AmountResult > 0
               -- ���
               LEFT JOIN _tmpRemains AS _tmpRemains_MSC
                                     ON _tmpRemains_MSC.UnitId  = tmp.UnitId
                                    AND _tmpRemains_MSC.GoodsId = tmp.GoodsId
               -- �������
               LEFT JOIN _tmpSale ON _tmpSale.UnitId  = tmp.UnitId
                                 AND _tmpSale.GoodsId = tmp.GoodsId
          -- ��������� ���-�� �� ������������
          WHERE tmp.Amount >= 1
            -- !!!����������� ����� ��������, �� ������� ���� ���������, �.�. ������������ �� ���� �� �����
            AND _tmpRemains.GoodsId IS NULL
          ;


     -- 3. ������� �� ������� ���� ��������� � ����
     CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpRemains_calc (UnitId, GoodsId, Price, MCS, AmountResult, AmountRemains, AmountIncome, AmountSend, AmountOrderExternal, AmountReserve
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
             , _tmpRemains.AmountSend
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
                         FROM _tmpRemains_Partion GROUP BY _tmpRemains_Partion.GoodsId
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.GoodsId = _tmpRemains.GoodsId
             -- �������� �� ���� ������, ����� ����������� � ������ ����� �� �����, �.�. ���� ��������� �� ���������
             LEFT JOIN _tmpRemains_Partion ON _tmpRemains_Partion.UnitId  = _tmpRemains.UnitId
                                          AND _tmpRemains_Partion.GoodsId = _tmpRemains.GoodsId
        WHERE _tmpRemains.AmountResult   > 0
          AND _tmpRemains_Partion.UnitId IS NULL
       ;


     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpSumm_limit (UnitId_from, UnitId_to, Summ)
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from
             , _tmpRemains_calc.UnitId    AS UnitId_to
               -- ���� �������� ������ ��� � ����������
             , CASE WHEN _tmpRemains_Partion.Amount >= _tmpRemains_calc.AmountResult
                         -- ����� �������� = ���������
                         THEN _tmpRemains_calc.AmountResult
                         -- ����� ��������� "��������" - �.�. ������� ���� ��������
                         ELSE _tmpRemains_Partion.Amount
               END
             * _tmpRemains_calc.Price 
        FROM -- ������� �� ������� ���� ��������� � ����
             _tmpRemains_calc
             -- ��� �������, ����
             INNER JOIN _tmpRemains_Partion ON _tmpRemains_Partion.GoodsId = _tmpRemains_calc.GoodsId
       ;

     -- 6. ������������ ������� �� ������� - �� ���� ������� � ����������
     CREATE TEMP TABLE _tmpResult_Partion (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpResult_Partion (UnitId_from, UnitId_to, GoodsId, Amount, Summ)
        WITH -- ������������ "����� ��������" (������� ����) - ��������������� ����������
             tmpPartion AS (SELECT _tmpRemains_calc.UnitId
                                 , _tmpRemains_calc.GoodsId
                                 , _tmpRemains_calc.Price
                                   -- ������������ - ����� ��������
                                 , _tmpRemains_calc.AmountSun_summ * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult AS AmountResult
                            FROM _tmpRemains_calc
                                 -- �������� ������ ��, ���� ����� ����������� "��������" ������ ������
                                 INNER JOIN (SELECT DISTINCT _tmpSumm_limit.UnitId_to FROM _tmpSumm_limit WHERE _tmpSumm_limit.Summ >= vbSumm_limit
                                            ) AS tmpSumm ON tmpSumm.UnitId_to = _tmpRemains_calc.UnitId
                                 -- ����� ��������� �� ���� �������
                                 LEFT JOIN (SELECT _tmpRemains_calc.GoodsId, SUM (_tmpRemains_calc.AmountResult) AS AmountResult FROM _tmpRemains_calc GROUP BY _tmpRemains_calc.GoodsId
                                           ) AS tmpRemains_sum ON tmpRemains_sum.GoodsId = _tmpRemains_calc.GoodsId
                           )
           , DD AS (SELECT _tmpRemains_Partion.UnitId AS UnitId_from
                         , tmpPartion.UnitId          AS UnitId_to
                         , tmpPartion.GoodsId
                         , tmpPartion.Price
                           -- ������� ���� ��������
                         , tmpPartion.AmountResult
                           -- ������� ��������
                         , _tmpRemains_Partion.Amount AS AmountRemains
                           -- ����� "�������������" ������� ��������
                         , SUM (_tmpRemains_Partion.Amount) OVER (PARTITION BY _tmpRemains_Partion.GoodsId
                                                                  ORDER BY Container.Id
                                                                 ) AS AmountRemains_sum

                    FROM tmpPartion
                         INNER JOIN _tmpRemains_Partion ON _tmpRemains_Partion.GoodsId = tmpPartion.GoodsId
                         -- "���������" ����� �����������
                         INNER JOIN _tmpSumm_limit AS tmpSumm
                                                   ON tmpSumm.UnitId_from = _tmpRemains_Partion.UnitId
                                                  AND tmpSumm.UnitId_to   = tmpPartion.UnitId
                                                  AND tmpSumm.Summ        >= vbSumm_limit
                         -- "�������" �� ������ ���� �����������
                         INNER JOIN _tmpSale ON _tmpSale.UnitId  = tmpPartion.UnitId
                                            AND _tmpSale.GoodsId = tmpPartion.GoodsId
                   )
        -- ���������
        SELECT _tmpRemains_Partion.UnitId AS UnitId_from
             , _tmpRemains_calc.UnitId    AS UnitId_to
             , _tmpRemains_calc.GoodsId   AS GoodsId
               -- ������������
             , CASE WHEN _tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult <= 1
                         -- ��������� �����
                         THEN CEIL (_tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult)
                    WHEN _tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult < 10
                         -- ���������
                         THEN ROUND (_tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult)
                         -- ��������� �����
                    ELSE ROUND (_tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult)
               END
               -- �����
             , CASE WHEN _tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult <= 1
                         -- ��������� �����
                         THEN CEIL (_tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult)
                    WHEN _tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult < 10
                         -- ���������
                         THEN ROUND (_tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult)
                         -- ��������� �����
                    ELSE ROUND (_tmpRemains_Partion.Amount * _tmpRemains_calc.AmountResult / tmpRemains_sum.AmountResult)
               END
             * _tmpRemains_calc.Price 
        FROM _tmpRemains_calc
             -- �������� ������ ��, ���� ����� ����������� "��������" ������ ������
             INNER JOIN (SELECT _tmpSumm_limit.UnitId_to, MIN (_tmpSumm_limit.Summ) AS Summ_min, MAX (_tmpSumm_limit.Summ) AS Summ_max, COUNT(*) AS Unit_count FROM _tmpSumm_limit WHERE _tmpSumm_limit.Summ >= vbSumm_limit GROUP BY _tmpSumm_limit.UnitId_to
                        ) AS tmpSumm ON tmpSumm.UnitId_to = _tmpRemains_calc.UnitId
             -- ��� �������, ����
             INNER JOIN _tmpRemains_Partion ON _tmpRemains_Partion.GoodsId = _tmpRemains_calc.GoodsId
             -- ����� ��������� �� ���� �������
             LEFT JOIN (SELECT _tmpRemains_calc.GoodsId, SUM (_tmpRemains_calc.AmountResult) AS AmountResult FROM _tmpRemains_calc GROUP BY _tmpRemains_calc.GoodsId
                       ) AS tmpRemains_sum ON tmpRemains_sum.GoodsId = _tmpRemains_calc.GoodsId
       ;

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
              -- _tmpRemains_calc.AmountSun_summ_save
            , _tmpRemains_calc.AmountSun_summ_save
              -- ����� �������� ������� ����� ������������
            , _tmpRemains_calc.AmountSun_summ
              -- ���������
            , _tmpRemains_calc.AmountResult
              -- ����� ��������� �� ���� �������
            , tmpRemains_sum.AmountResult        :: TFloat AS AmountResult_summ
              --
            , _tmpRemains_calc.AmountRemains
            , _tmpRemains_calc.AmountIncome
            , _tmpRemains_calc.AmountSend
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
            , tmpSumm.Summ_min   :: TFLoat AS Summ_min
              -- ������������ - "��������" ���������� �����
            , tmpSumm.Summ_max   :: TFLoat AS Summ_max
              -- ������������ - "��������"���-�� ����� ����.
            , tmpSumm.Unit_count :: TFLoat AS Unit_count

              -- ������������ - ����� �������������-1: �������� �����
            , tmpSumm_res1.Summ_min   :: TFLoat AS Summ_min_1
              -- ������������ - ����� �������������-1: ���������� �����
            , tmpSumm_res1.Summ_max   :: TFLoat AS Summ_max_1
              -- ������������ - ����� �������������-1: ���-�� ����� ����.
            , tmpSumm_res1.Unit_count :: TFLoat AS Unit_count_1
       FROM _tmpRemains_calc
            -- �������� ������ ��, ���� ����� ����������� "��������" ������ ������
            INNER JOIN (SELECT _tmpSumm_limit.UnitId_to, MIN (_tmpSumm_limit.Summ) AS Summ_min, MAX (_tmpSumm_limit.Summ) AS Summ_max, COUNT(*) AS Unit_count FROM _tmpSumm_limit WHERE _tmpSumm_limit.Summ >= vbSumm_limit GROUP BY _tmpSumm_limit.UnitId_to
                       ) AS tmpSumm ON tmpSumm.UnitId_to = _tmpRemains_calc.UnitId
            -- ����� �������������-1, ����� ����������� ������ ������
            LEFT JOIN (SELECT tmpSumm_res1.UnitId_to, MIN (tmpSumm_res1.Summ) AS Summ_min, MAX (tmpSumm_res1.Summ) AS Summ_max, COUNT(*) AS Unit_count
                       FROM (-- ������� � 1 �����������
                             SELECT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to, SUM (_tmpResult_Partion.Summ) AS Summ FROM _tmpResult_Partion  GROUP BY _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to
                            ) AS tmpSumm_res1
                       WHERE tmpSumm_res1.Summ >= vbSumm_limit GROUP BY tmpSumm_res1.UnitId_to
                      ) AS tmpSumm_res1 ON tmpSumm_res1.UnitId_to = _tmpRemains_calc.UnitId
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


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.19                                        *
*/

-- ����
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun (inOperDate:= CURRENT_DATE - INTERVAL '0 DAY', inSession:= '3') -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
