-- Function: gpUpdate_Movement_Check__NotMCS()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check__NotMCS(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check__NotMCS(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inisNotMCS            Boolean   , -- Не для НТЗ
   OUT outisNotMCS           Boolean   , -- Не для НТЗ
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  --Меняем признак Не для НТЗ
  Perform lpInsertUpdate_MovementBoolean(zc_MovementBoolean_NotMCS(), inMovementId, NOT inisNotMCS);
  
  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

  outisNotMCS := NOT inisNotMCS;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 23.01.20                                                                    *
*/

-- тест