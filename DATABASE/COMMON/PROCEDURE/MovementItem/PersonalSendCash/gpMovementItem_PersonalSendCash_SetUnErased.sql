-- Function: gpMovementItem_PersonalSendCash_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PersonalSendCash_SetUnErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PersonalSendCash_SetUnErased(
    IN inMovementId          Integer              , -- ключ Документа
    IN inPersonalId          Integer              , -- Сотрудник
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_PersonalSendCash());

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- проверка - связанные документы Изменять нельзя
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

  -- устанавливаем новое значение
  outIsErased := FALSE;

  -- Обязательно меняем 
  UPDATE MovementItem SET isErased = FALSE
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.ObjectId = inPersonalId
    AND MovementItem.DescId = zc_MI_Master();

  -- сохранили протокол
  PERFORM lpInsert_MovementItemProtocol (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId, inIsInsert:= FALSE, inIsErased:= FALSE)
  FROM MovementItem
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.ObjectId = inPersonalId
    AND MovementItem.DescId = zc_MI_Master();

  -- пересчитали Итоговые суммы по накладной
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

  -- !!! НЕ ПОНЯТНО - ПОЧЕМУ НАДО ВОЗВРАЩАТЬ НАОБОРОТ!!!
  -- outIsErased := TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_PersonalSendCash_SetUnErased (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.13                                        * add lpInsertUpdate_MovementFloat_TotalSumm
 07.10.13                                        * add vbStatusId
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM gpMovementItem_PersonalSendCash_SetUnErased (inMovementId:= 55, inPersonalId = 1, inSession:= '2')
