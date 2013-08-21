-- Function: gpSelect_Movement_Transport()

-- DROP FUNCTION gpSelect_Movement_Transport (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Transport(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , WorkTime TDateTime
             , MorningOdometre TFloat, EveningOdometre TFloat
             , Distance TFloat, Cold TFloat, Norm TFloat
             , CarId Integer, CarName TVarChar
             , MemberId Integer, MemberName TVarChar
             , RouteId Integer, RouteName TVarChar
              )
AS
$BODY$
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Transport());

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           
           , MovementDate_WorkTime.ValueData AS WorkTime           
          
           , MovementFloat_MorningOdometre.ValueData AS MorningOdometre
           , MovementFloat_EveningOdometre.ValueData AS EveningOdometre
           , MovementFloat_Distance.ValueData        AS Distance
           , MovementFloat_Cold.ValueData            AS Cold
           , MovementFloat_Norm.ValueData            AS Norm

           , Object_Car.Id                     AS CarId
           , Object_Car.ValueData              AS CarName
           
           , Object_Member.Id             AS MemberId
           , Object_Member.ValueData      AS MemberName

           , Object_Route.Id               AS RouteId
           , Object_Route.ValueData        AS RouteName
   
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_WorkTime
                                   ON MovementDate_WorkTime.MovementId = Movement.Id
                                  AND MovementDate_WorkTime.DescId = zc_MovementDate_WorkTime()

            LEFT JOIN MovementFloat AS MovementFloat_MorningOdometre
                                    ON MovementFloat_MorningOdometre.MovementId =  Movement.Id
                                   AND MovementFloat_MorningOdometre.DescId = zc_MovementFloat_MorningOdometre()
            
            LEFT JOIN MovementFloat AS MovementFloat_EveningOdometre
                                    ON MovementFloat_EveningOdometre.MovementId =  Movement.Id
                                   AND MovementFloat_EveningOdometre.DescId = zc_MovementFloat_EveningOdometre()

            LEFT JOIN MovementFloat AS MovementFloat_Distance
                                    ON MovementFloat_Distance.MovementId =  Movement.Id
                                   AND MovementFloat_Distance.DescId = zc_MovementFloat_Distance()

            LEFT JOIN MovementFloat AS MovementFloat_Cold
                                    ON MovementFloat_Cold.MovementId =  Movement.Id
                                   AND MovementFloat_Cold.DescId = zc_MovementFloat_Cold()

            LEFT JOIN MovementFloat AS MovementFloat_Norm
                                    ON MovementFloat_Norm.MovementId =  Movement.Id
                                   AND MovementFloat_Norm.DescId = zc_MovementFloat_Norm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId
 
       WHERE Movement.DescId = zc_Movement_Transport()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Transport (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 20.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Transport (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
