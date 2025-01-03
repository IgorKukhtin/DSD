-- Function: gpInsert_Movement_Send_RemainsSun

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;

   DECLARE vbDriverId_1 Integer;
   DECLARE vbDriverId_2 Integer;
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
                     WHERE Movement.OperDate = inOperDate
                       -- AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId = zc_Enum_Status_Erased()
                    )
          OR EXISTS (SELECT Movement.Id AS MovementId
                     FROM Movement
                          INNER JOIN MovementBoolean AS MovementBoolean_DefSUN
                                                     ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                                    AND MovementBoolean_DefSUN.DescId     = zc_MovementBoolean_DefSUN()
                                                    AND MovementBoolean_DefSUN.ValueData = TRUE
                     WHERE Movement.OperDate = inOperDate
                       AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId = zc_Enum_Status_Erased()
                    )
            )
     THEN
         -- �����
         RETURN;
     END IF;*/


     -- ��� ������������� ��� ����� SUN
     CREATE TEMP TABLE _tmpUnit_SUN   (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean, isOnlyTimingSUN Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_a (UnitId Integer, KoeffInSUN TFloat, KoeffOutSUN TFloat, DayIncome Integer, DaySendSUN Integer, DaySendSUNAll Integer, Limit_N TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean, isOnlyTimingSUN Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     -- ��� ������������� ��� ����� SUN-OVER
     -- CREATE TEMP TABLE _tmpUnit_SUN_over (UnitId Integer) ON COMMIT DROP;
     -- ������ �� ������� - ���� �� �������������, ����� ������ ��� ������ �����������
     CREATE TEMP TABLE _tmpUnit_SUN_balance   (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_a (UnitId Integer, Summ_out TFloat, Summ_in TFloat, KoeffInSUN TFloat, KoeffOutSUN TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_partion   (UnitId Integer, Summ_out TFloat, Summ_in TFloat, Summ_out_calc TFloat, Summ_in_calc TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpUnit_SUN_balance_partion_a (UnitId Integer, Summ_out TFloat, Summ_in TFloat, Summ_out_calc TFloat, Summ_in_calc TFloat) ON COMMIT DROP;

     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     CREATE TEMP TABLE _tmpGoods_TP_exception   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     -- ��������
     CREATE TEMP TABLE _tmpGoods_Layout  (UnitId Integer, GoodsId Integer, Layout TFloat, isNotMoveRemainder6 boolean, MovementLayoutId Integer) ON COMMIT DROP;
     -- ������������� ���� ��� �����
     CREATE TEMP TABLE _tmpGoods_PromoUnit  (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     -- ������ ���������� ��������
     CREATE TEMP TABLE _tmpGoods_DiscountExternal  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains_all   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, isGoodsCategory boolean, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_all_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, isGoodsCategory boolean, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, isCloseMCS boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, isGoodsCategory boolean, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, isGoodsCategory boolean, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat) ON COMMIT DROP;

     -- 2.1. ��� ���������� ������
     CREATE TEMP TABLE _tmpSale   (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSale_a (UnitId Integer, GoodsId Integer, Amount TFloat, Summ TFloat) ON COMMIT DROP;

     -- 2.2. ������ ��� ���������
     CREATE TEMP TABLE _tmpGoods_SUN (GoodsId Integer, KoeffSUN TFloat) ON COMMIT DROP;

     -- 2.3. "���� ������ � ���"... ���� � ����� �� ����� ��� ������������ ����� X, �� � ������������ ������� ������ ������������ ����� Y � ��� �� ����������
     CREATE TEMP TABLE _tmpGoods_SUN_PairSun (GoodsId Integer, GoodsId_PairSun Integer, PairSunAmount TFloat) ON COMMIT DROP;
     -- 2.4. ��� ������������ � ������� ���
     CREATE TEMP TABLE _tmpGoods_Sun_exception   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 3.1. ��� �������, ����
     CREATE TEMP TABLE _tmpRemains_Partion_all   (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat, Amount_6Month TFloat, isNotSold100 boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_all_a (ContainerDescId Integer, UnitId Integer, ContainerId_Parent Integer, ContainerId Integer, GoodsId Integer, Amount TFloat, PartionDateKindId Integer, ExpirationDate TDateTime, Amount_sun TFloat, Amount_notSold TFloat, Amount_6Month TFloat, isNotSold100 boolean) ON COMMIT DROP;
     -- 3.2. �������, ���� - ��� �������������
     CREATE TEMP TABLE _tmpRemains_Partion   (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat, Amount_6Month TFloat, isNotSold100 boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_Partion_a (ContainerDescId Integer, UnitId Integer, GoodsId Integer, MCSValue TFloat, Amount_sale TFloat, Amount TFloat, Amount_save TFloat, Amount_real TFloat, Amount_sun TFloat, Amount_notSold TFloat, Amount_6Month TFloat, isNotSold100 boolean) ON COMMIT DROP;


     -- 4. ������� �� ������� ���� ��������� � ����
     CREATE TEMP TABLE _tmpRemains_calc   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpRemains_calc_a (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, AmountResult TFloat, AmountRemains TFloat, AmountIncome TFloat, AmountSend_in TFloat, AmountSend_out TFloat, AmountOrderExternal TFloat, AmountReserve TFloat, AmountSun_real TFloat, AmountSun_summ TFloat, AmountSun_summ_save TFloat, AmountSun_unit TFloat, AmountSun_unit_save TFloat) ON COMMIT DROP;

     -- 5. �� ����� ����� ������� �� ������� "���������" ��������� ���������
     CREATE TEMP TABLE _tmpSumm_limit   (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpSumm_limit_a (UnitId_from Integer, UnitId_to Integer, Summ TFloat) ON COMMIT DROP;

     -- 6.1. ������������-1 ������� �� ������� - �� ���� ������� - ����� ������ >= vbSumm_limit
     CREATE TEMP TABLE _tmpResult_Partion   (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer, Amount_not_out TFloat, Summ_not_out TFloat, Amount_not_in TFloat, Summ_not_in TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_Partion_a (DriverId Integer, UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, Summ TFloat, Amount_next TFloat, Summ_next TFloat, MovementId Integer, MovementItemId Integer, Amount_not_out TFloat, Summ_not_out TFloat, Amount_not_in TFloat, Summ_not_in TFloat) ON COMMIT DROP;
     -- 6.2. !!!������ - DefSUN - ���� 2 ��� ���� � �����������, �.�. < vbSumm_limit - ����� ��� ����������� �� ����� !!!
     CREATE TEMP TABLE _tmpList_DefSUN   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpList_DefSUN_a (UnitId_from Integer, UnitId_to Integer, GoodsId Integer) ON COMMIT DROP;

     -- 7.1. ������������ ����������� - �� ������� �� �������
     CREATE TEMP TABLE _tmpResult_child   (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_child_a (MovementId Integer, UnitId_from Integer, UnitId_to Integer, ParentId Integer, ContainerId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 8. ��������� ����� �����������
     CREATE TEMP TABLE _tmpUnit_SunExclusion (UnitId_from Integer, UnitId_to Integer) ON COMMIT DROP;

     -- !!!OVER!!!
     -- INSERT INTO _tmpUnit_SUN_over (UnitId)
     --    SELECT OB.ObjectId FROM ObjectBoolean AS OB WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN_v2();

     -- !!!������ ��������!!!
     vbDriverId_1 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                     );
     -- !!!1 - ������������ ������ �� ��������� ����!!!
     PERFORM lpInsert_Movement_Send_RemainsSun (inOperDate:= inOperDate
                                              , inDriverId:= 0 -- vbDriverId_1
                                              , inStep    := 1
                                              , inUserId  := vbUserId
                                               );
     -- !!!1 - ��������� ������
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;
     INSERT INTO _tmpResult_child_a   SELECT * FROM _tmpResult_child;



     -- !!!������ ��������!!!
     /*vbDriverId_2 := (SELECT MAX (ObjectLink_Unit_Driver.ChildObjectId)
                      FROM ObjectLink AS ObjectLink_Unit_Driver
                           JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Driver.ObjectId AND Object_Unit.isErased = FALSE
                      WHERE ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                        AND ObjectLink_Unit_Driver.ChildObjectId <> vbDriverId_1
                     );
     -- !!!2 - ������������ ������ �� ��������� ����!!!
     PERFORM lpInsert_Movement_Send_RemainsSun (inOperDate:= inOperDate
                                              , inDriverId:= vbDriverId_2
                                              , inStep    := 1
                                              , inUserId  := vbUserId
                                               );
     -- !!!2 - ��������� ������
     INSERT INTO _tmpResult_Partion_a SELECT * FROM _tmpResult_Partion;
     INSERT INTO _tmpResult_child_a   SELECT * FROM _tmpResult_child;*/
      

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
                --
                INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                          AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                          AND MovementBoolean_SUN.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                          ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                         AND MovementBoolean_SUN_v2.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                          ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                         AND MovementBoolean_SUN_v3.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                          ON MovementBoolean_SUN_v4.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v4.DescId     = zc_MovementBoolean_SUN_v3()
                                         AND MovementBoolean_SUN_v4.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_BanFiscalSale
                                          ON MovementBoolean_BanFiscalSale.MovementId = Movement.Id
                                         AND MovementBoolean_BanFiscalSale.DescId     = zc_MovementBoolean_BanFiscalSale()
                                         AND MovementBoolean_BanFiscalSale.ValueData  = TRUE
                LEFT JOIN MovementString AS MovementString_Comment
                                         ON MovementString_Comment.MovementId = Movement.Id
                                        AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                         
                -- !!!����� ����� �����!!!
                -- LEFT JOIN _tmpUnit_SUN_over ON _tmpUnit_SUN_over.UnitId = MovementLinkObject_From.ObjectId
           WHERE Movement.OperDate = inOperDate
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId = zc_Enum_Status_Erased()
           --AND _tmpUnit_SUN_over.UnitId IS NULL
             AND MovementBoolean_SUN_v2.MovementId IS NULL
             AND MovementBoolean_SUN_v3.MovementId IS NULL
             AND MovementBoolean_SUN_v4.MovementId IS NULL
             AND MovementBoolean_BanFiscalSale.MovementId IS NULL
             AND COALESCE (MovementString_Comment.ValueData, '') <> '������������� ������ �� ���� �������� ���������� � ���1'
             AND COALESCE (MovementString_Comment.ValueData, '') <> '����� �� ���'
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
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                          ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v2.DescId     = zc_MovementBoolean_SUN_v2()
                                         AND MovementBoolean_SUN_v2.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                          ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v3.DescId     = zc_MovementBoolean_SUN_v3()
                                         AND MovementBoolean_SUN_v3.ValueData  = TRUE
                LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                          ON MovementBoolean_SUN_v4.MovementId = Movement.Id
                                         AND MovementBoolean_SUN_v4.DescId     = zc_MovementBoolean_SUN_v4()
                                         AND MovementBoolean_SUN_v4.ValueData  = TRUE
                -- !!!����� ����� �����!!!
                -- LEFT JOIN _tmpUnit_SUN_over ON _tmpUnit_SUN_over.UnitId = MovementLinkObject_From.ObjectId
           WHERE Movement.OperDate = inOperDate
             AND Movement.DescId   = zc_Movement_Send()
             AND Movement.StatusId = zc_Enum_Status_Erased()
           --AND _tmpUnit_SUN_over.UnitId IS NULL
             AND MovementBoolean_SUN_v2.MovementId IS NULL
             AND MovementBoolean_SUN_v3.MovementId IS NULL
             AND MovementBoolean_SUN_v4.MovementId IS NULL
          ) AS tmp;


     -- ������� ���������
     UPDATE _tmpResult_Partion_a SET MovementId = tmp.MovementId
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
                                              , inNumberSeats      := 1
                                              , inDriverSunId      := 0
                                              , inSession          := inSession
                                               ) AS MovementId

           FROM (SELECT DISTINCT _tmpResult_Partion_a.UnitId_from, _tmpResult_Partion_a.UnitId_to FROM _tmpResult_Partion_a WHERE _tmpResult_Partion_a.Amount > 0) AS tmp
          ) AS tmp
     WHERE _tmpResult_Partion_a.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Partion_a.UnitId_to   = tmp.UnitId_to
          ;

     -- ��������� �������� <����������� �� ���> + isAuto + zc_Enum_PartionDateKind_6
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartionDateKind(), tmp.MovementId, zc_Enum_PartionDateKind_6())
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Driver(),          tmp.MovementId, tmp.DriverId)
     FROM (SELECT DISTINCT _tmpResult_Partion_a.MovementId, _tmpResult_Partion_a.DriverId FROM _tmpResult_Partion_a WHERE _tmpResult_Partion_a.Amount > 0
          ) AS tmp;
     -- ��������� �������� <�������� ����������� �� ���> + isAuto + zc_Enum_PartionDateKind_6
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DefSUN(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartionDateKind(), tmp.MovementId, zc_Enum_PartionDateKind_6())
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Driver(),          tmp.MovementId, tmp.DriverId)
     FROM (SELECT DISTINCT _tmpResult_Partion_a.MovementId, _tmpResult_Partion_a.DriverId FROM _tmpResult_Partion_a WHERE _tmpResult_Partion_a.Amount_next > 0
          ) AS tmp;


     -- 6.1. ������� ������ - ����������� �� ���
     UPDATE _tmpResult_Partion_a SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inCommentSendID         := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Partion_a AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp
     WHERE _tmpResult_Partion_a.MovementId = tmp.MovementId
       AND _tmpResult_Partion_a.GoodsId    = tmp.GoodsId
          ;

     -- 6.2. ������� ������ - �������� ����������� �� ���
     UPDATE _tmpResult_Partion_a SET MovementItemId = tmp.MovementItemId
     FROM (SELECT _tmpResult_Partion.MovementId
                , _tmpResult_Partion.GoodsId
                , lpInsertUpdate_MovementItem_Send (ioId                   := 0
                                                  , inMovementId           := _tmpResult_Partion.MovementId
                                                  , inGoodsId              := _tmpResult_Partion.GoodsId
                                                  , inAmount               := _tmpResult_Partion.Amount_next
                                                  , inAmountManual         := 0
                                                  , inAmountStorage        := 0
                                                  , inReasonDifferencesId  := 0
                                                  , inCommentSendID         := 0
                                                  , inUserId               := vbUserId
                                                   ) AS MovementItemId
           FROM _tmpResult_Partion_a AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount_next > 0
          ) AS tmp
     WHERE _tmpResult_Partion_a.MovementId = tmp.MovementId
       AND _tmpResult_Partion_a.GoodsId    = tmp.GoodsId
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
     FROM _tmpResult_child_A AS _tmpResult_child
          LEFT JOIN (SELECT DISTINCT
                            _tmpResult_Partion.MovementId
                          , _tmpResult_Partion.UnitId_from
                          , _tmpResult_Partion.UnitId_to
                          , _tmpResult_Partion.MovementItemId AS ParentId
                          , _tmpResult_Partion.GoodsId
                     FROM _tmpResult_Partion_a AS _tmpResult_Partion
                    ) AS tmpResult_Partion
                      ON tmpResult_Partion.UnitId_from = _tmpResult_child .UnitId_from
                     AND tmpResult_Partion.UnitId_to   = _tmpResult_child .UnitId_to
                     AND tmpResult_Partion.GoodsId     = _tmpResult_child .GoodsId
                    ;


     -- 8. ������� ���������, ��� � �� ������
     /*PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Partion_a.MovementId FROM _tmpResult_Partion_a WHERE _tmpResult_Partion_a.MovementId > 0
          ) AS tmp;*/



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
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun (inOperDate:= CURRENT_DATE + INTERVAL '2 DAY', inSession:= zfCalc_UserAdmin()) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ


