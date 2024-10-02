-- Function: gpSelect_Movement_SaleAsset_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_SaleAsset_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SaleAsset_Print(
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
    DECLARE vbOperDate TDateTime;
    DECLARE vbJuridicalId_From Integer;
    DECLARE vbJuridicalId_to Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SaleAsset_Print());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)        AS VATPercent
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)      AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0)      AS ContractId
          , Movement.OperDate
          , ObjectLink_from_Juridical.ChildObjectId AS JuridicalId_from 
          , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, ObjectLink_CardFuel_Juridical.ChildObjectId) AS JuridicalId_to
          

            INTO vbDescId, vbStatusId, vbPriceWithVAT, vbVATPercent, vbPaidKindId, vbContractId, vbOperDate, vbJuridicalId_From, vbJuridicalId_to
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                    ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                 AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractTo())
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindTo())

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectLink AS ObjectLink_From_Juridical
                                 ON ObjectLink_From_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_From_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                               ON ObjectLink_CardFuel_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
            
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
    END IF;



      --
    OPEN Cursor1 FOR
       WITH 
       tmpJuridicalDetails_ViewByDate AS (SELECT * 
                                          FROM ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails
                                          where vbOperDate >= OH_JuridicalDetails.StartDate
                                            AND vbOperDate <  OH_JuridicalDetails.EndDate
                                            AND OH_JuridicalDetails.JuridicalId IN (vbJuridicalId_From, vbJuridicalId_to)
                                          )
 
  SELECT
             Movement.Id  
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData          AS VATPercent
           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData       AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData       AS TotalSummPVAT
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           
           , Object_From.ValueData             AS FromName
           , Object_To.ValueData               AS ToName
           , Object_Contract.ObjectCode        AS ContractCode
           , Object_Contract.ValueData         AS ContractName
           , ObjectDate_Signing.ValueData      AS ContractSigningDate

           --, Object_JuridicalFrom.ValueData    AS JuridicalName_From
           --, Object_JuridicalTo.ValueData      AS JuridicalName_To
     
           , CASE WHEN COALESCE (ObjectString_PlaceOf.ValueData, '') <> '' THEN COALESCE (ObjectString_PlaceOf.ValueData, '') 
                  ELSE 'м.Днiпро' 
                  END  :: TVarChar   AS PlaceOf 
           , OH_JuridicalDetails_From.FullName          AS JuridicalName_From 
           , OH_JuridicalDetails_To.FullName            AS JuridicalName_To
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

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
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId 

            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = Object_Contract.Id
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                                AND Object_Contract.ValueData <> '-'

            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = vbJuridicalId_From

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId =  Object_JuridicalFrom.Id 
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectString AS ObjectString_PlaceOf
                                   ON ObjectString_PlaceOf.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                  AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()   
 
            LEFT JOIN tmpJuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                     ON OH_JuridicalDetails_From.JuridicalId = vbJuridicalId_From
                                                    AND Movement.OperDate >= OH_JuridicalDetails_From.StartDate
                                                    AND Movement.OperDate <  OH_JuridicalDetails_From.EndDate 

            LEFT JOIN tmpJuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                     ON OH_JuridicalDetails_To.JuridicalId = vbJuridicalId_to
                                                    AND Movement.OperDate >= OH_JuridicalDetails_To.StartDate
                                                    AND Movement.OperDate <  OH_JuridicalDetails_To.EndDate
                                                                            
              LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = vbJuridicalId_to
      WHERE Movement.Id = inMovementId
        AND Movement.DescId = zc_Movement_SaleAsset();

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
ALTER FUNCTION gpSelect_Movement_SaleAsset_Print (Integer,  TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.10.16         * parce
 02.08.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_SaleAsset_Print (inMovementId := 432692, inSession:= '5');
