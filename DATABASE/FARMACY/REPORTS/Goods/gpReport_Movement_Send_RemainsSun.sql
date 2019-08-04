-- Function: gpReport_Movement_Send_RemainsSun()

DROP FUNCTION IF EXISTS gpReport_Movement_Send_RemainsSun (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun(
    IN inOperDate      TDateTime, 
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
  DECLARE Cursor1 refcursor;
  DECLARE Cursor2 refcursor;
  DECLARE Cursor3 refcursor;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpGetUserBySession (inSession);
    vbUserId := inSession;


     -- ��� ������������� ��� ����� SUN
     CREATE TEMP TABLE _tmpUnit_SUN (UnitId Integer) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2. ��� ���������� ������
     CREATE TEMP TABLE _tmpSale (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;

     -- 3.1. ��� �������, ����
     CREATE TEMP TABLE _tmpRemains_Partion_all (UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime) ON COMMIT DROP;
     -- 3.2. �������, ���� - ��� �������������
     CREATE TEMP TABLE _tmpRemains_Partion (UnitId Integer, GoodsId Integer, Amount TFloat, Amount_save TFloat, Amount_real TFloat) ON COMMIT DROP;


     -- 4. ������� �� ������� ���� ��������� � ����
     CREATE TEMP TABLE _tmpRemains_calc (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     CREATE TEMP TABLE _tmpSumm_limit (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;

     -- 7.1. ������������ ����������� - �� ������� �� �������
     CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;


     OPEN Cursor1 FOR 
          SELECT *
          FROM lpInsert_Movement_Send_RemainsSun (inOperDate := inOperDate
                                                , inUserId   := vbUserId) AS tmp;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
          SELECT *
          FROM _tmpResult_Partion
     RETURN NEXT Cursor2;

     OPEN Cursor3 FOR
          SELECT *
          FROM _tmpResult_child
     RETURN NEXT Cursor3;


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