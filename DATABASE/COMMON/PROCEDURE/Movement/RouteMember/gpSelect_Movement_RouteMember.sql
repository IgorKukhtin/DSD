-- Function: gpSelect_Movement_RouteMember()

DROP FUNCTION IF EXISTS gpSelect_Movement_RouteMember(TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_RouteMember (
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inIsErased         Boolean   ,
    IN inJuridicalBasisId Integer   ,
    IN inMemberId         Integer   ,
    IN inSession          TVarChar    -- сессия пользователя
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
   DECLARE vbUserId      Integer;

   DECLARE vbMemberId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_RouteMember());
      vbUserId := lpGetUserBySession(inSession);

     SELECT tmp.MemberId, tmp.PersonalId
     INTO vbMemberId, vbPersonalId     
     FROM gpGetMobile_Object_Const (inSession) AS tmp;

     IF (COALESCE(inMemberId,0) <> 0 AND COALESCE(vbMemberId,0) <> inMemberId)
        THEN
            RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.'; 
     END IF;

      -- Результат
      RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                           UNION 
                           SELECT zc_Enum_Status_UnComplete() AS StatusId
                           UNION 
                           SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                          )

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
        FROM (SELECT Movement.Id
              FROM tmpStatus
                   JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                                AND Movement.DescId = zc_Movement_RouteMember() 
                                AND Movement.StatusId = tmpStatus.StatusId
             ) AS tmpMovement
             LEFT JOIN Movement ON Movement.Id = tmpMovement.Id

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

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

             LEFT JOIN MovementFloat AS MovementFloat_GPSN
                                     ON MovementFloat_GPSN.MovementId = Movement.Id
                                    AND MovementFloat_GPSN.DescId = zc_MovementFloat_GPSN()

             LEFT JOIN MovementFloat AS MovementFloat_GPSE
                                     ON MovementFloat_GPSE.MovementId = Movement.Id
                                    AND MovementFloat_GPSE.DescId = zc_MovementFloat_GPSE()

             LEFT JOIN MovementString AS MovementString_GUID
                                      ON MovementString_GUID.MovementId = Movement.Id
                                     AND MovementString_GUID.DescId = zc_MovementString_GUID()
   ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 26.03.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_RouteMember(inStartDate:= '01.01.2017', inEndDate:= CURRENT_DATE, inIsErased:= FALSE, inJuridicalBasisId:= 0, inSession := zfCalc_UserAdmin())
