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
  DECLARE vbUserId Integer;
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
     -- 6.2. !!!������ - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     CREATE TEMP TABLE _tmpList_DefSUN (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. ������������ ����������� - �� ������� �� �������
     CREATE TEMP TABLE _tmpResult_child (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- ���������
     CREATE TEMP TABLE _tmpResult (UnitId Integer, UnitName TVarChar
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
                                 , UnitName_next_str   TVarChar) ON COMMIT DROP;
                                 
     INSERT INTO _tmpResult (UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale         
                           , Summ_sale           
                           , AmountSun_real      
                           , AmountSun_summ_save 
                           , AmountSun_summ      
                           , AmountResult        
                           , AmountResult_summ   
                           , AmountRemains       
                           , AmountIncome        
                           , AmountSend          
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
                           , UnitName_next_str)
          SELECT *
          FROM lpInsert_Movement_Send_RemainsSun (inOperDate := inOperDate
                                                , inStep     := 1
                                                , inUserId   := vbUserId) AS tmp;

     

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
          FROM _tmpResult_Partion AS tmp
          LEFT JOIN Object AS Object_UnitFrom  ON Object_UnitFrom.Id  = tmp.UnitId_from
          LEFT JOIN Object AS Object_UnitTo  ON Object_UnitTo.Id  = tmp.UnitId_to
          ;
     RETURN NEXT Cursor2;

     OPEN Cursor3 FOR
          SELECT tmp.*
               , tmp.UnitId_from 
               , Object_UnitFrom.ValueData     AS FromName
               , tmp.UnitId_to
               , Object_UnitTo.ValueData       AS ToName
               , Movement_Income.Id            AS MovementId
               , Movement_Income.OperDate      AS OperDate
               , Movement_Income.Invnumber     AS Invnumber
               , tmp.ContainerId
               , tmp.MovementId
               , COALESCE (MIDate_ExpirationDate_in.ValueData, zc_DateEnd())  AS ExpirationDate_in
               
                 
          FROM _tmpResult_child AS tmp
          LEFT JOIN Object AS Object_UnitFrom ON Object_UnitFrom.Id = tmp.UnitId_from
          LEFT JOIN Object AS Object_UnitTo   ON Object_UnitTo.Id   = tmp.UnitId_to
          LEFT JOIN Movement ON Movement.Id  = tmp.MovementId

          -- ������� ���� �������� �� �������
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
                     
          LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate_in
                                            ON MIDate_ExpirationDate_in.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                           AND MIDate_ExpirationDate_in.DescId = zc_MIDate_PartionGoods()
                                           
          LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
          ;
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
-- FETCH ALL "<unnamed portal 1>";