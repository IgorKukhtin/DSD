-- Function: gpGet_Movement_Sale()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Sale (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar, InvNumberOrder TVarChar
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_sale_seq') AS TVarChar) AS InvNumber
             , inOperDate						 	AS OperDate
             , Object_Status.Code               	AS StatusCode
             , Object_Status.Name              		AS StatusName
             , CAST (False as Boolean)         		AS Checked
             , inOperDate				      		AS OperDatePartner
             , CAST (False as Boolean)              AS PriceWithVAT
             , CAST (20 as TFloat)                  AS VATPercent
             , CAST (0 as TFloat)                   AS ChangePercent
             , CAST (0 as TFloat)                   AS TotalCount
             , CAST (0 as TFloat)                   AS TotalSummMVAT
             , CAST (0 as TFloat)                   AS TotalSummPVAT
             , CAST (0 as TFloat)                   AS TotalSumm
             , 0                     				AS FromId
             , CAST ('' as TVarChar) 				AS FromName
             , 0                     				AS ToId
             , CAST ('' as TVarChar) 				AS ToName
             , 0                     				AS PaidKindId
             , CAST ('' as TVarChar) 				AS PaidKindName
             , 0                     				AS ContractId
             , CAST ('' as TVarChar) 				AS ContractName
             , 0                     				AS PersonalPackerId
             , CAST ('' as TVarChar) 				AS PersonalPackerName
             , CAST ('' as TVarChar) 				AS InvNumberOrder
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode    				AS StatusCode
           , Object_Status.ValueData     				AS StatusName
           , MovementBoolean_Checked.ValueData          AS Checked
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , Object_From.Id                    			AS FromId
           , Object_From.ValueData             			AS FromName
           , Object_To.Id                      			AS ToId
           , Object_To.ValueData               			AS ToName
           , Object_PaidKind.Id                			AS PaidKindId
           , Object_PaidKind.ValueData         			AS PaidKindName
           , Object_Contract.ContractId        			AS ContractId
           , Object_Contract.invnumber         			AS ContractName
           , Object_RouteSorting.Id        				AS RouteSortingId
           , Object_RouteSorting.ValueData 				AS RouteSortingName
           , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

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

            LEFT JOIN object_contract_invnumber_view AS Object_Contract ON Object_Contract.contractid = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()

            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Sale();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.01.14                                                        * fix ContractName if empty
 16.01.14                                                        * MovementBoolean_Checked
 29.07.13         * add zc_MovementLinkObject_Personal
 14.07.13         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Sale (inMovementId:= 1, inOperDate:=CURRENT_DATE,inSession:= '2')