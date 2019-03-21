-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TFloat, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime,TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Boolean, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime,TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Boolean, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������������>
    IN inCode                    Integer   ,    -- ��� ������� <�������������>
    IN inName                    TVarChar  ,    -- �������� ������� <�������������>
    IN inAddress                 TVarChar  ,    -- �����
    IN inPhone                   TVarChar,
    IN inTaxService              TFloat    ,    -- % �� �������
    IN inTaxServiceNigth         TFloat    ,    -- % �� ������� � ������ �����
    IN inStartServiceNigth       TDateTime ,
    IN inEndServiceNigth         TDateTime ,
    IN inCreateDate              TDateTime ,    -- ���� �������� �����
    IN inCloseDate               TDateTime ,    -- ���� �������� �����
    IN inTaxUnitStartDate        TDateTime ,
    IN inTaxUnitEndDate          TDateTime ,
    IN inDateSP                  TDateTime ,    -- ���� ������ ������ �� ���.�������� 
    IN inStartTimeSP             TDateTime ,    -- ����� ������ ������ �� ���.�������� 
    IN inEndTimeSP               TDateTime ,    -- ����� ���������� ������ �� ���.��������
    IN inisSp                    Boolean   ,    -- �������� �� ���.�������
    IN inisRepriceAuto           Boolean   ,    -- ��������� � ��������������
    IN inAreaId                  Integer   ,    -- ������
    IN inParentId                Integer   ,    -- ������ �� �������������
    IN inJuridicalId             Integer   ,    -- ������ �� ����������� ����
    IN inMarginCategoryId        Integer   ,    -- ������ �� ��������� �������
    IN inProvinceCityId          Integer   ,    -- ������ �� �����
    IN inUserManagerId           Integer   ,    -- ������ �� ��������
    IN inUnitCategoryId          Integer   ,    -- ������ �� ��������� 
    IN inUnitRePriceId           Integer   ,    -- ������ �� ������������� 
    IN inNormOfManDays           Integer   ,    -- ����� ������������ � ������
    IN inPartnerMedicalId        Integer   ,    -- ���.���������� ��� ���� 1303
    IN inPharmacyItem            Boolean   ,    -- �������� �����
    IN inisGoodsCategory         Boolean   ,    -- 
    IN inSession                 TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbCode_calc    Integer;  
   DECLARE vbOldId        Integer;
   DECLARE vbOldParentId  Integer;
   DECLARE vbCreateDate  TDateTime;
   DECLARE vbCloseDate   TDateTime;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Unit());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Unit(), vbCode_calc);

   -- �������� ���� � ������
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_Unit_Parent(), inParentId);

   -- ���������
   vbOldId:= ioId;
   -- ���������
   vbOldParentId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent() AND ObjectId = ioId);

   -- ��������� ������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Parent(), ioId, inParentId);

   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);

   -- ��������� ����� � <��������� �������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_MarginCategory(), ioId, inMarginCategoryId);

   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_ProvinceCity(), ioId, inProvinceCityId);
   
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Category(), ioId, inUnitCategoryId);

   -- �����
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_Address(), ioId, inAddress);

   -- �������
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_Phone(), ioId, inPhone);

   -- % �������������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_TaxService(), ioId, inTaxService);
   -- % ������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_TaxServiceNigth(), ioId, inTaxServiceNigth);

   IF inStartServiceNigth ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_StartServiceNigth(), ioId, inStartServiceNigth);
   END IF;
   IF inEndServiceNigth ::Time <> '00:00'
   THEN   
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_EndServiceNigth(), ioId, inEndServiceNigth);
   END IF;

   IF inTaxUnitStartDate ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_TaxUnitStart(), ioId, inTaxUnitStartDate);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_TaxUnitStart(), ioId, NULL);
   END IF;
   IF inTaxUnitEndDate ::Time <> '00:00'
   THEN   
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_TaxUnitEnd(), ioId, inTaxUnitEndDate);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_TaxUnitEnd(), ioId, NULL);
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_StartSP(), ioId, inStartTimeSP);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_EndSP(), ioId, inEndTimeSP);
     
   IF inisSp = TRUE
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SP(), ioId, inDateSP);
   ELSE 
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SP(), ioId, NULL);
   END IF;

   --
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SP(), ioId, inisSP);
   
   -- ��������� � ��������������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_RepriceAuto(), ioId, inisRepriceAuto);

   -- ���� ��������� �������������
   IF vbOldId <> ioId THEN
      -- ���������� �������� ����\����� � ����
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), ioId, TRUE);
   END IF;

   -- ����� ������ inParentId ���� ������ 
   IF COALESCE (inParentId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_isLeaf(), inParentId, FALSE);
   END IF;

   IF COALESCE (vbOldParentId, 0) <> 0 THEN
      PERFORM lpUpdate_isLeaf (vbOldParentId, zc_ObjectLink_Unit_Parent());
   END IF;
   
   -- ��������� ����� � <��������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UserManager(), ioId, inUserManagerId);
   
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Area(), ioId, inAreaId);
   
   -- ��������� ����� � ��������������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UnitRePrice(), ioId, inUnitRePriceId);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_PartnerMedical(), ioId, inPartnerMedicalId);

   IF inCreateDate <> (CURRENT_DATE + INTERVAL '1 DAY')
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Create(), ioId, inCreateDate);
   ELSE 
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Create(), ioId, NULL);
   END IF;

   IF inCloseDate <> (CURRENT_DATE + INTERVAL '1 DAY')
   THEN   
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Close(), ioId, inCloseDate);
   ELSE 
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Close(), ioId, NULL);
   END IF;
   
   -- ����� ������������ � ������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_NormOfManDays(), ioId, inNormOfManDays);

   --��������� <�������� �����>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_PharmacyItem(), ioId, inPharmacyItem);
   --��������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_GoodsCategory(), ioId, inisGoodsCategory);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$

LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.03.19         *
 15.02.19         * inGoodsCategory
 09.02.19                                                        * add PharmacyItem
 15.01.19         *
 22.10.18         *
 29.08.18         * Phone
 14.05.18                                                        * add NormOfManDays               
 05.05.18                                                        * add UnitCategory               
 20.09.17         * add area
 15.09.17         * 
 08.08.17         * add ProvinceCity
 06.03.17         * add Address
 08.04.16         *
 24.02.16         * 
 14.02.16         * 
 27.06.14         * 
 25.06.13                          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Unit ()                            
