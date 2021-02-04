-- Function: gpInsertUpdate_Object_Cash ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Cash (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Cash(
 INOUT ioId           Integer,       -- Ключ объекта <Касса>         
 INOUT ioCode         Integer,       -- Код объекта <Касса>          
    IN inName         TVarChar,      -- Название объекта <Касса> 
    IN inCurrencyId   Integer,       -- Валюта
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Cash());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Cash_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Cash_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- проверка уникальности для свойства <Код Cash>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Cash(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Cash(), ioCode, inName);
   -- сохранили связь с <Валюта>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Cash_Currency(), ioId, inCurrencyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Cash()
