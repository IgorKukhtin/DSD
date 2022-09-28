-- Function: gpUpdate_User_InternshipCompleted()

DROP FUNCTION IF EXISTS gpUpdate_User_InternshipConfirmation (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_InternshipConfirmation(
    IN inUserId                    Integer   ,    -- 	Сотрудник
    IN inInternshipConfirmation    Integer   ,    -- 	Подтверждение стажировки
    IN inSession                   TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Изменение <Подтверждение стажировки>. Разрешено только системному администратору';
   END IF;     

     -- свойство <Подтверждение стажировки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_User_InternshipConfirmation(), inUserId, inInternshipConfirmation);

     -- свойство <Дата подтверждения стажировки>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_InternshipConfirmation(), inUserId, CURRENT_TIMESTAMP);

   -- Ведение протокола
   PERFORM lpInsert_ObjectProtocol (inUserId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.01.22                                                       *
*/