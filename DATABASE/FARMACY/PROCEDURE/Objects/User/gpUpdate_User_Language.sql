-- Function: gpUpdate_User_Language()

DROP FUNCTION IF EXISTS gpUpdate_User_Language (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_User_Language(
    IN inLanguage        TVarChar   ,   -- Язык справочников кассы
    IN inSession         TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- сохранили <Объект>
    PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Language(), vbUserId, inLanguage);

    -- Ведение протокола
    PERFORM lpInsert_ObjectProtocol (vbUserId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.09.22                                                       *
*/