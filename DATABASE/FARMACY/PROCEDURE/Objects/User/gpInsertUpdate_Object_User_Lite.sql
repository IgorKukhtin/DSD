-- Function: gpInsertUpdate_Object_User_Lite()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_User_Lite (Integer, TVarChar, TVarChar, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User_Lite(
 INOUT ioId                 Integer   ,    -- ключ объекта <Пользователь> 
    IN inUserName           TVarChar  ,    -- главное Название пользователя объекта <Пользователь> 
    IN inPassword           TVarChar  ,    -- пароль пользователя 
    IN inMemberId           Integer   ,    -- физ. лицо
    IN inisNewUser          Boolean   ,    -- Новый сотрудник
    IN inSession            TVarChar       -- сессия пользователя
)
  RETURNS Integer 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCode_calc Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession::Integer;

   -- проверка уникальности для свойства <Наименование Пользователя>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_User(), inUserName);

   -- пытаемся найти код
   IF ioId <> 0  THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc:= lfGet_ObjectCode (vbCode_calc, zc_Object_Member());

   IF COALESCE (ioId, 0) = 0
   THEN
     inisNewUser := TRUE;
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), vbCode_calc, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_User_Member(), ioId, inMemberId);

   -- свойство <Новый сотрудник>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_User_NewUser(), ioId, inisNewUser);

   -- Ведение протокола
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.22                                                       *
*/


-- тест
-- SELECT * FROM gpInsertUpdate_Object_User_Lite ('2')