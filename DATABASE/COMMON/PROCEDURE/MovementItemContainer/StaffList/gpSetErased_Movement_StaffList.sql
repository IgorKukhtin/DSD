-- Function: gpSetErased_Movement_StaffList (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_StaffList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_StaffList(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_StaffList());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


      -- сохранили свойство <Дата корректировки>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inMovementId, CURRENT_TIMESTAMP);
      -- сохранили связь с <Пользователь>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inMovementId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.08.25         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_StaffList (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
