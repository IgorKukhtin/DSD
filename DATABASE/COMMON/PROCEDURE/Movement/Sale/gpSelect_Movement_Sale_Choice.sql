-- Function: gpSelect_Movement_Sale_Choice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Choice (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Choice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsPartnerDate Boolean ,
    IN inIsErased      Boolean ,
    IN inPartnerId     Integer,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , Checked Boolean
             , PriceWithVAT Boolean
             , PaymentDate TDateTime
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountTare TFloat, TotalCountSh TFloat, TotalCountKg TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSummChange TFloat, TotalSumm TFloat, TotalSummCurrency TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , InvNumberOrder TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , JuridicalName_To TVarChar, OKPO_To TVarChar, RetailName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar, RouteName TVarChar, PersonalName TVarChar
             , PriceListName TVarChar
             , CurrencyDocumentName TVarChar, CurrencyPartnerName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MovementId_Master Integer, InvNumberPartner_Master TVarChar
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
             , OperDate_TransportGoods_calc TDateTime
             , isEDI Boolean
             , isElectron Boolean
             , isMedoc Boolean
             , EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean
             , isError Boolean
             , InvNumber_Full TVarChar, DescName TVarChar
             , Comment TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , InvNumber_Transport_Full TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsXleb Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Хлеб!!!
     vbIsXleb:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 131936  AND UserId = vbUserId);


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId WHERE vbIsXleb = TRUE
                              )
        , tmpBranchJuridical_all AS (SELECT DISTINCT ObjectLink_Juridical.ChildObjectId AS JuridicalId, COALESCE (ObjectLink_Unit.ChildObjectId, 0) AS UnitId
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
        , tmpBranchJuridical AS (SELECT DISTINCT tmpBranchJuridical_all.JuridicalId, tmpBranchJuridical_all.UnitId
                                 FROM tmpBranchJuridical_all

                                UNION
                                 SELECT DISTINCT OL_JuridicalGroup.ObjectId AS JuridicalId, 0 AS UnitId
                                 FROM ObjectLink AS OL_JuridicalGroup
                                      LEFT JOIN tmpBranchJuridical_all ON tmpBranchJuridical_all.JuridicalId = OL_JuridicalGroup.ObjectId
                                 WHERE OL_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                                   AND OL_JuridicalGroup.ChildObjectId IN (SELECT DISTINCT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId)
                                   -- если нет
                                   AND tmpBranchJuridical_all.JuridicalId IS NULL

                                UNION
                                 SELECT Object_Juridical.Id AS JuridicalId, 0 AS UnitId
                                 FROM Object AS Object_Juridical
                                      LEFT JOIN tmpBranchJuridical_all ON tmpBranchJuridical_all.JuridicalId = Object_Juridical.Id
                                 WHERE Object_Juridical.Id IN (7314357) -- М'ЯСНА ВЕСНА  ТОРГІВЕЛЬНИЙ БУДИНОК ТОВ 
                                   AND Object_Juridical.DescId = zc_Object_Juridical()
                                   -- если нет
                                   AND tmpBranchJuridical_all.JuridicalId IS NULL
                                )
        --документы Заявка на возврат тары
       /*  --не должно здесь біть
       
       , tmpOrderReturnTare AS (SELECT DISTINCT Movement.Id
                                 FROM tmpStatus
                                      JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                   AND Movement.DescId = zc_Movement_OrderReturnTare()
                                                   AND Movement.StatusId = tmpStatus.StatusId
                                     -- JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
                                      JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE

                                      INNER JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                                       ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                                                                      AND (MILinkObject_Partner.ObjectId = inPartnerId OR inPartnerId = 0) 
                                 )
       */

     SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
--           , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
           , Movement.OperDate                              AS OperDate
           --, Object_Status.ObjectCode                       AS StatusCode
           --, Object_Status.ValueData                        AS StatusName
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) AS Checked
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT

           , NULL :: TDateTime                              AS PaymentDate
           , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner

           , MovementFloat_VATPercent.ValueData             AS VATPercent
           , MovementFloat_ChangePercent.ValueData          AS ChangePercent
           , MovementFloat_TotalCount.ValueData             AS TotalCount
           , MovementFloat_TotalCountPartner.ValueData      AS TotalCountPartner
           , MovementFloat_TotalCountTare.ValueData         AS TotalCountTare
           , MovementFloat_TotalCountSh.ValueData           AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData           AS TotalCountKg
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData          AS TotalSummPVAT
           , MovementFloat_TotalSummChange.ValueData        AS TotalSummChange
           , MovementFloat_TotalSumm.ValueData              AS TotalSumm
           , NULL :: TFloat                                 AS TotalSummCurrency

           , NULL :: TFloat                                 AS CurrencyValue
           , NULL :: TFloat                                 AS ParValue
           , NULL :: TFloat                                 AS CurrencyPartnerValue
           , NULL :: TFloat                                 AS ParPartnerValue

           , MovementString_InvNumberOrder.ValueData        AS InvNumberOrder
           , Object_From.Id                                 AS FromId
           , Object_From.ValueData                          AS FromName
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , View_Contract_InvNumber.ContractId             AS ContractId
           , View_Contract_InvNumber.ContractCode           AS ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractName
           , View_Contract_InvNumber.ContractTagName
           , Object_JuridicalTo.ValueData                   AS JuridicalName_To
           , NULL :: TVarChar                               AS OKPO_To
           , Object_Retail.ValueData                        AS RetailName
           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName
           , NULL :: Integer                                AS RouteSortingId
           , NULL :: TVarChar                               AS RouteSortingName
           , NULL :: TVarChar                               AS RouteName
           , NULL :: TVarChar                               AS PersonalName
           , NULL :: TVarChar                               AS PriceListName
           , NULL :: TVarChar                               AS CurrencyDocumentName
           , NULL :: TVarChar                               AS CurrencyPartnerName
           , NULL :: Integer                                AS DocumentTaxKindId
           , NULL :: TVarChar                               AS DocumentTaxKindName
           , NULL :: Integer                                AS MovementId_Master
           , NULL :: TVarChar                               AS InvNumberPartner_Master

           , NULL :: Integer                                AS MovementId_TransportGoods
           , NULL :: TVarChar                               AS InvNumber_TransportGoods
           , NULL :: TDateTime                              AS OperDate_TransportGoods
           , NULL :: TDateTime                              AS OperDate_TransportGoods_calc

           , NULL :: Boolean                                          AS isEDI
           , NULL :: Boolean                                          AS isElectron
           , NULL :: Boolean                                          AS isMedoc

           , NULL :: Boolean                                          AS EdiOrdspr
           , NULL :: Boolean                                          AS EdiInvoice
           , NULL :: Boolean                                          AS EdiDesadv

           , NULL :: Boolean                                          AS isError

           , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) ) AS InvNumber_Full
           , MovementDesc.ItemName                  AS DescName
           , MovementString_Comment.ValueData       AS Comment

           , Object_ReestrKind.Id             		    AS ReestrKindId
           , Object_ReestrKind.ValueData       		    AS ReestrKindName
           
           , zfCalc_PartionMovementName (Movement_Transport.DescId, MovementDesc_Transport.ItemName, Movement_Transport.InvNumber, Movement_Transport.OperDate) ::TVarChar AS InvNumber_Transport_Full

       FROM (SELECT Movement.Id                      AS Id
                  , MovementLinkObject_From.ObjectId AS FromId
                  , MovementLinkObject_To.ObjectId   AS ToId
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Sale() AND Movement.StatusId = tmpStatus.StatusId
                  LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                               AND (MovementLinkObject_To.ObjectId   = inPartnerId OR COALESCE (inPartnerId, 0) = 0)
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical 
                                       ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                      AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                  LEFT JOIN tmpBranchJuridical ON tmpBranchJuridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             WHERE inIsPartnerDate = FALSE
               AND (tmpBranchJuridical.UnitId = MovementLinkObject_From.ObjectId OR COALESCE (tmpBranchJuridical.UnitId, 0) = 0
                 OR tmpRoleAccessKey.AccessKeyId > 0
               --OR inPartnerId > 0
                   )
               AND (tmpBranchJuridical.JuridicalId > 0 OR tmpRoleAccessKey.AccessKeyId > 0) -- OR inPartnerId > 0

            UNION ALL
             SELECT MovementDate_OperDatePartner.MovementId AS Id
                  , MovementLinkObject_From.ObjectId        AS FromId
                  , MovementLinkObject_To.ObjectId          AS ToId
             FROM MovementDate AS MovementDate_OperDatePartner
                  JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId AND Movement.DescId = zc_Movement_Sale()
                  JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                  LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = MovementDate_OperDatePartner.MovementId
                                               AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                               AND (MovementLinkObject_To.ObjectId   = inPartnerId OR COALESCE (inPartnerId, 0) = 0)
                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical 
                                       ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                      AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                  LEFT JOIN tmpBranchJuridical ON tmpBranchJuridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             WHERE inIsPartnerDate = TRUE
               AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
               AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

               AND (tmpBranchJuridical.UnitId = MovementLinkObject_From.ObjectId OR COALESCE (tmpBranchJuridical.UnitId, 0) = 0
                 OR tmpRoleAccessKey.AccessKeyId > 0
               --OR inPartnerId > 0
                   )
               AND (tmpBranchJuridical.JuridicalId > 0 OR tmpRoleAccessKey.AccessKeyId > 0) --  OR inPartnerId > 0

            /*UNION ALL
            --Заявка на возврат тары
             SELECT tmpOrderReturnTare.Id
                  , inPartnerId AS ToId
             FROM tmpOrderReturnTare  
             */
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.Id
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId


            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
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

            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId

            LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            --
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Transport ON MovementDesc_Transport.Id = Movement_Transport.DescId
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.04.15         *
*/

-- тест
-- select * from gpSelect_Movement_Sale_Choice(instartdate := ('07.01.2022')::TDateTime , inenddate := ('07.01.2022')::TDateTime , inIsPartnerDate := 'False' , inIsErased := 'False' , inPartnerId := 0 ,  inSession := '5');
