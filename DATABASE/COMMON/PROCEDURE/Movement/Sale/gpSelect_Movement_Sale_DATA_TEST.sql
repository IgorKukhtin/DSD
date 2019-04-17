-- Function: gpSelect_Movement_Sale_DATA()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_DATA22 (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_DATA22 (
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsPartnerDate      Boolean   ,
    IN inIsErased           Boolean   ,
    IN inJuridicalBasisId   Integer   ,
    IN inUserId             Integer
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
             , JuridicalName_To TVarChar, OKPO_To TVarChar, RetailName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteGroupName TVarChar, RouteName TVarChar, PersonalName TVarChar
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
   DECLARE vbIsXleb Boolean;
BEGIN
     -- !!!Хлеб!!!
     vbIsXleb:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 131936  AND UserId = inUserId);

/*
if inUserId = 1613484 then
  perform pg_sleep (59);
  -- return;
end if;
*/
     -- !!!т.к. нельзя когда много данных в гриде!!!
     IF inStartDate + (INTERVAL '200 DAY') <= inEndDate
     THEN
         inStartDate:= inEndDate + (INTERVAL '1 DAY');
     END IF;

     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT Object_Status.*
                             , Object_Status.Id  AS StatusId
                        FROM (SELECT zc_Enum_Status_Complete()   AS StatusId
                           UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                           UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                              ) AS tmp
                            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmp.StatusId
                        )
        , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = inUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT zc_Enum_Process_AccessKey_DocumentDnepr() AS AccessKeyId WHERE vbIsXleb = TRUE
                              )
        , tmpBranchJuridical AS (SELECT DISTINCT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                                 FROM ObjectLink AS ObjectLink_Juridical
                                      INNER JOIN ObjectLink AS ObjectLink_Branch
                                                            ON ObjectLink_Branch.ObjectId = ObjectLink_Juridical.ObjectId
                                                           AND ObjectLink_Branch.DescId = zc_ObjectLink_BranchJuridical_Branch()
                                 WHERE ObjectLink_Juridical.ChildObjectId > 0
                                   AND ObjectLink_Juridical.DescId = zc_ObjectLink_BranchJuridical_Juridical()
                                   AND ObjectLink_Branch.ChildObjectId IN (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
                                )
        , tmpMovement_all AS (SELECT Movement.Id
                               , Movement.OperDate
                               , Movement.InvNumber
                               , Movement.StatusId
                               , COALESCE (Movement.AccessKeyId, 0) AS AccessKeyId
                       -- FROM tmpStatus
                       --      JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Sale() AND Movement.StatusId = tmpStatus.StatusId
                          FROM Movement
                               
                          WHERE inIsPartnerDate = FALSE
                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                            AND Movement.DescId = zc_Movement_Sale()
                            AND (Movement.StatusId <> zc_Enum_Status_Erased() OR inIsErased = TRUE)
                         UNION ALL
                          SELECT MovementDate_OperDatePartner.MovementId  AS Id
                               , Movement.OperDate
                               , Movement.InvNumber
                               , Movement.StatusId
                               , COALESCE (Movement.AccessKeyId, 0) AS AccessKeyId
                          FROM MovementDate AS MovementDate_OperDatePartner
                               JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId AND Movement.DescId = zc_Movement_Sale()
                                            AND (Movement.StatusId <> zc_Enum_Status_Erased() OR inIsErased = TRUE)
                            -- JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                          WHERE inIsPartnerDate = TRUE
                            AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                         )
        , tmpMovementLinkObject_To AS (SELECT MovementLinkObject.*
                                       FROM MovementLinkObject
                                       WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                                         AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                                       )

       , tmpJuridicalTo AS (SELECT ObjectLink_Partner_Juridical.ObjectId AS ToId
                                 , Object_JuridicalTo.*
                            FROM ObjectLink AS ObjectLink_Partner_Juridical
                                 LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
                            WHERE ObjectLink_Partner_Juridical.ObjectId IN (SELECT DISTINCT tmpMovementLinkObject_To.ObjectId FROM tmpMovementLinkObject_To)
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            )
        --, tmpContract_InvNumber AS (SELECT * FROM Object_Contract_InvNumber_Sale_View)
        , tmpJuridicalDetails AS (SELECT * FROM ObjectHistory_JuridicalDetails_View
                                  WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpJuridicalTo.Id FROM tmpJuridicalTo)
                                 )
        , tmpMovement AS (SELECT Movement.Id
                               , Movement.OperDate
                               , Movement.InvNumber
                               , Movement.StatusId
                               , tmpRoleAccessKey.AccessKeyId
                          FROM tmpMovement_all AS Movement
                               LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                               LEFT JOIN tmpMovementLinkObject_To ON tmpMovementLinkObject_To.MovementId = Movement.Id
                               LEFT JOIN tmpJuridicalTo ON tmpJuridicalTo.ToId = tmpMovementLinkObject_To.ObjectId
                               LEFT JOIN tmpBranchJuridical ON tmpBranchJuridical.JuridicalId = tmpJuridicalTo.Id
                          WHERE (tmpBranchJuridical.JuridicalId > 0 OR tmpRoleAccessKey.AccessKeyId > 0)
                         )
        , tmpMovementLinkObject_From AS (SELECT MovementLinkObject.*
                                         FROM MovementLinkObject
                                         WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                         )

        , tmpMovementFloat AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId = null -- IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 -- AND MovementFloat.ValueData <> 0
                                 AND MovementFloat.DescId IN (zc_MovementFloat_VATPercent()
                                                            , zc_MovementFloat_ChangePercent()
                                                            , zc_MovementFloat_TotalCount()
                                                            , zc_MovementFloat_TotalCountPartner()
                                                            , zc_MovementFloat_TotalCountTare()
                                                            , zc_MovementFloat_TotalCountSh()
                                                            , zc_MovementFloat_TotalCountKg()
                                                            , zc_MovementFloat_TotalSummMVAT()
                                                            , zc_MovementFloat_TotalSummPVAT()
                                                            , zc_MovementFloat_TotalSummChange()
                                                            , zc_MovementFloat_TotalSumm()
                                                            , zc_MovementFloat_AmountCurrency()
                                                            , zc_MovementFloat_CurrencyValue()
                                                            , zc_MovementFloat_ParValue()
                                                            , zc_MovementFloat_CurrencyPartnerValue()
                                                            , zc_MovementFloat_ParPartnerValue()
                                                             )
                              )
      , tmpMovement_property AS (SELECT Movement.*
                                      , MovementBoolean_Checked.ValueData             AS isChecked
                                      , MovementBoolean_PriceWithVAT.ValueData        AS isPriceWithVAT
                                      , MovementBoolean_EdiOrdspr.ValueData           AS isEdiOrdspr
                                      , MovementBoolean_EdiInvoice.ValueData          AS isEdiInvoice
                                      , MovementBoolean_EdiDesadv.ValueData           AS isEdiDesadv
                                      , MovementBoolean_Print.ValueData               AS isPrint
                                      , MovementBoolean_Promo.ValueData               AS isPromo

                                      /*, MovementDate_Insert.ValueData                 AS InsertDate
                                      , MovementDate_Payment.ValueData                AS PaymentDate
                                      , MovementDate_OperDatePartner.ValueData        AS OperDatePartner

                                      , MovementString_InvNumberPartner.ValueData     AS InvNumberPartner
                                      , MovementString_Comment.ValueData              AS Comment
                                      , MovementString_InvNumberOrder.ValueData       AS InvNumberOrder*/
                         
                                      /*, MovementFloat_VATPercent.ValueData            AS VATPercent
                                      , MovementFloat_ChangePercent.ValueData         AS ChangePercent
                                      , MovementFloat_TotalCount.ValueData            AS TotalCount
                                      , MovementFloat_TotalCountPartner.ValueData     AS TotalCountPartner
                                      , MovementFloat_TotalCountTare.ValueData        AS TotalCountTare
                                      , MovementFloat_TotalCountSh.ValueData          AS TotalCountSh
                                      , MovementFloat_TotalCountKg.ValueData          AS TotalCountKg
                                      , MovementFloat_TotalSummMVAT.ValueData         AS TotalSummMVAT
                                      , MovementFloat_TotalSummPVAT.ValueData         AS TotalSummPVAT
                                      , MovementFloat_TotalSummChange.ValueData       AS TotalSummChange
                                      , MovementFloat_TotalSumm.ValueData             AS TotalSumm
                                      , MovementFloat_AmountCurrency.ValueData        AS AmountCurrency
                                      , MovementFloat_CurrencyValue.ValueData         AS CurrencyValue
                                      , MovementFloat_ParValue.ValueData              AS ParValue
                                      , MovementFloat_CurrencyPartnerValue.ValueData  AS CurrencyPartnerValue
                                      , MovementFloat_ParPartnerValue.ValueData       AS ParPartnerValue*/

                                 FROM tmpMovement AS Movement
                                      LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                                                   ON MovementBoolean_Checked.MovementId = Movement.Id
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

                                      /*LEFT JOIN MovementDate AS MovementDate_Insert
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
                                      LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                                  ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                                                 AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()*/
                          
                                      /*LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                                                 ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                                                AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                                                 ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                                                 ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                                                AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountPartner
                                                                 ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                                                AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountTare
                                                                 ON MovementFloat_TotalCountTare.MovementId = Movement.Id
                                                                AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                                                 ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                                                AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                                                 ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                                                AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                                                 ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                                                AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                                                 ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                                                AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummChange
                                                                 ON MovementFloat_TotalSummChange.MovementId =  Movement.Id
                                                                AND MovementFloat_TotalSummChange.DescId = zc_MovementFloat_TotalSummChange()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_AmountCurrency
                                                                 ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                                                AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyValue
                                                                 ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                                                AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_ParValue
                                                                 ON MovementFloat_ParValue.MovementId = Movement.Id
                                                                AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyPartnerValue
                                                                 ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                                                AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
                                      LEFT JOIN tmpMovementFloat AS MovementFloat_ParPartnerValue
                                                                 ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                                                AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()
                                                                */
                                )
        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId = null -- IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementDate.DescId IN (zc_MovementDate_Insert()
                                                          , zc_MovementDate_Payment()
                                                          , zc_MovementDate_OperDatePartner()
                                                           )
                              )
        , tmpMovementString AS (SELECT MovementString.*
                                FROM MovementString
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementString.DescId = null --  IN (zc_MovementString_InvNumberPartner()
                                                              , zc_MovementString_Comment()
                                                              , zc_MovementString_InvNumberOrder()
                                                               )
                               )
