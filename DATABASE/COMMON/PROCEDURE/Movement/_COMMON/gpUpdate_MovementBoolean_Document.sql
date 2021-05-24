-- Function: gpUpdate_MovementBoolean_Document()

DROP FUNCTION IF EXISTS gpUpdate_MovementBoolean_Document (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementBoolean_Document(
    IN ioId                  Integer   , -- ���� ������� <��������>
 INOUT inDocument             Boolean   , -- ��������
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
     inDocument:= NOT inDocument;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), ioId, inDocument);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 18.08.14                                        * add lpInsert_MovementProtocol
*/


-- ����
-- SELECT * FROM gpUpdate_MovementBoolean_Document (ioId:= 275079, inDocument:= 'False', inSession:= '2')
