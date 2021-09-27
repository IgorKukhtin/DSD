-- Function: gpUpdate_Object_Partner_AddressLoad()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_AddressLoad (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                          , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                          , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_AddressLoad(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inPartnerName         TVarChar  ,    -- Наименование
    IN inJuridicalNameNew    TVarChar  ,    -- Наименование 
    IN inOKPO                TVarChar  ,    -- ОКПО
    IN inPaidKindName        TVarChar  ,    -- 
    IN inRegionName          TVarChar  ,    -- наименование области
    IN inProvinceName        TVarChar  ,    -- наименование район
    IN inCityName            TVarChar  ,    -- наименование населенный пункт
    IN inCityKindName        TVarChar  ,    -- Вид населенного пункта
    IN inProvinceCityName    TVarChar  ,    -- Микрорайон
    IN inPostalCode          TVarChar  ,    -- индекс
    IN inStreetName          TVarChar  ,    -- наименование улица
    IN inStreetKindName      TVarChar  ,    -- Вид улицы
    IN inHouseNumber         TVarChar  ,    -- Номер дома
    IN inCaseNumber          TVarChar  ,    -- Номер корпуса
    IN inRoomNumber          TVarChar  ,    -- Номер квартиры
    IN inShortName           TVarChar  ,    -- Условное обозначение

    IN inOrderName           TVarChar  ,    -- заказы
    IN inOrderPhone          TVarChar  ,    --
    IN inOrderMail           TVarChar  ,    --

    IN inDocName             TVarChar  ,    -- первичка
    IN inDocPhone            TVarChar  ,    --
    IN inDocMail             TVarChar  ,    --

    IN inActName             TVarChar  ,    -- Акты
    IN inActPhone            TVarChar  ,    --
    IN inActMail             TVarChar  ,    --
    
    IN inPersonal            TVarChar  ,    -- Сотрудник (супервайзер)
    IN inPersonalTrade       TVarChar  ,    -- Сотрудник (торговый)
    IN inArea                TVarChar  ,    -- Регион
    IN inRetailName          TVarChar  ,    -- Торговая сеть
    IN inPartnerTag          TVarChar  ,    -- Признак торговой точки

    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId                Integer;

   DECLARE vbIsCheckUnique         Boolean;

   DECLARE vbJuridicalId           Integer;

   DECLARE vbRetailId              Integer;
   DECLARE vbPersonalId            Integer;
   DECLARE vbPersonalTradeId       Integer;
   DECLARE vbAreaId                Integer;
   DECLARE vbPartnerTagId          Integer; 
   DECLARE vbCityKindId            Integer; 
   DECLARE vbStreetKindId          Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());


   -- игнорируем пустую строчку в Excel
   IF COALESCE (inId, 0) = 0
      AND TRIM (COALESCE (inPartnerName, '')) = ''
      AND TRIM (COALESCE (inJuridicalNameNew, '')) = ''
      AND TRIM (COALESCE (inOKPO, '')) = ''
      AND TRIM (COALESCE (inPaidKindName, '')) = ''
      AND TRIM (COALESCE (inRetailName, '')) = ''
      AND TRIM (COALESCE (inRegionName, '')) = ''
      AND TRIM (COALESCE (inProvinceName, '')) = ''
      AND TRIM (COALESCE (inCityName, '')) = ''
      AND TRIM (COALESCE (inCityKindName, '')) = ''
      AND TRIM (COALESCE (inProvinceCityName, '')) = ''
      AND TRIM (COALESCE (inPostalCode, '')) = ''
      AND TRIM (COALESCE (inStreetName, '')) = ''
      AND TRIM (COALESCE (inStreetKindName, '')) = ''
      AND TRIM (COALESCE (inHouseNumber, '')) = ''
      AND TRIM (COALESCE (inCaseNumber, '')) = ''
      AND TRIM (COALESCE (inRoomNumber, '')) = ''
      AND TRIM (COALESCE (inShortName, '')) = ''

      AND TRIM (COALESCE (inOrderName, '')) = ''
      AND TRIM (COALESCE (inOrderPhone, '')) = ''
      AND TRIM (COALESCE (inOrderMail, '')) = ''

      AND TRIM (COALESCE (inDocName, '')) = ''
      AND TRIM (COALESCE (inDocPhone, '')) = ''
      AND TRIM (COALESCE (inDocMail, '')) = ''

      AND TRIM (COALESCE (inActName, '')) = ''
      AND TRIM (COALESCE (inActPhone, '')) = ''
      AND TRIM (COALESCE (inActMail, '')) = ''
    
      AND TRIM (COALESCE (inPersonal, '')) = ''
      AND TRIM (COALESCE (inPersonalTrade, '')) = ''
      AND TRIM (COALESCE (inArea, '')) = ''
      AND TRIM (COALESCE (inPartnerTag, '')) = ''
   THEN
      RETURN;
   END IF;


   -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
      -- проверка
      IF 1=1 OR NOT EXISTS (SELECT Id FROM Object WHERE Id = zc_Enum_PaidKind_SecondForm() AND ValueData = inPaidKindName)
      THEN
          IF inPartnerName <> '' OR inOKPO <> ''
          THEN
              RAISE EXCEPTION 'Ошибка.Для контрагента <%> c ОКПО <%> не определено значение <Ключ>.', inPartnerName, inOKPO;
          ELSE RAISE EXCEPTION 'Ошибка.Пустая строка.<%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%> <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%> <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%> <%> '
                             , COALESCE (inId, 0)
                             , COALESCE (inPartnerName, '')
                             , COALESCE (inJuridicalNameNew, '')
                             , COALESCE (inOKPO, '')
                             , COALESCE (inPaidKindName, '')
                             , COALESCE (inRetailName, '')
                             , COALESCE (inRegionName, '')
                             , COALESCE (inProvinceName, '')
                             , COALESCE (inCityName, '')
                             , COALESCE (inCityKindName, '')
                             , COALESCE (inProvinceCityName, '')
                             , COALESCE (inPostalCode, '')
                             , COALESCE (inStreetName, '')
                             , COALESCE (inStreetKindName, '')
                             , COALESCE (inHouseNumber, '')
                             , COALESCE (inCaseNumber, '')
                             , COALESCE (inRoomNumber, '')
                             , COALESCE (inShortName, '')

                             , COALESCE (inOrderName, '')
                             , COALESCE (inOrderPhone, '')
                             , COALESCE (inOrderMail, '')

                             , COALESCE (inDocName, '')
                             , COALESCE (inDocPhone, '')
                             , COALESCE (inDocMail, '')

                             , COALESCE (inActName, '')
                             , COALESCE (inActPhone, '')
                             , COALESCE (inActMail, '')
    
                             , COALESCE (inPersonal, '')
                             , COALESCE (inPersonalTrade, '')
                             , COALESCE (inArea, '')
                             , COALESCE (inPartnerTag, '')
                              ;
          END IF;
      END IF;
      -- проверка
      IF COALESCE (TRIM (inStreetName), '') = ''
      THEN
         RAISE EXCEPTION 'Ошибка.Для контрагента <%> не определено значение <Название (улица, проспект)>.', inPartnerName;
      END IF;

      -- проверка ОКПО
      IF CHAR_LENGTH (COALESCE (TRIM (inOKPO), '')) <= 5 THEN
         RAISE EXCEPTION 'Ошибка.Для контрагента <%> не определено значение <ОКПО>.', inPartnerName;
      END IF;
       
      -- поиск по ОКПО
      vbJuridicalId:= (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE OKPO = TRIM (inOKPO));
      -- проверка
      IF COALESCE (vbJuridicalId, 0) = 0 THEN
         RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено юр.лицо с ОКПО = <%>.', inPartnerName, inOKPO;
      END IF;

   END IF;


   -- проверка
   IF inId > 0 AND NOT EXISTS (SELECT Id FROM Object WHERE Id = inId AND DescId = zc_Object_Partner()) THEN
      RAISE EXCEPTION 'Ошибка.Не найден контрагент <%> со значением ключ <%>.', inPartnerName, inId;
   END IF;

   -- проверка
   IF 1=1 AND COALESCE (TRIM (inStreetName), '') = '' THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не определено значение <Название (улица, проспект)>.', inPartnerName;
   END IF;


   -- поиск
   vbRetailId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Retail() AND TRIM (ValueData) = TRIM (inRetailName));
   -- добавление
   IF COALESCE (vbRetailId, 0) = 0 AND TRIM (inRetailName) <> '' THEN
     vbRetailId:= gpInsertUpdate_Object_Retail (ioId         := vbRetailId
                                              , inCode       := 0
                                              , inName       := TRIM (inRetailName)
                                              , inGLNCode    := ''
                                              , inSession    := inSession
                                               );
   END IF;
   -- проверка
   IF COALESCE (vbRetailId, 0) = 0 AND TRIM (inRetailName) <> '' THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение <%> в справочнике <Торговая сеть>.', inPartnerName, inRetailName;
   END IF;


