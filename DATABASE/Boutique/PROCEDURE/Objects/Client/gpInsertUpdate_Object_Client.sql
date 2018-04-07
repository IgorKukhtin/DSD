-- Покупатели

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Client(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Покупатели>
 INOUT ioCode                     Integer   ,    -- Код объекта <Покупатели>
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
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName_Sybase TVarChar;
   DECLARE vbName_Sybase2 TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Client());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!Замена!!!
   inName:= TRIM (inName);


   -- ВРЕМЕННО - для Sybase найдем Id
   IF vbUserId = zc_User_Sybase()
   THEN
       -- !!!поиск - из №2 !!!
       vbName_Sybase2:= (SELECT gpGet_Object_Client_NEW2_SYBASE (inName));
       
       IF vbName_Sybase2 <> ''
       THEN
           vbName_Sybase:= vbName_Sybase2;
       ELSE
           -- !!!поиск!!!
           vbName_Sybase:= (SELECT gpGet_Object_Client_NEW_SYBASE (inName));

           -- !!!поиск - из №2 + для vbName_Sybase!!!
           vbName_Sybase2:= (SELECT gpGet_Object_Client_NEW2_SYBASE (vbName_Sybase));
           --
           IF vbName_Sybase2 <> ''
           THEN
               vbName_Sybase:= vbName_Sybase2;
           END IF;

       END IF;
       
       -- !!!Замена!!!
       IF vbName_Sybase <> '' THEN inName:=  vbName_Sybase; END IF;

       -- !!!Замена!!!
       ioId:= (SELECT Object.Id
               FROM Object
               WHERE Object.DescId    = zc_Object_Client()
                 AND TRIM (LOWER (Object.ValueData)) = TRIM (LOWER (inName))
              );

       -- сохраняем предыдущий !!!Коммент!!!
       IF ioId > 0 AND TRIM (inComment) = ''
       THEN inComment:= COALESCE ((SELECT ObjectString.ValueData FROM ObjectString WHERE ObjectString.ObjectId = ioId AND ObjectString.DescId = zc_ObjectString_Client_Comment()), '');
       END IF;
       
       -- сохраняем предыдущий !!!DiscountTax!!!
       IF ioId > 0 AND COALESCE (inDiscountTax, 0) = 0
       THEN inDiscountTax:= COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTax()), 0);
       END IF;

       -- сохраняем предыдущий !!!DiscountTax!!!
       IF ioId > 0 AND inDiscountTax > 0 AND inDiscountTax > COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ValueData <> 0 AND ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTax()), inDiscountTax)
       THEN inDiscountTax:= COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ValueData <> 0 AND ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTax()), inDiscountTax);
       END IF;

   END IF;



   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Client_seq');
   END IF;

   -- Нужен для загрузки из Sybase т.к. там код = 0
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Client_seq');
   ELSEIF ioCode = 0
       THEN ioCode:= (SELECT ObjectCode FROM Object WHERE Id = ioId);
   END IF;


   -- Проверка
   IF TRIM (inName) = '' THEN
      RAISE EXCEPTION 'Ошибка.Необходимо ввести Название.';
   END IF;

   -- Проверка - нельзя > 30%
   IF vbUserId <> zc_User_Sybase()
      AND (inDiscountTax > 30 OR inDiscountTaxTwo > 30)
   THEN
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Client_DiscountTax());
   END IF;
   -- Проверка - нельзя DiscountTaxTwo
   IF ((ioId > 0 AND inDiscountTaxTwo <> COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()), 0))
    OR (ioId = 0 AND inDiscountTaxTwo <> 0)
      )
      -- если это Пользователь Магазина
      AND lpGetUnit_byUser (vbUserId) > 0
      -- если в Этом Магазине НЕТ Группы Товара
      AND 0 = COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = lpGetUnit_byUser (vbUserId) AND OL.DescId = zc_ObjectLink_Unit_GoodsGroup()), 0)
      -- 
      AND vbUserId <> zc_User_Sybase()
   THEN
       PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Object_Client_DiscountTaxTwo());
   END IF;



   -- проверка прав уникальности для свойства <Название>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Client(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Client(), ioCode, inName);

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
13.05.17                                                           *
02.03.17                                                           *
01.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Client()
