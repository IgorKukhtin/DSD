-- Function: gpInsert_Movement_Send_RemainsSun_Supplement

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun_Supplement_V2 (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun_Supplement_V2(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;

     -- ��� ������������� ��� ����� SUN Supplement_V2
     CREATE TEMP TABLE _tmpUnit_SUN_Supplement_V2 (UnitId Integer, DeySupplOut Integer, DeySupplIn Integer, isSUN_Supplement_V2_in Boolean, isSUN_Supplement_V2_out Boolean, isSUN_Supplement_V2_Priority Boolean) ON COMMIT DROP;

     -- ��������
     CREATE TEMP TABLE _tmpGoodsLayout_SUN_Supplement_V2 (GoodsId Integer, UnitId Integer, Layout TFloat) ON COMMIT DROP;

     -- ������������� ���� ��� �����
     CREATE TEMP TABLE _tmpGoods_PromoUnit_Supplement_V2 (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- ������ ���������� ��������
     CREATE TEMP TABLE _tmpGoods_DiscountExternal_Supplement_V2  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     CREATE TEMP TABLE _tmpGoods_TP_exception_Supplement_V2   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- ��� ������������ � ������� ���
     CREATE TEMP TABLE _tmpGoods_Sun_exception_Supplement_V2   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- ��������� ����� �����������
     CREATE TEMP TABLE _tmpUnit_SunExclusion_Supplement_V2 (UnitId_from Integer, UnitId_to Integer) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains_all_Supplement_V2 (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountRemains TFloat, AmountNotSend TFloat, 
                                                     AmountSalesDay TFloat, Need TFloat, Give TFloat, AmountUse TFloat, 
                                                     MinExpirationDate TDateTime, isCloseMCS boolean) ON COMMIT DROP;

     -- 3. ������������-1 ������� - �� ���� �������
     CREATE TEMP TABLE _tmpResult_Supplement_V2   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;

     -- !!!1 - ������������ ������ �� ��������� ����!!!
     PERFORM lpInsert_Movement_Send_RemainsSun_Supplement_V2 (inOperDate:= inOperDate
                                                            , inDriverId:= 0 -- vbDriverId_1
                                                            , inUserId  := vbUserId
                                                             );

     --raise notice 'Value 06: %', (select Count(*) from _tmpResult_Supplement_V2);

     --DELETE FROM _tmpResult_Supplement_V2
     --WHERE _tmpResult_Supplement_V2.UnitId_to <> (SELECT _tmpResult_Supplement_V2.UnitId_to FROM _tmpResult_Supplement_V2 LIMIT 1);
          
     -- ������� ���������
     UPDATE _tmpResult_Supplement_V2 SET MovementId = tmp.MovementId
     FROM (SELECT tmp.UnitId_from
                , tmp.UnitId_to
                , gpInsertUpdate_Movement_Send (ioId               := 0
                                              , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                              , inOperDate         := inOperDate
                                              , inFromId           := UnitId_from
                                              , inToId             := UnitId_to
                                              , inComment          := '������������� ������ �� ���� �������� ���������� � ���2'
                                              , inChecked          := FALSE
                                              , inisComplete       := FALSE
                                              , inNumberSeats      := 1
                                              , inDriverSunId      := 0
                                              , inSession          := inSession
                                               ) AS MovementId

           FROM (SELECT DISTINCT _tmpResult_Supplement_V2.UnitId_from, _tmpResult_Supplement_V2.UnitId_to FROM _tmpResult_Supplement_V2 WHERE _tmpResult_Supplement_V2.Amount > 0) AS tmp
          ) AS tmp
     WHERE _tmpResult_Supplement_V2.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Supplement_V2.UnitId_to   = tmp.UnitId_to
          ;

     -- ��������� �������� <����������� �� ���> + isAuto + zc_Enum_PartionDateKind_6
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN_v2(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
     FROM (SELECT DISTINCT _tmpResult_Supplement_V2.MovementId FROM _tmpResult_Supplement_V2 WHERE _tmpResult_Supplement_V2.Amount > 0
          ) AS tmp;


     -- 6.1. ������� ������ - ����������� �� ���
     UPDATE _tmpResult_Supplement_V2 SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inCommentSendID        := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Supplement_V2 AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp
     WHERE _tmpResult_Supplement_V2.MovementId = tmp.MovementId
       AND _tmpResult_Supplement_V2.GoodsId    = tmp.GoodsId
          ;

     -- 8. ������� ���������, ��� � �� ������
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Supplement_V2.MovementId FROM _tmpResult_Supplement_V2 WHERE _tmpResult_Supplement_V2.MovementId > 0
          ) AS tmp;

        
     --raise notice 'Value 05: %', (select Count(*) from _tmpResult_Supplement_V2 WHERE _tmpResult_Supplement_V2.MovementId > 0);      
     --RAISE EXCEPTION '<ok>';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.19                                        *
*/

-- ����
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun_Supplement_V2 (inOperDate:= CURRENT_DATE + INTERVAL '4 DAY', inSession:= zfCalc_UserAdmin()) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