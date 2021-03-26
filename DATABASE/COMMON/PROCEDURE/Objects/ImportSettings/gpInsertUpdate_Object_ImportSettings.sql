-- Function: gpInsertUpdate_Object_ImportSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportSettings (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer,Integer, Integer, Boolean, TVarChar, TBlob, TVarChar, TVarChar, TFloat, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportSettings(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inJuridicalId             Integer   ,    -- ������ �� ������� ��.����
    IN inContractId              Integer   ,    -- ������ �� 
    IN inFileTypeId              Integer   ,    -- ������ �� 
    IN inImportTypeId            Integer   ,    -- ������ ��  
    IN inEmailId                 Integer   ,    -- ������ ��  
    IN inContactPersonId         Integer   ,    -- ������ �� ���������� ����
    IN inStartRow                Integer   ,    -- 
    IN inHDR                     Boolean   ,    -- 
    IN inDirectory               TVarChar  ,    --  
    IN inQuery                   TBlob     , 
    IN inStartTime               TVarChar  ,
    IN inEndTime                 TVarChar  ,
    IN inTime                    TFloat    ,
    IN inIsMultiLoad             Boolean   ,
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
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportSettings());
   -- vbUserId := lpGetUserBySession (inSession); 
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

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
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_FileType(), ioId, inFileTypeId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_ImportType(), ioId, inImportTypeId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_Email(), ioId, inEmailId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportSettings_ContactPerson(), ioId, inContactPersonId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ImportSettings_HDR(), ioId, inHDR);

   -- ��������� �������� <����� ��� ��������� �����>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ImportSettings_MultiLoad(), ioId, inIsMultiLoad);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjecTFloat_ImportSettings_StartRow(), ioId, inStartRow);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjecTFloat_ImportSettings_Time(), ioId, inTime);

   IF COALESCE(inStartTime,'') <> '' 
   THEN 
       vbStartTime:= ( '' ||CURRENT_DATE::Date || ' '||inStartTime ::Time):: TDateTime;
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_ImportSettings_StartTime(), ioId, vbStartTime);
   END IF;
   IF COALESCE(inEndTime,'') <> '' 
   THEN 
       vbEndTime  := ( '' ||CURRENT_DATE::Date || ' '||inEndTime ::Time):: TDateTime;
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_ImportSettings_EndTime(), ioId, vbEndTime);
   END IF;
   
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportSettings_Directory(), ioId, inDirectory);

   PERFORM lpInsertUpdate_ObjectBlob(zc_ObjectBlob_ImportSettings_Query(), ioId, inQuery);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.03.16         *
 16.09.14                         * 
 09.09.14                         * 
 02.07.14         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ImportSettings ()                            
-- select * from gpInsertUpdate_Object_ImportSettings(ioId := 0 , inCode := 0 , inName := '���' , inJuridicalId := 141 , inContractId := 151 , inFileTypeId := 0 , inImportTypeId := 0 , inStartRow := 0 , inDirectory := '���' ,  inSession := '8');
