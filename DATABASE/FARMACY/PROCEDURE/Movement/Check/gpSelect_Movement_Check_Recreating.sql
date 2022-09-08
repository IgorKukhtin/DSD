-- Function: gpSelect_Movement_Check_Recreating()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_Recreating (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_Recreating(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
   OUT outMovementId       Integer   , -- ���� ������� <�������� ���>
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbInvNumber Integer;
   DECLARE vbTotalSumm TFloat;
   DECLARE vbComment TVarChar;   
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    SELECT Movement.StatusId
         , '����������� �� ���� '||Movement.InvNumber ||' �� '||zfConvert_DateToString(Movement.OperDate)
         , MovementLinkObject_Unit.ObjectId
         , MovementFloat_TotalSumm.ValueData 
    INTO vbStatusId
       , vbComment
       , vbUnitId
       , vbTotalSumm
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

    WHERE Movement.Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_Complete()
    THEN
        RAISE EXCEPTION '������. ����������� ��� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- �������� ����� ���������
    SELECT COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1
    INTO vbInvNumber
    FROM Movement_Check_View
    WHERE Movement_Check_View.UnitId = vbUnitId
      AND Movement_Check_View.OperDate > CURRENT_DATE;
            
    -- ��������� <��������>
    outMovementId := lpInsertUpdate_Movement (0, zc_Movement_Check(), vbInvNumber::TVarChar, CURRENT_TIMESTAMP, NULL);

    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), outMovementId, vbUnitId);

    -- ��������� ����� � <� ����� ����������>
    PERFORM lpInsertUpdate_MovementLinkMovement(zc_MovementLinkMovement_Master(), outMovementId, inMovementId);    

    -- ����������� ��������� ����
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RoundingTo10(), outMovementId, COALESCE (MB_RoundingTo10.ValueData, FALSE))
          , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RoundingDown(), outMovementId, COALESCE (MB_RoundingDown.ValueData, FALSE))
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(), outMovementId, zc_Enum_PaidType_Cash())
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DiscountCard(), outMovementId, COALESCE (MovementLinkObject_DiscountCard.ObjectId, 0))
          -- ��������� �������� <���� ��������>
          , lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), outMovementId, CURRENT_TIMESTAMP)
          -- ��������� �������� <������������ (��������)>
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), outMovementId, vbUserId)
         -- , vbComment)
    FROM Movement
         LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                   ON MB_RoundingTo10.MovementId =  Movement.Id
                                  AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
         LEFT JOIN MovementBoolean AS MB_RoundingDown
                                   ON MB_RoundingDown.MovementId = Movement.Id
                                  AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                      ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                     AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
    WHERE Movement.ID = inMovementId;
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (outMovementId, vbUserId, True);
    
    PERFORM gpInsertUpdate_MovementItem_Check_ver2 (ioId                  := 0               -- ���� ������� <������ ���������>
                                                  , inMovementId          := outMovementId   -- ���� ������� <��������>
                                                  , inGoodsId             := MovementItem_Check_View.GoodsId       -- ������
                                                  , inAmount              := MovementItem_Check_View.Amount        -- ����������
                                                  , inPrice               := COALESCE(MovementItem_Check_View.Price, 0)              -- ����
                                                  , inPriceSale           := COALESCE(MovementItem_Check_View.PriceSale, 0)          -- ���� ��� ������
                                                  , inChangePercent       := COALESCE(MovementItem_Check_View.ChangePercent, 0)      -- % ������
                                                  , inSummChangePercent   := COALESCE(MovementItem_Check_View.SummChangePercent, 0)  -- ����� ������
                                                  , inPartionDateKindID   := MILO_PartionDateKind.ObjectId         -- ��� ����/�� ����
                                                  , inPricePartionDate    := MIFloat_PricePartionDate.ValueData    -- ���� ��������� �������� �����
                                                  , inNDSKindId           := MovementItem_Check_View.NDSKindId     -- ������ ���
                                                  , inDiscountExternalId  := MILO_DiscountExternal.ObjectId        -- ������ ���������� ����
                                                  , inDivisionPartiesID   := MILO_DivisionParties.ObjectId         -- ���������� ������ � ����� ��� �������
                                                  , inPresent             := COALESCE(MIBoolean_Present.ValueData, False)   -- �������
                                                  , inList_UID            := ''     -- UID ������
                                                  , inUserSession	      := inSession
                                                  , inSession             := inSession)
    FROM MovementItem_Check_View

         LEFT JOIN MovementItemLinkObject AS MILO_PartionDateKind
                                          ON MILO_PartionDateKind.MovementItemId = MovementItem_Check_View.Id
                                         AND MILO_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
                                         
         LEFT JOIN MovementItemLinkObject AS MILO_DiscountExternal
                                          ON MILO_DiscountExternal.MovementItemId = MovementItem_Check_View.Id
                                         AND MILO_DiscountExternal.DescId = zc_MILinkObject_DiscountExternal()

         LEFT JOIN MovementItemLinkObject AS MILO_DivisionParties
                                          ON MILO_DivisionParties.MovementItemId = MovementItem_Check_View.Id
                                         AND MILO_DivisionParties.DescId = zc_MILinkObject_DivisionParties()

         LEFT JOIN MovementItemFloat AS MIFloat_PricePartionDate
                                     ON MIFloat_PricePartionDate.MovementItemId = MovementItem_Check_View.Id
                                    AND MIFloat_PricePartionDate.DescId = zc_MIFloat_PricePartionDate()
    
         LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                       ON MIBoolean_Present.MovementItemId = MovementItem_Check_View.Id
                                      AND MIBoolean_Present.DescId = zc_MIBoolean_Present()

    WHERE MovementItem_Check_View.MovementId = inMovementId
      AND MovementItem_Check_View.isErased = False
      AND MovementItem_Check_View.Amount > 0;
      
    IF COALESCE(vbTotalSumm, 0) <> COALESCE((SELECT MovementFloat_TotalSumm.ValueData 
                                             FROM MovementFloat AS MovementFloat_TotalSumm
                                             WHERE MovementFloat_TotalSumm.MovementId =  outMovementId
                                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()), 0)
    THEN
        RAISE EXCEPTION '������. ����� ���������� ���� ����������� �� ����� ���������, ���������� � ���������� ��������������.';
    END IF;
      
    PERFORM gpUnComplete_Movement_Check (inMovementId, inSession, inSession);
    PERFORM gpSetErased_Movement_Check (inMovementId, zfCalc_UserAdmin());

    PERFORM gpComplete_Movement_Check (outMovementId, inSession);
    
  -- RAISE EXCEPTION '������.';
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.08.21                                                       *    
*/
-- ����
-- select * from gpSelect_Movement_Check_Recreating(inMovementId := 24479161 ,  inSession := '3');