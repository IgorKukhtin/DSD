-- Function: gpSelect_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpSelect_Movement_TaxCorrective (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxCorrective(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inIsRegisterDate Boolean ,
    IN inIsErased       Boolean ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean, Registered Boolean, DateRegistered TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar, OKPO_From TVarChar, ToId Integer, ToName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , ContractId Integer, ContractName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , DocumentMasterId Integer, InvNumber_Master TVarChar
             , DocumentChildId Integer, InvNumber_Child TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TaxCorrective());
     vbUserId:= inSession;

     --
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
     SELECT
             Movement.Id				AS Id
           , Movement.InvNumber				AS InvNumber
           , Movement.OperDate				AS OperDate
           , Object_Status.ObjectCode    		AS StatusCode
           , Object_Status.ValueData     		AS StatusName
           , MovementBoolean_Checked.ValueData          AS Checked
           , MovementBoolean_Document.ValueData         AS Document
           , MovementBoolean_Registered.ValueData       AS Registered
           , MovementDate_DateRegistered.ValueData      AS DateRegistered
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , Object_From.Id                    		AS FromId
           , Object_From.ValueData             		AS FromName
           , ObjectHistory_JuridicalDetails_View.OKPO   AS OKPO_From
           , Object_To.Id                      		AS ToId
           , Object_To.ValueData               		AS ToName
           , Object_Partner.ObjectCode                  AS PartnerCode
           , Object_Partner.ValueData               	AS PartnerName
           , View_Contract_InvNumber.ContractId        		AS ContractId
           , View_Contract_InvNumber.invnumber         		AS ContractName
           , Object_TaxKind.Id                		AS TaxKindId
           , Object_TaxKind.ValueData         		AS TaxKindName
           , Movement_DocumentMaster.Id                                    AS DocumentMasterId
           , CAST (CASE WHEN Movement_DocumentMaster.StatusId = zc_Enum_Status_Erased() THEN '***' ELSE '' END || Movement_DocumentMaster.InvNumber AS TVarChar)          AS InvNumber_Master
           , Movement_DocumentChild.Id                                     AS DocumentChildId
           , CAST (CASE WHEN Movement_DocumentChild.StatusId = zc_Enum_Status_Erased() THEN '***' ELSE '' END || MS_DocumentChild_InvNumberPartner.ValueData AS TVarChar) AS InvNumber_Child
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName

       FROM (SELECT Movement.id FROM  tmpStatus
               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_TaxCorrective() AND Movement.StatusId = tmpStatus.StatusId
               WHERE inIsRegisterDate = FALSE

             UNION ALL SELECT MovementDate_DateRegistered.movementid  AS Id FROM MovementDate AS MovementDate_DateRegistered
                        JOIN Movement ON Movement.Id = MovementDate_DateRegistered.MovementId AND Movement.DescId = zc_Movement_TaxCorrective()
                        JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                       WHERE inIsRegisterDate = TRUE AND MovementDate_DateRegistered.ValueData BETWEEN inStartDate AND inEndDate
                         AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
            ) AS tmpMovement

            JOIN Movement ON Movement.id = tmpMovement.id
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

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_From.Id

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
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_DocumentMaster
                                           ON MovementLinkMovement_DocumentMaster.MovementId = Movement.Id
                                          AND MovementLinkMovement_DocumentMaster.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_DocumentMaster.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_DocumentChild
                                           ON MovementLinkMovement_DocumentChild.MovementId = Movement.Id
                                          AND MovementLinkMovement_DocumentChild.DescId = zc_MovementLinkMovement_Child()

            LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_DocumentChild.MovementChildId
            LEFT JOIN MovementString AS MS_DocumentChild_InvNumberPartner ON MS_DocumentChild_InvNumberPartner.MovementId = MovementLinkMovement_DocumentChild.MovementChildId
                                                                         AND MS_DocumentChild_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TaxCorrective (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.03.14                                        * add TotalSummVAT
 23.03.14                                        * add Object_InfoMoney_View
 20.03.14                                        * add all
 03.03.14                                                        *
 10.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TaxCorrective (inStartDate:= '30.01.2014', inEndDate:= '12.12.2014', inIsRegisterDate:=FALSE, inIsErased :=TRUE, inSession:= '2')