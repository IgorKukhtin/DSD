-- Function: gpGet_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnIn(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar, Checked Boolean
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_returnin_seq') AS TVarChar) AS InvNumber
             , inOperDate						    AS OperDate
             , Object_Status.Code                   AS StatusCode
             , Object_Status.Name                   AS StatusName
             , CAST (False as Boolean)              AS Checked
             , inOperDate				      		AS OperDatePartner
             , CAST (False as Boolean)              AS PriceWithVAT
             , CAST (20 as TFloat)                  AS VATPercent
             , CAST (0 as TFloat)                   AS ChangePercent
             , CAST (0 as TFloat)                   AS TotalCount
             , CAST (0 as TFloat)                   AS TotalSummMVAT
             , CAST (0 as TFloat)                   AS TotalSummPVAT
             , CAST (0 as TFloat)                   AS TotalSumm
             , 0                     				AS FromId
             , CAST ('' as TVarChar) 			    AS FromName
             , 0                     				AS ToId
             , CAST ('' as TVarChar) 				AS ToName
             , 0                     				AS PaidKindId
             , CAST ('' as TVarChar) 				AS PaidKindName
             , 0                     				AS ContractId
             , CAST ('' as TVarChar) 				AS ContractName
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          	    AS StatusCode
           , Object_Status.ValueData         	    AS StatusName
           , MovementBoolean_Checked.ValueData      AS Checked
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData  AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData  AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm
           , Object_From.Id                    	    AS FromId
           , Object_From.ValueData             	    AS FromName
           , Object_To.Id                      	    AS ToId
           , Object_To.ValueData               	    AS ToName
           , Object_PaidKind.Id                	    AS PaidKindId
           , Object_PaidKind.ValueData         	    AS PaidKindName
           , View_Contract_InvNumber.ContractId     AS ContractId
           , View_Contract_InvNumber.InvNumber      AS ContractName


       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

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
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

         WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_ReturnIn();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_ReturnIn (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.     Манько Д.А.
 09.02.14                                        * add Object_Contract_InvNumber_View
 27.01.14                                                          * -Car -Driver +Checked +id=0
 17.07.13         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ReturnIn (inMovementId:= 1, inSession:= '2')
