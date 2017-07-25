-- Function: gpUpdate_Movement_Income_BranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_BranchDate(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_BranchDate(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inBranchDate          TDateTime , -- ���� � ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Income_BranchDate());

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;

    IF inBranchDate IS NOT NULL
    THEN
        -- 
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, inBranchDate);
    END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.07.17         *

*/
