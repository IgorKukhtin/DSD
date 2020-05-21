-- Function: gpUpdate_Object_Contract_isWMS()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract_isWMS (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract_isWMS(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inisWMS               Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract_isWMS());

     -- �������� �������
     inisWMS:= NOT inisWMS;

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Contract_isWMS(), inId, inisWMS);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.05.20         *
*/


-- ����
-- SELECT * FROM gpUpdate_Object_Contract_isWMS (ioId:= 275079, inisWMS:= 'False', inSession:= '2')
