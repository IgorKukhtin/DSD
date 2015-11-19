DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_SetEqualAmount(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_SetEqualAmount(
    IN inMovementId          Integer   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     
    SELECT 
        StatusId
      , InvNumber 
    INTO 
        vbStatusId
      , vbInvNumber   
    FROM 
        Movement 
    WHERE
        Id = inMovementId;
     
    --
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������. ��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
    END IF;

    vbUserId := inSession::Integer;
    
    
    --��������� <���-�� ������>
    PERFORM 
        lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), MovementItem.Id, MovementItem.Amount),
        lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReasonDifferences(), MovementItem.Id, 0)
    FROM
        MovementItem
    WHERE
        MovementItem.MovementId = inMovementId;

    -- ��������� ��������
    -- PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 17.11.15                                                                       *
*/

        
