-- Function: gpInsertUpdate_Object_FileTypeKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_FileTypeKind (Integer, Integer, TVarChar, Integer, Integer, TVarChar, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_FileTypeKind(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������>
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inJuridicalBasisId        Integer   ,    -- ������ �� ������� ��.����
    IN inJuridicalId             Integer   ,    -- ������ ��  ��.����
    IN inComment                 TVarChar  ,    --  
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_FileTypeKind());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_FileTypeKind());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_FileTypeKind(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_FileTypeKind(), vbCode_calc);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_FileTypeKind_JuridicalBasis(), ioId, inJuridicalBasisId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_FileTypeKind_Juridical(), ioId, inJuridicalId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_FileTypeKind_Comment(), ioId, inComment);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_FileTypeKind (Integer, Integer, TVarChar, Integer, Integer, TVarChar, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.07.14         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_FileTypeKind ()                            
