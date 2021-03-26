-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar, TVarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportSettingsItems(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inName                    TVarChar  ,    -- �������� ���������
    IN inImportSettingsId        Integer   ,    -- ������ �� ��������� �������
    IN inImportTypeItemsId       Integer   ,    -- ������ �� ���������
    IN inDefaultValue            TVarChar  ,    -- �������� ��������� �� ���������
    IN inConvertFormatInExcel    Boolean   DEFAULT FALSE,  -- �������������� ������ � Excel
    IN inSession                 TVarChar  DEFAULT ''      -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   -- vbUserId := lpGetUserBySession (inSession); 
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportSettingsItems(), 0, inName);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettingsItems_ImportSettings(), ioId, inImportSettingsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettingsItems_ImportTypeItems(), ioId, inImportTypeItemsId);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportSettingsItems_DefaultValue(), ioId, inDefaultValue);
   
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ImportSettingsItems_ConvertFormatInExcel(), ioId, inConvertFormatInExcel);
     
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportSettingsItems (Integer, TVarChar, Integer, Integer, TVarchar, Boolean, TVarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������������ �.�.
 09.02.18                                                           * 
 10.09.14                         * 
 03.07.14         * 

*/

-- ����
--select * from gpInsertUpdate_Object_ImportSettingsItems(ioId := 0 , inName := 'sfd' , inImportSettingsId := 329 , inImportTypeItemsId := 0 ,  inSession := '8');                            
