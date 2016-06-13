DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_AmountManual(Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_AmountManual(
    IN inMovementId          Integer   , -- ��������
    IN inMovementItemId      Integer   , -- ������ ���������
    IN inAmountManual        TFloat    , -- ���-�� ������
    IN inReasonDifferences   Integer   , -- ������� �����������
   OUT outAmountDiff         TFloat   , -- ������� �����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

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

    outAmountDiff := COALESCE(inAmountManual,0) - coalesce((Select Amount from MovementItem Where Id = inMovementItemId),0);

    IF outAmountDiff = 0
    THEN
        inReasonDifferences := 0;
    END IF;

    -- ��������� <������� �����������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReasonDifferences(), inMovementItemId, inReasonDifferences);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 17.11.15                                                                       *
*/
