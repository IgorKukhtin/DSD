-- Function: gpInsertUpdate_MovementItem_Send_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send_byUnLiquid (TDateTime, TDateTime, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send_byUnLiquid(
    IN inStartSale           TDateTime , -- ���� ������ ������
    IN inEndSale             TDateTime , -- ���� ��������� ������
    IN inFromId              Integer   , -- �� ����
    IN inToId                Integer   , -- ����
    IN inGoodsId             Integer   , -- ������
    IN inRemainsMCS_result   TFloat    , -- ����������
    IN inPrice_from          TFloat    , -- ���� �� ����
    IN inPrice_to            TFloat    , -- ���� ����
    IN inMCSPeriod           TFloat    , -- ������ ��� ������� ���
    IN inMCSDay              TFloat    , -- �� ������� ���� ���
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementId_ReportUnLiquid Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;


   IF NOT EXISTS (SELECT 1 FROM Object_GoodsPrint WHERE Object_GoodsPrint.UnitId = inFromId AND Object_GoodsPrint.GoodsId = inGoodsId AND Object_GoodsPrint.UserId = vbUserId)
   THEN
       RETURN;
   END IF;
    
    IF COALESCE(inRemainsMCS_result, 0) <> 0
    THEN
        -- ���� �� ��������� ��������� (���� - ����, �� ����, ����, ������ �������������)
        SELECT Movement.Id  
        INTO vbMovementId
        FROM Movement
          INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                     ON MovementBoolean_isAuto.MovementId = Movement.Id
                                    AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                    AND COALESCE(MovementBoolean_isAuto.ValueData, False) = True
   
          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.ID
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                       AND MovementLinkObject_From.ObjectId = inFromId
  
          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement.ID
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                       AND MovementLinkObject_To.ObjectId = inToId
  
        WHERE Movement.DescId = zc_Movement_Send() 
          AND Movement.OperDate = inEndSale
          AND Movement.StatusId <> zc_Enum_Status_Erased();
      
        IF COALESCE (vbMovementId,0) = 0 
        THEN
             -- ���� �� ��������� ����� �� ������. ������� (���� - �������������, ���. �����. ������)
             SELECT tmp.Id
             INTO vbMovementId_ReportUnLiquid
             FROM (SELECT Movement.Id  
                        , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                   FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.MovementId = Movement.ID
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                  AND MovementLinkObject_Unit.ObjectId = inFromId
                     INNER JOIN MovementDate AS MovementDate_StartSale
                                             ON MovementDate_StartSale.MovementId = Movement.Id
                                            AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                            AND MovementDate_StartSale.ValueData = inStartSale
                     INNER JOIN MovementDate AS MovementDate_EndSale
                                             ON MovementDate_EndSale.MovementId = Movement.Id
                                            AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                            AND MovementDate_EndSale.ValueData = inEndSale
                   WHERE Movement.DescId = zc_Movement_ReportUnLiquid() 
                     AND Movement.StatusId <> zc_Enum_Status_Erased()
                  ) AS tmp
             WHERE tmp.Ord = 1;

             IF COALESCE (vbMovementId_ReportUnLiquid, 0) = 0 THEN
                RAISE EXCEPTION '����������� �� ����� ���� �������. �������� <����� �� ������������ ������> �� ��������.';
             END IF;
      
             -- ���������� ����� <��������>
             vbMovementId := lpInsertUpdate_Movement_Send (ioId               := COALESCE(vbMovementId,0) ::Integer
                                                         , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) --inInvNumber
                                                         , inOperDate         := inEndSale
                                                         , inFromId           := inFromId
                                                         , inToId             := inToId
                                                         , inComment          := '' :: TVarChar
                                                         , inChecked          := FALSE
                                                         , inisComplete       := FALSE
                                                         , inNumberSeats      := 0
                                                         , inDriverSunId      := 0
                                                         , inUserId           := vbUserId
                                                         );
          
             -- ��������� �������� <������ �������������>
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);
      
             -- ��������� ����� � <�������� ����� �� ������������ ������>
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ReportUnLiquid(), vbMovementId, vbMovementId_ReportUnLiquid);

      END IF;
      
       -- ��������� �������� <������ �������������>
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);
       -- ���������/�������� <������ ��� ������� ���>
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MCSPeriod(), vbMovementId, inMCSPeriod);
       -- ���������/�������� <�� ������� ���� ���>
       PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MCSDay(), vbMovementId, inMCSDay);

      -- ���� �� ������ (���� - �� ���������, �����)
      SELECT MovementItem.Id
       INTO vbMovementItemId
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementId AND MovementItem.ObjectId = inGoodsId;

       -- ��������� ������ ���������
       vbMovementItemId := lpInsertUpdate_MovementItem_Send (ioId                 := COALESCE(vbMovementItemId,0) ::Integer
                                                           , inMovementId         := vbMovementId
                                                           , inGoodsId            := inGoodsId
                                                           , inAmount             := inRemainsMCS_result
                                                           , inAmountManual       := 0 ::TFloat
                                                           , inAmountStorage      := 0 ::TFloat
                                                           , inReasonDifferencesId:= 0
                                                           , inCommentTRID        := 0
                                                           , inUserId             := vbUserId
                                                            );
    -- ��������� <���� �� ����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceFrom(), vbMovementItemId, inPrice_from);
    -- ��������� <���� ����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTo(), vbMovementItemId, inPrice_to);

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.11.18         *
 19.06.16         *
*/

-- ����
--