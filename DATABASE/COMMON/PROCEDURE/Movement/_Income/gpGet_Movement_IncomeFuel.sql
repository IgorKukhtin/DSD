-- Function: gpGet_Movement_IncomeFuel()

-- DROP FUNCTION gpGet_Movement_IncomeFuel (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_IncomeFuel(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, ToParentId Integer
             , PaidKindId Integer, PaidKindName TVarChar, ContractId Integer, ContractName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (lfGet_InvNumber (0, zc_Movement_Income()) as TVarChar) AS InvNumber
             , CAST (CURRENT_TIMESTAMP as TDateTime) AS OperDate
             , Object_Status.Code                    AS StatusCode
             , Object_Status.Name                    AS StatusName

             , CAST (False as Boolean)               AS PriceWithVAT
             , CAST (20 as TFloat)                   AS VATPercent

             , 0                     AS FromId
             , CAST ('' as TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' as TVarChar) AS ToName
             , 0                     AS ToParentId
             , 0                     AS PaidKindId
             , CAST ('' as TVarChar) AS PaidKindName
             , 0                     AS ContractId
             , CAST ('' as TVarChar) AS ContractName
             , 0                     AS PersonalDriverId
             , CAST ('' as TVarChar) AS PersonalDriverName
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData          AS VATPercent

             , Object_From.Id                    AS FromId
             , Object_From.ValueData             AS FromName
             , Object_To.Id                      AS ToId
             , Object_To.ValueData               AS ToName
             , 0                                 AS ToParentId
             , Object_PaidKind.Id                AS PaidKindId
             , Object_PaidKind.ValueData         AS PaidKindName
             , Object_Contract.Id                AS ContractId
             , Object_Contract.ValueData         AS ContractName
             , Object_PersonalDriver.Id          AS PersonalDriverId
             , Object_PersonalDriver.ValueData   AS PersonalDriverName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Income();
     END IF;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_IncomeFuel (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.09.13                                        * add lfGet_InvNumber
 27.09.13                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_IncomeFuel (inMovementId := 0, inSession:= '2')
