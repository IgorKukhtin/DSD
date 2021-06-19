-- Function: gpSelect_Movement_Sale_ExpInvoice_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Invoice_Print (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_ExpInvoice_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_ExpInvoice_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbPaidKindId Integer;
    DECLARE vbContractId Integer;

    DECLARE vbCurrencyDocumentId Integer;
    DECLARE vbCurrencyPartnerId Integer;
    DECLARE vbCurrencyPartnerValue TFloat;
    DECLARE vbParPartnerValue TFloat;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;
    
    DECLARE vbWeighingCount Integer;
    
    DECLARE vbTotalSumm     TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- кол-во Взвешиваний / паллет
     vbWeighingCount:= (SELECT COUNT(*)
                        FROM Movement
                        WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       );

     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END    AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END     AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)     AS GoodsPropertyId_basis
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)      AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId

          , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
          , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())  AS CurrencyPartnerId
          , COALESCE (MovementFloat_CurrencyPartnerValue.ValueData, 0)                        AS CurrencyPartnerValue
          , COALESCE (MovementFloat_ParPartnerValue.ValueData, 0)                             AS ParPartnerValue
          
          , MovementFloat_TotalSumm.ValueData AS TotalSumm

            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis, vbPaidKindId, vbContractId
               , vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyPartnerValue, vbParPartnerValue
               , vbTotalSumm
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
          LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                  ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
          LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                  ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                 AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                       ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                      AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                       ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                      AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()*/
     WHERE Movement.Id = inMovementId
    ;

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

    --проверка выбрана ли валюта
    IF COALESCE (vbCurrencyDocumentId, 0) = zc_Enum_Currency_Basis() AND vbTotalSumm <> 0
    THEN
        RAISE EXCEPTION 'Ошибка.Валюта документа должна отличаться от базовой в <%>.', lfGet_Object_ValueData_sh (zc_Enum_Currency_Basis());
    END IF;
    --
    IF COALESCE (vbCurrencyPartnerValue, 0) = 0 AND vbTotalSumm <> 0 AND (vbCurrencyDocumentId <> vbCurrencyPartnerId)
    THEN
        RAISE EXCEPTION 'Ошибка.Не определен курс валюты';
    END IF;
    --
    OPEN Cursor1 FOR
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , Movement.OperDate                          AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner

           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh

           , MovementFloat_AmountCurrency.ValueData     AS TotalSummCurrency

           , Object_From.ValueData             		    AS FromName
           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName
           , View_Contract.InvNumber        		    AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKindName


           , ObjectString_ToAddress.ValueData           AS PartnerAddress_To
           , OH_JuridicalDetails_To.JuridicalId         AS JuridicalId_To
           , OH_JuridicalDetails_To.FullName            AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress    AS JuridicalAddress_To
           , OH_JuridicalDetails_To.OKPO                AS OKPO_To
           , OH_JuridicalDetails_To.INN                 AS INN_To
           , OH_JuridicalDetails_To.NumberVAT           AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName       AS AccounterName_To
           , OH_JuridicalDetails_To.BankAccount         AS BankAccount_To
           , OH_JuridicalDetails_To.BankName            AS BankName_To
           , OH_JuridicalDetails_To.MFO                 AS BankMFO_To
           , OH_JuridicalDetails_To.Phone               AS Phone_To
           , ObjectString_BuyerGLNCode.ValueData        AS BuyerGLNCode
           , ObjectString_DELIVERYPLACEGLNCode.ValueData AS DELIVERYPLACEGLNCode
           , '' ::TVarChar AS Sign_


           , OH_JuridicalDetails_From.JuridicalId       AS JuridicalId_From
           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName     AS AccounterName_From
           , OH_JuridicalDetails_From.BankAccount       AS BankAccount_From
           , OH_JuridicalDetails_From.BankName          AS BankName_From
           , OH_JuridicalDetails_From.MFO               AS BankMFO_From
           , OH_JuridicalDetails_From.Phone             AS Phone_From
           , ObjectString_SupplierGLNCode.ValueData     AS SupplierGLNCode

           , Object_BankAccount.Name                            AS BankAccount_ByContract
