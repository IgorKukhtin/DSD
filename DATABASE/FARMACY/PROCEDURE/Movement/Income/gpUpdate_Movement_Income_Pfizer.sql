-- Function: gpUpdate_Movement_Income_Pfizer()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_Pfizer (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_Pfizer(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
    vbUserId := inSession;

    -- ��������� �������� <���������������� (��/���)> - ��������� ��������� ��������� �� ������������� � ��������� Pfizer ���
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), inMovementId, TRUE);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.12.16                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Income_Pfizer (inMovementId:= 0, inSession:= '2')
