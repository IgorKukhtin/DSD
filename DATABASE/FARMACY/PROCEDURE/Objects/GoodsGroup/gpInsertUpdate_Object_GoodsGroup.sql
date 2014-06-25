-- Function: gpInsertUpdate_Object_GoodsGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup(
 INOUT ioId                  Integer   ,    -- ключ объекта <Группа товаров>
    IN inCode                Integer   ,    -- Код объекта <Группа товаров>
    IN inName                TVarChar  ,    -- Название объекта <Группа товаров>
    IN inParentId            Integer   ,    -- ссылка на группу товаров
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   vbUserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT COALESCE (MAX (ObjectCode), 0) + 1 INTO vbCode FROM Object WHERE Object.DescId = zc_Object_GoodsGroup();
   ELSE
       vbCode := inCode;
   END IF; 
   

   -- !!! проверка уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsGroup(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroup(), vbCode);

   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink (ioId, zc_ObjectLink_GoodsGroup_Parent(), inParentId);
   

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsGroup(), inCode, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_Parent(), ioId, inParentId);


  ;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsGroup (Integer, Integer, TVarChar, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.14         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroup()
