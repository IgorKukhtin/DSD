-- Function: gpComplete_Movement_CompetitorMarkups()

DROP FUNCTION IF EXISTS gpComplete_Movement_CompetitorMarkups  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_CompetitorMarkups(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_CompetitorMarkups());
                                             
    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.05.22                                                       *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_CompetitorMarkups (inMovementId:= 29207, inIsCurrentData:= TRUe, inSession:= '2')