IF inArea = 'дніпропетровськ' THEN inArea:= 'Дніпропетровськ'; END IF;
 

IF /*inId IN (293467, 296066) AND */ TRIM (inStreetKindName) = '' THEN inStreetKindName:= 'вулиця'; END IF;
IF inStreetKindName = 'Шосе' THEN inStreetKindName:= 'шосе'; END IF;
IF inStreetKindName = 'улица' THEN inStreetKindName:= 'вулиця'; END IF;
IF inStreetKindName = 'площадь' THEN inStreetKindName:= 'площа'; END IF;
IF inStreetKindName = 'пер.' THEN inStreetKindName:= 'провулок'; END IF;


IF inPartnerTag = 'дистритриб`ютор' OR inPartnerTag = 'дистриб' || CHR (39) || 'ютор' THEN inPartnerTag:= 'дистриб`ютор'; END IF;

IF inPersonal = 'Ковальчук Ігорь Леонідович' THEN inPersonal:= 'Ковальчук Ігор Леонідович'; END IF;
IF inPersonalTrade = 'Ковальчук Ігорь Леонідович' THEN inPersonalTrade:= 'Ковальчук Ігор Леонідович'; END IF;
IF inPersonal = 'Антонченко Наталья Осиповна' THEN inPersonal:= 'Антонченко Наталія Осипівна'; END IF;
IF inPersonalTrade = 'Антонченко Наталья Осиповна' THEN inPersonalTrade:= 'Антонченко Наталія Осипівна'; END IF;