/*        , tmpMovementFloat AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_VATPercent()
                                                            , zc_MovementFloat_ChangePercent()
                                                            , zc_MovementFloat_TotalCount()
                                                            , zc_MovementFloat_TotalCountPartner()
                                                            , zc_MovementFloat_TotalCountTare()
                                                            , zc_MovementFloat_TotalCountSh()
                                                            , zc_MovementFloat_TotalCountKg()
                                                            , zc_MovementFloat_TotalSummMVAT()
                                                            , zc_MovementFloat_TotalSummPVAT()
                                                            , zc_MovementFloat_TotalSummChange()
                                                            , zc_MovementFloat_TotalSumm()
                                                            , zc_MovementFloat_AmountCurrency()
                                                            , zc_MovementFloat_CurrencyValue()
                                                            , zc_MovementFloat_ParValue()
                                                            , zc_MovementFloat_CurrencyPartnerValue()
                                                            , zc_MovementFloat_ParPartnerValue()
                                                             )
                              )*/
        , tmpMovementLinkObject_PaidKind AS (SELECT MovementLinkObject.*
                                             FROM MovementLinkObject
                                             WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                               AND MovementLinkObject.DescId = zc_MovementLinkObject_PaidKind()
                                             )
        , tmpMovementLinkObject_Contract AS (SELECT MovementLinkObject.*
                                             FROM MovementLinkObject
                                             WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                               AND MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
                                             )

        , tmpContract_InvNumber AS (SELECT Object_Contract_InvNumber_Sale_View.*
                                    FROM Object_Contract_InvNumber_Sale_View
                                    WHERE Object_Contract_InvNumber_Sale_View.ContractId IN (SELECT DISTINCT tmpMovementLinkObject_Contract.ObjectId FROM tmpMovementLinkObject_Contract)
                                    )

        , tmpMovementLinkObject_PriceList AS (SELECT MovementLinkObject.*
                                              FROM MovementLinkObject
                                              WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                                AND MovementLinkObject.DescId = zc_MovementLinkObject_PriceList()
                                              )
        , tmpMovementLinkObject_CurrencyDocument AS (SELECT MovementLinkObject.*
                                                     FROM MovementLinkObject
                                                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                                       AND MovementLinkObject.DescId = zc_MovementLinkObject_CurrencyDocument()
                                                     )
        , tmpMovementLinkObject_CurrencyPartner AS (SELECT MovementLinkObject.*
                                                    FROM MovementLinkObject
                                                    WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                                      AND MovementLinkObject.DescId = zc_MovementLinkObject_CurrencyPartner()
                                                    )
        , tmpMovementLinkObject_ReestrKind AS (SELECT MovementLinkObject.*
                                               FROM MovementLinkObject
                                               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                                 AND MovementLinkObject.DescId = zc_MovementLinkObject_ReestrKind()
                                               )

        , tmpFrom AS (SELECT MovementLinkObject_From.MovementId
                           , Object_From.*
                      FROM tmpMovementLinkObject_From AS MovementLinkObject_From
                           LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                     )
        , tmpTo AS (SELECT MovementLinkObject_To.MovementId
                         , Object_To.*
                    FROM tmpMovementLinkObject_To AS MovementLinkObject_To
                         LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                    )
