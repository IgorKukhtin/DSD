-- Function: gpSelect_Movement_Sale()

-- DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsPartnerDate      Boolean   ,
    IN inIsErased           Boolean   ,
    IN inJuridicalBasisId   Integer   ,
    IN inSession            TVarChar    -- ������ ������������
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
             , MovementId_Order Integer, InvNumberOrder TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , JuridicalName_To TVarChar, OKPO_To TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteSortingId Integer, RouteSortingName TVarChar, RouteGroupName TVarChar, RouteName TVarChar, PersonalName TVarChar
             , RetailName_order TVarChar
             , PartnerName_order TVarChar
             , PriceListName TVarChar
             , CurrencyDocumentName TVarChar, CurrencyPartnerName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MovementId_Master Integer, InvNumberPartner_Master TVarChar
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
             , OperDate_TransportGoods_calc TDateTime
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, InvNumber_Transport_Full TVarChar
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar
             , isEDI Boolean
             , isElectron Boolean
             , isMedoc Boolean
             , EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean
             , isEdiOrdspr_partner Boolean, isEdiInvoice_partner Boolean, isEdiDesadv_partner Boolean
             , isError Boolean
             , isPrinted Boolean
             , isPromo Boolean
             , MovementPromo TVarChar
             , InsertDate TDateTime
             , Comment TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsXleb Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!����!!!
     vbIsXleb:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 131936  AND UserId = vbUserId);


     -- !!!�.�. ������ ����� ����� ������ � �����!!!
     IF inStartDate + (INTERVAL '100 DAY') <= inEndDate
     THEN
         inStartDate:= inEndDate + (INTERVAL '1 DAY');
     END IF;

     -- ���������
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
        , tmpBranchJuridical AS (SELECT DISTINCT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                 FROM ObjectLink AS ObjectLink_Juridical
                                      INNER JOIN ObjectLink AS ObjectLink_Branch ON ObjectLink_Branch.ObjectId = ObjectLink_Juridical.ObjectId AND ObjectLink_Branch.DescId = zc_ObjectLink_BranchJuridical_Branch()
                                 WHERE ObjectLink_Juridical.ChildObjectId > 0
                                   AND ObjectLink_Juridical.DescId = zc_ObjectLink_BranchJuridical_Juridical()
                                   AND ObjectLink_Branch.ChildObjectId IN (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
                                )
     SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
--           , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           , COALESCE (MovementBoolean_Checked.ValueData, FALSE) AS Checked
           , MovementBoolean_PriceWithVAT.ValueData         AS PriceWithVAT

           , MovementDate_Payment.ValueData                 AS PaymentDate
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
           , MovementFloat_AmountCurrency.ValueData         AS TotalSummCurrency

           , MovementFloat_CurrencyValue.ValueData          AS CurrencyValue
           , MovementFloat_ParValue.ValueData               AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData   AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData        AS ParPartnerValue

           , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order
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
           , ObjectHistory_JuridicalDetails_View.OKPO       AS OKPO_To
           , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

           , Object_RouteSorting.Id                         AS RouteSortingId
           , Object_RouteSorting.ValueData                  AS RouteSortingName
           , Object_RouteGroup.ValueData                    AS RouteGroupName
           , Object_Route.ValueData                         AS RouteName
           , Object_Personal.ValueData                      AS PersonalName
           , Object_Retail_order.ValueData                  AS RetailName_order
           , Object_Partner_order.ValueData                 AS PartnerName_order

           , Object_PriceList.ValueData                     AS PriceListName
           , Object_CurrencyDocument.ValueData              AS CurrencyDocumentName
           , Object_CurrencyPartner.ValueData               AS CurrencyPartnerName
           , Object_TaxKind_Master.Id                	    AS DocumentTaxKindId
           , Object_TaxKind_Master.ValueData         	    AS DocumentTaxKindName
           , MovementLinkMovement_Master.MovementChildId    AS MovementId_Master
           , MS_InvNumberPartner_Master.ValueData           AS InvNumberPartner_Master

           , Movement_TransportGoods.Id                     AS MovementId_TransportGoods
           , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
           , Movement_TransportGoods.OperDate               AS OperDate_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) :: TDateTime AS OperDate_TransportGoods_calc


           , Movement_Transport.Id                     AS MovementId_Transport
           , Movement_Transport.InvNumber              AS InvNumber_Transport
           , Movement_Transport.OperDate               AS OperDate_Transport
           , ('� ' || Movement_Transport.InvNumber || ' �� ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full 
           , Object_Car.ValueData                      AS CarName
           , Object_CarModel.ValueData                 AS CarModelName
           , View_PersonalDriver.PersonalName          AS PersonalDriverName
 
           , COALESCE (MovementLinkMovement_Sale.MovementChildId, 0) <> 0 AS isEDI
           , COALESCE (MovementBoolean_Electron.ValueData, FALSE)         AS isElectron
           , COALESCE (MovementBoolean_Medoc.ValueData, FALSE)            AS isMedoc

           , COALESCE (MovementBoolean_EdiOrdspr.ValueData, FALSE)    AS EdiOrdspr
           , COALESCE (MovementBoolean_EdiInvoice.ValueData, FALSE)   AS EdiInvoice
           , COALESCE (MovementBoolean_EdiDesadv.ValueData, FALSE)    AS EdiDesadv

           , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, CAST (False AS Boolean))     AS isEdiOrdspr_partner
           , COALESCE (ObjectBoolean_EdiInvoice.ValueData, CAST (False AS Boolean))    AS isEdiInvoice_partner
           , COALESCE (ObjectBoolean_EdiDesadv.ValueData, CAST (False AS Boolean))     AS isEdiDesadv_partner

           , CAST (CASE WHEN Movement_DocumentMaster.Id IS NOT NULL -- MovementLinkMovement_Master.MovementChildId IS NOT NULL
                              AND (Movement_DocumentMaster.StatusId <> zc_Enum_Status_Complete()
                                OR (MovementDate_OperDatePartner.ValueData <> Movement_DocumentMaster.OperDate
                                AND MovementLinkObject_DocumentTaxKind_Master.ObjectId IN (zc_Enum_DocumentTaxKind_Tax())
                                   )
                                OR (COALESCE (MovementLinkObject_To.ObjectId, -1) <> COALESCE (MovementLinkObject_Partner_Master.ObjectId, -2)
                                    AND MovementLinkObject_DocumentTaxKind_Master.ObjectId NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
                                   )
                                OR COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, -1) <> COALESCE (MovementLinkObject_To_Master.ObjectId, -2)
                                OR COALESCE (MovementLinkObject_Contract.ObjectId, -1) <> COALESCE (MovementLinkObject_Contract_Master.ObjectId, -2)
                                  )
                        THEN TRUE
                        ELSE FALSE
                   END AS Boolean) AS isError
           , COALESCE (MovementBoolean_Print.ValueData, False) AS isPrinted
           , COALESCE (MovementBoolean_Promo.ValueData, False) AS isPromo
           , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndSale.ValueData) AS MovementPromo

           , MovementDate_Insert.ValueData AS InsertDate
           , MovementString_Comment.ValueData       AS Comment

           , Object_ReestrKind.Id             		    AS ReestrKindId
           , Object_ReestrKind.ValueData       		    AS ReestrKindName

           , Movement_Production.Id               AS MovementId_Production
           , (CASE WHEN Movement_Production.StatusId = zc_Enum_Status_Erased()
                       THEN '???'
                   WHEN Movement_Production.StatusId = zc_Enum_Status_UnComplete()
                       THEN '?'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (CASE WHEN MovementBoolean_Peresort.ValueData = TRUE THEN -1 ELSE 1 END * Movement_Production.DescId, MovementDesc_Production.ItemName, Movement_Production.InvNumber, Movement_Production.OperDate)
             ) :: TVarChar AS InvNumber_ProductionFull


       FROM (SELECT Movement.Id
                  , tmpRoleAccessKey.AccessKeyId
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Sale() AND Movement.StatusId = tmpStatus.StatusId
                  LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
             WHERE inIsPartnerDate = FALSE
            UNION ALL
             SELECT MovementDate_OperDatePartner.MovementId  AS Id
                  , tmpRoleAccessKey.AccessKeyId
             FROM MovementDate AS MovementDate_OperDatePartner
                  JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId AND Movement.DescId = zc_Movement_Sale()
                  JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                  LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
             WHERE inIsPartnerDate = TRUE
               AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
               AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId


            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_EdiOrdspr
                                      ON MovementBoolean_EdiOrdspr.MovementId =  Movement.Id
                                     AND MovementBoolean_EdiOrdspr.DescId = zc_MovementBoolean_EdiOrdspr()

            LEFT JOIN MovementBoolean AS MovementBoolean_EdiInvoice
                                      ON MovementBoolean_EdiInvoice.MovementId =  Movement.Id
                                     AND MovementBoolean_EdiInvoice.DescId = zc_MovementBoolean_EdiInvoice()

            LEFT JOIN MovementBoolean AS MovementBoolean_EdiDesadv
                                      ON MovementBoolean_EdiDesadv.MovementId =  Movement.Id
                                     AND MovementBoolean_EdiDesadv.DescId = zc_MovementBoolean_EdiDesadv()

            LEFT JOIN MovementBoolean AS MovementBoolean_Print
                                      ON MovementBoolean_Print.MovementId =  Movement.Id
                                     AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

            LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                      ON MovementBoolean_Promo.MovementId =  Movement.Id
                                     AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId =  Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementDate AS MovementDate_Payment
                                   ON MovementDate_Payment.MovementId =  Movement.Id
                                  AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

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
            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch ON ObjectLink_Unit_Branch.ObjectId = Object_From.Id
                                                          AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalTo.Id
            LEFT JOIN tmpBranchJuridical ON tmpBranchJuridical.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                         ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
            LEFT JOIN Movement AS Movement_TransportGoods ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN Movement AS Movement_DocumentMaster ON Movement_DocumentMaster.Id = MovementLinkMovement_Master.MovementChildId

            LEFT JOIN MovementString AS MS_InvNumberPartner_Master ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId -- Movement_DocumentMaster.Id
                                                                  AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
--
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                           ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                          AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ReestrKind
                                         ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                        AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement_Transport.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
--

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId = MovementLinkMovement_Master.MovementChildId
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
            LEFT JOIN MovementBoolean AS MovementBoolean_Medoc
                                      ON MovementBoolean_Medoc.MovementId =  MovementLinkMovement_Master.MovementChildId
                                     AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To_Master
                                         ON MovementLinkObject_To_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_To_Master.DescId = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract_Master
                                         ON MovementLinkObject_Contract_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_Contract_Master.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_Master
                                         ON MovementLinkObject_Partner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_Partner_Master.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind_Master
                                         ON MovementLinkObject_DocumentTaxKind_Master.MovementId = Movement_DocumentMaster.Id -- MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN Object AS Object_TaxKind_Master ON Object_TaxKind_Master.Id = MovementLinkObject_DocumentTaxKind_Master.ObjectId
                                                     AND Movement_DocumentMaster.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                           ON MovementLinkMovement_Sale.MovementId = Movement.Id 
                                          AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id 
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                         ON MovementLinkObject_Personal.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                               AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner_order
                                         ON MovementLinkObject_Partner_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Partner_order.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner_order ON Object_Partner_order.Id = MovementLinkObject_Partner_order.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail_order
                                         ON MovementLinkObject_Retail_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkObject_Retail_order.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail_order ON Object_Retail_order.Id = MovementLinkObject_Retail_order.ObjectId

         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiOrdspr
                                 ON ObjectBoolean_EdiOrdspr.ObjectId = Object_To.Id
                                AND ObjectBoolean_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiInvoice
                                 ON ObjectBoolean_EdiInvoice.ObjectId = Object_To.Id
                                AND ObjectBoolean_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_EdiDesadv
                                 ON ObjectBoolean_EdiDesadv.ObjectId = Object_To.Id
                                AND ObjectBoolean_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Promo
                                           ON MovementLinkMovement_Promo.MovementId = Movement.Id
                                          AND MovementLinkMovement_Promo.DescId = zc_MovementLinkMovement_Promo()
            LEFT JOIN Movement AS Movement_Promo ON Movement_Promo.Id = MovementLinkMovement_Promo.MovementChildId
            LEFT JOIN MovementDate AS MD_StartSale
                                   ON MD_StartSale.MovementId =  Movement_Promo.Id
                                  AND MD_StartSale.DescId = zc_MovementDate_StartSale()
            LEFT JOIN MovementDate AS MD_EndSale
                                   ON MD_EndSale.MovementId =  Movement_Promo.Id
                                  AND MD_EndSale.DescId = zc_MovementDate_EndSale()

          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Production
                                         ON MovementLinkMovement_Production.MovementChildId = Movement.Id                                   --MovementLinkMovement_Production.MovementId = Movement.Id
                                        AND MovementLinkMovement_Production.DescId = zc_MovementLinkMovement_Production()
          LEFT JOIN Movement AS Movement_Production ON Movement_Production.Id = MovementLinkMovement_Production.MovementId  --MovementLinkMovement_Production.MovementChildId
          LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_Production.DescId
          LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                    ON MovementBoolean_Peresort.MovementId =  Movement_Production.Id
                                   AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()


     WHERE (vbIsXleb = FALSE OR (View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30103() -- ����
                                AND vbIsXleb = TRUE))
        AND (tmpBranchJuridical.JuridicalId > 0 OR tmpMovement.AccessKeyId > 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.10.16         * add inJuridicalBasisId
 21.12.15         * add isPrinted
 25.11.15         * add Promo
 13.11.14                                        * add zc_Enum_Process_AccessKey_DocumentAll
 21.08.14                                        * add RouteName
 12.08.14                                        * add isEDI
 24.07.14         * add zc_MovementFloat_CurrencyValue
                        zc_MovementLinkObject_CurrencyDocument
                        zc_MovementLinkObject_CurrencyPartner
 29.05.14                        * add isCOMDOC 
 17.05.14                                        * add MS_InvNumberPartner_Master - ������
 03.05.14                                        * add ContractTagName
 24.04.14                                        * ... Movement_DocumentMaster.Id
 12.04.14                                        * add CASE WHEN ...StatusId = zc_Enum_Status_Erased()
 31.03.14                                        * add TotalCount...
 28.03.14                                        * add TotalSummVAT
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 20.03.14                                        * add InvNumberPartner
 16.03.14                                        * add JuridicalName_To and OKPO_To
 13.02.14                                                        * add DocumentChild, DocumentTaxKind
 10.02.14                                        * add Object_RoleAccessKey_View
 05.02.14                                        * add Object_InfoMoney_View
 30.01.14                                                       * add inIsPartnerDate, inIsErased
 14.01.14                                        * add Object_Contract_InvNumber_View
 11.01.14                                        * add Checked, InvNumberOrder
 13.08.13                                        * add TotalCountPartner
 13.07.13          *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Sale (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsPartnerDate:= FALSE, inIsErased:= TRUE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
