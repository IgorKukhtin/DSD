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
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
   OUT outPartnerName        TVarChar  ,    -- 
   OUT outAddress            TVarChar  ,    -- 
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
    IN inShortName           TVarChar  ,    -- краткое наименование
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inGLNCodeJuridical    TVarChar  ,    -- Код GLN - Покупатель
    IN inGLNCodeRetail       TVarChar  ,    -- Код GLN - Получатель
    IN inGLNCodeCorporate    TVarChar  ,    -- Код GLN - Поставщик 
    
    IN inBranchCode          TVarChar  ,    -- Номер филиала
    IN inBranchJur           TVarChar  ,    -- Название юр.лица для филиала
    IN inTerminal            TVarChar  ,    -- код терминала
        
    IN inHouseNumber         TVarChar  ,    -- Номер дома
    IN inCaseNumber          TVarChar  ,    -- Номер корпуса
    IN inRoomNumber          TVarChar  ,    -- Номер квартиры
    IN inStreetId            Integer   ,    -- Улица/проспект  
    IN inPrepareDayCount     TFloat    ,    -- За сколько дней принимается заказ
    IN inDocumentDayCount    TFloat    ,    -- Через сколько дней оформляется документально
    IN inCategory            TFloat    ,    -- категория ТТ
                
    IN inTaxSale_Personal       TFloat    ,   -- супервайзер - % от товарооборота
    IN inTaxSale_PersonalTrade  TFloat    ,   -- ТП - % от товарооборота
    IN inTaxSale_MemberSaler1   TFloat    ,   -- Продавец-1 - % от товарооборота
    IN inTaxSale_MemberSaler2   TFloat    ,   -- Продавец-2 - % от товарооборота
    
    IN inEdiOrdspr           Boolean   ,    -- EDI - Подтверждение
    IN inEdiInvoice          Boolean   ,    -- EDI - Счет
    IN inEdiDesadv           Boolean   ,    -- EDI - уведомление

    IN inJuridicalId         Integer   ,    -- Юридическое лицо
    IN inRouteId             Integer   ,    -- Маршрут
    IN inRouteId_30201       Integer   ,    -- Маршрут мясное сырье    
    IN inRouteSortingId      Integer   ,    -- Сортировка маршрутов

  
    IN inMemberTakeId        Integer   ,    -- Физ лицо(сотрудник экспедитор) 
    IN inMemberSaler1Id      Integer   ,    -- Физ лицо(Продавец-1)
    IN inMemberSaler2Id      Integer   ,    -- Физ лицо(Продавец-2)
    
    IN inPersonalId          Integer   ,    -- Физ лицо (ответственное лицо)
    IN inPersonalTradeId     Integer   ,    -- Физ лицо(торговый)
    IN inPersonalMerchId     Integer   ,    -- Физ лицо (мерчандайзер) 
    IN inPersonalSigningId   Integer   ,    -- Сотрудник (подписант)
    IN inAreaId              Integer   ,    -- Регион
    IN inPartnerTagId        Integer   ,    -- Признак торговой точки 

    IN inGoodsPropertyId     Integer   ,    -- Классификаторы свойств товаров
    
    IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListId_30201   Integer   ,    -- Прайс-лист мясное сырье
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inUnitMobileId        Integer   ,    -- Подразделение(заявки мобильный)

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

    IN inValue1              Boolean  ,  -- понедельник значение
    IN inValue2              Boolean  ,  -- вторник
    IN inValue3              Boolean  ,  -- среда
    IN inValue4              Boolean  ,  -- четверг
    IN inValue5              Boolean  ,  -- пятница
    IN inValue6              Boolean  ,  -- суббота
    IN inValue7              Boolean  ,  -- воскресенье 
    
    IN inMovementComment     TVarChar ,  -- примечание для док продажи  
   
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbSchedule TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());


   -- Проверка
   IF (inCategory <> COALESCE((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = ioId AND OFl.DescId = zc_ObjectFloat_Partner_Category()), 0))
   AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_Partner_Category())
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав заполнять <Категорию ТТ>.';
   END IF;
   
   -- Проверка
   IF ioId > 0
      AND COALESCE (inPriceListId, 0) <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Partner_PriceList()), 0)
   THEN
       -- RAISE EXCEPTION 'Ошибка.Нет прав устанавливать прайс <%>.', lfGet_Object_ValueData_sh (inPriceListId);
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());
   ELSEIF COALESCE (ioId, 0) = 0 AND inPriceListId > 0
   THEN
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());
   END IF;

   -- Проверка
   IF ioId > 0
      AND COALESCE (inPriceListId_30201, 0) <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Partner_PriceList30201()), 0)
   THEN
       -- RAISE EXCEPTION 'Ошибка.Нет прав устанавливать прайс <%>.', lfGet_Object_ValueData_sh (inPriceListId);
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());
   ELSEIF COALESCE (ioId, 0) = 0 AND inPriceListId_30201 > 0
   THEN
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Partner_PriceList());
   END IF;


   -- !!!надо так криво обработать когда добавляют несколько пользователей!!!)
   IF COALESCE (ioId, 0) = 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.ObjectCode = inCode)
   THEN 
       -- Обнулим, что б потом переопределить
       inCode:= 0;
   END IF;
   -- !!!надо так криво обработать когда добавляют несколько пользователей!!!)
   IF inCode > 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.ObjectCode = inCode AND Object.Id <> COALESCE (ioId, 0))
   THEN 
       -- Обнулим, что б потом переопределить
       inCode:= 0;
   END IF;

   -- !!! Если код не установлен, определяем его как последний+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_Partner());

   -- проверка уникальности <Код>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), vbCode); END IF;

   vbSchedule:= (inValue1||';'||inValue2||';'||inValue3||';'||inValue4||';'||inValue5||';'||inValue6||';'||inValue7) :: TVarChar;
   vbSchedule:= replace( replace (vbSchedule, 'true', 't'), 'false', 'f');

   -- сохранили
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
   --
   -- сохранили свойство <примечание для Накладной продажи>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Movement(), ioId, inMovementComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
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
