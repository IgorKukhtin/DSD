-- Function: gpSelect_Movement_Tax()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_Tax (TDateTime, TDateTime, Boolean, Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Tax (TDateTime, TDateTime, Integer, Boolean, Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Tax(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer , -- Главное юр.лицо
    IN inIsRegisterDate   Boolean ,
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean, Document Boolean, DateRegistered TDateTime, DateRegistered_notNull TDateTime, InvNumberRegistered TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat
             , TotalCount TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , InvNumberPartner Integer
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName_inf TVarChar, ToName TVarChar, RetailName_To TVarChar, OKPO_To TVarChar, OKPO_Retail TVarChar
             , INN_To TVarChar
             , UnitCode Integer, UnitName TVarChar, PartnerCode Integer, PartnerName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar , ContractName_detail TVarChar
             , TaxKindId Integer, TaxKindName TVarChar
             , InvNumber_Master TVarChar, OperDatePartner_Master TDateTime, isError Boolean
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , InvNumberBranch TVarChar, BranchName TVarChar
             , isEDI Boolean
             , isElectron Boolean
             , isMedoc Boolean
             , isCopy Boolean
             , isINN Boolean
             , isOKPO_Retail Boolean
             , Comment TVarChar 
             , PersonalSigningName TVarChar
             , PersonalCode_Collation Integer
             , PersonalName_Collation TVarChar
             , UnitName_Collation TVarChar
             , BranchName_Collation TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , isDisableNPP Boolean
             , isAuto Boolean
             , isUKTZ_new Boolean
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
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentTaxAll()
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
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Tax() AND Movement.StatusId = tmpStatus.StatusId
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
                         UNION ALL
                          SELECT MovementDate_DateRegistered.MovementId       AS Id
                               , MovementLinkObject_Branch.ObjectId           AS BranchId
                               , MovementLinkObject_DocumentTaxKind.ObjectId  AS DocumentTaxKindId
                          FROM MovementDate AS MovementDate_DateRegistered
                               JOIN Movement ON Movement.Id = MovementDate_DateRegistered.MovementId AND Movement.DescId = zc_Movement_Tax()
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
                            -- AND (vbUserId <> 5 OR COALESCE (Movement.AccessKeyId, 0) = 0)
                         ) 
          --
        , tmpMLO_Contract AS (SELECT MovementLinkObject_Contract.*
                              FROM MovementLinkObject AS MovementLinkObject_Contract
                              WHERE MovementLinkObject_Contract.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract() 
                                AND COALESCE (MovementLinkObject_Contract.ObjectId,0) > 0
                              )   

          -- договора  zc_MI_Detail
        , tmpMIDetail AS (SELECT tmp.MovementId
                               , STRING_AGG (DISTINCT Object_Contract.ValueData, ';')    AS ContractName_detail
                               , STRING_AGG (DISTINCT Object_ContractTag.ValueData, ';') AS ContractTagName_detail 
                          FROM (SELECT MovementItem.MovementId
                                     , MovementItem.ObjectId
                                FROM MovementItem
                                WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement) 
                                  AND MovementItem.DescId = zc_MI_Detail()
                                  AND MovementItem.isErased = FALSE 
                                  AND COALESCE (MovementItem.ObjectId,0) > 0 
                              UNION
                                SELECT tmpMLO_Contract.MovementId
                                     , tmpMLO_Contract.ObjectId
                                FROM tmpMLO_Contract
                          ) AS tmp
                             INNER JOIN Object AS Object_Contract ON Object_Contract.Id = tmp.ObjectId
                             
                             LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                                  ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                                 AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                             LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                          GROUP BY tmp.MovementId
                          )
         -- Сотрудник (бухгалтер) подписант
       , tmpBranch_PersonalBookkeeper AS (SELECT Object_PersonalBookkeeper_View.MemberId
                                               , MAX (ObjectString_PersonalBookkeeper.ValueData) AS PersonalBookkeeperName
                                          FROM Object AS Object_Branch
                                               -- Сотрудник (бухгалтер)
                                               LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                                                    ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                                                   AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
                                               LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
                                               -- Сотрудник (бухгалтер) подписант
                                               INNER JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                                                       ON ObjectString_PersonalBookkeeper.ObjectId  = Object_Branch.Id
                                                                      AND ObjectString_PersonalBookkeeper.DescId    = zc_objectString_Branch_PersonalBookkeeper()
                                                                      AND ObjectString_PersonalBookkeeper.ValueData <> ''
                                          WHERE Object_Branch.DescId   = zc_Object_Branch()
                                            AND Object_Branch.isErased = FALSE
                                          GROUP BY Object_PersonalBookkeeper_View.MemberId
                                         )
     -- Результат
     SELECT
             Movement.Id                                AS Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate	                        AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean          AS Checked
           , COALESCE (MovementBoolean_Document.ValueData, FALSE) :: Boolean         AS Document
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
           , Object_From.ValueData             		    AS FromName
           , Object_To.Id                      		    AS ToId
           , Object_To.ValueData               		    AS ToName_inf
           , ObjectHistory_JuridicalDetails_View.FullName ::TVarChar AS ToName        --берем из истории
           , Object_Retail_To.ValueData                 AS RetailName_To
           , ObjectHistory_JuridicalDetails_View.OKPO       AS OKPO_To
           , ObjectString_Retail_OKPO.ValueData             AS OKPO_Retail
           , CASE WHEN Movement.Id IN (-- Tax
                                       6922620
                                     , 6922564
                                     , 6922609
                                     , 6922233
                                     , 6921599
                                     , 6922367
                                     , 6922254
                                     , 6922275
                                     , 8484674
                                     , 8486085
                                     , 8486839
                                     , 8487001
                                     , 8487359
                                      )
                  THEN '100000000000'
                  ELSE COALESCE (MovementString_ToINN.ValueData, ObjectHistory_JuridicalDetails_View.INN)
                  -- ELSE ObjectHistory_JuridicalDetails_View.INN
             END :: TVarChar AS INN_To

           , Object_From_Master.ObjectCode              AS UnitCode
           , Object_From_Master.ValueData               AS UnitName
           , Object_Partner.ObjectCode                  AS PartnerCode
           , Object_Partner.ValueData               	AS PartnerName

           , View_Contract_InvNumber.ContractId        	AS ContractId
           , View_Contract_InvNumber.ContractCode     	AS ContractCode
           --, View_Contract_InvNumber.InvNumber         	AS ContractName
           --, View_Contract_InvNumber.ContractTagName
           , tmpMIDetail.ContractName_detail     ::TVarChar AS ContractName
           , tmpMIDetail.ContractTagName_detail  ::TVarChar AS ContractTagName
           , tmpMIDetail.ContractName_detail ::TVarChar AS ContractName_detail
           , Object_TaxKind.Id                	        AS TaxKindId
           , Object_TaxKind.ValueData         	        AS TaxKindName
           , Movement_DocumentMaster.InvNumber          AS InvNumber_Master
           , MovementDate_OperDatePartner_Master.ValueData AS OperDatePartner_Master
           , CAST (CASE WHEN MovementLinkMovement_Master.MovementChildId IS NOT NULL
                              AND (Movement_DocumentMaster.StatusId <> zc_Enum_Status_Complete()
                                OR MovementDate_OperDatePartner_Master.ValueData <> Movement.OperDate
                                OR (COALESCE (MovementLinkObject_Partner.ObjectId, -1) <> COALESCE (MovementLinkObject_To_Master.ObjectId, -2)
                                    AND Movement_DocumentMaster.DescId <> zc_Movement_TransferDebtOut())
                                OR COALESCE (MovementLinkObject_Contract.ObjectId, -1) <> COALESCE (MovementLinkObject_Contract_Master.ObjectId, -2)
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

           , COALESCE (MovementLinkMovement_Tax.MovementChildId, 0) <> 0       AS isEDI
           , COALESCE (MovementBoolean_Electron.ValueData, FALSE)              AS isElectron
           , COALESCE (MovementBoolean_Medoc.ValueData, FALSE)                 AS isMedoc
           , COALESCE (MovementBoolean_isCopy.ValueData, FALSE)    :: Boolean  AS isCopy
           , CASE WHEN COALESCE (MovementString_ToINN.ValueData, '') <> '' THEN TRUE ELSE FALSE END AS isINN
           , CASE WHEN COALESCE (ObjectString_Retail_OKPO.ValueData, '') <> '' THEN TRUE ELSE FALSE END AS isOKPO_Retail
           , MovementString_Comment.ValueData         AS Comment

             -- Сотрудник подписант
           , COALESCE (-- контрагент - замена
                       tmpBranch_PersonalBookkeeper_partner.PersonalBookkeeperName
                       -- контрагент
                     , Object_PersonalSigning_partner.PersonalName
                        -- договор - замена
                     , tmpBranch_PersonalBookkeeper.PersonalBookkeeperName
                       -- договор
                     , Object_PersonalSigning.PersonalName
                       -- филиал - Сотрудник (бухгалтер) подписант
                     , ObjectString_PersonalBookkeeper.ValueData
                       -- филиал - Сотрудник (бухгалтер)
                     , Object_PersonalBookkeeper_View.PersonalName
                     , '')  ::TVarChar AS PersonalSigningName
           
           , Object_PersonalCollation.PersonalCode AS PersonalCode_Collation
           , Object_PersonalCollation.PersonalName AS PersonalName_Collation
           , Object_PersonalCollation.UnitName     AS UnitName_Collation
           , Object_PersonalCollation.BranchName   AS BranchName_Collation

           , Object_ReestrKind.Id                     AS ReestrKindId
           , Object_ReestrKind.ValueData              AS ReestrKindName
           
           , COALESCE (MovementBoolean_DisableNPP_auto.ValueData, FALSE) :: Boolean AS isDisableNPP
           , COALESCE (MovementBoolean_isAuto.ValueData, FALSE)          :: Boolean AS isAuto
           , COALESCE (MovementBoolean_isUKTZ_new.ValueData, FALSE)      :: Boolean AS isUKTZ_new

       FROM tmpMovement

            JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_ToINN
                                     ON MovementString_ToINN.MovementId = Movement.Id
                                    AND MovementString_ToINN.DescId = zc_MovementString_ToINN()
                                    AND MovementString_ToINN.ValueData  <> ''

            LEFT JOIN MovementBoolean AS MovementBoolean_isCopy
                                      ON MovementBoolean_isCopy.MovementId = Movement.Id
                                     AND MovementBoolean_isCopy.DescId = zc_MovementBoolean_isCopy()

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId = Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId =  Movement.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

            LEFT JOIN MovementBoolean AS MovementBoolean_DisableNPP_auto
                                      ON MovementBoolean_DisableNPP_auto.MovementId = Movement.Id
                                     AND MovementBoolean_DisableNPP_auto.DescId = zc_MovementBoolean_DisableNPP_auto()

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_Medoc
                                      ON MovementBoolean_Medoc.MovementId =  Movement.Id
                                     AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
            LEFT JOIN MovementBoolean AS MovementBoolean_isUKTZ_new
                                      ON MovementBoolean_isUKTZ_new.MovementId = Movement.Id
                                     AND MovementBoolean_isUKTZ_new.DescId = zc_MovementBoolean_UKTZ_new()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS ObjectHistory_JuridicalDetails_View
                                                                ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_To.Id
                                                               AND Movement.OperDate >= ObjectHistory_JuridicalDetails_View.StartDate AND Movement.OperDate < ObjectHistory_JuridicalDetails_View.EndDate

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectHistory_JuridicalDetails_View.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail() 
            LEFT JOIN Object AS Object_Retail_To ON Object_Retail_To.Id = ObjectLink_Juridical_Retail.ChildObjectId
            LEFT JOIN ObjectString AS ObjectString_Retail_OKPO
                                   ON ObjectString_Retail_OKPO.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_OKPO.DescId = zc_ObjectString_Retail_OKPO()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
            -- Сотрудник подписант - контрагент
            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalSigning
                                 ON ObjectLink_Partner_PersonalSigning.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_PersonalSigning.DescId   = zc_ObjectLink_Partner_PersonalSigning()
            LEFT JOIN Object_Personal_View AS Object_PersonalSigning_partner ON Object_PersonalSigning_partner.PersonalId = ObjectLink_Partner_PersonalSigning.ChildObjectId   
            -- Сотрудник подписант - замена
            LEFT JOIN tmpBranch_PersonalBookkeeper AS tmpBranch_PersonalBookkeeper_partner ON tmpBranch_PersonalBookkeeper_partner.MemberId = Object_PersonalSigning_partner.MemberId

            LEFT JOIN Object AS Object_Branch  ON Object_Branch.Id  = tmpMovement.BranchId
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = tmpMovement.DocumentTaxKindId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            -- Сотрудник подписант - договор
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                                 ON ObjectLink_Contract_PersonalSigning.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
            LEFT JOIN Object_Personal_View AS Object_PersonalSigning ON Object_PersonalSigning.PersonalId = ObjectLink_Contract_PersonalSigning.ChildObjectId   
            -- Сотрудник подписант - замена
            LEFT JOIN tmpBranch_PersonalBookkeeper ON tmpBranch_PersonalBookkeeper.MemberId = Object_PersonalSigning.MemberId

            -- Сотрудник (бухгалтер) - филиал
            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                 ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
            LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
            -- Сотрудник (бухгалтер) подписант - филиал
            LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                   ON ObjectString_PersonalBookkeeper.ObjectId = Object_Branch.Id
                                  AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()

            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                 ON ObjectLink_Contract_PersonalCollation.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
            LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId


            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId          = zc_MovementLinkMovement_Master()
                                          AND tmpMovement.DocumentTaxKindId               = zc_Enum_DocumentTaxKind_Tax()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Master
                                         ON MovementLinkObject_From_Master.MovementId = MovementLinkMovement_Master.MovementId
                                        AND MovementLinkObject_From_Master.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From_Master ON Object_From_Master.Id = MovementLinkObject_From_Master.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To_Master
                                         ON MovementLinkObject_To_Master.MovementId = MovementLinkMovement_Master.MovementId
                                        AND MovementLinkObject_To_Master.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_Master
                                         ON MovementLinkObject_Contract_Master.MovementId = MovementLinkMovement_Master.MovementId
                                        AND MovementLinkObject_Contract_Master.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_Master
                                   ON MovementDate_OperDatePartner_Master.MovementId =  MovementLinkMovement_Master.MovementId
                                  AND MovementDate_OperDatePartner_Master.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                    AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                           ON MovementLinkMovement_Tax.MovementId = Movement.Id 
                                          AND MovementLinkMovement_Tax.DescId = zc_MovementLinkMovement_Tax()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId = COALESCE (Movement_DocumentMaster.Id, Movement.Id)
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = COALESCE (Movement_DocumentMaster.Id, Movement.Id)
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId    
            
            --
            LEFT JOIN tmpMIDetail ON tmpMIDetail.MovementId = Movement.Id
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.12.21         *
 02.03.18         * add MovementString_ToINN
 01.12.16         * add ReestrKind
 06.10.16         * add inJuridicalBasisId
 06.04.15                        * add InvNumberRegistered, DateRegistered
 15.12.14                        * add isMedoc
 08.10.14         *  dell MovementBoolean_Electron было 2 раза
 12.08.14                                        * add isEDI and isElectron
 03.05.14                                        * add ContractTagName
 01.05.14                                        * InvNumber, InvNumberPartner is Integer
 24.04.14                                                        * add zc_MovementString_InvNumberBranch
 12.04.14                                        * add CASE WHEN ...StatusId = zc_Enum_Status_Erased()
 28.03.14                                        * add TotalSummVAT
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 16.03.14                                        * add all
 03.03.14                                                         *
 09.02.14                                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Tax (inStartDate:= '31.01.2024', inEndDate:= '31.01.2024', inJuridicalBasisId:= 0, inIsRegisterDate:= FALSE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
