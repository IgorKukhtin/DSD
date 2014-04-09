-- Function: gpSelect_Movement_Sale_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= inSession;

     --
    OPEN Cursor1 FOR
       SELECT
             Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , MovementBoolean_Checked.ValueData          AS Checked
           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner
           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT
           , MovementFloat_TotalSummPVAT.ValueData
            -MovementFloat_TotalSummMVAT.ValueData      AS SummVAT
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , Object_From.Id                    			AS FromId
           , Object_From.ValueData             			AS FromName
           , Object_To.Id                      			AS ToId
           , Object_To.ValueData               			AS ToName
           , Object_PaidKind.Id                			AS PaidKindId
           , Object_PaidKind.ValueData         			AS PaidKindName
           , Object_Contract.ContractId        			AS ContractId
           , Object_Contract.invnumber         			AS ContractName
           , Object_RouteSorting.Id        				AS RouteSortingId
           , Object_RouteSorting.ValueData 				AS RouteSortingName
           , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
           , ObjectDate_Signing.ValueData               AS ContractSigningDate
           , Object_ContractKind.ValueData              AS ContractKind
           , CAST('Бабенко В.П.' AS TVarChar)           AS StoreKeeper -- кладовщик
           , CAST('' AS TVarChar)                       AS Through     -- через кого
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

       FROM Movement

            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()


            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical ON ObjectLink_Unit_Juridical.objectid = MovementLinkObject_From.ObjectId
                                                             AND ObjectLink_Unit_Juridical.descid = zc_objectlink_unit_juridical()

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
-- Contract
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

            LEFT JOIN object_contract_invnumber_view AS Object_Contract ON Object_Contract.contractid = MovementLinkObject_Contract.ObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = MovementLinkObject_Contract.ObjectId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()

            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                 ON ObjectLink_Contract_ContractKind.ObjectId = MovementLinkObject_Contract.ObjectId
                                AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()

            LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteSorting
                                         ON MovementLinkObject_RouteSorting.MovementId = Movement.Id
                                        AND MovementLinkObject_RouteSorting.DescId = zc_MovementLinkObject_RouteSorting()

            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = MovementLinkObject_RouteSorting.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()


            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_To
                                                                ON OH_JuridicalDetails_To.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                               AND Movement.OperDate BETWEEN OH_JuridicalDetails_To.StartDate AND OH_JuridicalDetails_To.EndDate

            LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails_From
                                                                ON OH_JuridicalDetails_From.JuridicalId = ObjectLink_Unit_Juridical.ChildObjectId
                                                               AND Movement.OperDate BETWEEN OH_JuridicalDetails_From.StartDate AND OH_JuridicalDetails_From.EndDate

           LEFT JOIN ObjectString AS ObjectString_ToAddress
                                  ON ObjectString_ToAddress.ObjectId = Object_To.Id
                                 AND ObjectString_ToAddress.DescId = zc_ObjectString_Partner_Address()



       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Sale();
    RETURN NEXT Cursor1;
    OPEN Cursor2 FOR
     WITH tmpObject_GoodsPropertyValue AS
      ( SELECT
         Object_GoodsPropertyValue.Id         AS Id
       , Object_GoodsPropertyValue.ObjectCode AS Code
       , Object_GoodsPropertyValue.ValueData  AS Name

       , ObjectFloat_Amount.ValueData         AS Amount
       , ObjectString_BarCode.ValueData       AS BarCode
       , ObjectString_Article.ValueData       AS Article
       , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
       , ObjectString_ArticleGLN.ValueData    AS ArticleGLN

       , Object_GoodsProperty.Id              AS GoodsPropertyId
       , Object_GoodsProperty.ValueData       AS GoodsPropertyName

       , Object_GoodsKind.Id                  AS GoodsKindId
       , Object_GoodsKind.ValueData           AS GoodsKindName

       , Object_Goods.Id                      AS GoodsId
       , Object_Goods.ValueData               AS GoodsName

       , Object_GoodsPropertyValue.isErased   AS isErased

        FROM Object AS Object_GoodsPropertyValue
        LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                               ON ObjectFloat_Amount.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

        LEFT JOIN ObjectString AS ObjectString_BarCode
                               ON ObjectString_BarCode.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()

        LEFT JOIN ObjectString AS ObjectString_Article
                               ON ObjectString_Article.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()

        LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                               ON ObjectString_BarCodeGLN.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()

        LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                               ON ObjectString_ArticleGLN.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId



        WHERE Object_GoodsPropertyValue.DescId = zc_Object_GoodsPropertyValue()
      )

       SELECT
             MovementItem.Id                        AS Id
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode
           , Object_Goods.ValueData                 AS GoodsName
           , MovementItem.Amount                    AS Amount
           , MIFloat_AmountChangePercent.ValueData  AS AmountChangePercent
           , MIFloat_AmountPartner.ValueData        AS AmountPartner
           , MIFloat_ChangePercentAmount.ValueData  AS ChangePercentAmount
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice
           , MIFloat_HeadCount.ValueData            AS HeadCount
           , MIString_PartionGoods.ValueData        AS PartionGoods
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , Object_Measure.Id                      AS MeasureId
           , Object_Measure.ValueData               AS MeasureName
           , Object_Asset.Id                        AS AssetId
           , Object_Asset.ValueData                 AS AssetName

           , COALESCE (tmpObject_GoodsPropertyValue.Name,
                       CAST ('' AS TVarChar))
                                                   AS GoodsName_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Amount,
                       CAST (0 AS TFloat))
                                                   AS AmountInPack_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.Article,
                       CAST ('' AS TVarChar))
                                                   AS Article_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCode,
                       CAST ('' AS TVarChar))
                                                   AS BarCode_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.ArticleGLN,
                       CAST ('' AS TVarChar))
                                                   AS ArticleGLN_Juridical
           , COALESCE (tmpObject_GoodsPropertyValue.BarCodeGLN,
                       CAST ('' AS TVarChar))
                                                   AS BarCodeGLN_Juridical

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , CASE WHEN MovementBoolean_PriceWithVAT.ValueData <> TRUE
                  THEN CAST (MIFloat_Price.ValueData +
                        (MIFloat_Price.ValueData / 100) * COALESCE (MovementFloat_VATPercent.ValueData,0)AS NUMERIC (16, 2))
                  ELSE MIFloat_Price.ValueData  END
                                                    AS PriceWVAT

           , CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE
                  THEN CAST (MIFloat_Price.ValueData -
                        (MIFloat_Price.ValueData / 100) * COALESCE (MovementFloat_VATPercent.ValueData,0) AS NUMERIC (16, 2))
                   ELSE MIFloat_Price.ValueData  END
                                                    AS PriceNoVAT

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                        THEN  (COALESCE (MIFloat_AmountPartner.ValueData, 0)) *
                        CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE
                             THEN CAST ( MIFloat_Price.ValueData -
                             (MIFloat_Price.ValueData / 100) * COALESCE (MovementFloat_VATPercent.ValueData,0) AS NUMERIC (16, 3))
                        ELSE MIFloat_Price.ValueData  END
                        / MIFloat_CountForPrice.ValueData

                        ELSE  (COALESCE (MIFloat_AmountPartner.ValueData, 0)) *
                        CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE
                             THEN CAST (MIFloat_Price.ValueData -
                             (MIFloat_Price.ValueData / 100) * COALESCE (MovementFloat_VATPercent.ValueData,0) AS NUMERIC (16, 3))
                        ELSE MIFloat_Price.ValueData  END

                   END AS NUMERIC (16, 3))                   AS AmountSummNoVAT

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                        THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) *
                        CASE WHEN MovementBoolean_PriceWithVAT.ValueData <> TRUE
                             THEN MIFloat_Price.ValueData +
                             (MIFloat_Price.ValueData / 100) * COALESCE (MovementFloat_VATPercent.ValueData,0)
                        ELSE MIFloat_Price.ValueData  END
                        / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 3))

                        ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) *
                        CASE WHEN MovementBoolean_PriceWithVAT.ValueData <> TRUE
                             THEN MIFloat_Price.ValueData +
                             (MIFloat_Price.ValueData / 100) * COALESCE (MovementFloat_VATPercent.ValueData,0)
                        ELSE MIFloat_Price.ValueData  END
                        AS NUMERIC (16, 3))
                   END AS NUMERIC (16, 3))                   AS AmountSummWVAT

       FROM MovementItem
            JOIN MovementItemFloat AS MIFloat_Price
                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                  AND MIFloat_Price.ValueData <> 0
            JOIN MovementItemFloat AS MIFloat_AmountPartner
                                   ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                  AND MIFloat_AmountPartner.ValueData <> 0

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  MovementItem.MovementId
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  MovementItem.MovementId
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MovementItem.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                 ON ObjectLink_Juridical_GoodsProperty.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()

--            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Juridical_GoodsProperty.ChildObjectId -- Классификаторы свойств товаров

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId


            LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                        ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                        ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                       AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = MovementItem.ObjectId
                                                  AND tmpObject_GoodsPropertyValue.GoodsPropertyId = ObjectLink_Juridical_GoodsProperty.ChildObjectId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = MILinkObject_GoodsKind.ObjectId


       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
       ORDER BY MovementItem.Id
       ;


    RETURN NEXT Cursor2;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.04.14                                        * add JOIN MIFloat_AmountPartner
 02.04.14                                                       *  PriceWVAT PriceNoVAT round to 2 sign
 01.04.14                                                       *  MIFloat_Price.ValueData <> 0
 27.03.14                                                       *
 24.02.14                                                       *  add PriceNoVAT, PriceWVAT, AmountSummNoVAT, AmountSummWVAT
 19.02.14                                                       *  add by juridical
 07.02.14                                                       *  change to Cursor
 05.02.14                                                       *
*/

-- тест

/*
BEGIN;
 SELECT * FROM gpSelect_Movement_Sale_Print (inMovementId := 135428, inSession:= '2');
COMMIT;
*/