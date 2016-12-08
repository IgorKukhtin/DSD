-- Function: gpUpdate_Movement_Income_Pfizer()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_Pfizer (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_Pfizer(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());
    vbUserId := inSession;

    -- сохранили свойство <Зарегистрирована (да/нет)> - Загружена приходная накладная от дистрибьютора в медреестр Pfizer МДМ
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Registered(), inMovementId, TRUE);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.12.16                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Income_Pfizer (inMovementId:= 0, inSession:= '2')
