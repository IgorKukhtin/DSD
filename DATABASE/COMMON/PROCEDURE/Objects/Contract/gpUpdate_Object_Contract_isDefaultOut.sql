-- Function: gpUpdateObject_Contract_isVat()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract_isDefaultOut (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract_isDefaultOut(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inisDefaultOut        Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());

     -- �������� �������
     inisDefaultOut:= NOT inisDefaultOut;

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_DefaultOut(), inId, inisDefaultOut);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.03.16         *
*/


-- ����
-- SELECT * FROM gpUpdate_Object_Contract_isDefaultOut (inId:= 275079, inisDefaultOut:= 'False', inSession:= '2')
