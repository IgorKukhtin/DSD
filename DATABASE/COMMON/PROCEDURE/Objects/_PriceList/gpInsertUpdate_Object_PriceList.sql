-- Function: gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar);

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
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_PriceList();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование Прайс листа>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PriceList(), inName);
   -- проверка прав уникальности для свойства <Код Прайс листа>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PriceList(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceList(), Code_max, inName);
   -- сохранили свойство <Цена с НДС (да/нет)>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectFloat_Partner_PrepareDayCount(), ioId, inPriceWithVAT);
   -- сохранили свойство <% НДС>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PriceList_VATPercent(), ioId, inVATPercent);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.09.13                                        * add PriceWithVAT and VATPercent
 14.06.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PriceList ()