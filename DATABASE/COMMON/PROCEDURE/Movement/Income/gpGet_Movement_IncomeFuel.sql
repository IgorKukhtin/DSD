-- Function: gpGet_Movement_IncomeFuel (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_IncomeFuel (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_IncomeFuel(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePrice TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, ToParentId Integer
             , PaidKindId Integer, PaidKindName TVarChar, ContractId Integer, ContractName TVarChar
             , RouteId Integer, RouteName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar
             , StartOdometre TFloat, EndOdometre TFloat, AmountFuel TFloat
             , Reparation TFloat, LimitMoney TFloat, LimitFuel TFloat
             , LimitChange TFloat, LimitFuelChange TFloat, Distance TFloat

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_IncomeFuel());


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_Income_seq') AS TVarChar) AS InvNumber
             , CAST (CURRENT_DATE AS TDateTime) AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

             , CAST (CURRENT_DATE AS TDateTime) AS OperDatePartner
             , CAST ('' AS TVarChar) AS InvNumberPartner

             , CAST (TRUE AS Boolean) AS PriceWithVAT
             , CAST (20 AS TFloat)     AS VATPercent
             , CAST (0 AS TFloat)      AS ChangePrice

             , 0                     AS FromId
             , CAST ('' AS TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' AS TVarChar) AS ToName
             , 0                     AS ToParentId
             , 0                     AS PaidKindId
             , CAST ('' AS TVarChar) AS PaidKindName
             , 0                     AS ContractId
             , CAST ('' AS TVarChar) AS ContractName
             , 0                     AS RouteId
             , CAST ('' AS TVarChar) AS RouteName
             , 0                     AS PersonalDriverId
             , CAST ('' AS TVarChar) AS PersonalDriverName

             , CAST (0 AS TFloat)     AS StartOdometre
             , CAST (0 AS TFloat)     AS EndOdometre
             , CAST (0 AS TFloat)     AS AmountFuel
             , CAST (0 AS TFloat)     AS Reparation
             , CAST (0 AS TFloat)     AS LimitMoney
             , CAST (0 AS TFloat)     AS LimitFuel
             , CAST (0 AS TFloat)     AS LimitChange
             , CAST (0 AS TFloat)     AS LimitFuelChange
             , CAST (0 AS TFloat)     AS Distance

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
             , MovementFloat_ChangePrice.ValueData         AS ChangePrice

             , Object_From.Id                     AS FromId
             , Object_From.ValueData              AS FromName
             , Object_To.Id                       AS ToId
             , Object_To.ValueData                AS ToName
             , 0                                  AS ToParentId
             , Object_PaidKind.Id                 AS PaidKindId
             , Object_PaidKind.ValueData          AS PaidKindName
             , View_Contract_InvNumber.ContractId AS ContractId
             , View_Contract_InvNumber.InvNumber  AS ContractName
             , Object_Route.Id                    AS RouteId
             , Object_Route.ValueData             AS RouteName
             , View_PersonalDriver.PersonalId     AS PersonalDriverId
             , View_PersonalDriver.PersonalName   AS PersonalDriverName

             , MovementFloat_StartOdometre.ValueData       AS StartOdometre
             , MovementFloat_EndOdometre.ValueData         AS EndOdometre
             , MovementFloat_AmountFuel.ValueData          AS AmountFuel
             , MovementFloat_Reparation.ValueData          AS Reparation
             , MovementFloat_Limit.ValueData               AS LimitMoney
             , MovementFloat_LimitFuel.ValueData           AS LimitFuel
             , MovementFloat_LimitChange.ValueData         AS LimitChange
             , MovementFloat_LimitFuelChange.ValueData     AS LimitFuelChange
             , MovementFloat_Distance.ValueData            AS Distance


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
            LEFT JOIN MovementFloat AS MovementFloat_ChangePrice
                                    ON MovementFloat_ChangePrice.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePrice.DescId = zc_MovementFloat_ChangePrice()

            LEFT JOIN MovementFloat AS MovementFloat_StartOdometre
                                    ON MovementFloat_StartOdometre.MovementId =  Movement.Id
                                   AND MovementFloat_StartOdometre.DescId = zc_MovementFloat_StartOdometre()
            LEFT JOIN MovementFloat AS MovementFloat_EndOdometre
                                    ON MovementFloat_EndOdometre.MovementId =  Movement.Id
                                   AND MovementFloat_EndOdometre.DescId = zc_MovementFloat_EndOdometre()
            LEFT JOIN MovementFloat AS MovementFloat_AmountFuel
                                    ON MovementFloat_AmountFuel.MovementId =  Movement.Id
                                   AND MovementFloat_AmountFuel.DescId = zc_MovementFloat_AmountFuel()
            LEFT JOIN MovementFloat AS MovementFloat_Reparation
                                    ON MovementFloat_Reparation.MovementId =  Movement.Id
                                   AND MovementFloat_Reparation.DescId = zc_MovementFloat_Reparation()
            LEFT JOIN MovementFloat AS MovementFloat_Limit
                                    ON MovementFloat_Limit.MovementId =  Movement.Id
                                   AND MovementFloat_Limit.DescId = zc_MovementFloat_Limit()
            LEFT JOIN MovementFloat AS MovementFloat_LimitFuel
                                    ON MovementFloat_LimitFuel.MovementId =  Movement.Id
                                   AND MovementFloat_LimitFuel.DescId = zc_MovementFloat_LimitFuel()
            LEFT JOIN MovementFloat AS MovementFloat_LimitChange
                                    ON MovementFloat_LimitChange.MovementId =  Movement.Id
                                   AND MovementFloat_LimitChange.DescId = zc_MovementFloat_LimitChange()
            LEFT JOIN MovementFloat AS MovementFloat_LimitFuelChange
                                    ON MovementFloat_LimitFuelChange.MovementId =  Movement.Id
                                   AND MovementFloat_LimitFuelChange.DescId = zc_MovementFloat_LimitFuelChange()
            LEFT JOIN MovementFloat AS MovementFloat_Distance
                                    ON MovementFloat_Distance.MovementId =  Movement.Id
                                   AND MovementFloat_Distance.DescId = zc_MovementFloat_Distance()

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
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Income();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_IncomeFuel (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.01.16         * add
 09.02.14                                        * add Object_Contract_InvNumber_View
 31.10.13                                        * add OperDatePartner
 23.10.13                                        * add NEXTVAL
 20.10.13                                        * CURRENT_TIMESTAMP -> CURRENT_DATE
 19.10.13                                        * add ChangePrice
 07.10.13                                        * add lpCheckRight
 05.10.13                                        * add InvNumberPartner
 04.10.13                                        * add Route
 30.09.13                                        * add Object_Personal_View
 29.09.13                                        * add lfGet_InvNumber
 27.09.13                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_IncomeFuel (inMovementId := 0, inSession:= zfCalc_UserAdmin())
