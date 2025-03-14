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

  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpGetUserBySession (inSession);
     vbUserId := inSession;


     -- ��� ������������� ��� ����� SUN
     CREATE TEMP TABLE _tmpUnit_SUN   (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLockSale Boolean, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_a (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, Value_T1 TFloat, Value_T2 TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLockSale Boolean, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     -- ��������
     CREATE TEMP TABLE _tmpGoods_Layout  (UnitId Integer, GoodsId Integer, Layout TFloat, isNotMoveRemainder6 boolean, MovementLayoutId Integer) ON COMMIT DROP;
     -- ������������� ���� ��� �����
     CREATE TEMP TABLE _tmpGoods_PromoUnit  (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     -- ������ ���������� ��������
     CREATE TEMP TABLE _tmpGoods_DiscountExternal  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     -- ��� ������������ � ������� ���
     CREATE TEMP TABLE _tmpGoods_Sun_exception   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     CREATE TEMP TABLE _tmpUnit_SUN_balance   (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_a (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;

     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     CREATE TEMP TABLE _tmpGoods_TP_exception   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_all_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. ��� ���������� ������ - OVER
     CREATE TEMP TABLE _tmpSale_over   (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSale_over_a (UnitId Integer, GoodsId Integer, Amount_t1 TFloat, Summ_t1 TFloat, Amount_t2 TFloat, Summ_t2 TFloat) ON COMMIT DROP;
     -- 2.2. NotSold
     CREATE TEMP TABLE _tmpSale_not (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 2.3. ����������� ��� SUN-����� �������� - Erased - �� �������, ��� � �� ���������� / �� �������� ��� ������ �������� � ���-2
     CREATE TEMP TABLE  _tmpSUN_oth (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 2.4. ������ ��� ���������
     CREATE TEMP TABLE _tmpGoods_SUN (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 2.5. "���� ������ � ���"... ���� � ����� �� ����� ��� ������������ ����� X, �� � ������������ ������� ������ ������������ ����� Y � ��� �� ����������
     CREATE TEMP TABLE _tmpGoods_SUN_PairSun (GoodsId Integer, GoodsId_PairSun Integer, PairSunAmount TFloat) ON COMMIT DROP;

     -- 3.1. ��� �������, ����
     CREATE TEMP TABLE _tmpRemains_Partion_all   (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_all_a (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat) ON COMMIT DROP;
     -- 3.2. �������, ���� - ��� �������������
     CREATE TEMP TABLE _tmpRemains_Partion   (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat, AmountCorrec TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_a (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat, AmountCorrec TFloat) ON COMMIT DROP;

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
                                 , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, isClose boolean
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
                                 ) ON COMMIT DROP;
     -- ��������� - ������ ��������
     INSERT INTO _tmpResult (DriverId, DriverName
                           , UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName, isClose
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
                           , Layout
                           , PromoUnit
                           , isCloseMCS
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
          SELECT Object_Driver.Id                          AS DriverId
               , Object_Driver.ValueData                   AS DriverName
               , COALESCE (tmp.UnitId, 0)      :: Integer  AS UnitId
               , COALESCE (tmp.UnitName, '')   :: TVarChar AS UnitName
               , COALESCE (tmp.GoodsId, 0)     :: Integer  AS GoodsId
               , COALESCE (tmp.GoodsCode, 0)   :: Integer  AS GoodsCode
               , COALESCE (tmp.GoodsName, '')  :: TVarChar AS GoodsName
               , COALESCE (tmp.isClose, False)             AS isClose
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
               , COALESCE (tmp.Price, 0)      :: TFloat AS Price
               , COALESCE (tmp.MCS, 0)        :: TFloat AS MCS
               , COALESCE (tmp.Layout, 0)     :: TFloat AS Layout
               , COALESCE (tmp.PromoUnit, 0)  :: TFloat AS PromoUnit
               , COALESCE (tmp.isCloseMCS, False)       AS isCloseMCS
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
                                                     , inDriverId := 0
                                                     , inStep     := 1
                                                     , inUserId   := vbUserId
                                                      ) AS tmp
               LEFT JOIN ObjectLink AS ObjectLink_Unit_Driver
                                    ON ObjectLink_Unit_Driver.ObjectId      = tmp.UnitId
                                   AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
               LEFT JOIN Object AS Object_Driver ON Object_Driver.Id = ObjectLink_Unit_Driver.ChildObjectId
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
                  -- ��������
               , _tmpGoods_Layout.Layout
               , _tmpGoods_PromoUnit.Amount
               , _tmpRemains.isCloseMCS
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

               LEFT JOIN _tmpGoods_PromoUnit ON _tmpGoods_PromoUnit.UnitId = tmp.UnitId_from
                                            AND _tmpGoods_PromoUnit.GoodsId = tmp.GoodsId

               LEFT JOIN _tmpGoods_Layout ON _tmpGoods_Layout.UnitId = tmp.UnitId_from
                                         AND _tmpGoods_Layout.GoodsId = tmp.GoodsId
          ;
     RETURN NEXT Cursor2;
     

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.08.19         *
*/

-- ����
-- 
SELECT * FROM gpReport_Movement_Send_RemainsSun_over (inOperDate:= CURRENT_DATE + INTERVAL '1 DAY', inSession:= '3'); -- FETCH ALL "<unnamed portal 1>";