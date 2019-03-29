-- Function: gpInsertUpdate_Object_ImportSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettings (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettings (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportSettings(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inJuridicalId             Integer   ,    -- ������ �� ������� ��.����
    IN inFileTypeId              Integer   ,    -- ������ �� 
    IN inImportTypeId            Integer   ,    -- ������ ��  
    IN inStartRow                Integer   ,
    IN inDirectory               TVarChar  ,    --  
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
   DECLARE vbStartTime TDateTime;  
   DECLARE vbEndTime TDateTime;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportSettings());
   vbUserId := lpGetUserBySession (inSession); 

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_ImportSettings());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ImportSettings(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ImportSettings(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportSettings(), vbCode_calc, inName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_Juridical(), ioId, inJuridicalId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_FileType(), ioId, inFileTypeId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_ImportType(), ioId, inImportTypeId);
   
      -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjecTFloat_ImportSettings_StartRow(), ioId, inStartRow);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportSettings_Directory(), ioId, inDirectory);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.03.19         *
 03.03.16         *
 16.09.14                         * 
 09.09.14                         * 
 02.07.14         * 
*/

-- ����
-- 