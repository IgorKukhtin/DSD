-- Function: gpSelect_Movement_ProductionPersonal()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionPersonal (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionPersonal(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProductionPersonal());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_ProductionPersonal AS ( SELECT Movement_ProductionPersonal.Id
                                             , Movement_ProductionPersonal.ParentId
                                             , Movement_ProductionPersonal.InvNumber
                                             , Movement_ProductionPersonal.OperDate             AS OperDate
                                             , Movement_ProductionPersonal.StatusId             AS StatusId
                                             , MovementLinkObject_Unit.ObjectId     AS UnitId
                                        FROM tmpStatus
                                             INNER JOIN Movement AS Movement_ProductionPersonal
                                                                 ON Movement_ProductionPersonal.StatusId = tmpStatus.StatusId
                                                                AND Movement_ProductionPersonal.OperDate BETWEEN inStartDate AND inEndDate
                                                                AND Movement_ProductionPersonal.DescId = zc_Movement_ProductionPersonal()
           
                                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                          ON MovementLinkObject_Unit.MovementId = Movement_ProductionPersonal.Id
                                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        )

        SELECT Movement_ProductionPersonal.Id
             , zfConvert_StringToNumber (Movement_ProductionPersonal.InvNumber) AS InvNumber
             , ('№ ' || Movement_ProductionPersonal.InvNumber || ' от ' || zfConvert_DateToString (Movement_ProductionPersonal.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
             , Movement_ProductionPersonal.OperDate
             , Object_Status.ObjectCode                     AS StatusCode
             , Object_Status.ValueData                      AS StatusName

             , MovementFloat_TotalCount.ValueData           AS TotalCount

             , Object_Unit.Id                               AS UnitId
             , Object_Unit.ObjectCode                       AS UnitCode
             , Object_Unit.ValueData                        AS UnitName
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM Movement_ProductionPersonal

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_ProductionPersonal.StatusId
        LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = Movement_ProductionPersonal.UnitId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement_ProductionPersonal.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_ProductionPersonal.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_ProductionPersonal.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement_ProductionPersonal.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement_ProductionPersonal.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement_ProductionPersonal.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.07.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProductionPersonal (inStartDate:= '29.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin())