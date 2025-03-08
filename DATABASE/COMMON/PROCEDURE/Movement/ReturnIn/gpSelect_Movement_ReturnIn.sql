-- Function: gpSelect_Movement_ReturnIn()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnIn (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ReturnIn (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ReturnIn(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsPartnerDate      Boolean ,
    IN inIsErased           Boolean ,
    IN inJuridicalBasisId   Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , ParentId Integer, InvNumber_Parent TVarChar
             , StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , isPartner Boolean
             , PriceWithVAT Boolean
             , OperDatePartner TDateTime, InvNumberPartner TVarChar, InvNumberMark TVarChar
             , VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountTare TFloat
             , TotalCountSh TFloat, TotalCountKg TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat
             , TotalSummChange TFloat, TotalSumm TFloat
             , CurrencyValue TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , CurrencyDocumentName TVarChar, CurrencyPartnerName TVarChar
             , JuridicalName_From TVarChar, OKPO_From TVarChar, RetailName_From TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , PriceListInId Integer, PriceListInName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MemberId Integer, MemberName TVarChar
             , MemberExpId Integer, MemberExpName TVarChar, MemberExpName_calc TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , SubjectDocId Integer, SubjectDocName TVarChar
             , ReasonName  TVarChar
             , Comment TVarChar
             , isError Boolean
             , isEDI Boolean
             , isList Boolean
             , isPrinted Boolean
             , isPromo Boolean
             , isWeighing_inf Boolean
             , MovementPromo TVarChar

             , MovementId_OrderReturnTare Integer
             , InvNumber_OrderReturnTare  TVarChar
             
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
             , OperDate_TransportGoods_calc TDateTime
             , PersonalDriverName_TTN TVarChar
             , PersonalName_4_TTN TVarChar

             , InsertName TVarChar
             , InsertDate TDateTime
             , InsertMobileDate TDateTime
             , UpdateMobileDate TDateTime
             , PeriodSecMobile Integer
             , MemberInsertName TVarChar
             , UnitCode Integer
             , UnitName TVarChar
             , PositionName TVarChar
             , AccessKeyId Integer
             
             , PersonalSigningName TVarChar
             , PersonalCode_Collation Integer
             , PersonalName_Collation TVarChar
             , UnitName_Collation TVarChar
             , BranchName_Collation TVarChar
             , RouteName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsIrna Boolean;
   DECLARE vbIsXleb Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (vbUserId);

     -- !!!Хлеб!!!
     vbIsXleb:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 131936  AND UserId = vbUserId);

     -- 
     IF inStartDate < DATE_TRUNC ('YEAR', inEndDate) - INTERVAL '2 YEAR'
     THEN
         RAISE EXCEPTION 'Ошибка. Период с <%> по <%> слишком большой.', zfConvert_DateToString (inStartDate), zfConvert_DateToString (inEndDate);
     END IF;


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT Object_RoleAccessKey_View.AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY tmpRoleAccessKey_all.AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId WHERE vbIsXleb = TRUE

                         -- DocumentKrRog + DocumentDnepr
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentKrRog() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr())
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentKrRog())

                         -- Zaporozhye
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentZaporozhye() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentDnepr())
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId
                               WHERE EXISTS (SELECT 1 FROM tmpRoleAccessKey_user WHERE tmpRoleAccessKey_user.AccessKeyId = zc_Enum_Process_AccessKey_DocumentZaporozhye())
                              )
        , tmpBranchJuridical AS (SELECT DISTINCT ObjectLink_Juridical.ChildObjectId AS JuridicalId, COALESCE (ObjectLink_Unit.ChildObjectId, 0) AS UnitId
                                 FROM ObjectLink AS ObjectLink_Juridical
                                      INNER JOIN ObjectLink AS ObjectLink_Branch
                                                            ON ObjectLink_Branch.ObjectId = ObjectLink_Juridical.ObjectId
                                                           AND ObjectLink_Branch.DescId  = zc_ObjectLink_BranchJuridical_Branch()
                                      LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                           ON ObjectLink_Unit.ObjectId = ObjectLink_Juridical.ObjectId
                                                          AND ObjectLink_Unit.DescId = zc_ObjectLink_BranchJuridical_Unit()
                                 WHERE ObjectLink_Juridical.ChildObjectId > 0
                                   AND ObjectLink_Juridical.DescId = zc_ObjectLink_BranchJuridical_Juridical()
                                   AND ObjectLink_Branch.ChildObjectId IN (SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0)
                                )
        , tmpPersonal AS (SELECT lfSelect.MemberId
                               , lfSelect.PersonalId
                               , lfSelect.UnitId
                               , lfSelect.PositionId
                               , lfSelect.BranchId
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                          WHERE lfSelect.Ord = 1
                         )
        , tmpMovement AS (SELECT Movement.Id
                               , Movement.OperDate
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_ReturnIn() AND Movement.StatusId = tmpStatus.StatusId
                               LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                               LEFT JOIN tmpBranchJuridical ON tmpBranchJuridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                                    ON ObjectLink_Unit_Business.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Unit_Business.DescId   = zc_ObjectLink_Unit_Business()

                          WHERE inIsPartnerDate = FALSE
                          --AND (tmpBranchJuridical.UnitId = MovementLinkObject_To.ObjectId OR COALESCE (tmpBranchJuridical.UnitId, 0) = 0)
                            AND (tmpRoleAccessKey.AccessKeyId > 0
                              OR tmpBranchJuridical.JuridicalId > 0
                              OR vbIsIrna IS NULL
                              OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business.ChildObjectId = zc_Business_Irna())
                                )

                         UNION ALL
                          SELECT MovementDate_OperDatePartner.MovementId  AS Id
                               , Movement.OperDate
                          FROM MovementDate AS MovementDate_OperDatePartner
                               JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId AND Movement.DescId = zc_Movement_ReturnIn()
                               JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                               LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                               LEFT JOIN tmpBranchJuridical ON tmpBranchJuridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                                    ON ObjectLink_Unit_Business.ObjectId = MovementLinkObject_To.ObjectId
                                                   AND ObjectLink_Unit_Business.DescId   = zc_ObjectLink_Unit_Business()

                          WHERE inIsPartnerDate = TRUE
                            AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                          --AND (tmpBranchJuridical.UnitId = MovementLinkObject_To.ObjectId OR COALESCE (tmpBranchJuridical.UnitId, 0) = 0)
                            AND (tmpRoleAccessKey.AccessKeyId > 0
                              OR tmpBranchJuridical.JuridicalId > 0
                              OR vbIsIrna IS NULL
                              OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business.ChildObjectId = zc_Business_Irna())
                                )
                         )
        -- Эспедитор из заявки  (найти заявку по PartnerId + OperDatePartner = OperDate из возврата, если вдруг несколько заявок - можно взять МАКС (экспедитор_ФИО))
        , tmpPersonal_Calc AS (SELECT tmp.MovementId
                                    , Object_Personal.ValueData AS PersonalName
                               FROM (
                                     SELECT tmpMovement.Id                             AS MovementId
                                          , MAX (MovementLinkObject_Personal.ObjectId) AS PersonalId
                                     FROM tmpMovement
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     
                                          INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                                  ON MovementDate_OperDatePartner.ValueData = tmpMovement.OperDate
                                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                          INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId AND Movement.DescId = zc_Movement_OrderExternal()
                                     
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_From_Order
                                                                        ON MovementLinkObject_From_Order.MovementId = MovementDate_OperDatePartner.MovementId
                                                                       AND MovementLinkObject_From_Order.DescId = zc_MovementLinkObject_From()
                                                                       AND MovementLinkObject_From_Order.ObjectId = MovementLinkObject_From.ObjectId
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                                        ON MovementLinkObject_Personal.MovementId = MovementLinkObject_From_Order.MovementId
                                                                       AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                                     GROUP BY tmpMovement.Id
                                     ) AS tmp
                               LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmp.PersonalId
                               )

        -- взвешивание контрагент
        , tmpWeighingPartner AS (SELECT DISTINCT Movement.ParentId
                                 FROM Movement
                                 WHERE Movement.ParentId IN (SELECT tmpMovement.Id FROM tmpMovement)
                                   AND Movement.DescId = zc_Movement_WeighingPartner()
                                )
        
        , tmpMI_Detail AS (SELECT tmpMovement.Id AS MovementId
                                , STRING_AGG (DISTINCT Object_Reason.ValueData, '; ') ::TVarChar AS ReasonName
                           FROM tmpMovement
                                INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                       AND MovementItem.DescId     = zc_MI_Detail()
                                                       AND MovementItem.isErased   = FALSE
                                INNER JOIN MovementItemLinkObject AS MILO_Reason
                                                                  ON MILO_Reason.MovementItemId = MovementItem.Id
                                                                 AND MILO_Reason.DescId = zc_MILinkObject_Reason()
                                LEFT JOIN Object AS Object_Reason ON Object_Reason.Id = MILO_Reason.ObjectId
                           GROUP BY tmpMovement.Id
                           )

         , tmpMLM AS (SELECT MovementLinkMovement.*
                      FROM MovementLinkMovement
                      WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                        AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_MasterEDI()
                                                          , zc_MovementLinkMovement_Promo()
                                                          , zc_MovementLinkMovement_OrderReturnTare()
                                                          , zc_MovementLinkMovement_TransportGoods()
                                                           )
                       )

         , tmpMovement_TransportGoods AS (SELECT MovementLinkMovement_TransportGoods.MovementId
                                               , Movement_TransportGoods.*
                                          FROM tmpMLM AS MovementLinkMovement_TransportGoods
                                               LEFT JOIN Movement AS Movement_TransportGoods
                                                                  ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId
                                          WHERE MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
                                         )

         , tmpMLO_PersonalDriver AS (SELECT MovementLinkObject.*
                                     FROM MovementLinkObject
                                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                                       AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalDriver()
                                    )
         , tmpMLO_Personal_4 AS (SELECT MovementLinkObject.*
                                 FROM MovementLinkObject
                                 WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                                   AND MovementLinkObject.DescId = zc_MovementLinkObject_Member4()
                                )
        
       , tmpPersonalDriver AS (SELECT MovementLinkObject_PersonalDriver.MovementId
                                    , Object_PersonalDriver.*
                               FROM tmpMLO_PersonalDriver AS MovementLinkObject_PersonalDriver
                                    LEFT JOIN Object AS Object_PersonalDriver
                                                     ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId
                               )
       , tmpPersonal_4 AS (SELECT MovementLinkObject_Personal_4.MovementId
                                , Object_Personal.*
                           FROM tmpMLO_Personal_4 AS MovementLinkObject_Personal_4
                                LEFT JOIN Object AS Object_Personal
                                                 ON Object_Personal.Id = MovementLinkObject_Personal_4.ObjectId
                          )

       , tmpMLO_Contract AS (SELECT MovementLinkObject.*
                             FROM MovementLinkObject
                             WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                               AND MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
                             )

        , tmpMovementLinkObject_Branch AS (SELECT MovementLinkObject.*
                                             FROM MovementLinkObject
                                             WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                               AND MovementLinkObject.DescId = zc_MovementLinkObject_Branch()
                                             )

        -- данные из Договора
        , tmpContract_param AS (SELECT tmpContract.ContractId
                                     , Object_PersonalSigning.ValueData AS PersonalSigningName
                                     , Object_PersonalCollation.PersonalCode AS PersonalCode_Collation
                                     , Object_PersonalCollation.PersonalName AS PersonalName_Collation
                                     , Object_PersonalCollation.UnitName     AS UnitName_Collation
                                     , Object_PersonalCollation.BranchName   AS BranchName_Collation

                                FROM (SELECT DISTINCT tmpMLO_Contract.ObjectId AS ContractId
                                      FROM tmpMLO_Contract
                                      ) AS tmpContract
                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                                                      ON ObjectLink_Contract_PersonalSigning.ObjectId = tmpContract.ContractId
                                                     AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
                                 LEFT JOIN Object AS Object_PersonalSigning ON Object_PersonalSigning.Id = ObjectLink_Contract_PersonalSigning.ChildObjectId   

                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                                      ON ObjectLink_Contract_PersonalCollation.ObjectId = tmpContract.ContractId
                                                     AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
                                 LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId
                                )
       -- Результат
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Movement.ParentId                          AS ParentId
           , (Movement_Parent.InvNumber || ' от ' || Movement_Parent.OperDate :: Date :: TVarChar ) :: TVarChar AS InvNumber_Parent
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData,   FALSE) :: Boolean AS Checked
           , COALESCE (MovementBoolean_isPartner.ValueData, FALSE) :: Boolean AS isPartner
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementString_InvNumberMark.ValueData     AS InvNumberMark
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalCountPartner.ValueData  AS TotalCountPartner
           , MovementFloat_TotalCountTare.ValueData     AS TotalCountTare
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSummChange.ValueData    AS TotalSummChange
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , CAST (COALESCE (MovementFloat_CurrencyValue.ValueData, 0) AS TFloat)  AS CurrencyValue
           , Object_From.Id                             AS FromId
           , Object_From.ValueData                      AS FromName
           , Object_To.Id                               AS ToId
           , Object_To.ValueData                        AS ToName
           , Object_PaidKind.Id                         AS PaidKindId
           , Object_PaidKind.ValueData                  AS PaidKindName
           , View_Contract_InvNumber.ContractId         AS ContractId
           , View_Contract_InvNumber.ContractCode       AS ContractCode
           , View_Contract_InvNumber.InvNumber          AS ContractName
           , View_Contract_InvNumber.ContractTagName    AS ContractTagName
           , Object_CurrencyDocument.ValueData          AS CurrencyDocumentName
           , Object_CurrencyPartner.ValueData           AS CurrencyPartnerName
           , Object_JuridicalFrom.ValueData             AS JuridicalName_From
           , ObjectHistory_JuridicalDetails_View.OKPO   AS OKPO_From 
           , Object_Retail_from.ValueData               AS RetailName_From
           , View_InfoMoney.InfoMoneyGroupName          AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName    AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode               AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName               AS InfoMoneyName
           , Object_PriceList.Id                        AS PriceListId
           , Object_PriceList.Valuedata                 AS PriceListName
           , Object_PriceListIn.Id                      AS PriceListInId
           , Object_PriceListIn.ValueData               AS PriceListInName
           , Object_TaxKind.Id                	        AS DocumentTaxKindId
           , Object_TaxKind.ValueData        	        AS DocumentTaxKindName
           , Object_Member.Id                           AS MemberId
           , Object_Member.ValueData                    AS MemberName
           , Object_MemberExp.Id                        AS MemberExpId
           , Object_MemberExp.ValueData                 AS MemberExpName
           , tmpPersonal_Calc.PersonalName :: TVarChar  AS MemberExpName_calc
           , Object_ReestrKind.Id             	        AS ReestrKindId
           , Object_ReestrKind.ValueData       	        AS ReestrKindName
           , Object_SubjectDoc.Id                       AS SubjectDocId
           , Object_SubjectDoc.ValueData                AS SubjectDocName
           , tmpMI_Detail.ReasonName
           , MovementString_Comment.ValueData           AS Comment
           , MovementBoolean_Error.ValueData            AS isError
           , COALESCE (MovementLinkMovement_MasterEDI.MovementChildId, 0) <> 0 AS isEDI

           , COALESCE (MovementBoolean_List.ValueData, FALSE) :: Boolean AS isList
           , COALESCE (MovementBoolean_Print.ValueData, False):: Boolean AS isPrinted

           , COALESCE(MovementBoolean_Promo.ValueData, FALSE) AS isPromo
           , CASE WHEN tmpWeighingPartner.ParentId IS NULL THEN FALSE ELSE TRUE END ::Boolean AS isWeighing_inf

           , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndReturn.ValueData) AS MovementPromo
           , Movement_OrderReturnTare.Id                                                                                                    AS MovementId_OrderReturnTare
           , ('№ ' || Movement_OrderReturnTare.InvNumber || ' от ' || Movement_OrderReturnTare.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_OrderReturnTare

           --ТТН
           , Movement_TransportGoods.Id                AS MovementId_TransportGoods
           , Movement_TransportGoods.InvNumber         AS InvNumber_TransportGoods
           , Movement_TransportGoods.OperDate          AS OperDate_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) :: TDateTime AS OperDate_TransportGoods_calc
           , Object_PersonalDriver_TTN.ValueData       AS PersonalDriverName_TTN
           , Object_Personal_4_TTN.ValueData           AS PersonalName_4_TTN
           --

           , Object_User.ValueData                  AS InsertName
           , MovementDate_Insert.ValueData          AS InsertDate
           , MovementDate_InsertMobile.ValueData    AS InsertMobileDate
           , MovementDate_UpdateMobile.ValueData    AS UpdateMobileDate
           , CASE WHEN MovementDate_UpdateMobile.ValueData IS NULL THEN NULL
                  ELSE EXTRACT (SECOND FROM MovementDate_UpdateMobile.ValueData - MovementDate_Insert.ValueData)
                     + 60 * EXTRACT (MINUTE FROM MovementDate_UpdateMobile.ValueData - MovementDate_Insert.ValueData)
                     + 60 * 60 * EXTRACT (HOUR FROM MovementDate_UpdateMobile.ValueData - MovementDate_Insert.ValueData)
             END :: Integer AS PeriodSecMobile
           , CASE WHEN MovementString_GUID.ValueData <> '' THEN Object_MemberInsert.ValueData ELSE '' END :: TVarChar AS MemberInsertName
           , Object_Unit.ObjectCode                 AS UnitCode
           , Object_Unit.ValueData                  AS UnitName
           , CASE WHEN MovementString_GUID.ValueData <> '' THEN Object_Position.ValueData ELSE '' END :: TVarChar AS PositionName
           
           , Movement.AccessKeyId

             -- Сотрудник подписант
           , COALESCE (-- контрагент
                       Object_PersonalSigning_partner.ValueData
                        -- договор
                     , tmpContract_param.PersonalSigningName
                       -- филиал - Сотрудник (бухгалтер) подписант
                     , ObjectString_PersonalBookkeeper.ValueData
                       -- филиал - Сотрудник (бухгалтер)
                     , Object_PersonalBookkeeper.ValueData
                     , '') ::TVarChar AS PersonalSigningName

             -- сверка
           , tmpContract_param.PersonalCode_Collation  ::Integer
           , tmpContract_param.PersonalName_Collation  ::TVarChar
           , tmpContract_param.UnitName_Collation      ::TVarChar
           , tmpContract_param.BranchName_Collation    ::TVarChar
           --
           , Object_Route.ValueData                    ::TVarChar  AS RouteName
       FROM tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.id = Movement.ParentId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Error
                                      ON MovementBoolean_Error.MovementId =  Movement.Id
                                     AND MovementBoolean_Error.DescId = zc_MovementBoolean_Error()
            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                      ON MovementBoolean_isPartner.MovementId = Movement.Id
                                     AND MovementBoolean_isPartner.DescId = zc_MovementBoolean_isPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId = Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

            LEFT JOIN MovementBoolean AS MovementBoolean_List
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId = Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_InsertMobile
                                   ON MovementDate_InsertMobile.MovementId = Movement.Id
                                  AND MovementDate_InsertMobile.DescId = zc_MovementDate_InsertMobile()
            LEFT JOIN MovementDate AS MovementDate_UpdateMobile
                                   ON MovementDate_UpdateMobile.MovementId = Movement.Id
                                  AND MovementDate_UpdateMobile.DescId = zc_MovementDate_UpdateMobile()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId = Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountPartner
                                    ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountTare
                                    ON MovementFloat_TotalCountTare.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChange.DescId = zc_MovementFloat_TotalSummChange()
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
            -- Сотрудник подписант - контрагент
            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalSigning
                                 ON ObjectLink_Partner_PersonalSigning.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_PersonalSigning.DescId   = zc_ObjectLink_Partner_PersonalSigning()
            LEFT JOIN Object AS Object_PersonalSigning_partner ON Object_PersonalSigning_partner.Id = ObjectLink_Partner_PersonalSigning.ChildObjectId
            /*LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Partner_PersonalSigning.ChildObjectId
                                AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
            -- Сотрудник подписант - замена
            LEFT JOIN tmpBranch_PersonalBookkeeper AS tmpBranch_PersonalBookkeeper_partner ON tmpBranch_PersonalBookkeeper_partner.MemberId = ObjectLink_Personal_Member.ChildObjectId*/

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalFrom.Id     
            
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail_From
                                 ON ObjectLink_Juridical_Retail_From.ObjectId = Object_JuridicalFrom.Id
                                AND ObjectLink_Juridical_Retail_From.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail_from ON Object_Retail_from.Id = ObjectLink_Juridical_Retail_From.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMLO_Contract AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member
                                         ON MovementLinkObject_Member.MovementId = Movement.Id
                                        AND MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementLinkObject_Member.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberExp
                                         ON MovementLinkObject_MemberExp.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberExp.DescId = zc_MovementLinkObject_MemberExp()
            LEFT JOIN Object AS Object_MemberExp ON Object_MemberExp.Id = MovementLinkObject_MemberExp.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId

--add Tax
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceListIn
                                         ON MovementLinkObject_PriceListIn.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceListIn.DescId = zc_MovementLinkObject_PriceListIn()
            LEFT JOIN Object AS Object_PriceListIn ON Object_PriceListIn.Id = MovementLinkObject_PriceListIn.ObjectId

            LEFT JOIN tmpMLM AS MovementLinkMovement_MasterEDI
                             ON MovementLinkMovement_MasterEDI.MovementId = Movement.Id
                            AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()

            LEFT JOIN tmpMLM AS MovementLinkMovement_Promo
                             ON MovementLinkMovement_Promo.MovementId = Movement.Id
                            AND MovementLinkMovement_Promo.DescId = zc_MovementLinkMovement_Promo()
            LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MovementLinkMovement_Promo.MovementChildId 

            LEFT JOIN tmpMLM AS MovementLinkMovement_OrderReturnTare
                             ON MovementLinkMovement_OrderReturnTare.MovementId = Movement.Id
                            AND MovementLinkMovement_OrderReturnTare.DescId = zc_MovementLinkMovement_OrderReturnTare()
            LEFT JOIN Movement AS Movement_OrderReturnTare ON Movement_OrderReturnTare.Id = MovementLinkMovement_OrderReturnTare.MovementChildId

            -- ТТН
            LEFT JOIN tmpMovement_TransportGoods AS Movement_TransportGoods ON Movement_TransportGoods.MovementId = Movement.Id
            LEFT JOIN tmpPersonalDriver AS Object_PersonalDriver_TTN ON Object_PersonalDriver_TTN.MovementId =  Movement_TransportGoods.Id
            LEFT JOIN tmpPersonal_4     AS Object_Personal_4_TTN     ON Object_Personal_4_TTN.MovementId     =  Movement_TransportGoods.Id


            LEFT JOIN MovementDate AS MD_StartSale
                                   ON MD_StartSale.MovementId = Movement_Promo.Id
                                  AND MD_StartSale.DescId = zc_MovementDate_StartSale()
            LEFT JOIN MovementDate AS MD_EndReturn
                                   ON MD_EndReturn.MovementId =  Movement_Promo.Id
                                  AND MD_EndReturn.DescId = zc_MovementDate_EndReturn()

           --
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementString AS MovementString_GUID
                                     ON MovementString_GUID.MovementId = Movement.Id
                                    AND MovementString_GUID.DescId = zc_MovementString_GUID()

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                -- AND MovementString_GUID.ValueData <> ''
            LEFT JOIN Object AS Object_MemberInsert ON Object_MemberInsert.Id = ObjectLink_User_Member.ChildObjectId

            LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId

            LEFT JOIN tmpPersonal_Calc ON tmpPersonal_Calc.MovementId = Movement.Id
            
            LEFT JOIN tmpWeighingPartner ON tmpWeighingPartner.ParentId = Movement.Id
            
            LEFT JOIN tmpMI_Detail ON tmpMI_Detail.MovementId = Movement.Id

            LEFT JOIN tmpContract_param ON tmpContract_param.ContractId = MovementLinkObject_Contract.ObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                 ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
            LEFT JOIN Object AS Object_PersonalBookkeeper ON Object_PersonalBookkeeper.Id = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
            LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                   ON ObjectString_PersonalBookkeeper.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                  AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Route
                                 ON ObjectLink_Partner_Route.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Partner_Route.ChildObjectId
         
     /*WHERE vbIsXleb = FALSE OR (View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30103() -- Хлеб
                                AND vbIsXleb = TRUE)*/
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_ReturnIn (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.11.24         *
 16.02.23         * TransportGoods
 28.04.22         * add  OrderReturnTare
 14.03.22         * PriceListIn
 12.05.18         *
 22.04.17         *
 05.10.16         * add inJuridicalBasisId
 14.05.16         *
 21.08.15         * add isPartner
 26.06.15         * add Comment, ParentId
 13.11.14                                        * add zc_Enum_Process_AccessKey_DocumentAll
 12.08.14                                        * add isEDI
 24.07.14         * add zc_MovementFloat_CurrencyValue
                        zc_MovementLinkObject_CurrencyDocument
                        zc_MovementLinkObject_CurrencyPartner
 03.05.14                                        * add ContractTagName
 23.04.14                                        * add InvNumberMark
 31.03.14                                        * add TotalCount...
 28.03.14                                        * add TotalSummVAT
 26.03.14                                        * add InvNumberPartner
 16.03.14                                        * add JuridicalName_From and OKPO_From
 13.02.14                                                            * add PriceList
 10.02.14                                        * add Object_RoleAccessKey_View
 10.02.14                                                       * add TaxKind
 05.02.14                                        * add Object_InfoMoney_View
 30.01.14                                                       * add inIsPartnerDate, inIsErased
 14.01.14                                        * add Object_Contract_InvNumber_View
 11.01.14                                        * add Checked, TotalCountPartner
 17.07.13         *
*/
/*
!!!!!!!!!!!!!!!!!удаление задвоенных накл по филиалам
DO $$
BEGIN
 perform lpSetErased_Movement (a.Id, 5)
  from (
       SELECT Movement.InvNumber, Movement.OperDate, Min (Movement.Id) as Id
       FROM Movement
            JOIN MovementLinkObject AS MovementLinkObject_To
                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                   AND MovementLinkObject_To.ObjectId in (select 18341 as id -- ;22100;"ф. Никополь"
                                                                union all select 8425 as id -- ;22090;"ф. Харьков"
                                                                union all select 8423 as id -- ;22080;"ф. Одесса"
                                                                union all select 8421 as id -- ;22070;"ф. Донецк"
                                                                union all select 8419 as id -- ;22060;"ф. Крым"
                                                                union all select 8417 as id -- ;22050;"ф. Николаев (Херсон)"
                                                                union all select 8415 as id -- ;22040;"ф. Черкассы ( Кировоград)"
                                                                union all select 8413 as id -- ;22030;"ф. Кр.Рог"
                                                                union all select 8411 as id -- ;22021;"Склад гп ф.Киев"
                                                                         )
       where Movement.OperDate BETWEEN '01.04.2014' AND '30.04.2014'
         AND Movement.DescId = zc_Movement_ReturnIn()
         AND Movement.StatusId <> zc_Enum_Status_Erased()
       group by Movement.InvNumber, Movement.OperDate
       having count(*) > 1
) as a ;
END $$;
*/

/*
!!!!!!!!!!!!!!!!!проверка суммы по строкам

              -- данные <Продажа покупателю> и <Возврат от покупателя>
              SELECT 1, sum (MovementFloat_TotalSumm.ValueData)
              FROM MovementDate AS MovementDate_OperDatePartner
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                AND MovementLinkObject_Contract.ObjectId = 882691
                   INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                      AND Movement.DescId   = zc_Movement_ReturnIn()

                   INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                                -- AND MovementLinkObject.ObjectId = vbPartnerId

                   INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                        AND ObjectLink_Partner_Juridical.ChildObjectId = 862910

	    LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

              WHERE MovementDate_OperDatePartner.ValueData BETWEEN '01.11.2016' AND '30.11.2016'
                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

union all
              SELECT 2 -- , sum (MovementFloat_TotalSumm.ValueData)
--  , (coalesce (MIFloat_AmountPartner.ValueData, 0) * coalesce (MIFloat_Price.ValueData, 0)) * 1.2
 , SUM (coalesce (MovementItem_Child.Amount, 0) * coalesce (MIFloat_Price.ValueData, 0)) * 1.2
/ *, Movement.Id, MovementItem.ObjectId as GoodsId, MIFloat_Price.ValueData AS Price, Movement.InvNumber, MovementString.ValueData, Movement.OperDate
, MIFloat_AmountPartner.ValueData AS AmountPartner
, MIFloat_Price.ValueData AS Price_add
, SUM (coalesce (MovementItem_Child.Amount, 0) * coalesce (MIFloat_Price.ValueData, 0)) * 1.2 AS summ * /
              FROM MovementDate AS MovementDate_OperDatePartner
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                AND MovementLinkObject_Contract.ObjectId = 882691
                   INNER JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                      AND Movement.DescId   = zc_Movement_ReturnIn()

                   INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = MovementDate_OperDatePartner.MovementId
                                                AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                                -- AND MovementLinkObject.ObjectId = vbPartnerId
                   LEFT JOIN MovementString ON MovementString.MovementId = MovementDate_OperDatePartner.MovementId
                                           AND MovementString.DescId = zc_MovementString_InvNumberPartner()

                   INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                         ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject.ObjectId
                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                        AND ObjectLink_Partner_Juridical.ChildObjectId = 862910

	               LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                           ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                          AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId   = zc_MI_Master()
                                          AND MovementItem.isErased = FALSE
                   INNER JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               AND MIFloat_Price.ValueData <> 0

                   inner JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                   LEFT JOIN MovementItem AS MovementItem_Child ON MovementItem_Child.MovementId = Movement.Id
                                                               AND MovementItem_Child.isErased = FALSE
                                                               AND MovementItem_Child.DescId   = zc_MI_Child()
                                                               AND MovementItem_Child.ParentId = MovementItem.Id
                                                               AND MovementItem_Child.Amount   <> 0



              WHERE MovementDate_OperDatePartner.ValueData BETWEEN '01.11.2016' AND '30.11.2016'
                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
/ *group by  Movement.Id, MovementItem.ObjectId, MIFloat_Price.ValueData
, MIFloat_AmountPartner.ValueData
, Movement.InvNumber, MovementString.ValueData, Movement.OperDate
, MIFloat_Price.ValueData
having  MIFloat_AmountPartner.ValueData <>  SUM (coalesce (MovementItem_Child.Amount, 0))
* /

-- select lpCheck_Movement_ReturnIn_Auto (4832777, 1);
*/
-- тест
-- SELECT * FROM gpSelect_Movement_ReturnIn (inStartDate:= '01.12.2015', inEndDate:= '01.12.2015', inIsPartnerDate:=FALSE, inIsErased :=TRUE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Movement_ReturnIn (instartdate := ('28.03.2022')::TDateTime , inenddate := ('28.03.2022')::TDateTime , inIsPartnerDate := 'False' , inIsErased := 'False' , inJuridicalBasisId := 9399 ,  inSession := '9457');
