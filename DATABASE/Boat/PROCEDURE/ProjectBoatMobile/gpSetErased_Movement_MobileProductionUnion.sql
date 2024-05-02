-- Function: gpSetErased_Movement_MobileProductionUnion (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_MobileProductionUnion (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_MobileProductionUnion(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outStatusCode       Integer               , 
   OUT outStatusName       TVarChar              ,
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Удаляем Документ
    PERFORM gpSetErased_Movement_ProductionUnion (inMovementId  := inMovementId
                                                , inSession     := inSession);
                                                
    SELECT Object_Status.ObjectCode            AS StatusCode
         , Object_Status.ValueData             AS StatusName
    INTO outStatusCode, outStatusName
    FROM Movement

         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
         
    WHERE Movement.Id = inMovementId;                                                

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.04.24                                                       *
*/