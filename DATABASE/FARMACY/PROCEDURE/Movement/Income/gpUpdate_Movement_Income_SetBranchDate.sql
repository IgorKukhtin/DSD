-- Function: gpUpdate_Movement_Income_SetBranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_SetBranchDate(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_SetBranchDate(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inBranchDate          TDateTime , -- ���� � ������
   OUT outBranchDate         TDateTime , -- ���� � ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Income_BranchDate());
    vbUserId := inSession;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;

    SELECT
      StatusId
    INTO
      vbStatusId
    FROM Movement
    WHERE Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF inBranchDate IS NOT NULL
    THEN
        -- ��������� <���� ������>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, inBranchDate);
        
        outBranchDate := inBranchDate;
    END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.09.21                                                       *

*/