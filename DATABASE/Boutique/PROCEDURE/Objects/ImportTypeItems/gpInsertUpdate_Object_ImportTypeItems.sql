-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, TVarChar, Integer, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, TVarChar, Integer, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportTypeItems(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inParamNumber             Integer   ,    -- ����� ���������
    IN inName                    TVarChar  ,    -- �������� ���������
    IN inParamType               TVarChar  ,    -- ��� ���������
    IN inUserParamName           TVarChar  ,    -- �������� ��������� ��� ������������
    IN inImportTypeId            Integer   ,    -- ������ �� ������� ��.����
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   vbUserId := lpGetUserBySession (inSession); 
  
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportTypeItems(), inParamNumber, inName);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportTypeItems_ImportType(), ioId, inImportTypeId);
   
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportTypeItems_ParamType(), ioId, inParamType);  
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportTypeItems_UserParamName(), ioId, inUserParamName);  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.14                          * 
 02.07.14         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ImportTypeItems ()                            