IF inPersonal = 'Конюхов Сергій Генадійович' THEN inPersonal:= 'Конюхов Сергій Геннадійович'; END IF;
IF inPersonalTrade = 'Конюхов Сергій Генадійович' THEN inPersonalTrade:= 'Конюхов Сергій Геннадійович'; END IF;

IF inPersonal = 'Тюлю Анна Федорівна' THEN inPersonal:= 'Тюлю Ганна Федорівна'; END IF;
IF inPersonalTrade = 'Тюлю Анна Федорівна' THEN inPersonalTrade:= 'Тюлю Ганна Федорівна'; END IF;

IF inPersonalTrade = 'Гажев Олександр Олександрович' THEN inPersonalTrade:= 'Гажев Олександр Олександрович'; END IF;

IF inPersonalTrade = 'Мурзаєва Катерина Валеріїївна' THEN inPersonalTrade:= 'Мурзаєва Катерина Валеріївна'; END IF;
IF inPersonalTrade = 'Трубин Алексей' OR inPersonalTrade = 'Трубин Алексей Сергеевич' THEN inPersonalTrade:= 'Трубін Олексій Сергійович'; END IF;
IF inPersonalTrade = 'Гуслістий Олександр' THEN inPersonalTrade:= 'Гуслистий Олександр Анатолійович'; END IF;
IF inPersonalTrade = 'Мигуль Людмила' THEN inPersonalTrade:= 'Мигуль Людмила Валентинівна'; END IF;
IF inPersonalTrade = 'Петренко Евгений' THEN inPersonalTrade:= 'Петренко Євгеній Анатолійович'; END IF;
IF inPersonalTrade = 'Павлова Оксана' THEN inPersonalTrade:= 'Павлова Оксана Анатоліївна'; END IF;
IF inPersonalTrade = 'Леуш Иван' THEN inPersonalTrade:= 'Леуш Іван Володимирович'; END IF;
IF inPersonalTrade = 'Мигуль Людмила' THEN inPersonalTrade:= 'Мигуль Людмила Валентинівна'; END IF;
IF inPersonalTrade = 'Гордіенко Максим' THEN inPersonalTrade:= 'Гордієнко Максим Сергійович'; END IF;
IF inPersonalTrade = 'Чернявський Євген' THEN inPersonalTrade:= 'Чернявський Євгеній Вікторович'; END IF;
IF inPersonalTrade = 'Пономаренко Вікторія' THEN inPersonalTrade:= 'Пономаренко Вікторія Григорівна'; END IF;
 IF inPersonal = 'Мукосеева Олена Касьянівна' THEN inPersonal:= 'Мукосєєва Олена Кос`янівна'; END IF;
 IF inPersonalTrade = 'Мукосеева Олена Касьянівна' THEN inPersonalTrade:= 'Мукосєєва Олена Кос`янівна'; END IF;
 IF inPersonalTrade = 'Герасименко Марина Анатольевна' THEN inPersonalTrade:= 'Герасименко Марина  Анатоліївна'; END IF;


   -- замена
   IF POSITION (CHR (39) in inPersonal) > 0 THEN inPersonal:= left (inPersonal, POSITION (CHR (39) in inPersonal) - 1) || '`' || right (inPersonal, length (inPersonal) - POSITION (CHR (39) in inPersonal)); END IF;
   -- поиск
   vbPersonalId:= (SELECT MAX (PersonalId) FROM Object_Personal_View WHERE isMain = TRUE AND TRIM (PersonalName) = TRIM (inPersonal));
   -- проверка
   IF COALESCE (vbPersonalId, 0) = 0 AND TRIM (inPersonal) <> '' AND 1=0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение Супервайзера <%> в справочнике <Сотрудники>.', inPartnerName, inPersonal;
   END IF;


   -- замена
   IF POSITION (CHR (39) in inPersonalTrade) > 0 THEN inPersonalTrade:= left (inPersonalTrade, POSITION (CHR (39) in inPersonalTrade) - 1) || '`' || right (inPersonalTrade, length (inPersonalTrade) - POSITION (CHR (39) in inPersonalTrade)); END IF;
   -- поиск
   vbPersonalTradeId:= (SELECT MAX (PersonalId) FROM Object_Personal_View WHERE isMain = TRUE AND TRIM (PersonalName) = TRIM (inPersonalTrade));
   -- проверка
   IF COALESCE (vbPersonalTradeId, 0) = 0 AND TRIM (inPersonalTrade) <> '' AND 1=0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение Торговый представитель <%> в справочнике <Сотрудники>.', inPartnerName, inPersonalTrade;
   END IF;


   -- поиск
   vbAreaId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Area() AND TRIM (ValueData) = TRIM (inArea));
   -- проверка
   IF COALESCE (vbAreaId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение <%> в справочнике <Регионы>.', inPartnerName, inArea;
   END IF;


   -- поиск
   vbPartnerTagId:= (SELECT Id FROM Object WHERE DescId = zc_Object_PartnerTag() AND TRIM (ValueData) = TRIM (inPartnerTag));
   -- проверка
   IF COALESCE (vbPartnerTagId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение <%> в справочнике <Признак торговой точки>.', inPartnerName, inPartnerTag;
   END IF;


   -- поиск
   vbCityKindId:= (SELECT Id FROM Object WHERE DescId = zc_Object_CityKind() AND TRIM (ValueData) = TRIM (inCityKindName));
   -- проверка
   IF COALESCE (vbCityKindId, 0) = 0 AND COALESCE (TRIM (inStreetName), '') <> '' THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение <%> в справочнике <Вид населенного пункта>.', inPartnerName, inCityKindName;
   END IF;


   -- поиск
   vbStreetKindId:= (SELECT Id FROM Object WHERE DescId = zc_Object_StreetKind() AND TRIM (ValueData) = TRIM (inStreetKindName));
   -- проверка
   IF COALESCE (vbStreetKindId, 0) = 0 AND COALESCE (TRIM (inStreetName), '') <> '' THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение <%> в справочнике <Вид (улица,проспект)>.', inPartnerName, inStreetKindName;
   END IF;




   -- !!!поменяли название Юр.лица!!!
   IF inId <> 0
      AND TRIM (inJuridicalNameNew) <> ''
      AND EXISTS (SELECT Id FROM Object WHERE Id = zc_Enum_PaidKind_SecondForm() AND ValueData = inPaidKindName)
   THEN
      -- проверка
      IF NOT EXISTS (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE JuridicalId = (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical()) AND OKPO = TRIM (inOKPO))
      THEN
         RAISE EXCEPTION 'Ошибка.Для контрагента <%> нельзя изменть на юр.лицо с ОКПО = <%>.', inPartnerName, inOKPO;
      END IF;

       -- 
       PERFORM gpInsertUpdate_Object_Juridical (ioId               := tmp.Id
                                              , inCode             := tmp.Code
                                              , inName             := tmp.Name
                                              , inGLNCode          := tmp.GLNCode
                                              , inisCorporate      := isCorporate
                                              , inisTaxSummary     := NULL
                                              , inisDiscountPrice  := NULL
                                              , inDayTaxSummary    := 0
                                              , inJuridicalGroupId := tmp.JuridicalGroupId
                                              , inGoodsPropertyId  := tmp.GoodsPropertyId
                                              , inRetailId         := tmp.RetailId
                                              , inRetailReportId   := tmp.RetailReportId
                                              , inInfoMoneyId      := tmp.InfoMoneyId
                                              , inPriceListId      := tmp.PriceListId
                                              , inPriceListPromoId := tmp.PriceListPromoId
                                              , inStartPromo       := tmp.StartPromo
                                              , inEndPromo         := tmp.EndPromo
                                              , inSession          := inSession
                                               )
       FROM gpGet_Object_Juridical (inId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical())
                                  , inName    := ''
                                  , inSession := inSession
                                   ) AS tmp
       WHERE tmp.Id <> 0;
   END IF;


   IF COALESCE (TRIM (inStreetName), '') <> ''
   THEN
     -- поиск по адресу
     IF COALESCE (inId, 0) = 0
     THEN
         inId:= (SELECT ObjectLink.ObjectId
                 FROM ObjectLink INNER JOIN ObjectString ON ObjectString.ObjectId = ObjectLink.ObjectId AND ObjectString.DescId = zc_ObjectString_Partner_Address() AND ObjectString.ValueData
                = TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = vbCityKindId AND DescId = zc_ObjectString_CityKind_ShortName()), '')
              || ' ' || COALESCE (inCityName, '')
              || ' ' || COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = vbStreetKindId AND DescId = zc_ObjectString_StreetKind_ShortName()), '')
              || ' ' || COALESCE (inStreetName, '')
                     || CASE WHEN COALESCE (inHouseNumber, '') <> ''
                                  THEN ' ' || COALESCE (inHouseNumber, '')
                             ELSE ''
                        END
                     || CASE WHEN COALESCE (inCaseNumber, '') <> ''
                                  THEN ' ' || COALESCE (inCaseNumber, '')
                             ELSE ''
                        END
                       )
                 WHERE ObjectLink.ChildObjectId = vbJuridicalId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()

                UNION 
                 SELECT ObjectLink.ObjectId
                 FROM ObjectLink INNER JOIN ObjectString ON ObjectString.ObjectId = ObjectLink.ObjectId AND ObjectString.DescId = zc_ObjectString_Partner_Address() AND ObjectString.ValueData
                = TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = vbCityKindId AND DescId = zc_ObjectString_CityKind_ShortName()), '')
              || ' ' || COALESCE (inCityName, '')
              || ' ' || COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = vbStreetKindId AND DescId = zc_ObjectString_StreetKind_ShortName()), '')
              || ' ' || COALESCE (inStreetName, '')
                     || CASE WHEN COALESCE (inHouseNumber, '') <> ''
                                  THEN ' буд.' || COALESCE (inHouseNumber, '')
                             ELSE ''
                        END
                     || CASE WHEN COALESCE (inCaseNumber, '') <> ''
                                  THEN ' ' || COALESCE (inCaseNumber, '')
                             ELSE ''
                        END
                       )
                 WHERE ObjectLink.ChildObjectId = vbJuridicalId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()
                );
     END IF;


   -- сохранили
   IF COALESCE (inId, 0) = 0 THEN
   vbIsCheckUnique:= TRUE;
   inId := lpInsertUpdate_Object_Partner (ioId              := inId
                                        , inCode            := 0
                                        , inGLNCode         := ''
                                        , inGLNCodeJuridical:= ''
                                        , inGLNCodeRetail   := ''
                                        , inGLNCodeCorporate:= ''
                                        , inSchedule        := 'f;f;f;f;f;f;f'
                                        , inPrepareDayCount := 0
                                        , inDocumentDayCount:= 0
                                        , inCategory        := 0
                                        , inEdiOrdspr       := FALSE
                                        , inEdiInvoice      := FALSE
                                        , inEdiDesadv       := FALSE
                                        , inJuridicalId     := vbJuridicalId
                                        , inRouteId         := NULL
                                        , inRouteId_30201   := NULL
                                        , inRouteSortingId  := NULL
                                        , inMemberTakeId    := NULL
                                        , inPersonalId      := NULL
                                        , inPersonalTradeId := NULL
                                        , inAreaId          := NULL
                                        , inPartnerTagId    := NULL
                                        , inGoodsPropertyId := NULL
           
                                        , inPriceListId     := NULL
                                        , inPriceListId_30201:= NULL
                                        , inPriceListPromoId:= NULL
                                        , inUnitMobileId    := NULL
                                        , inStartPromo      := NULL
                                        , inEndPromo        := NULL
                                        , inUserId          := vbUserId
                                         );
   ELSE
       vbIsCheckUnique:= FALSE;
   END IF;


    -- сохранили
    PERFORM lpUpdate_Object_Partner_Address( inId                := inId
                                           , inJuridicalId       := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical())
                                           , inShortName         := inShortName
                                           , inCode              := (SELECT ObjectCode FROM Object WHERE Id = inId)
                                           , inRegionName        := inRegionName
                                           , inProvinceName      := inProvinceName
                                           , inCityName          := inCityName
                                           , inCityKindId        := vbCityKindId
                                           , inProvinceCityName  := inProvinceCityName  
                                           , inPostalCode        := inPostalCode
                                           , inStreetName        := inStreetName
                                           , inStreetKindId      := vbStreetKindId
                                           , inHouseNumber       := inHouseNumber
                                           , inCaseNumber        := inCaseNumber  
                                           , inRoomNumber        := inRoomNumber
                                           , inIsCheckUnique     := vbIsCheckUnique
                                           , inSession           := inSession
                                           , inUserId            := vbUserId
                                            );
   END IF;

   IF TRIM (inRetailName) <> ''
   THEN
       -- сохранили связь !!!Юр лица!!! с <Торговая сеть)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Juridical_Retail(), (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical()), vbRetailId);
   END IF;

   -- Контактные лица 
   PERFORM lpUpdate_Object_Partner_ContactPerson (inId        := inId
                                                , inOrderName := inOrderName
                                                , inOrderPhone:= inOrderPhone
                                                , inOrderMail := inOrderMail
                                                , inDocName   := inDocName
                                                , inDocPhone  := inDocPhone
                                                , inDocMail   := inDocMail
                                                , inActName   := inActName
                                                , inActPhone  := inActPhone
                                                , inActMail   := inActMail
                                                , inSession   := inSession
                                                 );


   -- сохранили связь с <Сотрудник (супервайзер)>
   IF vbPersonalId <> 0
   THEN
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, vbPersonalId);
   END IF;
   -- сохранили связь с <Сотрудник (торговый)>
   IF vbPersonalTradeId <> 0
   THEN
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, vbPersonalTradeId);
   END IF;
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), inId, vbAreaId);
   -- сохранили связь с <Признак торговой точки>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), inId, vbPartnerTagId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.12.14                                        * all
 01.12.14                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_AddressLoad()
