-- Function: gpInsertUpdate_Object_Composition (Integer,Integer,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Composition (Integer,Integer,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Composition(
 INOUT ioId                       Integer   ,    -- ключ объекта <Состав товара> 
    IN inCode                     Integer   ,    -- Код объекта <Состав товара>
    IN inName                     TVarChar  ,    -- Название объекта <Состав товара>
    IN inCompositionGroupId       Integer   ,    -- ключ объекта <Группа для состава товара> 
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer
  AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Composition());
   --vbUserId := inSession;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Composition()); 
   
   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Composition(), inName);
   -- проверка уникальность <Наименование> для !!!одноq!! <Группа для состава товара>
   IF TRIM (inName) <> '' AND COALESCE (inCompositionGroupId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_Composition_CompositionGroup
                                       ON ObjectLink_Composition_CompositionGroup.ObjectId = Object.Id
                                      AND ObjectLink_Composition_CompositionGroup.DescId = zc_ObjectLink_Composition_CompositionGroup()
                                      AND ObjectLink_Composition_CompositionGroup.ChildObjectId = inCompositionGroupId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION 'Ошибка. Группа для состава товара <%> уже установлена у <%>.', TRIM (inName), lfGet_Object_ValueData (inCompositionGroupId);
       END IF;
   END IF;


   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Composition(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Composition(), vbCode_calc, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Composition_CompositionGroup(), ioId, inCompositionGroupId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
20.02.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Composition()
