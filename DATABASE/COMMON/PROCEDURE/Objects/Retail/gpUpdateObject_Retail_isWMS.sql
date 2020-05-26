-- Function: gpUpdate_Object_Retail_isWMS()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_isWMS (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_isWMS(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inisWMS               Boolean   , -- ��������
   OUT outisWMS              Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Retail_isWMS());

     -- �������� �������
     outisWMS:= NOT inisWMS;

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Retail_isWMS(), inId, outisWMS);

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
-- SELECT * FROM gpUpdate_Object_Retail_isWMS (ioId:= 275079, inisWMS:= 'False', inSession:= '2')
