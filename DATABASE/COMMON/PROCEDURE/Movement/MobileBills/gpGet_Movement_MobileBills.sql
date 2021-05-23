-- Function: gpGet_Movement_MobileBills()

DROP FUNCTION IF EXISTS gpGet_Movement_MobileBills (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_MobileBills(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ContractId Integer, ContractName TVarChar
               )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_MobileBills());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_MobileBills_seq') AS TVarChar) AS InvNumber
             , inOperDate                                 AS OperDate
             , Object_Status.Code                         AS StatusCode
             , Object_Status.Name                         AS StatusName
             , 0                                          AS ContractId
             , CAST ('' AS TVarChar) 		          AS ContractName
            
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , Object_Contract.Id                 AS ContractId 
           , Object_Contract.ValueData          AS ContractName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
         
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_MobileBills();

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.10.16         * parce
 27.09.16         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_MobileBills (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= '9818')
