-- Function: gpInsertUpdate_Object_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit(Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat,
                                                   TDateTime, TDateTime, TDateTime, TDateTime, TDateTime,TDateTime, TDateTime, TDateTime, TDateTime,
                                                   Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                   Boolean, Boolean, Boolean, Boolean, Integer, Boolean, Boolean, 
                                                   TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, Integer, 
                                                   Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������������>
    IN inCode                    Integer   ,    -- ��� ������� <�������������>
    IN inName                    TVarChar  ,    -- �������� ������� <�������������>
    IN inAddress                 TVarChar  ,    -- �����
    IN inPhone                   TVarChar  ,

    IN inTaxService              TFloat    ,    -- % �� �������
    IN inTaxServiceNigth         TFloat    ,    -- % �� ������� � ������ �����
    IN inKoeffInSUN              TFloat    ,    -- ����������� ������� ������/������
    IN inKoeffOutSUN             TFloat    ,    -- ����������� ������� ������/������
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
    IN inUserManager2Id          Integer   ,    -- ������ �� �������� 2
    IN inUserManager3Id          Integer   ,    -- ������ �� �������� 3
    IN inUnitCategoryId          Integer   ,    -- ������ �� ��������� 
    IN inUnitRePriceId           Integer   ,    -- ������ �� ������������� 
    IN inNormOfManDays           Integer   ,    -- ����� ������������ � ������
    IN inPartnerMedicalId        Integer   ,    -- ���.���������� ��� ���� 1303
    IN inPharmacyItem            Boolean   ,    -- �������� �����
    IN inisGoodsCategory         Boolean   ,    -- ��� �������������� �������
    IN inDividePartionDate       Boolean   ,    -- ��������� ����� �� ������� �� ������
    IN inRedeemByHandSP          Boolean   ,    -- �������� ����� ���� ������� (��� ������������� API)
    IN inUnitOverdueId           Integer   ,    -- ������������� ��� ����������� ������������� ������
    IN inisAutoMCS               Boolean   ,    -- �������������� �������� ���
    IN inisTopNo                 Boolean   ,    -- �� ��������� ��� ��� ������

    IN inListDaySUN              TVarChar  ,    -- �� ����� ���� ������ �� ���

    IN inLatitude                TVarChar  ,    -- �������������� ������
    IN inLongitude               TVarChar  ,    -- �������������� �������
    IN inMondayStart             TDateTime ,    -- ���. -  ����. ������ ������
    IN inMondayEnd               TDateTime ,    -- ���. -  ����. ����� ������
    IN inSaturdayStart           TDateTime ,    -- ������� ������ ������
    IN inSaturdayEnd             TDateTime ,    -- ������� ����� ������
    IN inSundayStart             TDateTime ,    -- ����������� ������ ������
    IN inSundayEnd               TDateTime ,    -- ����������� ����� ������
    IN inisNotCashMCS            Boolean   ,    -- ����������� ��������� ��� �� ������ 
    IN inisNotCashListDiff       Boolean   ,    -- ����������� ���������� � ����� ������� �� ������
    
    IN inUnitOldId               Integer   ,    -- ������ �������������� (��������)
    IN inMorionCode              Integer   ,    -- ��� �������
    IN inAccessKeyYF             TVarChar  ,    -- ���� �� ��� �������� ������ ����-����

    IN inSession                 TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbCode_calc    Integer;  
   DECLARE vbOldId        Integer;
   DECLARE vbOldParentId  Integer;
   DECLARE vbCreateDate   TDateTime;
   DECLARE vbCloseDate    TDateTime;
   DECLARE vbFloat        Float;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Unit());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!
   
   if COALESCE((SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.DescId = zc_ObjectBoolean_Unit_DividePartionDate() and 
      ObjectBoolean.ObjectId = ioId), False) <> inDividePartionDate
     AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������.��������� �������� <��������� ����� �� ������� �� ������> ��������� ������ ��������������.';   
   END IF;
   
   IF TRIM(inLatitude) <> ''
   THEN
     BEGIN
          vbFloat:= TRIM(inLatitude) :: Float;
     EXCEPTION           
        WHEN data_exception
        THEN vbFloat := -1;
        RAISE EXCEPTION '������.������ ����� <%> ���������� ������������� � �����.', inLatitude;   
     END;
   END IF;

   IF TRIM(inLongitude) <> ''
   THEN
     BEGIN
          vbFloat:= TRIM(inLongitude) :: Float;
     EXCEPTION           
        WHEN data_exception
        THEN vbFloat := -1;
        RAISE EXCEPTION '������.������ ������� <%> ���������� ������������� � �����.', inLongitude;   
     END;
   END IF;

   
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

   -- �� ����� ���� ������ �� ���
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_ListDaySUN(), ioId, inListDaySUN);

   -- % �������������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_TaxService(), ioId, inTaxService);
   -- % ������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_TaxServiceNigth(), ioId, inTaxServiceNigth);

   -- ����������� ������� ������/������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffInSUN(), ioId, inKoeffInSUN);
   -- ����������� ������� ������/������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffOutSUN(), ioId, inKoeffOutSUN);

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
   -- ��������� ����� � <�������� 2>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UserManager2(), ioId, inUserManager2Id);
   -- ��������� ����� � <�������� 3>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UserManager3(), ioId, inUserManager3Id);

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

   --��������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_DividePartionDate(), ioId, inDividePartionDate);
   --��������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_RedeemByHandSP(), ioId, inRedeemByHandSP);

   -- ��������� ����� � ��������������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UnitOverdue(), ioId, inUnitOverdueId);

   -- ��������� ����� � ��������������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UnitOld(), ioId, inUnitOldId);

   --��������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_AutoMCS(), ioId, inisAutoMCS);

   --��������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_TopNo(), ioId, inisTopNo);
   
   
   -- �������������� ������
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_Latitude(), ioId, TRIM(inLatitude));
   -- �������������� �������
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_Longitude(), ioId, TRIM(inLongitude));

   -- ��� �������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_MorionCode(), ioId, inMorionCode);
   -- ���� �� ��� �������� ������ ����-����
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_AccessKeyYF(), ioId, TRIM(inAccessKeyYF));

   IF inMondayStart ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_MondayStart(), ioId, inMondayStart);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_MondayStart(), ioId, NULL);
   END IF;
   
   IF inMondayEnd ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_MondayEnd(), ioId, inMondayEnd);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_MondayEnd(), ioId, NULL);
   END IF;

   IF inSaturdayStart ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SaturdayStart(), ioId, inSaturdayStart);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SaturdayStart(), ioId, NULL);
   END IF;

   IF inSaturdayEnd ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SaturdayEnd(), ioId, inSaturdayEnd);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SaturdayEnd(), ioId, NULL);
   END IF;

   IF inSundayStart ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SundayStart(), ioId, inSundayStart);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SundayStart(), ioId, NULL);
   END IF;

   IF inSundayEnd ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SundayEnd(), ioId, inSundayEnd);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SundayEnd(), ioId, NULL);
   END IF;
   
   --��������� <����������� ��������� ��� �� ������>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_NotCashMCS(), ioId, inisNotCashMCS);
   --��������� <����������� ���������� � ����� ������� �� ������>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Unit_NotCashListDiff(), ioId, inisNotCashListDiff);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$

LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.12.19                                                       * MorionCode, AccessKeyYF
 11.12.19                                                       * UnitOld
 24.11.19                                                       * isNotCashMCS, isNotCashListDiff
 20.11.19         * inListDaySUN
 28.10.19                                                        * ���������� � �������
 04.09.19         * inisTopNo
 26.08.19         * inKoeffInSUN, inKoeffOutSUN
 13.08.19                                                        * AutoMCS
 02.07.19                                                        * UnitOverdue
 02.07.19         *
 14.06.19                                                        *
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
