-- Function: gpSelect_Movement_IncomeAsset_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeAsset_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeAsset_Print(
    IN inMovementId        Integer  , -- ключ Документа Приход от поставщика
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbChangePercentTo TFloat;
    DECLARE vbPaidKindId Integer;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;

    DECLARE vbContractId Integer;
    DECLARE vbIsProcess_BranchIn Boolean;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_IncomeAsset_Print());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END    AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END     AS ExtraChargesPercent
          , COALESCE (MovementFloat_ChangePercentTo.ValueData, 0)   AS ChangePercentTo

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)      AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId

            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbChangePercentTo, vbPaidKindId, vbContractId
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

          LEFT JOIN MovementFloat AS MovementFloat_ChangePercentTo
                                  ON MovementFloat_ChangePercentTo.MovementId = Movement.Id
                                 AND MovementFloat_ChangePercentTo.DescId = zc_MovementFloat_ChangePercentPartner()                              
      
     WHERE Movement.Id = inMovementId
       -- AND Movement.StatusId = zc_Enum_Status_Complete()
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
       -- RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



      --
    OPEN Cursor1 FOR
         WITH tmpMovementDate       AS (SELECT * FROM MovementDate WHERE MovementDate.MovementId =  inMovementId)
            , tmpMovementString     AS (SELECT * FROM MovementString WHERE MovementString.MovementId =  inMovementId)
            , tmpMovementBoolean    AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId =  inMovementId)
            , tmpMovementFloat      AS (SELECT * FROM MovementFloat WHERE MovementFloat.MovementId =  inMovementId)
            , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject WHERE MovementLinkObject.MovementId =  inMovementId)
         --
         SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData          AS VATPercent
           , MovementFloat_ChangePercent.ValueData       AS ChangePercent

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalCountPartner.ValueData   AS TotalCountPartner
           , MovementFloat_TotalSummMVAT.ValueData       AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData       AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData           AS TotalSumm
           , MovementFloat_TotalSummSpending.ValueData   AS TotalSummSpending
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           
           , CAST (COALESCE (MovementFloat_CurrencyValue.ValueData, 0) AS TFloat)  AS CurrencyValue

           , Object_From.ValueData             AS FromName
           , Object_To.ValueData               AS ToName
           , Object_PaidKind.ValueData         AS PaidKindName
           , Object_Contract_View.ContractCode AS ContractCode
           , Object_Contract_View.InvNumber AS ContractName
           , Object_Contract_View.ContractKindName  AS ContractKind
           , ObjectDate_Signing.ValueData      AS ContractSigningDate

           , Object_JuridicalFrom.ValueData    AS JuridicalName_From
           , Object_JuridicalTo.ValueData      AS JuridicalName_To
           , ObjectHistory_JuridicalDetails_View.OKPO AS OKPO_From
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
         
           , Object_CurrencyDocument.ValueData AS CurrencyDocumentName
           , Object_CurrencyPartner.ValueData  AS CurrencyPartnerName
        
           , CASE WHEN (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0) AND vbPaidKindId = zc_Enum_PaidKind_SecondForm()
                        THEN ' та знижкой'
                  ELSE ''
             END AS Price_info

           , ObjectHistory_JuridicalDetails_View.JuridicalId       AS JuridicalId_From
           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From
           , OH_JuridicalDetails_From.JuridicalAddress  AS JuridicalAddress_From
           , OH_JuridicalDetails_From.OKPO              AS OKPO_From
           , OH_JuridicalDetails_From.INN               AS INN_From
           , OH_JuridicalDetails_From.NumberVAT         AS NumberVAT_From
           , OH_JuridicalDetails_From.BankAccount       AS BankAccount_From
           , OH_JuridicalDetails_From.BankName          AS BankName_From
           , OH_JuridicalDetails_From.MFO               AS BankMFO_From
           , OH_JuridicalDetails_From.Phone             AS Phone_From
      
           , OH_JuridicalDetails_To.Phone               AS Phone_To
   
           , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '') 
                  ELSE 'м.Днiпро' 
                  END  :: TVarChar   AS PlaceOf 

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN tmpMovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
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

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummSpending
                                    ON MovementFloat_TotalSummSpending.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummSpending.DescId = zc_MovementFloat_TotalSummSpending()

            LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND Object_Contract_View.InvNumber <> '-'

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = Object_Contract_View.InfoMoneyId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                 ON ObjectLink_CardFuel_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, ObjectLink_CardFuel_Juridical.ChildObjectId)
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_JuridicalFrom.Id

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_To_Juridical
                                 ON ObjectLink_To_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_To_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_To_Juridical.ChildObjectId
                  
            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = Object_JuridicalTo.Id
                                                               AND Movement.OperDate >= OH_JuridicalDetails_To.StartDate
                                                               AND Movement.OperDate <  OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = Object_JuridicalFrom.Id
                                                               AND Movement.OperDate >= OH_JuridicalDetails_From.StartDate
                                                               AND Movement.OperDate <  OH_JuridicalDetails_From.EndDate
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId =  Object_JuridicalFrom.Id 
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf
                                   ON ObjectString_PlaceOf.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()   
         
      WHERE Movement.Id = inMovementId
        AND Movement.DescId = zc_Movement_IncomeAsset();
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       SELECT Object_Goods.Id                AS Id
           , Object_Goods.ObjectCode         AS GoodsCode
           , COALESCE(ObjectString_FullName.ValueData,'') :: TVarChar AS GoodsName
           , Object_Goods.ValueData          AS GoodsName_two
           , tmpMI.Amount                    AS Amount
           , tmpMI.Price                     AS Price
           , tmpMI.CountForPrice             AS CountForPrice

           , CASE WHEN tmpMI.Amount = 0
                       THEN 0
                  WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.Amount * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2)) / tmpMI.Amount
                  ELSE CAST (tmpMI.Amount * tmpMI.Price AS NUMERIC (16, 2)) / tmpMI.Amount
             END AS Price2


             -- сумма по ценам док-та
           , CASE WHEN tmpMI.CountForPrice <> 0
                       THEN CAST (tmpMI.Amount * (tmpMI.Price / tmpMI.CountForPrice) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.Amount * tmpMI.Price AS NUMERIC (16, 2))
             END AS AmountSumm

             -- расчет цены без НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT = TRUE
                  THEN CAST (tmpMI.Price - tmpMI.Price * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                  ELSE tmpMI.Price
             END  / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceNoVAT

             -- расчет цены с НДС, до 4 знаков
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.Price + tmpMI.Price * (vbVATPercent / 100))
                                         * CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ учитываем!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ учитываем!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.Price * CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                                     THEN (1 - vbDiscountPercent / 100)
                                                WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                                                     THEN (1 + vbExtraChargesPercent / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
             END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
             AS PriceWVAT

             -- расчет суммы без НДС, до 2 знаков
           , CAST (tmpMI.Amount * CASE WHEN vbPriceWithVAT = TRUE
                                       THEN (tmpMI.Price - tmpMI.Price * (vbVATPercent / 100))
                                       ELSE tmpMI.Price
                                  END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 2)) AS AmountSummNoVAT

             -- расчет суммы с НДС, до 3 знаков
           , CAST (tmpMI.Amount * CASE WHEN vbPriceWithVAT <> TRUE
                                       THEN tmpMI.Price + tmpMI.Price * (vbVATPercent / 100)
                                       ELSE tmpMI.Price
                                  END / CASE WHEN tmpMI.CountForPrice <> 0 THEN tmpMI.CountForPrice ELSE 1 END
                   AS NUMERIC (16, 3)) AS AmountSummWVAT

             -- расчет цены C НДС покупателя , до 4 знаков, для  (с учетом скидки)
           , CASE WHEN vbPriceWithVAT <> TRUE
                  THEN CAST ((tmpMI.PriceOriginal + tmpMI.PriceOriginal * (vbVATPercent / 100))
                                         * CASE WHEN vbChangePercentTo <> 0 
                                                     THEN (1 + vbChangePercentTo / 100)
                                                ELSE 1
                                           END
                             AS NUMERIC (16, 4))
                  ELSE CAST (tmpMI.PriceOriginal * CASE WHEN vbChangePercentTo <> 0
                                                             THEN (1 + vbChangePercentTo / 100)
                                                        ELSE 1
                                                   END
                             AS NUMERIC (16, 4))
             END   AS PriceWVAT_To
   
           , vbChangePercentTo
      
       FROM (SELECT MovementItem.ObjectId AS GoodsId
                  , CASE WHEN vbDiscountPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         WHEN vbExtraChargesPercent <> 0 AND vbPaidKindId <> zc_Enum_PaidKind_SecondForm() -- !!!для НАЛ не учитываем!!!
                              THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                         ELSE COALESCE (MIFloat_Price.ValueData, 0)
                    END AS Price
                  , MIFloat_CountForPrice.ValueData AS CountForPrice
                  , SUM (MovementItem.Amount) AS Amount
   
                  , COALESCE (MIFloat_Price.ValueData, 0) AS PriceOriginal
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Master()
               AND MovementItem.isErased   = FALSE
             GROUP BY MovementItem.ObjectId
                    , MIFloat_Price.ValueData
                    , MIFloat_CountForPrice.ValueData
            ) AS tmpMI

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN ObjectString AS ObjectString_FullName
                                   ON ObjectString_FullName.ObjectId = Object_Goods.Id
                                  AND ObjectString_FullName.DescId = zc_ObjectString_Asset_FullName()
       WHERE tmpMI.Amount <> 0 
       ORDER BY Object_Goods.ValueData
       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_IncomeAsset_Print (Integer,  TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.10.16         * parce
 02.08.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_IncomeAsset_Print (inMovementId := 432692, inSession:= '5');
