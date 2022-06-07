-- Function: gpSelect_Movement_OrderExternal_PrintBill()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderExternal_PrintBill (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderExternal_PrintBill(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbDescId              Integer;
    DECLARE vbStatusId            Integer;
    DECLARE vbPriceWithVAT        Boolean;
    DECLARE vbVATPercent          TFloat;
    DECLARE vbDiscountPercent     TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbContractId          Integer;
    DECLARE vbRetailId            Integer;
    DECLARE vbFromId              Integer;
    DECLARE vbUnitId              Integer;
    DECLARE vbJuridicalId         Integer;
    DECLARE vbOperDate            TDateTime;
    DECLARE vbIsOrderByLine       Boolean;
    DECLARE vbPaidKindId          Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)  AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)         AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END  AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId), COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)      AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)       AS ContractId
          , COALESCE (MovementLinkObject_Retail.ObjectId, 0)         AS RetailId
          , COALESCE (MovementLinkObject_From.ObjectId, 0)           AS FromId
          , COALESCE (MovementLinkObject_To.ObjectId, 0)             AS UnitId
          , ObjectLink_Partner_Juridical.ChildObjectId               AS JuridicalId
          , CASE WHEN Movement.AccessKeyId IN (zc_Enum_Process_AccessKey_DocumentKiev(), zc_Enum_Process_AccessKey_DocumentLviv()) THEN TRUE ELSE FALSE END AS isOrderByLine
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)        AS PaidKindId
            INTO vbDescId, vbStatusId, vbOperDate, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
               , vbGoodsPropertyId, vbGoodsPropertyId_basis, vbContractId, vbRetailId, vbFromId, vbUnitId, vbJuridicalId, vbIsOrderByLine 
               , vbPaidKindId
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                       ON MovementLinkObject_Retail.MovementId = Movement.Id
                                      AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.Id
                                      AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                      AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()  
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind())
     WHERE Movement.Id = inMovementId;
     

