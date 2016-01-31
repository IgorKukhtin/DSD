-- Function: gpUpdateMovement_isDocument()

DROP FUNCTION IF EXISTS gpUpdateMovement_isDocument (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_isDocument(
    IN ioId                  Integer   , -- ���� ������� <��������>
 INOUT inisDocument             Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= inSession;  

     -- ���������� �������
     inisDocument:= NOT inisDocument;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), ioId, inisDocument);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
  30.01.16        * 
*/


-- ����
-- SELECT * FROM gpUpdateMovement_isDocument (ioId:= 275079, inisDocument:= 'False', inSession:= '2')
