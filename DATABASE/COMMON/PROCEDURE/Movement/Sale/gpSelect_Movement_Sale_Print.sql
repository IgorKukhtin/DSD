-- Function: gpSelect_Movement_Sale_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Print(
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

    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;

     -- параметры из документа
     SELECT COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
          , ObjectLink_JuridicalBasis_GoodsProperty.ChildObjectId AS GoodsPropertyId_basis
            INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis
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
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_To.ObjectId)
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                              AND ObjectLink_Juridical_GoodsProperty.ChildObjectId IS NULL
     WHERE Movement.Id = inMovementId
       AND Movement.StatusId = zc_Enum_Status_Complete()
    ;


    IF vbDiscountPercent <> 0
    THEN
        -- Расчет Сумм
        SELECT CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены без НДС или %НДС=0
                         THEN OperSumm
                    WHEN vbPriceWithVAT AND 1=1
                         -- если цены c НДС
                         THEN CAST ( (OperSumm) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                    WHEN vbPriceWithVAT
                         -- если цены c НДС (Вариант может быть если первичен расчет НДС =1/6 )
                         THEN OperSumm - CAST ( (OperSumm) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
               END AS OperSumm_MVAT
               -- Сумма с НДС
             , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                         -- если цены с НДС
                         THEN (OperSumm)
                    WHEN vbVATPercent > 0
                         -- если цены без НДС
                         THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm) AS NUMERIC (16, 2))
               END AS OperSumm_PVAT
               INTO vbOperSumm_MVAT, vbOperSumm_PVAT
        FROM
       (SELECT SUM (CASE WHEN tmpMI.CountForPrice <> 0
                              THEN CAST (tmpMI.Amount * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                         ELSE CAST (tmpMI.Amount * tmpMI.Price AS NUMERIC (16, 2))
                    END
                   ) AS OperSumm
        FROM (SELECT MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                   , CASE WHEN vbDiscountPercent <> 0
                               THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          WHEN vbExtraChargesPercent <> 0
                               THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                          ELSE COALESCE (MIFloat_Price.ValueData, 0)
                     END AS Price
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                   , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN MovementItem.Amount ELSE 0 END) AS Amount
              FROM MovementItem
                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                   INNER JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                               AND MIFloat_Price.ValueData <> 0
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.isErased = FALSE
              GROUP BY MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
             ) AS tmpMI
        ) AS tmpMI;
    END IF;


     --
    OPEN Cursor1 FOR
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
           , Movement.OperDate                          AS OperDate
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)     AS OperDatePartner
           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent
           , vbExtraChargesPercent - vbDiscountPercent  AS ChangePercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh
           , CASE WHEN vbDiscountPercent <> 0 THEN vbOperSumm_MVAT ELSE MovementFloat_TotalSummMVAT.ValueData END AS TotalSummMVAT
           , CASE WHEN vbDiscountPercent <> 0 THEN vbOperSumm_PVAT ELSE MovementFloat_TotalSummPVAT.ValueData END AS TotalSummPVAT
           , CASE WHEN vbDiscountPercent <> 0 THEN vbOperSumm_PVAT - vbOperSumm_MVAT ELSE MovementFloat_TotalSummPVAT.ValueData - MovementFloat_TotalSummMVAT.ValueData END AS SummVAT
           , CASE WHEN vbDiscountPercent <> 0 THEN vbOperSumm_PVAT ELSE MovementFloat_TotalSumm.ValueData END AS TotalSumm
           , Object_From.ValueData             		AS FromName
           , COALESCE (Object_Partner.ValueData, Object_To.ValueData) AS ToName
           , Object_PaidKind.ValueData         		AS PaidKindName
           , View_Contract.InvNumber        		AS ContractName
           , View_Contract.StartDate                    AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind

           , Object_RouteSorting.ValueData 		AS RouteSortingName

           , CASE WHEN View_Contract.InfoMoneyId = zc_Enum_InfoMoney_30101() THEN 'Бабенко В.П.' ELSE '' END AS StoreKeeper -- кладовщик
           , '' :: TVarChar                             AS Through     -- через кого

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

           , Object_BankAccount.ValueData               AS BankAccount_ByContract
           , Object_Bank.ValueData                      AS BankName_ByContract
           , ObjectString_Bank_MFO.ValueData            AS BankMFO_ByContract

       FROM Movement
            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
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
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
-- Contract
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId IN ( zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId

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
                                                               AND Movement.OperDate BETWEEN OH_JuridicalDetails_To.StartDate AND OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectString AS ObjectString_BuyerGLNCode
                                   ON ObjectString_BuyerGLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_BuyerGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = COALESCE (View_Contract.JuridicalBasisId, Object_From.Id)
                                                               AND Movement.OperDate BETWEEN OH_JuridicalDetails_From.StartDate AND OH_JuridicalDetails_From.EndDate

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
                            LEFT JOIN ObjectLink AS ObjectLink_BankAccountContract_BankAccount
                                                 ON ObjectLink_BankAccountContract_BankAccount.DescId = zc_ObjectLink_BankAccountContract_BankAccount()
                                                AND ObjectLink_BankAccountContract_BankAccount.ObjectId = ObjectLink_BankAccountContract_InfoMoney.ObjectId
                       WHERE ObjectLink_BankAccountContract_InfoMoney.DescId = zc_ObjectLink_BankAccountContract_InfoMoney()
                         AND ObjectLink_BankAccountContract_InfoMoney.ChildObjectId IS NULL
                      ) AS ObjectLink_BankAccountContract_BankAccount_all ON ObjectLink_BankAccountContract_BankAccount.ChildObjectId IS NULL -- !!!не ошибка!!!, выбирается с пустой УП
                                                                         AND ObjectLink_Contract_BankAccount.ChildObjectId IS NULL

            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = COALESCE (ObjectLink_Contract_BankAccount.ChildObjectId, COALESCE (ObjectLink_BankAccountContract_BankAccount.ChildObjectId, ObjectLink_BankAccountContract_BankAccount_all.ChildObjectId))

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Bank_MFO
                                   ON ObjectString_Bank_MFO.ObjectId = Object_Bank.Id
                                  AND ObjectString_Bank_MFO.DescId = zc_ObjectString_Bank_MFO()
