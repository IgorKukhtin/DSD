-- Function: gpMovementItem_PersonalAccount_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PersonalAccount_SetErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PersonalAccount_SetErased(
    IN inMovementId          Integer              , -- ключ Документа
    IN inJuridicalId         Integer              , -- Юр.лицо
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
  DECLARE vbStatusId Integer;
BEGIN
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_MovementItem());

  -- определяем <Статус>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
  -- проверка - проведенные/удаленные документы Изменять нельзя
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <"%"> не возможно.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- проверка - связанные документы Изменять нельзя
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

  -- устанавливаем новое значение
  outIsErased := TRUE;

  -- Обязательно меняем 
  UPDATE MovementItem SET isErased = outIsErased
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.ObjectId = inJuridicalId
    AND MovementItem.DescId = zc_MI_Master();

  -- пересчитали Итоговые суммы по накладной
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

  -- !!! НЕ ПОНЯТНО - ПОЧЕМУ НАДО ВОЗВРАЩАТЬ НАОБОРОТ!!!
  -- outIsErased := FALSE;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_PersonalAccount_SetErased (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.12.13         *
*/

-- тест
-- SELECT * FROM gpMovementItem_PersonalAccount_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
