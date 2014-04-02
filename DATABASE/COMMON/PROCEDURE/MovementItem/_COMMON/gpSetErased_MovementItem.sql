-- Function: gpSetErased_MovementItem (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_MovementItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_???());
  vbUserId:= lpGetUserBySession (inSession);

  -- устанавливаем новое значение
  outIsErased := TRUE;

  -- Обязательно меняем 
  UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- проверка - связанные документы Изменять нельзя
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= 'изменение');

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete() AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- пересчитали Итоговые суммы по накладной
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

  -- !!! НЕ ПОНЯТНО - ПОЧЕМУ НАДО ВОЗВРАЩАТЬ НАОБОРОТ!!!
  -- outIsErased := FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.14                                        * add zc_Enum_Role_Admin
 06.10.13                                        * add vbStatusId
 06.10.13                                        * add lfCheck_Movement_Parent
 06.10.13                                        * add lpInsertUpdate_MovementFloat_TotalSumm
 06.10.13                                        * add outIsErased
 01.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_MovementItem (inMovementItemId:= 55, inSession:= '2')
