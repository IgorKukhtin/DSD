-- Function: gpInsertUpdateMobile_Object_Partner

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Object_Partner (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, 
                                                             TFloat, TFloat, TVarChar, Integer, TVarChar, TVarChar, TVarChar, 
                                                             Integer, TVarChar, TVarChar, TVarChar, Integer,
                                                             Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Object_Partner (
 INOUT ioId               Integer  ,  -- ключ объекта <Контрагент>
    IN inGUID             TVarChar ,  -- Глобальный уникальный идентификатор
    IN inShortName        TVarChar ,  -- краткое наименование
        
    IN inHouseNumber      TVarChar ,  -- Номер дома
    IN inCaseNumber       TVarChar ,  -- Номер корпуса
    IN inRoomNumber       TVarChar ,  -- Номер квартиры
    IN inPrepareDayCount  TFloat   ,  -- За сколько дней принимается заказ
    IN inDocumentDayCount TFloat   ,  -- Через сколько дней оформляется документально
    
    IN inJuridicalGUID    TVarChar ,  -- Юридическое лицо (Глобальный уникальный идентификатор)

    IN inAreaId           Integer  ,  -- Регион
    IN inRegionName       TVarChar ,  -- наименование области
    IN inProvinceName     TVarChar ,  -- наименование район
    IN inCityName         TVarChar ,  -- наименование населенный пункт
    IN inCityKindId       Integer  ,  -- Вид населенного пункта
    IN inProvinceCityName TVarChar ,  -- наименование района населенного пункта
    IN inPostalCode       TVarChar ,  -- индекс
    IN inStreetName       TVarChar ,  -- наименование улица
    IN inStreetKindId     Integer  ,  -- Вид улицы

    IN inValue1           Boolean  ,  -- понедельник значение
    IN inValue2           Boolean  ,  -- вторник
    IN inValue3           Boolean  ,  -- среда
    IN inValue4           Boolean  ,  -- четверг
    IN inValue5           Boolean  ,  -- пятница
    IN inValue6           Boolean  ,  -- суббота
    IN inValue7           Boolean  ,  -- воскресенье
    
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbPriceListId_def Integer;
   DECLARE vbId Integer;
BEGIN
      
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      IF COALESCE (inJuridicalGUID, '') = ''
      THEN
           RAISE EXCEPTION 'Ошибка. Не задан глобальный уникальный идентификатор юр.лица';
      END IF;

      -- ищем юр.лицо по значению глобального уникального идентификатора
      SELECT ObjectString_Juridical_GUID.ObjectId
      INTO vbJuridicalId
      FROM ObjectString AS ObjectString_Juridical_GUID
           JOIN Object AS Object_Juridical
                       ON Object_Juridical.Id = ObjectString_Juridical_GUID.ObjectId
                      AND Object_Juridical.DescId = zc_Object_Juridical()
      WHERE ObjectString_Juridical_GUID.DescId = zc_ObjectString_Juridical_GUID()
        AND ObjectString_Juridical_GUID.ValueData = inJuridicalGUID;

      IF COALESCE (inGUID, '') = ''
      THEN
           RAISE EXCEPTION 'Ошибка. Не задан глобальный уникальный идентификатор';
      END IF;

      SELECT PersonalId, PriceListId_def INTO vbPersonalId, vbPriceListId_def FROM gpGetMobile_Object_Const (inSession);

      -- ищем контрагента по значению глобального уникального идентификатора
      SELECT ObjectString_Partner_GUID.ObjectId
      INTO vbId
      FROM ObjectString AS ObjectString_Partner_GUID
           JOIN Object AS Object_Partner
                       ON Object_Partner.Id = ObjectString_Partner_GUID.ObjectId
                      AND Object_Partner.DescId = zc_Object_Partner()
      WHERE ObjectString_Partner_GUID.DescId = zc_ObjectString_Partner_GUID()
        AND ObjectString_Partner_GUID.ValueData = inGUID;

      ioId:= (SELECT tmpPartner.ioId FROM gpInsertUpdate_Object_Partner(ioId               := COALESCE (vbId, 0)::Integer -- ключ объекта <Контрагент> 
                                                                      , inCode             := 0                  -- код объекта <Контрагент>
                                                                      , inShortName        := inShortName        -- краткое наименование
                                                                      , inGLNCode          := ''::TVarChar       -- Код GLN
                                                                      , inGLNCodeJuridical := ''::TVarChar       -- Код GLN - Покупатель
                                                                      , inGLNCodeRetail    := ''::TVarChar       -- Код GLN - Получатель
                                                                      , inGLNCodeCorporate := ''::TVarChar       -- Код GLN - Поставщик
                                                                         
                                                                      , inHouseNumber      := inHouseNumber      -- Номер дома
                                                                      , inCaseNumber       := inCaseNumber       -- Номер корпуса
                                                                      , inRoomNumber       := inRoomNumber       -- Номер квартиры
                                                                      , inStreetId         := 0                  -- Улица/проспект  
                                                                      , inPrepareDayCount  := inPrepareDayCount  -- За сколько дней принимается заказ
                                                                      , inDocumentDayCount := inDocumentDayCount -- Через сколько дней оформляется документально
                                                                       
                                                                      , inEdiOrdspr        := false -- EDI - Подтверждение
                                                                      , inEdiInvoice       := false -- EDI - Счет
                                                                      , inEdiDesadv        := false -- EDI - уведомление
                                                                       
                                                                      , inJuridicalId      := vbJuridicalId -- Юридическое лицо
                                                                      , inRouteId          := 0             -- Маршрут
                                                                      , inRouteSortingId   := 0             -- Сортировка маршрутов
                                                                       
                                                                      , inMemberTakeId     := 0            -- Физ лицо(сотрудник экспедитор)
                                                                      , inPersonalId       := 0            -- Физ лицо (ответственное лицо)
                                                                      , inPersonalTradeId  := vbPersonalId -- Физ лицо(торговый)
                                                                      , inAreaId           := inAreaId     -- Регион
                                                                      , inPartnerTagId     := 0            -- Признак торговой точки
                                                                       
                                                                      , inGoodsPropertyId  := 0 -- Классификаторы свойств товаров
                                                                       
                                                                      , inPriceListId      := vbPriceListId_def -- Прайс-лист
                                                                      , inPriceListPromoId := 0                 -- Прайс-лист(Акционный)
                                                                      , inStartPromo       := NULL              -- Дата начала акции
                                                                      , inEndPromo         := NULL              -- Дата окончания акции
                                                                       
                                                                      , inRegionName       := inRegionName       -- наименование области
                                                                      , inProvinceName     := inProvinceName     -- наименование район
                                                                      , inCityName         := inCityName         -- наименование населенный пункт
                                                                      , inCityKindId       := inCityKindId       -- Вид населенного пункта
                                                                      , inProvinceCityName := inProvinceCityName -- наименование района населенного пункта
                                                                      , inPostalCode       := inPostalCode       -- индекс
                                                                      , inStreetName       := inStreetName       -- наименование улица
                                                                      , inStreetKindId     := inStreetKindId     -- Вид улицы

                                                                      , inValue1           := inValue1  -- понедельник значение
                                                                      , inValue2           := inValue2  -- вторник
                                                                      , inValue3           := inValue3  -- среда
                                                                      , inValue4           := inValue4  -- четверг
                                                                      , inValue5           := inValue5  -- пятница
                                                                      , inValue6           := inValue6  -- суббота
                                                                      , inValue7           := inValue7  -- воскресенье
                                                                       
                                                                      , inSession          := inSession -- сессия пользователя
                                                                       ) AS tmpPartner);
   
      -- сохранили свойство <Глобальный уникальный идентификатор>
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_GUID(), ioId, inGUID);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 05.04.17                                                         *
*/

-- тест
/* SELECT * FROM gpInsertUpdateMobile_Object_Partner (ioId               := 0
                                                    , inGUID             := '{FD0D2968-FE5A-49B8-AC9B-29E0FC741E91}'
                                                    , inShortName        := 'Контрагент с моб. устройства'

                                                    , inHouseNumber      := '5'  -- Номер дома
                                                    , inCaseNumber       := '1'  -- Номер корпуса
                                                    , inRoomNumber       := '37' -- Номер квартиры
                                                    , inPrepareDayCount  := 1    -- За сколько дней принимается заказ
                                                    , inDocumentDayCount := 1    -- Через сколько дней оформляется документально
                                                   
                                                    , inJuridicalGUID    := '{CCCCEF83-D391-4CDB-A471-AF9DD07AC7D9}' -- Юридическое лицо (Глобальный уникальный идентификатор)

                                                    , inAreaId           := 310820          -- Регион
                                                    , inRegionName       := 'Полтавская'    -- наименование области
                                                    , inProvinceName     := 'Гадячский'     -- наименование район
                                                    , inCityName         := 'Гадяч'         -- наименование населенный пункт
                                                    , inCityKindId       := 310784          -- Вид населенного пункта
                                                    , inProvinceCityName := ''              -- наименование района населенного пункта
                                                    , inPostalCode       := '45034'         -- индекс
                                                    , inStreetName       := 'Котляревского' -- наименование улица
                                                    , inStreetKindId     := 310787          -- Вид улицы

                                                    , inValue1           := true   -- понедельник значение
                                                    , inValue2           := false  -- вторник
                                                    , inValue3           := true   -- среда
                                                    , inValue4           := false  -- четверг
                                                    , inValue5           := true   -- пятница
                                                    , inValue6           := false  -- суббота
                                                    , inValue7           := false  -- воскресенье

                                                    , inSession          := zfCalc_UserAdmin()
                                                     )
*/
