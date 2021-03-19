-- Function: gpSelect_Movement_Wages()

DROP FUNCTION IF EXISTS gpSelect_Movement_Wages (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Wages(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar

             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , DateCalculation TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitId Integer;
BEGIN

     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        -- Результат
        SELECT
            Movement.Id                              AS ID
          , Movement.InvNumber                       AS InvNumber
          , Movement.OperDate                        AS OperDate
          , Object_Status.ObjectCode                 AS StatusCode
          , Object_Status.ValueData                  AS StatusName

          , Object_Insert.ValueData                  AS InsertName
          , MovementDate_Insert.ValueData            AS InsertDate
          , Object_Update.ValueData                  AS UpdateName
          , MovementDate_Update.ValueData            AS UpdateDate
          , MovementDate_Calculation.ValueData       AS DateCalculation
        FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId


            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementDate AS MovementDate_Calculation
                                   ON MovementDate_Calculation.MovementId = Movement.Id
                                  AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

        WHERE Movement.OperDate BETWEEN date_trunc('month', inStartDate) AND date_trunc('month', inEndDate)
          AND Movement.DescId = zc_Movement_Wages();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Wages (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.08.19                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Wages (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin());-- SELECT * FROM gpSelect_Movement_Wages (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin());