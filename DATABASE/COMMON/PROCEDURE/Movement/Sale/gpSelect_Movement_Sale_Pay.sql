-- Function: gpSelect_Movement_Sale_Pay()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Pay (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Pay (TDateTime, TDateTime, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Pay(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsPartnerDate      Boolean   ,
    IN inIsErased           Boolean   ,
    IN inJuridicalBasisId   Integer   ,
    IN inSession            TVarChar
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
             , PersonalName TVarChar
             , RetailName_order TVarChar
             , PartnerName_order TVarChar
             , PriceListName TVarChar
             , PriceListInName TVarChar
             , CurrencyDocumentName TVarChar, CurrencyPartnerName TVarChar

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
             , MovementId_ReturnIn Integer, InvNumber_ReturnInFull TVarChar   
             
             , SumPay1     TFloat
             , SumPay2     TFloat
             , SumReturn_1 TFloat
             , SumReturn_2 TFloat   
             , DatePay_1    TDateTime
             , DatePay_2    TDateTime
             , DateReturn_1 TDateTime
             , DateReturn_2 TDateTime
             , TotalSumm_diff TFloat
              )
AS
$BODY$
   DECLARE vbIsIrna Boolean;
   DECLARE vbIsXleb Boolean;
   DECLARE vbIsZp   Boolean;  

   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

      -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);



     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (vbUserId);

     -- !!!Хлеб!!!
     vbIsXleb:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 131936  AND UserId = vbUserId);
     
     vbIsZp:= EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_DocumentZaporozhye() AND Object_RoleAccessKey_View.UserId = vbUserId);

     -- !!!т.к. нельзя когда много данных в гриде!!!
     IF inStartDate + (INTERVAL '200 DAY') <= inEndDate
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
                                      INNER JOIN ObjectLink AS ObjectLink_Branch
                                                            ON ObjectLink_Branch.ObjectId = ObjectLink_Juridical.ObjectId
                                                           AND ObjectLink_Branch.DescId = zc_ObjectLink_BranchJuridical_Branch()
                                 WHERE ObjectLink_Juridical.ChildObjectId > 0
                                   AND ObjectLink_Juridical.DescId = zc_ObjectLink_BranchJuridical_Juridical()
                                   AND ObjectLink_Branch.ChildObjectId IN (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)

                                UNION
                                 SELECT Object_Juridical.Id AS JuridicalId
                                 FROM Object AS Object_Juridical
                                 WHERE Object_Juridical.Id IN (7314357) -- М'ЯСНА ВЕСНА  ТОРГІВЕЛЬНИЙ БУДИНОК ТОВ 
                                   AND Object_Juridical.DescId = zc_Object_Juridical()
                                   AND vbIsZp = TRUE
                                )
        , tmpMovement_all AS (SELECT Movement.Id
                               , Movement.OperDate
                               , Movement.InvNumber
                               , Movement.StatusId
                               , COALESCE (Movement.AccessKeyId, 0) AS AccessKeyId
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
                                         AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                                      )

       , tmpJuridicalTo AS (SELECT ObjectLink_Partner_Juridical.ObjectId AS ToId
                                 , Object_JuridicalTo.*
                            FROM ObjectLink AS ObjectLink_Partner_Juridical
                                 LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId
                            WHERE ObjectLink_Partner_Juridical.ObjectId IN (SELECT DISTINCT tmpMovementLinkObject_To.ObjectId FROM tmpMovementLinkObject_To)
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            )
        , tmpJuridicalDetails AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpJuridicalTo.Id FROM tmpJuridicalTo))

        -- Результат
        SELECT Movement.Id
             , Movement.OperDate
             , Movement.InvNumber
             , Movement.StatusId
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
        WHERE (tmpBranchJuridical.JuridicalId > 0 OR tmpRoleAccessKey.AccessKeyId > 0
               -- Склад ГП ф.Запорожье
            OR (vbIsZp = TRUE AND tmpMovementLinkObject_From.ObjectId = 301309)
            OR vbIsIrna = TRUE
              )
          AND (vbIsIrna IS NULL
            OR (vbIsIrna = FALSE AND COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) <> zc_Business_Irna())
            OR (vbIsIrna = TRUE  AND ObjectLink_Unit_Business.ChildObjectId = zc_Business_Irna())
              );

     -- Результат
     RETURN QUERY
     WITH
          tmpMovement_all AS (SELECT tmpMovement.Id, tmpMovement.OperDate, tmpMovement.InvNumber, tmpMovement.StatusId, tmpMovement.AccessKeyId
                              FROM tmpMovement
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
       , tmpJuridicalDetails AS (SELECT * FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.JuridicalId IN (SELECT DISTINCT tmpJuridicalTo.Id FROM tmpJuridicalTo))

       , tmpMovementLinkObject_From AS (SELECT MovementLinkObject.*
                                        FROM MovementLinkObject
                                        WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                          AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                        )

       , tmpMovementBoolean AS (SELECT MovementBoolean.*
                                FROM MovementBoolean
                                WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                  AND MovementBoolean.DescId IN (zc_MovementBoolean_Checked()
                                                               --, zc_MovementBoolean_EdiOrdspr()
                                                               , zc_MovementBoolean_PriceWithVAT()
                                                               --, zc_MovementBoolean_EdiInvoice()
                                                               --, zc_MovementBoolean_EdiDesadv()
                                                               , zc_MovementBoolean_Print()
                                                               --, zc_MovementBoolean_Promo() 
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
                                                         , zc_MovementDate_Pay_1()
                                                         , zc_MovementDate_Pay_2()
                                                         , zc_MovementDate_Return_1()
                                                         , zc_MovementDate_Return_2()
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
                                                           
                                                           , zc_MovementFloat_Pay_1()
                                                           , zc_MovementFloat_Pay_2()
                                                           , zc_MovementFloat_Return_1()
                                                           , zc_MovementFloat_Return_2() 
                                                            )
                              )


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
                      AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Sale()
                                                        , zc_MovementLinkMovement_Order()
                                                        , zc_MovementLinkMovement_Promo()
                                                       --, zc_MovementLinkMovement_Production()
                                                       -- , zc_MovementLinkMovement_Transport()
                                                       -- , zc_MovementLinkMovement_TransportGoods()
                                                        , zc_MovementLinkMovement_ReturnIn()
                                                       -- , zc_MovementLinkMovement_Master()
                                                         )
                     )
       , tmpMS_InvNumberPartner AS (SELECT MovementString.*
                                    FROM MovementString
                                    WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMLM.MovementChildId FROM tmpMLM WHERE tmpMLM.DescId = zc_MovementLinkMovement_Master())
                                      AND MovementString.DescId = zc_MovementString_InvNumberPartner()
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

     -- Результат
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

           , Object_Personal.ValueData                      AS PersonalName
           , Object_Retail_order.ValueData                  AS RetailName_order
           , Object_Partner_order.ValueData                 AS PartnerName_order

           , Object_PriceList.ValueData                     AS PriceListName
           , Object_PriceListIn.ValueData                   AS PriceListInName
           , Object_CurrencyDocument.ValueData              AS CurrencyDocumentName
           , Object_CurrencyPartner.ValueData               AS CurrencyPartnerName
           
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

           , Movement_ReturnIn.Id                                                                                                AS MovementId_ReturnIn
           , zfCalc_InvNumber_isErased ('', Movement_ReturnIn.InvNumber, Movement_ReturnIn.OperDate, Movement_ReturnIn.StatusId) AS InvNumber_ReturnInFull 
           
           , MovementFloat_Pay_1.ValueData      ::TFloat    AS SumPay1
           , MovementFloat_Pay_2.ValueData      ::TFloat    AS SumPay2
           , MovementFloat_Return_1.ValueData   ::TFloat    AS SumReturn_1
           , MovementFloat_Return_2.ValueData   ::TFloat    AS SumReturn_2    
           
           , MovementDate_Pay_1.ValueData       ::TDateTime AS DatePay_1
           , MovementDate_Pay_2.ValueData       ::TDateTime AS DatePay_2
           , MovementDate_Return_1.ValueData    ::TDateTime AS DateReturn_1
           , MovementDate_Return_2.ValueData    ::TDateTime AS DateReturn_2  
           --
           , (CASE WHEN MovementFloat_Pay_1.ValueData <> 0 OR MovementFloat_Return_1.ValueData <> 0
                     OR MovementFloat_Pay_2.ValueData <> 0 OR MovementFloat_Return_2.ValueData <> 0
                       THEN COALESCE (MovementFloat_TotalSumm.ValueData,0)
                          - (COALESCE (MovementFloat_Pay_1.ValueData,0) - COALESCE (MovementFloat_Return_1.ValueData,0))
                          - (COALESCE (MovementFloat_Pay_2.ValueData,0) - COALESCE (MovementFloat_Return_2.ValueData,0))
                   ELSE 0
              END) ::TFloat AS TotalSumm_diff
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

            LEFT JOIN tmpMovementDate AS MovementDate_Pay_1
                                      ON MovementDate_Pay_1.MovementId =  Movement.Id
                                     AND MovementDate_Pay_1.DescId = zc_MovementDate_Pay_1()
            LEFT JOIN tmpMovementDate AS MovementDate_Pay_2
                                      ON MovementDate_Pay_2.MovementId =  Movement.Id
                                     AND MovementDate_Pay_2.DescId = zc_MovementDate_Pay_2()
            LEFT JOIN tmpMovementDate AS MovementDate_Return_1
                                      ON MovementDate_Return_1.MovementId =  Movement.Id
                                     AND MovementDate_Return_1.DescId = zc_MovementDate_Return_1()
            LEFT JOIN tmpMovementDate AS MovementDate_Return_2
                                      ON MovementDate_Return_2.MovementId =  Movement.Id
                                     AND MovementDate_Return_2.DescId = zc_MovementDate_Return_2()

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

            LEFT JOIN tmpMovementFloat AS MovementFloat_Pay_1
                                       ON MovementFloat_Pay_1.MovementId = Movement.Id
                                      AND MovementFloat_Pay_1.DescId = zc_MovementFloat_Pay_1()
            LEFT JOIN tmpMovementFloat AS MovementFloat_Pay_2
                                       ON MovementFloat_Pay_2.MovementId = Movement.Id
                                      AND MovementFloat_Pay_2.DescId = zc_MovementFloat_Pay_2()
            LEFT JOIN tmpMovementFloat AS MovementFloat_Return_1
                                       ON MovementFloat_Return_1.MovementId = Movement.Id
                                      AND MovementFloat_Return_1.DescId = zc_MovementFloat_Return_1()
            LEFT JOIN tmpMovementFloat AS MovementFloat_Return_2
                                       ON MovementFloat_Return_2.MovementId = Movement.Id
                                      AND MovementFloat_Return_2.DescId = zc_MovementFloat_Return_2()

            LEFT JOIN tmpFrom AS Object_From ON Object_From.MovementId = Movement.Id
            LEFT JOIN tmpTo AS Object_To ON Object_To.MovementId = Movement.Id
            LEFT JOIN tmpJuridicalTo AS Object_JuridicalTo ON Object_JuridicalTo.ToId = Object_To.Id
            LEFT JOIN tmpJuridicalDetails AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalTo.Id
            -- LEFT JOIN tmpBranchJuridical ON tmpBranchJuridical.JuridicalId = Object_JuridicalTo.Id

            LEFT JOIN tmpOL_Partner_Unit ON tmpOL_Partner_Unit.ObjectId = Object_To.Id

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

            LEFT JOIN tmpMovementLinkObject_ReestrKind AS MovementLinkObject_ReestrKind
                                                       ON MovementLinkObject_ReestrKind.MovementId = Movement.Id
                                                      AND MovementLinkObject_ReestrKind.DescId = zc_MovementLinkObject_ReestrKind()
            LEFT JOIN Object AS Object_ReestrKind ON Object_ReestrKind.Id = MovementLinkObject_ReestrKind.ObjectId

            LEFT JOIN tmpMLM AS MovementLinkMovement_Sale
                             ON MovementLinkMovement_Sale.MovementId = Movement.Id
                            AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()

            LEFT JOIN tmpMLM AS MovementLinkMovement_Order
                             ON MovementLinkMovement_Order.MovementId = Movement.Id
                            AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()

            --LEFT JOIN tmpRoute AS Object_Route ON Object_Route.MovementId = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpPersonal AS Object_Personal ON Object_Personal.MovementId = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpPartner AS Object_Partner_order ON Object_Partner_order.MovementId = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpRetail AS Object_Retail_order ON Object_Retail_order.MovementId = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN tmpMovementDate_Order AS MovementDate_Insert_order
                                            ON MovementDate_Insert_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                           AND MovementDate_Insert_order.DescId = zc_MovementDate_Insert()

            LEFT JOIN tmpMovement_Promo AS Movement_Promo ON Movement_Promo.MovementId = Movement.Id

            LEFT JOIN tmpMovementDate_Promo AS MD_StartSale
                                            ON MD_StartSale.MovementId = Movement_Promo.Id
                                           AND MD_StartSale.DescId = zc_MovementDate_StartSale()

            LEFT JOIN tmpMovementDate_Promo AS MD_EndSale
                                            ON MD_EndSale.MovementId = Movement_Promo.Id
                                           AND MD_EndSale.DescId = zc_MovementDate_EndSale()

            LEFT JOIN tmpMovement_ReturnIn AS Movement_ReturnIn ON Movement_ReturnIn.MovementId = Movement.Id

            LEFT JOIN tmpRetail_JuridicalTo ON tmpRetail_JuridicalTo.JuridicalId_To = Object_JuridicalTo.Id
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.09.24         *
*/

-- тест
--
-- SELECT * FROM gpSelect_Movement_Sale_Pay (inStartDate:= '10.01.2022', inEndDate:= '10.01.2022', inIsPartnerDate:= FALSE, inIsErased:= FALSE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
--Было 1 месяц - 3 мин 21 сек
--сейчас 1 месяц - 28 сек

-- SELECT * FROM gpSelect_Movement_Sale_Pay (inStartDate:= '10.09.2024', inEndDate:= '10.09.2024', inIsPartnerDate:= FALSE, inIsErased:= FALSE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())

