-- Function: gpSelect_Movement_GoodsAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_GoodsAccount (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_GoodsAccount(
    IN inStartDate         TDateTime , -- Дата нач. периода
    IN inEndDate           TDateTime , -- Дата оконч. периода
    IN inIsErased          Boolean   , -- показывать удаленные Да/Нет
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSummPay TFloat
             , TotalSummChange TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_GoodsAccount());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       SELECT
             Movement.Id                                 AS Id
           , Movement.InvNumber                          AS InvNumber
           , Movement.OperDate                           AS OperDate
           , Object_Status.ObjectCode                    AS StatusCode
           , Object_Status.ValueData                     AS StatusName

           , MovementFloat_TotalSummPay.ValueData        AS TotalSummPay
           , MovementFloat_TotalSummChange.ValueData     AS TotalSummChange
       
           , Object_From.Id                              AS FromId
           , Object_From.ValueData                       AS FromName
           , Object_To.Id                                AS ToId
           , Object_To.ValueData                         AS ToName
           , MovementString_Comment.ValueData            AS Comment

           , Object_Insert.ValueData                     AS InsertName
           , MovementDate_Insert.ValueData               AS InsertDate
       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                               AND Movement.DescId = zc_Movement_GoodsAccount()
                               AND Movement.StatusId = tmpStatus.StatusId
             ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                    ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPay.DescId     = zc_MovementFloat_TotalSummPay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChange.DescId     = zc_MovementFloat_TotalSummChange()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
            INNER JOIN Object AS Object_From ON Object_From.Id     = MovementLinkObject_From.ObjectId
                                            AND Object_From.DescId = zc_Object_Client()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            
            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
    
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId     = zc_MovementString_Comment()
            ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 14.07.17         *
 18.05.17         *
*/

-- тест
 --SELECT * FROM gpSelect_Movement_GoodsAccount (inStartDate:= '01.01.2015', inEndDate:= '01.02.2015', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