----
       , tmpMLM AS (SELECT MovementLinkMovement.*
                    FROM MovementLinkMovement
                    WHERE MovementLinkMovement.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                      AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Master()
                                                        , zc_MovementLinkMovement_TransportGoods()
                                                        , zc_MovementLinkMovement_Sale()
                                                        , zc_MovementLinkMovement_Order()
                                                        , zc_MovementLinkMovement_Promo()
                                                        , zc_MovementLinkMovement_Production()
                                                        , zc_MovementLinkMovement_Transport()
                                                        )
                     )
       , tmpMS_InvNumberPartner AS (SELECT MovementString.*
                                    FROM MovementString
                                    WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM WHERE tmpMLM.DescId = zc_MovementLinkMovement_Master())
                                      AND MovementString.DescId = zc_MovementString_InvNumberPartner()
                                   )

       , tmpMB_MLM AS (SELECT MovementBoolean.*
                       FROM MovementBoolean
                       WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM/* WHERE tmpMLM.DescId = zc_MovementLinkMovement_Master()*/)
                         AND MovementBoolean.DescId IN (zc_MovementBoolean_Electron()
                                                      , zc_MovementBoolean_Medoc()
                                                      , zc_MovementBoolean_Peresort()
                                                      )
                       )

       , tmpMLO_To AS (SELECT MovementLinkObject.*
                       FROM MovementLinkObject
                       WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                         AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                       )
       , tmpMLO_Contract AS (SELECT MovementLinkObject.*
                             FROM MovementLinkObject
                             WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                               AND MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
                             )
       , tmpMLO_Partner AS (SELECT MovementLinkObject.*
                            FROM MovementLinkObject
                            WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                              AND MovementLinkObject.DescId = zc_MovementLinkObject_Partner()
                            )

       , tmpMLO_DocumentTaxKind AS (SELECT MovementLinkObject.*
                                    FROM MovementLinkObject
                                    WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                                      AND MovementLinkObject.DescId = zc_MovementLinkObject_DocumentTaxKind()
                            )

       , tmpMLO_Route AS (SELECT MovementLinkObject.*
                          FROM MovementLinkObject
                          WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                            AND MovementLinkObject.DescId = zc_MovementLinkObject_Route()
                          )

       , tmpMLO_Personal AS (SELECT MovementLinkObject.*
                             FROM MovementLinkObject
                             WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                               AND MovementLinkObject.DescId = zc_MovementLinkObject_Personal()
                             )

       , tmpMLO_Retail AS (SELECT MovementLinkObject.*
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                             AND MovementLinkObject.DescId = zc_MovementLinkObject_Retail()
                           )

       , tmpMLO_Car AS (SELECT MovementLinkObject.*
                        FROM MovementLinkObject
                        WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                          AND MovementLinkObject.DescId = zc_MovementLinkObject_Car()
                       )

       , tmpMLO_PersonalDriver AS (SELECT MovementLinkObject.*
                                   FROM MovementLinkObject
                                   WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                                     AND MovementLinkObject.DescId = zc_MovementLinkObject_PersonalDriver()
                                  )

       , tmpRoute AS (SELECT MovementLinkObject_Route.MovementId
                             , Object_Route.*
                      FROM tmpMLO_Route AS MovementLinkObject_Route
                          LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId AND Object_Route.DescId = zc_Object_Route()
                     )
       , tmpOL_Route_RouteGroup AS (SELECT ObjectLink.*
                                    FROM ObjectLink
                                    WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpRoute.Id FROM tmpRoute)
                                      AND ObjectLink.DescId = zc_ObjectLink_Route_RouteGroup()
                                    )
       , tmpPersonal AS (SELECT MovementLinkObject_Personal.MovementId
                              , Object_Personal.*
                         FROM tmpMLO_Personal AS MovementLinkObject_Personal
                          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId-- AND Object_Personal.DescId = zc_Object_Personal()
                     )
       , tmpCar AS (SELECT MovementLinkObject_Car.MovementId
                             , Object_Car.*
                    FROM tmpMLO_Car AS MovementLinkObject_Car
                         LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId AND Object_Car.DescId = zc_Object_Car()
                    )

       , tmpPersonalDriver AS (SELECT MovementLinkObject_PersonalDriver.MovementId
                                    , Object_PersonalDriver.*
                               FROM tmpMLO_PersonalDriver AS MovementLinkObject_PersonalDriver
                                    LEFT JOIN Object AS Object_PersonalDriver
                                                     ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId
                               )
       , tmpPartner AS (SELECT MovementLinkObject_Partner.MovementId
                            , Object_Partner.*
                    FROM tmpMLO_Partner AS MovementLinkObject_Partner
                         LEFT JOIN Object AS Object_Partner
                                          ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
                    )

       , tmpRetail AS (SELECT MovementLinkObject_Retail.MovementId
                            , Object_Retail.*
                       FROM tmpMLO_Retail AS MovementLinkObject_Retail
                            LEFT JOIN Object AS Object_Retail
                                             ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId
                       )
