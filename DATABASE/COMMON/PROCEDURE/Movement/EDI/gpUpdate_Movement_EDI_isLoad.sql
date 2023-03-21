-- Function: gpUpdate_Movement_EDI_isLoad()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_isLoad (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDI_isLoad(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inisLoad              Boolean   , -- 
    IN inSession             TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Params());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), inMovementId, inisLoad);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.03.23                                                       * 
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_EDI_isLoad (inMovementId:= 10, inisLoad:= False, inSession:= '2')
