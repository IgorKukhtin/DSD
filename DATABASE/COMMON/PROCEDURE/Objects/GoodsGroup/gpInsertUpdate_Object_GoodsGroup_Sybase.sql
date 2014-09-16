-- Function: gpInsertUpdate_Object_GoodsGroup_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup_Sybase (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup_Sybase(
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
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());

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

   -- изменили свойство <Полное название группы> у всех товаров этой группы
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ObjectLink.ObjectId, lfGet_Object_TreeNameFull (ObjectLink.ChildObjectId, zc_ObjectLink_GoodsGroup_Parent()))
   FROM ObjectLink
   WHERE DescId = zc_ObjectLink_Goods_GoodsGroup()
     AND ChildObjectId IN -- !!! опускаемся на все уровни вниз !!!!
                     (SELECT ioId
                     UNION ALL
                      SELECT ObjectLink.ObjectId
                      FROM ObjectLink
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child1.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child2.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child3.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ChildObjectId = ObjectLink_Child2.ObjectId
                                                               AND ObjectLink_Child3.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child4.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ChildObjectId = ObjectLink_Child2.ObjectId
                                                               AND ObjectLink_Child3.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child4 ON ObjectLink_Child4.ChildObjectId = ObjectLink_Child3.ObjectId
                                                               AND ObjectLink_Child4.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child5.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ChildObjectId = ObjectLink_Child2.ObjectId
                                                               AND ObjectLink_Child3.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child4 ON ObjectLink_Child4.ChildObjectId = ObjectLink_Child3.ObjectId
                                                               AND ObjectLink_Child4.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child5 ON ObjectLink_Child5.ChildObjectId = ObjectLink_Child4.ObjectId
                                                               AND ObjectLink_Child5.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     )
  ;

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsGroup_Sybase (Integer, Integer, TVarChar, Integer, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.09.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroup_Sybase()
