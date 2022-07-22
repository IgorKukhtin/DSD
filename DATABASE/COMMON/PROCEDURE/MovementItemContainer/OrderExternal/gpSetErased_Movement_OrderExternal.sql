-- Function: gpSetErased_Movement_OrderExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderExternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSetErased_Movement_OrderExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_OrderExternal(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outPrinted          Boolean               ,
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                     JOIN Object ON Object.Id = MLO.ObjectId AND Object.DescId = zc_Object_Unit()
                WHERE MLO.MovementId = inMovementId 
                  AND MLO.DescId     = zc_MovementLinkObject_From()
               )
     THEN
         -- так для zc_Object_Unit
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_OrderExternalUnit());
     ELSE
         -- для остальных 
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_OrderExternal());
     END IF;


     -- сохранили свойство <Был сформирован резерв> - нет
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Remains(), inMovementId, FALSE);

     -- Обнулили ВЕСЬ Резерв
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, zc_MI_Child(), MovementItem.ObjectId, inMovementId, 0, MovementItem.ParentId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE 
      ;

     --
     outPrinted := gpUpdate_Movement_OrderExternal_Print(inId := inMovementId , inNewPrinted := FALSE,  inSession := inSession);

     -- проверка - если <Master> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- проверка - если есть <Child> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- !!!обнуляются свойства в элементах документа!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId;

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.09.21         *
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_OrderExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())