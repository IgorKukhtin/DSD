-- Function: gpUpdate_Movement_Income_BranchDate()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OperDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OperDate (
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbDescId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Income_BranchDate());
    vbUserId := inSession;

    IF COALESCE (inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '������. �������� �� ��������!';
    END IF;

    -- ��������
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION '������.�������� ������ ����.';
    END IF;

    -- ���������� ��� ���������,  ����� ���������
    SELECT Movement.DescId    AS DescId
         , Movement.InvNumber AS InvNumber
           INTO vbDescId, vbInvNumber
    FROM Movement
    WHERE Movement.Id = inMovementId;
    
    -- ��������� <��������> c ����� ����� 
    PERFORM lpInsertUpdate_Movement (inMovementId, vbDescId, vbInvNumber, inOperDate, NULL);
    
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.07.17         *

*/
