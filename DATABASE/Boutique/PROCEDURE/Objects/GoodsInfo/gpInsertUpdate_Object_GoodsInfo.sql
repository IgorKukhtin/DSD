-- Описание товара

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsInfo (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsInfo(
 INOUT ioId           Integer,       -- Ключ объекта <Описание товара>            
 INOUT ioCode         Integer,       -- Код объекта <Описание товара>             
    IN inName         TVarChar,      -- Название объекта <Описание товара>        
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_GoodsInfo_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := coalesce((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 THEN  ioCode := NEXTVAL ('Object_GoodsInfo_seq'); 
   END IF; 
   
   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsInfo(), inName); 
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsInfo(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsInfo(), ioCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.17                                                          *
19.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsInfo()
