-- Function: gpInsertUpdate_User_PasswordEHels()

DROP FUNCTION IF EXISTS gpInsertUpdate_User_PasswordEHels (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_User_PasswordEHels(
    IN inId               Integer   ,    -- ключ объекта <Пользователь> 
    IN inPasswordEHels    TVarChar  ,    -- Пароль Е-Хелс
    IN inSession          TVarChar       -- сессия пользователя
)
  RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
     8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
   THEN
     RAISE EXCEPTION 'У вас нет прав выполнение операции.';
   END IF;

   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION 'Запись не сохранена.';
   END IF;

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Helsi_PasswordEHels(), inId, inPasswordEHels);

   -- Ведение протокола
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.04.19                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_User_PasswordEHels ('3')

