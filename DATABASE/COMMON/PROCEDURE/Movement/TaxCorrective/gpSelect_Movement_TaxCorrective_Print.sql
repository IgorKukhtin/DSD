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

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;

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
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
             , ObjectString_BarCode.ValueData       AS BarCode
             , ObjectString_Article.ValueData       AS Article
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
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
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
           , 'J1201205'::TVarChar                                           AS CHARCODE
           , 'Неграш О.В.'::TVarChar                                        AS N10
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
           , CASE WHEN (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                  THEN 'X' ELSE '' END                                      AS ERPN

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

           , OH_JuridicalDetails_From.FullName                              AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress                      AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO                                  AS OKPO_From
           , OH_JuridicalDetails_From.INN                                   AS INN_From
           , OH_JuridicalDetails_From.NumberVAT                             AS NumberVAT_From
           , OH_JuridicalDetails_From.AccounterName                         AS AccounterName_From
           , OH_JuridicalDetails_From.BankAccount                           AS BankAccount_From
           , OH_JuridicalDetails_From.BankName                              AS BankName_From
           , OH_JuridicalDetails_From.MFO                                   AS BankMFO_From
           , OH_JuridicalDetails_From.Phone                                 AS Phone_From

           , MovementItem.Id                                                AS Id
           , Object_Goods.ObjectCode                                        AS GoodsCode
           , (CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END END) :: TVarChar AS GoodsName
           , CASE WHEN tmpObject_GoodsPropertyValue.Name <> '' THEN tmpObject_GoodsPropertyValue.Name WHEN tmpObject_GoodsPropertyValue_basis.Name <> '' THEN tmpObject_GoodsPropertyValue_basis.Name ELSE Object_Goods.ValueData END AS GoodsName_two
           , Object_GoodsKind.ValueData                             AS GoodsKindName
           , Object_Measure.ValueData                               AS MeasureName
           , COALESCE (tmpObject_GoodsPropertyValue.Article, '')    AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode, '')    AS BarCode_Juridical

           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId <> zc_Enum_DocumentTaxKind_CorrectivePrice()
                  THEN MovementItem.Amount
                  ELSE NULL  END                                            AS Amount
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId <> zc_Enum_DocumentTaxKind_CorrectivePrice()
                  THEN MIFloat_Price.ValueData
                  ELSE NULL  END                                            AS Price

           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectivePrice()
                  THEN MovementItem.Amount
                  ELSE NULL  END                                            AS Amount_for_PriceCor
           , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId = zc_Enum_DocumentTaxKind_CorrectivePrice()
                  THEN MIFloat_Price.ValueData
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


       FROM tmpMovement
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
                                                               AND Movement.OperDate BETWEEN OH_JuridicalDetails_To.StartDate AND OH_JuridicalDetails_To.EndDate
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = Object_From.Id
                                                               AND Movement.OperDate BETWEEN OH_JuridicalDetails_From.StartDate AND OH_JuridicalDetails_From.EndDate

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
                                                AND Movement_child.StatusId = zc_Enum_Status_Complete()

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
     WITH
          tmpMovementTaxCount AS
          (SELECT COALESCE (COUNT (MovementLinkMovement_Child.MovementChildId), 0) AS CountTaxId
                , MAX (Movement.DescId) AS DescId
           FROM MovementLinkMovement AS MovementLinkMovement_Master
                INNER JOIN Movement ON Movement.Id = inMovementId
                                   AND Movement.Id = MovementLinkMovement_Master.MovementChildId
                                   AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
                INNER JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                ON MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                                               AND MovementLinkMovement_Child.MovementId = MovementLinkMovement_Master.MovementId
           WHERE MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          )
        , tmpMovementTaxCorrective AS
          (SELECT MovementLinkMovement_Master.MovementId AS Id --CASE WHEN tmpMovementTaxCount<1
                , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummVAT
                , COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TotalSummMVAT
                , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) AS TotalSummPVAT
           FROM MovementLinkMovement AS MovementLinkMovement_Master
                INNER JOIN Movement ON Movement.Id = inMovementId
                                   AND Movement.Id = MovementLinkMovement_Master.MovementChildId
                                   AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
                LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                        ON MovementFloat_TotalSummMVAT.MovementId =  MovementLinkMovement_Master.MovementId
                                       AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
                LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                        ON MovementFloat_TotalSummPVAT.MovementId =  MovementLinkMovement_Master.MovementId
                                       AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
           WHERE MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
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
           FROM MovementItem
                INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                   AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn(), zc_Movement_PriceCorrective())
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
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId     = zc_MI_Master()
             AND MovementItem.isErased   = FALSE
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
            JOIN Movement ON Movement.Id = MovementItem.MovementId
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
       GROUP BY MovementItem.ObjectId
              , MIFloat_Price.ValueData

       )
       -- сам запрос
       SELECT COALESCE (tmp.GoodsId, 1) AS GoodsId
            , CAST (tmpMovementTaxCount.CountTaxId AS Integer) AS CountTaxId
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
            LEFT JOIN tmpMovementTaxCount ON 1 = 1
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
-- SELECT * FROM gpSelect_Movement_TaxCorrective_Print (inMovementId := 185675, inisClientCopy:= FALSE ,inSession:= '2');
