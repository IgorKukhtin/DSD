-- Function: gpUpdate_Movement_Pretension_BranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Pretension_BranchDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Pretension_BranchDate(
    IN inMovementId          Integer   , -- ���� ������� <�������� �����������>
    IN inBranchDate          TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbNeedComplete Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := inSession;
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Pretension_BranchDate());
    
    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;
    
    --��������� ������������� ����� ����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, inBranchDate);
    
    -- ��������� ����� � <��� ���������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), inMovementId, vbUserId);

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
