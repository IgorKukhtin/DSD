-- Function: gpReport_Movement_Send_RemainsSun_over()

DROP FUNCTION IF EXISTS gpReport_Movement_Send_RemainsSun_over (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun_over(
    IN inOperDate      TDateTime,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId     Integer;

  DECLARE vbDriverId_1 Integer;
  DECLARE vbDriverId_2 Integer;

  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
--  DECLARE Cursor3 refcursor;
--  DECLARE Cursor4 refcursor;
--  DECLARE Cursor5 refcursor;

  DECLARE vbDate_0 TDateTime;
  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_1 TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;


     -- !!!������ ��������!!!
     vbDriverId_1 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                     );
     -- !!!������ ��������!!!
     vbDriverId_2 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                        AND ObjectLink_Unit_Driver.ChildObjectId <> vbDriverId_1
                     );

    -- ���� + 6 �������
    vbDate_6:= inOperDate
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
    vbDate_1:= inOperDate
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
    vbDate_0 := inOperDate
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

     -- ��� ������������� ��� ����� SUN
     CREATE TEMP TABLE _tmpUnit_SUN   (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_a (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     CREATE TEMP TABLE _tmpUnit_SUN_balance   (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_a (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_all_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. ��� ���������� ������
     CREATE TEMP TABLE _tmpSale_over   (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSale_over_a (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     -- 2.2. NotSold
     CREATE TEMP TABLE _tmpSale_not (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 2.3. ����������� SUN-v4 - Erased - �� �������, ��� � �� ���������� / �� �������� ��� ������ �������� � ���-2
     CREATE TEMP TABLE  _tmpSUN_v4 (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 3.1. ��� �������, ����
     CREATE TEMP TABLE _tmpRemains_Partion_all   (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_all_a (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     -- 3.2. �������, ���� - ��� �������������
     CREATE TEMP TABLE _tmpRemains_Partion   (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_a (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;


     -- 4. ������� �� ������� ���� ��������� � ����
     CREATE TEMP TABLE _tmpRemains_calc   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_calc_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     CREATE TEMP TABLE _tmpSumm_limit   (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSumm_limit_a (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion   (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_Partion_a (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     -- 6.2. !!!������ - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     CREATE TEMP TABLE _tmpList_DefSUN   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpList_DefSUN_a (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. ������������ ����������� - �� ������� �� �������
     CREATE TEMP TABLE _tmpResult_child   (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_child_a (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 8. ��������� ����� �����������
     CREATE TEMP TABLE _tmpUnit_SunExclusion (UnitId_from Integer, UnitId_to Integer, isMCS_to Boolean) ON COMMIT DROP;


     -- ���������
     CREATE TEMP TABLE _tmpResult (DriverId Integer, DriverName TVarChar
                                 , UnitId Integer, UnitName TVarChar
                                 , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                                 , Amount_sale         TFloat --
                                 , Summ_sale           TFloat --
                                 , AmountSun_real      TFloat -- ����� �������� �� �������� ��������, ������ ��������� � AmountSun_summ_save
                                 , AmountSun_summ_save TFloat -- ����� ��������, ��� ����� ���������
                                 , AmountSun_summ      TFloat -- ����� �������� + notSold, ������� ����� ������������
                                 , AmountSunOnly_summ  TFloat -- ����� ��������, ������� ����� ������������
                                 , Amount_notSold_summ TFloat -- ����� notSold, ������� ����� ������������
                                 , AmountResult        TFloat -- ���������
                                 , AmountResult_summ   TFloat -- ����� ��������� �� ���� �������
                                 , AmountRemains       TFloat -- �������
                                 , AmountIncome        TFloat -- ������ (���������)
                                 , AmountSend_in       TFloat -- ����������� - ������ (���������)
                                 , AmountSend_out      TFloat -- ����������� - ������ (���������)
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
                                 ) ON COMMIT DROP;
     -- ��������� - ������ ��������
     INSERT INTO _tmpResult (DriverId, DriverName
                           , UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_real
                           , AmountSun_summ_save
                           , AmountSun_summ
                           , AmountSunOnly_summ
                           , Amount_notSold_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountIncome
                           , AmountSend_in
                           , AmountSend_out
                           , AmountOrderExternal
                           , AmountReserve
                           , AmountSun_unit
                           , AmountSun_unit_save
                           , Price
                           , MCS
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_min_2
                           , Summ_max_2
                           , Unit_count_2
                           , Summ_str
                           , Summ_next_str
                           , UnitName_str
                           , UnitName_next_str
                           , Amount_res
                           , Summ_res
                           , Amount_next_res
                           , Summ_next_res
                            )
          SELECT COALESCE (vbDriverId_1, 0)                              :: Integer  AS DriverId
               , COALESCE (lfGet_Object_ValueData_sh (vbDriverId_1), '') :: TVarChar AS DriverName
               , COALESCE (tmp.UnitId, 0)      :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, '')   :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, 0)     :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, 0)   :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, '')  :: TVarChar AS GoodsName
               , tmp.Amount_sale
               , tmp.Summ_sale
               , tmp.AmountSun_real
               , tmp.AmountSun_summ_save
               , tmp.AmountSun_summ
               , tmp.AmountSunOnly_summ
               , tmp.Amount_notSold_summ
               , COALESCE (tmp.AmountResult, 0)        :: TFloat AS AmountResult
               , tmp.AmountResult_summ
               , COALESCE (tmp.AmountRemains, 0)       :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountIncome, 0)        :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend_in, 0)       :: TFloat AS AmountSend_in
               , COALESCE (tmp.AmountSend_out, 0)      :: TFloat AS AmountSend_out
               , COALESCE (tmp.AmountOrderExternal, 0) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, 0)       :: TFloat AS AmountReserve
               , tmp.AmountSun_unit
               , tmp.AmountSun_unit_save
               , COALESCE (tmp.Price, 0) :: TFloat AS Price
               , COALESCE (tmp.MCS, 0)     :: TFloat AS MCS
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_min_2
               , tmp.Summ_max_2
               , tmp.Unit_count_2
               , tmp.Summ_str
               , tmp.Summ_next_str
               , tmp.UnitName_str
               , tmp.UnitName_next_str
               , tmp.Amount_res
               , tmp.Summ_res
               , tmp.Amount_next_res
               , tmp.Summ_next_res
          FROM lpInsert_Movement_Send_RemainsSun_over (inOperDate := inOperDate
                                                     , inDriverId := vbDriverId_1
                                                     , inStep     := 1
                                                     , inUserId   := vbUserId
                                                      ) AS tmp
         ;
     -- !!!1 - ��������� ������
     INSERT INTO _tmpUnit_SUN_a SELECT * FROM _tmpUnit_SUN;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     INSERT INTO _tmpUnit_SUN_balance_a SELECT * FROM _tmpUnit_SUN_balance;
     -- 1. ��� �������, ��� => �������� ���-�� ����������
     INSERT INTO _tmpRemains_all_a SELECT * FROM _tmpRemains_all;
     INSERT INTO _tmpRemains_a     SELECT * FROM _tmpRemains;
     -- 2. ��� ���������� ������
     INSERT INTO _tmpSale_over_a SELECT * FROM _tmpSale_over;
     -- 3.1. ��� �������, ����
     INSERT INTO _tmpRemains_Partion_all_a SELECT * FROM _tmpRemains_Partion_all;
     -- 3.2. �������, ���� - ��� �������������
     INSERT INTO _tmpRemains_Partion_a SELECT * FROM _tmpRemains_Partion;
     -- 4. ������� �� ������� ���� ��������� � ����
     INSERT INTO _tmpRemains_calc_a SELECT * FROM _tmpRemains_calc;
     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     INSERT INTO _tmpSumm_limit_a SELECT * FROM _tmpSumm_limit;
     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;
     -- 6.2. !!!������ - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     INSERT INTO _tmpList_DefSUN_a SELECT * FROM _tmpList_DefSUN;
     -- 7.1. ������������ ����������� - �� ������� �� �������
     INSERT INTO _tmpResult_child_a   SELECT * FROM _tmpResult_child;



     -- ��������� - ������ ��������
   /*INSERT INTO _tmpResult (DriverId, DriverName
                           , UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_real
                           , AmountSun_summ_save
                           , AmountSun_summ
                           , AmountSunOnly_summ
                           , Amount_notSold_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountIncome
                           , AmountSend_in
                           , AmountSend_out
                           , AmountOrderExternal
                           , AmountReserve
                           , AmountSun_unit
                           , AmountSun_unit_save
                           , Price
                           , MCS
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_min_2
                           , Summ_max_2
                           , Unit_count_2
                           , Summ_str
                           , Summ_next_str
                           , UnitName_str
                           , UnitName_next_str
                           , Amount_res
                           , Summ_res
                           , Amount_next_res
                           , Summ_next_res
                            )
          SELECT COALESCE (vbDriverId_2, 0)                              :: Integer  AS DriverId
               , COALESCE (lfGet_Object_ValueData_sh (vbDriverId_2), '') :: TVarChar AS DriverName
               , COALESCE (tmp.UnitId, 0)      :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, '')   :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, 0)     :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, 0)   :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, '')  :: TVarChar AS GoodsName
               , tmp.Amount_sale
               , tmp.Summ_sale
               , tmp.AmountSun_real
               , tmp.AmountSun_summ_save
               , tmp.AmountSun_summ
               , tmp.AmountSunOnly_summ
               , tmp.Amount_notSold_summ
               , COALESCE (tmp.AmountResult, 0)        :: TFloat AS AmountResult
               , tmp.AmountResult_summ
               , COALESCE (tmp.AmountRemains, 0)       :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountIncome, 0)        :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend_in, 0)       :: TFloat AS AmountSend_in
               , COALESCE (tmp.AmountSend_out, 0)      :: TFloat AS AmountSend_out
               , COALESCE (tmp.AmountOrderExternal, 0) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, 0)       :: TFloat AS AmountReserve
               , tmp.AmountSun_unit
               , tmp.AmountSun_unit_save
               , COALESCE (tmp.Price, 0) :: TFloat AS Price
               , COALESCE (tmp.MCS, 0)     :: TFloat AS MCS
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_min_2
               , tmp.Summ_max_2
               , tmp.Unit_count_2
               , tmp.Summ_str
               , tmp.Summ_next_str
               , tmp.UnitName_str
               , tmp.UnitName_next_str
               , tmp.Amount_res
               , tmp.Summ_res
               , tmp.Amount_next_res
               , tmp.Summ_next_res
          FROM lpInsert_Movement_Send_RemainsSun_over (inOperDate := inOperDate
                                                     , inDriverId := vbDriverId_2
                                                     , inStep     := 1
                                                     , inUserId   := vbUserId
                                                      ) AS tmp
         ;
     -- !!!2 - ��������� ������
     INSERT INTO _tmpUnit_SUN_a SELECT * FROM _tmpUnit_SUN;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     INSERT INTO _tmpUnit_SUN_balance_a SELECT * FROM _tmpUnit_SUN_balance;
     -- 1. ��� �������, ��� => �������� ���-�� ����������
     INSERT INTO _tmpRemains_all_a SELECT * FROM _tmpRemains_all;
     INSERT INTO _tmpRemains_a     SELECT * FROM _tmpRemains;
     -- 2. ��� ���������� ������
     INSERT INTO _tmpSale_over_a SELECT * FROM _tmpSale_over;
     -- 3.1. ��� �������, ����
     INSERT INTO _tmpRemains_Partion_all_a SELECT * FROM _tmpRemains_Partion_all;
     -- 3.2. �������, ���� - ��� �������������
     INSERT INTO _tmpRemains_Partion_a SELECT * FROM _tmpRemains_Partion;
     -- 4. ������� �� ������� ���� ��������� � ����
     INSERT INTO _tmpRemains_calc_a SELECT * FROM _tmpRemains_calc;
     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     INSERT INTO _tmpSumm_limit_a SELECT * FROM _tmpSumm_limit;
     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;
     -- 6.2. !!!������ - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     INSERT INTO _tmpList_DefSUN_a SELECT * FROM _tmpList_DefSUN;
     -- 7.1. ������������ ����������� - �� ������� �� �������
     INSERT INTO _tmpResult_child_a   SELECT * FROM _tmpResult_child;*/


      -- �������� ��� �������
     /*INSERT INTO _tmpResult (UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_real
                           , AmountSun_summ_save
                           , AmountSun_summ
                           , AmountSunOnly_summ
                           , Amount_notSold_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountIncome
                           , AmountSend_in
                           , AmountSend_out
                           , AmountOrderExternal
                           , AmountReserve
                           , AmountSun_unit
                           , AmountSun_unit_save
                           , Price
                           , MCS
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_min_2
                           , Summ_max_2
                           , Unit_count_2
                           , Summ_str
                           , Summ_next_str
                           , UnitName_str
                           , UnitName_next_str
                           , Amount_res
                           , Summ_res
                           , Amount_next_res
                           , Summ_next_res
                            )
          SELECT COALESCE (tmp.UnitId, _tmpRemains_all.UnitId)     :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, Object_Unit.ValueData)    :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, _tmpRemains_all.GoodsId)   :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, Object_Goods.ObjectCode) :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, Object_Goods.ValueData)  :: TVarChar AS GoodsName
               , tmp.Amount_sale
               , tmp.Summ_sale
               , tmp.AmountSun_real
               , tmp.AmountSun_summ_save
               , tmp.AmountSun_summ
               , tmp.AmountSunOnly_summ
               , tmp.Amount_notSold_summ
               , COALESCE (tmp.AmountResult, _tmpRemains_all.AmountResult)               :: TFloat AS AmountResult
               , tmp.AmountResult_summ                                                   
               , COALESCE (tmp.AmountRemains, _tmpRemains_all.AmountRemains)             :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountIncome, _tmpRemains_all.AmountIncome)               :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend_in, _tmpRemains_all.AmountSend_in)             :: TFloat AS AmountSend_in
               , COALESCE (tmp.AmountSend_out, _tmpRemains_all.AmountSend_out)           :: TFloat AS AmountSend_out
               , COALESCE (tmp.AmountOrderExternal, _tmpRemains_all.AmountOrderExternal) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, _tmpRemains_all.AmountReserve)             :: TFloat AS AmountReserve
               , tmp.AmountSun_unit
               , tmp.AmountSun_unit_save
               , COALESCE (tmp.Price, _tmpRemains_all.Price) :: TFloat AS Price
               , COALESCE (tmp.MCS, _tmpRemains_all.MCS)     :: TFloat AS MCS
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_min_2
               , tmp.Summ_max_2
               , tmp.Unit_count_2
               , tmp.Summ_str
               , tmp.Summ_next_str
               , tmp.UnitName_str
               , tmp.UnitName_next_str
               , tmp.Amount_res
               , tmp.Summ_res
               , tmp.Amount_next_res
               , tmp.Summ_next_res
          FROM _tmpRemains_all_a AS _tmpRemains_all
               LEFT JOIN _tmpResult AS tmp
                                    ON tmp.UnitId  = _tmpRemains_all.UnitId
                                   AND tmp.GoodsId = _tmpRemains_all.GoodsId
               LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = _tmpRemains_all.UnitId
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpRemains_all.GoodsId
          WHERE tmp.GoodsId IS NULL;
          */

     IF EXISTS (SELECT COUNT(*) FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1)
        AND 1=1
     THEN
         RAISE EXCEPTION '������.����������� �����: % %(%) % %(%) % %(%)'
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT tmpRes.UnitId_from FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1))
                       ,                            (SELECT tmpRes.UnitId_from FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT tmpRes.UnitId_to   FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1))
                       ,                            (SELECT tmpRes.UnitId_to   FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1)
                       , CHR (13)
                       , lfGet_Object_ValueData    ((SELECT tmpRes.GoodsId     FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1))
                       ,                            (SELECT tmpRes.GoodsId     FROM _tmpResult_Partion_a AS tmpRes GROUP BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId HAVING COUNT(*) > 1 ORDER BY tmpRes.UnitId_from, tmpRes.UnitId_to, tmpRes.GoodsId LIMIT 1)
                        ;
     END IF;



     OPEN Cursor1 FOR
          SELECT *
          FROM _tmpResult AS tmp;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
          SELECT tmp.*
               , tmp.UnitId_from
               , Object_UnitFrom.ValueData AS FromName
               , tmp.UnitId_to
               , Object_UnitTo.ValueData   AS ToName
                 -- ����� ��������, ��� ����� ���������
               , tmpRemains_Partion_sum.AmountSun_summ_save
                 -- ����� �������� + notSold, ������� ����� ������������
               , tmpRemains_Partion_sum.AmountSun_summ
                 -- ����� ������ ��������, ������� ����� ������������
               , tmpRemains_Partion_sum.AmountSunOnly_summ
                 -- ����� ������ notSold, ������� ����� ������������
               , tmpRemains_Partion_sum.Amount_notSold_summ
                 --
               , tmpRemains_Partion_sum.Amount_sale
               , tmpRemains_Partion_sum.MCSValue AS MCS
               , _tmpRemains.AmountResult
               , _tmpRemains.AmountRemains
                 -- ���������� ���� + �� ����������� � CommentError
               , _tmpRemains.AmountReserve
                 -- ����������� - ������ (���������)
               , _tmpRemains.AmountSend_in
                 -- ����������� - ������ (���������)
               , _tmpRemains.AmountSend_out
               , _tmpRemains.Price
          FROM _tmpResult_Partion_a AS tmp
               LEFT JOIN Object AS Object_UnitFrom  ON Object_UnitFrom.Id  = tmp.UnitId_from
               LEFT JOIN Object AS Object_UnitTo  ON Object_UnitTo.Id  = tmp.UnitId_to
               -- ����� �������� + notSold ������� ����� ������������
               LEFT JOIN (SELECT _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId, _tmpRemains_Partion.MCSValue, _tmpRemains_Partion.Amount_sale
                                , SUM (_tmpRemains_Partion.Amount_save)    AS AmountSun_summ_save
                                , SUM (_tmpRemains_Partion.Amount)         AS AmountSun_summ
                                , SUM (_tmpRemains_Partion.Amount_sun)     AS AmountSunOnly_summ
                                , SUM (_tmpRemains_Partion.Amount_notSold) AS Amount_notSold_summ
                          FROM _tmpRemains_Partion_a AS _tmpRemains_Partion
                          GROUP BY _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId, _tmpRemains_Partion.MCSValue, _tmpRemains_Partion.Amount_sale
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.UnitId  = tmp.UnitId_from
                                                    AND tmpRemains_Partion_sum.GoodsId = tmp.GoodsId
               -- ��� �������, ���
               LEFT JOIN _tmpRemains_all_a AS _tmpRemains
                                           ON _tmpRemains.UnitId  = tmp.UnitId_from
                                          AND _tmpRemains.GoodsId = tmp.GoodsId

          ;
     RETURN NEXT Cursor2;
/*
     OPEN Cursor3 FOR
          WITH
          tmp_Result AS (SELECT tmp.*
                              , COALESCE (ObjectDate_Value.ValueData, zc_DateEnd())           AS ExpirationDate_in
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)    AS MovementId_Income
                              , CASE WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_0 THEN zc_Enum_PartionDateKind_0()
                                     WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_0  AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_1 THEN zc_Enum_PartionDateKind_1()
                                     WHEN COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) > vbDate_1  AND COALESCE (ObjectDate_Value.ValueData, zc_DateEnd()) <= vbDate_6 THEN zc_Enum_PartionDateKind_6()
                                     ELSE 0
                                END                                                          AS PartionDateKindId
                         FROM _tmpResult_child_a AS tmp
                              LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                            ON CLO_PartionGoods.ContainerId = tmp.ContainerId
                                                           AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                              LEFT OUTER JOIN ObjectDate AS ObjectDate_Value
                                                         ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                        AND ObjectDate_Value.DescId   =  zc_ObjectDate_PartionGoods_Value()

                              -- ������� ������
                              LEFT JOIN ContainerlinkObject AS CLO_PartionMovementItem
                                                            ON CLO_PartionMovementItem.ContainerId = tmp.ContainerId
                                                           AND CLO_PartionMovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLO_PartionMovementItem.ObjectId
                              -- ������� �������
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                            --LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate_in
                            --                                  ON MIDate_ExpirationDate_in.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                            --                                 AND MIDate_ExpirationDate_in.DescId = zc_MIDate_PartionGoods()
                        )

          SELECT tmp.*
               , Object_UnitFrom.ValueData        AS FromName
               , Object_UnitTo.ValueData          AS ToName
               , Movement_Income.Id               AS MovementId
               , Movement_Income.OperDate         AS OperDate
               , Movement_Income.Invnumber        AS Invnumber
               , tmp.ContainerId
               , tmp.MovementId
               , tmp.ExpirationDate_in
               , Object_PartionDateKind.ValueData AS PartionDateKindName
          FROM tmp_Result AS tmp
               LEFT JOIN Object AS Object_UnitFrom ON Object_UnitFrom.Id = tmp.UnitId_from
               LEFT JOIN Object AS Object_UnitTo   ON Object_UnitTo.Id   = tmp.UnitId_to
               LEFT JOIN Movement ON Movement.Id = tmp.MovementId
               LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmp.MovementId_Income
               LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmp.PartionDateKindId
              ;
     RETURN NEXT Cursor3;


     OPEN Cursor4 FOR
          SELECT Object_Goods.Id           AS GoodsId
               , Object_Goods.ObjectCode   AS GoodsCode
               , Object_Goods.ValueData    AS GoodsName
               , Object_UnitFrom.Id        AS FrimId
               , Object_UnitFrom.ValueData AS FromName
               , Object_UnitTo.Id          AS ToId
               , Object_UnitTo.ValueData   AS ToName
          FROM _tmpList_DefSUN_a AS tmp
               LEFT JOIN Object AS Object_UnitFrom ON Object_UnitFrom.Id = tmp.UnitId_from
               LEFT JOIN Object AS Object_UnitTo   ON Object_UnitTo.Id   = tmp.UnitId_to
               LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmp.GoodsId
          ;
     RETURN NEXT Cursor4;

     OPEN Cursor5 FOR
          SELECT Object_Unit.Id        AS UnitId
               , Object_Unit.ValueData AS UnitName
               , tmp.Summ_out
               , tmp.Summ_in
               , tmp.KoeffInSUN
               , tmp.KoeffOutSUN
          FROM _tmpUnit_SUN_balance_a AS tmp
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId
          ;
     RETURN NEXT Cursor5;
*/

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.08.19         *
*/

-- ����
-- FETCH ALL "<unnamed portal 1>";