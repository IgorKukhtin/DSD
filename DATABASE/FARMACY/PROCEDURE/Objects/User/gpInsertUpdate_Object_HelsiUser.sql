-- Function: gpInsertUpdate_Object_HelsiUser()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_HelsiUser (Integer, Integer, TVarChar, TVarChar, TBlob, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_HelsiUser(
    IN inId                        Integer   ,    -- ключ объекта <Пользователь> 
    IN inUnitId                    Integer   ,    -- Подразделением для которого зарегестрирован ключ
    IN inUserName                  TVarChar  ,    -- Имя пользователя на сайте Хелси
    IN inUserPassword              TVarChar  ,    -- Пароль пользователя на сайте Хелси
    IN inKey                       TBlob     ,    -- Файловый ключь
    IN inKeyPassword               TVarChar  ,    -- Пароль к файловому ключу
    IN inLikiDnepr_UnitId          Integer   ,    -- Подразделение в МИС «Каштан»
    IN inLikiDnepr_UserEmail       TVarChar  ,    -- E-mail провизора Е-Хелс для МИС «Каштан»
    IN inLikiDnepr_PasswordEHels   TVarChar  ,    -- Пароль Е-Хелс для регистрации через МИС «Каштан»
    IN inSession                   TVarChar       -- сессия пользователя
)
  RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

  /* IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
     8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
   THEN
     RAISE EXCEPTION 'У вас нет прав выполнение операции.';
   END IF;*/

   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION 'Запись не сохранена.';
   END IF;

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_User_Helsi_Unit(), inId, inUnitId);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Helsi_UserName(), inId, inUserName);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Helsi_UserPassword(), inId, inUserPassword);
   PERFORM lpInsertUpdate_ObjectBlob(zc_ObjectBlob_User_Helsi_Key(), inId, inKey);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Helsi_KeyPassword(), inId, inKeyPassword);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_User_LikiDnepr_Unit(), inId, inLikiDnepr_UnitId);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_LikiDnepr_UserEmail(), inId, inLikiDnepr_UserEmail);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_LikiDnepr_PasswordEHels(), inId, inLikiDnepr_PasswordEHels);

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
-- SELECT * FROM gpInsertUpdate_Object_HelsiUser ('3')
