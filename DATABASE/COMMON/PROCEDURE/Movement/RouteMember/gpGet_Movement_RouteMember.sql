-- Function: gpGet_Movement_RouteMember()

DROP FUNCTION IF EXISTS gpGet_Movement_RouteMember(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_RouteMember (
    IN inMovementId Integer  , -- ключ Документа
    IN inOperDate   TDateTime, -- дата Документа
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , GUID TVarChar
             , GPSN TFloat
             , GPSE TFloat
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , InsertName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUserName TVarChar;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_RouteMember());
      vbUserId:= lpGetUserBySession (inSession);
      vbUserName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = vbUserId);

      IF COALESCE(inMovementId, 0) = 0 
      THEN
           RETURN QUERY
             SELECT 0::Integer                                  AS Id
                  , NEXTVAL('movement_RouteMember_seq')::TVarChar AS InvNumber
                  , CURRENT_DATE::TDateTime                     AS OperDate
                  , Object_Status.Code                          AS StatusCode
                  , Object_Status.Name                          AS StatusName
                  , ''::TVarChar                                AS GUID
                  , Null ::TFloat                               AS GPSN
                  , Null ::TFloat                               AS GPSE
                  , CURRENT_TIMESTAMP::TDateTime                AS InsertDate
                  , CURRENT_TIMESTAMP ::TDateTime               AS InsertMobileDate
                  , vbUserName                                  AS InserName 
             FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
      ELSE
           RETURN QUERY
             SELECT Movement.Id                           
                  , Movement.InvNumber                        
                  , Movement.OperDate                      
                  , Object_Status.ObjectCode            AS StatusCode
                  , Object_Status.ValueData             AS StatusName
                  , MovementString_GUID.ValueData       AS GUID
                  , MovementFloat_GPSN.ValueData        AS GPSN
                  , MovementFloat_GPSE.ValueData        AS GPSE
                  , MovementDate_Insert.ValueData       AS InsertDate
                  , MovementDate_InsertMobile.ValueData AS InsertMobileDate
                  , Object_User.ValueData               AS InsertName
             FROM Movement
                  LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                  LEFT JOIN MovementString AS MovementString_GUID 
                                           ON MovementString_GUID.MovementId = Movement.Id
                                          AND MovementString_GUID.DescId = zc_MovementString_GUID()

                  LEFT JOIN MovementFloat AS MovementFloat_GPSN
                                          ON MovementFloat_GPSN.MovementId = Movement.Id
                                         AND MovementFloat_GPSN.DescId = zc_MovementFloat_GPSN()

                  LEFT JOIN MovementFloat AS MovementFloat_GPSE
                                          ON MovementFloat_GPSE.MovementId = Movement.Id
                                         AND MovementFloat_GPSE.DescId = zc_MovementFloat_GPSE()

                  LEFT JOIN MovementDate AS MovementDate_Insert 
                                         ON MovementDate_Insert.MovementId = Movement.Id
                                        AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                  LEFT JOIN MovementDate AS MovementDate_InsertMobile 
                                         ON MovementDate_InsertMobile.MovementId = Movement.Id
                                        AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert 
                                               ON MovementLinkObject_Insert.MovementId = Movement.Id
                                              AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                  LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId

             WHERE Movement.Id = inMovementId
               AND Movement.DescId = zc_Movement_RouteMember();
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 27.03.17         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_RouteMember (inMovementId := 1, inOperDate := CURRENT_DATE, inSession := '9818')
