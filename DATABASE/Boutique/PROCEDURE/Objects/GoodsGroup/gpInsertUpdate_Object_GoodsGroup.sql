-- Function: gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Группа товара> 
 INOUT ioCode                     Integer   ,    -- Код объекта <Группа товара>
    IN inName                     TVarChar  ,    -- Название объекта <Группа товара>
    IN inParentId                 Integer   ,    -- ключ объекта <Группа товара> 
    IN inSession                  TVarChar       -- сессия пользователя  
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_GoodsGroup_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := coalesce((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 THEN  ioCode := NEXTVAL ('Object_GoodsGroup_seq'); 
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsGroup(), inName);
/*
   -- проверка уникальность <Наименование> для !!!одноq!! <Группа для состава товара>
   IF TRIM (inName) <> '' AND COALESCE (inParentId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                       ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                      AND ObjectLink_GoodsGroup_Parent.DescId = zc_ObjectLink_GoodsGroup_Parent()
                                      AND ObjectLink_GoodsGroup_Parent.ChildObjectId = inParentId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION 'Ошибка. Группа для состава товара <%> уже установлена у <%>.', TRIM (inName), lfGet_Object_ValueData (inParentId);
       END IF;
   END IF;
*/

   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroup(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsGroup(), ioCode, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsGroup_Parent(), ioId, inParentId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.17                                                           *
20.02.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroup()
