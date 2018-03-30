-- FunctiON: Report_CheckTaxCorrective_NPP ()

DROP FUNCTION IF EXISTS Report_CheckTaxCorrective_NPP (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION Report_CheckTaxCorrective_NPP (
    IN inMovementId          Integer   , -- № налоговой
    IN inGoodsId             Integer   , -- товар
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (ItemName TVarChar, InvNumber TVarChar, OperDate TDateTime
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar
             , LineNum         Integer
             , LineNumTax      Integer
             , LineNumTaxCorr_calc Integer
             , LineNumTaxCorr  Integer
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
                                               
                              FROM (SELECT MovementLinkMovement_DocumentChild.MovementId                    --корр.
                                    FROM MovementLinkMovement AS MovementLinkMovement_DocumentChild
                                    WHERE MovementLinkMovement_DocumentChild.MovementChildId = inMovementId -- НН
                                      AND MovementLinkMovement_DocumentChild.DescId = zc_MovementLinkMovement_Child()
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
                              )
                              
    , tmpData AS (SELECT tmp.MovementId
                       , tmp.LineNum
                       , tmp.GoodsCode
                       , tmp.GoodsName
                       , tmp.GoodsKindName
                       , tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.AmountSumm
                       , 0              AS LineNumTax
                       , 0   :: Integer AS LineNumTaxCorr_calc
                       , 0   :: Integer AS LineNumTaxCorr
                       , 0   :: TFloat  AS AmountTax_calc
                  FROM tmpMI_Tax AS tmp
               UNION 
                  SELECT tmp.MovementId
                       , 0 AS LineNum
                       , tmp.GoodsCode
                       , tmp.GoodsName
                       , tmp.GoodsKindName
                       , tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.AmountSumm
                       , (-1) * tmp.LineNumTax
                       , (-1) * tmp.LineNumTaxCorr_calc
                       , (-1) * tmp.LineNumTaxCorr
                       , (-1) * tmp.AmountTax_calc
                  FROM tmpMI_TaxCorrective AS tmp
                  )
    --- результат 
    SELECT MovementDesc.ItemName
         , Movement.InvNumber
         , Movement.OperDate
         , tmpData.GoodsCode
         , tmpData.GoodsName
         , tmpData.GoodsKindName

         , tmpData.LineNum             :: integer
         , tmpData.LineNumTax          :: integer
         , tmpData.LineNumTaxCorr_calc :: integer
         , tmpData.LineNumTaxCorr      :: integer
         , tmpData.Amount         :: TFloat
         , tmpData.Price          :: TFloat
         , tmpData.CountForPrice  :: TFloat
         , tmpData.AmountSumm     :: TFloat
         , tmpData.AmountTax_calc :: TFloat
    FROM tmpData
         LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
         LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
    ORDER BY 1 DESC, tmpData.LineNum
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.18         *
*/

-- тест
-- SELECT * FROM Report_CheckTaxCorrective_NPP (inMovementId:= 5199861, inGoodsId:= 0, inSession:= zfCalc_UserAdmin());