-- if vbUserId = 5
-- then
--     RAISE EXCEPTION '<%>', lfGet_Object_ValueData(vbGoodsPropertyId);
-- end if;

     -- очень важная проверка
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
     THEN
         IF vbStatusId = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         IF vbStatusId = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
     END IF;

     
                     
      --
     OPEN Cursor1 FOR
    WITH
    tmpBankAccount AS (SELECT ObjectLink_BankAccountContract_BankAccount.ChildObjectId             AS BankAccountId
                            , COALESCE (ObjectLink_BankAccountContract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId
                            , COALESCE (ObjectLink_BankAccountContract_Unit.ChildObjectId, 0)      AS UnitId
                       FROM ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                            LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_InfoMoney
                                                 ON ObjectLink_BankAccountContract_InfoMoney.ObjectId = ObjectLink_BankAccountContract_BankAccount.ObjectId
                                                AND ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
                            LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_Unit
                                                  ON ObjectLink_BankAccountContract_Unit.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
                                                 AND ObjectLink_BankAccountContract_Unit.DescId = zc_ObjectLink_BankAccountContract_Unit()
                       WHERE ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
                         AND ObjectLink_BankAccountContract_BankAccount.ChildObjectId IS NOT NULL
                      )
  , tmpObject_Bank_View AS(SELECT *
                           FROM Object_Bank_View)

  , tmpMovementDate AS (SELECT *
                          FROM MovementDate
                          WHERE MovementDate.MovementId = inMovementId
                            AND MovementDate.DescId IN (zc_MovementDate_Payment()
                                                      , zc_MovementDate_OperDatePartner()
                                                         )
                          )

  , tmpMovementFloat AS (SELECT *
                          FROM MovementFloat
                          WHERE MovementFloat.MovementId = inMovementId
                            AND MovementFloat.DescId IN (zc_MovementFloat_TotalCountPartner()
                                                        , zc_MovementFloat_TotalCountKg()
                                                        , zc_MovementFloat_TotalCountSh()
                                                        , zc_MovementFloat_TotalSummMVAT()
                                                        , zc_MovementFloat_TotalSummPVAT()
                                                        , zc_MovementFloat_TotalSumm()  
                                                        , zc_MovementFloat_TotalSummTare() 
                                                        , zc_MovementFloat_TotalCountTare()
                                                         )
                          )

  , tmpMovement AS (SELECT * FROM Movement WHERE Movement.Id = inMovementId)

       SELECT
             Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
--         , Movement.InvNumber                         AS InvNumber
           , CASE WHEN Movement.DescId = zc_Movement_Sale()
                       THEN Movement.InvNumber
                  WHEN Movement.DescId = zc_Movement_TransferDebtOut() AND MovementString_InvNumberPartner.ValueData <> ''
                       THEN COALESCE (MovementString_InvNumberPartner.ValueData, Movement.InvNumber)
                  WHEN Movement.DescId = zc_Movement_TransferDebtOut() AND MovementString_InvNumberPartner.ValueData = ''
                       THEN Movement.InvNumber
                  ELSE Movement.InvNumber
             END AS InvNumber

           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner

           , EXTRACT (DAY FROM Movement.OperDate) :: Integer AS OperDate_day
           , COALESCE (EXTRACT (DAY FROM MovementDate_OperDatePartner.ValueData), 0) :: Integer AS OperDatePartner_day

           , Movement.OperDate                          AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate ) :: TDateTime AS OperDatePartner
          -- , MovementDate_Payment.ValueData             AS PaymentDate
          -- , CASE WHEN MovementDate_Payment.ValueData IS NOT NULL THEN TRUE ELSE FALSE END :: Boolean AS isPaymentDate

           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent  AS ChangePercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , FLOOR (MovementFloat_TotalCount.ValueData) AS TotalCount_floor

           , MovementFloat_TotalCountKg.ValueData  AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData  AS TotalCountSh

           , COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)
             + COALESCE (CAST (MovementFloat_TotalSummTare.ValueData - MovementFloat_TotalSummTare.ValueData * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4)),0) AS TotalSummMVAT 
           
           , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0)
              + COALESCE (MovementFloat_TotalSummTare.ValueData,0) AS TotalSummPVAT

           , (MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData 
                  + COALESCE (CAST ( MovementFloat_TotalSummTare.ValueData * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4)),0) ) AS SummVAT
           
           , MovementFloat_TotalSumm.ValueData  AS TotalSumm
           , (MovementFloat_TotalSumm.ValueData *(1 - (vbVATPercent / (vbVATPercent + 100))))  TotalSummMVAT_Info                                                                                                                            
           --Сумма оборотной тары
           , MovementFloat_TotalSummTare.ValueData AS TotalSummPVAT_Tare -- c НДС
           
           , CAST (MovementFloat_TotalSummTare.ValueData - MovementFloat_TotalSummTare.ValueData * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4)) AS TotalSummMVAT_Tare --  без НДС


           , Object_From.ValueData             		AS FromName
           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName
          -- , Object_PaidKind.ValueData         		AS PaidKindName
           , View_Contract.InvNumber        		AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind
           , COALESCE (ObjectString_PartnerCode.ValueData, '') :: TVarChar AS PartnerCode


           , CASE WHEN COALESCE (Object_PersonalStore_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_PersonalStore_View.PersonalName, 2, FALSE) ELSE '' END  AS StoreKeeper -- кладовщик
           , '' :: TVarChar                             AS Through     -- через кого
           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('32516492', '39135315', '39622918') THEN 'м. Київ, вул Ольжича, 18/22' ELSE '' END :: TVarChar  AS UnitAddress -- адреса складання

           , ObjectString_Partner_ShortName.ValueData   AS ShortNamePartner_To
           , ObjectString_ToAddress.ValueData           AS PartnerAddress_To

           , (CASE WHEN ObjectString_PostalCode.ValueData  <> '' THEN ObjectString_PostalCode.ValueData || ' '      ELSE '' END
           || CASE WHEN View_Partner_Address.RegionName    <> '' THEN View_Partner_Address.RegionName   || ' обл., ' ELSE '' END
           || CASE WHEN View_Partner_Address.ProvinceName  <> '' THEN View_Partner_Address.ProvinceName || ' р-н, '  ELSE '' END
           || ObjectString_ToAddress.ValueData
             ) :: TVarChar            AS PartnerAddressAll_To
           , OH_JuridicalDetails_To.JuridicalId         AS JuridicalId_To
           , COALESCE (Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName) AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To
           , OH_JuridicalDetails_To.INN                 AS INN_To
           , OH_JuridicalDetails_To.NumberVAT           AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName       AS AccounterName_To
           , OH_JuridicalDetails_To.MainName            AS MainName_To
           , OH_JuridicalDetails_To.BankAccount         AS BankAccount_To
           , OH_JuridicalDetails_To.BankName            AS BankName_To
           , OH_JuridicalDetails_To.MFO                 AS BankMFO_To
           , OH_JuridicalDetails_To.Phone               AS Phone_To

           , COALESCE (OH_JuridicalDetails_Invoice.JuridicalId,      OH_JuridicalDetails_To.JuridicalId)         AS JuridicalId_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.FullName, COALESCE (Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName)) AS JuridicalName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.JuridicalAddress, OH_JuridicalDetails_To.JuridicalAddress)    AS JuridicalAddress_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.OKPO,             OH_JuridicalDetails_To.OKPO)                AS OKPO_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.INN,              OH_JuridicalDetails_To.INN)                 AS INN_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.NumberVAT,        OH_JuridicalDetails_To.NumberVAT)           AS NumberVAT_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.AccounterName,    OH_JuridicalDetails_To.AccounterName)       AS AccounterName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.MainName,         OH_JuridicalDetails_To.MainName)            AS MainName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.BankAccount,      OH_JuridicalDetails_To.BankAccount)         AS BankAccount_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.BankName,         OH_JuridicalDetails_To.BankName)            AS BankName_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.MFO,              OH_JuridicalDetails_To.MFO)                 AS BankMFO_Invoice
           , COALESCE (OH_JuridicalDetails_Invoice.Phone,            OH_JuridicalDetails_To.Phone)               AS Phone_Invoice

           , CASE WHEN COALESCE (Object_PersonalCollation.ValueData, '') = '' THEN '' ELSE zfConvert_FIO (Object_PersonalCollation.ValueData, 2, FALSE) END :: TVarChar        AS PersonalCollationName

          /* , ObjectString_Partner_GLNCode.ValueData     AS DeliveryPlaceGLNCode
           , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                     ) AS BuyerGLNCode

           , zfCalc_GLNCodeRetail (inGLNCode               := ObjectString_Partner_GLNCode.ValueData
                                 , inGLNCodeRetail_partner := ObjectString_Partner_GLNCodeRetail.ValueData
                                 , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                                 , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                  ) AS RecipientGLNCode

           , CASE WHEN 1=0 AND OH_JuridicalDetails_To.JuridicalId = 15158 -- МЕТРО Кеш енд Кері Україна ТОВ
                       THEN '' -- если Метро, тогда наш = "пусто"
                  ELSE zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                              , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                              , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                              , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                               )
             END :: TVarChar AS SupplierGLNCode

           , zfCalc_GLNCodeCorporate (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeCorporate_partner := ObjectString_Partner_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_retail  := ObjectString_Retail_GLNCodeCorporate.ValueData
                                    , inGLNCodeCorporate_main    := ObjectString_JuridicalFrom_GLNCode.ValueData
                                     ) AS SenderGLNCode 
                                     */

           , OH_JuridicalDetails_From.JuridicalId       AS JuridicalId_From
           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName     AS AccounterName_From
           , CASE WHEN COALESCE (OH_JuridicalDetails_From.MainName, '') = '' THEN '' ELSE zfConvert_FIO (OH_JuridicalDetails_From.MainName, 2, FALSE) END :: TVarChar   AS MainName_From --- , zfConvert_FIO (OH_JuridicalDetails_From.MainName, 2, FALSE)          AS MainName_From
           , OH_JuridicalDetails_From.BankAccount       AS BankAccount_From
           , OH_JuridicalDetails_From.BankName          AS BankName_From
           , OH_JuridicalDetails_From.MFO               AS BankMFO_From
           , OH_JuridicalDetails_From.Phone             AS Phone_From

           , Object_BankAccount.Name                            AS BankAccount_ByContract
           , 'российских рублях' :: TVarChar                    AS CurrencyInternalAll_ByContract
           , Object_BankAccount.CurrencyInternalName            AS CurrencyInternal_ByContract
           , Object_BankAccount.BankName                        AS BankName_ByContract
           , Object_BankAccount.MFO                             AS BankMFO_ByContract
           , Object_BankAccount.SWIFT                           AS BankSWIFT_ByContract
           , Object_BankAccount.IBAN                            AS BankIBAN_ByContract
           , Object_BankAccount.CorrespondentBankName           AS CorrBankName_ByContract
           , Object_Bank_View_CorrespondentBank_From.SWIFT      AS CorrBankSWIFT_ByContract
           , Object_BankAccount.CorrespondentAccount            AS CorrespondentAccount_ByContract
           , OHS_JD_JuridicalAddress_Bank_From.ValueData        AS JuridicalAddressBankFrom
           , OHS_JD_JuridicalAddress_CorrBank_From.ValueData    AS JuridicalAddressCorrBankFrom


           , BankAccount_To.BankName                            AS BankName_Int
           , BankAccount_To.Name                                AS BankAccount_Int

           , BankAccount_To.CorrespondentBankName               AS CorBankName_Int
           , Object_Bank_View_CorrespondentBank.JuridicalName   AS CorBankJuridicalName_Int
           , Object_Bank_View_CorrespondentBank.SWIFT           AS CorBankSWIFT_Int

           , BankAccount_To.BeneficiarysBankName                AS BenefBankName_Int
           , OHS_JD_JuridicalAddress_BenifBank_To.ValueData     AS JuridicalAddressBenifBank_Int
           , Object_Bank_View_BenifBank.SWIFT                   AS BenifBankSWIFT_Int
           , BankAccount_To.BeneficiarysBankAccount             AS BenefBankAccount_Int

           , BankAccount_To.MFO                                 AS BankMFO_Int
           , BankAccount_To.SWIFT                               AS BankSWIFT_Int
           , BankAccount_To.IBAN                                AS BankIBAN_Int

           , Object_Bank_View_To.JuridicalName                  AS BankJuridicalName_Int
           , OHS_JD_JuridicalAddress_To.ValueData               AS BankJuridicalAddress_Int
           , BankAccount_To.BeneficiarysAccount                 AS BenefAccount_Int
           , BankAccount_To.Name                                AS BankAccount_Int

           --, MS_InvNumberPartner_Master.ValueData               AS InvNumberPartner_Master

           , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '')
                  ELSE '' -- 'м.Днiпро'
                  END  :: TVarChar   AS PlaceOf
           , CASE WHEN COALESCE (Object_Personal_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_Personal_View.PersonalName, 2, FALSE) ELSE '' END AS PersonalBookkeeperName   -- бухгалтер из спр.Филиалы

             -- Мiсце складання
           , 'м.Дніпро' :: TVarChar AS CityOf

             -- для договора Id = 4440485(№7183Р(14781)) + доп страничка
           , CASE WHEN vbContractId = 4440485 THEN TRUE ELSE FALSE END :: Boolean AS isFozzyPage2

             -- этому Юр Лицу печатается "За довіренністю ...."
           --, vbIsOKPO_04544524 :: Boolean AS isOKPO_04544524
           --
       FROM tmpMovement AS Movement

            LEFT JOIN tmpMovementDate AS MovementDate_Payment
                                      ON MovementDate_Payment.MovementId =  Movement.Id
                                     AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                       ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCountPartner()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                       ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountSh
                                       ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                      AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                       ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                       ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummTare
                                       ON MovementFloat_TotalSummTare.MovementId =  Movement.Id
                                      AND MovementFloat_TotalSummTare.DescId = zc_MovementFloat_TotalSummTare()
                                      
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_To()    --наоборот для счета , чтоб не переделывать печать счета
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                AND vbContractId = 0

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf
                                   ON ObjectString_PlaceOf.ObjectId = COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()
            LEFT JOIN ObjectLink AS ObjectLink_Branch_Personal
                                 ON ObjectLink_Branch_Personal.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                AND ObjectLink_Branch_Personal.DescId = zc_ObjectLink_Branch_Personal()
            LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Branch_Personal.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                                 ON ObjectLink_Branch_PersonalStore.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                AND ObjectLink_Branch_PersonalStore.DescId = zc_ObjectLink_Branch_PersonalStore()
            LEFT JOIN Object_Personal_View AS Object_PersonalStore_View ON Object_PersonalStore_View.PersonalId = ObjectLink_Branch_PersonalStore.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_From()    --наоборот для счета , чтоб не переделывать печать счета
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()
            LEFT JOIN ObjectString AS ObjectString_Partner_ShortName
                                   ON ObjectString_Partner_ShortName.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_ShortName.DescId = zc_ObjectString_Partner_ShortName()
            LEFT JOIN Object_Partner_Address_View AS View_Partner_Address ON View_Partner_Address.PartnerId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
            LEFT JOIN ObjectString AS ObjectString_PostalCode
                                   ON ObjectString_PostalCode.ObjectId = View_Partner_Address.StreetId
                                  AND ObjectString_PostalCode.DescId = zc_ObjectString_Street_PostalCode()

            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'
            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()                                                                                      
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                 ON ObjectLink_Contract_PersonalCollation.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
            LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = ObjectLink_Contract_PersonalCollation.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                                 ON ObjectLink_Contract_JuridicalInvoice.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_JuridicalInvoice.DescId = zc_ObjectLink_Contract_JuridicalInvoice()
            -- код поставщика
            LEFT JOIN ObjectString AS ObjectString_PartnerCode
                                   ON ObjectString_PartnerCode.ObjectId = View_Contract.ContractId
                                  AND ObjectString_PartnerCode.DescId = zc_objectString_Contract_PartnerCode()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Invoice
                                                                ON OH_JuridicalDetails_Invoice.JuridicalId = ObjectLink_Contract_JuridicalInvoice.ChildObjectId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Invoice.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Invoice.EndDate

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectString AS ObjectString_Juridical_GLNCode
                                   ON ObjectString_Juridical_GLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_Juridical_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCode
                                   ON ObjectString_Retail_GLNCode.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCode.DescId = zc_ObjectString_Retail_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Retail_GLNCodeCorporate
                                   ON ObjectString_Retail_GLNCodeCorporate.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                  AND ObjectString_Retail_GLNCodeCorporate.DescId = zc_ObjectString_Retail_GLNCodeCorporate()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (ObjectLink_Contract_JuridicalDocument.ChildObjectId
                                                                                                        , COALESCE (View_Contract.JuridicalBasisId
                                                                                                        , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId
                                                                                                                  , Object_From.Id)))
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate
            LEFT JOIN ObjectString AS ObjectString_JuridicalFrom_GLNCode
                                   ON ObjectString_JuridicalFrom_GLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_JuridicalFrom_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

