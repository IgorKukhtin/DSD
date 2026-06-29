-- Function: gpUpdate_Movement_StaffList_Personal()

DROP FUNCTION IF EXISTS gpUpdate_Movement_StaffList_Personal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_StaffList_Personal(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inPersonalId             Integer   , -- Менеджер по персоналу
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StaffList());

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), inMovementId, inPersonalId); 

     -- сохранили свойство <Дата корректировки>
     -- PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inMovementId, CURRENT_TIMESTAMP);
     -- сохранили связь с <Пользователь>
     -- PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inMovementId, vbUserId); 

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.06.26                                        *
*/

-- тест
--