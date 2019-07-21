-- Function: gpInsertUpdate_Object_GoodsGroupPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroupPromo(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroupPromo(
 INOUT ioId                  Integer   ,    -- ключ объекта <Группа товаров>
    IN inCode                Integer   ,    -- Код объекта <Группа товаров>
    IN inName                TVarChar  ,    -- Название объекта <Группа товаров>
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Object_GoodsGroupPromo());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний + 1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_GoodsGroupPromo());
   
   -- !!! проверка уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsGroupPromo(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroupPromo(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsGroupPromo(), inCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsGroup(Integer, Integer, TVarChar, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroupPromo()