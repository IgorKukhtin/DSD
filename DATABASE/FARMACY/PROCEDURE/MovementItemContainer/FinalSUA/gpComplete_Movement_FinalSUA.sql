-- Function: gpComplete_Movement_FinalSUA()

DROP FUNCTION IF EXISTS gpComplete_Movement_FinalSUA  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_FinalSUA(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Complete_FinalSUA());
  vbUserId := inSession;
    
  -- пересчитали Итоговые суммы
  PERFORM lpInsertUpdate_FinalSUA_TotalSumm (inMovementId);
  
  -- собственно проводки
  PERFORM lpComplete_Movement_FinalSUA(inMovementId, -- ключ Документа
                                                    vbUserId);    -- Пользователь 
                         
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.21                                                       * 
 */

-- тест
-- SELECT * FROM gpComplete_Movement_FinalSUA (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')