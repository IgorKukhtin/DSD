-- Function: gpUpdate_Movement_Pretension_SentDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Pretension_SentDate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Pretension_SentDate(
    IN inMovementId          Integer   , -- ���� ������� <�������� �����������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;
    
    
    --��������� ������������� ����� ����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Sent(), inMovementId, CURRENT_TIMESTAMP);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.21                                                       *
*/