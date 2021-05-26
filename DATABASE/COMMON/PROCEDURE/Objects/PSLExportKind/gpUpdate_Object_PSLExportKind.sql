-- Function: gpUpdate_Object_PSLExportKind(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpUpdate_Object_PSLExportKind (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PSLExportKind(
    IN inId             Integer,       -- ���� ������� <>
    IN inCode           Integer,       -- �������� <>
    IN inName           TVarChar,      -- �������� <>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_PSLExportKind());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- ��������� <������>
   PERFORM lpInsertUpdate_Object (ioId, zc_Object_PSLExportKind(), inCode, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.03.21         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PSLExportKind(2, 2,'��','2')
