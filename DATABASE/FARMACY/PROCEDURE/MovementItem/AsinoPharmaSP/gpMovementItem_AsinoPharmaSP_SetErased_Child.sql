-- Function: gpMovementItem_AsinoPharmaSP_SetErased_Child (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_AsinoPharmaSP_SetErased_Child (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_AsinoPharmaSP_SetErased_Child(
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
    vbUserId := inSession;

  -- устанавливаем новое значение
  outIsErased := TRUE;

  -- Обязательно меняем
  UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete() AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;
  
  -- пересчитали Итоговые суммы по накладной
  --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.02.23                                                       *
*/

-- тест
-- select * from gpMovementItem_AsinoPharmaSP_SetErased_Child(inMovementItemId := 579599661 ,  inSession := '3');