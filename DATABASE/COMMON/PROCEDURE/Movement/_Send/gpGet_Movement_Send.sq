-- Function: gpGet_Movement_Income()

--DROP FUNCTION gpGet_Movement_Income();

CREATE OR REPLACE FUNCTION gpGet_Movement_Send(
    IN inId          Integer,       -- ключ объекта <Документ Перемещение>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCountTare TFloat, TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , CarId Integer, CarName TVarChar, PersonalDriverId Integer, PersonalDriverName TVarChar
             , RouteId Integer, RouteName TVarChar, RouteSortingId Integer, RouteSortingName TVarChar
             ) 
AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Movement_Send());
   IF COALESCE (inId, 0) = 0
   THEN
      RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST (0 as Integer)    AS InvNumber
           , CAST (' ' as TDateTime) AS OperDate
           , CAST (0 as Integer)    AS StatusCode
           , CAST (' ' as TVarChar)  AS StatusName

           , CAST (' ' as TDateTime) AS OperDatePartner

           , CAST (NULL AS Boolean) AS PriceWithVAT
           , CAST ('' as TVarChar)  AS VATPercent
           , CAST ('' as TVarChar)  AS ChangePercent

           , CAST ('' as TVarChar)  AS TotalCountKg
           , CAST ('' as TVarChar)  AS TotalCountSh
           , CAST ('' as TVarChar)  AS TotalCountTare
           , CAST ('' as TVarChar)  AS TotalCount
          
           , CAST ('' as TVarChar)  AS TotalSummMVAT
           , CAST ('' as TVarChar)  AS TotalSummPVAT
           , CAST ('' as TVarChar)  AS TotalSumm

           , CAST (0 as Integer)    AS FromId
           , CAST ('' as TVarChar)  AS FromName
           , CAST (0 as Integer)    AS ToId
           , CAST ('' as TVarChar)  AS ToName

           , CAST (0 as Integer)    AS CarId
           , CAST ('' as TVarChar)  AS CarName
           , CAST (0 as Integer)    AS PersonalDriverId
           , CAST ('' as TVarChar)  AS PersonalDriverName
           
           , CAST (0 as Integer)    AS RouteId
           , CAST ('' as TVarChar)  AS RouteName
           , CAST (0 as Integer)    AS RouteSortingId
           , CAST ('' as TVarChar)  AS RouteSortingName   
                   
       FROM Movement
       WHERE Movement.DescId = zc_Movement_Send();
   ELSE
     RETURN QUERY
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , MovementDate_OperDatePartner.ValueData      AS OperDatePartner

           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData          AS VATPercent
           , MovementFloat_ChangePercent.ValueData       AS ChangePercent

           , MovementFloat_TotalCountKg.ValueData        AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData        AS TotalCountSh
           , MovementFloat_TotalCountTare.ValueData      AS TotalCountTare
           , MovementFloat_TotalCount.ValueData          AS TotalCount
          
           , MovementFloat_TotalSummMVAT.ValueData       AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData       AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData           AS TotalSumm

           , Object_From.Id                    AS FromId
           , Object_From.ValueData             AS FromName
           , Object_To.Id                      AS ToId
           , Object_To.ValueData               AS ToName

           , Object_Car.Id                     AS CarId
           , Object_Car.ValueData              AS CarName
           , Object_PersonalDriver.Id          AS PersonalDriverId
           , Object_PersonalDriver.ValueData   AS PersonalDriverName
           
           , Object_Route.Id               AS RouteId
           , Object_Route.ValueData        AS RouteName
           , Object_RouteSorting.Id        AS RouteSortingId
           , Object_RouteSorting.ValueData AS RouteSortingName   
                   
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
                                   
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
           
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

        WHERE Movement.Id =  inMovementId
          AND Movement.DescId = zc_Movement_Send();
   END IF;      
   
   
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Send (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 12.07.13         *

*/

-- тест
-- SELECT * FROM gpGet_Movement_Send (inMovementId:= 1, inSession:= '2')