--
       WHERE Movement.Id =  inMovementId
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectFloat_Amount.ValueData         AS Amount
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0 UNION SELECT vbGoodsPropertyId_basis AS GoodsPropertyId WHERE vbGoodsPropertyId_basis <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                   ON ObjectFloat_Amount.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                  AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
                                  AND vbGoodsPropertyId <> 0

             LEFT JOIN ObjectString AS ObjectString_BarCode
                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                   AND vbGoodsPropertyId <> 0
             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                   AND vbGoodsPropertyId <> 0

             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
                                   AND vbGoodsPropertyId <> 0
             LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                    ON ObjectString_ArticleGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                   AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                                   AND vbGoodsPropertyId <> 0

             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )
       SELECT
             Object_GoodsByGoodsKind_View.Id AS Id
           , Object_Goods.ObjectCode         AS GoodsCode
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name ELSE Object_Goods.ValueData END || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , Object_GoodsKind.ValueData      AS GoodsKindName
           , Object_Measure.ValueData        AS MeasureName
           , CASE Object_Measure.Id
                  WHEN zc_Measure_Sh() THEN 'PCE'
                  ELSE 'KGM'
             END::TVarChar AS DELIVEREDUNIT
           , tmpMI.Amount                    AS Amount
           , tmpMI.AmountPartner             AS AmountPartner
           , tmpMI.Price                     AS Price
           , tmpMI.CountForPrice             AS CountForPrice

           , COALESCE (tmpObject_GoodsPropertyValue.Name, '')       AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount, 0)      AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Article, '')    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')    AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '') AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '') AS BarCodeGLN_Juridical

           , CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.AmountPartner * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.AmountPartner * tmpMI.Price AS NUMERIC (16, 2))
             END AS AmountSumm

           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST (tmpMI.Price + tmpMI.Price * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE tmpMI.Price
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT

           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100))
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT
           , CAST (tmpMI.AmountPartner * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                              ELSE tmpMI.Price
                                         END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

       FROM (SELECT MovementItem.ObjectId AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  , CASE WHEN vbDiscountPercent <> 0
                              THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         WHEN vbExtraChargesPercent <> 0
                              THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price
                  , MIFloat_CountForPrice.ValueData AS CountForPrice
                  , SUM (MovementItem.Amount) AS Amount
                  , SUM (CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                   THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                   ELSE MovementItem.Amount
                         END) AS AmountPartner
             FROM MovementItem
                  INNER JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                              AND MIFloat_Price.ValueData <> 0
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
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , MILinkObject_GoodsKind.ObjectId
                    , MIFloat_Price.ValueData
                    , MIFloat_CountForPrice.ValueData
            ) AS tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId

            LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = tmpMI.GoodsId
                                                  AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpMI.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpMI.GoodsKindId

       WHERE tmpMI.AmountPartner <> 0
       ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.06.14                                        * add tmpObject_GoodsPropertyValue.Name
 20.05.14                                        * add Object_Contract_View
 17.05.14                                        * add StatusId = zc_Enum_Status_Complete
 13.05.14                                        * add calc GoodsName
 13.05.14                                                       * zc_ObjectLink_Contract_BankAccount
 08.05.14                        * add GLN code
 08.05.14                                        * all
 06.05.14                                        * add Object_Partner
 06.05.14                                                       * zc_Movement_SendOnPrice
 06.05.14                                        * OperDatePartner
 05.05.14                                                       *
 28.04.14                                                       *
 09.04.14                                        * add JOIN MIFloat_AmountPartner
 02.04.14                                                       *  PriceWVAT PriceNoVAT round to 2 sign
 01.04.14                                                       *  tmpMI.Price <> 0
 27.03.14                                                       *
 24.02.14                                                       *  add PriceNoVAT, PriceWVAT, AmountSummNoVAT, AmountSummWVAT
 19.02.14                                                       *  add by juridical
 07.02.14                                                       *  change to Cursor
 05.02.14                                                       *
*/

/*
BEGIN;
 SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId := 135428, inSession:= '2');
COMMIT;
*/
-- тест
-- SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId := 135428, inSession:= '2');
