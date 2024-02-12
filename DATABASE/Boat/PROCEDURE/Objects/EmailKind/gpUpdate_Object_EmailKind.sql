-- Function: gpUpdate_Object_EmailKind(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_EmailKind(Integer,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_EmailKind(
    IN inId	                 Integer,       -- ���� ������� 
    IN inDropBox             TVarChar,      -- ���������� ���������� � DropBox
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
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.02.24         * 

*/

-- ����
--