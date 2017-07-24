-- Function: gpSetErased_Movement_GoodsAccount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_GoodsAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_GoodsAccount(
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
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_GoodsAccount());
    vbUserId:= lpGetUserBySession (inSession);

    -- тек.статус документа
    vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);
    
    -- убираем ссылки на этот док в продажах
    /*PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), MLM_Child.MovementId, Null)
    FROM MovementLinkMovement AS MLM_Child
    WHERE MLM_Child.descId = zc_MovementLinkMovement_Child()
      AND MLM_Child.MovementChildId = inMovementId;*/
    
    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- пересчитали "итоговые" суммы по элементам партии продажи / возврата
    PERFORM lpUpdate_MI_Partion_Total_byMovement(inMovementId);

    -- Если был статус Проведен нужно пересчитать расчетные суммы по покупателю
    IF vbStatusId = zc_Enum_Status_Complete() 
    THEN 
         -- сохраняем расчетные суммы по покупателю
         PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= FALSE, inUserId:= vbUserId);
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 23.07.17         *
 18.05.17         *
*/
