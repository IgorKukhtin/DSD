-- Function: gpUpdate_UserCash_InternshipCompleted()

DROP FUNCTION IF EXISTS gpUpdate_UserCash_InternshipCompleted (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_UserCash_InternshipCompleted(
    IN inisInternshipConfirmation  Boolean   ,    -- 	Подтверждение стажировки
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


    -- если нашли
    IF inisInternshipConfirmation = TRUE
    THEN

        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_User_InternshipConfirmation(), vbUserId, 2);
    ELSE
    
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_User_InternshipConfirmation(), vbUserId, 1);
    END IF;

    PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_User_InternshipConfirmation(), vbUserId, CURRENT_TIMESTAMP);

    -- Ведение протокола
    PERFORM lpInsert_ObjectProtocol (vbUserId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.01.22                                                       *
*/