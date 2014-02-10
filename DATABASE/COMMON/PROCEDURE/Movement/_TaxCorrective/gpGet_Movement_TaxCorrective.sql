-- Function: gpGet_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpGet_Movement_TaxCorrective (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TaxCorrective(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean, Registered Boolean, DateRegistered TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , ContractId Integer, ContractName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , DocumentMasterId Integer, DocumentMasterName TVarChar
             , DocumentChildId Integer, DocumentChildName TVarChar
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TaxCorrective());

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 									AS Id
             , tmpInvNum.InvNumber                  AS InvNumber
             , inOperDate						 	AS OperDate
             , Object_Status.Code               	AS StatusCode
             , Object_Status.Name              		AS StatusName
             , CAST (False as Boolean)         		AS Checked
             , CAST (False as Boolean)         		AS Document
             , CAST (False as Boolean)        		AS Registered
             , inOperDate         	            	AS DateRegistered
             , CAST (False as Boolean)              AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 as TFloat)                   AS TotalCount
             , CAST (0 as TFloat)                   AS TotalSummMVAT
             , CAST (0 as TFloat)                   AS TotalSummPVAT
             , tmpInvNum.InvNumber                  AS InvNumberPartner
             , 0                     				AS FromId
             , CAST ('' as TVarChar) 				AS FromName
             , 0                     				AS ToId
             , CAST ('' as TVarChar) 				AS ToName
             , 0                     				AS ContractId
             , CAST ('' as TVarChar) 				AS ContractName
             , 0                     				AS TaxKindId
             , CAST ('' as TVarChar) 				AS TaxKindName
             , 0                     				AS DocumentMasterId
             , CAST ('' as TVarChar) 				AS DocumentMasterName
             , 0                     				AS DocumentChildId
             , CAST ('' as TVarChar) 				AS DocumentChildName

          FROM (SELECT CAST (NEXTVAL ('movement_taxcorrective_seq') AS TVarChar) AS InvNumber) AS tmpInvNum
          LEFT JOIN lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status ON 1=1
          LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id								AS Id
           , Movement.InvNumber							AS InvNumber
           , Movement.OperDate							AS OperDate
           , Object_Status.ObjectCode    				AS StatusCode
           , Object_Status.ValueData     				AS StatusName
           , MovementBoolean_Checked.ValueData          AS Checked
           , MovementBoolean_Document.ValueData         AS Document
           , MovementBoolean_Registered.ValueData       AS Registered
           , MovementDate_DateRegistered.ValueData      AS DateRegistered
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , Object_From.Id                    			AS FromId
           , Object_From.ValueData             			AS FromName
           , Object_To.Id                      			AS ToId
           , Object_To.ValueData               			AS ToName
           , Object_Contract.ContractId        			AS ContractId
           , Object_Contract.invnumber         			AS ContractName
           , Object_TaxKind.Id                			AS TaxKindId
           , Object_TaxKind.ValueData         			AS TaxKindName
           , Movement_DocumentMaster.Id                 AS DocumentMasterId
           , CAST(Movement_DocumentMaster.InvNumber as TVarChar) AS DocumentMasterName
           , Movement_DocumentChild.Id                  AS DocumentChildId
           , CAST(Movement_DocumentChild.InvNumber as TVarChar) AS DocumentChildName


       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId =  Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

            LEFT JOIN MovementBoolean AS MovementBoolean_Registered
                                      ON MovementBoolean_Registered.MovementId =  Movement.Id
                                     AND MovementBoolean_Registered.DescId = zc_MovementBoolean_Registered()

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN object_contract_invnumber_view AS Object_Contract ON Object_Contract.contractid = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentMaster
                                         ON MovementLinkObject_DocumentMaster.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentMaster.DescId = zc_MovementLinkObject_DocumentMaster()

            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkObject_DocumentMaster.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentChild
                                         ON MovementLinkObject_DocumentChild.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentChild.DescId = zc_MovementLinkObject_DocumentChild()

            LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkObject_DocumentChild.ObjectId


       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_TaxCorrective();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TaxCorrective (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_TaxCorrective (inMovementId:= 0, inOperDate:=CURRENT_DATE,inSession:= '2')
-- SELECT * FROM gpGet_Movement_TaxCorrective(inMovementId := 40859 , inOperDate := '25.01.2014',  inSession := '5');