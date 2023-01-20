-- Function: gpComplete_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS gpComplete_Movement_ProductionUnion  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProductionUnion(
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
 

     -- создаются временные таблицы - для формирование данных по проводкам
     PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();

     -- проводки
     PERFORM lpComplete_Movement_ProductionUnion (inMovementId -- Документ
                                                , vbUserId     -- Пользователь  
                                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
 */