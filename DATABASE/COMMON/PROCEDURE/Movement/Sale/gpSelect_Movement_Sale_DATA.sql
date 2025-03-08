-- Function: gpSelect_Movement_Sale_DATA()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_DATA (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_DATA(
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
             , isCurrencyUser Boolean
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
             , PriceListInName TVarChar
             , CurrencyDocumentName TVarChar, CurrencyPartnerName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             , MovementId_Master Integer, InvNumberPartner_Master TVarChar
             , MovementId_TransportGoods Integer
             , InvNumber_TransportGoods TVarChar
             , OperDate_TransportGoods TDateTime
             , OperDate_TransportGoods_calc TDateTime
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime, InvNumber_Transport_Full TVarChar
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar, PersonalDriverName_TTN TVarChar, PersonalName_4_TTN TVarChar
             , isEDI Boolean
             , isElectron Boolean
             , isMedoc Boolean
             , EdiOrdspr Boolean, EdiInvoice Boolean, EdiDesadv Boolean
             , isEdiOrdspr_partner Boolean, isEdiInvoice_partner Boolean, isEdiDesadv_partner Boolean
             , isError Boolean
             , isPrinted Boolean
             , isPromo Boolean
             , isPav Boolean    
             , isTotalSumm_GoodsReal  Boolean  --Расчет суммы по схеме - Товар (факт)
             , MovementPromo TVarChar
             , InsertDate TDateTime 
             , InsertDate_order TDateTime
             , InsertDatediff_min TFloat
             , Comment TVarChar
             , ReestrKindId Integer, ReestrKindName TVarChar
             , MovementId_Production Integer, InvNumber_ProductionFull TVarChar
             , MovementId_ReturnIn Integer, InvNumber_ReturnInFull TVarChar
            
             , PersonalSigningName TVarChar
             , PersonalCode_Collation Integer
             , PersonalName_Collation TVarChar
             , UnitName_Collation TVarChar
             , BranchName_Collation TVarChar
             )
AS
$BODY$
   DECLARE vbIsIrna Boolean;
   DECLARE vbIsXleb Boolean;
   DECLARE vbIsZp   Boolean;
BEGIN

     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (inUserId);

     -- !!!Хлеб!!!
     vbIsXleb:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 131936  AND UserId = inUserId);
     
     vbIsZp:= EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_DocumentZaporozhye() AND Object_RoleAccessKey_View.UserId = inUserId);

