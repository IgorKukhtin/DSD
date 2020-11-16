-- Function: gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceList(
 INOUT ioId            Integer   ,     -- ключ объекта <Прайс листы> 
    IN inCode          Integer   ,     -- Код объекта <Прайс листы> 
    IN inName          TVarChar  ,     -- Название объекта <Прайс листы> 
    IN inPriceWithVAT  Boolean   ,     -- Цена с НДС (да/нет)
    IN inVATPercent    TFloat    ,     -- % НДС
    IN inSession       TVarChar        -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

    -- Если код не установлен, определяем его как последний+1
   inCode:= lfGet_ObjectCode (inCode, zc_Object_PriceList());
   
   -- проверка прав уникальности для свойства <Наименование Прайс листа>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PriceList(), inName);
   -- проверка прав уникальности для свойства <Код Прайс листа>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PriceList(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceList(), inCode, inName);
   -- сохранили свойство <Цена с НДС (да/нет)>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PriceList_PriceWithVAT(), ioId, inPriceWithVAT);
   -- сохранили свойство <% НДС>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PriceList_VATPercent(), ioId, inVATPercent);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PriceList ()