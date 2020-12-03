-- Function: gpComplete_Movement_DistributionPromo()

DROP FUNCTION IF EXISTS gpComplete_Movement_DistributionPromo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_DistributionPromo(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  
BEGIN
    vbUserId:= inSession;


    -- ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_DistributionPromo()
                               , inUserId     := vbUserId
                                );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.20                                                       *
 */