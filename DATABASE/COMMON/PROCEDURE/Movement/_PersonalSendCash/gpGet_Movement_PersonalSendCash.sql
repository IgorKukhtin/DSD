-- Function: gpGet_Movement_PersonalSendCash (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalSendCash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalSendCash(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PersonalId Integer, PersonalName TVarChar
              )
AS
$BODY$
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalSendCash());

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_PersonalSendCash_seq') AS TVarChar) AS InvNumber
           , CAST (CURRENT_DATE as TDateTime) AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName

           , View_Personal.PersonalId
           , View_Personal.PersonalName

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId IN (SELECT MIN (Object_Personal_View.PersonalId) FROM Object_Personal_View WHERE PersonalCode = 2)
       ;
     ELSE
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , View_Personal.PersonalId
           , View_Personal.PersonalName
  
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = MovementLinkObject_Personal.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_PersonalSendCash();

     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_PersonalSendCash (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.13                                        * add NEXTVAL
 20.10.13                                        * CURRENT_TIMESTAMP -> CURRENT_DATE
 30.09.13                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalSendCash (inMovementId:= 0, inSession:= zfCalc_UserAdmin())
