-- Function: gpComplete_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnIn  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
 
    -- собственно проводки
    PERFORM lpComplete_Movement_ReturnIn(inMovementId, -- ключ Документа
                                         vbUserId);    -- Пользователь  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

    -- пересчитали "итоговые" суммы по элементам партии продажи
    PERFORM lpUpdate_MI_Partion_Total_byMovement(inMovementId);
    
    -- сохраняем расчетные суммы по покупателю
    PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= TRUE, inUserId:= vbUserId);
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 23.07.17         *
 14.05.17         *
 */