-- Function: gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member(
 INOUT ioId           Integer,       -- Ключ объекта <Физические лица>    
 INOUT ioCode         Integer,       -- Код объекта <Физические лица>     
    IN inName         TVarChar,      -- Название объекта ФИО <Физические лица>
    IN inINN          TVarChar,      -- ИНН
    IN inComment      TVarChar,      -- Примечание
    IN inEMail        TVarChar,      -- E-Mail
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Member());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Member_seq'); 
   END IF; 

   -- !!!ВРЕМЕННО!!! - пытаемся найти Id  для Загрузки из Sybase - !!!но если в Sybase нет уникальности - НАДО УБРАТЬ!!!
   IF COALESCE (ioId, 0) = 0  AND COALESCE (ioCode, 0) = 0 
   THEN ioId := (SELECT Id FROM Object WHERE Valuedata = inName AND DescId = zc_Object_Member());
        -- пытаемся найти код
        ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF;
   -- !!!ВРЕМЕННО!!! - для загрузки из Sybase т.к. там код = 0 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) = 0
   THEN 
       ioCode := NEXTVAL ('Object_Member_seq'); 
   ELSEIF ioCode = 0
   THEN 
       ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 
   
   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Member(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Member(), ioCode, inName);

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
13.05.17                                                          *
08.05.17                                                          *
06.03.17                                                          *
20.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Member()