-- bank account
            LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                 ON ObjectLink_Contract_BankAccount.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()

            LEFT JOIN tmpBankAccount AS tmpBankAccount1 ON tmpBankAccount1.UnitId      = MovementLinkObject_From.ObjectId
                                                       AND tmpBankAccount1.InfoMoneyId = View_Contract.InfoMoneyId
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
            LEFT JOIN tmpBankAccount AS tmpBankAccount2 ON tmpBankAccount2.UnitId      = MovementLinkObject_From.ObjectId
                                                       AND tmpBankAccount2.InfoMoneyId = 0
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                       AND tmpBankAccount1.BankAccountId IS NULL
            LEFT JOIN tmpBankAccount AS tmpBankAccount3 ON tmpBankAccount3.UnitId      = 0
                                                       AND tmpBankAccount3.InfoMoneyId = View_Contract.InfoMoneyId
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                       AND tmpBankAccount1.BankAccountId IS NULL
                                                       AND tmpBankAccount2.BankAccountId IS NULL
            LEFT JOIN tmpBankAccount AS tmpBankAccount4 ON tmpBankAccount4.UnitId      = 0
                                                       AND tmpBankAccount4.InfoMoneyId = 0
                                                       AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
                                                       AND tmpBankAccount1.BankAccountId IS NULL
                                                       AND tmpBankAccount2.BankAccountId IS NULL
                                                       AND tmpBankAccount3.BankAccountId IS NULL
            LEFT JOIN Object_BankAccount_View AS Object_BankAccount ON Object_BankAccount.Id = COALESCE (ObjectLink_Contract_BankAccount.ChildObjectId, COALESCE (tmpBankAccount1.BankAccountId, COALESCE (tmpBankAccount2.BankAccountId, COALESCE (tmpBankAccount3.BankAccountId, tmpBankAccount4.BankAccountId))))

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Bank_From
                                                                ON OH_JuridicalDetails_Bank_From.JuridicalId = Object_BankAccount.BankJuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Bank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Bank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_Bank_From
                                          ON OHS_JD_JuridicalAddress_Bank_From.ObjectHistoryId = OH_JuridicalDetails_Bank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_Bank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_CorrespondentBank_From ON Object_Bank_View_CorrespondentBank_From.Id = Object_BankAccount.CorrespondentBankId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_CorrBank_From
                                                                ON OH_JuridicalDetails_CorrBank_From.JuridicalId = Object_Bank_View_CorrespondentBank_From.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_CorrBank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_CorrBank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_CorrBank_From
                                          ON OHS_JD_JuridicalAddress_CorrBank_From.ObjectHistoryId = OH_JuridicalDetails_CorrBank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_CorrBank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

