DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_SetAmountManual(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_SetAmountManual(
    IN inMovementId          Integer   , -- ��������
    IN inMovementItemId      Integer   , -- �������� ������
    IN inAmountManual        TFloat    , -- ����. ���-��
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

    IF vbUserId NOT IN (3, 59591, 183242, 4183126)
    THEN
      RETURN;     
    END IF;     
    
    IF COALESCE(inAmountManual, 0) = COALESCE((SELECT MIFloat_AmountManual.ValueData
                                               FROM MovementItemFloat AS MIFloat_AmountManual
                                               WHERE MIFloat_AmountManual.MovementItemId = inMovementItemId
                                                 AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()), 0)
    THEN
      RETURN;     
    END IF;     

    -- ������������
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
    
    -- ��������� <���-�� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), inMovementItemId, inAmountManual);

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.11.23                                                       *
*/