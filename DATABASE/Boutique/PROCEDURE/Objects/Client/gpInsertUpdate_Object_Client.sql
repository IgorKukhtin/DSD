-- Покупатели

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Client(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Покупатели> 
    IN inCode                     Integer   ,    -- Код объекта <Покупатели>     
    IN inName                     TVarChar  ,    -- Название объекта <Покупатели>
    IN inDiscountCard             TVarChar  ,    -- Номер карты
    IN inDiscountTax              TFloat    ,    -- Процент скидки
    IN inDiscountTaxTwo           TFloat    ,    -- Процент скидки дополнительно
    IN inAddress                  TVarChar  ,    -- Адрес
    IN inHappyDate                TDateTime ,    -- День рождения
    IN inPhoneMobile              TVarChar  ,    -- Мобильный телефон
    IN inPhone                    TVarChar  ,    -- Телефон
    IN inMail                     TVarChar  ,    -- Электронная почта
    IN inComment                  TVarChar  ,    -- Примечание
    IN inCityId                   Integer   ,    -- Населенный пункт
    IN inDiscountKindId           Integer   ,    -- Вид накопительной скидки
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Client());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Client_seq'); END IF; 

   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Client(), inName);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Client(), inCode, inName);
 
   -- сохранили Номер карты
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_DiscountCard(), ioId, inDiscountCard);
   -- сохранили Процент скидки
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_DiscountTax(), ioId, inDiscountTax);
   -- сохранили Процент скидки дополнительно
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_DiscountTaxTwo(), ioId, inDiscountTaxTwo);
   -- сохранили Адрес
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Address(), ioId, inAddress);
   -- сохранили День рождения
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Client_HappyDate(), ioId, inHappyDate);
   -- сохранили Мобильный телефон
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_PhoneMobile(), ioId, inPhoneMobile);
   -- сохранили Телефон
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Phone(), ioId, inPhone);
   -- сохранили Электронная почта
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Mail(), ioId, inMail);
   -- сохранили Примечание
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Comment(), ioId, inComment);

   -- сохранили связь с <Населенный пункт>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_City(), ioId, inCityId);
   -- сохранили связь с <Вид накопительной скидки>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_DiscountKind(), ioId, inDiscountKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
02.03.17                                                           *
01.03.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Client()
