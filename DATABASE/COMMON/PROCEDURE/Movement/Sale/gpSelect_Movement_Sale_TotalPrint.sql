-- Function: gpSelect_Movement_Sale_TotalPrint()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_TotalPrint (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_TotalPrint (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_TotalPrint (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_TotalPrint(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inContractId        Integer  , -- ключ Документа
    IN inToId              Integer  , -- Id контрагента
    IN inIsList            Boolean  , -- печать по списку документов
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;

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
    DECLARE vbIsChangePrice Boolean;
    DECLARE vbIsDiscountPrice Boolean;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;

    DECLARE vbIsProcess_BranchIn Boolean;

    DECLARE vbWeighingCount   Integer;
    DECLARE vbStoreKeeperName TVarChar;

    DECLARE vbIsInfoMoney_30201 Boolean;

    DECLARE vbIsKiev Boolean;
    
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);
     
 
     vbGoodsPropertyId_basis := zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0);

    -- таб. документов по Договору    -- параметры из документов
    CREATE TEMP TABLE tmpListDocSale(MovementId Integer, OperDate TDateTime, OperDatePartner TDateTime, PriceWithVAT Boolean, VATPercent TFloat, DiscountPercent TFloat, ExtraChargesPercent TFloat, GoodsPropertyId Integer, ContractId Integer, PaidKindId Integer, IsDiscountPrice Boolean, IsChangePrice Boolean) ON COMMIT DROP;
    INSERT INTO tmpListDocSale(MovementId, OperDate, OperDatePartner, PriceWithVAT, VATPercent, DiscountPercent, ExtraChargesPercent, GoodsPropertyId, ContractId, PaidKindId, IsDiscountPrice, IsChangePrice)
       WITH
       tmpMovement AS (SELECT Movement.Id 
                            , Movement.OperDate
                            , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                       FROM Movement
                          INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                 AND MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                          INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                       AND MovementLinkObject_Contract.ObjectId = inContractId
                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                       AND (MovementLinkObject_To.ObjectId = inToId OR inToId = 0)
                       WHERE Movement.DescId = zc_Movement_Sale()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND inIsList = FALSE
                      UNION
                       SELECT Movement.Id 
                            , Movement.OperDate
                            , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                       FROM (SELECT DISTINCT LockUnique.KeyData ::Integer AS Id
                             FROM LockUnique 
                             WHERE LockUnique.UserId = vbUserId --AND LockUnique.OperDate = CURRENT_DATE
                             ) AS tmp
                          LEFT JOIN Movement ON Movement.Id = tmp.Id
                                            AND Movement.DescId = zc_Movement_Sale()
                                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                       WHERE inIsList = TRUE
                      )
                      
       SELECT tmpMovement.Id AS MovementId
          , tmpMovement.OperDate
          , tmpMovement.OperDatePartner
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN      MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , zfCalc_GoodsPropertyId (inContractId, COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId), MovementLinkObject_To.ObjectId) AS GoodsPropertyId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)        AS ContractId
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)        AS PaidKindId
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE) AS isDiscountPrice
          , CASE WHEN (COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE) = TRUE
                    OR COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) = zc_Enum_PaidKind_FirstForm()
                    OR COALESCE (MovementFloat_ChangePercent.ValueData, 0) <> 0 ) 
                 THEN TRUE 
                 ELSE FALSE END    AS IsChangePrice
       FROM tmpMovement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = tmpMovement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId = tmpMovement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = tmpMovement.Id
                                 AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = tmpMovement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = tmpMovement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = tmpMovement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice();            
     --!!!!!!!!!!!!!!!!!!!!!
     ANALYZE tmpListDocSale;

     -- !!! для Киева + Львов
     vbIsKiev:= EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = (SELECT MAX (tmpListDocSale.MovementId) FROM tmpListDocSale) AND MLO.ObjectId IN (8411, 3080691) AND MLO.DescId = zc_MovementLinkObject_From());

     -- параметры из Взвешивания
     vbStoreKeeperName:= (SELECT Object_User.ValueData
                          FROM (SELECT MAX (tmpListDocSale.MovementId) AS MovementId
                                FROM tmpListDocSale
                                )tmpMovement
                               LEFT JOIN Movement ON Movement.ParentId = tmpMovement.MovementId 
                                                 AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                            ON MovementLinkObject_User.MovementId = Movement.Id
                                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                          LIMIT 1
                         );

     -- кол-во Взвешиваний
     vbWeighingCount:= (SELECT COUNT(*)
                        FROM Movement
                        WHERE Movement.ParentId IN (SELECT tmpListDocSale.MovementId FROM tmpListDocSale)
                          AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       );

    -- Параметр для Доходы + Продукция + Тушенка
    vbIsInfoMoney_30201:= EXISTS (SELECT 1
                                  FROM tmpListDocSale
                                       INNER JOIN MovementItem ON MovementItem.MovementId = tmpListDocSale.MovementId
                                                              AND MovementItem.DescId     = zc_MI_Master()
                                                              AND MovementItem.isErased   = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                             ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId 
                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                            AND ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30102()
                                 );


     --
    OPEN Cursor1 FOR

       WITH tmpBankAccount AS (SELECT ObjectLink_BankAccountContract_BankAccount.ChildObjectId             AS BankAccountId
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
       SELECT Movement.Id                                     
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           
           , (lpad(date_part('day' ,inEndDate)::tvarchar, 2, '0')
            || lpad(date_part('month' ,inEndDate)::tvarchar, 2, '0')  
            || date_part('year' ,inEndDate))   ::tvarchar              AS InvNumber

           , MovementString_InvNumberPartner.ValueData                 AS InvNumberPartner

           , CASE WHEN MovementString_InvNumberPartner_order.ValueData <> ''
                       THEN CASE WHEN zfConvert_StringToNumber (MovementString_InvNumberPartner_order.ValueData) <> 0
                                      THEN zfConvert_StringToNumber (MovementString_InvNumberPartner_order.ValueData) :: TVarChar
                                 ELSE MovementString_InvNumberPartner_order.ValueData
                            END
                  WHEN MovementString_InvNumberOrder.ValueData <> ''
                       THEN MovementString_InvNumberOrder.ValueData
                  ELSE COALESCE (Movement_order.InvNumber, '')
             END AS InvNumberOrder

           , EXTRACT (DAY FROM Movement.OperDate) :: Integer AS OperDate_day
           , COALESCE (EXTRACT (DAY FROM MovementDate_OperDatePartner.ValueData), 0) :: Integer AS OperDatePartner_day

           , Movement.OperDate                          AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, CASE WHEN Movement.DescId <> zc_Movement_Sale() THEN Movement.OperDate END) AS OperDatePartner
           , MovementDate_Payment.ValueData             AS PaymentDate
           , CASE WHEN MovementDate_Payment.ValueData IS NOT NULL THEN TRUE ELSE FALSE END AS isPaymentDate
           , COALESCE (Movement_order.OperDate, Movement.OperDate) AS OperDateOrder

           , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) :: Boolean AS PriceWithVAT
           , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
           , tmpMovement.ChangePercent
           , tmpMovement.TotalCount
           , tmpMovement.TotalCount_floor
           , tmpMovement.TotalCountKg
           , tmpMovement.TotalCountSh
           , tmpMovement.TotalSummMVAT
           , tmpMovement.TotalSummPVAT
           , tmpMovement.SummVAT
           , tmpMovement.TotalSumm
           , tmpMovement.TotalSummMVAT_Info

           , Object_From.ValueData             		AS FromName
           , CASE WHEN vbIsKiev = TRUE THEN TRUE ELSE FALSE END AS isPrintPageBarCode
           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName
           , Object_PaidKind.ValueData         		AS PaidKindName
           , View_Contract.InvNumber        		AS ContractName
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind

           , Object_RouteSorting.ValueData 	        AS RouteSortingName

           , CASE WHEN COALESCE (Object_PersonalStore_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_PersonalStore_View.PersonalName, 2, FALSE) ELSE vbStoreKeeperName END  AS StoreKeeper -- кладовщик
           , '' :: TVarChar                             AS Through     -- через кого
           , CASE WHEN OH_JuridicalDetails_To.OKPO IN ('32516492', '39135315', '39622918') THEN 'м. Київ, вул Ольжича, 18/22' ELSE '' END :: TVarChar  AS UnitAddress -- адреса складання

           , CASE -- !!!захардкодил временно для Запорожье!!!
                  WHEN MovementLinkObject_From.ObjectId IN (301309) -- Склад ГП ф.Запорожье
                   AND Object_PaidKind.Id = zc_Enum_PaidKind_SecondForm()
                       THEN FALSE
                  WHEN ObjectLink_Contract_JuridicalDocument.ChildObjectId > 0
                   AND Movement.AccessKeyId <> zc_Enum_Process_AccessKey_DocumentKiev()
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isJuridicalDocument
           , CASE WHEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) = zc_Branch_Basis()
                       THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isBranchBasis

           , ObjectString_Partner_ShortName.ValueData   AS ShortNamePartner_To
           , ObjectString_ToAddress.ValueData           AS PartnerAddress_To

           , (CASE WHEN ObjectString_PostalCode.ValueData  <> '' THEN ObjectString_PostalCode.ValueData || ' '      ELSE '' END
           || CASE WHEN View_Partner_Address.RegionName    <> '' THEN View_Partner_Address.RegionName   || ' обл., ' ELSE '' END
           || CASE WHEN View_Partner_Address.ProvinceName  <> '' THEN View_Partner_Address.ProvinceName || ' р-н, '  ELSE '' END
           || ObjectString_ToAddress.ValueData
             ) :: TVarChar            AS PartnerAddressAll_To
           , OH_JuridicalDetails_To.JuridicalId         AS JuridicalId_To
           , COALESCE (Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName) AS JuridicalName_To
           , COALESCE (OH_JuridicalDetails_Invoice.FullName, COALESCE (Object_ArticleLoss.ValueData, OH_JuridicalDetails_To.FullName)) AS JuridicalName_Invoice
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

           , CASE WHEN COALESCE (Object_PersonalCollation.ValueData, '') = '' THEN '' ELSE zfConvert_FIO (Object_PersonalCollation.ValueData, 2, FALSE) END :: TVarChar        AS PersonalCollationName
      
           , ObjectString_Partner_GLNCode.ValueData     AS DeliveryPlaceGLNCode
    
           , zfCalc_GLNCodeJuridical (inGLNCode                  := ObjectString_Partner_GLNCode.ValueData
                                    , inGLNCodeJuridical_partner := ObjectString_Partner_GLNCodeJuridical.ValueData
                                    , inGLNCodeJuridical         := ObjectString_Juridical_GLNCode.ValueData
                                     ) AS BuyerGLNCode

           , zfCalc_GLNCodeRetail (inGLNCode               := ObjectString_Partner_GLNCode.ValueData
                                 , inGLNCodeRetail_partner := ObjectString_Partner_GLNCodeRetail.ValueData
                                 , inGLNCodeRetail         := ObjectString_Retail_GLNCode.ValueData
                                 , inGLNCodeJuridical      := ObjectString_Juridical_GLNCode.ValueData
                                  ) AS RecipientGLNCode

           , CASE WHEN OH_JuridicalDetails_To.JuridicalId = 15158 -- МЕТРО Кеш енд Кері Україна ТОВ
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


           , COALESCE (MovementLinkMovement_Sale.MovementChildId, 0)  AS EDIId

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

           , MS_InvNumberPartner_Master.ValueData               AS InvNumberPartner_Master

           , CASE WHEN (tmpMovement.ChangePercent <> 0) AND Object_PaidKind.Id = zc_Enum_PaidKind_SecondForm() 
                        THEN ' та знижкой'
                  ELSE ''
             END AS Price_info

           , vbIsInfoMoney_30201 AS isInfoMoney_30201

           , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '') 
                  ELSE 'м.Днiпро' 
                  END  :: TVarChar   AS PlaceOf 
           , CASE WHEN COALESCE (Object_Personal_View.PersonalName, '') <> '' THEN zfConvert_FIO (Object_Personal_View.PersonalName, 2, FALSE) ELSE '' END AS PersonalBookkeeperName   -- бухгалтер из спр.Филиалы 
           
           , MovementSale_Comment.ValueData        AS SaleComment 
           , CASE WHEN TRIM (MovementOrder_Comment.ValueData) <> TRIM (COALESCE (MovementSale_Comment.ValueData, '')) THEN MovementOrder_Comment.ValueData ELSE '' END AS OrderComment
           , FALSE AS isPrintText

             -- кол-во Взвешиваний
           , vbWeighingCount AS WeighingCount

           , CASE WHEN EXISTS (SELECT 1 FROM tmpListDocSale WHERE tmpListDocSale.PaidKindId = zc_Enum_PaidKind_FirstForm()) THEN TRUE ELSE FALSE END :: Boolean AS isFirstForm

           , 'м.Дніпро' :: TVarChar AS CityOf                             -- Мiсце складання

             -- для договора Id = 4440485(№7183Р(14781)) + доп страничка
           , CASE WHEN EXISTS (SELECT 1 FROM tmpListDocSale WHERE tmpListDocSale.ContractId = 4440485) THEN TRUE ELSE FALSE END :: Boolean AS isFozzyPage2
           
             -- этому Юр Лицу печатается "За довіренністю ...."
           , FALSE :: Boolean AS isOKPO_04544524

       FROM (SELECT Max(tmpListDocSale.MovementId) AS MovementId
                  , MAX(tmpListDocSale.ExtraChargesPercent - tmpListDocSale.DiscountPercent)  AS ChangePercent
                  , Sum(MovementFloat_TotalCount.ValueData)         AS TotalCount
                  , Sum(FLOOR (MovementFloat_TotalCount.ValueData)) AS TotalCount_floor
                  , Sum(MovementFloat_TotalCountKg.ValueData)       AS TotalCountKg
                  , Sum(MovementFloat_TotalCountSh.ValueData)       AS TotalCountSh
                  , Sum(MovementFloat_TotalSummMVAT.ValueData)      AS TotalSummMVAT
                  , Sum(MovementFloat_TotalSummPVAT.ValueData)      AS TotalSummPVAT
                  , Sum(MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData) AS SummVAT
                  , Sum(MovementFloat_TotalSumm.ValueData)          AS TotalSumm
                  , Sum(MovementFloat_TotalSumm.ValueData *(1 - (tmpListDocSale.VATPercent / (tmpListDocSale.VATPercent + 100)))) TotalSummMVAT_Info
             FROM tmpListDocSale 
                  LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                          ON MovementFloat_TotalCount.MovementId = tmpListDocSale.MovementId
                                         AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
                  LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                          ON MovementFloat_TotalCountKg.MovementId = tmpListDocSale.MovementId
                                         AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                  LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                          ON MovementFloat_TotalCountSh.MovementId = tmpListDocSale.MovementId
                                         AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()
                  LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                          ON MovementFloat_TotalSummMVAT.MovementId = tmpListDocSale.MovementId
                                         AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                  LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                          ON MovementFloat_TotalSummPVAT.MovementId = tmpListDocSale.MovementId
                                         AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
                  LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                          ON MovementFloat_TotalSumm.MovementId = tmpListDocSale.MovementId
                                         AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
             ) AS tmpMovement
            INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Sale
                                           ON MovementLinkMovement_Sale.MovementId = Movement.Id
                                          AND MovementLinkMovement_Sale.DescId = zc_MovementLinkMovement_Sale()
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
            LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner_order
                                     ON MovementString_InvNumberPartner_order.MovementId =  Movement_order.Id
                                    AND MovementString_InvNumberPartner_order.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementString AS MovementSale_Comment 
                                     ON MovementSale_Comment.MovementId = Movement.Id
                                    AND MovementSale_Comment.DescId = zc_MovementString_Comment()
            LEFT JOIN MovementString AS MovementOrder_Comment 
                                     ON MovementOrder_Comment.MovementId = Movement_order.Id
                                    AND MovementOrder_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Payment
                                   ON MovementDate_Payment.MovementId =  Movement.Id
                                  AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                AND inContractId = 0

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_From.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf
                                   ON ObjectString_PlaceOf.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
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
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
-- Contract
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = inContractId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = View_Contract.ContractId 
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'
            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = View_Contract.ContractId 
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                AND Object_PaidKind.Id = zc_Enum_PaidKind_SecondForm()
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                                 ON ObjectLink_Contract_PersonalCollation.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
            LEFT JOIN Object AS Object_PersonalCollation ON Object_PersonalCollation.Id = ObjectLink_Contract_PersonalCollation.ChildObjectId
                                
            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCode
                                   ON ObjectString_Partner_GLNCode.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeJuridical
                                   ON ObjectString_Partner_GLNCodeJuridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCodeJuridical.DescId = zc_ObjectString_Partner_GLNCodeJuridical()
            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeRetail
                                   ON ObjectString_Partner_GLNCodeRetail.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                  AND ObjectString_Partner_GLNCodeRetail.DescId = zc_ObjectString_Partner_GLNCodeRetail()
            LEFT JOIN ObjectString AS ObjectString_Partner_GLNCodeCorporate
                                   ON ObjectString_Partner_GLNCodeCorporate.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, Object_To.Id)
                                 AND ObjectString_Partner_GLNCodeCorporate.DescId = zc_ObjectString_Partner_GLNCodeCorporate()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_To.Id)
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_To.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_To.EndDate
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
                                  
            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                                 ON ObjectLink_Contract_JuridicalInvoice.ObjectId = View_Contract.ContractId
                                AND ObjectLink_Contract_JuridicalInvoice.DescId = zc_ObjectLink_Contract_JuridicalInvoice()
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_Invoice
                                                                ON OH_JuridicalDetails_Invoice.JuridicalId = ObjectLink_Contract_JuridicalInvoice.ChildObjectId
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= OH_JuridicalDetails_Invoice.StartDate
                                                               AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) <  OH_JuridicalDetails_Invoice.EndDate

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

            LEFT JOIN Object_Bank_View AS Object_Bank_View_CorrespondentBank_From ON Object_Bank_View_CorrespondentBank_From.Id = Object_BankAccount.CorrespondentBankId

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
                       LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                              ON ObjectLink_Contract_Juridical.ObjectId = inContractId 
                             AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                      WHERE Object_BankAccount_View.JuridicalId = ObjectLink_Contract_Juridical.ChildObjectId
                      LIMIT 1
                      ) AS BankAccount_To ON 1=1

            LEFT JOIN Object_Bank_View AS Object_Bank_View_CorrespondentBank ON Object_Bank_View_CorrespondentBank.Id = BankAccount_To.CorrespondentBankId
            LEFT JOIN Object_Bank_View AS Object_Bank_View_BenifBank ON Object_Bank_View_BenifBank.Id = BankAccount_To.BeneficiarysBankId
            LEFT JOIN Object_Bank_View AS Object_Bank_View_To ON Object_Bank_View_To.Id = BankAccount_To.BankId

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
--
            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                           ON MovementLinkMovement_Master.MovementId = Movement.Id
                                          AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
            LEFT JOIN MovementString AS MS_InvNumberPartner_Master ON MS_InvNumberPartner_Master.MovementId = MovementLinkMovement_Master.MovementChildId
                                                                  AND MS_InvNumberPartner_Master.DescId = zc_MovementString_InvNumberPartner()
     ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectFloat_BoxCount.ValueData       AS BoxCount             
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
        FROM (SELECT DISTINCT tmpListDocSale.GoodsPropertyId AS GoodsPropertyId FROM tmpListDocSale WHERE tmpListDocSale.GoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
             LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                   ON ObjectFloat_BoxCount.ObjectId = Object_GoodsPropertyValue.Id
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
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.ArticleGLN
             , tmpObject_GoodsPropertyValue.BarCode
             , tmpObject_GoodsPropertyValue.BarCodeGLN
             , tmpObject_GoodsPropertyValue.BoxCount             
        FROM (SELECT MAX (tmpObject_GoodsPropertyValue.ObjectId) AS ObjectId, GoodsId FROM tmpObject_GoodsPropertyValue WHERE Article <> '' OR ArticleGLN <> '' OR BarCode <> '' OR BarCodeGLN <> '' OR Name <> '' GROUP BY GoodsId
             ) AS tmpGoodsProperty_find
             LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.ObjectId =  tmpGoodsProperty_find.ObjectId
       )

     , tmpObject_GoodsPropertyValue_basis AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectString_BarCode.ValueData       AS BarCode
        FROM (SELECT vbGoodsPropertyId_basis AS GoodsPropertyId
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             INNER JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                           -- AND Object_GoodsPropertyValue.ValueData <> ''
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
       )
    
 , tmpMI AS (SELECT MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND (tmpListDocSale.IsChangePrice = TRUE OR COALESCE (MIFloat_ChangePercent.ValueData, 0) <> 0) -- !!!для НАЛ не учитываем, но НЕ всегда!!!
                              THEN zfCalc_PriceTruncate (inOperDate     := tmpListDocSale.OperDatePartner
                                                       , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                       , inPrice        := MIFloat_Price.ValueData
                                                       , inIsWithVAT    := tmpListDocSale.PriceWithVAT
                                                        )
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price
                  , MIFloat_CountForPrice.ValueData AS CountForPrice
                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale())
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                   ELSE MovementItem.Amount

                         END) AS AmountPartner
                  , tmpListDocSale.PriceWithVAT
                  , tmpListDocSale.DiscountPercent
                  , tmpListDocSale.ExtraChargesPercent
                  , tmpListDocSale.GoodsPropertyId
                  , tmplistdocsale.ischangeprice
                  , tmpListDocSale.vatpercent
             FROM tmpListDocSale
                  LEFT JOIN MovementItem ON MovementItem.MovementId = tmpListDocSale.MovementId
                                        AND MovementItem.DescId     = zc_MI_Master()
                                        AND MovementItem.isErased   = FALSE
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
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

                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                              ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND (tmpListDocSale.IsChangePrice = TRUE OR COALESCE (MIFloat_ChangePercent.ValueData, 0) <> 0) -- !!!для НАЛ не учитываем, но НЕ всегда!!!
                                THEN zfCalc_PriceTruncate (inOperDate     := tmpListDocSale.OperDatePartner
                                                         , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                         , inPrice        := MIFloat_Price.ValueData
                                                         , inIsWithVAT    := tmpListDocSale.PriceWithVAT
                                                          )
                           ELSE COALESCE (MIFloat_Price.ValueData, 0)
                      END
                    , MIFloat_CountForPrice.ValueData
                    , MIFloat_ChangePercent.ValueData
                    , tmpListDocSale.PriceWithVAT
                    , tmpListDocSale.DiscountPercent
                    , tmpListDocSale.ExtraChargesPercent
                    , tmpListDocSale.GoodsPropertyId
                    , tmplistdocsale.ischangeprice
                    , tmpListDocSale.vatpercent
            )

      SELECT COALESCE (Object_GoodsByGoodsKind_View.Id, Object_Goods.Id) AS Id
           , Object_Goods.ObjectCode         AS GoodsCode
           , tmpObject_GoodsPropertyValue_basis.BarCode AS BarCode_Main

           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValueGroup.Name <> '' THEN tmpObject_GoodsPropertyValueGroup.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValueGroup.Name <> '' THEN tmpObject_GoodsPropertyValueGroup.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END) :: TVarChar AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , OS_Measure_InternalCode.ValueData  AS MeasureIntCode
           , CASE Object_Measure.Id
                  WHEN zc_Measure_Sh() THEN 'PCE'
                  ELSE 'KGM'
             END::TVarChar                   AS DELIVEREDUNIT
           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , 0 :: TFloat                     AS AmountOrder
           , tmpMI.Price                     AS Price
           , tmpMI.CountForPrice             AS CountForPrice

           , CASE WHEN COALESCE (tmpObject_GoodsPropertyValue.BoxCount, COALESCE (tmpObject_GoodsPropertyValueGroup.BoxCount, 0)) > 0
                       THEN CAST (tmpMI.AmountPartner / COALESCE (tmpObject_GoodsPropertyValue.BoxCount, COALESCE (tmpObject_GoodsPropertyValueGroup.BoxCount, 0)) AS NUMERIC (16, 4))
                  ELSE 0
             END AS AmountBox
           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')       AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)      AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BoxCount, COALESCE (tmpObject_GoodsPropertyValueGroup.BoxCount, 0))      AS BoxCount_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article,    COALESCE (tmpObject_GoodsPropertyValue.Article, ''))    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCode,    COALESCE (tmpObject_GoodsPropertyValue.BarCode, ''))    AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '')) AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.BarCodeGLN, COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '')) AS BarCodeGLN_Juridical

           , CASE WHEN tmpMI.GoodsPropertyId = 83954 -- Метро
                       THEN COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))
                  ELSE ''
             END AS Article_order

             -- сумма без НДС - по ценам док-та
           , CASE WHEN 1 = (SELECT COUNT(*) FROM (SELECT 1
                                                  FROM tmpMI                
                                                  GROUP BY tmpMI.GoodsId
                                                         , tmpMI.GoodsKindId
                                                         , tmpMI.Price
                                                         , tmpMI.CountForPrice
                                                         , tmpMI.GoodsPropertyId
                                                         , tmpMI.PriceWithVAT 
                                                         , tmpmi.vatpercent
                                                 ) AS tmpMI)
                  THEN (SELECT SUM (MF.ValueData) FROM tmpListDocSale JOIN MovementFloat AS MF ON MF.MovementId = tmpListDocSale.MovementId AND MF.DescId = zc_MovementFloat_TotalSummMVAT())
                  ELSE tmpMI.AmountSumm
             END :: TFloat AS AmountSumm

             -- расчет цены без НДС, до 4 знаков
           , tmpMI.PriceNoVAT

             -- расчет цены с НДС и скидкой, до 4 знаков
           , tmpMI.PriceWVAT
             -- расчет суммы с НДС и скидкой, до 2 знаков
           , CASE WHEN 1 = (SELECT COUNT(*) FROM (SELECT 1
                                                  FROM tmpMI                
                                                  GROUP BY tmpMI.GoodsId
                                                         , tmpMI.GoodsKindId
                                                         , tmpMI.Price
                                                         , tmpMI.CountForPrice
                                                         , tmpMI.GoodsPropertyId
                                                         , tmpMI.PriceWithVAT 
                                                         , tmpmi.vatpercent
                                                 ) AS tmpMI)
                  THEN (SELECT SUM (MF.ValueData) FROM tmpListDocSale JOIN MovementFloat AS MF ON MF.MovementId = tmpListDocSale.MovementId AND MF.DescId = zc_MovementFloat_TotalSummPVAT())
                  ELSE tmpMI.SummWVAT
             END :: TFloat AS SummWVAT
             -- расчет цены с НДС БЕЗ скидки, до 4 знаков
           , tmpMI.PriceWVAT_original

             -- расчет суммы без НДС, до 2 знаков
           , tmpMI.AmountSummNoVAT

             -- расчет суммы с НДС, до 3 знаков
           , tmpMI.AmountSummWVAT

           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END )) AS TFloat) AS Amount_Weight
            
           , '' :: TVarChar AS GoodsCodeUKTZED
       FROM (SELECT tmpMI.GoodsId
                  , tmpMI.GoodsKindId
                  , tmpMI.Price
                  , tmpMI.CountForPrice
                  , SUM (tmpMI.Amount)        AS Amount
                  , SUM (tmpMI.AmountPartner) AS AmountPartner
                  , tmpMI.GoodsPropertyId

          -- сумма по ценам док-та
           , SUM(CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
             END) AS AmountSumm

             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN tmpMI.PriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (tmpMI.VATPercent / (tmpMI.VATPercent + 100)) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                 AS PriceNoVAT

             -- расчет цены с НДС и скидкой, до 4 знаков
           , CASE WHEN tmpMI.PriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (tmpMI.VATPercent / 100))
                                         * CASE WHEN tmpMI.DiscountPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 - tmpMI.DiscountPercent / 100)
                                                WHEN tmpMI.ExtraChargesPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 + tmpMI.ExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * CASE WHEN tmpMI.DiscountPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 - tmpMI.DiscountPercent / 100)
                                                WHEN tmpMI.ExtraChargesPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 + tmpMI.ExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT
             -- расчет суммы с НДС и скидкой, до 4 знаков
           , SUM (CAST (CASE WHEN tmpMI.PriceWithVAT <> TRUE
                             THEN CAST ((tmpMI.Price + tmpMI.Price * (tmpMI.VATPercent / 100))
                                                    * CASE WHEN tmpMI.DiscountPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                                THEN (1 - tmpMI.DiscountPercent / 100)
                                                           WHEN tmpMI.ExtraChargesPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                                THEN (1 + tmpMI.ExtraChargesPercent / 100)
                                                           ELSE 1
                                                      END
                                        AS NUMERIC (16, 4))
                             ELSE CAST (tmpMI.Price * CASE WHEN tmpMI.DiscountPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                                THEN (1 - tmpMI.DiscountPercent / 100)
                                                           WHEN tmpMI.ExtraChargesPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                                THEN (1 + tmpMI.ExtraChargesPercent / 100)
                                                           ELSE 1
                                                      END
                                        AS NUMERIC (16, 4))
                        END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                      * tmpMI.AmountPartner
                  AS NUMERIC (16, 4))) :: TFloat AS SummWVAT
             -- расчет цены с НДС БЕЗ скидки, до 4 знаков
           , CASE WHEN tmpMI.PriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (tmpMI.VATPercent / 100))
                                         * 1
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * 1
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT_original

             -- расчет суммы без НДС, до 2 знаков
           , SUM(CAST (tmpMI.AmountPartner * CASE WHEN tmpMI.PriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (tmpMI.VATPercent / (tmpMI.VATPercent + 100)))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) ) AS AmountSummNoVAT

             -- расчет суммы с НДС, до 3 знаков
           , SUM(CAST (tmpMI.AmountPartner * CASE WHEN tmpMI.PriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (tmpMI.VATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) ) AS AmountSummWVAT

             FROM tmpMI
                
             GROUP BY tmpMI.GoodsId
                    , tmpMI.GoodsKindId
                    , tmpMI.Price
                    , tmpMI.CountForPrice
                    , tmpMI.GoodsPropertyId
                    , tmpMI.PriceWithVAT 
                    , tmpmi.vatpercent
             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN tmpMI.PriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (tmpMI.VATPercent / (tmpMI.VATPercent + 100)) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END

             -- расчет цены с НДС и скидкой, до 4 знаков
           , CASE WHEN tmpMI.PriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (tmpMI.VATPercent / 100))
                                         * CASE WHEN tmpMI.DiscountPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 - tmpMI.DiscountPercent / 100)
                                                WHEN tmpMI.ExtraChargesPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 + tmpMI.ExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * CASE WHEN tmpMI.DiscountPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 - tmpMI.DiscountPercent / 100)
                                                WHEN tmpMI.ExtraChargesPercent <> 0 AND tmpMI.IsChangePrice = FALSE -- !!!учитываем для НАЛ, но НЕ всегда!!!
                                                     THEN (1 + tmpMI.ExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END

             -- расчет цены с НДС БЕЗ скидки, до 4 знаков
           , CASE WHEN tmpMI.PriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (tmpMI.VATPercent / 100))
                                         * 1
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * 1
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END

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

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId
                                                  AND (tmpObject_GoodsPropertyValue.Article <> ''
                                                    OR tmpObject_GoodsPropertyValue.BarCode <> ''
                                                    OR tmpObject_GoodsPropertyValue.ArticleGLN <> ''
                                                    OR tmpObject_GoodsPropertyValue.Name <> '')
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = tmpMI.GoodsId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = tmpMI.GoodsId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                  AND Object_GoodsByGoodsKind_View.GoodsKindId = Object_GoodsKind.Id

       WHERE tmpMI.AmountPartner <> 0 
       ORDER BY CASE WHEN tmpMI.GoodsPropertyId IN (83954 -- Метро
                                                  , 83963 -- Ашан
                                                    )
                     THEN zfConvert_StringToNumber (COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, '0')))
                     ELSE '0'
                END :: Integer
              , Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

    -- печать тары
    OPEN Cursor3 FOR
      WITH tmpMI AS (SELECT MovementItem.ObjectId                         AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , SUM (MovementItem.Amount) AS Amount
                          , SUM (MovementItem.Amount) AS AmountPartner
                     FROM tmpListDocSale
                          LEFT JOIN MovementItem ON MovementItem.MovementId = NULL -- tmpListDocSale.MovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
        
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                          LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
        
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        
                     -- WHERE COALESCE (MIFloat_Price.ValueData, 0) = 0
                     WHERE 1 = 0 -- !!!временно отключил!!!
                     GROUP BY MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                    )
      SELECT Object_Goods.ObjectCode         AS GoodsCode
           , (Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , Object_Goods.ValueData          AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName

           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , CAST ((tmpMI.AmountPartner * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 0 END )) AS TFloat) AS Amount_Weight
      
       FROM tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       -- !!!временно отключил!!!
       -- WHERE tmpMI.AmountPartner <> 0

       -- !!!временно отключил!!!
       -- ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData
      ;

    RETURN NEXT Cursor3;

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
   /*INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_Movement_Sale_TotalPrint'
               -- ProtocolData
             , zfConvert_DateToString (inStartDate)
    || ', ' || zfConvert_DateToString (inEndDate)
    || ', ' || inContractId  :: TVarChar
    || ', ' || inToId        :: TVarChar
    || ', ' || inIsList      :: TVarChar
    || ', ' || inSession
              ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.12.17         *
 05.10.16         * parce
 28.09.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Sale_TotalPrint (inStartDate:= '30.08.2016', inEndDate:= '30.08.2016', inContractId:= 148465, inToId:= 0 , inIsList:= FALSE, inSession:= zfCalc_UserAdmin()); -- FETCH ALL "<unnamed portal 43>";
