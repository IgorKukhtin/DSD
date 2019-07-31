-- Function: gpGet_Movement_PersonalAccount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalAccount (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_PersonalAccount (Integer, TDateTime ,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalAccount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , -- 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PersonalId Integer, PersonalName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalAccount());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_PersonalAccount_seq') as Integer) AS InvNumber
--           , CAST (CURRENT_DATE as TDateTime) AS OperDate
           , inOperDate AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName

           , Object_Personal.Id               AS PersonalId
           , Object_Personal.ValueData        AS PersonalName

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = 984658 -- Сисоєва Олена Сергіївна -- IN (SELECT MIN (Object_Personal_View.PersonalId) FROM Object_Personal_View WHERE PersonalCode = 2)
       ;
     ELSE
     RETURN QUERY 
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , Object_Personal.Id         AS PersonalId
           , Object_Personal.ValueData  AS PersonalName
  
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_PersonalAccount();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_PersonalAccount (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.01.14                                        * add inOperDate
 18.12.13         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalAccount (inMovementId:= 0, inSession:= zfCalc_UserAdmin())
