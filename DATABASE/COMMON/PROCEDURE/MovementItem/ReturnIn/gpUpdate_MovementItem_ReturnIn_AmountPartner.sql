-- Function: gpUpdate_MovementItem_ReturnIn_AmountPartner()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_ReturnIn_AmountPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_ReturnIn_AmountPartner(
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
     
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn_Partner());


     -- ������������ ��������� ���������
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
            INTO vbStatusId, vbInvNumber, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;


     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
    
     -- ��������� + ��������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id, 0)
           , lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
          INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                       ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                      AND MIFloat_AmountPartner.ValueData <> 0
     WHERE MovementId = inMovementId
       AND isErased = FALSE;


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.11.15         *  
*/