/*
if inUserId = 1613484 then
  perform pg_sleep (59);
  -- return;
end if;
*/
     -- !!!т.к. нельзя когда много данных в гриде!!!
     IF inStartDate + (INTERVAL '400 DAY') <= inEndDate
     THEN
         inStartDate:= inEndDate + (INTERVAL '1 DAY');
     END IF;


     -- Результат 1
     CREATE TEMP TABLE tmpStatus ON COMMIT DROP AS
       SELECT Object_Status.*
            , Object_Status.Id  AS StatusId
       FROM (SELECT zc_Enum_Status_Complete()   AS StatusId
          UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
          UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
             ) AS tmp
           LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmp.StatusId
       ;

     -- Результат 2
     CREATE TEMP TABLE tmpMovement  ON COMMIT DROP AS
     WITH tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = inUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId
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
                                       AND ObjectLink_Branch.ChildObjectId IN (SELECT DISTINCT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0)
                                    )
        , tmpBranchJuridical AS (SELECT DISTINCT tmpBranchJuridical_all.JuridicalId, tmpBranchJuridical_all.UnitId
                                 FROM tmpBranchJuridical_all

                                UNION
                                 SELECT DISTINCT OL_JuridicalGroup.ObjectId AS JuridicalId, 0 AS UnitId
                                 FROM ObjectLink AS OL_JuridicalGroup
                                      LEFT JOIN tmpBranchJuridical_all ON tmpBranchJuridical_all.JuridicalId = OL_JuridicalGroup.ObjectId
                                 WHERE OL_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                                   AND OL_JuridicalGroup.ChildObjectId IN (SELECT DISTINCT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId)
                                   AND vbIsZp = TRUE
                                   -- если нет
                                   AND tmpBranchJuridical_all.JuridicalId IS NULL

                                UNION
                                 SELECT Object_Juridical.Id AS JuridicalId, 0 AS UnitId
                                 FROM Object AS Object_Juridical
                                      LEFT JOIN tmpBranchJuridical_all ON tmpBranchJuridical_all.JuridicalId = Object_Juridical.Id
                                 WHERE Object_Juridical.Id IN (7314357) -- М'ЯСНА ВЕСНА  ТОРГІВЕЛЬНИЙ БУДИНОК ТОВ 
                                   AND Object_Juridical.DescId = zc_Object_Juridical()
                                   AND vbIsZp = TRUE
                                   -- если нет
                                   AND tmpBranchJuridical_all.JuridicalId IS NULL
                                )
        , tmpMovement_all AS (SELECT Movement.Id
                               , Movement.OperDate
                               , Movement.InvNumber
                               , Movement.StatusId
                               , Movement.StatusId_next
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
                               , Movement.StatusId_next
                               , COALESCE (Movement.AccessKeyId, 0) AS AccessKeyId
                          FROM MovementDate AS MovementDate_OperDatePartner
                               JOIN Movement ON Movement.Id = MovementDate_OperDatePartner.MovementId AND Movement.DescId = zc_Movement_Sale()
                                            AND (Movement.StatusId <> zc_Enum_Status_Erased() OR inIsErased = TRUE)
                            -- JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                          WHERE inIsPartnerDate = TRUE
                            AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                         )
        , tmpMovementLinkObject_From AS (SELECT MovementLinkObject.*
                                         FROM MovementLinkObject
                                         WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                                           AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                        )
        , tmpMovementLinkObject_To AS (SELECT MovementLinkObject.*
                                       FROM MovementLinkObject
                                       WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                                     --WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id     FROM tmpMovement)
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
        , tmpJuridicalDetails AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpJuridicalTo.Id FROM tmpJuridicalTo))

        -- Результат
        SELECT Movement.Id
             , Movement.OperDate
             , Movement.InvNumber
             , Movement.StatusId
             , Movement.StatusId_next
             , tmpRoleAccessKey.AccessKeyId
        FROM tmpMovement_all AS Movement
             LEFT JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
             LEFT JOIN tmpMovementLinkObject_From ON tmpMovementLinkObject_From.MovementId = Movement.Id
             LEFT JOIN tmpMovementLinkObject_To ON tmpMovementLinkObject_To.MovementId = Movement.Id
             LEFT JOIN tmpJuridicalTo ON tmpJuridicalTo.ToId = tmpMovementLinkObject_To.ObjectId
             LEFT JOIN tmpBranchJuridical ON tmpBranchJuridical.JuridicalId = tmpJuridicalTo.Id
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                  ON ObjectLink_Unit_Business.ObjectId = tmpMovementLinkObject_From.ObjectId
                                 AND ObjectLink_Unit_Business.DescId   = zc_ObjectLink_Unit_Business()
        WHERE (tmpBranchJuridical.UnitId = tmpMovementLinkObject_From.ObjectId OR COALESCE (tmpBranchJuridical.UnitId, 0) = 0
            OR tmpRoleAccessKey.AccessKeyId > 0
              )
          AND (tmpBranchJuridical.JuridicalId > 0 OR tmpRoleAccessKey.AccessKeyId > 0
               -- Склад ГП ф.Запорожье
            OR (vbIsZp = TRUE AND tmpMovementLinkObject_From.ObjectId = 301309)
            OR vbIsIrna = TRUE
              )
          AND (vbIsIrna IS NULL
            OR (vbIsIrna = FALSE AND COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) <> zc_Business_Irna())
            OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business.ChildObjectId = zc_Business_Irna())
              );

-- analyze tmpMovement;
-- RAISE EXCEPTION '<%>', (select count(*) from tmpMovement);


     -- Результат
     RETURN QUERY
     WITH /*tmpStatus AS (SELECT Object_Status.*
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
                                )*/
          tmpMovement_all AS
                         (SELECT tmpMovement.Id, tmpMovement.OperDate, tmpMovement.InvNumber, tmpMovement.StatusId, tmpMovement.AccessKeyId FROM tmpMovement
                        /*SELECT Movement.Id
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
                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()*/
                         )
        , tmpMovementLinkObject_To AS (SELECT MovementLinkObject.*
                                       FROM MovementLinkObject
                                       WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_all.Id FROM tmpMovement_all)
                                     --WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id     FROM tmpMovement)
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
        , tmpJuridicalDetails AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpJuridicalTo.Id FROM tmpJuridicalTo))
