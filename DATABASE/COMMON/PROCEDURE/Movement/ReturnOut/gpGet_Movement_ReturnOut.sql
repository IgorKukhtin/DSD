-- Function: gpGet_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnOut (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnOut(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , CurrencyValue TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , CurrencyPartnerId Integer, CurrencyPartnerName TVarChar
             , PaidKindFromId Integer, PaidKindFromName TVarChar
             , ContractFromId Integer, ContractFromName TVarChar
             , ChangePercentFrom TFloat
             , Comment TVarChar
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnOut());
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0                                    AS Id
             , CAST (NEXTVAL ('movement_returnout_seq') AS TVarChar) AS InvNumber
             , inOperDate						    AS OperDate
             , Object_Status.Code                   AS StatusCode
             , Object_Status.Name                   AS StatusName
             , inOperDate				      		AS OperDatePartner
             , CAST (False as Boolean)              AS PriceWithVAT
             , CAST (20 as TFloat)                  AS VATPercent
             , CAST (0 as TFloat)                   AS ChangePercent
             , CAST (0 as TFloat)                   AS TotalCount
             , CAST (0 as TFloat)                   AS TotalSummMVAT
             , CAST (0 as TFloat)                   AS TotalSummPVAT
             , CAST (0 as TFloat)                   AS TotalSumm

             , CAST (0 as TFloat)                   AS CurrencyValue

             , 0                     		    AS FromId
             , CAST ('' as TVarChar) 		    AS FromName
             , 0                     		    AS ToId
             , CAST ('' as TVarChar) 		    AS ToName
             , 0                     		    AS PaidKindId
             , CAST ('' as TVarChar) 		    AS PaidKindName
             , 0                     		    AS ContractId
             , CAST ('' as TVarChar) 		    AS ContractName

             , ObjectCurrency.Id      AS CurrencyDocumentId	                             -- грн
             , ObjectCurrency.ValueData  AS CurrencyDocumentName
             , 0                     AS CurrencyPartnerId
             , CAST ('' as TVarChar) AS CurrencyPartnerName

             , 0                     		    AS PaidKindFromId
             , CAST ('' as TVarChar) 		    AS PaidKindFromName
             , 0                     		    AS ContractFromId
             , CAST ('' as TVarChar) 		    AS ContractFromName
             , CAST (0 as TFloat)                   AS ChangePercentFrom
             , CAST ('' as TVarChar) 		    AS Comment

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
              JOIN Object as ObjectCurrency on ObjectCurrency.descid= zc_Object_Currency()
                                            and ObjectCurrency.id = 14461;	             -- грн
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData  AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData  AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm
           , MovementFloat_CurrencyValue.ValueData       AS CurrencyValue
           , Object_From.Id                    	    AS FromId
           , Object_From.ValueData             	    AS FromName
           , Object_To.Id                      	    AS ToId
           , Object_To.ValueData               	    AS ToName
           , Object_PaidKind.Id                	    AS PaidKindId
           , Object_PaidKind.ValueData         	    AS PaidKindName
           , View_Contract_InvNumber.ContractId     AS ContractId
           , View_Contract_InvNumber.InvNumber      AS ContractName
        
             , COALESCE (Object_CurrencyDocument.Id, ObjectCurrencycyDocumentInf.Id)                AS CurrencyDocumentId
             , COALESCE (Object_CurrencyDocument.ValueData, ObjectCurrencycyDocumentInf.ValueData)  AS CurrencyDocumentName
           , Object_CurrencyPartner.Id              AS CurrencyPartnerId
           , Object_CurrencyPartner.ValueData       AS CurrencyPartnerName
 
           , Object_PaidKindFrom.Id                	AS PaidKindFromId
           , Object_PaidKindFrom.ValueData         	AS PaidKindFromName
           , View_ContractFrom_InvNumber.ContractId     AS ContractFromId
           , View_ContractFrom_InvNumber.InvNumber      AS ContractFromName

           , MovementFloat_ChangePercentFrom.ValueData  AS ChangePercentFrom
           , MovementString_Comment.ValueData           AS Comment

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
           
            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercentFrom
                                    ON MovementFloat_ChangePercentFrom.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercentFrom.DescId = zc_MovementFloat_ChangePercentPartner()

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

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN Object as ObjectCurrencycyDocumentInf on ObjectCurrencycyDocumentInf.descid= zc_Object_Currency()
                                            and ObjectCurrencycyDocumentInf.id = 14461

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindFrom
                                         ON MovementLinkObject_PaidKindFrom.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKindFrom.DescId = zc_MovementLinkObject_PaidKindFrom()
            LEFT JOIN Object AS Object_PaidKindFrom ON Object_PaidKindFrom.Id = MovementLinkObject_PaidKindFrom.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom
                                         ON MovementLinkObject_ContractFrom.MovementId = Movement.Id
                                        AND MovementLinkObject_ContractFrom.DescId = zc_MovementLinkObject_ContractFrom()
            LEFT JOIN Object_Contract_InvNumber_View AS View_ContractFrom_InvNumber ON View_ContractFrom_InvNumber.ContractId = MovementLinkObject_ContractFrom.ObjectId

         WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_ReturnOut();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_ReturnOut (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.     Манько Д.А.
 24.07.14         * add zc_MovementFloat_CurrencyValue
                        zc_MovementLinkObject_CurrencyDocument
                        zc_MovementLinkObject_CurrencyPartner
 10.02.14                                                            *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ReturnOut (inMovementId:= 1, inOperDate:='01.01.2014', inSession:= '2')
