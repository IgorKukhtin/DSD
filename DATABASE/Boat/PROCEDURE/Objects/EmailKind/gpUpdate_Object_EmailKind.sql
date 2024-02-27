-- Function: gpUpdate_Object_EmailKind(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_EmailKind(Integer,TVarChar,TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_EmailKind(Integer,TVarChar,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_EmailKind(
    IN inId	                 Integer,       -- ���� ������� 
    IN inDropBox             TVarChar,      -- ���������� ���������� � DropBox
    IN inCheckImport         TVarChar,      -- �������� �������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

 
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_EmailKind_DropBox(), inId, inDropBox);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_EmailKind_CheckImport(), inId, inCheckImport);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.02.24         * CheckImport
 12.02.24         * 

*/

-- ����
--