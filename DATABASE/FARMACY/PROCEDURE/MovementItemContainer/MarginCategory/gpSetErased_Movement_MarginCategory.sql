-- Function: gpSetErased_Movement_MarginCategory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_MarginCategory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_MarginCategory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession; --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MarginCategory());


     -- проверка 
     IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
          RAISE EXCEPTION 'Ошибка.Документ проведен, удаление запрещено!';
     END IF;
     
     -- проверка - если <Master> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- проверка - если есть <Child> Проведен, то <Ошибка>
     PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= 'удалить');

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.11.17         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_MarginCategory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
