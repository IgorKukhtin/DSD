-- Function: gpComplete_Movement_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpComplete_Movement_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_TechnicalRediscount(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_TechnicalRediscount());

    -- собственно проводки
    PERFORM lpComplete_Movement_TechnicalRediscount(inMovementId, -- ключ Документа
                                                    vbUserId);    -- Пользователь  

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
 */