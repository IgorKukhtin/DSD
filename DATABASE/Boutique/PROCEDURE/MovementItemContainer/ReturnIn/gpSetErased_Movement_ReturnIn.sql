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
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ReturnIn());
    vbUserId:= lpGetUserBySession (inSession);


    -- тек.статус документа
    vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);
    
     -- Проверка - Дата - для User - Магазин
     IF lpCheckUnitByUser((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To()), inSession);
        AND (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) < DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '14 HOUR')
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение данных возможно только с <%>', zfConvert_DateToString (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '14 HOUR'));
     END IF;

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
