-- Function: gpUpdate_Movement_Income_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_ChangePercent (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_ChangePercent(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inChangePercent         TFloat    , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());


     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;

     -- сохранили свойство <% нац. скидки>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), inMovementId, inChangePercent);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.19         *
*/

-- тест
-- 