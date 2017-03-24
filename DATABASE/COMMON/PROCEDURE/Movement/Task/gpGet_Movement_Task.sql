-- Function: gpGet_Movement_Task()

DROP FUNCTION IF EXISTS gpGet_Movement_Task (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Task(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PersonalTradeId Integer, PersonalTradeName TVarChar
             , InsertId Integer, InsertName TVarChar
             , InsertDate TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Task());
     vbUserId:= lpGetUserBySession (inSession);

     SELECT tmp.MemberId--, tmp.PersonalId
     INTO vbMemberId--, vbPersonalId     
     FROM gpGetMobile_Object_Const (inSession) AS tmp;

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         WITH tmpBranch AS (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_Task_seq') AS TVarChar) AS InvNumber
             , inOperDate				AS OperDate
             , Object_Status.Code                       AS StatusCode
             , Object_Status.Name                       AS StatusName
             , Object_PersonalTrade.Id		        AS PersonalTradeId
             , Object_PersonalTrade.ValueData	        AS PersonalTradeName
             , 0                     		        AS InsertId
             , CAST ('' as TVarChar) 	                AS InsertName
             , CAST (NULL AS TDateTime)                 AS InsertDate

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = vbMemberId
         ;
     ELSE

     RETURN QUERY
 SELECT
             Movement.Id                               AS Id
           , Movement.InvNumber                        AS InvNumber
           , Movement.OperDate                         AS OperDate
           , Object_Status.ObjectCode                  AS StatusCode
           , Object_Status.ValueData                   AS StatusName
           , Object_PersonalTrade.Id                   AS PersonalTradeId
           , Object_PersonalTrade.ValueData            AS PersonalTradeName
           , Object_Insert.Id                          AS InsertId
           , Object_Insert.ValueData                   AS InsertName
           , MovementDate_Insert.ValueData             AS InsertDate
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                      ON MovementBoolean_Closed.MovementId = Movement.Id
                                     AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                         ON MovementLinkObject_PersonalTrade.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

         WHERE Movement.Id = inMovementId
           AND Movement.DescId = zc_Movement_Task();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.     Манько Д.А.
 24.03.17         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Task (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())