/*      , tmpMovement AS (SELECT Movement.Id
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
                         )*/
        , tmpMovementLinkObject_From AS (SELECT MovementLinkObject.*
                                         FROM MovementLinkObject
                                         WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                           AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                         )

        , tmpMovementBoolean AS (SELECT MovementBoolean.*
                                 FROM MovementBoolean
                                 WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementBoolean.DescId IN (zc_MovementBoolean_EdiOrdspr()
                                                                , zc_MovementBoolean_Checked()
                                                                , zc_MovementBoolean_PriceWithVAT()
                                                                , zc_MovementBoolean_EdiInvoice()
                                                                , zc_MovementBoolean_EdiDesadv()
                                                                , zc_MovementBoolean_Print()
                                                                , zc_MovementBoolean_Promo() 
                                                                , zc_MovementBoolean_CurrencyUser()
                                                                , zc_MovementBoolean_TotalSumm_GoodsReal()
                                                                )
                                 )
        , tmpMovementDate AS (SELECT MovementDate.*
                              FROM MovementDate
                              WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementDate.DescId IN (zc_MovementDate_Insert()
                                                          , zc_MovementDate_Payment()
                                                          , zc_MovementDate_OperDatePartner()
                                                           )
                              )
        , tmpMovementString AS (SELECT MovementString.*
                                FROM MovementString
                                WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementString.DescId IN (zc_MovementString_InvNumberPartner()
                                                              , zc_MovementString_Comment()
                                                              , zc_MovementString_InvNumberOrder()
                                                              )
                               )
        , tmpMovementFloat AS (SELECT MovementFloat.*
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
                              )
   /* , tmpMovementFloat_VATPercent AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_VATPercent()
                              )
     , tmpMovementFloat_ChangePercent AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId =  zc_MovementFloat_ChangePercent()
                              )
     , tmpMovementFloat_TotalCount AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_TotalCount()
                              )
     , tmpMovementFloat_TotalCountPartner AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_TotalCountPartner()
                              )
     , tmpMovementFloat_TotalCountTare AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_TotalCountTare()
                              )
     , tmpMovementFloat_TotalCountSh AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_TotalCountSh()
                              )
     , tmpMovementFloat_TotalCountKg AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_TotalCountKg()
                              )
     , tmpMovementFloat_TotalSummMVAT AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_TotalSummMVAT()
                              )
     , tmpMovementFloat_TotalSummPVAT AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_TotalSummPVAT()
                              )
     , tmpMovementFloat_TotalSummChange AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_TotalSummChange()
                              )
     , tmpMovementFloat_TotalSumm AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_TotalSumm()
                              )
     , tmpMovementFloat_AmountCurrency AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_AmountCurrency()
                              )
     , tmpMovementFloat_CurrencyValue AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_CurrencyValue()
                              )
     , tmpMovementFloat_ParValue AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_ParValue()
                              )
     , tmpMovementFloat_CurrencyPartnerValue AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_CurrencyPartnerValue()
                              )
     , tmpMovementFloat_ParPartnerValue AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementFloat.DescId = zc_MovementFloat_ParPartnerValue()
                              )
*/
  /*      , tmpMLO AS (SELECT MovementLinkObject.*
                     FROM MovementLinkObject
                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                       , zc_MovementLinkObject_To()
                                                       , zc_MovementLinkObject_PaidKind()
                                                       , zc_MovementLinkObject_Contract()
                                                       , zc_MovementLinkObject_PriceList()
                                                       , zc_MovementLinkObject_CurrencyDocument()
                                                       , zc_MovementLinkObject_CurrencyPartner()
                                                       , zc_MovementLinkObject_ReestrKind()
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
                                                AND MovementLinkObject.DescId IN (zc_MovementLinkObject_PriceList(), zc_MovementLinkObject_PriceListIn())
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
                                                        , zc_MovementLinkMovement_ReturnIn()
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

       , tmpMovementDate_Order AS (SELECT MovementDate.*
                                   FROM MovementDate
                                   WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                                     AND MovementDate.DescId = zc_MovementDate_Insert()
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
       , tmpMLO_Personal_4 AS (SELECT MovementLinkObject.*
                               FROM MovementLinkObject
                               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM)
                                 AND MovementLinkObject.DescId = zc_MovementLinkObject_Member4()
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
       , tmpOL_Partner_Unit AS (SELECT ObjectLink.*
                                    FROM ObjectLink
                                    WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpMovementLinkObject_To.ObjectId FROM tmpMovementLinkObject_To)
                                      AND ObjectLink.DescId = zc_ObjectLink_Partner_Unit()
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
       , tmpPersonal_4 AS (SELECT MovementLinkObject_Personal_4.MovementId
                                , Object_Personal.*
                           FROM tmpMLO_Personal_4 AS MovementLinkObject_Personal_4
                                LEFT JOIN Object AS Object_Personal
                                                 ON Object_Personal.Id = MovementLinkObject_Personal_4.ObjectId
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
        , tmpMovement_ReturnIn AS (SELECT MovementLinkMovement_ReturnIn.MovementId
                                        , Movement_ReturnIn.*
                                   FROM tmpMLM AS MovementLinkMovement_ReturnIn
                                        LEFT JOIN Movement AS Movement_ReturnIn
                                                           ON Movement_ReturnIn.Id = MovementLinkMovement_ReturnIn.MovementChildId
                                   WHERE MovementLinkMovement_ReturnIn.DescId = zc_MovementLinkMovement_ReturnIn()
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
 
        , tmpMovementLinkObject_Branch AS (SELECT MovementLinkObject.*
                                             FROM MovementLinkObject
                                             WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                               AND MovementLinkObject.DescId = zc_MovementLinkObject_Branch()
                                             )

         -- Сотрудник (бухгалтер) подписант
     /*, tmpBranch_PersonalBookkeeper AS (SELECT Object_PersonalBookkeeper_View.MemberId
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
                                         )*/
        -- данные из Договора
        , tmpContract_param AS (SELECT tmpContract.ContractId
                                   --, COALESCE (tmpBranch_PersonalBookkeeper.PersonalBookkeeperName, Object_PersonalSigning.ValueData) AS PersonalSigningName
                                     , Object_PersonalSigning.ValueData      AS PersonalSigningName
                                     , Object_PersonalCollation.PersonalCode AS PersonalCode_Collation
                                     , Object_PersonalCollation.PersonalName AS PersonalName_Collation
                                     , Object_PersonalCollation.UnitName     AS UnitName_Collation
                                     , Object_PersonalCollation.BranchName   AS BranchName_Collation

                                FROM (SELECT DISTINCT tmpMovementLinkObject_Contract.ObjectId AS ContractId
                                      FROM tmpMovementLinkObject_Contract
                                      ) AS tmpContract
                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                                                      ON ObjectLink_Contract_PersonalSigning.ObjectId = tmpContract.ContractId
                                                     AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
                                 LEFT JOIN Object AS Object_PersonalSigning ON Object_PersonalSigning.Id = ObjectLink_Contract_PersonalSigning.ChildObjectId   

                                 /*LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                      ON ObjectLink_Personal_Member.ObjectId = Object_PersonalSigning.Id
                                                     AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                 -- Сотрудник подписант - замена
                                 LEFT JOIN tmpBranch_PersonalBookkeeper ON tmpBranch_PersonalBookkeeper.MemberId = ObjectLink_Personal_Member.ChildObjectId*/

                                 LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                                      ON ObjectLink_Contract_PersonalCollation.ObjectId = tmpContract.ContractId
                                                     AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
                                 LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId
                                )

     -- Результат
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
           , COALESCE (MovementBoolean_CurrencyUser.ValueData, FALSE) ::Boolean AS isCurrencyUser

           , MovementLinkMovement_Order.MovementChildId     AS MovementId_Order
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
           , Object_PriceListIn.ValueData                   AS PriceListInName
           , Object_CurrencyDocument.ValueData              AS CurrencyDocumentName
           , Object_CurrencyPartner.ValueData               AS CurrencyPartnerName
           , Object_TaxKind_Master.Id                	    AS DocumentTaxKindId
           , Object_TaxKind_Master.ValueData         	    AS DocumentTaxKindName
           , Movement_DocumentMaster.Id                     AS MovementId_Master
           , CASE WHEN Movement_DocumentMaster.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                       THEN COALESCE (Object_StatusMaster.ValueData, '') || ' ' || MS_InvNumberPartner_Master.ValueData
                  ELSE MS_InvNumberPartner_Master.ValueData
             END                                :: TVarChar AS InvNumberPartner_Master

           , Movement_TransportGoods.Id                     AS MovementId_TransportGoods
           , Movement_TransportGoods.InvNumber              AS InvNumber_TransportGoods
           , Movement_TransportGoods.OperDate               AS OperDate_TransportGoods
           , COALESCE (Movement_TransportGoods.OperDate, Movement.OperDate) :: TDateTime AS OperDate_TransportGoods_calc


           , Movement_Transport.Id                     AS MovementId_Transport
           , Movement_Transport.InvNumber              AS InvNumber_Transport
           , Movement_Transport.OperDate               AS OperDate_Transport
           , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport_Full
           , Object_Car.ValueData                      AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , Object_PersonalDriver.ValueData           AS PersonalDriverName
           , Object_PersonalDriver_TTN.ValueData       AS PersonalDriverName_TTN
           , Object_Personal_4_TTN.ValueData           AS PersonalName_4_TTN
           

           , (COALESCE (MovementLinkMovement_Sale.MovementChildId, 0) <> 0) :: Boolean AS isEDI
           , COALESCE (MovementBoolean_Electron.ValueData, FALSE)           :: Boolean AS isElectron
           , COALESCE (MovementBoolean_Medoc.ValueData, FALSE)              :: Boolean AS isMedoc

           , COALESCE (MovementBoolean_EdiOrdspr.ValueData, FALSE)    :: Boolean AS EdiOrdspr
           , COALESCE (MovementBoolean_EdiInvoice.ValueData, FALSE)   :: Boolean AS EdiInvoice
           , COALESCE (MovementBoolean_EdiDesadv.ValueData, FALSE)    :: Boolean AS EdiDesadv

           , COALESCE (ObjectBoolean_EdiOrdspr.ValueData, CAST (False AS Boolean))     :: Boolean AS isEdiOrdspr_partner
           , COALESCE (ObjectBoolean_EdiInvoice.ValueData, CAST (False AS Boolean))    :: Boolean AS isEdiInvoice_partner
           , COALESCE (ObjectBoolean_EdiDesadv.ValueData, CAST (False AS Boolean))     :: Boolean AS isEdiDesadv_partner

           , CAST (CASE WHEN Movement_DocumentMaster.Id IS NOT NULL -- MovementLinkMovement_Master.MovementChildId IS NOT NULL
                              AND (Movement_DocumentMaster.StatusId <> zc_Enum_Status_Complete()
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
                   END AS Boolean)  :: Boolean AS isError
           , COALESCE (MovementBoolean_Print.ValueData, False)  :: Boolean AS isPrinted
           , COALESCE (MovementBoolean_Promo.ValueData, False)  :: Boolean AS isPromo
           , CASE WHEN tmpOL_Partner_Unit.ChildObjectId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPav   
           , COALESCE (MovementBoolean_TotalSumm_GoodsReal.ValueData, FALSE)         :: Boolean AS isTotalSumm_GoodsReal
           
           , zfCalc_PromoMovementName (NULL, Movement_Promo.InvNumber :: TVarChar, Movement_Promo.OperDate, MD_StartSale.ValueData, MD_EndSale.ValueData) AS MovementPromo

           , MovementDate_Insert.ValueData       AS InsertDate
           , MovementDate_Insert_order.ValueData AS InsertDate_order
           , CASE WHEN COALESCE (MovementDate_Insert.ValueData, zc_DateStart()) = zc_DateStart() OR COALESCE (MovementDate_Insert_order.ValueData, zc_DateStart()) = zc_DateStart() THEN 0
                  ELSE CAST (EXTRACT (EPOCH FROM (MovementDate_Insert.ValueData - MovementDate_Insert_order.ValueData) :: INTERVAL ) / 60 AS NUMERIC (16,2)) 
             END  :: TFloat AS InsertDatediff_min

           , MovementString_Comment.ValueData    AS Comment

           , Object_ReestrKind.Id             AS ReestrKindId
           , Object_ReestrKind.ValueData      AS ReestrKindName

           , Movement_Production.Id               AS MovementId_Production
           , (CASE WHEN Movement_Production.StatusId = zc_Enum_Status_Erased()
                       THEN '???'
                   WHEN Movement_Production.StatusId = zc_Enum_Status_UnComplete()
                       THEN '?'
                   ELSE ''
              END
           || zfCalc_PartionMovementName (CASE WHEN MovementBoolean_Peresort.ValueData = TRUE THEN -1 ELSE 1 END * Movement_Production.DescId, MovementDesc_Production.ItemName, Movement_Production.InvNumber, Movement_Production.OperDate)
             ) :: TVarChar AS InvNumber_ProductionFull

           , Movement_ReturnIn.Id                                                                                                AS MovementId_ReturnIn
           , zfCalc_InvNumber_isErased ('', Movement_ReturnIn.InvNumber, Movement_ReturnIn.OperDate, Movement_ReturnIn.StatusId) AS InvNumber_ReturnInFull

             -- Сотрудник подписант
           , COALESCE (-- контрагент - замена
                       -- tmpBranch_PersonalBookkeeper_partner.PersonalBookkeeperName
                       -- контрагент
                       Object_PersonalSigning_partner.ValueData
                        -- договор
                     , tmpContract_param.PersonalSigningName
                       -- филиал - Сотрудник (бухгалтер) подписант
                     , ObjectString_PersonalBookkeeper.ValueData
                       -- филиал - Сотрудник (бухгалтер)
                     , Object_PersonalBookkeeper.ValueData
                     , '')  ::TVarChar AS PersonalSigningName
           -- сверка
           , tmpContract_param.PersonalCode_Collation  ::Integer
           , tmpContract_param.PersonalName_Collation  ::TVarChar
           , tmpContract_param.UnitName_Collation      ::TVarChar
           , tmpContract_param.BranchName_Collation    ::TVarChar
       FROM tmpMovement AS Movement

            LEFT JOIN tmpStatus AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_Checked
                                         ON MovementBoolean_Checked.MovementId = Movement.Id
                                        AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                         ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_EdiOrdspr
                                         ON MovementBoolean_EdiOrdspr.MovementId =  Movement.Id
                                        AND MovementBoolean_EdiOrdspr.DescId = zc_MovementBoolean_EdiOrdspr()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_EdiInvoice
                                         ON MovementBoolean_EdiInvoice.MovementId =  Movement.Id
                                        AND MovementBoolean_EdiInvoice.DescId = zc_MovementBoolean_EdiInvoice()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_EdiDesadv
                                         ON MovementBoolean_EdiDesadv.MovementId =  Movement.Id
                                        AND MovementBoolean_EdiDesadv.DescId = zc_MovementBoolean_EdiDesadv()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_Print
                                         ON MovementBoolean_Print.MovementId =  Movement.Id
                                        AND MovementBoolean_Print.DescId = zc_MovementBoolean_Print()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_Promo
                                         ON MovementBoolean_Promo.MovementId =  Movement.Id
                                        AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_CurrencyUser
                                         ON MovementBoolean_CurrencyUser.MovementId = Movement.Id
                                        AND MovementBoolean_CurrencyUser.DescId = zc_MovementBoolean_CurrencyUser()
 
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_TotalSumm_GoodsReal
                                         ON MovementBoolean_TotalSumm_GoodsReal.MovementId =  Movement.Id
                                        AND MovementBoolean_TotalSumm_GoodsReal.DescId = zc_MovementBoolean_TotalSumm_GoodsReal()

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

            LEFT JOIN tmpOL_Partner_Unit ON tmpOL_Partner_Unit.ObjectId = Object_To.Id

            -- Сотрудник подписант - контрагент
            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalSigning
                                 ON ObjectLink_Partner_PersonalSigning.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_PersonalSigning.DescId   = zc_ObjectLink_Partner_PersonalSigning()
            LEFT JOIN Object AS Object_PersonalSigning_partner ON Object_PersonalSigning_partner.Id = ObjectLink_Partner_PersonalSigning.ChildObjectId
            /*LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                 ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Partner_PersonalSigning.ChildObjectId
                                AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
            -- Сотрудник подписант - замена
            LEFT JOIN tmpBranch_PersonalBookkeeper AS tmpBranch_PersonalBookkeeper_partner ON tmpBranch_PersonalBookkeeper_partner.MemberId = ObjectLink_Personal_Member.ChildObjectId*/


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

            LEFT JOIN tmpMovementLinkObject_PriceList AS MovementLinkObject_PriceListIn
                                                      ON MovementLinkObject_PriceListIn.MovementId = Movement.Id
                                                     AND MovementLinkObject_PriceListIn.DescId = zc_MovementLinkObject_PriceListIn()
            LEFT JOIN Object AS Object_PriceListIn ON Object_PriceListIn.Id = MovementLinkObject_PriceListIn.ObjectId

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
            LEFT JOIN Object AS Object_StatusMaster ON Object_StatusMaster.Id = Movement_DocumentMaster.Id

            -- ТТН
            LEFT JOIN tmpMovement_TransportGoods AS Movement_TransportGoods ON Movement_TransportGoods.MovementId = Movement.Id
            LEFT JOIN tmpPersonalDriver AS Object_PersonalDriver_TTN ON Object_PersonalDriver_TTN.MovementId =  Movement_TransportGoods.Id
            LEFT JOIN tmpPersonal_4     AS Object_Personal_4_TTN     ON Object_Personal_4_TTN.MovementId     =  Movement_TransportGoods.Id
            

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

            LEFT JOIN tmpMovementDate_Order AS MovementDate_Insert_order
                                            ON MovementDate_Insert_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                           AND MovementDate_Insert_order.DescId = zc_MovementDate_Insert()

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

            LEFT JOIN tmpMovement_ReturnIn AS Movement_ReturnIn ON Movement_ReturnIn.MovementId = Movement.Id

            -- Путевой лист
            LEFT JOIN tmpMovement_Transport AS Movement_Transport ON Movement_Transport.MovementId = Movement.Id

            LEFT JOIN tmpCar AS Object_Car ON Object_Car.MovementId = Movement_Transport.Id

            LEFT JOIN tmpCarModel AS Object_CarModel ON Object_CarModel.CarId = Object_Car.Id

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN tmpPersonalDriver AS Object_PersonalDriver ON Object_PersonalDriver.MovementId =  Movement_Transport.Id

            LEFT JOIN tmpRetail_JuridicalTo ON tmpRetail_JuridicalTo.JuridicalId_To = Object_JuridicalTo.Id

            LEFT JOIN tmpContract_param ON tmpContract_param.ContractId = MovementLinkObject_Contract.ObjectId
            
            LEFT JOIN tmpMovementLinkObject_Branch AS MovementLinkObject_Branch
                                                   ON MovementLinkObject_Branch.MovementId = Movement.Id
                                                  AND MovementLinkObject_Branch.DescId = zc_MovementLinkObject_Branch()

            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                                 ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = MovementLinkObject_Branch.ObjectId
                                AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
            LEFT JOIN Object AS Object_PersonalBookkeeper ON Object_PersonalBookkeeper.Id = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     
            LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                                   ON ObjectString_PersonalBookkeeper.ObjectId = MovementLinkObject_Branch.ObjectId
                                  AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()
                                                              
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
 07.11.24         *
 16.08.24         *
 21.03.22         *
 26.01.22         * 
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
-- SELECT * FROM gpSelect_Movement_Sale_DATA (inStartDate:= '10.01.2022', inEndDate:= '10.01.2022', inIsPartnerDate:= FALSE, inIsErased:= FALSE, inJuridicalBasisId:= 0, inUserId:= zfCalc_UserAdmin() :: Integer)
--Было 1 месяц - 3 мин 21 сек
--сейчас 1 месяц - 28 сек
--select * from gpSelect_Movement_Sale_DATA(instartdate := ('23.10.2024')::TDateTime , inenddate := ('23.10.2024')::TDateTime , inIsPartnerDate := 'False' , inIsErased := 'False' , inJuridicalBasisId := 9399 ,  inUserId:= zfCalc_UserAdmin() :: Integer);
