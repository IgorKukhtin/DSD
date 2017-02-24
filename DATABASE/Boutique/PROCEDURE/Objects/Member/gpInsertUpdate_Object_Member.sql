-- Function: gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member(
 INOUT ioId           Integer,       -- Ключ объекта <Физические лица>    
    IN inCode         Integer,       -- Код объекта <Физические лица>     
    IN inName         TVarChar,      -- Название объекта ФИО <Физические лица>
    IN inINN          TVarChar,      -- ИНН
    IN inComment      TVarChar,      -- Примечание
    IN inEMail        TVarChar,      -- E-Mail
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCode_max Integer;

BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_Member()); 
   
   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName); 
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), vbCode_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Member(), vbCode_max, inName);

   -- сохранили ИНН
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_INN(), ioId, inINN);
   -- сохранили Примечание  
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_Comment(), ioId, inComment);
   -- сохранили E-Mail
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_EMail(), ioId, inEMail);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
20.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Member()
