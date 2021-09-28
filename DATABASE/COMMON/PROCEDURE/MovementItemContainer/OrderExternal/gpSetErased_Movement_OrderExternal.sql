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
  DECLARE vbDescId_From Integer;
BEGIN
     --из шапки документа получаем вид параметра <от кого>
     vbDescId_From := (SELECT Object.DescId
                       FROM MovementLinkObject AS MLO
                           LEFT JOIN Object ON Object.Id = MLO.ObjectId
                       WHERE MLO.MovementId = inMovementId 
                         AND MLO.DescId = zc_MovementLinkObject_From());

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight(inSession, CASE WHEN vbDescId_From = zc_Object_Unit() THEN zc_Enum_Process_SetErased_OrderExternalUnit() ELSE zc_Enum_Process_SetErased_OrderExternal() END);

     outPrinted := gpUpdate_Movement_OrderExternal_Print(inId := inMovementId , inNewPrinted := False,  inSession := inSession);

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