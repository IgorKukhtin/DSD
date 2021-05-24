-- Function: gpUpdateMovement_Close()

DROP FUNCTION IF EXISTS gpUpdateMovement_Close (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Close(
    IN ioId                  Integer   , -- ���� ������� <��������>
 INOUT inisClosed            Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- ���������� �������
     inisClosed:= NOT inisClosed;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Closed(), ioId, inisClosed);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.05.17         * 
*/


-- ����
-- SELECT * FROM gpUpdateMovement_Close (ioId:= 275079, inClose:= 'False', inSession:= '2')
