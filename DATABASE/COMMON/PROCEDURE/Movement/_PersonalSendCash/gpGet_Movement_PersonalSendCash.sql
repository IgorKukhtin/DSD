-- Function: gpGet_Movement_PersonalSendCash (Integer, TVarChar)

-- DROP FUNCTION gpGet_Movement_PersonalSendCash (Integer, TVarChar);

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
           , CAST (lfGet_InvNumber (0, zc_Movement_PersonalSendCash()) as TVarChar) InvNumber
           , CAST (CURRENT_TIMESTAMP as TDateTime) AS OperDate
           , lfObject_Status.Code                  AS StatusCode
           , lfObject_Status.Name                  AS StatusName

           , Object_Personal.Id        AS PersonalId
           , Object_Personal.ValueData AS PersonalName

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
               LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = 1000
       ;
     ELSE
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , Object_Personal.Id         AS PersonalId
           , Object_Personal.ValueData  AS PersonalName
  
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = Movement.Id
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

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
 30.09.13                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalSendCash (inMovementId:= 0, inSession:= '2')