--
       , tmpRetail_JuridicalTo AS (SELECT ObjectLink_Juridical_Retail.ObjectId AS JuridicalId_To
                                        , Object_Retail.ValueData              AS RetailName
                                   FROM ObjectLink AS ObjectLink_Juridical_Retail
                                        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                                   WHERE ObjectLink_Juridical_Retail.ObjectId IN (SELECT DISTINCT tmpJuridicalTo.Id FROM tmpJuridicalTo)
                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                   )

       , tmpObjectBoolean_To AS (SELECT ObjectBoolean.*
                                 FROM ObjectBoolean
                                 WHERE ObjectBoolean.ObjectId IN (SELECT DISTINCT tmpTo.Id FROM tmpTo)
                                   AND ObjectBoolean.DescId IN (zc_ObjectBoolean_Partner_EdiOrdspr()
                                                              , zc_ObjectBoolean_Partner_EdiInvoice()
                                                              , zc_ObjectBoolean_Partner_EdiDesadv())
                                )

        , tmpMovement_Master AS (SELECT MovementLinkMovement_Master.MovementId
                                      , Movement_Master.*
                                 FROM tmpMLM AS MovementLinkMovement_Master
                                      LEFT JOIN Movement AS Movement_Master
                                                         ON Movement_Master.Id = MovementLinkMovement_Master.MovementChildId
                                 WHERE MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                                )
        , tmpMovement_TransportGoods AS (SELECT MovementLinkMovement_TransportGoods.MovementId
                                              , Movement_TransportGoods.*
                                         FROM tmpMLM AS MovementLinkMovement_TransportGoods
                                              LEFT JOIN Movement AS Movement_TransportGoods
                                                                 ON Movement_TransportGoods.Id = MovementLinkMovement_TransportGoods.MovementChildId
                                         WHERE MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()
                                        )
        , tmpMovement_Production AS (SELECT MovementLinkMovement_Production.MovementId
                                          , Movement_Production.*
                                     FROM tmpMLM AS MovementLinkMovement_Production
                                          LEFT JOIN Movement AS Movement_Production
                                                             ON Movement_Production.Id = MovementLinkMovement_Production.MovementChildId
                                     WHERE MovementLinkMovement_Production.DescId = zc_MovementLinkMovement_Production()
                                    )
        , tmpMovement_Transport AS (SELECT MovementLinkMovement_Transport.MovementId
                                         , Movement_Transport.*
                                    FROM tmpMLM AS MovementLinkMovement_Transport
                                         LEFT JOIN Movement AS Movement_Transport
                                                            ON Movement_Transport.Id = MovementLinkMovement_Transport.MovementChildId
                                    WHERE MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                                   )
        , tmpMovement_Promo AS (SELECT MovementLinkMovement_Promo.MovementId
                                     , Movement_Promo.*
                                FROM tmpMLM AS MovementLinkMovement_Promo
                                     LEFT JOIN Movement AS Movement_Promo
                                                        ON Movement_Promo.Id = MovementLinkMovement_Promo.MovementChildId
                                                       AND Movement_Promo.DescId = zc_Movement_Promo()
                                WHERE MovementLinkMovement_Promo.DescId = zc_MovementLinkMovement_Promo()
                               )

        , tmpMovementDate_Promo AS (SELECT MovementDate.*
                                    FROM MovementDate
                                    WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo)
                                       AND MovementDate.DescId IN (zc_MovementDate_StartSale()
                                                                 , zc_MovementDate_EndSale())
                                    )

        , tmpCarModel AS (SELECT ObjectLink.ObjectId AS CarId
                               , Object_CarModel.*
                          FROM ObjectLink
                               LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink.ChildObjectId
                          WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpCar.Id FROM tmpCar)
                            AND ObjectLink.DescId = zc_ObjectLink_Car_CarModel()
                         )
     -- Результат
     SELECT
             Movement.Id                                     AS Id
           , Movement.InvNumber                              AS InvNumber
--         , zfConvert_StringToNumber (Movement.InvNumber)   AS InvNumber
           , Movement.OperDate                               AS OperDate
           , Object_Status.ObjectCode                        AS StatusCode
           , Object_Status.ValueData                         AS StatusName
           , COALESCE (Movement.isChecked, FALSE) :: Boolean AS Checked
           , Movement.isPriceWithVAT                         AS PriceWithVAT

           , MovementDate_Payment.ValueData                  AS PaymentDate
           , MovementDate_OperDatePartner.ValueData          AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData       AS InvNumberPartner
--!!!      , Movement.PaymentDate                            AS PaymentDate
--!!!      , Movement.OperDatePartner                        AS OperDatePartner
--!!!      , Movement.InvNumberPartner                       AS InvNumberPartner

           , MovementFloat_VATPercent.ValueData            AS VATPercent
           , MovementFloat_ChangePercent.ValueData         AS ChangePercent
           , MovementFloat_TotalCount.ValueData            AS TotalCount
           , MovementFloat_TotalCountPartner.ValueData     AS TotalCountPartner
           , MovementFloat_TotalCountTare.ValueData        AS TotalCountTare
           , MovementFloat_TotalCountSh.ValueData          AS TotalCountSh
           , MovementFloat_TotalCountKg.ValueData          AS TotalCountKg
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData         AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData         AS TotalSummPVAT
           , MovementFloat_TotalSummChange.ValueData       AS TotalSummChange
           , MovementFloat_TotalSumm.ValueData             AS TotalSumm
           , MovementFloat_AmountCurrency.ValueData        AS TotalSummCurrency

           , MovementFloat_CurrencyValue.ValueData         AS CurrencyValue
           , MovementFloat_ParValue.ValueData              AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData  AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData       AS ParPartnerValue

/*         , Movement.VATPercent             AS VATPercent
           , Movement.ChangePercent          AS ChangePercent
           , Movement.TotalCount             AS TotalCount
           , Movement.TotalCountPartner      AS TotalCountPartner
           , Movement.TotalCountTare         AS TotalCountTare
           , Movement.TotalCountSh           AS TotalCountSh
           , Movement.TotalCountKg           AS TotalCountKg
           , CAST (COALESCE (Movement.TotalSummPVAT, 0) - COALESCE (Movement.TotalSummMVAT, 0) AS TFloat) AS TotalSummVAT
           , Movement.TotalSummMVAT          AS TotalSummMVAT
           , Movement.TotalSummPVAT          AS TotalSummPVAT
           , Movement.TotalSummChange        AS TotalSummChange
           , Movement.TotalSumm              AS TotalSumm
           , Movement.AmountCurrency         AS TotalSummCurrency

           , Movement.CurrencyValue          AS CurrencyValue
           , Movement.ParValue               AS ParValue
           , Movement.CurrencyPartnerValue   AS CurrencyPartnerValue
           , Movement.ParPartnerValue        AS ParPartnerValue*/

           , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order
--!!!      , Movement.InvNumberOrder                        AS InvNumberOrder
           , MovementString_InvNumberOrder.ValueData        AS InvNumberOrder
           , Object_From.Id                                 AS FromId
           , Object_From.ValueData                          AS FromName
           , Object_To.Id                                   AS ToId
           , Object_To.ValueData                            AS ToName
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , tmpContract_InvNumber.ContractId               AS ContractId
           , tmpContract_InvNumber.ContractCode             AS ContractCode
           , tmpContract_InvNumber.InvNumber                AS ContractName
           , tmpContract_InvNumber.ContractTagName
           , Object_JuridicalTo.ValueData                   AS JuridicalName_To
           , ObjectHistory_JuridicalDetails_View.OKPO       AS OKPO_To
           , tmpRetail_JuridicalTo.RetailName    ::TVarChar AS RetailName
           , tmpContract_InvNumber.InfoMoneyGroupName       AS InfoMoneyGroupName
           , tmpContract_InvNumber.InfoMoneyDestinationName AS InfoMoneyDestinationName
           , tmpContract_InvNumber.InfoMoneyCode            AS InfoMoneyCode
           , tmpContract_InvNumber.InfoMoneyName            AS InfoMoneyName

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
           , Movement_DocumentMaster.Id    AS MovementId_Master
           , MS_InvNumberPartner_Master.ValueData           AS InvNumberPartner_Master

           , Movement_TransportGoods.Id                     AS MovementId_TransportGoods
           , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
           , Movement_TransportGoods.OperDate               AS OperDate_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) :: TDateTime AS OperDate_TransportGoods_calc


           , Movement_Transport.Id                     AS MovementId_Transport
           , Movement_Transport.InvNumber              AS InvNumber_Transport
           , Movement_Transport.OperDate               AS OperDate_Transport
           , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full
           , Object_Car.ValueData                      AS CarName
           , Object_CarModel.ValueData                 AS CarModelName
           , Object_PersonalDriver.ValueData           AS PersonalDriverName

           , COALESCE (MovementLinkMovement_Sale.MovementChildId, 0) <> 0 AS isEDI
           , COALESCE (MovementBoolean_Electron.ValueData, FALSE)         AS isElectron
           , COALESCE (MovementBoolean_Medoc.ValueData, FALSE)            AS isMedoc

           , COALESCE (Movement.isEdiOrdspr, FALSE)    :: Boolean AS EdiOrdspr
           , COALESCE (Movement.isEdiInvoice, FALSE)   :: Boolean AS EdiInvoice
           , COALESCE (Movement.isEdiDesadv, FALSE)    :: Boolean AS EdiDesadv

           , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, CAST (False AS Boolean))     AS isEdiOrdspr_partner
           , COALESCE (ObjectBoolean_EdiInvoice.ValueData, CAST (False AS Boolean))    AS isEdiInvoice_partner
           , COALESCE (ObjectBoolean_EdiDesadv.ValueData, CAST (False AS Boolean))     AS isEdiDesadv_partner

           , CAST (CASE WHEN Movement_DocumentMaster.Id IS NOT NULL -- MovementLinkMovement_Master.MovementChildId IS NOT NULL
                              AND (Movement_DocumentMaster.StatusId <> zc_Enum_Status_Complete()
--!!!                           OR (Movement.OperDatePartner <> Movement_DocumentMaster.OperDate
                                OR (MovementDate_OperDatePartner.ValueData <> Movement_DocumentMaster.OperDate
                                AND MovementLinkObject_DocumentTaxKind_Master.ObjectId IN (zc_Enum_DocumentTaxKind_Tax())
                                   )
                                OR (COALESCE (Object_To.Id, -1) <> COALESCE (MovementLinkObject_Partner_Master.ObjectId, -2)
                                    AND MovementLinkObject_DocumentTaxKind_Master.ObjectId NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS(), zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR())
                                   )
                                OR COALESCE (Object_JuridicalTo.Id, -1) <> COALESCE (MovementLinkObject_To_Master.ObjectId, -2)
                                OR COALESCE (MovementLinkObject_Contract.ObjectId, -1) <> COALESCE (MovementLinkObject_Contract_Master.ObjectId, -2)
                                  )
                        THEN TRUE
                        ELSE FALSE
                   END AS Boolean) AS isError
           , COALESCE (Movement.isPrint, False) :: Boolean AS isPrinted
           , COALESCE (Movement.isPromo, False) :: Boolean AS isPromo
           , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndSale.ValueData) AS MovementPromo

           , MovementDate_Insert.ValueData    AS InsertDate
           , MovementString_Comment.ValueData AS Comment
