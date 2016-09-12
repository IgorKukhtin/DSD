-- Function: gpUpdate_Movement_ReturnIn_Contract()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_Contract (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_Contract(
    IN inMovementId        Integer               , -- ���� ���������
    IN inContractId        Integer               , --
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS Void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ReturnIn_Contract());

     -- ��������� ����� � <��������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, inContractId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.09.16         *
*/

-- ����
-- SELECT gpUpdate_Movement_ReturnIn_Contract (inMovementId:= Movement.Id, inContractId:=0, inUserId:= zfCalc_UserAdmin())
