-- Function: gpInsertUpdate_Object_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                             Integer, TFloat, TFloat, 
                             Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
   OUT outPartnerName        TVarChar  ,    -- 
    IN inAddress             TVarChar  ,    -- 
    IN inCode                Integer   ,    -- ��� ������� <����������> 
    IN inShortName           TVarChar  ,    -- ������� ������������
    IN inGLNCode             TVarChar  ,    -- ��� GLN
    IN inHouseNumber         TVarChar  ,    -- ����� ����
    IN inCaseNumber          TVarChar  ,    -- ����� �������
    IN inRoomNumber          TVarChar  ,    -- ����� ��������
    IN inStreetId            Integer   ,    -- �����/��������  
    IN inPrepareDayCount     TFloat    ,    -- �� ������� ���� ����������� �����
    IN inDocumentDayCount    TFloat    ,    -- ����� ������� ���� ����������� �������������
    IN inJuridicalId         Integer   ,    -- ����������� ����
    IN inRouteId             Integer   ,    -- �������
    IN inRouteSortingId      Integer   ,    -- ���������� ���������
    IN inPersonalTakeId      Integer   ,    -- ��������� (����������) 
    
    IN inPriceListId         Integer   ,    -- �����-����
    IN inPriceListPromoId    Integer   ,    -- �����-����(���������)
    IN inStartPromo          TDateTime ,    -- ���� ������ �����
    IN inEndPromo            TDateTime ,    -- ���� ��������� �����     
    
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;

   -- DECLARE vbAddress TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId := lpGetUserBySession (inSession);


   -- !!!����� �����!!!
   /*vbAddress := (SELECT COALESCE(cityname, '')||', '||COALESCE(streetkindname, '')||' '||
                        COALESCE(name, '')||', '
                   FROM Object_Street_View  WHERE Id = inStreetId);
   vbAddress := vbAddress||inHouseNumber;*/

   -- ���������� ���������, �.�. �������� ������ ���� ���������������� � �������� <����������� ����>
   SELECT ValueData INTO outPartnerName FROM Object WHERE Id = inJuridicalId;

   -- !!!� �������� ��������� <����� ����� ��������>!!!
   outPartnerName:= COALESCE (outPartnerName || ' ' || inAddress, '');
   -- outPartnerName:= COALESCE(outPartnerName || ', ' || vbAddress, '');


   -- ���������
   ioId := lpInsertUpdate_Object_Partner (ioId              := ioId
                                        , inPartnerName     := outPartnerName
                                        , inAddress         := inAddress -- vbAddress
                                        , inCode            := inCode
                                        , inShortName       := inShortName
                                        , inGLNCode         := inGLNCode
                                        , inHouseNumber     := inHouseNumber
                                        , inCaseNumber      := inCaseNumber
                                        , inRoomNumber      := inRoomNumber
                                        , inStreetId        := inStreetId
                                        , inPrepareDayCount := inPrepareDayCount
                                        , inDocumentDayCount:= inDocumentDayCount
                                        , inJuridicalId     := inJuridicalId
                                        , inRouteId         := inRouteId
                                        , inRouteSortingId  := inRouteSortingId
                                        , inPersonalTakeId  := inPersonalTakeId
    
                                        , inPriceListId     := inPriceListId
                                        , inPriceListPromoId:= inPriceListPromoId
                                        , inStartPromo      := inStartPromo
                                        , inEndPromo        := inEndPromo

                                        , inUserId          := vbUserId
                                         );
   
   
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Partner (Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
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
