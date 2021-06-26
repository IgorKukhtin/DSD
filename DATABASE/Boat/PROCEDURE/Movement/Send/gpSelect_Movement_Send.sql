-- Function: gpSelect_Movement_SendChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_Send(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_Send AS ( SELECT Movement_Send.Id
                                  , Movement_Send.InvNumber
                                  , Movement_Send.OperDate             AS OperDate
                                  , Movement_Send.StatusId             AS StatusId
                                  , MovementLinkObject_To.ObjectId     AS ToId
                                  , MovementLinkObject_From.ObjectId   AS FromId
                             FROM tmpStatus
                                  INNER JOIN Movement AS Movement_Send
                                                      ON Movement_Send.StatusId = tmpStatus.StatusId
                                                     AND Movement_Send.OperDate BETWEEN inStartDate AND inEndDate
                                                     AND Movement_Send.DescId = zc_Movement_Send()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement_Send.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement_Send.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            )

        SELECT Movement_Send.Id
             , zfConvert_StringToNumber (Movement_Send.InvNumber) AS InvNumber
             , ('№ ' || Movement_Send.InvNumber || ' от ' || zfConvert_DateToString (Movement_Send.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
             , Movement_Send.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm

             , Object_From.Id                             AS FromId
             , Object_From.ObjectCode                     AS FromCode
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId
             , Object_To.ObjectCode                       AS ToCode
             , Object_To.ValueData                        AS ToName
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM Movement_Send

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Send.StatusId
        LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_Send.FromId
        LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_Send.ToId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement_Send.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement_Send.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_Send.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_Send.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement_Send.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement_Send.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement_Send.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.06.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Send (inStartDate:= '29.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin())