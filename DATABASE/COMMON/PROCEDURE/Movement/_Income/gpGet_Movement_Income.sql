-- Function: gpGet_Movement_Income()

-- DROP FUNCTION gpGet_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, ToParentId Integer
             , PaidKindId Integer, PaidKindName TVarChar, ContractId Integer, ContractName TVarChar, CarId Integer, CarName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar, PersonalPackerId Integer, PersonalPackerName TVarChar
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
             , CAST ('' as TVarChar)                 AS InvNumber
             , CAST (CURRENT_TIMESTAMP as TDateTime) AS OperDate
             , Object_Status.Code                    AS StatusCode
             , Object_Status.Name                    AS StatusName

             , CAST (CURRENT_TIMESTAMP as TDateTime) AS OperDatePartner
             , CAST ('' as TVarChar)                 AS InvNumberPartner

             , CAST (False as Boolean)               AS PriceWithVAT
             , CAST (20 as TFloat)                   AS VATPercent
             , CAST (0 as TFloat)                    AS ChangePercent

             , 0                     AS FromId
             , CAST ('' as TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' as TVarChar) AS ToName
             , 0                     AS ToParentId
             , 0                     AS PaidKindId
             , CAST ('' as TVarChar) AS PaidKindName
             , 0                     AS ContractId
             , CAST ('' as TVarChar) AS ContractName
             , 0                     AS CarId
             , CAST ('' as TVarChar) AS CarName
             , 0                     AS PersonalDriverId
             , CAST ('' as TVarChar) AS PersonalDriverName
             , 0                     AS PersonalPackerId
             , CAST ('' as TVarChar) AS PersonalPackerName
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName

             , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
             , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

             , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData          AS VATPercent
             , MovementFloat_ChangePercent.ValueData       AS ChangePercent

             , Object_From.Id                    AS FromId
             , Object_From.ValueData             AS FromName
             , Object_To.Id                      AS ToId
             , Object_To.ValueData               AS ToName
             , ObjectLink_Unit_Parent.ChildObjectId AS ToParentId
             , Object_PaidKind.Id                AS PaidKindId
             , Object_PaidKind.ValueData         AS PaidKindName
             , Object_Contract.Id                AS ContractId
             , Object_Contract.ValueData         AS ContractName
             , Object_Car.Id                     AS CarId
             , Object_Car.ValueData              AS CarName
             , Object_PersonalDriver.Id          AS PersonalDriverId
             , Object_PersonalDriver.ValueData   AS PersonalDriverName
             , Object_PersonalPacker.Id          AS PersonalPackerId
             , Object_PersonalPacker.ValueData   AS PersonalPackerName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent ON ObjectLink_Unit_Parent.ObjectId = Object_To.Id AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalPacker
                                         ON MovementLinkObject_PersonalPacker.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
            LEFT JOIN Object AS Object_PersonalPacker ON Object_PersonalPacker.Id = MovementLinkObject_PersonalPacker.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Income();
     END IF;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Income (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.13                       *              
 30.07.13                       * ToParentId Integer
 09.07.13                                        * Красота
 08.07.13                                        * zc_MovementFloat_ChangePercent
 30.06.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Movement_Income (inMovementId := 0, inSession:= '2')
