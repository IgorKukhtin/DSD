-- Function: lpUnComplete_Movement_OrderExternal (Integer, Integer)

DROP FUNCTION IF EXISTS lpUnComplete_Movement_OrderExternal (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUnComplete_Movement_OrderExternal(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outPrinted          Boolean               ,
    IN inUserId            Integer     -- пользователь

)
RETURNS Boolean
AS
$BODY$
BEGIN
     --
     outPrinted := gpUpdate_Movement_OrderExternal_Print (inId := inMovementId, inNewPrinted := FALSE, inSession := lfGet_User_Session (inUserId));

     -- сохранили свойство <Был сформирован резерв> - нет
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Remains(), inMovementId, FALSE);

     -- Обнулили ВЕСЬ Резерв
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, zc_MI_Child(), MovementItem.ObjectId, inMovementId, 0, MovementItem.ParentId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE 
      ;

     -- проверка - если <Master> Удален, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

     -- !!!обнуляются свойства в элементах документа!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId;

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.04.17                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement_OrderExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())