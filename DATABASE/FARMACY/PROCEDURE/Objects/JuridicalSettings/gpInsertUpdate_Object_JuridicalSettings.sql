-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, TFloat, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalSettings(
 INOUT ioId                      Integer   ,   	-- ���� ������� <��������� ��� ������� �����>
    IN inName                    TVarChar  ,    -- ������������ (����� ��������)
    IN inJuridicalId             Integer   ,    -- ��. ����
    IN inMainJuridicalId         Integer   ,    -- ��. ����
    IN inContractId              Integer   ,    -- �������
    IN inisPriceClose            Boolean   ,    -- ������ �����
    IN inBonus                   TFloat    ,    -- % �������������
    IN inStartDate               TDateTime ,    -- 
    IN inEndDate                 TDateTime ,    -- 
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalSettings());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalSettings(), 0, inName);

   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Retail(), ioId, vbObjectId);

   -- ��������� ����� � <��. �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Juridical(), ioId, inJuridicalId);

   -- ��������� ����� � <��. �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_MainJuridical(), ioId, inMainJuridicalId);

   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Contract(), ioId, inContractId);

   -- % �������������
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_JuridicalSettings_isPriceClose(), ioId, inisPriceClose);

   -- % �������������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettings_Bonus(), ioId, inBonus);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Start(), ioId, inStartDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_End(), ioId, inEndDate);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_JuridicalSettings_PriceList(Integer, Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.01.16         *                
 17.02.15                          *
 21.01.15                          *
 13.10.14                          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_JuridicalSettings ()           

--select * from gpInsertUpdate_Object_JuridicalSettings(ioId := 390626 , inName := '4456' , inJuridicalId := 59610 , inMainJuridicalId := 393053 , inContractId := 183275 , inisPriceClose := 'False' , inBonus := 0 , InStartDate := ('NULL')::TDateTime , inEndDate := ('NULL')::TDateTime ,  inSession := '3');                 
