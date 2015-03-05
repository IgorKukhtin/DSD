-- Function: gpInsertUpdate_Object_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (integer, integer, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, integer, tfloat, tfloat, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, tdatetime, tdatetime, tvarchar, tvarchar, tvarchar, integer, tvarchar, tvarchar, tvarchar, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (integer, integer, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, integer, tfloat, tfloat, Boolean, Boolean, Boolean, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, tdatetime, tdatetime, tvarchar, tvarchar, tvarchar, integer, tvarchar, tvarchar, tvarchar, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (integer, integer, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, integer, tfloat, tfloat, Boolean, Boolean, Boolean, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, tdatetime, tdatetime, tvarchar, tvarchar, tvarchar, integer, tvarchar, tvarchar, tvarchar, integer, tvarchar);

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
        
    IN inHouseNumber         TVarChar  ,    -- ����� ����
    IN inCaseNumber          TVarChar  ,    -- ����� �������
    IN inRoomNumber          TVarChar  ,    -- ����� ��������
    IN inStreetId            Integer   ,    -- �����/��������  
    IN inPrepareDayCount     TFloat    ,    -- �� ������� ���� ����������� �����
    IN inDocumentDayCount    TFloat    ,    -- ����� ������� ���� ����������� �������������
    
    IN inEdiOrdspr           Boolean   ,    -- EDI - �������������
    IN inEdiInvoice          Boolean   ,    -- EDI - ����
    IN inEdiDesadv           Boolean   ,    -- EDI - �����������

    IN inJuridicalId         Integer   ,    -- ����������� ����
    IN inRouteId             Integer   ,    -- �������
    IN inRouteSortingId      Integer   ,    -- ���������� ���������
  
    IN inMemberTakeId        Integer   ,    -- ��� ����(��������� ����������) 
    IN inPersonalId          Integer   ,    -- ��� ���� (������������� ����)
    IN inPersonalTradeId     Integer   ,    -- ��� ����(��������)
    IN inAreaId              Integer   ,    -- ������
    IN inPartnerTagId        Integer   ,    -- ������� �������� ����� 
    
    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
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
    
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());


   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Partner());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! � ��� ������ !!!

   -- �������� ������������ <���>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), vbCode); END IF;


   -- ���������
   ioId := lpInsertUpdate_Object_Partner (ioId              := ioId
                                        , inCode            := vbCode
                                        , inGLNCode         := inGLNCode
                                        , inGLNCodeJuridical:= inGLNCodeJuridical
                                        , inGLNCodeRetail   := inGLNCodeRetail
                                        , inGLNCodeCorporate:= inGLNCodeCorporate
                                        , inPrepareDayCount := inPrepareDayCount
                                        , inDocumentDayCount:= inDocumentDayCount
                                        , inEdiOrdspr       := inEdiOrdspr
                                        , inEdiInvoice      := inEdiInvoice
                                        , inEdiDesadv       := inEdiDesadv
                                        , inJuridicalId     := inJuridicalId
                                        , inRouteId         := inRouteId
                                        , inRouteSortingId  := inRouteSortingId
                                        , inMemberTakeId    := inMemberTakeId
                                        , inPersonalId      := inPersonalId
                                        , inPersonalTradeId := inPersonalTradeId
                                        , inAreaId          := inAreaId
                                        , inPartnerTagId    := inPartnerTagId
           
                                        , inPriceListId     := inPriceListId
                                        , inPriceListPromoId:= inPriceListPromoId
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

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
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
