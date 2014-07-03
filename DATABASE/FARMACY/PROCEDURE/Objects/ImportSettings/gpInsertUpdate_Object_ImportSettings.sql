-- Function: gpInsertUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettings (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Tfloat, TVarChar, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportSettings(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inJuridicalId             Integer   ,    -- ������ �� ������� ��.����
    IN inContractId              Integer   ,    -- ������ �� 
    IN inFileTypeId              Integer   ,    -- ������ �� 
    IN inImportTypeId            Integer   ,    -- ������ ��  
    IN inStartRow                Tfloat    ,    -- 
    IN inDirectory               TVarChar  ,    --  
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Contract());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Contract(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Contract(), vbCode_calc);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_FileType(), ioId, inFileTypeId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_ImportType(), ioId, inImportTypeId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_StartRow(), ioId, inStartRow);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Contract_Directory(), ioId, inDirectory);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportSettings (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Tfloat, TVarChar, TVarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.07.14         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ImportSettings ()                            
