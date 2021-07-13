-- Function: gpSelect_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnion (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnion(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , TotalCountChild TFloat
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
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_ProductionUnion AS ( SELECT Movement_ProductionUnion.Id
                                  , Movement_ProductionUnion.InvNumber
                                  , Movement_ProductionUnion.OperDate             AS OperDate
                                  , Movement_ProductionUnion.StatusId             AS StatusId
                                  , MovementLinkObject_To.ObjectId     AS ToId
                                  , MovementLinkObject_From.ObjectId   AS FromId
                             FROM tmpStatus
                                  INNER JOIN Movement AS Movement_ProductionUnion
                                                      ON Movement_ProductionUnion.StatusId = tmpStatus.StatusId
                                                     AND Movement_ProductionUnion.OperDate BETWEEN inStartDate AND inEndDate
                                                     AND Movement_ProductionUnion.DescId = zc_Movement_ProductionUnion()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement_ProductionUnion.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement_ProductionUnion.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            )

        SELECT Movement_ProductionUnion.Id
             , zfConvert_StringToNumber (Movement_ProductionUnion.InvNumber) AS InvNumber
             , ('№ ' || Movement_ProductionUnion.InvNumber || ' от ' || zfConvert_DateToString (Movement_ProductionUnion.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
             , Movement_ProductionUnion.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalCountChild.ValueData    AS TotalCountChild

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

        FROM Movement_ProductionUnion

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_ProductionUnion.StatusId
        LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_ProductionUnion.FromId
        LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_ProductionUnion.ToId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement_ProductionUnion.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalCountChild
                                ON MovementFloat_TotalCountChild.MovementId = Movement_ProductionUnion.Id
                               AND MovementFloat_TotalCountChild.DescId = zc_MovementFloat_TotalCountChild()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_ProductionUnion.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_ProductionUnion.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement_ProductionUnion.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement_ProductionUnion.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement_ProductionUnion.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProductionUnion (inStartDate:= '29.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin())