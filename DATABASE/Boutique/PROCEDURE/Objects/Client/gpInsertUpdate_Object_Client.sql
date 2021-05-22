-- Function: gpInsertUpdate_Object_Client() - Покупатели

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

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
    IN inCurrencyId               Integer   ,    -- Валюта
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbIsOutlet Boolean;
   DECLARE vbUnitId   Integer;

   DECLARE vbName_Sybase TVarChar;
   DECLARE vbName_Sybase2 TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Client());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!Замена!!!
   inName:= TRIM (inName);

   -- Получили - 
   vbUnitId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Unit() AND OL.ObjectId = vbUserId);
   -- Проверка
   IF zc_Enum_GlobalConst_isTerry() = TRUE AND COALESCE (vbUnitId, 0) =  0 AND COALESCE (ioId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Нет прав добавлять Покупателя.';
   END IF;
   -- Получили - показывать ЛИ 
   vbIsOutlet := EXISTS (SELECT 1 FROM lfSelect_Object_Unit_isOutlet() AS lfSelect WHERE lfSelect.UnitId = vbUnitId);

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
      AND (inDiscountTax    <> COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTax()),    0)
        OR inDiscountTaxTwo <> COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_Client_DiscountTaxTwo()), 0)
          )
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
   IF vbIsOutlet = TRUE
   THEN
       IF EXISTS (WITH tmpUnit_isOutlet AS (SELECT * FROM lfSelect_Object_Unit_isOutlet())
                  SELECT 1
                  FROM Object AS Object_Client
                       LEFT JOIN ObjectBoolean AS ObjectBoolean_Client_Outlet
                                               ON ObjectBoolean_Client_Outlet.ObjectId = Object_Client.Id
                                              AND ObjectBoolean_Client_Outlet.DescId   = zc_ObjectBoolean_Client_Outlet()
                       LEFT JOIN ObjectLink AS ObjectLink_Client_InsertUnit
                                            ON ObjectLink_Client_InsertUnit.ObjectId = Object_Client.Id
                                           AND ObjectLink_Client_InsertUnit.DescId   = zc_ObjectLink_Client_InsertUnit()
                       LEFT JOIN tmpUnit_isOutlet ON tmpUnit_isOutlet.UnitId = ObjectLink_Client_InsertUnit.ChildObjectId
                  WHERE Object_Client.DescId = zc_Object_Client()
                    AND LOWER (TRIM (Object_Client.ValueData)) = LOWER (TRIM (inName))
                    AND Object_Client.Id <> COALESCE (ioId, 0)
                    AND (tmpUnit_isOutlet.UnitId > 0 OR ObjectBoolean_Client_Outlet.ValueData = TRUE)
                 )
       THEN
            RAISE EXCEPTION 'Ошибка добавления.Значение <%> уже существует.', inName;
       END IF;
   ELSE
       IF EXISTS (WITH tmpUnit_isOutlet AS (SELECT * FROM lfSelect_Object_Unit_isOutlet())
                  SELECT 1
                  FROM Object AS Object_Client
                       LEFT JOIN ObjectLink AS ObjectLink_Client_InsertUnit
                                            ON ObjectLink_Client_InsertUnit.ObjectId = Object_Client.Id
                                           AND ObjectLink_Client_InsertUnit.DescId   = zc_ObjectLink_Client_InsertUnit()
                       LEFT JOIN tmpUnit_isOutlet ON tmpUnit_isOutlet.UnitId = ObjectLink_Client_InsertUnit.ChildObjectId
                  WHERE Object_Client.DescId = zc_Object_Client()
                    AND LOWER (TRIM (Object_Client.ValueData)) = LOWER (TRIM (inName))
                    AND Object_Client.Id <> COALESCE (ioId, 0)
                    AND tmpUnit_isOutlet.UnitId IS NULL
                 )
       THEN
            RAISE EXCEPTION 'Ошибка добавления.Значение <%> уже существует.', inName;
       END IF;
   END IF;
   


   -- определяется признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

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

   -- сохранили связь с <Валюта>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_Currency(), ioId, inCurrencyId);

   -- определяется признак Создание/Корректировка
   IF vbIsInsert = TRUE
   THEN
       -- сохранили протокол - Подразделение (создание)
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_InsertUnit(), ioId, vbUnitId);
       -- сохранили протокол - Пользователь (создание)
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
       -- сохранили протокол - Дата создания
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
   ELSEIF NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Protocol_Insert() AND OL.ObjectId = ioId AND OL.ChildObjectId > 0)
   THEN
       -- сохранили протокол - Подразделение (создание) - если здесь было значение "пусто"
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_InsertUnit(), ioId, (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_User_Unit() AND OL.ObjectId = vbUserId));

   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
07.02.20          * add CurrencyName
13.05.17                                                           *
02.03.17                                                           *
01.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Client()
