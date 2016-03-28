-- Function: gpUpdateObject_isVat()

DROP FUNCTION IF EXISTS gpUpdateObject_isVat (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_isVat(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inisVAT               Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS  Void 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract_VAT());

     -- ���������� �������
     inisVAT:= NOT inisVAT;

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_VAT(), inId, inisVAT);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.03.16         *
*/


-- ����
-- SELECT * FROM gpUpdateObject_isVat (ioId:= 275079, inisVAT:= 'False', inSession:= '2')
