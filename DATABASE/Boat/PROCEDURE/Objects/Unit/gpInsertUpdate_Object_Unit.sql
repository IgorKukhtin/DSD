-- Function: gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar,  Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Подразделения> 
 INOUT ioCode                     Integer   ,    -- Код объекта <Подразделения> 
    IN inName                     TVarChar  ,    -- Название объекта <Подразделения>
    IN inAddress                  TVarChar  ,    -- Адрес
    IN inPhone                    TVarChar  ,    -- Телефон
    IN inPrinter                  TVarChar  ,    -- Принтер (печать чеков)
    IN inPrint                    TVarChar  ,    -- Название при печати
    IN inIsPartnerBarCode         Boolean   ,    -- Ш/К поставщика
    IN inDiscountTax              TFloat    ,    -- % скидки ВИНТАЖ
    IN inJuridicalId              Integer   ,    -- ключ объекта <Юридические лица> 
    IN inParentId                 Integer   ,    -- ключ объекта <Група> 
    IN inChildId                  Integer   ,    -- ключ объекта <Склад>
    IN inBankAccountId            Integer   ,    -- ключ объекта <Расчетный счет>
    IN inAccountDirectionId       Integer   ,    -- ключ объекта <Аналитики управленческих счетов - направление>
    IN inGoodsGroupId             Integer   ,    -- ключ объекта <Группа товара>
    IN inPriceListId              Integer   ,    -- ключ объекта <Прайс лист>
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Unit_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Unit_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 
   
   -- для загрузки из Sybase
   IF vbUserId = zc_User_Sybase() AND ioId > 0
   THEN
        inPrinter:= (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = ioId AND OS.DescId = zc_ObjectString_Unit_Printer());
        inGoodsGroupId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Unit_GoodsGroup());
   END IF;
   

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), ioCode, inName);

   -- сохранили Адрес
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Address(), ioId, inAddress);
   -- сохранили Телефон
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Phone(), ioId, inPhone);
   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <Група>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Parent(), ioId, inParentId);
   -- сохранили связь с <Склад>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Child(), ioId, inChildId);

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
 22.10.20          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Unit()
