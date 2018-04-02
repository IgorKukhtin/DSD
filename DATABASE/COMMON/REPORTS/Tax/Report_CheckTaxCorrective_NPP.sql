-- FunctiON: Report_CheckTaxCorrective_NPP ()

DROP FUNCTION IF EXISTS Report_CheckTaxCorrective_NPP (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION Report_CheckTaxCorrective_NPP (
    IN inMovementId          Integer   , -- № налоговой
    IN inGoodsId             Integer   , -- товар
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (ItemName TVarChar, InvNumber TVarChar, InvNumberPartner TVarChar, InvNumberPartner_Tax TVarChar
             , OperDate TDateTime
             , JuridicalName TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , LineNum         Integer
             , LineNumTax      Integer
             , LineNumTaxCorr_calc Integer
             , LineNum_calc    Integer
             , Amount          TFloat
             , Price           TFloat
             , CountForPrice   TFloat
             , AmountSumm      TFloat
             , AmountTax_calc  TFloat
              )  
AS
$BODY$

BEGIN

    RETURN QUERY

      WITH
      -- № п/п строк Налоговой
      tmpMITax AS (SELECT tmp.Kind, tmp.GoodsId, tmp.GoodsKindId, tmp.Price, tmp.LineNum
                   FROM lpSelect_TaxFromTaxCorrective (inMovementId) AS tmp
                  )

    , tmpMI_Tax AS (SELECT MovementItem.MovementId
                         , MIFloat_NPP.ValueData       :: Integer AS LineNum
                         , Object_Goods.Id                        AS GoodsId
                         , Object_Goods.ObjectCode                AS GoodsCode
                         , Object_Goods.ValueData                 AS GoodsName
                         , Object_GoodsKind.Id                    AS GoodsKindId
                         , Object_GoodsKind.ValueData             AS GoodsKindName
                         , MovementItem.Amount                    AS Amount
                         , MIFloat_Price.ValueData                AS Price
                         , MIFloat_CountForPrice.ValueData        AS CountForPrice

                         , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                         THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                         ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                                 END AS TFloat)                   AS AmountSumm
                       
                     FROM MovementItem
                          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
              
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                      ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                     AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                          LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                                      ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                                     AND MIFloat_NPP.DescId = zc_MIFloat_NPP()           
              
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE --tmpIsErased.isErased
                AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
           )

    , tmpMI_TaxCorrective AS (SELECT MovementItem.MovementId
                                   , tmpMovement.MovementId_Tax
                                   , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, True) = True THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE COALESCE(MIFloat_NPP.ValueData,0) END  :: Integer AS LineNumTaxOld
                                   , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, True) = True THEN COALESCE (tmpMITax1.LineNum, tmpMITax2.LineNum) ELSE COALESCE(MIFloat_NPP.ValueData,0) END  :: Integer AS LineNumTax
                        
                                   , COALESCE (MIFloat_NPPTax_calc.ValueData, 0)    :: Integer AS LineNumTaxCorr_calc
                                   , COALESCE (MIFloat_NPP_calc.ValueData, 0)       :: Integer AS LineNumTaxCorr
                                   , COALESCE (MIFloat_AmountTax_calc.ValueData, 0) :: TFloat  AS AmountTax_calc
                        
                                   , Object_Goods.Id                        AS GoodsId
                                   , Object_Goods.ObjectCode                AS GoodsCode
                                   , Object_Goods.ValueData                 AS GoodsName
                                   , Object_GoodsKind.Id                    AS GoodsKindId
                                   , Object_GoodsKind.ValueData             AS GoodsKindName
                                   , MovementItem.Amount                    AS Amount
                                   , MIFloat_Price.ValueData                AS Price
                                   , MIFloat_CountForPrice.ValueData        AS CountForPrice
                                   , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                                   THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                                                   ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                                           END AS TFloat)                   AS AmountSumm
                                               
                              FROM (SELECT MLM_DocumentChild.MovementId                    --корр.
                                         , MLM_DocumentChild.MovementChildId  AS MovementId_Tax
                                    FROM MovementLinkMovement AS MLM_DocumentChild
                                         INNER JOIN Movement ON Movement.Id = MLM_DocumentChild.MovementId
                                                            AND Movement.DescId = zc_Movement_TaxCorrective()
                                                            AND Movement.StatusId = zc_Enum_Status_Complete()
                                    WHERE MLM_DocumentChild.MovementChildId = inMovementId -- НН
                                      AND MLM_DocumentChild.DescId = zc_MovementLinkMovement_Child()
                                    ) AS tmpMovement 
                                   LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                                   
                                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                       
                                   LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                                               ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                                              AND MIFloat_NPP.DescId = zc_MIFloat_NPP()
                                   LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                                 ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                         AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()

                                   LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                                               ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_NPPTax_calc.DescId = zc_MIFloat_NPPTax_calc()
                                   LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                               ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_NPP_calc.DescId = zc_MIFloat_NPP_calc()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                                               ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountTax_calc.DescId = zc_MIFloat_AmountTax_calc()
                       
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                                   LEFT JOIN tmpMITax AS tmpMITax1 ON tmpMITax1.Kind        = 1
                                                                  AND tmpMITax1.GoodsId     = Object_Goods.Id
                                                                  AND tmpMITax1.GoodsKindId = Object_GoodsKind.Id
                                                                  AND tmpMITax1.Price       = MIFloat_Price.ValueData
                                   LEFT JOIN tmpMITax AS tmpMITax2 ON tmpMITax2.Kind        = 2
                                                                  AND tmpMITax2.GoodsId     = Object_Goods.Id
                                                                  AND tmpMITax2.Price       = MIFloat_Price.ValueData
                                                                  AND tmpMITax1.GoodsId     IS NULL
                                WHERE (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                                  -- AND COALESCE (MIFloat_NPP_calc.ValueData, 0) <> 0
                              )
                              
    , tmpData AS (SELECT tmp.MovementId
                       , tmp.MovementId AS MovementId_Tax
                       , tmp.LineNum
                       , tmp.GoodsCode
                       , tmp.GoodsName
                       , tmp.GoodsKindName
                       , tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.AmountSumm
                       , 0   :: Integer AS LineNumTaxCorr_calc
                       , 0    AS LineNumTax
                       , 0   :: TFloat  AS AmountTax_calc
                  FROM tmpMI_Tax AS tmp
               UNION 
                  SELECT tmp.MovementId
                       , tmp.MovementId_Tax
                       , tmp.LineNumTaxCorr AS LineNum
                       , tmp.GoodsCode
                       , tmp.GoodsName
                       , tmp.GoodsKindName
                       , (-1) * tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , (-1) * tmp.AmountSumm
                       , tmp.LineNumTaxCorr_calc
                       , tmp.LineNumTax
                       , tmp.AmountTax_calc
                  FROM tmpMI_TaxCorrective AS tmp
                  )
    --- результат 
    SELECT MovementDesc.ItemName
         , Movement.InvNumber
         , MovementString_InvNumberPartner.ValueData     AS InvNumberPartner
         , MovementString_InvNumberPartner_Tax.ValueData AS InvNumberPartner_Tax
         , Movement.OperDate
         , Object_To.ValueData  AS JuridicalName
         , tmpData.GoodsCode
         , tmpData.GoodsName
         , tmpData.GoodsKindName

         , tmpData.LineNum             :: integer
         , tmpData.LineNumTax          :: integer
         , CASE WHEN COALESCE (tmpData.LineNumTaxCorr_calc, 0) <> 0 THEN tmpData.LineNumTaxCorr_calc ELSE tmpLine.LineNum END  :: integer AS LineNumTaxCorr_calc
         --, tmpData.LineNumTaxCorr_calc
         , ROW_NUMBER() OVER (PARTITION BY tmpData.MovementId_Tax ORDER BY tmpData.LineNum, tmpData.LineNumTaxCorr_calc)  :: integer AS LineNum_calc
         --, ROW_NUMBER() OVER (ORDER BY tmpData.LineNum, tmpData.LineNumTaxCorr_calc)  :: integer AS LineNum_calc
         , tmpData.Amount         :: TFloat
         , tmpData.Price          :: TFloat
         , tmpData.CountForPrice  :: TFloat
         , tmpData.AmountSumm     :: TFloat
         , tmpData.AmountTax_calc :: TFloat 
    FROM tmpData
         LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
         LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = CASE WHEN Movement.DescId = zc_Movement_Tax() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
         LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
         
         LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                  ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                 AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

         LEFT JOIN MovementString AS MovementString_InvNumberPartner_Tax
                                  ON MovementString_InvNumberPartner_Tax.MovementId = tmpData.MovementId_Tax
                                 AND MovementString_InvNumberPartner_Tax.DescId = zc_MovementString_InvNumberPartner()

         LEFT JOIN tmpData AS tmpLine ON tmpLine.LineNumTaxCorr_calc = tmpData.LineNum  -- and 1 = 0
                                    AND tmpData.LineNum <> 0
                                    AND tmpLine.MovementId_Tax = tmpData.MovementId_Tax
    ORDER BY 1 DESC, tmpData.LineNum
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.18         *
 30.03.18         *
*/

-- тест
-- SELECT * FROM Report_CheckTaxCorrective_NPP (inMovementId:= 5199861, inGoodsId:= 0, inSession:= zfCalc_UserAdmin());
