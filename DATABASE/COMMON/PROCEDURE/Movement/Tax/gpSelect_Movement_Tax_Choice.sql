-- Function: gpSelect_Movement_Tax_Choice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_ByPartner (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Choice (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Tax_Choice(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inIsRegisterDate Boolean ,
    IN inIsErased       Boolean ,
    IN inJuridicalId    Integer,
    IN inPartnerId      Integer,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean, DateRegistered TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , InvNumberPartner TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, OKPO_To TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , Comment TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Tax());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     --
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
     , tmpMovement AS (SELECT Movement.*, MovementLinkObject_To.ObjectId AS ToId, MovementLinkObject_Partner.ObjectId AS PartnerId
                       FROM (SELECT inStartDate AS StartDate, inEndDate AS EndDate, zc_Movement_Tax() AS DescId WHERE inIsRegisterDate = FALSE) AS tmp
                            INNER JOIN Movement ON Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate AND Movement.DescId = tmp.DescId
                            INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_To.ObjectId = inJuridicalId
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                       WHERE inIsRegisterDate = FALSE AND (MovementLinkObject_Partner.ObjectId = inPartnerId OR inPartnerId = 0)
                      UNION ALL
                       SELECT Movement.*, MovementLinkObject_To.ObjectId AS ToId, MovementLinkObject_Partner.ObjectId AS PartnerId
                       FROM (SELECT inStartDate AS StartDate, inEndDate AS EndDate, zc_MovementDate_DateRegistered() AS DescId WHERE inIsRegisterDate = TRUE) AS tmp
                            INNER JOIN MovementDate AS MovementDate_DateRegistered ON MovementDate_DateRegistered.ValueData BETWEEN inStartDate AND inEndDate
                                                                                  AND MovementDate_DateRegistered.DescId = tmp.DescId
                            INNER JOIN Movement ON Movement.Id = MovementDate_DateRegistered.MovementId
                            INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_To.ObjectId = inJuridicalId
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                       WHERE inIsRegisterDate = TRUE AND (MovementLinkObject_Partner.ObjectId = inPartnerId OR inPartnerId = 0)
                       )
     , tmpMovementFloat AS (SELECT * FROM MovementFloat WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement))
     -- Результат
     SELECT
             Movement.Id				AS Id
           , Movement.InvNumber				AS InvNumber
           , Movement.OperDate				AS OperDate
           , Object_Status.ObjectCode    		AS StatusCode
           , Object_Status.ValueData     		AS StatusName
           , MovementBoolean_Checked.ValueData          AS Checked
           , MovementBoolean_Document.ValueData         AS Document
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
           , Object_To.Id                      		AS ToId
           , Object_To.ValueData               		AS ToName
           , ObjectHistory_JuridicalDetails_View.OKPO   AS OKPO_To

           , Object_Unit.ObjectCode                  	AS UnitCode
           , Object_Unit.ValueData               	AS UnitName
           , Object_Partner.Id                          AS PartnerId
           , Object_Partner.ObjectCode                  AS PartnerCode
           , Object_Partner.ValueData               	AS PartnerName

           , View_Contract_InvNumber.ContractId        	AS ContractId
           , View_Contract_InvNumber.ContractCode     	AS ContractCode
           , View_Contract_InvNumber.InvNumber         	AS ContractName
           , View_Contract_InvNumber.ContractTagName
           , Object_TaxKind.Id                		AS TaxKindId
           , Object_TaxKind.ValueData         		AS TaxKindName
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , MovementString_Comment.ValueData       AS Comment

       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId =  Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            
            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()


            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN Object AS Object_To ON Object_To.Id = Movement.ToId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_To.Id

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = Movement.PartnerId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                                          AND MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Tax()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Child
                                         ON MovementLinkObject_From_Child.MovementId = MovementLinkMovement_Master.MovementId
                                        AND MovementLinkObject_From_Child.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_From_Child.ObjectId
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Tax_Choice (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.04.14                                        * add inJuridicalId
 09.04.14                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Tax_Choice (inStartDate:= '30.01.2014', inEndDate:= '02.02.2014', inIsRegisterDate:=FALSE, inIsErased :=TRUE, inJuridicalId:=0, inPartnerId:=0, inSession:= '2')
