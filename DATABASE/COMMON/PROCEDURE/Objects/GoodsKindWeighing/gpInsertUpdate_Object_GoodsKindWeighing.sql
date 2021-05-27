-- Function: gpInsertUpdate_Object_GoodsKindWeighing()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsKindWeighing();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsKindWeighing(
 INOUT ioId	         Integer,   	-- ключ объекта <Единица измерения>
    IN inCode        Integer,       -- свойство <Код Единицы измерения>
    IN inName        TVarChar,      -- главное Название Единицы измерения
    IN inGoodsKindId Integer,       -- свойство
    IN inGoodsKindWeighingGroupId Integer,       -- свойство
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;

BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighing());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_GoodsKindWeighing();
   ELSE
       Code_max := inCode;
   END IF;


   -- проверка уникальности для свойства
--   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsKindWeighing(), inName);
   -- проверка уникальности для свойства
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsKindWeighing(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsKindWeighing(), Code_max, inName);

   -- сохранили связь с <Виды упаковки>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsKindWeighing_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили связь с <Группы видов упаковки для взвешивания>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsKindWeighing_GoodsKindWeighingGroup(), ioId, inGoodsKindWeighingGroupId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsKindWeighing (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.03.14                                                         *
 21.03.14                                                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsKindWeighing()