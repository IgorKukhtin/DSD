-- 
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptService (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptService(
 INOUT ioId           Integer,       -- Ключ объекта < >
 INOUT ioCode         Integer,       -- Код Объекта < >
    IN inName         TVarChar,      -- Название объекта <>
    IN inArticle      TVarChar,      -- 
    IN inComment      TVarChar,      -- Краткое название
    IN inTaxKindId    Integer ,      -- НДС
    IN inEKPrice      TFloat  ,      -- Вх. цена без ндс
    IN inSalePrice    TFloat  ,      -- Цена продажи без ндс
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptService());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- Если код не установлен, определяем его как последний+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_ReceiptService()); 

   -- проверка уникальности для свойства <Наименование Страна>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ReceiptService(), inName ::TVarChar, vbUserId);
   -- проверка уникальности для свойства <Код Страна>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReceiptService(), ioCode, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptService(), ioCode, inName);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptService_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), ioId, inArticle);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptService_EKPrice(), ioId, inEKPrice);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptService_SalePrice(), ioId, inSalePrice);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptService_TaxKind(), ioId, inTaxKindId);


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
22.12.20          *
11.12.20          *
*/

-- тест
--