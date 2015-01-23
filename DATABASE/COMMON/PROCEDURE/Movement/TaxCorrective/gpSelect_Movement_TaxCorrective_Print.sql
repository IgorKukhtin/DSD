-- Function: gpSelect_Movement_TaxCorrective_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_TaxCorrective_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxCorrective_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inisClientCopy      Boolean  , -- копия для клиента
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbMovementId_TaxCorrective Integer;
    DECLARE vbStatusId_TaxCorrective Integer;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbNotNDSPayer_INN TVarChar;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;
     vbNotNDSPayer_INN := '100000000000';

     -- определяется <Налоговый документ> и его параметры
     SELECT COALESCE (tmpMovement.MovementId_TaxCorrective, 0) AS MovementId_TaxCorrective
          , Movement_TaxCorrective.StatusId                    AS StatusId_TaxCorrective
            INTO vbMovementId_TaxCorrective, vbStatusId_TaxCorrective
     FROM (SELECT CASE WHEN Movement.DescId = zc_Movement_TaxCorrective()
                            THEN inMovementId
                       ELSE MovementLinkMovement_Master.MovementChildId
                  END AS MovementId_TaxCorrective
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
           WHERE Movement.Id = inMovementId
          ) AS tmpMovement
          INNER JOIN Movement AS Movement_TaxCorrective ON Movement_TaxCorrective.Id = tmpMovement.MovementId_TaxCorrective
                                                       AND (Movement_TaxCorrective.StatusId = zc_Enum_Status_Complete() OR tmpMovement.MovementId_TaxCorrective = inMovementId)
     ;
