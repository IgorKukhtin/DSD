-- Function: gpComplete_Movement_SendPartionDate()

DROP FUNCTION IF EXISTS gpComplete_Movement_SendPartionDate  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SendPartionDate(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
    vbUserId:= inSession;
    
  -- пересчитали Итоговые суммы
  --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
  
  -- собственно проводки
  PERFORM lpComplete_Movement_SendPartionDate(inMovementId, -- ключ Документа
                                        vbUserId);    -- Пользователь 
                         
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.08.18         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_SendPartionDate (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')
