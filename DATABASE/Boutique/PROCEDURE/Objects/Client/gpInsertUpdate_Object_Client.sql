-- Function: gpInsertUpdate_Object_Client (Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Client(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Покупатели> 
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
    IN inCityId                   Integer   ,    -- ключ объекта <Город> 
    IN inDiscountKindId           Integer   ,    -- ключ объекта <Виды скидок> 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Client());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (vbCode_max, 0) = 0 THEN vbCode_max := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (vbCode_max, zc_Object_Client()); 
   
   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Client(), inName);



   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Client(), vbCode_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Client(), vbCode_max, inName);
 
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

   -- сохранили связь с <Город>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Client_City(), ioId, inCityId);
   -- сохранили связь с <Виды скидок>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Client_DiscountKind(), ioId, inDiscountKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
01.03.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Client()
