-- Function: gpCheckRight_Movement_Promo()

DROP FUNCTION IF EXISTS gpCheckRight_Movement_Promo (TVarChar);

CREATE OR REPLACE FUNCTION gpCheckRight_Movement_Promo(
    IN inSession          TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.01.19         *
*/