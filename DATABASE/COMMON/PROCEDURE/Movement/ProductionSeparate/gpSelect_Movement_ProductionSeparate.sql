-- Function: gpSelect_Movement_ProductionSeparate()

-- DROP FUNCTION gpSelect_Movement_ProductionSeparate (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparate(
    IN inStartDate   TDateTime,
    IN inEndDate     TDateTime,
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
               , TotalCount TFloat, PartionGoods TVarChar
               , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Movement_ProductionSeparate());

   RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )

     SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
         , Object_Status.ObjectCode             AS StatusCode
         , Object_Status.ValueData              AS StatusName

         , MovementFloat_TotalCount.ValueData   AS TotalCount
         , MovementString_PartionGoods.ValueData AS PartionGoods

         , Object_From.Id                       AS FromId
         , Object_From.ValueData                AS FromName
         , Object_To.Id                         AS ToId
         , Object_To.ValueData                  AS ToName

     FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_ProductionSeparate() AND Movement.StatusId = tmpStatus.StatusId
--                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement

          LEFT JOIN Movement ON Movement.id = tmpMovement.id

          LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

          LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                  ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                 AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

          LEFT JOIN MovementString AS MovementString_PartionGoods
                                   ON MovementString_PartionGoods.MovementId =  Movement.Id
                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
          ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.05.14                                                        *
 16.07.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProductionSeparate (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
