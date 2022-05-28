-- Function: gpReport_Send_RemainsSun_express()

DROP FUNCTION IF EXISTS gpReport_Send_RemainsSun_express (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Send_RemainsSun_express (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Send_RemainsSun_express(
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


     -- ��� ������������� ��� ����� SUN-EXPRESS
     CREATE TEMP TABLE _tmpUnit_SUN   (UnitId Integer, isSUN_out Boolean, isSUN_in Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_a (UnitId Integer, isSUN_out Boolean, isSUN_in Boolean) ON COMMIT DROP;
     -- ��������
     CREATE TEMP TABLE _tmpGoods_Layout  (UnitId Integer, GoodsId Integer, Layout TFloat, isNotMoveRemainder6 boolean) ON COMMIT DROP;
     -- ������������� ���� ��� �����
     CREATE TEMP TABLE _tmpGoods_PromoUnit  (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     -- ������ ���������� ��������
     CREATE TEMP TABLE _tmpGoods_DiscountExternal  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� �������/����������� � �����������/����������
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Amount_sale TFloat, Summ_sale TFloat, AmountResult_in TFloat, AmountResult_out TFloat, AmountRemains TFloat, AmountRemains_calc_in TFloat, AmountRemains_calc_out TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_all_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Amount_sale TFloat, Summ_sale TFloat, AmountResult_in TFloat, AmountResult_out TFloat, AmountRemains TFloat, AmountRemains_calc_in TFloat, AmountRemains_calc_out TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains   (UnitId Integer, GoodsId Integer, Price TFloat, AmountResult TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_a (UnitId Integer, GoodsId Integer, Price TFloat, AmountResult TFloat) ON COMMIT DROP;
     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     CREATE TEMP TABLE _tmpGoods_TP_exception   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 2.1. ��� ���������� ������ - EXPRESS
     CREATE TEMP TABLE _tmpSale_express   (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSale_express_a (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     -- 2.3. ������ ��� ���������
     CREATE TEMP TABLE _tmpGoods_express   (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 3.2. �������, ���� - ��� �������������
     CREATE TEMP TABLE _tmpRemains_Partion   (UnitId Integer, GoodsId Integer, AmountRemains TFloat, AmountResult TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_a (UnitId Integer, GoodsId Integer, AmountRemains TFloat, AmountResult TFloat) ON COMMIT DROP;

     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     CREATE TEMP TABLE _tmpSumm_limit   (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSumm_limit_a (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion   (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_Partion_a (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;


     -- ���������
     CREATE TEMP TABLE _tmpResult (DriverId Integer, DriverName TVarChar
                                 , UnitId Integer, UnitName TVarChar
                                 , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                                 , Amount_sale         TFloat -- ���-�� ������� � ���������� (���������� �� �*24 �����)
                                 , Summ_sale           TFloat -- �����  ������� � ���������� (���������� �� �*24 �����)
                                 , AmountSun_summ      TFloat -- ����� ���-�� ��� ������������� �� ���� ������ ������������
                                 , AmountResult        TFloat -- ����������� � ����� ����������
                                 , AmountResult_summ   TFloat -- ����� ����������� � ���� ����� ����������� --���
                                 , AmountRemains       TFloat -- �������
                                 , AmountRemains_calc  TFloat -- �������
                                 , AmountIncome        TFloat -- ������ (���������) --���
                                 , AmountSend_in       TFloat -- ����������� - ������ (���������) --���
                                 , AmountSend_out      TFloat -- ����������� - ������ (���������) --���
                                 , AmountOrderExternal TFloat -- ����� (���������) --���
                                 , AmountReserve       TFloat -- ������ �� ����� --���
                                 , Price               TFloat -- ����
                                 , MCS                 TFloat -- ���
                                 , Summ_min            TFloat -- ������������ - �������� �����
                                 , Summ_max            TFloat -- ������������ - ���������� �����
                                 , Unit_count          TFloat -- ������������ - ���-�� ����� ����.
                                 , Summ_min_1          TFloat -- ������������ - ����� �������������-1: �������� �����
                                 , Summ_max_1          TFloat -- ������������ - ����� �������������-1: ���������� �����
                                 , Unit_count_1        TFloat -- ������������ - ����� �������������-1: ���-�� ����� ����.
                                 , Summ_str            TVarChar
                                 , UnitName_str        TVarChar
                                   -- !!!���������!!!
                                 , Amount_res          TFloat
                                 , Summ_res            TFloat
                                 ) ON COMMIT DROP;
     -- ��������� - ������ ��������
     INSERT INTO _tmpResult (DriverId, DriverName
                           , UnitId, UnitName
                           , GoodsId, GoodsCode, GoodsName
                           , Amount_sale
                           , Summ_sale
                           , AmountSun_summ
                           , AmountResult
                           , AmountResult_summ
                           , AmountRemains
                           , AmountRemains_calc
                           , AmountIncome
                           , AmountSend_in
                           , AmountSend_out
                           , AmountOrderExternal
                           , AmountReserve
                           , Price
                           , MCS
                           , Summ_min
                           , Summ_max
                           , Unit_count
                           , Summ_min_1
                           , Summ_max_1
                           , Unit_count_1
                           , Summ_str
                           , UnitName_str
                           , Amount_res
                           , Summ_res
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
               , tmp.AmountSun_summ
               , COALESCE (tmp.AmountResult, 0)        :: TFloat AS AmountResult
               , tmp.AmountResult_summ
               , COALESCE (tmp.AmountRemains, 0)       :: TFloat AS AmountRemains
               , COALESCE (tmp.AmountRemains_calc, 0)  :: TFloat AS AmountRemains_calc
               , COALESCE (tmp.AmountIncome, 0)        :: TFloat AS AmountIncome
               , COALESCE (tmp.AmountSend_in, 0)       :: TFloat AS AmountSend_in
               , COALESCE (tmp.AmountSend_out, 0)      :: TFloat AS AmountSend_out
               , COALESCE (tmp.AmountOrderExternal, 0) :: TFloat AS AmountOrderExternal
               , COALESCE (tmp.AmountReserve, 0)       :: TFloat AS AmountReserve
               , COALESCE (tmp.Price, 0)   :: TFloat AS Price
               , COALESCE (tmp.MCS, 0)     :: TFloat AS MCS
               , tmp.Summ_min
               , tmp.Summ_max
               , tmp.Unit_count
               , tmp.Summ_min_1
               , tmp.Summ_max_1
               , tmp.Unit_count_1
               , tmp.Summ_str
               , tmp.UnitName_str
               , tmp.Amount_res
               , tmp.Summ_res
          FROM lpInsert_Movement_Send_RemainsSun_express (inOperDate := inOperDate   
                                                        , inDriverId := 0 -- vbDriverId_1
                                                        , inStep     := 1
                                                        , inUserId   := vbUserId
                                                         ) AS tmp
         ;
     -- !!!1 - ��������� ������
     INSERT INTO _tmpUnit_SUN_a SELECT * FROM _tmpUnit_SUN;
     -- 1. ��� �������, ��� => �������� ���-�� ����������
     INSERT INTO _tmpRemains_all_a SELECT * FROM _tmpRemains_all;
     INSERT INTO _tmpRemains_a     SELECT * FROM _tmpRemains;
     -- 2. ��� ���������� ������
     INSERT INTO _tmpSale_express_a SELECT * FROM _tmpSale_express;
     -- 3.2. �������, ���� - ��� �������������
     INSERT INTO _tmpRemains_Partion_a SELECT * FROM _tmpRemains_Partion;
     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     INSERT INTO _tmpSumm_limit_a SELECT * FROM _tmpSumm_limit;
     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;



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
             --, tmp.UnitId_to
             --, tmp.UnitId_from
             --, tmp.GoodsId
               , Object_UnitFrom.ValueData AS FromName
               , tmp.UnitId_to
               , Object_UnitTo.ValueData   AS ToName
               , Object_Goods.ObjectCode   AS GoodsCode
               , Object_Goods.ValueData    AS GoodsName

                 -- ����� ���-�� ��� ������������� � ����� �����������
               , tmpRemains_Partion_sum.AmountResult AS AmountSun_summ

                 -- ���������� �� �*24 ����� � ����� �����������
               , _tmpRemains.Amount_sale
               , _tmpRemains.Summ_sale

                 -- ������� ��� �������������
               , _tmpRemains.AmountRemains
                 -- ������� - ��� ������� "���-�� ��� �������������"
               , _tmpRemains.AmountRemains_calc_out AS AmountRemains_calc
                 -- ������� - ������ "�����" ���� �������
               , _tmpRemains.AmountRemains_calc_in  AS AmountRemains_calc_all

                 -- ������ (���������)--���
               , _tmpRemains.AmountIncome
                 -- ����������� - ������ (���������)--���
               , _tmpRemains.AmountSend_in
                 -- ����������� - ������ (���������)--���
               , _tmpRemains.AmountSend_out
                 -- ����� (���������)--���
               , _tmpRemains.AmountOrderExternal
                 -- ������ �� ����� + �� ����������� � CommentError--���
               , _tmpRemains.AmountReserve

               , _tmpRemains.Price
               , _tmpRemains.MCS

                 -- ��������� - ���-�� ������������ - ����������� ������
               , tmp.Amount                     AS Amount_res
               , tmp.Amount * _tmpRemains.Price AS Summ_res

               , tmpUnit_str.UnitName_str       AS UnitName_str_in
               , tmpSumm_str.Summ_str           AS Summ_str_in

          FROM _tmpResult_Partion_a AS tmp
               LEFT JOIN Object AS Object_UnitFrom  ON Object_UnitFrom.Id  = tmp.UnitId_from
               LEFT JOIN Object AS Object_UnitTo  ON Object_UnitTo.Id  = tmp.UnitId_to
               -- ����� ���-�� ��� ������������� �� ������ ������������
               INNER JOIN (SELECT _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
                                , SUM (_tmpRemains_Partion.AmountResult) AS AmountResult
                          FROM _tmpRemains_Partion_a AS _tmpRemains_Partion
                          GROUP BY _tmpRemains_Partion.UnitId, _tmpRemains_Partion.GoodsId
                         ) AS tmpRemains_Partion_sum ON tmpRemains_Partion_sum.UnitId  = tmp.UnitId_from
                                                    AND tmpRemains_Partion_sum.GoodsId = tmp.GoodsId
               -- ��� �������, ���
               LEFT JOIN _tmpRemains_all_a AS _tmpRemains
                                           ON _tmpRemains.UnitId  = tmp.UnitId_from
                                          AND _tmpRemains.GoodsId = tmp.GoodsId
               
               LEFT JOIN  Object AS Object_Goods ON Object_Goods.Id  = tmp.GoodsId
               
            -- ������ ����
            LEFT JOIN (SELECT _tmpResult.UnitId, STRING_AGG (zfConvert_FloatToString (_tmpResult.Summ_res), ';') AS Summ_str
                       FROM _tmpResult
                       WHERE _tmpResult.Summ_res > 0
                       GROUP BY _tmpResult.UnitId
                      ) AS tmpSumm_str ON tmpSumm_str.UnitId = tmp.UnitId_to
            -- ������ ����� ���� ����� ������� 
            LEFT JOIN (SELECT _tmpResult.UnitId, STRING_AGG (Object.ValueData, ';') AS UnitName_str
                       FROM _tmpResult
                            LEFT JOIN Object ON Object.Id = _tmpResult.UnitId
                       WHERE _tmpResult.Summ_res > 0
                       GROUP BY _tmpResult.UnitId
                      ) AS tmpUnit_str ON tmpUnit_str.UnitId = tmp.UnitId_to

              ;
     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.04.20         *
*/

-- ����
-- FETCH ALL "<unnamed portal 1>";
-- 
select * from gpReport_Movement_Send_RemainsSun_express(inOperDate := ('17.01.2022')::TDateTime ,  inSession := '3');