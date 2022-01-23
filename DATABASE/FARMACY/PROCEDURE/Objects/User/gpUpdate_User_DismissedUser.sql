-- Function: gpUpdate_User_DismissedUser()

DROP FUNCTION IF EXISTS gpUpdate_User_DismissedUser (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_DismissedUser(
    IN inUserId              Integer   ,    -- Ключ
    IN inisDismissedUser     Boolean   ,    -- Уволенный сотрудник
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- если нашли
    IF inUserId <> 0
    THEN

        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_User_DismissedUser(), inUserId, not inisDismissedUser);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.01.22                                                       *
*/
