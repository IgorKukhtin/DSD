-- Function: gpInsertUpdate_Object_JuridicalGroup (Integer,Integer,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalGroup (Integer,Integer,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalGroup(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Группы юридических лиц> 
 INOUT ioCode                     Integer   ,    -- Код объекта <Группы юридических лиц>
    IN inName                     TVarChar  ,    -- Название объекта <Группы юридических лиц>
    IN inParentId                 Integer   ,    -- ключ объекта <Группы юридических лиц> 
    IN inSession                  TVarChar       -- сессия пользователя  
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_JuridicalGroup_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_JuridicalGroup_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 
 
   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_JuridicalGroup(), inName);

   -- проверка уникальность <Наименование> для !!!одной!! <Группы юридических лиц>
   IF TRIM (inName) <> '' AND COALESCE (inParentId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_JuridicalGroup_Parent
                                       ON ObjectLink_JuridicalGroup_Parent.ObjectId = Object.Id
                                      AND ObjectLink_JuridicalGroup_Parent.DescId = zc_ObjectLink_JuridicalGroup_Parent()
                                      AND ObjectLink_JuridicalGroup_Parent.ChildObjectId = inParentId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION 'Ошибка. Группы юридических лиц <%> уже установлена у <%>.', TRIM (inName), lfGet_Object_ValueData (inParentId);
       END IF;
   END IF;


   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalGroup(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalGroup(), ioCode, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalGroup_Parent(), ioId, inParentId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
13.05.17                                                           *
06.03.17                                                           *
27.02.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_JuridicalGroup()
