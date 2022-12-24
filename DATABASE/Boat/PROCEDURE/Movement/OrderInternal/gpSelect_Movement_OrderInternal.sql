-- Function: gpSelect_Movement_OrderInternalChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternal(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inClientId      Integer  ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar
             , BarCode TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )

AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_OrderInternal AS ( SELECT Movement_OrderInternal.Id
                                           , Movement_OrderInternal.InvNumber
                                           , Movement_OrderInternal.OperDate             AS OperDate
                                           , Movement_OrderInternal.StatusId             AS StatusId
                                      FROM tmpStatus
                                           INNER JOIN Movement AS Movement_OrderInternal
                                                               ON Movement_OrderInternal.StatusId = tmpStatus.StatusId
                                                              AND Movement_OrderInternal.OperDate BETWEEN inStartDate AND inEndDate
                                                              AND Movement_OrderInternal.DescId = zc_Movement_OrderInternal()
                                     )


        SELECT Movement_OrderInternal.Id
             , zfConvert_StringToNumber (Movement_OrderInternal.InvNumber) AS InvNumber
             , ('№ ' || Movement_OrderInternal.InvNumber || ' от ' || zfConvert_DateToString (Movement_OrderInternal.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
             , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_OrderInternal.Id) AS BarCode
             , Movement_OrderInternal.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

        FROM Movement_OrderInternal

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_OrderInternal.StatusId

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_OrderInternal.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_OrderInternal.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_OrderInternal.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement_OrderInternal.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Update
                                    ON MovementDate_Update.MovementId = Movement_OrderInternal.Id
                                   AND MovementDate_Update.DescId = zc_MovementDate_Update()
             LEFT JOIN MovementLinkObject AS MLO_Update
                                          ON MLO_Update.MovementId = Movement_OrderInternal.Id
                                         AND MLO_Update.DescId = zc_MovementLinkObject_Update()
             LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternal (inStartDate:= '01.01.2021', inEndDate:= '31.12.2021', inClientId:=0 , inIsErased := FALSE, inSession:= zfCalc_UserAdmin())
