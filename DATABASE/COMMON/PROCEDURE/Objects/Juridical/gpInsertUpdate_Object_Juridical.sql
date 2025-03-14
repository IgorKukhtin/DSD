-- Function: gpInsertUpdate_Object_Juridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������� ����>
    IN inCode                Integer   ,    -- �������� <��� ������������ ����>
    IN inName                TVarChar  ,    -- �������� ������� <����������� ����>
    IN inGLNCode             TVarChar  ,    -- ��� GLN
    IN inIsCorporate         Boolean   ,    -- ������� ���� �� ������������� ��� ����������� ����
    IN inIsTaxSummary        Boolean   ,    -- ������� ������� ���������
    IN inIsDiscountPrice     Boolean   ,    -- ������ � ��������� ���� �� �������
    IN inIsPriceWithVAT      Boolean   ,    -- ������ � ��������� ���� � ��� (��/���)
    IN inIsNotRealGoods      Boolean   ,    -- ��� c���� � ������� ����/���� ��������)
    IN inisVchasnoEdi        Boolean   ,    -- ��������� �� ��������� ������ EDI
    IN inDayTaxSummary       TFloat    ,    -- ���-�� ���� ��� ������� ���������
    IN inJuridicalGroupId    Integer   ,    -- ������ ����������� ���
    IN inGoodsPropertyId     Integer   ,    -- �������������� ������� �������
    IN inRetailId            Integer   ,    -- �������� ����
    IN inRetailReportId      Integer   ,    -- �������� ����(�����)
    IN inInfoMoneyId         Integer   ,    -- ������ ����������
    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inSectionId           Integer   ,    -- �������
    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbName_old TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());


   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Juridical());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! � ��� ������ !!!

   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Juridical(), inName);
   -- �������� ������������ <���>
   IF vbCode <> 0
   THEN
       PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Juridical(), vbCode);
   END IF;

   -- ��������
   IF ioId > 0
      AND COALESCE (inPriceListId, 0) <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Juridical_PriceList()), 0)
   THEN
       -- RAISE EXCEPTION '������.��� ���� ������������� ����� <%>.', lfGet_Object_ValueData_sh (inPriceListId);
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Juridical_PriceList());
   ELSEIF COALESCE (ioId, 0) = 0 -- AND inPriceListId > 0 AND inPriceListId <> zc_PriceList_Basis()
   THEN
       -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Juridical_PriceList());
      inPriceListId:= NULL;
      inPriceListPromoId:= NULL;
   END IF;


   -- ��������
   IF COALESCE (inInfoMoneyId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<�� ������ ����������> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inJuridicalGroupId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<������ ����������� ���> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inName, '') = ''
   THEN
      RAISE EXCEPTION '������.���������� ���������� <�������� ������������ ����>.';
   END IF;
   -- ��������
   IF inIsCorporate = TRUE AND COALESCE (ioId, 0) <> zc_Juridical_Basis()
   AND 1=0
   THEN
      RAISE EXCEPTION '������.����������� ���������� ������� <������� ����������� ����>.';
   END IF;

   vbName_old:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Juridical(), vbCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_DayTaxSummary(), ioId, inDayTaxSummary);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inIsCorporate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isTaxSummary(), ioId, inIsTaxSummary);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isDiscountPrice(), ioId, inIsDiscountPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isPriceWithVAT(), ioId, inIsPriceWithVAT);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isNotRealGoods(), ioId, inIsNotRealGoods);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_VchasnoEdi(), ioId, inisVchasnoEdi);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_GoodsProperty(), ioId, inGoodsPropertyId);
    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), ioId, inRetailId);
    -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_RetailReport(), ioId, inRetailReportId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_InfoMoney(), ioId, inInfoMoneyId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceList(), ioId, inPriceListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_PriceListPromo(), ioId, inPriceListPromoId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Section(), ioId, inSectionId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_StartPromo(), ioId, DATE (inStartPromo));
      -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Juridical_EndPromo(), ioId, DATE (inEndPromo));

   -- ���������
   PERFORM lpUpdate_Object_Partner_Address( inId                := OL_Partner_Juridical.ObjectId
                                          , inJuridicalId       := ioId
                                          , inShortName         := ObjectString_ShortName.ValueData
                                          , inCode              := Object_Partner.ObjectCode
                                          , inRegionName        := Object_Region.ValueData
                                          , inProvinceName      := Object_Province.ValueData
                                          , inCityName          := Object_Street_View.CityName
                                          , inCityKindId        := Object_CityKind.Id
                                          , inProvinceCityName  := Object_Street_View.ProvinceCityName
                                          , inPostalCode        := Object_Street_View.PostalCode
                                          , inStreetName        := Object_Street_View.Name
                                          , inStreetKindId      := Object_Street_View.StreetKindId
                                          , inHouseNumber       := ObjectString_HouseNumber.ValueData
                                          , inCaseNumber        := ObjectString_CaseNumber.ValueData
                                          , inRoomNumber        := ObjectString_RoomNumber.ValueData
                                          , inIsCheckUnique     := FALSE
                                          , inSession           := inSession
                                          , inUserId            := vbUserId
                                           )
      FROM ObjectLink AS OL_Partner_Juridical
           JOIN Object AS Object_Partner ON Object_Partner.Id = OL_Partner_Juridical.ObjectId
           LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                  ON ObjectString_HouseNumber.ObjectId = Object_Partner.Id
                                 AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()

           LEFT JOIN ObjectString AS ObjectString_ShortName
                                  ON ObjectString_ShortName.ObjectId = Object_Partner.Id
                                 AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()

           LEFT JOIN ObjectString AS ObjectString_CaseNumber
                                  ON ObjectString_CaseNumber.ObjectId = Object_Partner.Id
                                 AND ObjectString_CaseNumber.DescId = zc_ObjectString_Partner_CaseNumber()

           LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                  ON ObjectString_RoomNumber.ObjectId = Object_Partner.Id
                                 AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()

           LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                                ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                               AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
           LEFT JOIN Object_Street_View ON Object_Street_View.Id = ObjectLink_Partner_Street.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_City_CityKind                                          -- �� �����
                                ON ObjectLink_City_CityKind.ObjectId = Object_Street_View.CityId
                               AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
           LEFT JOIN Object AS Object_CityKind ON Object_CityKind.Id = ObjectLink_City_CityKind.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_City_Region
                                ON ObjectLink_City_Region.ObjectId = Object_Street_View.CityId
                               AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
           LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_City_Region.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_City_Province
                                ON ObjectLink_City_Province.ObjectId = Object_Street_View.CityId
                               AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
           LEFT JOIN Object AS Object_Province ON Object_Province.Id = ObjectLink_City_Province.ChildObjectId

      WHERE OL_Partner_Juridical.ChildObjectId = ioId
        AND OL_Partner_Juridical.DescId        = zc_ObjectLink_Partner_Juridical()
        AND vbName_old                         <> inName
        AND Object_Street_View.CityName        <> ''
     ;

   -- ��������
   IF vbUserId = 5 OR vbUserId = 9457
   THEN
      RAISE EXCEPTION '������. %  %.', vbName_old, inName;
   END IF;


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.03.25         * inisVchasnoEdi
 02.11.22         * add inSectionId
 30.09.22         * add inIsNotRealGoods
 07.02.17         * add isPriceWithVAT
 17.12.15         * add isDiscountPrice
 20.11.14         *
 07.11.14         * �������� RetailReport
 23.05.14         * add Retail
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo
 06.01.14                                        * add �������� ������������ <���>
 06.01.14                                        * add �������� ������������ <������������>
 20.10.13                                        * vbCode_calc:=0
 03.07.13          * + InfoMoney
 12.05.13                                        * rem lpCheckUnique_Object_ValueData
 12.06.13          *
 16.06.13                                        * rem lpCheckUnique_Object_ObjectCode
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Juridical()