-- +++++++++++++++++ BANK TO
            LEFT JOIN
                      (SELECT *
                       FROM Object_BankAccount_View
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = inMovementId
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                            ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()


                      WHERE Object_BankAccount_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                      LIMIT 1
                      ) AS BankAccount_To ON 1=1

            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_CorrespondentBank ON Object_Bank_View_CorrespondentBank.Id = BankAccount_To.CorrespondentBankId
            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_BenifBank ON Object_Bank_View_BenifBank.Id = BankAccount_To.BeneficiarysBankId
            LEFT JOIN tmpObject_Bank_View AS Object_Bank_View_To ON Object_Bank_View_To.Id = BankAccount_To.BankId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_BenifBank_To
                                                                ON OH_JuridicalDetails_BenifBank_To.JuridicalId = Object_Bank_View_BenifBank.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_BenifBank_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) < OH_JuridicalDetails_BenifBank_To.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_BenifBank_To
                                          ON OHS_JD_JuridicalAddress_BenifBank_To.ObjectHistoryId = OH_JuridicalDetails_BenifBank_To.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_BenifBank_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()


            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetailsBank_To
                                                                ON OH_JuridicalDetailsBank_To.JuridicalId = Object_Bank_View_To.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetailsBank_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetailsBank_To.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_To
                                          ON OHS_JD_JuridicalAddress_To.ObjectHistoryId = OH_JuridicalDetailsBank_To.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_To.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

       WHERE Movement.Id = inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
       RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
    WITH 
    tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectFloat_BoxCount.ValueData       AS BoxCount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
             , ObjectString_CodeSticker.ValueData   AS CodeSticker 
             , COALESCE (ObjectBoolean_Weigth.ValueData, FALSE) :: Boolean AS isWeigth
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

             LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                   ON ObjectFloat_BoxCount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
             LEFT JOIN ObjectString AS ObjectString_CodeSticker
                                    ON ObjectString_CodeSticker.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_CodeSticker.DescId = zc_ObjectString_GoodsPropertyValue_CodeSticker()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind() 

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Weigth
                                     ON ObjectBoolean_Weigth.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                    AND ObjectBoolean_Weigth.DescId = zc_ObjectBoolean_GoodsPropertyValue_Weigth()
        WHERE Object_GoodsPropertyValue.ValueData  <> ''
           OR ObjectString_BarCode.ValueData       <> ''
           OR ObjectString_Article.ValueData       <> ''
           OR ObjectString_BarCodeGLN.ValueData    <> ''
           OR ObjectString_ArticleGLN.ValueData    <> ''
           OR ObjectString_CodeSticker.ValueData   <> ''
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.BoxCount
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' OR ArticleGLN <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
  , tmpMI_All AS (SELECT MovementItem.Id        AS MovementItemId
                       , MovementItem.ObjectId AS GoodsId
                       , MovementItem.Amount   AS Amount
                  FROM  MovementItem
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                  )
  , tmpMI_Float AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_All.MovementItemId FROM tmpMI_All) 
                      AND MovementItemFloat.DESCId IN ( zc_MIFloat_Price(), zc_MIFloat_AmountSecond(), zc_MIFloat_CountForPrice(), zc_MIFloat_Summ())
                   )
  , tmpMI_LO AS (SELECT MovementItemLinkObject.*
                 FROM MovementItemLinkObject
                 WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_All.MovementItemId FROM tmpMI_All) 
                   AND MovementItemLinkObject.DESCId = zc_MILinkObject_GoodsKind()
                )

  , tmpMI AS (SELECT MAX (tmpMI_All.MovementItemId) AS MovementItemId
                   , tmpMI_All.GoodsId 
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , CASE WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , MIFloat_CountForPrice.ValueData AS CountForPrice
                   , SUM (tmpMI_All.Amount) AS Amount
                   , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS AmountSecond
                   , SUM (COALESCE (MIFloat_Summ.ValueData, 0)) AS Summ
              FROM tmpMI_All
                   LEFT JOIN tmpMI_Float AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = tmpMI_All.MovementItemId
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN tmpMI_Float AS MIFloat_AmountSecond
                                         ON MIFloat_AmountSecond.MovementItemId = tmpMI_All.MovementItemId
                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                   LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                         ON MIFloat_CountForPrice.MovementItemId = tmpMI_All.MovementItemId
                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN tmpMI_Float AS MIFloat_Summ
                                         ON MIFloat_Summ.MovementItemId = tmpMI_All.MovementItemId
                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
 
                   LEFT JOIN tmpMI_LO AS MILinkObject_GoodsKind
                                      ON MILinkObject_GoodsKind.MovementItemId = tmpMI_All.MovementItemId
                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              GROUP BY tmpMI_All.GoodsId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
             )

       SELECT
             CASE WHEN vbIsOrderByLine = TRUE THEN row_number() OVER (ORDER BY tmpMI.MovementItemId) ELSE 0 END :: Integer AS LineNum
           --, ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                AS GoodsGroupName
           , Object_Goods.ObjectCode  			        AS GoodsCode
           , Object_Goods.ValueData                     AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two

           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.Amount          :: TFloat AS Amount
           , tmpMI.AmountSecond    :: TFloat AS AmountSecond
           , tmpMI.Price           :: TFloat AS Price
           , tmpMI.CountForPrice   :: TFloat AS CountForPrice

           --если  isWeigth = true - тогда в amountpartner - для шт. вернуть вес, в measurename - вернуть кг.
           , CASE WHEN COALESCE (tmpObject_GoodsPropertyValue.isWeigth, FALSE) = FALSE THEN tmpMI.Amount
                  ELSE CAST ((tmpMI.Amount * (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat)
             END                             AS AmountPartner

           , CASE WHEN vbPriceWithVAT = FALSE OR vbVATPercent = 0
                       -- если цены без НДС или %НДС = 0
                       THEN tmpMI.AmountSumm
                       -- если цены с НДС
                  ELSE CAST ((tmpMI.Summ / (1 + vbVATPercent / 100)) AS NUMERIC (16, 2))
             END :: TFloat AS SummMVAT

           , tmpMI.Summ :: TFloat AS SummPVAT

           , CAST (tmpMI.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                       THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)))
                                       ELSE tmpMI.Price
                                  END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT

             -- расчет суммы с НДС, до 3 знаков
           , CAST (tmpMI.Amount * CASE WHEN vbPriceWithVAT <> TRUE
                                       THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                       ELSE tmpMI.Price
                                  END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT
       FROM (SELECT tmpMI.MovementItemId
                  , tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.Price
                  , tmpMI.CountForPrice
                  , tmpMI.Amount
                  , tmpMI.AmountSecond
                  , tmpMI.Summ
                  , CAST ((tmpMI.Amount + tmpMI.AmountSecond) * tmpMI.Price / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END AS NUMERIC (16, 2)) AS AmountSumm
             FROM tmpMI

            ) AS tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
       WHERE tmpMI.Amount <> 0 OR tmpMI.AmountSecond <> 0
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.06.22         * 
*/

-- тест
-- 
SELECT * FROM gpSelect_Movement_OrderExternal_PrintBill (inMovementId := 388160, inSession:= zfCalc_UserAdmin())
