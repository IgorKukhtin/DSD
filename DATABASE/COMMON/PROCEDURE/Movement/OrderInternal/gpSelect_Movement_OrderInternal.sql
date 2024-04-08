-- Function: gpSelect_Movement_OrderInternal()

-- DROP FUNCTION gpSelect_Movement_OrderInternal (TDateTime, TDateTime, TVarChar);

-- DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal (TDateTime, TDateTime, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal (TDateTime, TDateTime, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal (TDateTime, TDateTime, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternal(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inisRemains         Boolean ,
    IN inFromId            Integer ,   -- от кого
    IN inToId              Integer ,   -- кому
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime
             , OperDateStart TDateTime, OperDateEnd TDateTime
             , TotalCount TFloat, TotalCountKg TFloat, TotalCountSh TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , DayCount TFloat
             , Comment TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

     vbUserId:= lpGetUserBySession (inSession);
     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);
     
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
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName
           
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , MovementDate_OperDateStart.ValueData   AS OperDateStart
           , MovementDate_OperDateEnd.ValueData     AS OperDateEnd           
           
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalCountKg.ValueData   AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData   AS TotalCountSh
           , Object_From.Id                         AS FromId
           , Object_From.ValueData                  AS FromName
           , Object_To.Id                           AS ToId
           , Object_To.ValueData                    AS ToName
           , (1 + EXTRACT (DAY FROM (COALESCE (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData),   zfConvert_DateTimeWithOutTZ (Movement.OperDate) - (INTERVAL '1 DAY'))
                                   - COALESCE (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData), zfConvert_DateTimeWithOutTZ (Movement.OperDate) - (INTERVAL '7 DAY')))
                          )) :: TFloat AS DayCount
           , MovementString_Comment.ValueData       AS Comment

       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_OrderInternal() AND Movement.StatusId = tmpStatus.StatusId
--                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
  
            LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                      ON MovementBoolean_Remains.MovementId =  Movement.Id
                                     AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()
                                               
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
             
            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            
         WHERE (Object_From.Id = inFromId OR inFromId = 0 OR (inFromId <> inToId AND Object_From.Id <> Object_To.Id AND inFromId <> 0 AND inToId <> 0))
           AND (Object_To.Id   = inToId   OR inToId   = 0)
           AND (COALESCE (MovementBoolean_Remains.ValueData, FALSE) = inIsRemains)
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.10.16         * add inJuridicalBasisId
 02.03.15         * add OperDatePartner, OperDateStart, OperDateEnd, DayCount
 06.06.14                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternal (inStartDate:= '30.10.2017', inEndDate:= '30.10.2017', inIsErased:= FALSE, inisRemains:= FALSE, inFromId:= 0, inToId:= 0, inJuridicalBasisId:= 0, inSession:= '2')
