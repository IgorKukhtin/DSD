-- Function: lpInsertUpdate_Object_Partner()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, 
                                                       TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer);   
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer);  
/*DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer);   */         
/*DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer);*/ 
/*DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer); 
*/

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,
                                                       TFloat, TFloat, TFloat, Boolean, Boolean, Boolean,
                                                       Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer,
                                                       TDateTime, TDateTime, Integer); 


CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Partner(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
    IN inGLNCode             TVarChar  ,    -- Код GLN
    
    IN inGLNCodeJuridical    TVarChar  ,    -- Код GLN - Покупатель
    IN inGLNCodeRetail       TVarChar  ,    -- Код GLN - Получатель
    IN inGLNCodeCorporate    TVarChar  ,    -- Код GLN - Поставщик
    IN inSchedule            TVarChar  ,    -- График посещения

    IN inPrepareDayCount     TFloat    ,    -- За сколько дней принимается заказ
    IN inDocumentDayCount    TFloat    ,    -- Через сколько дней оформляется документально
    IN inCategory            TFloat    ,    -- категория ТТ

    IN inEdiOrdspr           Boolean   ,    -- EDI - Подтверждение
    IN inEdiInvoice          Boolean   ,    -- EDI - Счет
    IN inEdiDesadv           Boolean   ,    -- EDI - уведомление

    IN inJuridicalId         Integer   ,    -- Юридическое лицо
    IN inRouteId             Integer   ,    -- Маршрут
    IN inRouteId_30201       Integer   ,    -- Маршрут мясное сырье 
    IN inRouteSortingId      Integer   ,    -- Сортировка маршрутов
    
    IN inMemberTakeId        Integer   ,    -- Физ лицо (сотрудник экспедитор)
    IN inPersonalId          Integer   ,    -- Сотрудник (супервайзер)
    IN inPersonalTradeId     Integer   ,    -- Сотрудник (торговый)
    IN inPersonalMerchId     Integer   ,    -- Сотрудник (мерчандайзер)
    IN inAreaId              Integer   ,    -- Регион
    IN inPartnerTagId        Integer   ,    -- Признак торговой точки

    IN inGoodsPropertyId     Integer   ,    -- Классификаторы свойств товаров
    
    IN inUnitMobileId        Integer   ,    -- Подразделение(заявки мобильный)

    IN inPriceListId         Integer   ,    -- Прайс-лист
    IN inPriceListId_30201   Integer   ,    -- Прайс-лист мясное сырье
    IN inPriceListPromoId    Integer   ,    -- Прайс-лист(Акционный)
    IN inStartPromo          TDateTime ,    -- Дата начала акции
    IN inEndPromo            TDateTime ,    -- Дата окончания акции     
    
    IN inUserId              Integer        -- Пользователь
)
  RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

   -- Проверка для TPartner1CLinkPlaceForm
   IF ioId <> 0 AND NOT EXISTS (SELECT Id FROM Object where Id = ioId AND DescId = zc_Object_Partner()) THEN
      RAISE EXCEPTION 'Ошибка.Корректировка элемента невозможна.';
   END IF;

   -- Проверка установки значений
   IF COALESCE (inJuridicalId, 0) = 0  THEN
      RAISE EXCEPTION 'Ошибка.Не установлено <Юридическое лицо>.';
   END IF;
   

   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   IF COALESCE (ioId, 0) = 0
   THEN
       -- сохранили <Объект>
       ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), inCode, '');
   END IF;

   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);

   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeJuridical(), ioId, inGLNCodeJuridical);
   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeRetail(), ioId, inGLNCodeRetail);   
   -- сохранили свойство <Код GLN>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_GLNCodeCorporate(), ioId, inGLNCodeCorporate);   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Schedule(), ioId, inSchedule);   
      
   -- сохранили свойство <За сколько дней принимается заказ>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_PrepareDayCount(), ioId, inPrepareDayCount /*CASE WHEN vbIsInsert = TRUE AND COALESCE (inPrepareDayCount, 0) = 0 THEN 1 ELSE inPrepareDayCount END*/);
   -- сохранили свойство <Через сколько дней оформляется документально>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_DocumentDayCount(), ioId, inDocumentDayCount);

   -- сохранили свойство <inCategory>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_Category(), ioId, inCategory);
   
   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <Маршруты>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), ioId, inRouteId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route30201(), ioId, inRouteId_30201);
   
   -- сохранили связь с <Сортировки маршрутов>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_RouteSorting(), ioId, inRouteSortingId);
   -- сохранили связь с <Физ лицо (сотрудник экспедитор)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), ioId, inMemberTakeId);
   
   -- сохранили связь с <Сотрудник (супервайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), ioId, inPersonalId);
   -- сохранили связь с <Сотрудник (торговый)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), ioId, inPersonalTradeId);
   -- сохранили связь с <Сотрудник (мерчандайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalMerch(), ioId, inPersonalMerchId);
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), ioId, inAreaId);
   -- сохранили связь с <Признак торговой точки>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), ioId, inPartnerTagId);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_GoodsProperty(), ioId, inGoodsPropertyId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PriceList(), ioId, inPriceListId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PriceList30201(), ioId, inPriceListId_30201);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_PriceListPromo(), ioId, inPriceListPromoId);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_UnitMobile(), ioId, inUnitMobileId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_StartPromo(), ioId, DATE (inStartPromo));
      -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Partner_EndPromo(), ioId, DATE (inEndPromo));

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiOrdspr(), ioId, inEdiOrdspr);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiInvoice(), ioId, inEdiInvoice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiDesadv(), ioId, inEdiDesadv);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION lpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.09.21         *
 25.05.21         *
 29.04.21         * Category
 19.06.17         * add inPersonalMerchId
 07.03.17         * add Schedule
 25.12.15         * add inGoodsPropertyId
 06.02.15         * add inEdiOrdspr, inEdiInvoice, inEdiDesadv
 22.11.14                                        * all
 10.11.14         * add redmine
 25.08.14                                        * set lp
 24.08.14                                        * add Проверка для TPartner1CLinkPlaceForm
 16.08.14                                        * add inAddress
 01.06.14         * add ShortName,
                        HouseNumber, CaseNumber, RoomNumber, Street
 24.04.14                                        * add inPartnerName
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
-- SELECT * FROM lpInsertUpdate_Object_Partner()
