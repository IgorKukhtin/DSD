-- Function: gpComplete_Movement_PriceList()

DROP FUNCTION IF EXISTS gpComplete_Movement_PriceList  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PriceList(
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
    PERFORM lpComplete_Movement_PriceList (inMovementId   -- ключ Документа
                                         , vbUserId       -- Пользователь  
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.03.22         *
 */