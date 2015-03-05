-- Function: gpInsertUpdate_Object_Partner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (integer, integer, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, integer, tfloat, tfloat, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, tdatetime, tdatetime, tvarchar, tvarchar, tvarchar, integer, tvarchar, tvarchar, tvarchar, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (integer, integer, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, integer, tfloat, tfloat, Boolean, Boolean, Boolean, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, tdatetime, tdatetime, tvarchar, tvarchar, tvarchar, integer, tvarchar, tvarchar, tvarchar, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (integer, integer, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, tvarchar, integer, tfloat, tfloat, Boolean, Boolean, Boolean, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, tdatetime, tdatetime, tvarchar, tvarchar, tvarchar, integer, tvarchar, tvarchar, tvarchar, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
   OUT outPartnerName        TVarChar  ,    -- 
   OUT outAddress            TVarChar  ,    -- 
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
    IN inShortName           TVarChar  ,    -- краткое наименование
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inGLNCodeJuridical    TVarChar  ,    -- Код GLN - Покупатель
    IN inGLNCodeRetail       TVarChar  ,    -- Код GLN - Получатель
    IN inGLNCodeCorporate    TVarChar  ,    -- Код GLN - Поставщик
        
    IN inHouseNumber         TVarChar  ,    -- Номер дома
    IN inCaseNumber          TVarChar  ,    -- Номер корпуса
    IN inRoomNumber          TVarChar  ,    -- Номер квартиры
    IN inStreetId            Integer   ,    -- Улица/проспект  
    IN inPrepareDayCount     TFloat    ,    -- За сколько дней принимается заказ
    IN inDocumentDayCount    TFloat    ,    -- Через сколько дней оформляется документально
    
    IN inEdiOrdspr           Boolean   ,    -- EDI - Подтверждение
    IN inEdiInvoice          Boolean   ,    -- EDI - Счет
    IN inEdiDesadv           Boolean   ,    -- EDI - уведомление

    IN inJuridicalId         Integer   ,    -- Юридическое лицо
    IN inRouteId             Integer   ,    -- Маршрут
    IN inRouteSortingId      Integer   ,    -- Сортировка маршрутов
  
    IN inMemberTakeId        Integer   ,    -- Физ лицо(сотрудник экспедитор) 
    IN inPersonalId          Integer   ,    -- Физ лицо (ответственное лицо)
    IN inPersonalTradeId     Integer   ,    -- Физ лицо(торговый)
    IN inAreaId              Integer   ,    -- Регион
    IN inPartnerTagId        Integer   ,    -- Признак торговой точки 
    
    IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inStartPromo          TDateTime ,    -- Дата начала акции
    IN inEndPromo            TDateTime ,    -- Дата окончания акции     

    IN inRegionName          TVarChar  ,    -- наименование области
    IN inProvinceName        TVarChar  ,    -- наименование район
    IN inCityName            TVarChar  ,    -- наименование населенный пункт
    IN inCityKindId          Integer   ,    -- Вид населенного пункта
    IN inProvinceCityName    TVarChar  ,    -- наименование района населенного пункта
    IN inPostalCode          TVarChar  ,    -- индекс
    IN inStreetName          TVarChar  ,    -- наименование улица
    IN inStreetKindId        Integer   ,    -- Вид улицы
    
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());


   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Partner());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!

   -- проверка уникальности <Код>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), vbCode); END IF;


   -- сохранили
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

   -- сохранили
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.02.15         * add inEdiOrdspr, inEdiInvoice, inEdiDesadv

 22.11.14                                        * all
 20.11.14         * add redmine              
 10.11.14         * add redmine
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
