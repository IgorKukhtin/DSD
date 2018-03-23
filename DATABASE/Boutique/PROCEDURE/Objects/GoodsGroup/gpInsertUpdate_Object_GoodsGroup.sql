-- Function: gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Группа товара>
 INOUT ioCode                     Integer   ,    -- Код объекта <Группа товара>
    IN inName                     TVarChar  ,    -- Название объекта <Группа товара>
    IN inParentId                 Integer   ,    -- ключ объекта <Группа товара>
    IN inInfoMoneyId              Integer   ,    -- ключ объекта <Статьи назначения 	>
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());
   vbUserId:= lpGetUserBySession (inSession);


   IF vbUserId = zc_User_Sybase() AND ioId > 0 AND NOT EXISTS (SELECT 1 FROM Object WHERE Id = ioId)
   THEN ioId:= 0;
   END IF;

   /*IF vbUserId = zc_User_Sybase() AND ioId > 0 AND NOT EXISTS (SELECT 1
                                                               FROM Object
                                                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                                                                         ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                                                                        AND ObjectLink_GoodsGroup_Parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                                                               WHERE Object.DescId = zc_Object_GoodsGroup() 
                                                                 AND Object.Id     = ioId
                                                                 AND COALESCE (ObjectLink_GoodsGroup_Parent.ChildObjectId, 0) = COALESCE (inParentId, 0)
                                                              )
   THEN ioId:= 0;
   END IF;*/

   -- Поиск для Sybase
   IF vbUserId = zc_User_Sybase() AND COALESCE (ioId, 0) = 0
   THEN ioId:= (SELECT Object.Id
                FROM Object
                     LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                          ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                         AND ObjectLink_GoodsGroup_Parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                WHERE Object.DescId = zc_Object_GoodsGroup() AND TRIM (LOWER (Object.ValueData)) = TRIM (LOWER (inName))
                  AND COALESCE (ObjectLink_GoodsGroup_Parent.ChildObjectId, 0) = COALESCE (inParentId, 0)
                ORDER BY Object.Id
                -- !!!ПОТОМ УБРАТЬ!!!
                -- LIMIT 1
               );
   END IF;


   IF vbUserId = zc_User_Sybase() AND COALESCE (ioId, 0) = 0
   THEN
       -- Нужен для загрузки из Sybase т.к. там код = 0
       ioCode := NEXTVAL ('Object_GoodsGroup_seq');

   ELSEIF vbUserId = zc_User_Sybase()
   THEN
       -- Нужен для загрузки из Sybase т.к. там код = 0
       ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);

   -- Нужен ВСЕГДА - ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   ELSEIF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_GoodsGroup_seq');
   END IF;


   -- Проверка
   IF TRIM (inName) = '' THEN
      RAISE EXCEPTION 'Ошибка.Необходимо ввести Название.';
   END IF;

   -- проверка уникальность <Название> для !!!<Группа>!!
   -- IF vbUserId <> zc_User_Sybase() -- !!!ПОТОМ УБРАТЬ!!!
   -- THEN
   IF EXISTS (SELECT Object.Id
              FROM Object
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                        ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                       AND ObjectLink_GoodsGroup_Parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
              WHERE Object.DescId = zc_Object_GoodsGroup() AND TRIM (LOWER (Object.ValueData)) = TRIM (LOWER (inName))
                AND COALESCE (ObjectLink_GoodsGroup_Parent.ChildObjectId, 0) = COALESCE (inParentId, 0)
                AND Object.Id <> COALESCE (ioId, 0)
             )
   THEN
       RAISE EXCEPTION 'Ошибка.Группа товара <%> для <%> уже существует.', TRIM (inName), lfGet_Object_ValueData_sh (inParentId);
   END IF;

   -- END IF;


   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroup(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsGroup(), ioCode, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_Parent(), ioId, inParentId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_InfoMoney(), ioId, inInfoMoneyId);



   -- изменили свойство <УП статью> у всех товаров этой группы
   PERFORM CASE WHEN inInfoMoneyId <> 0
                THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ObjectLink.ObjectId, inInfoMoneyId)
                ELSE lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ObjectLink.ObjectId, lfGet_Object_GoodsGroup_InfoMoneyId (ObjectLink.ChildObjectId))
           END
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
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
07.06.17          * InfoMoney
13.05.17                                                           *
06.03.17                                                           *
20.02.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroup (ioId := 0 , ioCode := 0 , inName := 'Группа товара 2' ::TVarChar, inParentId := 0 , inInfoMoneyId := 0 ,  inSession := '2'::TVarChar);
