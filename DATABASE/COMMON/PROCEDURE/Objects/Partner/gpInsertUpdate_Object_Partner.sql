 -- Function: gpInsertUpdate_Object_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer
                                                     , TFloat, TFloat, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer
                                                     , TFloat, TFloat, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer
                                                     , TFloat, TFloat, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer
                                                     , TFloat, TFloat, TFloat, Boolean, Boolean, Boolean
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer
                                                     , TFloat, TFloat, TFloat, Boolean, Boolean, Boolean
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer
                                                     , TFloat, TFloat, TFloat, Boolean, Boolean, Boolean
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer
                                                     , TFloat, TFloat, TFloat, Boolean, Boolean, Boolean
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer
                                                     , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     , Boolean, Boolean, Boolean
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);*/
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     , Boolean, Boolean, Boolean
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     , Boolean, Boolean, Boolean
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);*/
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                     , Boolean, Boolean, Boolean
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , Integer, Integer
                                                     , TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer
                                                     , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
   OUT outPartnerName        TVarChar  ,    -- 
   OUT outAddress            TVarChar  ,    -- 
    IN inCode                Integer   ,    -- ��� ������� <����������> 
    IN inShortName           TVarChar  ,    -- ������� ������������
    IN inGLNCode             TVarChar  ,    -- ��� GLN
    IN inGLNCodeJuridical    TVarChar  ,    -- ��� GLN - ����������
    IN inGLNCodeRetail       TVarChar  ,    -- ��� GLN - ����������
    IN inGLNCodeCorporate    TVarChar  ,    -- ��� GLN - ��������� 
    
    IN inBranchCode          TVarChar  ,    -- ����� �������
    IN inBranchJur           TVarChar  ,    -- �������� ��.���� ��� �������
    IN inTerminal            TVarChar  ,    -- ��� ���������
        
    IN inHouseNumber         TVarChar  ,    -- ����� ����
    IN inCaseNumber          TVarChar  ,    -- ����� �������
    IN inRoomNumber          TVarChar  ,    -- ����� ��������
    IN inStreetId            Integer   ,    -- �����/��������  
    IN inPrepareDayCount     TFloat    ,    -- �� ������� ���� ����������� �����
    IN inDocumentDayCount    TFloat    ,    -- ����� ������� ���� ����������� �������������
    IN inCategory            TFloat    ,    -- ��������� ��
                
    IN inTaxSale_Personal       TFloat    ,   -- ����������� - % �� �������������
    IN inTaxSale_PersonalTrade  TFloat    ,   -- �� - % �� �������������
    IN inTaxSale_MemberSaler1   TFloat    ,   -- ��������-1 - % �� �������������
    IN inTaxSale_MemberSaler2   TFloat    ,   -- ��������-2 - % �� �������������
    
    IN inEdiOrdspr           Boolean   ,    -- EDI - �������������
    IN inEdiInvoice          Boolean   ,    -- EDI - ����
    IN inEdiDesadv           Boolean   ,    -- EDI - �����������

    IN inJuridicalId         Integer   ,    -- ����������� ����
    IN inRouteId             Integer   ,    -- �������
    IN inRouteId_30201       Integer   ,    -- ������� ������ �����    
    IN inRouteSortingId      Integer   ,    -- ���������� ���������

  
    IN inMemberTakeId        Integer   ,    -- ��� ����(��������� ����������) 
    IN inMemberSaler1Id      Integer   ,    -- ��� ����(��������-1)
    IN inMemberSaler2Id      Integer   ,    -- ��� ����(��������-2)
    
    IN inPersonalId          Integer   ,    -- ��� ���� (������������� ����)
    IN inPersonalTradeId     Integer   ,    -- ��� ����(��������)
    IN inPersonalMerchId     Integer   ,    -- ��� ���� (������������) 
    IN inPersonalSigningId   Integer   ,    -- ��������� (���������)
    IN inAreaId              Integer   ,    -- ������
    IN inPartnerTagId        Integer   ,    -- ������� �������� ����� 

    IN inGoodsPropertyId     Integer   ,    -- �������������� ������� �������
    
    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListId_30201   Integer   ,    -- �����-���� ������ �����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inUnitMobileId        Integer   ,    -- �������������(������ ���������)

    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����     

    IN inRegionName          TVarChar  ,    -- ������������ �������
    IN inProvinceName        TVarChar  ,    -- ������������ �����
    IN inCityName            TVarChar  ,    -- ������������ ���������� �����
    IN inCityKindId          Integer   ,    -- ��� ����������� ������
    IN inProvinceCityName    TVarChar  ,    -- ������������ ������ ����������� ������
    IN inPostalCode          TVarChar  ,    -- ������
    IN inStreetName          TVarChar  ,    -- ������������ �����
    IN inStreetKindId        Integer   ,    -- ��� �����

    IN inValue1              Boolean  ,  -- ����������� ��������
    IN inValue2              Boolean  ,  -- �������
    IN inValue3              Boolean  ,  -- �����
    IN inValue4              Boolean  ,  -- �������
    IN inValue5              Boolean  ,  -- �������
    IN inValue6              Boolean  ,  -- �������
    IN inValue7              Boolean  ,  -- ����������� 
    
    IN inMovementComment     TVarChar ,  -- ���������� ��� ��� �������  
   
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbSchedule TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());


   -- ��������
   IF (inCategory <> COALESCE((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = ioId AND OFl.DescId = zc_ObjectFloat_Partner_Category()), 0))
   AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_Partner_Category())
   THEN
       RAISE EXCEPTION '������.��� ���� ��������� <��������� ��>.';
   END IF;
   
   -- ��������
   IF ioId > 0
      AND COALESCE (inPriceListId, 0) <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Partner_PriceList()), 0)
   THEN
       -- RAISE EXCEPTION '������.��� ���� ������������� ����� <%>.', lfGet_Object_ValueData_sh (inPriceListId);
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());
   ELSEIF COALESCE (ioId, 0) = 0 AND inPriceListId > 0
   THEN
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());
   END IF;

   -- ��������
   IF ioId > 0
      AND COALESCE (inPriceListId_30201, 0) <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Partner_PriceList30201()), 0)
   THEN
       -- RAISE EXCEPTION '������.��� ���� ������������� ����� <%>.', lfGet_Object_ValueData_sh (inPriceListId);
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());
   ELSEIF COALESCE (ioId, 0) = 0 AND inPriceListId_30201 > 0
   THEN
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());
   END IF;


   -- !!!���� ��� ����� ���������� ����� ��������� ��������� �������������!!!)
   IF COALESCE (ioId, 0) = 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.ObjectCode = inCode)
   THEN 
       -- �������, ��� � ����� ��������������
       inCode:= 0;
   END IF;
   -- !!!���� ��� ����� ���������� ����� ��������� ��������� �������������!!!)
   IF inCode > 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.ObjectCode = inCode AND Object.Id <> COALESCE (ioId, 0))
   THEN 
       -- �������, ��� � ����� ��������������
       inCode:= 0;
   END IF;

   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_Partner());

   -- �������� ������������ <���>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), vbCode); END IF;

   vbSchedule:= (inValue1||';'||inValue2||';'||inValue3||';'||inValue4||';'||inValue5||';'||inValue6||';'||inValue7) :: TVarChar;
   vbSchedule:= replace( replace (vbSchedule, 'true', 't'), 'false', 'f');

   -- ���������
   ioId := lpInsertUpdate_Object_Partner (ioId              := ioId
                                        , inCode            := vbCode
                                        , inGLNCode         := inGLNCode
                                        , inGLNCodeJuridical:= inGLNCodeJuridical
                                        , inGLNCodeRetail   := inGLNCodeRetail
                                        , inGLNCodeCorporate:= inGLNCodeCorporate
                                        , inSchedule        := vbSchedule  
                                        , inBranchCode      := inBranchCode
                                        , inBranchJur       := inBranchJur
                                        , inTerminal        := inTerminal

                                        , inPrepareDayCount := inPrepareDayCount
                                        , inDocumentDayCount:= inDocumentDayCount
                                        , inCategory        := inCategory
                                        , inTaxSale_Personal      := inTaxSale_Personal
                                        , inTaxSale_PersonalTrade := inTaxSale_PersonalTrade
                                        , inTaxSale_MemberSaler1  := inTaxSale_MemberSaler1
                                        , inTaxSale_MemberSaler2  := inTaxSale_MemberSaler2
                                        , inEdiOrdspr       := inEdiOrdspr
                                        , inEdiInvoice      := inEdiInvoice
                                        , inEdiDesadv       := inEdiDesadv
                                        , inJuridicalId     := inJuridicalId
                                        , inRouteId         := inRouteId
                                        , inRouteId_30201   := inRouteId_30201
                                        , inRouteSortingId  := inRouteSortingId
                                        , inMemberTakeId    := inMemberTakeId
                                        , inMemberSaler1Id  := inMemberSaler1Id
                                        , inMemberSaler2Id  := inMemberSaler2Id
                                        , inPersonalId      := inPersonalId
                                        , inPersonalTradeId := inPersonalTradeId
                                        , inPersonalMerchId := inPersonalMerchId
                                        , inPersonalSigningId:= inPersonalSigningId
                                        , inAreaId          := inAreaId
                                        , inPartnerTagId    := inPartnerTagId
                                        , inGoodsPropertyId := inGoodsPropertyId           
                                        , inPriceListId     := inPriceListId
                                        , inPriceListId_30201 := inPriceListId_30201
                                        , inPriceListPromoId:= inPriceListPromoId
                                        , inUnitMobileId    := inUnitMobileId
                                        , inStartPromo      := inStartPromo
                                        , inEndPromo        := inEndPromo
                                        , inUserId          := vbUserId
                                         );

   -- ���������
   SELECT tmp.outPartnerName, tmp.outAddress
         INTO outPartnerName, outAddress
      FROM lpUpdate_Object_Partner_Address( inId                := ioId
                                          , inJuridicalId       := inJuridicalId
                                          , inShortName         := inShortName
                                          , inCode              := vbCode
                                          , inRegionName        := inRegionName
                                          , inProvinceName      := inProvinceName
                                          , inCityName          := inCityName
                                          , inCityKindId        := inCityKindId
                                          , inProvinceCityName  := inProvinceCityName  
                                          , inPostalCode        := inPostalCode
                                          , inStreetName        := inStreetName
                                          , inStreetKindId      := inStreetKindId
                                          , inHouseNumber       := inHouseNumber
                                          , inCaseNumber        := inCaseNumber  
                                          , inRoomNumber        := inRoomNumber
                                          , inIsCheckUnique     := FALSE -- TRUE
                                          , inSession           := inSession
                                          , inUserId            := vbUserId
                                           ) AS tmp;   
   --
   -- ��������� �������� <���������� ��� ��������� �������>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Movement(), ioId, inMovementComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.11.24         *
 04.07.24         *
 24.10.23         *
 27.01.23         *
 25.05.21         *
 29.04.21         * inCategory
 19.06.17         * add inPersonalMerchId
 07.03.17         * add Schedule
 25.12.15         * add inGoodsPropertyId
 06.02.15         * add inEdiOrdspr, inEdiInvoice, inEdiDesadv

 22.11.14                                        * all
 20.11.14         * add redmine              
 10.11.14         * add redmine
 25.08.14                                        * add lp
 24.08.14                                        * add �������� ��� TPartner1CLinkPlaceForm
 16.08.14                                        * add inAddress
 01.06.14         * add ShortName,
                        HouseNumber, CaseNumber, RoomNumber, Street
 24.04.14                                        * add outPartnerName
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo
 06.01.14                                        * add inAddress
 06.01.14                                        * add �������� ������������ <���>
 06.01.14                                        * add �������� ������������ <������������>
 20.10.13                                        * vbCode_calc:=0
 29.07.13          *  + PersonalTakeId, PrepareDayCount, DocumentDayCount                
 03.07.13          *  + Route, RouteSorting              
 16.06.13                                        * rem lpCheckUnique_Object_ObjectCode
 13.06.13          *
 14.05.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Partner()
