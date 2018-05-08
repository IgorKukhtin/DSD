-- Function: gpSetErased_Movement_ReturnIn (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ReturnIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


     -- Вот они Роли + Пользователи: с проверкой прав = НЕЛЬЗЯ
     IF EXISTS (SELECT 1
                FROM Object_RoleAccessKey_View
                WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_Check()
                  AND Object_RoleAccessKey_View.UserId      = vbUserId
               )
     THEN
         -- проверка прав пользователя на вызов процедуры - Ругнемся, т.к. права "забрали"
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ReturnIn());
     END IF;


    -- Проверка - Дата Документа
    PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inUserId:= vbUserId);

    -- тек.статус документа
    vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);
    
    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- пересчитали "итоговые" суммы по элементам партии продажи / возврата
    PERFORM lpUpdate_MI_Partion_Total_byMovement (inMovementId);

    -- Если был статус Проведен
    IF vbStatusId = zc_Enum_Status_Complete() 
    THEN 
         -- меняются ИТОГОВЫЕ суммы по покупателю
         PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= FALSE, inUserId:= vbUserId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 23.07.17         *
 14.05.17         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_ReturnIn (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
