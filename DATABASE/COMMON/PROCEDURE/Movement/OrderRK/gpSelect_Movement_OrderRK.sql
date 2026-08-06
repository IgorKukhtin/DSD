-- Function: gpSelect_Movement_OrderRK()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderRK (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderRK(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , MovementId_OrderExternal Integer
             , InvNumber_OrderExternal  TVarChar
             , OperDate_OrderExternal   TDateTime, OperDatePartner_OrderExternal TDateTime, OperDatePartner_sale_OE TDateTime

             , isPrint Boolean
             , OperDate_Print TDateTime
             , OperDate_CarInfo TDateTime
             , RouteGroupName TVarChar, RouteId Integer, RouteName TVarChar
             , RetailId Integer, RetailName TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , TotalCountKg TFloat, TotalCountSh TFloat, TotalCount TFloat
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbIsDocumentUser Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderRK());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate ::TDateTime       AS OperDate
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName

           , Movement_OrderExternal.Id           AS MovementId_OrderExternal
           , Movement_OrderExternal.InvNumber    AS InvNumber_OrderExternal
           , Movement_OrderExternal.OperDate     AS OperDate_OrderExternal
           , MovementDate_OperDatePartner_order.ValueData AS OperDatePartner_OrderExternal
           , COALESCE (MovementDate_OperDatePartner_Effie.ValueData, MovementDate_OperDatePartner_order.ValueData + (COALESCE (ObjectFloat_DocumentDayCount_order.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_sale_OE

           , COALESCE (MovementBoolean_Print.ValueData, False) ::Boolean AS isPrint
           , MovementDate_Print.ValueData                    ::TDateTime AS OperDate_Print
           , MovementDate_CarInfo.ValueData                  ::TDateTime AS OperDate_CarInfo
           , Object_RouteGroup.ValueData   AS RouteGroupName
           , Object_Route.Id               AS RouteId
           , Object_Route.ValueData        AS RouteName
           , Object_Retail.Id              AS RetailId
           , Object_Retail.ValueData       AS RetailName
           , Object_From.Id                AS FromId
           , Object_From.ValueData         AS FromName
           , Object_To.Id                  AS ToId
           , Object_To.ValueData           AS ToName

           , MovementFloat_TotalCountKg.ValueData   ::TFloat   AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData   ::TFloat   AS TotalCountSh
           , MovementFloat_TotalCount.ValueData     ::TFloat   AS TotalCount

           , MovementString_Comment.ValueData    AS Comment

           , Object_Insert.ValueData             AS InsertName
           , MovementDate_Insert.ValueData       AS InsertDate
           
       FROM (SELECT Movement.*
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.DescId = zc_Movement_OrderRK()
                               AND Movement.StatusId = tmpStatus.StatusId
            ) AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Movement AS Movement_OrderExternal ON Movement_OrderExternal.Id = Movement.ParentId

            ---
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_order
                                   ON MovementDate_OperDatePartner_order.MovementId = Movement_OrderExternal.Id
                                  AND MovementDate_OperDatePartner_order.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Effie
                                   ON MovementDate_OperDatePartner_Effie.MovementId = Movement_OrderExternal.Id
                                  AND MovementDate_OperDatePartner_Effie.DescId = zc_MovementDate_OperDatePartner_Effie()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From_order
                                         ON MovementLinkObject_From_order.MovementId = Movement_OrderExternal.Id
                                        AND MovementLinkObject_From_order.DescId = zc_MovementLinkObject_From()

            LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount_order
                                  ON ObjectFloat_DocumentDayCount_order.ObjectId = MovementLinkObject_From_order.ObjectId
                                 AND ObjectFloat_DocumentDayCount_order.DescId = zc_ObjectFloat_Partner_DocumentDayCount()
            --
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId = Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId = Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

            LEFT JOIN MovementDate AS MovementDate_Print
                                   ON MovementDate_Print.MovementId = Movement.Id
                                  AND MovementDate_Print.DescId = zc_MovementDate_Print()

            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup
                                 ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderRK (inStartDate:= '30.11.2017', inEndDate:= '30.11.2017', inJuridicalBasisId:=0, inIsErased := FALSE, inSession:= '2')
