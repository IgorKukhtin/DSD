-- Function: gpGet_Movement_WeighingPartner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_WeighingPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_WeighingPartner(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Parent TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDesc TFloat, InvNumberTransport TFloat, InvNumberOrder TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar
             , UserId Integer, UserName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_WeighingPartner());

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_WeighingPartner_seq') AS TVarChar) AS InvNumber
             , CAST (CURRENT_DATE as TDateTime) AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName
             
             , CAST ('' as TVarChar)            AS Parent
             
             , CAST (CURRENT_DATE as TDateTime) AS StartWeighing
             , CAST (CURRENT_DATE as TDateTime) AS EndWeighing
            
             , CAST (0 as TFloat)    AS MovementDesc
             , CAST (0 as TFloat)    AS InvNumberTransport
             , CAST ('' as TVarChar) AS InvNumberOrder

             , 0                     AS FromId
             , CAST ('' as TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' as TVarChar) AS ToName

             , 0                     AS PaidKindId
             , CAST ('' as TVarChar) AS PaidKindName

             , 0                     AS RouteSortingId
             , CAST ('' as TVarChar) AS RouteSortingName

             , 0                     AS UserId
             , CAST ('' as TVarChar) AS UserName
             
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , Movement_Parent.InvNumber         AS Parent
              
             , MovementDate_StartWeighing.ValueData  AS StartWeighing  
             , MovementDate_EndWeighing.ValueData    AS EndWeighing

             , MovementFloat_MovementDesc.ValueData       AS MovementDesc
             , MovementFloat_InvNumberTransport.ValueData AS InvNumberTransport

             , Object_From.Id                  AS FromId
             , Object_From.ValueData           AS FromName
             , Object_To.Id                    AS ToId
             , Object_To.ValueData             AS ToName

             , Object_PaidKind.Id              AS PaidKindId
             , Object_PaidKind.ValueData       AS PaidKindName
             
             , Object_RouteSorting.Id          AS RouteSortingId
             , Object_RouteSorting.ValueData   AS RouteSortingName
             , Object_User.Id                  AS UserId
             , Object_User.ValueData           AS UserName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

            LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                   ON MovementDate_StartWeighing.MovementId =  Movement.Id
                                  AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
            LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                   ON MovementDate_EndWeighing.MovementId =  Movement.Id
                                  AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing()
                                  
            LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                    ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                   AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
            LEFT JOIN MovementFloat AS MovementFloat_InvNumberTransport
                                    ON MovementFloat_InvNumberTransport.MovementId =  Movement.Id
                                   AND MovementFloat_InvNumberTransport.DescId = zc_MovementFloat_InvNumberTransport()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_WeighingPartner();
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_WeighingPartner (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.03.14         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_WeighingPartner (inMovementId := 0, inSession:= zfCalc_UserAdmin())
