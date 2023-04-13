-- Function: gpSelect_Movement_ChangePercent_PrintAkt()

DROP FUNCTION IF EXISTS gpSelect_Movement_ChangePercent_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ChangePercent_Print(
    IN inMovementId        Integer  ,  -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbChangePercent TFloat;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ChangePercent());
     vbUserId:= lpGetUserBySession (inSession);


     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , MovementFloat_ChangePercent.ValueData      AS ChangePercent 
          , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData         AS VATPercent
   INTO vbDescId, vbStatusId, vbChangePercent,vbPriceWithVAT, vbVATPercent 
     FROM Movement 
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
     WHERE Movement.Id = inMovementId;


    -- очень важная проверка
    -- IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    IF COALESCE (vbStatusId, 0) = zc_Enum_Status_UnComplete() AND vbUserId <> 5
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
    tmpMI AS (SELECT 
                    -- сумма БЕЗ скидки, БЕЗ НДС
                    SUM (CAST (MovementItem.Amount
                             * CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                    THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData
                                    ELSE MIFloat_Price.ValueData
                               END
                               AS NUMERIC (16, 2)
                              )) ::TFloat AS Sum_1 

                    -- сумма скидки
                  , SUM (CAST (MovementItem.Amount
                             * CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                          THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData
                                          ELSE MIFloat_Price.ValueData
                                     END
                                   * vbChangePercent / 100 AS NUMERIC (16, 2)
                                    )
                               AS NUMERIC (16, 2)
                              )) ::TFloat AS Sum_Diff1 

                    -- сумма скидки С НДС
                  , SUM (CAST (CAST (MovementItem.Amount
                                   * CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData
                                                ELSE MIFloat_Price.ValueData
                                           END
                                         * vbChangePercent / 100 AS NUMERIC (16, 2)
                                          )
                                     AS NUMERIC (16, 2)
                                    )
                             * vbVATPercent / 100
                               AS NUMERIC (16, 2)
                              )) ::TFloat AS Sum_Diff1_tax
               FROM MovementItem
                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
          
                    LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                               AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
          
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
                )


       ---
       SELECT
             Movement.Id                                AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate

           , MovementString_InvNumberPartner.ValueData  AS InvNumberPartner

           , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData         AS VATPercent
           , MovementFloat_ChangePercent.ValueData      AS ChangePercent

           , MovementFloat_TotalCountKg.ValueData       AS TotalCountKg
           , MovementFloat_TotalCountSh.ValueData       AS TotalCountSh
           , MovementFloat_TotalCount.ValueData         AS TotalCount

         /*, CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT
           , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData      AS TotalSummPVAT*/
           
           , (CAST (tmpMI.Sum_1 * (1 + MovementFloat_VATPercent.ValueData / 100) AS NUMERIC (16, 2)) - tmpMI.Sum_1) :: TFloat AS TotalSummVAT
           , tmpMI.Sum_1 :: TFloat AS TotalSummMVAT
           , (CAST (tmpMI.Sum_1 * (1 + MovementFloat_VATPercent.ValueData / 100) AS NUMERIC (16, 2))) :: TFloat AS TotalSummPVAT

           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
          -- , MovementFloat_TotalSummPVAT.ValueData * MovementFloat_ChangePercent.ValueData  / 100  AS TotalSumm_ChangePercent 
          , (tmpMI.Sum_Diff1 + tmpMI.Sum_Diff1_tax) :: TFloat  AS TotalSumm_ChangePercent 
           
           , Object_From.Id                    	     AS FromId
           , Object_From.ValueData                   AS FromName
           , View_JuridicalDetails_From.OKPO         AS OKPO_From
           , Object_To.Id                      	     AS ToId
           , Object_To.ValueData                     AS ToName
           , View_JuridicalDetails_To.OKPO           AS OKPO_To

           , Object_Partner.ObjectCode               AS PartnerCode
           , Object_Partner.ValueData                AS PartnerName

           , View_Contract_InvNumber.ContractId      AS ContractId
           , View_Contract_InvNumber.ContractCode    AS ContractCode
           , View_Contract_InvNumber.InvNumber       AS ContractName
           , View_Contract_InvNumber.ContractTagName AS ContractTagName
           , ObjectDate_Signing.ValueData            AS SigningDate

           , Object_PaidKind.Id                      AS PaidKindName
           , Object_PaidKind.ValueData               AS PaidKindName

           , View_InfoMoney.InfoMoneyGroupName       AS InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName AS InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode            AS InfoMoneyCode
           , View_InfoMoney.InfoMoneyName            AS InfoMoneyName

           , Object_TaxKind.Id                	    AS DocumentTaxKindId
           , Object_TaxKind.ValueData         	    AS DocumentTaxKindName
           --, MovementString_Comment.ValueData       AS Comment

           , DATE_TRUNC ('MONTH', Movement.OperDate)       AS StartDate
           , DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate
           
           --Додаткова угода № від
           , CASE WHEN View_Contract_InvNumber.ContractId = 9081123 THEN ' № 75 від 01.03.2023'
                  WHEN View_Contract_InvNumber.ContractId = 8875106 THEN ' № 76 від 01.03.2023' 
                    ELSE '______________________'
             END AS Text_ugoda
           --доверенность
           , CASE WHEN Object_To.Id = 8793437 THEN ' Довіренність № 2562-201-22' ELSE '______________________' END AS Text_dovir
           --ответственный
           , CASE WHEN Object_To.Id = 8793437 THEN ' Євстіфєєв Юрій Костянтинович' ELSE '______________________' END AS Text_upovnovag
           
       FROM Movement
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            
      /*   LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

           LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

     */       LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                    ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCountSh
                                    ON MovementFloat_TotalCountSh.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCountSh.DescId = zc_MovementFloat_TotalCountSh()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

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
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS View_JuridicalDetails_From ON View_JuridicalDetails_From.JuridicalId = Object_From.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS View_JuridicalDetails_To ON View_JuridicalDetails_To.JuridicalId = Object_To.Id

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                         ON MovementLinkObject_Partner.MovementId = Movement.Id
                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = View_Contract_InvNumber.ContractId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

            LEFT JOIN tmpMI ON 1= 1 

       WHERE Movement.Id = inMovementId
      ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
    WITH 
    tmpMI AS (SELECT MovementItem.Id          AS Id
                   , CAST (row_number() OVER (ORDER BY MovementItem.Id) AS Integer) AS LineNum
                   , Object_Goods.Id          AS GoodsId
                   , Object_Goods.ObjectCode  AS GoodsCode
                   , Object_Goods.ValueData   AS GoodsName
                   , MovementItem.Amount      AS Amount
                   , MIFloat_Price.ValueData  AS Price
                   , CAST (MIFloat_Price.ValueData * (1-vbChangePercent / 100) AS NUMERIC (16,2))  AS Price_ChangePercent     --цена со скидкой
                   , MIFloat_CountForPrice.ValueData  AS CountForPrice
          
                   , Object_GoodsKind.ValueData AS GoodsKindName
                   , Object_Measure.ValueData   AS MeasureName
          
                   , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                   THEN CAST ( MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                ELSE CAST ( MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                           END AS TFloat)	    AS AmountSumm
          
                   , vbChangePercent AS ChangePercent
          
                     -- сумма скидки
                   , (CAST (MovementItem.Amount
                          * CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                       THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData
                                       ELSE MIFloat_Price.ValueData
                                  END
                                * vbChangePercent / 100 AS NUMERIC (16, 2)
                                 )
                            AS NUMERIC (16, 2)
                           )) ::TFloat AS Sum_Diff1 
 
                     -- сумма скидки С НДС
                   , (CAST (CAST (MovementItem.Amount
                                * CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                             THEN MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData
                                             ELSE MIFloat_Price.ValueData
                                        END
                                      * vbChangePercent / 100 AS NUMERIC (16, 2)
                                       )
                                  AS NUMERIC (16, 2)
                                 )
                          * vbVATPercent / 100
                            AS NUMERIC (16, 2)
                           )) ::TFloat AS Sum_Diff1_tax

               FROM MovementItem
                    LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                    LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                         ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                        AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
          
                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
          
                    LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                               AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
          
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
              )
     SELECT tmpMI.*
          , tmpMI.Sum_Diff1_tax :: TFloat AS Sum_VATPercent 
          , (tmpMI.Sum_Diff1 + tmpMI.Sum_Diff1_tax) :: TFloat AS Sum_ChangePercent_vat
          , vbVATPercent AS VATPercent
     FROM tmpMI
     ORDER BY  tmpMI.GoodsName, tmpMI.GoodsKindName
    ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.03.23         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ChangePercent_Print (inMovementId :=24672369 , inSession := '9457'); --FETCH ALL "<unnamed portal 36>";