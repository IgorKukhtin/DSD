-- Function: gpUpdateObject_Contract_isVat()

DROP FUNCTION IF EXISTS gpUpdateObject_Contract_isVat (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Contract_isVat(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inisVAT               Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract_isVAT());

     -- �������� �������
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
-- SELECT * FROM gpUpdateObject_Contract_isVat (ioId:= 275079, inisVAT:= 'False', inSession:= '2')
