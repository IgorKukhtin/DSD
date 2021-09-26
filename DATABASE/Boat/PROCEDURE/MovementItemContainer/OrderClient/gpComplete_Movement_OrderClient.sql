-- Function: gpComplete_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderClient  (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_OrderClient  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderClient(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsChild_Recalc    Boolean               , -- Пересчет Комплектующих
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
    PERFORM lpComplete_Movement_OrderClient (inMovementId     -- ключ Документа
                                           , inIsChild_Recalc -- Пересчет Комплектующих
                                           , vbUserId         -- Пользователь  
                                            );

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
 */