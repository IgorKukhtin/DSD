-- Function: gpGet_Movement_ProfitLossResult()

DROP FUNCTION IF EXISTS gpGet_Movement_ProfitLossResult (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProfitLossResult(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AccountId Integer, AccountName TVarChar
             , TotalSumm TFloat
             , Comment TVarChar
             , isCorrective Boolean
             , InsertDate TDateTime, InsertName TVarChar
             , UpdateDate TDateTime, UpdateName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProfitLossResult());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_ProfitLossResult_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , Object_Account.Id                                AS AccountId
             , Object_Account.ValueData                         AS AccountName
             , CAST (0 AS TFloat)                               AS TotalSumm
             , CAST ('' as TVarChar)                            AS Comment
             , FALSE                                            AS isCorrective
             , CURRENT_TIMESTAMP ::TDateTime                    AS InsertDate
             , Object_Insert.ValueData                          AS InsertName
             , CAST (NULL as TDateTime)                         AS UpdateDate             
             , CAST ('' as TVarChar)                            AS UpdateName
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
              LEFT JOIN Object AS Object_Account ON Object_Account.Id = zc_Enum_Account_100301()
          ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , Object_Account.Id                  AS AccountId
           , Object_Account.ValueData           AS AccountName
           , MovementFloat_TotalSumm.ValueData  AS TotalSumm

           , MovementString_Comment.ValueData   AS Comment

           , COALESCE(MovementBoolean_isCorrective.ValueData, False) ::Boolean  AS isCorrective

           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Insert.ValueData                AS InsertName
           , MovementDate_Update.ValueData          AS UpdateDate
           , Object_Update.ValueData                AS UpdateName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Account
                                         ON MovementLinkObject_Account.MovementId = Movement.Id
                                        AND MovementLinkObject_Account.DescId = zc_MovementLinkObject_Account()
            LEFT JOIN Object AS Object_Account ON Object_Account.Id = MovementLinkObject_Account.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementBoolean AS MovementBoolean_isCorrective
                                      ON MovementBoolean_isCorrective.MovementId = Movement.Id
                                     AND MovementBoolean_isCorrective.DescId = zc_MovementBoolean_isCorrective()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

        WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_ProfitLossResult();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ProfitLossResult (inMovementId:= 0, inOperDate:= CURRENT_DATE, inSession:= '9818')
