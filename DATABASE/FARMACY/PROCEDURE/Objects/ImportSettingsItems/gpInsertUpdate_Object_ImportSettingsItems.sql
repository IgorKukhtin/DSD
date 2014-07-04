-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportSettingsItems(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inImportSettingsId        Integer   ,    -- ������ �� ������� ��.����
    IN inImportTypeItemsId       Integer   ,    -- ������ �� 
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());

   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ImportTypeItems(), inName);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportTypeItems(), 0, inName);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportTypeItems_ImportSettings(), ioId, inImportSettingsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportTypeItems_ImportTypeItems(), ioId, inImportTypeItemsId);
     
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.07.14         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ImportSettingsItems ()                            
