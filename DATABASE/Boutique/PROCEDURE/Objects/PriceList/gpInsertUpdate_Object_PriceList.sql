-- Function: gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceList(
 INOUT ioId              Integer,       -- ключ объекта <Прайс лист>
 INOUT ioCode            Integer,       -- свойство <Код>
    IN inName            TVarChar,      -- главное Название
    IN inCurrencyId      Integer,       -- ключ объекта <Валюта> 
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_PriceList_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_PriceList_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_PriceList(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceList(), ioCode, inName);

   -- сохранили связь с <СВАлюта>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PriceList_Currency(), ioId, inCurrencyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
13.05.17                                                          *
08.05.17                                                          *
28.04.17          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PriceList()
