-- Function: gpInsertUpdate_Object_ImportTypeItems()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, Integer, Tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportTypeItems(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inImportTypeId            Integer   ,    -- ������ �� ������� ��.����
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ImportTypeItems());
  
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ImportTypeItems(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ImportTypeItems(), vbCode_calc);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportTypeItems_ImportType(), ioId, inImportTypeId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportTypeItems (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.07.14         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ImportTypeItems ()                            