--!!!      , Movement.InsertDate     AS InsertDate
--!!!      , Movement.Comment        AS Comment

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

       FROM tmpMovement_property AS Movement

            LEFT JOIN tmpStatus AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                      ON MovementDate_Insert.MovementId =  Movement.Id
                                     AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN tmpMovementDate AS MovementDate_Payment
                                      ON MovementDate_Payment.MovementId =  Movement.Id
                                     AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN tmpMovementString AS MovementString_Comment
                                        ON MovementString_Comment.MovementId = Movement.Id
                                       AND MovementString_Comment.DescId = zc_MovementString_Comment()
            LEFT JOIN tmpMovementString AS MovementString_InvNumberOrder
                                        ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                       AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()


            LEFT JOIN tmpMovementFloat AS MovementFloat_VATPercent
                                       ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                      AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ChangePercent
                                       ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                      AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountPartner
                                       ON MovementFloat_TotalCountPartner.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountPartner.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountTare
                                       ON MovementFloat_TotalCountTare.MovementId = Movement.Id
                                      AND MovementFloat_TotalCountTare.DescId = zc_MovementFloat_TotalCountTare()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                       ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                       ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                       ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummChange
                                       ON MovementFloat_TotalSummChange.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummChange.DescId = zc_MovementFloat_TotalSummChange()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN tmpMovementFloat AS MovementFloat_AmountCurrency
                                       ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                      AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()

            LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyValue
                                       ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                      AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ParValue
                                       ON MovementFloat_ParValue.MovementId = Movement.Id
                                      AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyPartnerValue
                                       ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                      AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ParPartnerValue
                                       ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                      AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN tmpFrom AS Object_From ON Object_From.MovementId = Movement.Id
            LEFT JOIN tmpTo AS Object_To ON Object_To.MovementId = Movement.Id
            LEFT JOIN tmpJuridicalTo AS Object_JuridicalTo ON Object_JuridicalTo.ToId = Object_To.Id
            LEFT JOIN tmpJuridicalDetails AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalTo.Id
            -- LEFT JOIN tmpBranchJuridical ON tmpBranchJuridical.JuridicalId = Object_JuridicalTo.Id

            LEFT JOIN tmpMovementLinkObject_PaidKind AS MovementLinkObject_PaidKind
                                                     ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId and Object_PaidKind.DescId = zc_Object_PaidKind()

            LEFT JOIN tmpMovementLinkObject_Contract AS MovementLinkObject_Contract
                                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN tmpContract_InvNumber ON tmpContract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN tmpMovementLinkObject_PriceList AS MovementLinkObject_PriceList
                                                      ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                                     AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId

            LEFT JOIN tmpMovementLinkObject_CurrencyDocument AS MovementLinkObject_CurrencyDocument
                                                             ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                                            AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN tmpMovementLinkObject_CurrencyPartner AS MovementLinkObject_CurrencyPartner
                                                            ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                                           AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN tmpMovement_Master AS Movement_DocumentMaster ON Movement_DocumentMaster.MovementId = Movement.Id

            LEFT JOIN tmpMS_InvNumberPartner AS MS_InvNumberPartner_Master
                                             ON MS_InvNumberPartner_Master.MovementId = Movement_DocumentMaster.Id -- Movement_DocumentMaster.Id

            LEFT JOIN tmpMovement_TransportGoods AS Movement_TransportGoods ON Movement_TransportGoods.MovementId = Movement.Id

            LEFT JOIN tmpMovementLinkObject_ReestrKind AS MovementLinkObject_ReestrKind
                                                       ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                                      AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN tmpMB_MLM AS MovementBoolean_Electron
                                ON MovementBoolean_Electron.MovementId = Movement_DocumentMaster.Id
                               AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
            LEFT JOIN tmpMB_MLM AS MovementBoolean_Medoc
                                ON MovementBoolean_Medoc.MovementId =  Movement_DocumentMaster.Id
                               AND MovementBoolean_Medoc.DescId = zc_MovementBoolean_Medoc()
            LEFT JOIN tmpMLO_To AS MovementLinkObject_To_Master
                                ON MovementLinkObject_To_Master.MovementId = Movement_DocumentMaster.Id
                               AND MovementLinkObject_To_Master.DescId = zc_MovementLinkObject_To()

            LEFT JOIN tmpMLO_Contract AS MovementLinkObject_Contract_Master
                                      ON MovementLinkObject_Contract_Master.MovementId = Movement_DocumentMaster.Id
                                     AND MovementLinkObject_Contract_Master.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN tmpMLO_Partner AS MovementLinkObject_Partner_Master
                                     ON MovementLinkObject_Partner_Master.MovementId = Movement_DocumentMaster.Id
                                    AND MovementLinkObject_Partner_Master.DescId = zc_MovementLinkObject_Partner()

            LEFT JOIN tmpMLO_DocumentTaxKind AS MovementLinkObject_DocumentTaxKind_Master
                                             ON MovementLinkObject_DocumentTaxKind_Master.MovementId = Movement_DocumentMaster.Id -- MovementLinkMovement_Master.MovementChildId
                                            AND MovementLinkObject_DocumentTaxKind_Master.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind_Master
                             ON Object_TaxKind_Master.Id = MovementLinkObject_DocumentTaxKind_Master.ObjectId
                            AND Movement_DocumentMaster.StatusId = zc_Enum_Status_Complete() -- <> zc_Enum_Status_Erased()

            LEFT JOIN tmpMLM AS MovementLinkMovement_Sale
                             ON MovementLinkMovement_Sale.MovementId = Movement.Id
                            AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()

            LEFT JOIN tmpMLM AS MovementLinkMovement_Order
                             ON MovementLinkMovement_Order.MovementId = Movement.Id
                            AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            LEFT JOIN tmpRoute AS Object_Route ON Object_Route.MovementId = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpPersonal AS Object_Personal ON Object_Personal.MovementId = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpOL_Route_RouteGroup AS ObjectLink_Route_RouteGroup
                                             ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                            AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()

            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = COALESCE (ObjectLink_Route_RouteGroup.ChildObjectId, Object_Route.Id)

            LEFT JOIN tmpPartner AS Object_Partner_order ON Object_Partner_order.MovementId = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpRetail AS Object_Retail_order ON Object_Retail_order.MovementId = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpObjectBoolean_To AS ObjectBoolean_EdiOrdspr
                                          ON ObjectBoolean_EdiOrdspr.ObjectId = Object_To.Id
                                         AND ObjectBoolean_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()

            LEFT JOIN tmpObjectBoolean_To AS ObjectBoolean_EdiInvoice
                                          ON ObjectBoolean_EdiInvoice.ObjectId = Object_To.Id
                                         AND ObjectBoolean_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()

            LEFT JOIN tmpObjectBoolean_To AS ObjectBoolean_EdiDesadv
                                          ON ObjectBoolean_EdiDesadv.ObjectId = Object_To.Id
                                         AND ObjectBoolean_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()

            LEFT JOIN tmpMovement_Promo AS Movement_Promo ON Movement_Promo.MovementId = Movement.Id

            LEFT JOIN tmpMovementDate_Promo AS MD_StartSale
                                            ON MD_StartSale.MovementId = Movement_Promo.Id
                                           AND MD_StartSale.DescId = zc_MovementDate_StartSale()

            LEFT JOIN tmpMovementDate_Promo AS MD_EndSale
                                            ON MD_EndSale.MovementId = Movement_Promo.Id
                                           AND MD_EndSale.DescId = zc_MovementDate_EndSale()

            LEFT JOIN tmpMovement_Production AS Movement_Production ON Movement_Production.MovementId = Movement.Id

            LEFT JOIN MovementDesc AS MovementDesc_Production ON MovementDesc_Production.Id = Movement_Production.DescId

            LEFT JOIN tmpMB_MLM AS MovementBoolean_Peresort
                                ON MovementBoolean_Peresort.MovementId = Movement_Production.Id
                               AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()

            LEFT JOIN tmpMovement_Transport AS Movement_Transport ON Movement_Transport.MovementId = Movement.Id

            LEFT JOIN tmpCar AS Object_Car ON Object_Car.MovementId = Movement_Transport.Id

            LEFT JOIN tmpCarModel AS Object_CarModel ON Object_CarModel.CarId = Object_Car.Id

            LEFT JOIN tmpPersonalDriver AS Object_PersonalDriver ON Object_PersonalDriver.MovementId =  Movement_Transport.Id

            LEFT JOIN tmpRetail_JuridicalTo ON tmpRetail_JuridicalTo.JuridicalId_To = Object_JuridicalTo.Id

