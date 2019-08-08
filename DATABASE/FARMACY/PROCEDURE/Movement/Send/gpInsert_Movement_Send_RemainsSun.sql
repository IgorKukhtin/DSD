-- Function: gpInsert_Movement_Send_RemainsSun

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;
     

     -- !!!����� ��� zfCalc_UserAdmin - �.�. ��������� ���� ����������� ������ 1 ���
     /*IF inSession = zfCalc_UserAdmin()
        AND (EXISTS (SELECT Movement.Id AS MovementId
                     FROM Movement
                          INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                     ON MovementBoolean_SUN.MovementId = Movement.Id
                                                    AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                    AND MovementBoolean_SUN.ValueData  = TRUE
                     WHERE Movement.OperDate = CURRENT_DATE
                       -- AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId = zc_Enum_Status_Erased()
                    )
          OR EXISTS (SELECT Movement.Id AS MovementId
                     FROM Movement
                          INNER JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                     ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                    AND MovementBoolean_DefSUN.DescId     = zc_MovementBoolean_DefSUN()
                                                    AND MovementBoolean_DefSUN.ValueData = TRUE
                     WHERE Movement.OperDate = CURRENT_DATE
                       AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId = zc_Enum_Status_Erased()
                    )
            )
     THEN
         -- �����
         RETURN;
     END IF;*/


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


     -- !!!������������ ������ �� ��������� ����!!!
     PERFORM lpInsert_Movement_Send_RemainsSun (inOperDate:= inOperDate
                                              , inStep    := 1
                                              , inUserId  := vbUserId
                                               );

      
     -- !!!������� ���������� ��������� - SUN !!!
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(), tmp.MovementId, FALSE)
     FROM (SELECT Movement.Id AS MovementId
           FROM Movement
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                -- !!!������ ��� ����� �����!!!
                -- INNER JOIN
                --
                INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                          AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                          AND MovementBoolean_SUN.ValueData  = TRUE
           WHERE Movement.OperDate = CURRENT_DATE
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId = zc_Enum_Status_Erased()
          ) AS tmp;

     -- !!!������� ���������� ��������� - DefSUN!!!
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DefSUN(), tmp.MovementId, FALSE)
     FROM (SELECT Movement.Id AS MovementId
           FROM Movement
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                -- !!!������ ��� ����� �����!!!
                -- INNER JOIN
                --
                --
                INNER JOIN MovementBoolean AS MovementBoolean_DefSUN
                                           ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                          AND MovementBoolean_DefSUN.DescId     = zc_MovementBoolean_DefSUN()
                                          AND MovementBoolean_DefSUN.ValueData = TRUE
           WHERE Movement.OperDate = CURRENT_DATE
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId = zc_Enum_Status_Erased()
          ) AS tmp;


     -- ������� ���������
     UPDATE _tmpResult_Partion SET MovementId = tmp.MovementId
     FROM (SELECT tmp.UnitId_from
                , tmp.UnitId_to
                , gpInsertUpdate_Movement_Send (ioId               := 0
                                              , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                              , inOperDate         := inOperDate
                                              , inFromId           := UnitId_from
                                              , inToId             := UnitId_to
                                              , inComment          := ''
                                              , inChecked          := FALSE
                                              , inisComplete       := FALSE
                                              , inSession          := inSession
                                               ) AS MovementId

           FROM (SELECT DISTINCT _tmpResult_Partion.UnitId_from, _tmpResult_Partion.UnitId_to FROM _tmpResult_Partion) AS tmp
          ) AS tmp
     WHERE _tmpResult_Partion.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Partion.UnitId_to   = tmp.UnitId_to
          ;

     -- ��������� �������� <����������� �� ���> + isAuto + zc_Enum_PartionDateKind_6
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartionDateKind(), tmp.MovementId, zc_Enum_PartionDateKind_6())

     FROM (SELECT DISTINCT _tmpResult_Partion.MovementId FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp;
     -- ��������� �������� <�������� ����������� �� ���> + isAuto + zc_Enum_PartionDateKind_6
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DefSUN(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartionDateKind(), tmp.MovementId, zc_Enum_PartionDateKind_6())
     FROM (SELECT DISTINCT _tmpResult_Partion.MovementId FROM _tmpResult_Partion WHERE _tmpResult_Partion.Amount_next > 0
          ) AS tmp;


     -- 6.1. ������� ������ - ����������� �� ���
     UPDATE _tmpResult_Partion SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp
     WHERE _tmpResult_Partion.MovementId = tmp.MovementId
       AND _tmpResult_Partion.GoodsId    = tmp.GoodsId
          ;

     -- 6.2. ������� ������ - �������� ����������� �� ���
     UPDATE _tmpResult_Partion SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount_next
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount_next > 0
          ) AS tmp
     WHERE _tmpResult_Partion.MovementId = tmp.MovementId
       AND _tmpResult_Partion.GoodsId    = tmp.GoodsId
          ;



     -- 7.2. ������� ������ Child - �� ���
     PERFORM lpInsertUpdate_MovementItem_Send_Child (ioId         := 0
                                                   , inParentId   := tmpResult_Partion.ParentId   -- _tmpResult_child.ParentId
                                                   , inMovementId := tmpResult_Partion.MovementId -- _tmpResult_child.MovementId
                                                   , inGoodsId    := _tmpResult_child.GoodsId
                                                   , inAmount     := _tmpResult_child.Amount
                                                   , inContainerId:= _tmpResult_child.ContainerId
                                                   , inUserId     := vbUserId
                                                    )
     FROM _tmpResult_child
          LEFT JOIN (SELECT DISTINCT
                            _tmpResult_Partion.MovementId
                          , _tmpResult_Partion.UnitId_from
                          , _tmpResult_Partion.UnitId_to
                          , _tmpResult_Partion.MovementItemId AS ParentId
                          , _tmpResult_Partion.GoodsId
                     FROM _tmpResult_Partion
                    ) AS tmpResult_Partion
                      ON tmpResult_Partion.UnitId_from = _tmpResult_child .UnitId_from
                     AND tmpResult_Partion.UnitId_to   = _tmpResult_child .UnitId_to
                     AND tmpResult_Partion.GoodsId     = _tmpResult_child .GoodsId
                    ;


     -- 8. ������� ���������, ��� � �� ������
     PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Partion.MovementId FROM _tmpResult_Partion WHERE _tmpResult_Partion.MovementId > 0
          ) AS tmp;



    -- RAISE EXCEPTION '<ok>';


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.19                                        *
*/

-- ����
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun (inOperDate:= CURRENT_DATE - INTERVAL '0 DAY', inSession:= zfCalc_UserAdmin()) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
