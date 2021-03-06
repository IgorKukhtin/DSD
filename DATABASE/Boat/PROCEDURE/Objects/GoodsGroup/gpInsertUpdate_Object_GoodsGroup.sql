-- Function: gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Группа товара>
 INOUT ioCode                     Integer   ,    -- Код объекта <Группа товара>
    IN inName                     TVarChar  ,    -- Название объекта <Группа товара>
    IN inParentId                 Integer   ,    -- ключ объекта <Группа товара>
    IN inInfoMoneyId              Integer   ,    -- ключ объекта <Статьи назначения 	>
    IN inModelEtiketenId          Integer   ,    -- модель печати этикетки
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_GoodsGroup());

   -- Проверка
   IF TRIM (inName) = '' THEN
      --RAISE EXCEPTION 'Ошибка.Необходимо ввести Название.';
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Необходимо ввести Название.' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_GoodsGroup' :: TVarChar
                                            , inUserId        := vbUserId
                                            );
   END IF;

   -- проверка уникальность <Название> для !!!<Группа>!!
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
       --RAISE EXCEPTION 'Ошибка.Группа товара <%> для <%> уже существует.', TRIM (inName), lfGet_Object_ValueData_sh (inParentId);
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Группа товара <%> для <%> уже существует.' :: TVarChar
                                               , inProcedureName := 'gpInsertUpdate_Object_GoodsGroup' :: TVarChar
                                               , inUserId        := vbUserId
                                               , inParam1        := TRIM (inName)    :: TVarChar
                                               , inParam2        := lfGet_Object_ValueData_sh (inParentId) :: TVarChar
                                               );
   END IF;

   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroup(), ioCode, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsGroup(), ioCode, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_Parent(), ioId, inParentId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_ModelEtiketen(), ioId, inModelEtiketenId);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


   -- изменили свойство <УП статью> у всех товаров этой группы
   PERFORM CASE WHEN inInfoMoneyId <> 0
                -- всем группам ниже - ставим эту статью
                THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ObjectLink.ObjectId, inInfoMoneyId)
                -- всем группам ниже - находим статью у группы выше
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


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
09.11.20          *
*/

-- тест
--