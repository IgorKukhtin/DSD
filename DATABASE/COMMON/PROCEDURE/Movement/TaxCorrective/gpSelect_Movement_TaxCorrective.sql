-- Function: gpSelect_Movement_TaxCorrective()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_TaxCorrective (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_TaxCorrective (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxCorrective(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer , -- ������� ��.����
    IN inIsRegisterDate   Boolean ,
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean, DocumentValue TVarChar, DateRegistered TDateTime, DateRegistered_notNull TDateTime, InvNumberRegistered TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , InvNumberPartner Integer
             , FromId Integer, FromName_inf TVarChar, FromName TVarChar, OKPO_From TVarChar, OKPO_Retail TVarChar, INN_From TVarChar , RetailName_From TVarChar
             , ToId Integer, ToName TVarChar
             , PartnerCode Integer, PartnerName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , ContractName_detail TVarChar, ContractName_detail_Child TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , DocumentMasterId Integer, InvNumber_Master TVarChar, InvNumberPartner_Master TVarChar, isPartner Boolean
             , DocumentChildId Integer, OperDate_Child TDateTime, InvNumberPartner_Child TVarChar
             , isError Boolean
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , InvNumberBranch TVarChar, BranchName TVarChar
             , isEDI Boolean
             , isElectron Boolean
             , isMedoc Boolean
             , isCopy Boolean
             , isINN Boolean
             , isOKPO_Retail Boolean
             , isAuto Boolean
             , Comment TVarChar
             , PersonalSigningName TVarChar
             , PersonalCode_Collation Integer
             , PersonalName_Collation TVarChar
             , UnitName_Collation TVarChar
             , BranchName_Collation TVarChar
             , isNPP_calc Boolean, DateisNPP_calc TDateTime
             , isUKTZ_new Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TaxCorrective());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

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
                         -- Zaporozhye
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentZaporozhye())
                              )


        , tmpMovement AS (SELECT Movement.Id
                               , MovementLinkObject_Branch.ObjectId           AS BranchId
                               , MovementLinkObject_DocumentTaxKind.ObjectId  AS DocumentTaxKindId
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate AND Movement.DescId = zc_Movement_TaxCorrective() AND Movement.StatusId = tmpStatus.StatusId
                               LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                                            ON MovementLinkObject_Branch.MovementId = Movement.Id
                                                           AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                            ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                          WHERE inIsRegisterDate = FALSE
                            AND (tmpRoleAccessKey.AccessKeyId > 0
                                 OR (MovementLinkObject_Branch.ObjectId IS NULL AND MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Prepay())
                                 OR COALESCE (Movement.AccessKeyId, 0) = 0
                                 OR MovementLinkObject_Branch.ObjectId IS NULL
                                )
                            AND (vbUserId <> 5 OR vbUserId <> 0 OR COALESCE (Movement.AccessKeyId, 0) = 0)
             
                         UNION ALL
                          SELECT MovementDate_DateRegistered.MovementId       AS Id
                               , MovementLinkObject_Branch.ObjectId           AS BranchId
                               , MovementLinkObject_DocumentTaxKind.ObjectId  AS DocumentTaxKindId
                          FROM MovementDate AS MovementDate_DateRegistered
                               JOIN Movement ON Movement.Id = MovementDate_DateRegistered.MovementId AND Movement.DescId = zc_Movement_TaxCorrective()
                               JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                               LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Branch
                                                            ON MovementLinkObject_Branch.MovementId = Movement.Id
                                                           AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                            ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                          WHERE inIsRegisterDate = TRUE AND MovementDate_DateRegistered.ValueData BETWEEN inStartDate AND inEndDate
                            AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
                            AND (tmpRoleAccessKey.AccessKeyId > 0
                                 OR (MovementLinkObject_Branch.ObjectId IS NULL AND MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Prepay())
                                 OR COALESCE (Movement.AccessKeyId, 0) = 0
                                 OR MovementLinkObject_Branch.ObjectId IS NULL
                                )
                         )
        , tmpMLM_Child AS (SELECT MovementLinkMovement_Child.*
                           FROM MovementLinkMovement AS MovementLinkMovement_Child
                           WHERE MovementLinkMovement_Child.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                           ) 

        --�������� 
        --������� �� ����� ���. ��������� 
        , tmpMLO_Contract_Child AS (SELECT MovementLinkObject_Contract.*
                                    FROM MovementLinkObject AS MovementLinkObject_Contract
                                    WHERE MovementLinkObject_Contract.MovementId IN (SELECT DISTINCT tmpMLM_Child.MovementChildId FROM tmpMLM_Child)
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract() 
                                      AND COALESCE (MovementLinkObject_Contract.ObjectId,0) > 0
                                    )
        , tmpMIDetail_tax AS (SELECT tmp.MovementId
                                   , STRING_AGG (DISTINCT Object_Contract.ValueData, ';') AS ContractName_detail 
                              FROM (SELECT MovementItem.MovementId
                                         , MovementItem.ObjectId
                                    FROM MovementItem
                                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMLM_Child.MovementChildId FROM tmpMLM_Child) 
                                      AND MovementItem.DescId = zc_MI_Detail()
                                      AND MovementItem.isErased = FALSE 
                                      AND COALESCE (MovementItem.ObjectId,0) > 0 
                                  UNION ALL
                                    SELECT tmpMLO_Contract_Child.MovementId
                                         , tmpMLO_Contract_Child.ObjectId
                                    FROM tmpMLO_Contract_Child
                              ) AS tmp
                                 INNER JOIN Object AS Object_Contract ON Object_Contract.Id = tmp.ObjectId
                              GROUP BY tmp.MovementId
                              )
         --������� �� ����� ���. �������������
        , tmpMLO_Contract AS (SELECT MovementLinkObject_Contract.*
                              FROM MovementLinkObject AS MovementLinkObject_Contract
                              WHERE MovementLinkObject_Contract.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract() 
                                AND COALESCE (MovementLinkObject_Contract.ObjectId,0) > 0
                              )   

        , tmpMIDetail_TaxCorrective AS (SELECT tmp.MovementId
                                             , STRING_AGG (DISTINCT Object_Contract.ValueData, ';') AS ContractName_detail 
                                        FROM (SELECT MovementItem.MovementId
                                                   , MovementItem.ObjectId
                                              FROM MovementItem
                                              WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                                AND MovementItem.DescId = zc_MI_Detail()
                                                AND MovementItem.isErased = FALSE 
                                                AND COALESCE (MovementItem.ObjectId,0) > 0 
                                           /* UNION ALL
                                              SELECT tmpMLO_Contract.MovementId
                                                   , tmpMLO_Contract.ObjectId
                                              FROM tmpMLO_Contract  */
                                        ) AS tmp
                                           INNER JOIN Object AS Object_Contract ON Object_Contract.Id = tmp.ObjectId
                                        GROUP BY tmp.MovementId
                                        )
         -- ��������� (���������) ���������
       , tmpBranch_PersonalBookkeeper AS (SELECT Object_PersonalBookkeeper_View.MemberId
                                               , MAX (ObjectString_PersonalBookkeeper.ValueData) AS PersonalBookkeeperName
                                          FROM Object AS Object_Branch
                                               -- ��������� (���������)
                                               LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                                                    ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                                                   AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
                                               LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
                                               -- ��������� (���������) ���������
                                               INNER JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                                                       ON ObjectString_PersonalBookkeeper.ObjectId  = Object_Branch.Id
                                                                      AND ObjectString_PersonalBookkeeper.DescId    = zc_objectString_Branch_PersonalBookkeeper()
                                                                      AND ObjectString_PersonalBookkeeper.ValueData <> ''
                                          WHERE Object_Branch.DescId   = zc_Object_Branch()
                                            AND Object_Branch.isErased = FALSE
                                          GROUP BY Object_PersonalBookkeeper_View.MemberId
                                         )
     -- ���������
     SELECT
             Movement.Id                                AS Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate	                        AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean          AS Checked
           , COALESCE (MovementBoolean_Document.ValueData, FALSE) :: Boolean         AS Document
           , CASE WHEN MovementBoolean_Document.ValueData = TRUE THEN 'V' ELSE '-' END :: TVarChar AS DocumentValue
           , MovementDate_DateRegistered.ValueData      AS DateRegistered
           , COALESCE (MovementDate_DateRegistered.ValueData, inEndDate) :: TDateTime AS DateRegistered_notNull
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
           , Object_From.ValueData             		    AS FromName_inf
           , ObjectHistory_JuridicalDetails_View.FullName AS FromName
           , ObjectHistory_JuridicalDetails_View.OKPO       AS OKPO_From
           , ObjectString_Retail_OKPO.ValueData             AS OKPO_Retail
           , CASE WHEN Movement.Id IN (-- Corr
                                       7943509
                                     , 8066170
                                     , 8066171
                                     , 8066169
                                     , 8464974
                                     , 8465476
                                     , 8465802
                                     , 8479936
                                     , 8462887
                                     , 8462999
                                     , 8463007
                                     , 8488900
                                     , 8464619
                                      )
                  THEN '100000000000'
                  ELSE COALESCE (MovementString_FromINN.ValueData, ObjectHistory_JuridicalDetails_View.INN)
             END :: TVarChar AS INN_From
           , Object_Retail_from.ValueData               AS RetailName_From 
             
           , Object_To.Id                      		    AS ToId
           , Object_To.ValueData               		    AS ToName
           , Object_Partner.ObjectCode                  AS PartnerCode
           , Object_Partner.ValueData               	AS PartnerName
           , View_Contract_InvNumber.ContractId        	AS ContractId
           , View_Contract_InvNumber.ContractCode     	AS ContractCode
           , View_Contract_InvNumber.InvNumber         	AS ContractName
           , View_Contract_InvNumber.ContractTagName     
           , tmpMIDetail_TaxCorrective.ContractName_detail ::TVarChar AS ContractName_detail
           , tmpMIDetail_tax.ContractName_detail           ::TVarChar AS ContractName_detail_Child
           , Object_TaxKind.Id                		    AS TaxKindId
           , Object_TaxKind.ValueData         		    AS TaxKindName
           , Movement_DocumentMaster.Id                 AS DocumentMasterId
           , CASE WHEN Movement_DocumentMaster.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                       THEN COALESCE (Object_StatusMaster.ValueData, '') || ' ' || Movement_DocumentMaster.InvNumber
                  ELSE Movement_DocumentMaster.InvNumber
             END :: TVarChar AS InvNumber_Master
           , CASE WHEN Movement_DocumentMaster.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                       THEN COALESCE (Object_StatusMaster.ValueData, '') || ' ' || MS_InvNumberPartner_DocumentMaster.ValueData
                  ELSE MS_InvNumberPartner_DocumentMaster.ValueData
             END :: TVarChar AS InvNumberPartner_Master
           , COALESCE (MovementBoolean_isPartner.ValueData, FALSE) :: Boolean AS isPartner     -- ������� ��� �������� �� ��������� ��������
           
           , Movement_DocumentChild.Id                   AS DocumentChildId
           , Movement_DocumentChild.OperDate             AS OperDate_Child
           , CASE WHEN Movement_DocumentChild.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                       THEN COALESCE (Object_StatusChild.ValueData, '') || ' ' || MS_InvNumberPartner_DocumentChild.ValueData
                  ELSE MS_InvNumberPartner_DocumentChild.ValueData
             END :: TVarChar AS InvNumberPartner_Master
         --, zfConvert_StringToNumber (MS_InvNumberPartner_DocumentChild.ValueData) AS InvNumberPartner_Child
           , CAST (CASE WHEN (MovementLinkMovement_Master.MovementChildId IS NOT NULL
                              AND (Movement_DocumentMaster.StatusId <> zc_Enum_Status_Complete()
                                OR Movement.OperDate <> CASE WHEN Movement_DocumentMaster.DescId = zc_Movement_ReturnIn() THEN MovementDate_OperDatePartner_Master.ValueData ELSE Movement_DocumentMaster.OperDate END
                                OR (COALESCE (MovementLinkObject_Partner.ObjectId, -1) <> COALESCE (MovementLinkObject_Partner_Master.ObjectId, COALESCE (MovementLinkObject_From_Master.ObjectId, -2))
                                    AND tmpMovement.DocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
                                   )
                                OR COALESCE (MovementLinkObject_From.ObjectId, -1) <> CASE WHEN Movement_DocumentMaster.DescId = zc_Movement_ReturnIn() THEN COALESCE (ObjectLink_Partner_Juridical_Master.ChildObjectId, -2) ELSE COALESCE (MovementLinkObject_From_Master.ObjectId, -2) END
                                OR COALESCE (MovementLinkObject_Contract.ObjectId, -1) <> CASE WHEN Movement_DocumentMaster.DescId = zc_Movement_TransferDebtIn() THEN COALESCE (MovementLinkObject_ContractFrom_Master.ObjectId, -2) ELSE COALESCE (MovementLinkObject_Contract_Master.ObjectId, -2) END
                                OR COALESCE (tmpMovement.DocumentTaxKindId, -1) <> COALESCE (MovementLinkObject_DocumentTaxKind_Master.ObjectId, -2)
                                  )
                             )
                          OR (MovementLinkMovement_Child.MovementChildId IS NOT NULL
                              AND (Movement_DocumentChild.StatusId <> zc_Enum_Status_Complete()
                                OR (COALESCE (MovementLinkObject_Partner.ObjectId, -1) <> COALESCE (MovementLinkObject_Partner_Child.ObjectId, -2)
                                    AND tmpMovement.DocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
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
           , COALESCE (MovementBoolean_Medoc.ValueData, FALSE)    :: Boolean  AS isMedoc
           , COALESCE(MovementBoolean_isCopy.ValueData, FALSE)    :: Boolean  AS isCopy
           , CASE WHEN COALESCE (MovementString_FromINN.ValueData, '') <> '' THEN TRUE ELSE FALSE END AS isINN
           , CASE WHEN COALESCE (ObjectString_Retail_OKPO.ValueData, '') <> '' THEN TRUE ELSE FALSE END AS isOKPO_Retail
           , COALESCE(MovementBoolean_isAuto.ValueData, FALSE)    :: Boolean  AS isAuto

           , MovementString_Comment.ValueData                                 AS Comment

             -- ��������� ���������
           , COALESCE (-- ���������� - ������
                       tmpBranch_PersonalBookkeeper_partner.PersonalBookkeeperName
                       -- ����������
                     , Object_PersonalSigning_partner.PersonalName
                        -- ������� - ������
                     , tmpBranch_PersonalBookkeeper.PersonalBookkeeperName
                       -- �������
                     , Object_PersonalSigning.PersonalName
                       -- ������ - ��������� (���������) ���������
                     , ObjectString_PersonalBookkeeper.ValueData
                       -- ������ - ��������� (���������)
                     , Object_PersonalBookkeeper_View.PersonalName
                     , '')  ::TVarChar AS PersonalSigningName

           , Object_PersonalCollation.PersonalCode AS PersonalCode_Collation
           , Object_PersonalCollation.PersonalName AS PersonalName_Collation
           , Object_PersonalCollation.UnitName     AS UnitName_Collation
           , Object_PersonalCollation.BranchName   AS BranchName_Collation

           , COALESCE (MovementBoolean_NPP_calc.ValueData, FALSE) ::Boolean AS isNPP_calc
           , COALESCE (MovementDate_NPP_calc.ValueData, Null) :: TDateTime  AS DateisNPP_calc

           , COALESCE (MovementBoolean_isUKTZ_new.ValueData, FALSE)      :: Boolean AS isUKTZ_new

       FROM tmpMovement

            JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementBoolean AS MovementBoolean_isCopy
                                      ON MovementBoolean_isCopy.MovementId = Movement.Id
                                     AND MovementBoolean_isCopy.DescId = zc_MovementBoolean_isCopy()

            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId =  Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

            LEFT JOIN MovementBoolean AS MovementBoolean_NPP_calc
                                      ON MovementBoolean_NPP_calc.MovementId = Movement.Id
                                     AND MovementBoolean_NPP_calc.DescId = zc_MovementBoolean_NPP_calc()

            LEFT JOIN MovementDate AS MovementDate_NPP_calc
                                   ON MovementDate_NPP_calc.MovementId =  Movement.Id
                                  AND MovementDate_NPP_calc.DescId = zc_MovementDate_NPP_calc()

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                    AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_FromINN
                                     ON MovementString_FromINN.MovementId = Movement.Id
                                    AND MovementString_FromINN.DescId = zc_MovementString_FromINN()
                                    AND MovementString_FromINN.ValueData  <> ''

            LEFT JOIN MovementBoolean AS MovementBoolean_Medoc
                                      ON MovementBoolean_Medoc.MovementId =  Movement.Id
                                     AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()

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
            -- ��������� ��������� - ����������
            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalSigning
                                 ON ObjectLink_Partner_PersonalSigning.ObjectId = MovementLinkObject_Partner.ObjectId
                                AND ObjectLink_Partner_PersonalSigning.DescId   = zc_ObjectLink_Partner_PersonalSigning()
            LEFT JOIN Object_Personal_View AS Object_PersonalSigning_partner ON Object_PersonalSigning_partner.PersonalId = ObjectLink_Partner_PersonalSigning.ChildObjectId   
            -- ��������� ��������� - ������
            LEFT JOIN tmpBranch_PersonalBookkeeper AS tmpBranch_PersonalBookkeeper_partner ON tmpBranch_PersonalBookkeeper_partner.MemberId = Object_PersonalSigning_partner.MemberId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN Object AS Object_Branch  ON Object_Branch.Id  = tmpMovement.BranchId
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = tmpMovement.DocumentTaxKindId

            LEFT JOIN tmpMLO_Contract AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            -- ��������� ��������� - �������
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                                 ON ObjectLink_Contract_PersonalSigning.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
            LEFT JOIN Object_Personal_View AS Object_PersonalSigning ON Object_PersonalSigning.PersonalId = ObjectLink_Contract_PersonalSigning.ChildObjectId   
            -- ��������� ��������� - ������
            LEFT JOIN tmpBranch_PersonalBookkeeper ON tmpBranch_PersonalBookkeeper.MemberId = Object_PersonalSigning.MemberId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                 ON ObjectLink_Contract_PersonalCollation.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
            LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_DocumentMaster ON MS_InvNumberPartner_DocumentMaster.MovementId = MovementLinkMovement_Master.MovementChildId
                                                                          AND MS_InvNumberPartner_DocumentMaster.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_DocumentMaster.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Master
                                   ON MovementDate_OperDatePartner_Master.MovementId =  MovementLinkMovement_Master.MovementChildId
                                  AND MovementDate_OperDatePartner_Master.DescId = zc_MovementDate_OperDatePartner()
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
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_Master
                                         ON MovementLinkObject_Partner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_Partner_Master.DescId     = zc_MovementLinkObject_Partner()

            LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                      ON MovementBoolean_isPartner.MovementId = Movement_DocumentMaster.Id
                                     AND MovementBoolean_isPartner.DescId = zc_MovementBoolean_isPartner()
                                     
            -- ��������� (���������) - ������
            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                 ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
            LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
            -- ��������� (���������) ��������� - ������
            LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                   ON ObjectString_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                  AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()

            LEFT JOIN tmpMLM_Child AS MovementLinkMovement_Child
                                   ON MovementLinkMovement_Child.MovementId = Movement.Id
                                  AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
            LEFT JOIN Movement AS Movement_DocumentChild ON Movement_DocumentChild.Id = MovementLinkMovement_Child.MovementChildId
            LEFT JOIN MovementString AS MS_InvNumberPartner_DocumentChild ON MS_InvNumberPartner_DocumentChild.MovementId = MovementLinkMovement_Child.MovementChildId
                                                                         AND MS_InvNumberPartner_DocumentChild.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN Object AS Object_StatusChild ON Object_StatusChild.Id = Movement_DocumentChild.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_Child
                                         ON MovementLinkObject_Partner_Child.MovementId = Movement_DocumentChild.Id
                                        AND MovementLinkObject_Partner_Child.DescId     = zc_MovementLinkObject_Partner()

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_Partner_Child.ObjectId)

            LEFT JOIN MovementBoolean AS MovementBoolean_isUKTZ_new
                                      ON MovementBoolean_isUKTZ_new.MovementId = Movement_DocumentChild.Id
                                     AND MovementBoolean_isUKTZ_new.DescId     = zc_MovementBoolean_UKTZ_new()


            LEFT JOIN MovementLinkObject AS MovementLinkObject_To_Child
                                         ON MovementLinkObject_To_Child.MovementId = MovementLinkMovement_Child.MovementChildId
                                        AND MovementLinkObject_To_Child.DescId = zc_MovementLinkObject_To()
            LEFT JOIN tmpMLO_Contract_Child AS MovementLinkObject_Contract_Child
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

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS ObjectHistory_JuridicalDetails_View
                                                                ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_From.Id
                                                               AND COALESCE (Movement_DocumentChild.OperDate, Movement.OperDate) >= ObjectHistory_JuridicalDetails_View.StartDate
                                                               AND COALESCE (Movement_DocumentChild.OperDate, Movement.OperDate) <  ObjectHistory_JuridicalDetails_View.EndDate

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()     
            LEFT JOIN Object AS Object_Retail_from ON Object_Retail_from.Id = ObjectLink_Juridical_Retail.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Retail_OKPO
                                   ON ObjectString_Retail_OKPO.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_OKPO.DescId = zc_ObjectString_Retail_OKPO() 
            
            LEFT JOIN tmpMIDetail_TaxCorrective ON tmpMIDetail_TaxCorrective.MovementId = Movement.Id
            LEFT JOIN tmpMIDetail_tax ON tmpMIDetail_tax.MovementId = MovementLinkMovement_Child.MovementChildId 
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_TaxCorrective (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.04.24         *
 07.12.21         *
 06.10.16         * add inJuridicalBasisId
 04.12.15         * add isPartner
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
-- SELECT * FROM gpSelect_Movement_TaxCorrective (inStartDate:= '01.02.2024', inEndDate:= '01.02.2024', inJuridicalBasisId:= 0, inIsRegisterDate:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