--     WHERE /*(vbIsXleb = FALSE OR (View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30103() -- Хлеб
--                                AND vbIsXleb = TRUE))
--        AND */(tmpBranchJuridical.JuridicalId > 0 OR Movement.AccessKeyId > 0)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.04.18         *
 24.10.17         * add Movement_Transport_Reestr
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
 17.05.14                                        * add MS_InvNumberPartner_Master - всегда
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

-- тест
--
-- SELECT * FROM gpSelect_Movement_Sale_DATA (inStartDate:= '01.03.2019', inEndDate:= '31.03.2019', inIsPartnerDate:= FALSE, inIsErased:= TRUE, inJuridicalBasisId:= 0, inUserId:= zfCalc_UserAdmin() :: Integer)
--Было 1 месяц - 3 мин 21 сек
--сейчас 1 месяц - 28 сек
-- select * from gpSelect_Movement_Sale_DATA22 (instartdate := ('01.04.2019')::TDateTime , inenddate := ('30.04.2019')::TDateTime , inIsPartnerDate := 'False' , inIsErased := 'False' , inJuridicalBasisId := 9399 ,  inUserId := 2953032)
-- select * from gpSelect_Movement_Sale_DATA22 (instartdate := ('01.04.2019')::TDateTime , inenddate := ('30.04.2019')::TDateTime , inIsPartnerDate := 'False' , inIsErased := 'False' , inJuridicalBasisId := 9399 ,  inUserId := 5)
