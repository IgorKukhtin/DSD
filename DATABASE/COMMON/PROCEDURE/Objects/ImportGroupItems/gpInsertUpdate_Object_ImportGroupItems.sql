-- Function: gpInsertUpdate_Object_ImportType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportGroupItems (Integer, Integer, Integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportGroupItems(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inImportSettingsId        Integer   ,    -- 
    IN inImportGroupId           Integer   ,    -- 
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportType());
   vbUserId := lpGetUserBySession (inSession); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportGroupItems(), 0, '');

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportGroupItems_ImportSettings(), ioId, inImportSettingsId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportGroupItems_ImportGroup(), ioId, inImportGroupId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportGroupItems (Integer, Integer, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.09.14                         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ImportType ()                            
