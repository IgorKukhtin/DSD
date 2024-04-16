-- Торговая марка

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar , TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar , TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId              Integer,       -- ключ объекта <>
 INOUT ioCode            Integer,       -- свойство <Код >
    IN inName            TVarChar,      -- главное Название
    IN inComment         TVarChar,      --
    IN inFax             TVarChar,
    IN inPhone           TVarChar,
    IN inMobile          TVarChar,
    IN inIBAN            TVarChar,
    IN inStreet          TVarChar,
    IN inStreet_add      TVarChar,
    IN inMember          TVarChar,
    IN inWWW             TVarChar,
    IN inEmail           TVarChar,
    IN inCodeDB          TVarChar,
    IN inTaxNumber       TVarChar,
    IN inPLZ             TVarChar,
    IN inCityName        TVarChar,
    IN inCountryName     TVarChar,
    IN inDiscountTax     TFloat ,
    IN inDayCalendar     TFloat ,
    IN inDayBank         TFloat ,
    IN inBankId          Integer ,
    --IN inPLZId           Integer ,
    IN inInfoMoneyId     Integer ,
    IN inTaxKindId       Integer ,
    IN inPaidKindId      Integer ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCountryId Integer;
   DECLARE vbPLZId Integer;
   DECLARE vbIsCheck_not Boolean;
BEGIN
   vbIsCheck_not:=  zfConvert_StringToNumber (inSession) < 0;

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());
   IF zfConvert_StringToNumber (inSession) < 0 THEN inSession:= (-1 * zfConvert_StringToNumber (inSession)) :: TVarChar; END IF;
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (ioCode, zc_Object_Partner());

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Partner(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Partner(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Fax(), ioId, inFax);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Phone(), ioId, inPhone);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Mobile(), ioId, inMobile);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_IBAN(), ioId, inIBAN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Street(), ioId, inStreet);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Street_add(), ioId, inStreet_add);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Member(), ioId, inMember);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_WWW(), ioId, inWWW);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Email(), ioId, inEmail);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_CodeDB(), ioId, inCodeDB);
   -- сохранили свойство <Налоговый номер>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_TaxNumber(), ioId, inTaxNumber);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Partner_DiscountTax(), ioId, inDiscountTax);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Partner_DayCalendar(), ioId, inDayCalendar);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Partner_Bank(), ioId, inDayBank);

   -- сохранили свойство <>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PLZ(), ioId, inPLZId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Bank(), ioId, inBankId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_TaxKind(), ioId, CASE WHEN inTaxKindId > 0 THEN inTaxKindId ELSE zc_Enum_TaxKind_Basis() END);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PaidKind(), ioId, CASE WHEN inPaidKindId > 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END);


   IF vbIsCheck_not = FALSE
   THEN
       -- проверка <inCountryName>
       IF TRIM (COALESCE (inCountryName, '')) = ''
       THEN
           RAISE EXCEPTION 'Ошибка.Значение <Country> должно быть установлено.';
       END IF;

       -- проверка <inCityName>
       IF TRIM (COALESCE (inCityName, '')) = ''
       THEN
           RAISE EXCEPTION 'Ошибка.Значение <City> должно быть установлено.';
       END IF;

       -- проверка <inPLZ>
       IF TRIM (COALESCE (inPLZ, '')) = ''
       THEN
           RAISE EXCEPTION 'Ошибка.Значение <PLZ> должно быть установлено.';
       END IF;
   END IF;


   -- inPLZId заменили на город и страну, можно вводить вручную, можно выбирать, если ввели и такого нет в справочнике создаем    ,
   -- страна
   vbCountryId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Country() AND TRIM(Object.ValueData) ILIKE TRIM(inCountryName) AND Object.isErased = FALSE);
   --
   IF COALESCE (vbCountryId, 0) = 0
   THEN
       IF (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_Country() AND TRIM(Object.ValueData) ILIKE TRIM(inCountryName))
       THEN 
           RAISE EXCEPTION 'Ошибка.В справочнике найдено несколько значений <%>.', TRIM(inCountryName);
       END IF;
       --
       vbCountryId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Country() AND TRIM(Object.ValueData) ILIKE TRIM(inCountryName)); 
      
       --если не нашли пробуем поиск по короткому названию 
       IF COALESCE (vbCountryId,0) = 0 
       THEN
           vbCountryId := (SELECT ObjectString.ObjectId
                           FROM ObjectString
                           WHERE ObjectString.DescId = zc_ObjectString_Country_ShortName()
                           AND UPPER(TRIM(ObjectString.ValueData))  ILIKE UPPER (TRIM(inCountryName))
                           );
       END IF;
       
   END IF;
   -- если не находим создаем
   IF COALESCE (vbCountryId,0) = 0 AND TRIM (inCountryName) <> ''
   THEN  
        IF LENGTH (TRIM (inCountryName)) > 3 
        THEN
        vbCountryId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_Country (ioId        := 0         :: Integer
                                                          , ioCode      := 0         :: Integer
                                                          , inName      := TRIM(inCountryName) :: TVarChar
                                                          , inShortName := ''        :: TVarChar
                                                          , inSession   := inSession :: TVarChar
                                                           ) AS tmp); 
        ELSE
             RAISE EXCEPTION 'Ошибка.Слишком короткое название страны <%>.', TRIM(inCountryName);
        END IF;
   END IF;

   -- пробуем найти  PLZId
   vbPLZId := (SELECT Object_PLZ.Id
               FROM Object AS Object_PLZ
                    INNER JOIN ObjectString AS ObjectString_City
                                            ON ObjectString_City.ObjectId = Object_PLZ.Id
                                           AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()
                                           AND UPPER (TRIM (ObjectString_City.ValueData)) = UPPER (TRIM (inCityName))

                    INNER JOIN ObjectLink AS ObjectLink_Country
                                          ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                                         AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
                                         AND COALESCE (ObjectLink_Country.ChildObjectId,0) = vbCountryId

               WHERE Object_PLZ.DescId = zc_Object_PLZ()
                 AND Object_PLZ.isErased = FALSE
                 AND TRIM (Object_PLZ.ValueData) ILIKE TRIM (inPLZ)
                );

   IF COALESCE (vbPLZId,0) = 0 AND TRIM (inCityName) <> ''
   THEN
        vbPLZId := (SELECT tmp.ioId
                    FROM gpInsertUpdate_Object_PLZ (ioId        := 0
                                                  , ioCode      := 0
                                                  , inName      := TRIM (inPLZ)
                                                  , inCity      := TRIM (inCityName) :: TVarChar
                                                  , inAreaCode  := ''        ::TVarChar
                                                  , inComment   := ''        ::TVarChar
                                                  , inCountryId := vbCountryId
                                                  , inSession   := inSession :: TVarChar
                                                   ) AS tmp
                   );
   END IF;

   -- сохранили свойство <PLZ почтовый адрес>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PLZ(), ioId, vbPLZId);



   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.08.23         *
 17.06.21         *
 02.02.21         *
 09.11.20         *
 22.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner()
