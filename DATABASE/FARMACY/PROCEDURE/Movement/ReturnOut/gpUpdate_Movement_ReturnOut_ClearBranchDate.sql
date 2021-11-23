-- Function: gpUpdate_Movement_ReturnOut_ClearBranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnOut_ClearBranchDate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnOut_ClearBranchDate(
    IN inMovementId          Integer   , -- ���� ������� <�������� �����������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := inSession;
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ReturnOut_BranchDate());
    
    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;
    
    IF NOT EXISTS(SELECT 1 FROM MovementDate AS MovementDate_Branch
                  WHERE MovementDate_Branch.MovementId = inMovementId
                    AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                    AND MovementDate_Branch.ValueData IS NOT NULL)
    THEN
      RETURN;
    END IF;

    -- ��������� ���������
    SELECT
        Movement.StatusId
    INTO
        vbStatusId
    FROM Movement
    WHERE Movement.Id = inMovementId;

    -- �������� ������ � �� ����������� ����������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
    THEN
       RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);   
    END IF;
       
    --��������� ������������� ����� ����
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, Null);
    
    -- ��������� ����� � <��� ���������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), inMovementId, Null);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.11.21                                                       * 
*/