--           , 'российских рублях' :: TVarChar                    AS CurrencyInternalAll_ByContract
           , Object_BankAccount.CurrencyInternalName            AS CurrencyInternal_ByContract
           , CASE WHEN COALESCE (Object_BankAccount.BankName,'') = '' THEN 'Введите Банк'            ELSE Object_BankAccount.BankName END  AS BankName_ByContract
           , CASE WHEN COALESCE (Object_BankAccount.MFO,'') = ''      THEN 'Введите МФО банка'       ELSE Object_BankAccount.MFO END       AS BankMFO_ByContract
           , CASE WHEN COALESCE (Object_BankAccount.SWIFT,'') = ''    THEN 'Введите SWIFT-код банка' ELSE Object_BankAccount.SWIFT END     AS BankSWIFT_ByContract
           , Object_BankAccount.IBAN                            AS BankIBAN_ByContract
           
           , CASE WHEN COALESCE (Object_BankAccount.BeneficiarysBankName,'') = ''          THEN 'Введите банка-Бенефициар'              ELSE Object_BankAccount.BeneficiarysBankName           END  AS BenefBankName_ByContract
           , CASE WHEN COALESCE (OHS_JD_JuridicalAddress_BenifBank_From.ValueData,'') = '' THEN 'Введите адрес банка-Бенефициар'       ELSE OHS_JD_JuridicalAddress_BenifBank_From.ValueData   END  AS JurAddrBenifBank_ByContract
           , CASE WHEN COALESCE (Object_Bank_View_BenifBank_From.SWIFT,'') = ''            THEN 'Введите SWIFT-код банка-Бенефициар'   ELSE Object_Bank_View_BenifBank_From.SWIFT              END  AS BenifBankSWIFT_ByContract
           , CASE WHEN COALESCE (Object_BankAccount.BeneficiarysBankAccount,'') = ''       THEN 'Введите Р/счет банка-Бенефициар'      ELSE Object_BankAccount.BeneficiarysBankAccount         END  AS BenefBankAccount_ByContract

           , CASE WHEN COALESCE (Object_BankAccount.CorrespondentBankName,'') = ''        THEN 'Введите Банк-корреспондент'            ELSE Object_BankAccount.CorrespondentBankName        END AS CorrBankName_ByContract
           , CASE WHEN COALESCE (Object_Bank_View_CorrespondentBank_From.SWIFT,'') = ''   THEN 'Введите SWIFT-код банка-корреспондент' ELSE Object_Bank_View_CorrespondentBank_From.SWIFT   END AS CorrBankSWIFT_ByContract
           , CASE WHEN COALESCE (Object_BankAccount.CorrespondentAccount,'') = ''         THEN 'Введите P/счет банка-корреспондент'    ELSE Object_BankAccount.CorrespondentAccount         END AS CorrespondentAccount_ByContract
           , CASE WHEN COALESCE (OHS_JD_JuridicalAddress_Bank_From.ValueData,'') = ''     THEN 'Введите Адрес банка'                   ELSE OHS_JD_JuridicalAddress_Bank_From.ValueData     END AS JuridicalAddressBankFrom
           , CASE WHEN COALESCE (OHS_JD_JuridicalAddress_CorrBank_From.ValueData,'') = '' THEN 'Введите Адрес банка-корреспондент'     ELSE OHS_JD_JuridicalAddress_CorrBank_From.ValueData END AS JuridicalAddressCorrBankFrom


           , CASE WHEN COALESCE (BankAccount_To.BankName,'') = ''        THEN 'Введите Банк-корреспондент' ELSE BankAccount_To.BankName          END AS BankName_Int
           , CASE WHEN COALESCE (BankAccount_To.Name,'') = ''        THEN 'Введите р/счет Банка-корреспондент'     ELSE BankAccount_To.Name      END AS BankAccount_Int

           , CASE WHEN COALESCE (BankAccount_To.CorrespondentBankName,'') = ''             THEN 'Введите Банк-корреспондент'            ELSE BankAccount_To.CorrespondentBankName             END  AS CorBankName_Int
           , CASE WHEN COALESCE (Object_Bank_View_CorrespondentBank.JuridicalName,'') = '' THEN 'Введите Юр. наименование Банка-корреспондент'            ELSE Object_Bank_View_CorrespondentBank.JuridicalName END  AS CorBankJuridicalName_Int
           , CASE WHEN COALESCE (Object_Bank_View_CorrespondentBank.SWIFT,'') = ''         THEN 'Введите SWIFT-код Банк-корреспондент'  ELSE Object_Bank_View_CorrespondentBank.SWIFT         END  AS CorBankSWIFT_Int

           , CASE WHEN COALESCE (BankAccount_To.BeneficiarysBankName,'') = ''             THEN 'Введите банка-Бенефициар'            ELSE BankAccount_To.BeneficiarysBankName              END  AS BenefBankName_Int
           , CASE WHEN COALESCE (OHS_JD_JuridicalAddress_BenifBank_To.ValueData,'') = ''  THEN 'Введите адрес банка-Бенефициар'       ELSE OHS_JD_JuridicalAddress_BenifBank_To.ValueData   END  AS JuridicalAddressBenifBank_Int
           , CASE WHEN COALESCE (Object_Bank_View_BenifBank.SWIFT,'') = ''                THEN 'Введите SWIFT-код банка-Бенефициар'   ELSE Object_Bank_View_BenifBank.SWIFT                 END  AS BenifBankSWIFT_Int
           , CASE WHEN COALESCE (BankAccount_To.BeneficiarysBankAccount,'') = ''          THEN 'Введите Р/счет банка-Бенефициар'      ELSE BankAccount_To.BeneficiarysBankAccount           END  AS BenefBankAccount_Int

           , CASE WHEN COALESCE (BankAccount_To.MFO,'') = ''          THEN 'Введите МФО Банка'        ELSE BankAccount_To.MFO    END AS BankMFO_Int
           , CASE WHEN COALESCE (BankAccount_To.SWIFT,'') = ''        THEN 'Введите SWIFT-код банка'  ELSE BankAccount_To.SWIFT  END AS BankSWIFT_Int
           , BankAccount_To.IBAN                                AS BankIBAN_Int

           , CASE WHEN COALESCE (Object_Bank_View_To.JuridicalName,'') = ''    THEN 'Введите Бенефициара'         ELSE Object_Bank_View_To.JuridicalName     END             AS BankJuridicalName_Int
           , CASE WHEN COALESCE (OHS_JD_JuridicalAddress_To.ValueData,'') = '' THEN 'Введите Адрес бенефициара'   ELSE OHS_JD_JuridicalAddress_To.ValueData  END             AS BankJuridicalAddress_Int
           , CASE WHEN COALESCE (BankAccount_To.BeneficiarysAccount,'') = ''   THEN 'Введите Р/счет Бенефициара'  ELSE BankAccount_To.BeneficiarysAccount    END             AS BenefAccount_Int
           , CASE WHEN COALESCE (BankAccount_To.Name,'') = ''                  THEN 'Введите Р/счет'              ELSE BankAccount_To.Name                   END             AS BankAccount_Int
           , CASE WHEN COALESCE (ObjectString_BankAccountPartner.ValueData,'') = '' THEN 'Введите Р/счет (покупателя)' ELSE ObjectString_BankAccountPartner.ValueData END         AS BankAccountPartner_Int

           , View_CurrencyPartner.Name                          AS CurrencyPartnerName
           , View_CurrencyPartner.InternalName                  AS IntCurShortName
           , View_CurrencyPartner.Name                          AS IntCurName

           , CASE WHEN View_CurrencyPartner.Code = 980
                  THEN 'украинских гривнах'
                  WHEN View_CurrencyPartner.Code = 840
                  THEN 'долларах США'
                  WHEN View_CurrencyPartner.Code = 643
                  THEN 'российских рублях'
             ELSE '' END                                        AS IntCurNameAllName
           
           , vbWeighingCount ::TFloat AS WeighingCount

       FROM Movement
            LEFT JOIN Object_Currency_View AS View_CurrencyPartner ON View_CurrencyPartner.Id = vbCurrencyPartnerId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()

