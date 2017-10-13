-- Function: gpSelect_Movement_AnotherRetail()

DROP FUNCTION IF EXISTS gpSelect_Movement_AnotherRetail (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_AnotherRetail(
    IN inContainerId      Integer,    --
    IN inSession          TVarChar    -- сессия пользователя
    )

RETURNS TABLE (MovementId   Integer
             , OperDate     TDateTime
             , Invnumber    TVarChar
             , ItemName     TVarChar
             , ToName       TVarChar
             , FromName     TVarChar
             , StatusCode   Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    
   SELECT Movement.Id                AS MovementId
        , Movement.OperDate          AS OperDate
        , Movement.Invnumber         AS Invnumber
        , MovementDesc.ItemName      AS ItemName
        , Object_To.ValueData        AS ToName
        , Object_From.ValueData      AS FromName
        , Object_Status.ObjectCode   AS StatusCode
    FROM MovementItemContainer AS MIContainer
         LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
         LEFT JOIN MovementDesc ON MovementDesc.Id = MIContainer.MovementDescId
         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
         
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()                                      
         LEFT JOIN Object AS Object_From ON Object_From.Id = COALESCE (MovementLinkObject_From.ObjectId, MovementLinkObject_Unit.ObjectId)
         
    WHERE MIContainer.ContainerId = inContainerId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.10.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_AnotherRetail (inContainerId:= 7948847 , inSession := '3')