/* пока убрал, т.к. проверка сумм происходит в непроведенном состоянии, надо или добавить параметр - "когда ругаться" или сделать еще одну печать-проверку
     -- очень важная проверка
     IF COALESCE (vbMovementId_TaxCorrective, 0) = 0 OR COALESCE (vbStatusId_TaxCorrective, 0) <> zc_Enum_Status_Complete()
     THEN
         IF COALESCE (vbMovementId_TaxCorrective, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> не создан.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective());
         END IF;
         IF vbStatusId_TaxCorrective = zc_Enum_Status_Erased()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective);
         END IF;
         IF vbStatusId_TaxCorrective = zc_Enum_Status_UnComplete()
         THEN
             RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective()), (SELECT ValueData FROM MovementString WHERE MovementId = vbMovementId_TaxCorrective AND DescId = zc_MovementString_InvNumberPartner()), (SELECT DATE (OperDate) FROM Movement WHERE Id = vbMovementId_TaxCorrective);
         END IF;
         -- это уже странная ошибка
         RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective());
     END IF;
*/

     -- определяется параметр
     vbGoodsPropertyId:= (SELECT ObjectLink_Juridical_GoodsProperty.ChildObjectId
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                               LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                                    ON ObjectLink_Juridical_GoodsProperty.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId)
                                                   AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                          WHERE Movement.Id = inMovementId
                         );
     -- определяется параметр
     vbGoodsPropertyId_basis:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = zc_Juridical_Basis() AND DescId = zc_ObjectLink_Juridical_GoodsProperty());


     -- Данные по Всем корректировкам + налоговым: заголовок + строчная часть
     OPEN Cursor1 FOR
     WITH tmpMovement AS
          (SELECT Movement_find.Id
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                -- печатаем всегда все корректировки
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                               ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                              AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_find ON Movement_find.Id  = COALESCE (MovementLinkMovement_Master_find.MovementId, Movement.Id)
                                                    AND Movement_find.StatusId = zc_Enum_Status_Complete()
           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_TaxCorrective()
          UNION
           SELECT MovementLinkMovement_Master.MovementId AS Id
           FROM Movement
                INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                               AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_Master ON Movement_Master.Id  = MovementLinkMovement_Master.MovementId
                                                      AND Movement_Master.StatusId = zc_Enum_Status_Complete()
           WHERE Movement.Id = inMovementId
             AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
          )
     , tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
             , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId

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
        WHERE Object_GoodsPropertyValue.ValueData  <> ''
           OR ObjectString_BarCode.ValueData       <> ''
           OR ObjectString_Article.ValueData       <> ''
           OR ObjectString_BarCodeGLN.ValueData    <> ''
           OR ObjectString_ArticleGLN.ValueData    <> ''
       )
     , tmpObject_GoodsPropertyValueGroup AS
       (SELECT tmpObject_GoodsPropertyValue.GoodsId
             , tmpObject_GoodsPropertyValue.Article
             , tmpObject_GoodsPropertyValue.ArticleGLN
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

      SELECT Movement.Id				                                    AS MovementId
           , Movement.InvNumber				                                AS InvNumber
           , Movement.OperDate				                                AS OperDate
           , 'J1201006'::TVarChar                                           AS CHARCODE
           -- , 'Неграш О.В.'::TVarChar                                        AS N10
           , 'Рудик Н.В.'::TVarChar                                        AS N10
           -- , 'А.В. МАРУХНО'::TVarChar                                        AS N10
           , 'оплата з поточного рахунка'::TVarChar                         AS N9
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectivePrice() THEN 'Змiна цiни'  ELSE 'повернення' END :: TVarChar AS KindName
           , MovementBoolean_PriceWithVAT.ValueData                         AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData                             AS VATPercent
           , CAST (REPEAT (' ', 8 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumberPartner

           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData                          AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData                          AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData                              AS TotalSumm

           , View_Contract.InvNumber         		                        AS ContractName
           , ObjectDate_Signing.ValueData                                   AS ContractSigningDate
           , View_Contract.ContractKindName                                 AS ContractKind

           , CAST (REPEAT (' ', 7 - LENGTH (MS_DocumentChild_InvNumberPartner.ValueData)) || MS_DocumentChild_InvNumberPartner.ValueData AS TVarChar) AS InvNumber_Child
           , Movement_child.OperDate                                        AS OperDate_Child

           , CASE WHEN inisClientCopy=TRUE
                  THEN 'X' ELSE '' END                                      AS CopyForClient
           , CASE WHEN inisClientCopy=TRUE
                  THEN '' ELSE 'X' END                                      AS CopyForUs

           , CASE WHEN Movement.OperDate < '01.01.2015' AND (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                  THEN 'X'
                  WHEN Movement.OperDate >= '01.01.2015' AND Movement_child.OperDate >= '01.01.2015' AND OH_JuridicalDetails_From.INN <> vbNotNDSPayer_INN
                  THEN 'X'
                  ELSE ''
             END AS ERPN
           , Movement_child.Id as x11
           , Movement_child.OperDate as x12

           , CASE WHEN Movement.OperDate < '01.01.2015' AND (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                  THEN TRUE
                  WHEN Movement.OperDate >= '01.01.2015' AND Movement_child.OperDate >= '01.01.2015' AND OH_JuridicalDetails_From.INN <> vbNotNDSPayer_INN
                  THEN TRUE
                  ELSE FALSE
             END :: Boolean AS isERPN

           , CASE WHEN OH_JuridicalDetails_From.INN <> vbNotNDSPayer_INN AND Movement_child.OperDate >= '01.01.2015'
                  THEN 'X' ELSE '' END                                      AS ERPN2

           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN 'X' ELSE '' END                                      AS NotNDSPayer
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN TRUE ELSE FALSE END :: Boolean                       AS isNotNDSPayer
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN '0' ELSE '' END                                      AS NotNDSPayerC1
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN '2' ELSE '' END                                      AS NotNDSPayerC2

           , ObjectString_FromAddress.ValueData                             AS PartnerAddress_From

           , OH_JuridicalDetails_To.FullName                                AS JuridicalName_To
           , OH_JuridicalDetails_To.JuridicalAddress                        AS JuridicalAddress_To

           , OH_JuridicalDetails_To.OKPO                                    AS OKPO_To
           , OH_JuridicalDetails_To.INN                                     AS INN_To
           , OH_JuridicalDetails_To.NumberVAT                               AS NumberVAT_To
           , OH_JuridicalDetails_To.AccounterName                           AS AccounterName_To
           , OH_JuridicalDetails_To.BankAccount                             AS BankAccount_To
           , OH_JuridicalDetails_To.BankName                                AS BankName_To
           , OH_JuridicalDetails_To.MFO                                     AS BankMFO_To
           , OH_JuridicalDetails_To.Phone                                   AS Phone_To
           , ObjectString_BuyerGLNCode.ValueData                            AS BuyerGLNCode

           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN 'НЕПЛАТНИК'
             ELSE OH_JuridicalDetails_From.FullName END                     AS JuridicalName_From
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN 'НЕПЛАТНИК'
             ELSE OH_JuridicalDetails_From.JuridicalAddress END             AS JuridicalAddress_From

           , OH_JuridicalDetails_From.OKPO                                  AS OKPO_From
           , OH_JuridicalDetails_From.INN                                   AS INN_From
           , OH_JuridicalDetails_From.NumberVAT                             AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName                         AS AccounterName_From
           , OH_JuridicalDetails_From.BankAccount                           AS BankAccount_From
           , OH_JuridicalDetails_From.BankName                              AS BankName_From
           , OH_JuridicalDetails_From.MFO                                   AS BankMFO_From
           , CASE WHEN OH_JuridicalDetails_From.INN = vbNotNDSPayer_INN
                  THEN ''
             ELSE OH_JuridicalDetails_From.Phone END                        AS Phone_From
           , ObjectString_SupplierGLNCode.ValueData                         AS SupplierGLNCode

           , MovementItem.Id                                                AS Id
           , Object_Goods.ObjectCode                                        AS GoodsCode
           , (CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Prepay() THEN 'ПРЕДОПЛАТА ЗА КОЛБ.ИЗДЕЛИЯ' WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END END) :: TVarChar AS GoodsName
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_Prepay() THEN 'ПРЕДОПЛАТА ЗА КОЛБ.ИЗДЕЛИЯ' WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , Object_GoodsKind.ValueData                             AS GoodsKindName
           , Object_Measure.ValueData                               AS MeasureName
           , CASE WHEN Object_Measure.ObjectCode=1 THEN '0301'
                  WHEN Object_Measure.ObjectCode=2 THEN '2009'
             ELSE ''     END                                        AS MeasureCode
           , COALESCE (tmpObject_GoodsPropertyValueGroup.Article, COALESCE (tmpObject_GoodsPropertyValue.Article, ''))    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')    AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValueGroup.ArticleGLN, COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN, '')) AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN, '') AS BarCodeGLN_Juridical

           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId <> zc_Enum_DocumentTaxKind_CorrectivePrice()
                  THEN MovementItem.Amount
                  ELSE NULL  END                                            AS Amount
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId <> zc_Enum_DocumentTaxKind_CorrectivePrice()
                  THEN MIFloat_Price.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                  ELSE NULL  END                                            AS Price

           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectivePrice()
                  THEN MovementItem.Amount
                  ELSE NULL  END                                            AS Amount_for_PriceCor
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectivePrice()
                  THEN MIFloat_Price.ValueData / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                  ELSE NULL  END                                            AS Price_for_PriceCor

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)                                           AS AmountSumm

           , CAST (REPEAT (' ', 4 - LENGTH (MovementString_InvNumberBranch.ValueData)) || MovementString_InvNumberBranch.ValueData AS TVarChar) AS InvNumberBranch
           , CAST (REPEAT (' ', 4 - LENGTH (MovementString_InvNumberBranch_Child.ValueData)) || MovementString_InvNumberBranch_Child.ValueData AS TVarChar) AS InvNumberBranch_Child

           , MovementString_InvNumberMark.ValueData     AS InvNumberMark
           , COALESCE (MovementDate_OperDatePartner.ValueData, Movement_ReturnIn.OperDate) AS OperDatePartner_ReturnIn
           , COALESCE (MovementString_InvNumberPartner_ReturnIn.ValueData, Movement_ReturnIn.InvNumber) AS InvNumberPartner_ReturnIn
--           , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent

           , MovementString_InvNumberPartnerEDI.ValueData  AS InvNumberPartnerEDI
           , MovementDate_OperDatePartnerEDI.ValueData     AS OperDatePartnerEDI
           , COALESCE(MovementLinkMovement_ChildEDI.MovementChildId, 0) AS EDIId
           , COALESCE(MovementFloat_Amount.ValueData, 0) AS SendDeclarAmount


       FROM tmpMovement

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_ChildEDI
                                           ON MovementLinkMovement_ChildEDI.MovementId = tmpMovement.Id
                                          AND MovementLinkMovement_ChildEDI.DescId = zc_MovementLinkMovement_ChildEDI()

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId =  MovementLinkMovement_ChildEDI.MovementChildId
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartnerEDI
                                   ON MovementDate_OperDatePartnerEDI.MovementId =  MovementLinkMovement_ChildEDI.MovementChildId
                                  AND MovementDate_OperDatePartnerEDI.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartnerEDI
                                     ON MovementString_InvNumberPartnerEDI.MovementId =  MovementLinkMovement_ChildEDI.MovementChildId
                                    AND MovementString_InvNumberPartnerEDI.DescId = zc_MovementString_InvNumberPartner()

            INNER JOIN MovementItem ON MovementItem.MovementId =  tmpMovement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   AND MovementItem.Amount <> 0
            INNER JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        AND MIFloat_Price.ValueData <> 0

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            LEFT JOIN tmpObject_GoodsPropertyValueGroup ON tmpObject_GoodsPropertyValueGroup.GoodsId = MovementItem.ObjectId
                                                       AND tmpObject_GoodsPropertyValue.GoodsId IS NULL
            LEFT JOIN tmpObject_GoodsPropertyValue_basis ON tmpObject_GoodsPropertyValue_basis.GoodsId = MovementItem.ObjectId
                                                        AND tmpObject_GoodsPropertyValue_basis.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                  -- AND tmpObject_GoodsPropertyValue.Name <> ''

-- MOVEMENT
            LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_From.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = Object_To.Id
                                                               AND Movement.OperDate >= OH_JuridicalDetails_To.StartDate AND Movement.OperDate < OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = Object_From.Id
                                                               AND Movement.OperDate >= OH_JuridicalDetails_From.StartDate AND Movement.OperDate < OH_JuridicalDetails_From.EndDate

            LEFT JOIN ObjectString AS ObjectString_BuyerGLNCode
                                   ON ObjectString_BuyerGLNCode.ObjectId = OH_JuridicalDetails_To.JuridicalId
                                  AND ObjectString_BuyerGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

            LEFT JOIN ObjectString AS ObjectString_SupplierGLNCode
                                   ON ObjectString_SupplierGLNCode.ObjectId = OH_JuridicalDetails_From.JuridicalId
                                  AND ObjectString_SupplierGLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND View_Contract.InvNumber <> '-'

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_child
                                           ON MovementLinkMovement_child.MovementId = Movement.Id
                                          AND MovementLinkMovement_child.DescId = zc_MovementLinkMovement_Child()
            LEFT JOIN Movement AS Movement_child ON Movement_child.Id = MovementLinkMovement_child.MovementChildId
                                                AND Movement_child.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())

--   09.07.14
            LEFT JOIN Movement AS Movement_ReturnIn ON Movement_ReturnIn.Id = inMovementId

            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement_ReturnIn.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement_ReturnIn.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner_ReturnIn
                                     ON MovementString_InvNumberPartner_ReturnIn.MovementId =  Movement_ReturnIn.Id
                                    AND MovementString_InvNumberPartner_ReturnIn.DescId = zc_MovementString_InvNumberPartner()

--   09.07.14

            LEFT JOIN MovementString AS MovementString_InvNumberBranch_Child
                                     ON MovementString_InvNumberBranch_Child.MovementId =  Movement_child.Id
                                    AND MovementString_InvNumberBranch_Child.DescId = zc_MovementString_InvNumberBranch()
            LEFT JOIN MovementString AS MS_DocumentChild_InvNumberPartner ON MS_DocumentChild_InvNumberPartner.MovementId = Movement_child.Id
                                                                         AND MS_DocumentChild_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN ObjectString AS ObjectString_FromAddress
                                   ON ObjectString_FromAddress.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectString_FromAddress.DescId = zc_ObjectString_Partner_Address()

       ORDER BY MovementString_InvNumberPartner.ValueData
      ;
     RETURN NEXT Cursor1;


     -- Данные по разнице Возвратов и Всех корректировок
     OPEN Cursor2 FOR
     WITH tmpMovement AS
          (SELECT Movement_find.Id
                , MovementLinkMovement_Master.MovementChildId AS MovementId_Return
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                -- печатаем всегда все корректировки
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                               ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                              AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_find ON Movement_find.Id  = COALESCE (MovementLinkMovement_Master_find.MovementId, Movement.Id)
                                                    AND Movement_find.StatusId IN (zc_Enum_Status_Complete())
           WHERE Movement.Id = inMovementId
             AND Movement.DescId = zc_Movement_TaxCorrective()
          UNION
           SELECT MovementLinkMovement_Master.MovementId AS Id
                , Movement.Id AS MovementId_Return
           FROM Movement
                INNER JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                                ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                               AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
                INNER JOIN Movement AS Movement_Master ON Movement_Master.Id  = MovementLinkMovement_Master.MovementId
                                                      AND Movement_Master.StatusId = zc_Enum_Status_Complete()
           WHERE Movement.Id = inMovementId
             AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
          )
        , tmpMovementTaxCorrectiveCount AS
          (SELECT COALESCE (COUNT (*), 0) AS CountTaxId FROM tmpMovement)
        , tmpMovementTaxCorrective AS
          (SELECT tmpMovement.Id
                , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummVAT
                , COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummMVAT
                , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) AS TotalSummPVAT
           FROM tmpMovement
                LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                        ON MovementFloat_TotalSummMVAT.MovementId =  tmpMovement.Id
                                       AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                        ON MovementFloat_TotalSummPVAT.MovementId =  tmpMovement.Id
                                       AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
          )
        , tmpReturnIn AS
          (SELECT MovementItem.ObjectId     			        AS GoodsId
                , CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                            THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                       ELSE COALESCE (MIFloat_Price.ValueData, 0)
                  END AS Price
                , SUM (CASE WHEN Movement.DescId = zc_Movement_ReturnIn()
                                 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                 ELSE MovementItem.Amount
                       END) AS Amount
           FROM (SELECT MovementId_Return AS MovementId FROM tmpMovement GROUP BY MovementId_Return) AS tmpMovement
                INNER JOIN Movement ON Movement.Id = tmpMovement.MovementId
                                   AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
                                   AND Movement.StatusId <> zc_Enum_Status_Erased() -- не проведенные должны учавствовать
                INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = FALSE
                INNER JOIN MovementItemFloat AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                            AND MIFloat_Price.ValueData <> 0
                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                        ON MovementFloat_ChangePercent.MovementId = MovementItem.MovementId
                                       AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
           GROUP BY MovementItem.ObjectId
                  , MIFloat_Price.ValueData
                  , MovementFloat_ChangePercent.ValueData
          )

       , tmpTaxCorrective AS --строчные корректировок
       (SELECT
             MovementItem.ObjectId                                          AS GoodsId
           , MIFloat_Price.ValueData                                        AS Price
           , SUM (MovementItem.Amount)                                      AS Amount
       FROM tmpMovementTaxCorrective
            INNER JOIN MovementItem ON MovementItem.MovementId =  tmpMovementTaxCorrective.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   AND MovementItem.Amount <> 0
            JOIN MovementItemFloat AS MIFloat_Price
                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                  AND MIFloat_Price.ValueData <> 0
       GROUP BY MovementItem.ObjectId
              , MIFloat_Price.ValueData

       )
       -- сам запрос
       SELECT COALESCE (tmp.GoodsId, 1) AS GoodsId
            , CAST (tmpMovementTaxCorrectiveCount.CountTaxId AS Integer) AS CountTaxId
            , Object_Goods.ObjectCode         AS GoodsCode
            , Object_Goods.ValueData          AS GoodsName
            , tmp.Price
            , tmp.ReturnInAmount
            , tmp.TaxCorrectiveAmount
            , tmpMovementTaxCorrective.TotalSummVAT  AS TotalSummVAT_calc
            , tmpMovementTaxCorrective.TotalSummMVAT AS TotalSummMVAT_calc
            , tmpMovementTaxCorrective.TotalSummPVAT AS TotalSummPVAT_calc
            , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummVAT
            , COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummMVAT
            , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) AS TotalSummPVAT

       FROM (SELECT SUM (tmpMovementTaxCorrective.TotalSummVAT)  AS TotalSummVAT
                  , SUM (tmpMovementTaxCorrective.TotalSummMVAT) AS TotalSummMVAT
                  , SUM (tmpMovementTaxCorrective.TotalSummPVAT) AS TotalSummPVAT
             FROM tmpMovementTaxCorrective
            ) AS tmpMovementTaxCorrective
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId = inMovementId
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId = inMovementId
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN (SELECT GoodsId
                            , Price
                            , SUM (ReturnInAmount)            AS ReturnInAmount
                            , SUM (TaxCorrectiveAmount)       AS TaxCorrectiveAmount
                       FROM (SELECT tmpReturnIn.GoodsId
                                  , tmpReturnIn.Price
                                  , tmpReturnIn.Amount AS ReturnInAmount
                                  , 0                  AS TaxCorrectiveAmount
                             FROM tmpReturnIn
                             WHERE tmpReturnIn.Amount <> 0
                            UNION ALL
                             SELECT tmpTaxCorrective.GoodsId
                                  , tmpTaxCorrective.Price
                                  , 0                       AS ReturnInAmount
                                  , tmpTaxCorrective.Amount AS TaxCorrectiveAmount
                             FROM tmpTaxCorrective
                            ) AS tmp
                       GROUP BY tmp.GoodsId
                              , tmp.Price
                       HAVING SUM (tmp.ReturnInAmount) <>  SUM (tmp.TaxCorrectiveAmount)
                      ) AS tmp ON 1 = 1
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
            LEFT JOIN tmpMovementTaxCorrectiveCount ON 1 = 1
       -- !!! print all !!!
       -- WHERE tmpMovementTaxCount.DescId NOT IN (zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective()) OR tmp.GoodsId IS NOT NULL
     ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TaxCorrective_Print (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.01.15                                                       *
 16.07.14                                        * add tmpObject_GoodsPropertyValueGroup
 09.07.14                                                       *
 27.06.14                                        * !!! print all !!!
 05.06.14                                        * restore ContractSigningDate
 04.06.14                                        * add tmpObject_GoodsPropertyValue.Name
 03.06.14                                        * add zc_Movement_PriceCorrective
 21.05.14                                        * add zc_Movement_TransferDebtIn
 20.05.14                                        * ContractSigningDate -> Object_Contract_View.StartDate
 17.05.14                                        * add StatusId = zc_Enum_Status_Complete
 13.05.14                                        * add calc GoodsName
 03.05.14                                        * add zc_Enum_DocumentTaxKind_CorrectivePrice()
 30.04.14                                                       *
 24.04.14                                                       * add zc_MovementString_InvNumberBranch
 23.04.14                                        * add печатаем всегда все корректировки
 14.04.14                                                       *
 10.04.14                                                       *
 09.04.14                                                       *
 08.04.14                                                       *
 07.04.14                                                       *
*/

/*
BEGIN;
 SELECT * FROM gpSelect_Movement_TaxCorrective_Print (inMovementId := 141816, inisClientCopy:= FALSE ,inSession:= '2');
COMMIT;
*/
-- тест
-- SELECT * FROM gpSelect_Movement_TaxCorrective_Print (inMovementId := 185675, inisClientCopy:= FALSE ,inSession:= '2');
-- SELECT * FROM gpSelect_Movement_TaxCorrective_Print (inMovementId := 520880 , inisClientCopy:= FALSE ,inSession:= '2');
