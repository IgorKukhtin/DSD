-- Function: gpInsertUpdate_Object_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                             Integer, TFloat, TFloat, 
                             Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
   OUT outPartnerName        TVarChar  ,    -- 
    IN inAddress             TVarChar  ,    -- 
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
    IN inShortName           TVarChar  ,    -- краткое наименование
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inHouseNumber         TVarChar  ,    -- Номер дома
    IN inCaseNumber          TVarChar  ,    -- Номер корпуса
    IN inRoomNumber          TVarChar  ,    -- Номер квартиры
    IN inStreetId            Integer   ,    -- Улица/проспект  
    IN inPrepareDayCount     TFloat    ,    -- За сколько дней принимается заказ
    IN inDocumentDayCount    TFloat    ,    -- Через сколько дней оформляется документально
    IN inJuridicalId         Integer   ,    -- Юридическое лицо
    IN inRouteId             Integer   ,    -- Маршрут
    IN inRouteSortingId      Integer   ,    -- Сортировка маршрутов
    IN inPersonalTakeId      Integer   ,    -- Сотрудник (экспедитор) 
    
    IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inStartPromo          TDateTime ,    -- Дата начала акции
    IN inEndPromo            TDateTime ,    -- Дата окончания акции     
    
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;

   -- DECLARE vbAddress TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId := lpGetUserBySession (inSession);


   -- !!!такой адрес!!!
   /*vbAddress := (SELECT COALESCE(cityname, '')||', '||COALESCE(streetkindname, '')||' '||
                        COALESCE(name, '')||', '
                   FROM Object_Street_View  WHERE Id = inStreetId);
   vbAddress := vbAddress||inHouseNumber;*/

   -- определяем параметры, т.к. значения должны быть синхронизированы с объектом <Юридическое лицо>
   SELECT ValueData INTO outPartnerName FROM Object WHERE Id = inJuridicalId;

   -- !!!в название добавляем <Адрес точки доставки>!!!
   outPartnerName:= COALESCE (outPartnerName || ' ' || inAddress, '');
   -- outPartnerName:= COALESCE(outPartnerName || ', ' || vbAddress, '');


   -- сохранили
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.08.14                                        * add lp
 24.08.14                                        * add Проверка для TPartner1CLinkPlaceForm
 16.08.14                                        * add inAddress
 01.06.14         * add ShortName,
                        HouseNumber, CaseNumber, RoomNumber, Street
 24.04.14                                        * add outPartnerName
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo
 06.01.14                                        * add inAddress
 06.01.14                                        * add проверка уникальность <Код>
 06.01.14                                        * add проверка уникальность <Наименование>
 20.10.13                                        * vbCode_calc:=0
 29.07.13          *  + PersonalTakeId, PrepareDayCount, DocumentDayCount                
 03.07.13          *  + Route, RouteSorting              
 16.06.13                                        * rem lpCheckUnique_Object_ObjectCode
 13.06.13          *
 14.05.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner()
