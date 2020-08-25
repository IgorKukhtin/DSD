-- Function: gpInsertUpdate_Object_Composition (Integer,Integer,TVarChar,Integer,TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Composition (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Composition (Integer, Integer, TVarChar, TVarChar, Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Composition(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Состав товара> 
 INOUT ioCode                     Integer   ,    -- Код объекта <Состав товара>
    IN inName                     TVarChar  ,    -- Название объекта <Состав товара>
    IN inName_UKR                 TVarChar,      -- Название объекта <Название > укр
    IN inCompositionGroupId       Integer   ,    -- ключ объекта <Группа для состава товара> 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Composition());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Composition_seq'); 
   END IF; 

   -- !!!ВРЕМЕННО!!! - пытаемся найти Id  для Загрузки из Sybase - !!!но если в Sybase нет уникальности - НАДО УБРАТЬ!!!
   IF COALESCE (ioId, 0) = 0  AND COALESCE (ioCode, 0) = 0 
   THEN ioId := (SELECT Id FROM Object WHERE Valuedata = inName AND DescId = zc_Object_Composition());
        -- пытаемся найти код
        ioCode := (SELECT ObjectCode FROM Object WHERE Id = ioId);
   END IF;
   -- !!!ВРЕМЕННО!!! - для загрузки из Sybase т.к. там код = 0 
  
   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN ioCode := NEXTVAL ('Object_Composition_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 
   
   -- проверка - свойство должно быть установлено
   -- IF COALESCE (inCompositionGroupId, 0) = 0 THEN
   --    RAISE EXCEPTION 'Ошибка.Не установлено значение <Группа для состава товара>.';
   -- END IF;

   -- проверка уникальности свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Composition(), ioCode);
   -- проверка уникальности свойства <Название> для !!!одной!! <Группа для состава товара>
   IF TRIM (inName) <> '' AND COALESCE (inCompositionGroupId, 0) <> 0 
   THEN
       IF EXISTS (SELECT 1
                  FROM Object
                       LEFT JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                            ON ObjectLink_Composition_CompositionGroup.ObjectId = Object.Id
                                           AND ObjectLink_Composition_CompositionGroup.DescId   = zc_ObjectLink_Composition_CompositionGroup()
                  WHERE Object.Descid           = zc_Object_Composition()
                    AND TRIM (Object.ValueData) = TRIM (inName)
                    AND Object.Id               <> COALESCE (ioId, 0)
                    AND COALESCE (ObjectLink_Composition_CompositionGroup.ChildObjectId, 0) = COALESCE (inCompositionGroupId, 0)
                 )
       THEN
           RAISE EXCEPTION 'Ошибка. Состав товара <%> в группе <%> уже существует.', TRIM (inName), lfGet_Object_ValueData (inCompositionGroupId);
       END IF;
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Composition(), ioCode, inName);

   -- сохранили связь с <Группа для состава товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Composition_CompositionGroup(), ioId, inCompositionGroupId);

   -- сохранили свойство
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Composition_UKR(), ioId, inName_UKR);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
25.08.20          * inName_UKR
13.05.17                                                           *
06.03.17                                                           *
20.02.17                                                           *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Composition()
