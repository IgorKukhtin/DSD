-- Function: gpUpdate_Scale_Movement_PersonalLoss()

DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_PersonalLoss (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement_PersonalLoss(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- ���� �������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� ����� � <��������� ������������� 1>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, inPersonalId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 24.03.16                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_Movement_PersonalLoss (inMovementId:= 0, inSession:= '2')
