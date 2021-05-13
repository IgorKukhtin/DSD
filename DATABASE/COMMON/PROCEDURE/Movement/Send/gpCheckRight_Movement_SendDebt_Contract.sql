-- Function: gpCheckRight_Movement_SendDebt_Contract()

DROP FUNCTION IF EXISTS gpCheckRight_Movement_SendDebt_Contract (TVarChar);

CREATE OR REPLACE FUNCTION gpCheckRight_Movement_SendDebt_Contract(
    IN inSession          TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendDebt_Contract());

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.21         *
*/