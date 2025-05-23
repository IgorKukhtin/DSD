-- Function: gpInsert_Movement_Send_RemainsSun_Supplement

DROP FUNCTION IF EXISTS gpInsert_Movement_Send_RemainsSun_Supplement (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_RemainsSun_Supplement(
    IN inOperDate            TDateTime , -- ���� ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbisShoresSUN Boolean;
   DECLARE vbDOW_curr    Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
     vbUserId := inSession;

     SELECT COALESCE(ObjectBoolean_CashSettings_ShoresSUN.ValueData, FALSE) 
     INTO vbisShoresSUN
     FROM Object AS Object_CashSettings
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_ShoresSUN
                                  ON ObjectBoolean_CashSettings_ShoresSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_ShoresSUN.DescId = zc_ObjectBoolean_CashSettings_ShoresSUN()
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;
     
     IF vbisShoresSUN = TRUE
     THEN
       -- ���� ������
       vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                     FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                    );
                    
       IF NOT EXISTS(SELECT Object_Unit.Id
                     FROM Object AS Object_Unit
                         LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = Object_Unit.Id AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN
                                                 ON ObjectBoolean_SUN.ObjectId = Object_Unit.Id
                                                AND ObjectBoolean_SUN.DescId = zc_ObjectBoolean_Unit_SUN()
                     WHERE Object_Unit.DescId = zc_Object_Unit()
                       -- ���� ������ ���� ������ - �������� ���
                       AND OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr::TVarChar || '%' 
                       AND COALESCE (ObjectBoolean_SUN.ValueData, FALSE) = TRUE)
       THEN 
         vbisShoresSUN := FALSE;
       END IF;
     END IF;

     -- ��� ������ ��� ����� SUN Supplement
     CREATE TEMP TABLE _tmpGoods_SUN_Supplement   (GoodsId Integer, KoeffSUN TFloat, isSupplementMarkSUN1 Boolean, isSmudge Boolean, SupplementMin Integer, SupplementMinPP Integer, UnitSupplementSUN1InId Integer, isMarcCalc Boolean) ON COMMIT DROP;
     -- ��� ������������� �������� ����� SUN Supplement
     CREATE TEMP TABLE _tmpGoodsUnit_SUN_Supplement   (GoodsId Integer, UnitOutId Integer) ON COMMIT DROP;

     -- ��� ������������� ��� ����� SUN Supplement
     CREATE TEMP TABLE _tmpUnit_SUN_Supplement   (UnitId Integer, DeySupplSun1 Integer, MonthSupplSun1 Integer, isSUN_Supplement_in Boolean, isSUN_Supplement_out Boolean, isSUN_Supplement_Priority Boolean, SalesRatio TFloat, isLock_CheckMSC Boolean, isLock_CloseGd Boolean, isLock_ClosePL Boolean, isLock_CheckMa Boolean, isColdOutSUN Boolean) ON COMMIT DROP;
     -- ������ ���������� ��������
     CREATE TEMP TABLE _tmpGoods_DiscountExternal_Supplement  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;

     -- ���������� �� ����������� ���������� �� ������� - ���� ���� � ������������� �� �� ��������� �� �������������
     CREATE TEMP TABLE _tmpGoods_TP_exception_Supplement   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- ��� ������������ � ������� ���
     CREATE TEMP TABLE _tmpGoods_Sun_exception_Supplement   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;

     -- 1. ��� �������, ��� => �������� ���-�� ����������
     CREATE TEMP TABLE _tmpRemains_all_Supplement   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Layout TFloat, AmountRemains TFloat, AmountNotSend TFloat, 
                                                     AmountSalesDay TFloat, AmountSalesMonth TFloat, AverageSalesMonth TFloat, Need TFloat, GiveAway TFloat, AmountUse TFloat, 
                                                     MinExpirationDate TDateTime, isCloseMCS boolean, SupplementMin Integer, SurplusCalc TFloat, NeedCalc TFloat) ON COMMIT DROP;

     -- 2. ��� �������, ���, � ����. ��������� ������
     CREATE TEMP TABLE _tmpStockRatio_all_Supplement   (GoodsId Integer, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AverageSales TFloat, StockRatio TFloat) ON COMMIT DROP;

     -- 3. ������������-1 ������� - �� ���� �������
     CREATE TEMP TABLE _tmpResult_Supplement   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;



     -- !!!1 - ������������ ������ �� ��������� ����!!!
     PERFORM lpInsert_Movement_Send_RemainsSun_Supplement (inOperDate:= inOperDate
                                                         , inDriverId:= 0 -- vbDriverId_1
                                                         , inUserId  := vbUserId
                                                          );

     -- ������� ���������
     UPDATE _tmpResult_Supplement SET MovementId = tmp.MovementId
     FROM (SELECT tmp.UnitId_from
                , tmp.UnitId_to
                , gpInsertUpdate_Movement_Send (ioId               := 0
                                              , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                              , inOperDate         := inOperDate
                                              , inFromId           := UnitId_from
                                              , inToId             := UnitId_to
                                              , inComment          := '������������� ������ �� ���� �������� ���������� � ���1'
                                              , inChecked          := FALSE
                                              , inisComplete       := FALSE
                                              , inNumberSeats      := 1
                                              , inDriverSunId      := 0
                                              , inSession          := inSession
                                               ) AS MovementId

           FROM (SELECT DISTINCT _tmpResult_Supplement.UnitId_from, _tmpResult_Supplement.UnitId_to FROM _tmpResult_Supplement WHERE _tmpResult_Supplement.Amount > 0) AS tmp
          ) AS tmp
     WHERE _tmpResult_Supplement.UnitId_from = tmp.UnitId_from
       AND _tmpResult_Supplement.UnitId_to   = tmp.UnitId_to
          ;

     -- ��������� �������� <����������� �� ���> + isAuto + zc_Enum_PartionDateKind_6
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(),    tmp.MovementId, TRUE)
           , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), tmp.MovementId, TRUE)
     FROM (SELECT DISTINCT _tmpResult_Supplement.MovementId FROM _tmpResult_Supplement WHERE _tmpResult_Supplement.Amount > 0
          ) AS tmp;


     -- 6.1. ������� ������ - ����������� �� ���
     UPDATE _tmpResult_Supplement SET MovementItemId = tmp.MovementItemId
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
           FROM _tmpResult_Supplement AS _tmpResult_Partion
           WHERE _tmpResult_Partion.Amount > 0
          ) AS tmp
     WHERE _tmpResult_Supplement.MovementId = tmp.MovementId
       AND _tmpResult_Supplement.GoodsId    = tmp.GoodsId
          ;

     -- 8. ������� ���������, ��� � �� ������
     /*PERFORM lpSetErased_Movement (inMovementId := tmp.MovementId
                                 , inUserId     := vbUserId
                                  )
     FROM (SELECT DISTINCT _tmpResult_Supplement.MovementId FROM _tmpResult_Supplement WHERE _tmpResult_Supplement.MovementId > 0
          ) AS tmp;*/

     -- ������ ������������� ���������
     IF EXISTS(SELECT _tmpResult_Supplement.MovementId FROM _tmpResult_Supplement WHERE _tmpResult_Supplement.MovementId > 0) AND 
        vbisShoresSUN = False
     THEN
       PERFORM  gpUpdate_Movement_Promo_Supplement(Movement.Id, TRUE, inSession)            
       FROM Movement
                                  
            INNER JOIN MovementBoolean AS MovementBoolean_Supplement
                                       ON MovementBoolean_Supplement.MovementId =  Movement.Id
                                      AND MovementBoolean_Supplement.DescId = zc_MovementBoolean_Supplement()
                                      AND MovementBoolean_Supplement.ValueData = True
                             
       WHERE Movement.DescId = zc_Movement_Promo();
       
       PERFORM gpUpdate_Goods_ClearSupplementSUN1(inGoodsMainId := Object_Goods_Main.Id  , inSession := inSession)
       FROM Object_Goods_Main 
       WHERE Object_Goods_Main.isSupplementSUN1 = True;
       
       UPDATE Object_Goods_Blob SET UnitSupplementSUN1Out = NULL
       WHERE Object_Goods_Blob.UnitSupplementSUN1Out IS NOT NULL;  
     END IF;
        
        
     --raise notice 'Value 05: %', (select Count(*) from _tmpResult_Supplement WHERE _tmpResult_Supplement.MovementId > 0);      
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
-- SELECT * FROM gpInsert_Movement_Send_RemainsSun_Supplement (inOperDate:= CURRENT_DATE + INTERVAL '2 DAY', inSession:= zfCalc_UserAdmin()) -- WHERE Amount_calc < AmountResult_summ -- WHERE AmountSun_summ_save <> AmountSun_summ