-- Contract
            /*LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN ( zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())*/
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = vbContractId -- MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = View_Contract.ContractId -- MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'
            LEFT JOIN ObjectString AS ObjectString_BankAccount --исх счет по дог
                                   ON ObjectString_BankAccount.ObjectId = View_Contract.ContractId
                                  AND ObjectString_BankAccount.DescId = zc_objectString_Contract_BankAccount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectString AS ObjectString_DELIVERYPLACEGLNCode
                                   ON ObjectString_DELIVERYPLACEGLNCode.ObjectId = Object_To.Id
                                  AND ObjectString_DELIVERYPLACEGLNCode.DescId = zc_ObjectString_Partner_GLNCode()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectString AS ObjectString_BuyerGLNCode
                                   ON ObjectString_BuyerGLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_BuyerGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (View_Contract.JuridicalBasisId, Object_From.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectString AS ObjectString_SupplierGLNCode
                                   ON ObjectString_SupplierGLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_SupplierGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
-- bank account
            LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                                 ON ObjectLink_Contract_BankAccount.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()

            LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_InfoMoney
                                 ON ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
                                AND ObjectLink_BankAccountContract_InfoMoney.ChildObjectId = View_Contract.InfoMoneyId
                                AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL
            LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                                 ON ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
                                AND ObjectLink_BankAccountContract_BankAccount.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
            LEFT JOIN (SELECT ObjectLink_BankAccountContract_BankAccount.ChildObjectId
                       FROM ObjectLink AS ObjectLink_BankAccountContract_InfoMoney
                            JOIN ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                                                 ON ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
                                                AND ObjectLink_BankAccountContract_BankAccount.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
                                                AND ObjectLink_BankAccountContract_BankAccount.ChildObjectId IS NOT NULL

                       WHERE ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
                         AND ObjectLink_BankAccountContract_InfoMoney.ChildObjectId IS NULL
                      ) AS ObjectLink_BankAccountContract_BankAccount_all ON ObjectLink_BankAccountContract_BankAccount.ChildObjectId IS NULL -- !!!не ошибка!!!, выбирается с пустой УП
                                                                         AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL

            LEFT JOIN Object_BankAccount_View AS Object_BankAccount ON Object_BankAccount.Id = COALESCE (ObjectLink_Contract_BankAccount.ChildObjectId, COALESCE (ObjectLink_BankAccountContract_BankAccount.ChildObjectId, ObjectLink_BankAccountContract_BankAccount_all.ChildObjectId))


            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Bank_From
                                                                ON OH_JuridicalDetails_Bank_From.JuridicalId = Object_BankAccount.BankJuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Bank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Bank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_Bank_From
                                          ON OHS_JD_JuridicalAddress_Bank_From.ObjectHistoryId = OH_JuridicalDetails_Bank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_Bank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

            LEFT JOIN Object_Bank_View AS Object_Bank_View_CorrespondentBank_From ON Object_Bank_View_CorrespondentBank_From.Id = Object_BankAccount.CorrespondentBankId
            LEFT JOIN Object_Bank_View AS Object_Bank_View_BenifBank_From ON Object_Bank_View_BenifBank_From.Id = Object_BankAccount.BeneficiarysBankId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_CorrBank_From
                                                                ON OH_JuridicalDetails_CorrBank_From.JuridicalId = Object_Bank_View_CorrespondentBank_From.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_CorrBank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_CorrBank_From.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_BenifBank_From
                                                                ON OH_JuridicalDetails_BenifBank_From.JuridicalId = Object_Bank_View_BenifBank_From.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_BenifBank_From.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_BenifBank_From.EndDate

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_BenifBank_From
                                          ON OHS_JD_JuridicalAddress_BenifBank_From.ObjectHistoryId = OH_JuridicalDetails_BenifBank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_BenifBank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

            LEFT JOIN ObjectHistoryString AS OHS_JD_JuridicalAddress_CorrBank_From
                                          ON OHS_JD_JuridicalAddress_CorrBank_From.ObjectHistoryId = OH_JuridicalDetails_CorrBank_From.ObjectHistoryId
                                         AND OHS_JD_JuridicalAddress_CorrBank_From.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()

-- +++++++++++++++++ BANK TO

            LEFT JOIN ObjectString AS ObjectString_BankAccountPartner
                                   ON ObjectString_BankAccountPartner.ObjectId = View_Contract.ContractId
                                  AND ObjectString_BankAccountPartner.DescId = zc_objectString_Contract_BankAccountPartner()

            LEFT JOIN --список счетов.имя = исх счет по дог.знач
                      (SELECT Object_BankAccount_View.*
                       FROM Object_BankAccount_View
                       LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = inMovementId
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                            ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                      WHERE Object_BankAccount_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
--                      LIMIT 1
                      ) AS BankAccount_To ON BankAccount_To.Name = ObjectString_BankAccount.ValueData


         LEFT JOIN Object_Bank_View AS Object_Bank_View_CorrespondentBank ON Object_Bank_View_CorrespondentBank.Id = BankAccount_To.CorrespondentBankId
         LEFT JOIN Object_Bank_View AS Object_Bank_View_BenifBank ON Object_Bank_View_BenifBank.Id = BankAccount_To.BeneficiarysBankId
         LEFT JOIN Object_Bank_View AS Object_Bank_View_To ON Object_Bank_View_To.Id = BankAccount_To.BankId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_BenifBank_To
                                                                ON OH_JuridicalDetails_BenifBank_To.JuridicalId = Object_Bank_View_BenifBank.JuridicalId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_BenifBank_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_BenifBank_To.EndDate

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

--
       WHERE Movement.Id =  inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_GroupName.ValueData     AS GroupName
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

             LEFT JOIN ObjectString AS ObjectString_GroupName
                                    ON ObjectString_GroupName.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_GroupName.DescId = zc_ObjectString_GoodsPropertyValue_GroupName()

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Name
             , tmpObject_GoodsPropertyValue.BarCode
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.GroupName
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Name <> '' OR BarCode <> '' OR Article <> '' OR GroupName <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )
     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
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
       SELECT
             Object_Goods.ObjectCode         AS GoodsCode
           , Object_GoodsGroup.ValueData     AS GoodsGroupName
           , 'Колбасные изделия в ассортименте и консервы тушеные' ::TVarChar AS GoodsGroupName_1801161421 -- группа товара для ООО Абоа
           , Object_TradeMark.ValueData      AS TradeMarkName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName_two
           , Object_GoodsKind.ValueData         AS GoodsKindName
           , Object_Measure.ValueData           AS MeasureName
           , OS_Measure_InternalCode.ValueData  AS MeasureIntCode

           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , (tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) :: TFloat AS AmountPartner_Weight

           , tmpMI.CountForPrice             AS CountForPrice
           , tmpMI.Price                     AS Price
           , CASE WHEN vbCurrencyDocumentId = zc_Enum_Currency_Basis() AND vbCurrencyPartnerId = zc_Enum_Currency_Basis()
                       THEN 0
                  WHEN vbCurrencyDocumentId = vbCurrencyPartnerId
                       THEN tmpMI.Price
                       -- так переводится в валюту vbCurrencyPartnerId
                  ELSE CAST (tmpMI.Price * CASE WHEN vbCurrencyPartnerValue <> 0 THEN vbParPartnerValue / vbCurrencyPartnerValue ELSE 0 END AS NUMERIC (16, 3))
             END AS Price_Curr

             -- сумма в валюте
           , CAST (
             CASE WHEN vbCurrencyDocumentId = zc_Enum_Currency_Basis() AND vbCurrencyPartnerId = zc_Enum_Currency_Basis()
                       THEN 0
                  WHEN vbCurrencyDocumentId = vbCurrencyPartnerId
                       THEN tmpMI.Price
                       -- так переводится в валюту vbCurrencyPartnerId
                  ELSE CAST (tmpMI.Price * CASE WHEN vbCurrencyPartnerValue <> 0 THEN vbParPartnerValue / vbCurrencyPartnerValue ELSE 0 END AS NUMERIC (16, 3))
             END
           * tmpMI.AmountPartner
           * CASE WHEN tmpMI.CountForPrice <> 0 THEN 1 / tmpMI.CountForPrice ELSE 1 END
             AS NUMERIC (16, 2)) AS AmountSumm_Curr


           , COALESCE (tmpObject_GoodsPropertyValue.GroupName, '')  AS GroupName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')       AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)      AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')    AS BarCode_Juridical

           , CAST ((COALESCE (tmpMI.AmountPartner, 0) * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) AS TFloat) AS Netto_Weight
           , CAST ((COALESCE (tmpMI.AmountPartner, 0) * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END )) + (COALESCE (tmpMI.BoxCount_summ, 0)) AS TFloat) AS Brutto_Weight
           , CAST (COALESCE (tmpMI.Box_Count, 0)  AS TFloat) AS Box_Count

           , CASE WHEN COALESCE (tmpMI.AmountPartner_all,0) <> 0 THEN vbWeighingCount * COALESCE (tmpMI.AmountPartner, 0)* (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END ) / tmpMI.AmountPartner_all ELSE 0 END ::TFloat AS WeighingCount

       FROM (SELECT MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                  , CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price

                  , MIFloat_CountForPrice.ValueData AS CountForPrice
                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))    AS AmountPartner

                  , COALESCE (MIFloat_BoxCount.ValueData, 0)               AS Box_Count
                  , SUM (COALESCE (OF_Box_Weight.ValueData, 0) * COALESCE (MIFloat_BoxCount.ValueData, 0)) AS BoxCount_summ
                  , SUM ( SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) ) OVER ()               AS AmountPartner_all
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                           --AND MIFloat_Price.ValueData <> 0
                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                  LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                              ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                   ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
                  LEFT JOIN ObjectFloat AS OF_Box_Weight
                                        ON OF_Box_Weight.ObjectId = MILinkObject_Box.ObjectId
                                       AND OF_Box_Weight.DescId = zc_ObjectFloat_Box_Weight()

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , MIFloat_Price.ValueData
                    , MIFloat_CountForPrice.ValueData
                    , COALESCE (MIFloat_BoxCount.ValueData, 0)

            ) AS tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            LEFT JOIN ObjectString AS OS_Measure_InternalCode
                                   ON OS_Measure_InternalCode.ObjectId = Object_Measure.Id
                                  AND OS_Measure_InternalCode.DescId = zc_ObjectString_Measure_InternalCode()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                 ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId


            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId

       WHERE tmpMI.AmountPartner <> 0
       ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_ExpInvoice_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.11.14                                        * all
 13.11.14                                                       * from sale_print
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_ExpInvoice_Print (inMovementId := 570596, inSession:= zfCalc_UserAdmin()); -- FETCH ALL "<unnamed portal 1>";
