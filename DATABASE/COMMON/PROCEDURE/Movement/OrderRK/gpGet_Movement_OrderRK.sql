-- Function: gpGet_Movement_OrderRK()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderRK (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_OrderRK(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , MovementId_OrderExternal Integer
             , InvNumber_OrderExternal  TVarChar, InvNumberFull_OrderExternal TVarChar
             , OperDate_OrderExternal   TDateTime, OperDatePartner_OrderExternal TDateTime
             , isPrint Boolean
             , OperDate_Print TDateTime
             , OperDate_CarInfo TDateTime
             , RouteId Integer, RouteName TVarChar
             , RetailId Integer, RetailName TVarChar
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
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderRK());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_OrderRK_seq') AS TVarChar) AS InvNumber
             , DATE_TRUNC ('Month',inOperDate)       ::TDateTime AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                        AS MovementId_OrderExternal
             , CAST ('' AS TVarChar)    AS InvNumber_OrderExternal
             , CAST ('' AS TVarChar)    AS InvNumberFull_OrderExternal
             , Null         ::TDateTime AS OperDate_OrderExternal
             , Null         ::TDateTime AS OperDatePartner_OrderExternal
             
             , False ::Boolean          AS isPrint
             , CAST (NULL AS TDateTime) AS OperDate_Print
             , CAST (NULL AS TDateTime) AS OperDate_CarInfo
             , 0                        AS RouteId
             , CAST ('' AS TVarChar)    AS RouteName
             , 0                        AS RetailId
             , CAST ('' AS TVarChar)    AS RetailName
             , 0                        AS FromId
             , CAST ('' AS TVarChar)    AS FromName
             , 0                        AS ToId
             , CAST ('' AS TVarChar)    AS ToName
             , CAST ('' AS TVarChar) 		                    AS Comment
             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP        ::TDateTime             AS InsertDate
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              LEFT JOIN Object AS Object_Insert          ON Object_Insert.Id          = vbUserId
              LEFT JOIN Object AS Object_PriceList       ON Object_PriceList.Id       = zc_PriceList_Basis()
          ;
     ELSE

     RETURN QUERY
     SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate ::TDateTime       AS OperDate
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName

           , Movement_OrderExternal.Id           AS MovementId_OrderExternal
           , Movement_OrderExternal.InvNumber    AS InvNumber_OrderExternal
           , zfCalc_PartionMovementName (Movement_OrderExternal.DescId, MovementDesc_OrderExternal.ItemName, Movement_OrderExternal.InvNumber, Movement_OrderExternal.OperDate) AS InvNumberFull_OrderExternal
           , Movement_OrderExternal.OperDate     AS OperDate_OrderExternal
           , MovementDate_OperDatePartner_order.ValueData     AS OperDatePartner_OrderExternal
           
           , COALESCE (MovementBoolean_Print.ValueData, False) ::Boolean AS isPrint
           , MovementDate_Print.ValueData                    ::TDateTime AS OperDate_Print
           , MovementDate_CarInfo.ValueData                  ::TDateTime AS OperDate_CarInfo
           , Object_Route.Id               AS RouteId
           , Object_Route.ValueData        AS RouteName
           , Object_Retail.Id              AS RetailId
           , Object_Retail.ValueData       AS RetailName
           , Object_From.Id                AS FromId
           , Object_From.ValueData         AS FromName
           , Object_To.Id                  AS ToId
           , Object_To.ValueData           AS ToName

           , MovementString_Comment.ValueData    AS Comment

           , Object_Insert.ValueData             AS InsertName
           , MovementDate_Insert.ValueData       AS InsertDate
           
       FROM Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Movement AS Movement_OrderExternal ON Movement_OrderExternal.Id = Movement.ParentId
            LEFT JOIN MovementDesc AS MovementDesc_OrderExternal ON MovementDesc_OrderExternal.Id = Movement_OrderExternal.DescId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_order
                                   ON MovementDate_OperDatePartner_order.MovementId = Movement_OrderExternal.Id
                                  AND MovementDate_OperDatePartner_order.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

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

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_OrderRK();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.26         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderRK (inMovementId:= 0, inOperDate:= CURRENT_DATE, inSession:= '9457')
