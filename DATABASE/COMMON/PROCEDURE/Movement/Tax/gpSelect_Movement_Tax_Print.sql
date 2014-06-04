-- Function: gpSelect_Movement_Tax_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Tax_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inisClientCopy      Boolean  , -- копия для клиента
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

    DECLARE vbMovementId_Sale Integer;
    DECLARE vbMovementId_Tax Integer;

    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;

     -- определяется <Налоговый документ> и его параметры 
     SELECT COALESCE (tmpMovement.MovementId_Tax, 0) AS MovementId_Tax
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , ObjectLink_Juridical_GoodsProperty.ChildObjectId AS GoodsPropertyId
          , ObjectLink_JuridicalBasis_GoodsProperty.ChildObjectId AS GoodsPropertyId_basis
            INTO vbMovementId_Tax, vbPriceWithVAT, vbVATPercent, vbGoodsPropertyId, vbGoodsPropertyId_basis
     FROM (SELECT CASE WHEN Movement.DescId = zc_Movement_Tax()
                            THEN inMovementId
                       ELSE MovementLinkMovement_Master.MovementChildId
                  END AS MovementId_Tax
           FROM Movement
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                               ON MovementLinkMovement_Master.MovementId = Movement.Id
                                              AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
           WHERE Movement.Id = inMovementId
          ) AS tmpMovement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = tmpMovement.MovementId_Tax
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                  ON MovementFloat_VATPercent.MovementId = tmpMovement.MovementId_Tax
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = tmpMovement.MovementId_Tax
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                               ON ObjectLink_Juridical_GoodsProperty.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
          LEFT JOIN ObjectLink AS ObjectLink_JuridicalBasis_GoodsProperty
                               ON ObjectLink_JuridicalBasis_GoodsProperty.ObjectId = zc_Juridical_Basis()
                              AND ObjectLink_JuridicalBasis_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
                              AND ObjectLink_Juridical_GoodsProperty.ChildObjectId IS NULL
     ;

     -- определяется <Продажа покупателю> или <Перевод долга (расход)>
     SELECT COALESCE(CASE WHEN Movement.DescId IN (zc_Movement_Sale(), zc_Movement_TransferDebtOut())
                               THEN inMovementId
                          ELSE MovementLinkMovement_Master.MovementId
                     END, 0)
            INTO vbMovementId_Sale
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementChildId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
     WHERE Movement.Id = inMovementId;


     -- Данные по заголовку налоговой
     OPEN Cursor1 FOR
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , 'J1201005'::TVarChar                       AS CHARCODE  
           , 'Неграш О.В.'::TVarChar                    AS N10 
           , 'оплата з поточного рахунка'::TVarChar     AS N9
           , CAST (REPEAT (' ', 7 - LENGTH (MovementString_InvNumberPartner.ValueData)) || MovementString_InvNumberPartner.ValueData AS TVarChar) AS InvNumberPartner
           , vbPriceWithVAT                             AS PriceWithVAT
           , vbVATPercent                               AS VATPercent

           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS SummVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm

           , Object_From.ValueData             		AS FromName
           , Object_To.ValueData               		AS ToName

           , View_Contract.InvNumber         		AS ContractName
           , View_Contract.StartDate                    AS ContractSigningDate
           , View_Contract.ContractKindName             AS ContractKind

           , ObjectString_ToAddress.ValueData           AS PartnerAddress_To

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

           , CASE WHEN inisClientCopy=TRUE
                  THEN 'X' ELSE '' END                  AS CopyForClient
           , CASE WHEN inisClientCopy=TRUE
                  THEN '' ELSE 'X' END                  AS CopyForUs
           , CASE WHEN (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0)) > 10000
                  THEN 'X' ELSE '' END                  AS ERPN
           , CAST (REPEAT (' ', 4 - LENGTH (MovementString_InvNumberBranch.ValueData)) || MovementString_InvNumberBranch.ValueData AS TVarChar) AS InvNumberBranch

       FROM Movement
            LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                     ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                    AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

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
            LEFT JOIN ObjectString AS ObjectString_ToAddress
                                   ON ObjectString_ToAddress.ObjectId = MovementLinkObject_Partner.ObjectId
                                  AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

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

       WHERE Movement.Id =  vbMovementId_Tax
         AND Movement.StatusId = zc_Enum_Status_Complete()
      ;
     RETURN NEXT Cursor1;

     -- Данные по строчной части налоговой
     OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
       (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId      AS GoodsId
             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
             , Object_GoodsPropertyValue.ValueData  AS Name
        FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0 UNION SELECT vbGoodsPropertyId_basis AS GoodsPropertyId WHERE vbGoodsPropertyId_basis <> 0
             ) AS tmpGoodsProperty
             INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                   ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
             LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
       )

       SELECT
             Object_Goods.ObjectCode                AS GoodsCode
           , (COALESCE (tmpObject_GoodsPropertyValue.Name, Object_Goods.ValueData) || CASE WHEN COALESCE (Object_GoodsKind.Id, zc_Enum_GoodsKind_Main()) = zc_Enum_GoodsKind_Main() THEN '' ELSE ' ' || Object_GoodsKind.ValueData END) :: TVarChar AS GoodsName
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , Object_Measure.ValueData               AS MeasureName

           , MovementItem.Amount                    AS Amount
           , MovementItem.Amount                    AS AmountPartner
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST (MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST (MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (MIFloat_Price.ValueData - MIFloat_Price.ValueData * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE MIFloat_Price.ValueData 
             END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
             AS PriceNoVAT

           , CASE WHEN vbPriceWithVAT = FALSE
                  THEN CAST (MIFloat_Price.ValueData + MIFloat_Price.ValueData * (vbVATPercent / 100) AS NUMERIC (16, 4))
                  ELSE MIFloat_Price.ValueData 
             END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
             AS PriceWVAT

           , CAST (MovementItem.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                              THEN (MIFloat_Price.ValueData - MIFloat_Price.ValueData * (vbVATPercent / 100))
                                              ELSE MIFloat_Price.ValueData
                                         END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT
           , CAST (MovementItem.Amount * CASE WHEN vbPriceWithVAT <> TRUE
                                              THEN MIFloat_Price.ValueData + MIFloat_Price.ValueData * (vbVATPercent / 100)
                                              ELSE MIFloat_Price.ValueData
                                         END / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

       FROM MovementItem
            INNER JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        AND MIFloat_Price.ValueData <> 0
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                  AND tmpObject_GoodsPropertyValue.Name <> ''
       WHERE MovementItem.MovementId = vbMovementId_Tax
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
         AND MovementItem.Amount <> 0
      ;
     RETURN NEXT Cursor2;


     -- Данные по разнице Продажи и Налоговой
     OPEN Cursor3 FOR
     WITH
     tmpMovementTaxCount AS
     (
     SELECT CASE
            WHEN (vbMovementId_Sale <> 0 AND vbMovementId_Tax<>0 AND MovementLinkObject_DocumentTaxKind.ObjectId=80787)--тип-налоговой 80787=налоговая простая
            THEN 1 ELSE 0 END                       AS CountTaxId
     FROM MovementLinkObject AS MovementLinkObject_DocumentTaxKind
     WHERE MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
       AND MovementLinkObject_DocumentTaxKind.MovementId = vbMovementId_Tax
     )
     ,
     tmpTax AS
      (SELECT MovementItem.ObjectId                  AS GoodsId
            , MIFloat_Price.ValueData                AS Price
            , SUM (MovementItem.Amount)              AS Amount
       FROM MovementItem
            INNER JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        AND MIFloat_Price.ValueData <> 0
       WHERE MovementItem.MovementId = vbMovementId_Tax
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
       GROUP BY MovementItem.ObjectId
              , MIFloat_Price.ValueData
      )
    , tmpSale AS
       (SELECT MovementItem.ObjectId     			AS GoodsId
             , CASE WHEN MovementFloat_ChangePercent.ValueData <> 0
                         THEN CAST ( (1 + MovementFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                    ELSE COALESCE (MIFloat_Price.ValueData, 0)
               END AS Price
             , SUM (CASE WHEN Movement.DescId = zc_Movement_Sale()
                              THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                              ELSE MovementItem.Amount
                    END) AS Amount
       FROM MovementItem
            INNER JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                        AND MIFloat_Price.ValueData <> 0
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = MovementItem.MovementId
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
       WHERE MovementItem.MovementId = vbMovementId_Sale
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
       GROUP BY MovementItem.ObjectId
              , MIFloat_Price.ValueData
              , MovementFloat_ChangePercent.ValueData
      )

       SELECT GoodsId
            , Object_Goods.ObjectCode        AS GoodsCode
            , Object_Goods.ValueData         AS GoodsName
            , Price                          AS Price
            , CAST (COALESCE(tmpMovementTaxCount.CountTaxId, 0) AS Integer) AS CountTaxId
            , SUM (SaleAmount)               AS SaleAmount
            , SUM (TaxAmount)                AS TaxAmount
       FROM (SELECT tmpSale.GoodsId
                  , tmpSale.Price
                  , tmpSale.Amount AS SaleAmount
                  , 0              AS TaxAmount
             FROM tmpSale
             WHERE tmpSale.Amount <> 0
           UNION ALL
             SELECT tmpTax.GoodsId
                  , tmpTax.Price
                  , 0             AS SaleAmount
                  , tmpTax.Amount AS TaxAmount
             FROM tmpTax
          ) AS tmp
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id =  tmp.GoodsId
           LEFT JOIN tmpMovementTaxCount ON 1=1
       GROUP BY tmp.GoodsId
              , Object_Goods.ObjectCode
              , Object_Goods.ValueData
              , tmp.Price
              , tmpMovementTaxCount.CountTaxId
       HAVING SUM (tmp.SaleAmount) <>  SUM (tmp.TaxAmount)
      ;
     RETURN NEXT Cursor3;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Tax_Print (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.06.14                                        * add tmpObject_GoodsPropertyValue.Name
 21.05.14                                        * add zc_Movement_TransferDebtOut
 20.05.14                                        * ContractSigningDate -> Object_Contract_View.StartDate
 19.05.14                                        * add MovementFloat_ChangePercent
 17.05.14                                        * add StatusId = zc_Enum_Status_Complete
 13.05.14                                        * add calc GoodsName
 07.05.14                       * add CHARCODE
 24.04.14                                                       * add zc_MovementString_InvNumberBranch
 11.04.14                                                       *
 02.04.14                                                       *  PriceWVAT PriceNoVAT round to 2 sign
 01.04.14                                                       *  MIFloat_Price.ValueData <> 0
 31.03.14                                                       *  + inisClientCopy
 23.03.14                                        * rename zc_MovementLinkMovement_Child -> zc_MovementLinkMovement_Master
 06.03.14                                                       *
 24.02.14                                                       *  add PriceNoVAT, PriceWVAT, AmountSummNoVAT, AmountSummWVAT
 19.02.14                                                       *  add by juridical
 07.02.14                                                       *  change to Cursor
 05.02.14                                                       *
*/

/*
BEGIN;
 SELECT * FROM gpSelect_Movement_Tax_Print (inMovementId := 135428 , inisClientCopy:= FALSE ,inSession:= '2');
COMMIT;
*/
-- тест
-- SELECT * FROM gpSelect_Movement_Tax_Print (inMovementId := 171760, inisClientCopy:= FALSE ,inSession:= '2');
