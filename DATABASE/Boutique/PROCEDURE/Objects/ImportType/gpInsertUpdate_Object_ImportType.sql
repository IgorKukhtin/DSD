-- Function: gpInsertUpdate_Object_ImportType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportType (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportType(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������>
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inProcedureName           TVarChar  ,    --  
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportType());
   vbUserId := lpGetUserBySession (inSession); 

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_ImportType());

   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ImportType(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ImportType(), vbCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportType(), vbCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportType_ProcedureName(), ioId, inProcedureName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������������ �.�.
 20.03.19         *
 09.02.18                                                           *               
 02.07.14         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ImportType ()                            
