-- Function: gpUpdateObject_Partner_EdiDesadv()

DROP FUNCTION IF EXISTS gpUpdateObject_Partner_EdiDesadv(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_EdiDesadv (
    IN ioId                  Integer   , -- ���� ������� <��������>
 INOUT inValue               Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());

     -- ���������� �������
     inValue:= NOT inValue;
     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiDesadv(), ioId, inValue);
   
  -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 06.02.15         * 
*/


-- ����
-- SELECT * FROM gpUpdateObject_Partner_EdiDesadv (ioId:= 275079, inChecked:= 'False', inSession:= '2')
