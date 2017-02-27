-- Function: gpInsertUpdate_Object_JuridicalGroup (Integer,Integer,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalGroup (Integer,Integer,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalGroup(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Группы юридических лиц> 
    IN inCode                     Integer   ,    -- Код объекта <Группы юридических лиц>
    IN inName                     TVarChar  ,    -- Название объекта <Группы юридических лиц>
    IN inParentId                 Integer   ,    -- ключ объекта <Группы юридических лиц> 
    IN inSession                  TVarChar       -- сессия пользователя  
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalGroup());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_JuridicalGroup()); 
   
   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_JuridicalGroup(), inName);

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
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalGroup(), vbCode_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_JuridicalGroup(), vbCode_max, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_JuridicalGroup_Parent(), ioId, inParentId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
27.02.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_JuridicalGroup()
