-- FunctiON: gpGet_Movement_Reestr (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_Reestr (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Reestr(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , CarId Integer, CarName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar
             , MemberId Integer, MemberName TVarChar
             , MovementId_Transport Integer, InvNumber_Transport TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Reestr());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST ('' AS TVarChar)  AS InvNumber --CAST (NEXTVAL ('Movement_Reestr_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime          AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

             , 0                     AS CarId
             , CAST ('' AS TVarChar) AS CarName
             , 0                     AS PersonalDriverId
             , CAST ('' AS TVarChar) AS PersonalDriverName

             , 0                     AS MemberId
             , CAST ('' AS TVarChar) AS MemberName

             , 0                                    AS MovementId_Transport
             , '' :: TVarChar                       AS InvNumber_Transport 

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
       
         -- результат
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , Object_Car.Id                     AS CarId
             , Object_Car.ValueData              AS CarName
             , Object_PersonalDriver.Id          AS PersonalDriverId
             , Object_PersonalDriver.ValueData   AS PersonalDriverName
             , Object_Member.Id                  AS MemberId
             , Object_Member.ValueData           AS MemberName
            
             , Movement_Transport.Id                     AS MovementId_Transport
             , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar AS InvNumber_Transport

--             , zfCalc_PartiONMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvoiceName

       FROM Movement
          --  LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_Reestr();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.16         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Reestr (inMovementId:= 0 ::integer,  inOperDate:= CURRENT_DATE ::TDateTime, inSession:= '5'::TVarChar)
