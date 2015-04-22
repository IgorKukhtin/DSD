-- Function: gpSelect_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpSelect_Movement_TaxCorrective (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxCorrective(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inIsRegisterDate Boolean ,
    IN inIsErased       Boolean ,
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean, DocumentValue TVarChar, Registered Boolean, DateRegistered TDateTime, InvNumberRegistered TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , InvNumberPartner Integer
             , FromId Integer, FromName TVarChar, OKPO_From TVarChar, ToId Integer, ToName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , DocumentMasterId Integer, InvNumber_Master TVarChar, InvNumberPartner_Master TVarChar
             , DocumentChildId Integer, OperDate_Child TDateTime, InvNumberPartner_Child Integer
             , isError Boolean
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , InvNumberBranch TVarChar, BranchName TVarChar
             , isEDI Boolean
             , isElectron Boolean
             , isMedoc Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TaxCorrective());
     vbUserId:= lpGetUserBySession (inSession);

     --
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentTaxCorrectiveAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                              )
     SELECT
             Movement.Id                                AS Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate	                        AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean          AS Checked
           , COALESCE (MovementBoolean_Document.ValueData, FALSE) :: Boolean         AS Document
           , CASE WHEN MovementBoolean_Document.ValueData = TRUE THEN 'V' ELSE '-' END :: TVarChar AS DocumentValue
           , COALESCE (MovementBoolean_Registered.ValueData, FALSE) :: Boolean       AS Registered
           , MovementDate_DateRegistered.ValueData      AS DateRegistered
           , MovementString_InvNumberRegistered.ValueData   AS InvNumberRegistered
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , zfConvert_StringToNumber (MovementString_InvNumberPartner.ValueData) AS InvNumberPartner
           , Object_From.Id                    		    AS FromId
           , Object_From.ValueData             		    AS FromName
           , ObjectHistory_JuridicalDetails_View.OKPO   AS OKPO_From
           , Object_To.Id                      		    AS ToId
           , Object_To.ValueData               		    AS ToName
           , Object_Partner.ObjectCode                  AS PartnerCode
           , Object_Partner.ValueData               	AS PartnerName
           , View_Contract_InvNumber.ContractId        	AS ContractId
           , View_Contract_InvNumber.ContractCode     	AS ContractCode
           , View_Contract_InvNumber.InvNumber         	AS ContractName
           , View_Contract_InvNumber.ContractTagName
           , Object_TaxKind.Id                		    AS TaxKindId
           , Object_TaxKind.ValueData         		    AS TaxKindName
           , Movement_DocumentMaster.Id                 AS DocumentMasterId
           , Movement_DocumentMaster.InvNumber          AS InvNumber_Master
           , MS_InvNumberPartner_DocumentMaster.ValueData AS InvNumberPartner_Master
           , Movement_DocumentChild.Id                   AS DocumentChildId
           , Movement_DocumentChild.OperDate             AS OperDate_Child
           , zfConvert_StringToNumber (MS_InvNumberPartner_DocumentChild.ValueData) AS InvNumberPartner_Child
           , CAST (CASE WHEN (MovementLinkMovement_Master.MovementChildId IS NOT NULL
                              AND (Movement_DocumentMaster.StatusId <> zc_Enum_Status_Complete()
                                OR Movement.OperDate <> CASE WHEN Movement_DocumentMaster.DescId = zc_Movement_ReturnIn() THEN MovementDate_OperDatePartner_Master.ValueData ELSE Movement_DocumentMaster.OperDate END
                                OR (COALESCE (MovementLinkObject_Partner.ObjectId, -1) <> COALESCE (MovementLinkObject_Partner_Master.ObjectId, COALESCE (MovementLinkObject_From_Master.ObjectId, -2))
                                    AND MovementLinkObject_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
                                   )
                                OR COALESCE (MovementLinkObject_From.ObjectId, -1) <> CASE WHEN Movement_DocumentMaster.DescId = zc_Movement_ReturnIn() THEN COALESCE (ObjectLink_Partner_Juridical_Master.ChildObjectId, -2) ELSE COALESCE (MovementLinkObject_From_Master.ObjectId, -2) END
                                OR COALESCE (MovementLinkObject_Contract.ObjectId, -1) <> CASE WHEN Movement_DocumentMaster.DescId = zc_Movement_TransferDebtIn() THEN COALESCE (MovementLinkObject_ContractFrom_Master.ObjectId, -2) ELSE COALESCE (MovementLinkObject_Contract_Master.ObjectId, -2) END
                                OR COALESCE (MovementLinkObject_DocumentTaxKind.ObjectId, -1) <> COALESCE (MovementLinkObject_DocumentTaxKind_Master.ObjectId, -2)
                                  )
                             )
                          OR (MovementLinkMovement_Child.MovementChildId IS NOT NULL
                              AND (Movement_DocumentChild.StatusId <> zc_Enum_Status_Complete()
                                OR (COALESCE (MovementLinkObject_Partner.ObjectId, -1) <> COALESCE (MovementLinkObject_Partner_Child.ObjectId, -2)
                                    AND MovementLinkObject_DocumentTaxKind.ObjectId NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
                                   )
                                OR COALESCE (MovementLinkObject_From.ObjectId, -1) <> COALESCE (MovementLinkObject_To_Child.ObjectId, -2)
                                OR COALESCE (MovementLinkObject_Contract.ObjectId, -1) <> COALESCE (MovementLinkObject_Contract_Child.ObjectId, -2)
                                  )
                             )
                        THEN TRUE
                        ELSE FALSE
                   END AS Boolean) AS isError
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , MovementString_InvNumberBranch.ValueData AS InvNumberBranch
           , Object_Branch.ValueData                  AS BranchName

           , COALESCE (MovementLinkMovement_ChildEDI.MovementChildId, 0) <> 0 AS isEDI
           , COALESCE (MovementBoolean_Electron.ValueData, FALSE) :: Boolean  AS isElectron
           , COALESCE (MovementBoolean_Medoc.ValueData, FALSE)                AS isMedoc

       FROM (SELECT Movement.Id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate AND Movement.DescId = zc_Movement_TaxCorrective() AND Movement.StatusId = tmpStatus.StatusId
                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
             WHERE inIsRegisterDate = FALSE
            UNION ALL
             SELECT MovementDate_DateRegistered.MovementId AS Id
             FROM MovementDate AS MovementDate_DateRegistered
                  JOIN Movement ON Movement.Id = MovementDate_DateRegistered.MovementId AND Movement.DescId = zc_Movement_TaxCorrective()
                  JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
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

            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                    AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()

            LEFT JOIN MovementBoolean AS MovementBoolean_Medoc
                                      ON MovementBoolean_Medoc.MovementId =  Movement.Id
                                     AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()

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

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_DocumentMaster ON MS_InvNumberPartner_DocumentMaster.MovementId = MovementLinkMovement_Master.MovementChildId
                                                                          AND MS_InvNumberPartner_DocumentMaster.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Master
                                   ON MovementDate_OperDatePartner_Master.MovementId =  MovementLinkMovement_Master.MovementChildId
                                  AND MovementDate_OperDatePartner_Master.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_Master
                                         ON MovementLinkObject_Partner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_Partner_Master.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Master
                                         ON MovementLinkObject_From_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_From_Master.DescId = zc_MovementLinkObject_From()
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical_Master
                                 ON ObjectLink_Partner_Juridical_Master.ObjectId = MovementLinkObject_From_Master.ObjectId
                                AND ObjectLink_Partner_Juridical_Master.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_Master
                                         ON MovementLinkObject_Contract_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_Contract_Master.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractFrom_Master
                                         ON MovementLinkObject_ContractFrom_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_ContractFrom_Master.DescId = zc_MovementLinkObject_ContractFrom()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                         ON MovementLinkObject_DocumentTaxKind_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                         ON MovementLinkObject_Branch.MovementId = Movement.Id
                                        AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MovementLinkObject_Branch.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                           ON MovementLinkMovement_Child.MovementId = Movement.Id
                                          AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
            LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_Child.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_DocumentChild ON MS_InvNumberPartner_DocumentChild.MovementId = MovementLinkMovement_Child.MovementChildId
                                                                         AND MS_InvNumberPartner_DocumentChild.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_Child
                                         ON MovementLinkObject_Partner_Child.MovementId = MovementLinkMovement_Child.MovementChildId
                                        AND MovementLinkObject_Partner_Child.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To_Child
                                         ON MovementLinkObject_To_Child.MovementId = MovementLinkMovement_Child.MovementChildId
                                        AND MovementLinkObject_To_Child.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_Child
                                         ON MovementLinkObject_Contract_Child.MovementId = MovementLinkMovement_Child.MovementId
                                        AND MovementLinkObject_Contract_Child.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId =  Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ChildEDI
                                           ON MovementLinkMovement_ChildEDI.MovementId = Movement.Id 
                                          AND MovementLinkMovement_ChildEDI.DescId = zc_MovementLinkMovement_ChildEDI()
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TaxCorrective (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.04.15                        * add InvNumberRegistered, DateRegistered
 12.08.14                                        * add isEDI and isElectron
 30.07.14                                        * add DocumentValue
 03.05.14                                        * add ContractTagName
 01.05.14                                        * InvNumber, InvNumberPartner, InvNumberPartner_Child is Integer
 24.04.14                                                        * add zc_MovementString_InvNumberBranch
 12.04.14                                        * add CASE WHEN ...StatusId = zc_Enum_Status_Erased()
 28.03.14                                        * add TotalSummVAT
 23.03.14                                        * add Object_InfoMoney_View
 20.03.14                                        * add all
 03.03.14                                                        *
 10.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_TaxCorrective (inStartDate:= '01.02.2014', inEndDate:= '01.02.2014', inIsRegisterDate:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
