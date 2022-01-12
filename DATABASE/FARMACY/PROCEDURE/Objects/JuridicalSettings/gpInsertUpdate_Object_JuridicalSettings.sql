-- Function: gpInsertUpdate_Object_()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalSettings(Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalSettings(
 INOUT ioId                      Integer   ,   	-- ���� ������� <��������� ��� ������� �����>
    IN inName                    TVarChar  ,    -- ������������ (����� ��������)
    IN inJuridicalId             Integer   ,    -- ��. ����
    IN inMainJuridicalId         Integer   ,    -- ��. ����
    IN inContractId              Integer   ,    -- �������
    IN inisBonusVirtual          Boolean   ,    -- ����������� �����
    IN inisPriceClose            Boolean   ,    -- ������ �����
    IN inisPriceCloseOrder       Boolean   ,    -- ������ ����� ��� ������
    IN inisSite                  Boolean   ,    -- ��� �����
    IN inisBonusClose            Boolean   ,    -- �� ��������� ������
    IN inBonus                   TFloat    ,    -- % �������������
    IN inPriceLimit              TFloat    ,    -- ���� ��
    IN inConditionalPercent      TFloat    ,    -- ���.������� �� ������, %
    IN inStartDate               TDateTime ,    -- 
    IN inEndDate                 TDateTime ,    -- 
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalSettings());
   vbUserId:= inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   IF COALESCE (ioId, 0) = 0
   THEN
     vbCode_calc:= lfGet_ObjectCode (0, zc_Object_JuridicalSettings());
   ELSE
     vbCode_calc:= (SELECT ObjectCode from Object WHERE Object.Id = ioId);
   END IF;

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalSettings(), vbCode_calc, inName);

   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Retail(), ioId, vbObjectId);

   -- ��������� ����� � <��. �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Juridical(), ioId, inJuridicalId);

   -- ��������� ����� � <��. �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_MainJuridical(), ioId, inMainJuridicalId);

   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalSettings_Contract(), ioId, inContractId);

   -- ����� ������
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_JuridicalSettings_isPriceClose(), ioId, inisPriceClose);
   -- ����� ������ ��� ������
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder(), ioId, inisPriceCloseOrder);
   -- ����� ������
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_JuridicalSettings_isBonusClose(), ioId, inisBonusClose);

   -- % �������������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettings_Bonus(), ioId, inBonus);
   -- ���� ��
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_JuridicalSettings_PriceLimit(), ioId, inPriceLimit);

   -- ���.������� �� ������, %
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_ConditionalPercent(), inJuridicalId, inConditionalPercent);

   -- ��������� �������� <����������� �����>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_BonusVirtual(), ioId, inisBonusVirtual);

   -- ��������� �������� <��� �����>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_Site(), ioId, inisSite);


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
 07.02.19         * inisBonusClose
 22.10.18         *
 14.11.16         * add BonusVirtual
 13.04.16         *
 18.02.16         *
 11.02.16
 26.01.16         *                
 17.02.15                          *
 21.01.15                          *
 13.10.14                          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_JuridicalSettings ()           

--select * from gpInsertUpdate_Object_JuridicalSettings(ioId := 390626 , inName := '4456' , inJuridicalId := 59610 , inMainJuridicalId := 393053 , inContractId := 183275 , inisPriceClose := 'False' , inBonus := 0 , InStartDate := ('NULL')::TDateTime , inEndDate := ('NULL')::TDateTime ,  inSession := '3');                 