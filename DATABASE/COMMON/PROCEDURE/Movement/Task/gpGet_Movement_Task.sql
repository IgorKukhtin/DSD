-- Function: gpGet_Movement_Task()

DROP FUNCTION IF EXISTS gpGet_Movement_Task (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Task(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionCode Integer, PositionName TVarChar
             , PersonalTradeId Integer, PersonalTradeName TVarChar
             , InsertId Integer, InsertName TVarChar
             , InsertDate TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Task());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_Task_seq') AS TVarChar) AS InvNumber
             , inOperDate				AS OperDate
             , Object_Status.Code                       AS StatusCode
             , Object_Status.Name                       AS StatusName
             , 0                     		        AS BranchCode
             , '' :: TVarChar                           AS BranchName
             , 0                     		        AS UnitCode
             , '' :: TVarChar                           AS UnitName
             , 0                     		        AS PositionCode
             , '' :: TVarChar                           AS PositionName
             , 0                     		        AS PersonalTradeId
             , '' :: TVarChar                           AS PersonalTradeName
             , 0                     		        AS InsertId
             , '' :: TVarChar                           AS InsertName
             , CAST (NULL AS TDateTime)                 AS InsertDate

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
         ;
         
     ELSE

     RETURN QUERY
         WITH
           tmpPersonal AS (SELECT lfSelect.MemberId
                                , lfSelect.PersonalId
                                , lfSelect.UnitId
                                , lfSelect.PositionId
                                , lfSelect.BranchId
                           FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                           WHERE lfSelect.Ord = 1
                          )
       SELECT
             Movement.Id                               AS Id
           , Movement.InvNumber                        AS InvNumber
           , Movement.OperDate                         AS OperDate
           , Object_Status.ObjectCode                  AS StatusCode
           , Object_Status.ValueData                   AS StatusName
           , Object_Branch.ObjectCode                  AS BranchCode
           , Object_Branch.ValueData                   AS BranchName
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName
           , Object_Position.ObjectCode                AS PositionCode
           , Object_Position.ValueData                 AS PositionName
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

            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = Object_PersonalTrade.Id -- AND tmpPersonal.Ord = 1

            LEFT JOIN Object AS Object_Branch   ON Object_Branch.Id   = tmpPersonal.BranchId
            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpPersonal.UnitId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId

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