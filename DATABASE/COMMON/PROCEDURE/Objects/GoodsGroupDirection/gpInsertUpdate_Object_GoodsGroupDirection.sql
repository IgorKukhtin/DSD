 -- Function: gpInsertUpdate_Object_GoodsGroupDirection()

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsGroupDirection (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroupDirection(
   INOUT ioId                       Integer,     -- ид
      IN incode                     Integer,     -- код 
      IN inName                     TVarChar,    -- наименование 
      IN inSession                  TVarChar     -- Пользователь
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroupDirection());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   incode:=lfGet_ObjectCode (inCode, zc_Object_GoodsGroupDirection()); 
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsGroupDirection(), inName);
   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroupDirection(), incode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsGroupDirection(), incode, inName);
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.24         *
*/

-- тест
-- 
