-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_AddressLoad (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_AddressLoad (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_AddressLoad (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_AddressLoad(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inPartnerName         TVarChar  ,    -- Наименование Контрагента
    IN inJuridicalName       TVarChar  ,    -- Наименование 
    IN inOKPO                TVarChar  ,    -- ОКПО
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
      AND TRIM (COALESCE (inOKPO, '')) = ''
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
   IF COALESCE (inId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не определено значение <Ключ>.', inPartnerName;
   END IF;
   -- проверка
   IF NOT EXISTS (SELECT Id FROM Object WHERE Id = inId AND DescId = zc_Object_Partner()) THEN
      RAISE EXCEPTION 'Ошибка.Не найден контрагент <%> со значением ключ <%>.', inPartnerName, inId;
   END IF;
   -- проверка
   IF 1=0 AND COALESCE (TRIM (inStreetName), '') = '' THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не определено значение <Улица>.', inPartnerName;
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
   IF COALESCE (vbPersonalId, 0) = 0 AND TRIM (inPersonal) <> '' THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение Супервайзера <%> в справочнике <Сотрудники>.', inPartnerName, inPersonal;
   END IF;


   -- замена
   IF POSITION (CHR (39) in inPersonalTrade) > 0 THEN inPersonalTrade:= left (inPersonalTrade, POSITION (CHR (39) in inPersonalTrade) - 1) || '`' || right (inPersonalTrade, length (inPersonalTrade) - POSITION (CHR (39) in inPersonalTrade)); END IF;
   -- поиск
   vbPersonalTradeId:= (SELECT MAX (PersonalId) FROM Object_Personal_View WHERE isMain = TRUE AND TRIM (PersonalName) = TRIM (inPersonalTrade));
   -- проверка
   IF COALESCE (vbPersonalTradeId, 0) = 0 AND TRIM (inPersonalTrade) <> ''  THEN
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

   IF COALESCE (TRIM (inStreetName), '') <> ''
   THEN
   -- сохранили
   PERFORM  lpUpdate_Object_Partner_Address( inId                := inId
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
                                           , inIsCheckUnique     := FALSE
                                           , inSession           := inSession
                                           , inUserId            := vbUserId
                                            );
   END IF;

   IF TRIM (inRetailName) <> '' THEN
   -- сохранили связь !!!Юр лица!!! с <Торговая сеть)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Juridical_Retail(), (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical()), vbRetailId);
   END IF;

   -- сохранили связь с <Сотрудник (супервайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, vbPersonalId);
   -- сохранили связь с <Сотрудник (торговый)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, vbPersonalTradeId);
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
-- SELECT * FROM gpUpdate_Object_Partner_Address()
