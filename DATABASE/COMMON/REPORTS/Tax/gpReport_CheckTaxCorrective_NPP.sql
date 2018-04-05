-- FunctiON: Report_CheckTaxCorrective_NPP ()

DROP FUNCTION IF EXISTS Report_CheckTaxCorrective_NPP (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckTaxCorrective_NPP (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckTaxCorrective_NPP (
    IN inMovementId          Integer   , -- № налоговой
    IN inGoodsId             Integer   , -- товар
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (ItemName TVarChar, InvNumber TVarChar, InvNumberPartner TVarChar, InvNumberPartner_Tax TVarChar
             , OperDate TDateTime
             , OperDate_Tax TDateTime
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
             , AmountSumm_original  TFloat
             , SummTaxDiff_calc     TFloat
             , AmountTax_calc  TFloat
             , AmountTax       TFloat
             , isAmountTax     Boolean
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
     -- сначала выбираем все товары из Налоговых и корректировок, чтоб сделать Расчетный № п/п
    , tmpMI_Tax AS (SELECT MovementItem.MovementId                AS MovementId
                         , MovementItem.Id                        AS MovementItemId
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
                --AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
           )

    , tmpMI_TaxCorrective AS (SELECT MovementItem.MovementId
                                   , tmpMovement.MovementId_Tax
                                   , MovementItem.Id                                           AS MovementItemId
                                   , COALESCE (MovementBoolean_NPP_calc.ValueData, FALSE) ::Boolean AS isNPP_calc
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
                                   , COALESCE (MIFloat_SummTaxDiff_calc.ValueData, 0) :: TFloat AS SummTaxDiff_calc
                                             
                              FROM (SELECT MLM_DocumentChild.MovementId                    --корр.
                                         , MLM_DocumentChild.MovementChildId  AS MovementId_Tax
                                    FROM MovementLinkMovement AS MLM_DocumentChild
                                         INNER JOIN Movement ON Movement.Id = MLM_DocumentChild.MovementId
                                                            AND Movement.DescId = zc_Movement_TaxCorrective()
                                                            AND Movement.StatusId = zc_Enum_Status_Complete()
                                    WHERE MLM_DocumentChild.MovementChildId = inMovementId -- НН
                                      AND MLM_DocumentChild.DescId = zc_MovementLinkMovement_Child()
                                    ) AS tmpMovement 
                                   -- 
                                   LEFT JOIN MovementBoolean AS MovementBoolean_NPP_calc
                                                             ON MovementBoolean_NPP_calc.MovementId = tmpMovement.MovementId
                                                            AND MovementBoolean_NPP_calc.DescId = zc_MovementBoolean_NPP_calc()

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
                                   LEFT JOIN MovementItemFloat AS MIFloat_SummTaxDiff_calc
                                                               ON MIFloat_SummTaxDiff_calc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_SummTaxDiff_calc.DescId = zc_MIFloat_SummTaxDiff_calc()

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
                              )

    -- данные НН и корректировок                           
    , tmpData_All AS (SELECT tmp.MovementId
                       , tmp.MovementId AS MovementId_Tax
                       , tmp.MovementItemId
                       , tmp.LineNum
                       , tmp.GoodsId
                       , tmp.GoodsCode
                       , tmp.GoodsName
                       , tmp.GoodsKindId
                       , tmp.GoodsKindName
                       , tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.AmountSumm
                       , tmp.AmountSumm AS AmountSumm_original
                       , 0   :: TFloat  AS SummTaxDiff_calc
                       , 0   :: Integer AS LineNumTaxCorr_calc
                       , tmp.LineNum    AS LineNumTax
                       , 0   :: TFloat  AS AmountTax_calc
                       , TRUE           AS isNPP_calc
                  FROM tmpMI_Tax AS tmp
               UNION 
                  SELECT tmp.MovementId
                       , tmp.MovementId_Tax
                       , tmp.MovementItemId
                       , tmp.LineNumTaxCorr AS LineNum
                       , tmp.GoodsId
                       , tmp.GoodsCode
                       , tmp.GoodsName
                       , tmp.GoodsKindId
                       , tmp.GoodsKindName
                       , (-1) * tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , (-1) * (tmp.AmountSumm + tmp.SummTaxDiff_calc) AS AmountSumm
                       , (-1) * tmp.AmountSumm AS AmountSumm_original
                       , (-1) * tmp.SummTaxDiff_calc
                       , tmp.LineNumTaxCorr_calc
                       , tmp.LineNumTax
                       , tmp.AmountTax_calc
                       , tmp.isNPP_calc
                  FROM tmpMI_TaxCorrective AS tmp
                  )
    -- перенумеруем 
    , tmpDataAll_ord AS (SELECT tmp.MovementId
                       , tmp.MovementId_Tax
                       , tmp.MovementItemId
                       , tmp.isNPP_calc
                       , tmp.LineNum
                       , tmp.GoodsId
                       , tmp.GoodsCode
                       , tmp.GoodsName
                       , tmp.GoodsKindId
                       , tmp.GoodsKindName
                       , tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.AmountSumm
                       , tmp.AmountSumm_original
                       , tmp.SummTaxDiff_calc
                       , tmp.LineNumTaxCorr_calc
                       , tmp.LineNumTax
                       , tmp.AmountTax_calc
                       , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price ORDER BY tmp.MovementId, tmp.LineNum, tmp.LineNumTaxCorr_calc)  :: integer AS Ord_calc

                 FROM tmpData_All AS tmp
                 )

    -- получаем расчетное значение AmountTax_calc
    , tmpData_Summ AS (SELECT tmp1.MovementId
                       , tmp1.MovementId_Tax
                       , tmp1.MovementItemId
                       , tmp1.isNPP_calc
                       , tmp1.LineNum
                       , tmp1.GoodsId
                       , tmp1.GoodsCode
                       , tmp1.GoodsName
                       , tmp1.GoodsKindId
                       , tmp1.GoodsKindName
                       , tmp1.Amount
                       , tmp1.Price
                       , tmp1.CountForPrice
                       , tmp1.AmountSumm
                       , tmp1.AmountSumm_original
                       , tmp1.SummTaxDiff_calc
                       , tmp1.LineNumTaxCorr_calc
                       , tmp1.LineNumTax
                       , tmp1.AmountTax_calc
                       , SUM (COALESCE (tmp2.Amount, 0)) AS AmountTax
                 FROM tmpDataAll_ord AS tmp1
                      LEFT JOIN tmpDataAll_ord AS tmp2 ON tmp2.GoodsId     = tmp1.GoodsId
                                                   AND (tmp2.GoodsKindId = tmp1.GoodsKindId OR COALESCE (tmp1.GoodsKindId,0) = 0)
                                                   AND tmp2.Price       = tmp1.Price
                                                   AND tmp2.Ord_calc    < tmp1.Ord_calc
                 GROUP BY tmp1.MovementId
                        , tmp1.MovementId_Tax
                        , tmp1.MovementItemId
                        , tmp1.LineNum
                        , tmp1.GoodsId
                        , tmp1.GoodsCode
                        , tmp1.GoodsName
                        , tmp1.GoodsKindId
                        , tmp1.GoodsKindName
                        , tmp1.Amount
                        , tmp1.Price
                        , tmp1.CountForPrice
                        , tmp1.AmountSumm
                        , tmp1.AmountSumm_original
                        , tmp1.SummTaxDiff_calc
                        , tmp1.LineNumTaxCorr_calc
                        , tmp1.LineNumTax
                        , tmp1.AmountTax_calc
                        , tmp1.isNPP_calc
                 )

    -- получаем расчетное значение № п/п
   , tmpData_Ord AS (SELECT tmp.MovementId
                       , tmp.MovementId_Tax
                       , tmp.MovementItemId
                       , tmp.isNPP_calc
                       , tmp.LineNum
                       , tmp.GoodsId
                       , tmp.GoodsCode
                       , tmp.GoodsName
                       , tmp.GoodsKindId
                       , tmp.GoodsKindName
                       , tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.AmountSumm
                       , tmp.AmountSumm_original
                       , tmp.SummTaxDiff_calc
                       , tmp.LineNumTaxCorr_calc
                       , tmp.LineNumTax
                       , tmp.AmountTax_calc
                       , tmp.AmountTax
                       , ROW_NUMBER() OVER (ORDER BY tmp.MovementId, tmp.LineNum, tmp.LineNumTaxCorr_calc)  :: integer AS LineNum_calc
                 FROM tmpData_Summ AS tmp
                 WHERE tmp.isNPP_calc = TRUE
                   AND (COALESCE (tmp.Amount, 0) + COALESCE (tmp.AmountTax, 0)) <> 0
                 )

  , tmpData AS (SELECT tmp.MovementId
                       , tmp.MovementId_Tax
                       , tmp.MovementItemId
                       , tmp.isNPP_calc
                       , tmp.LineNum
                       , tmp.GoodsId
                       , tmp.GoodsCode
                       , tmp.GoodsName
                       , tmp.GoodsKindId
                       , tmp.GoodsKindName
                       , tmp.Amount
                       , tmp.Price
                       , tmp.CountForPrice
                       , tmp.AmountSumm
                       , tmp.AmountSumm_original
                       , tmp.SummTaxDiff_calc
                       , tmp.LineNumTaxCorr_calc
                       , tmp.LineNumTax
                       , tmp.AmountTax_calc
                       , tmp.AmountTax
                       , tmpData_Ord.LineNum_calc
                 FROM tmpData_Summ AS tmp
                      LEFT JOIN tmpData_Ord ON tmpData_Ord.MovementItemId = tmp.MovementItemId
                 )

    --- результат 
    SELECT MovementDesc.ItemName
         , Movement.InvNumber
         , MovementString_InvNumberPartner.ValueData     AS InvNumberPartner
         , MovementString_InvNumberPartner_Tax.ValueData AS InvNumberPartner_Tax
         , Movement.OperDate                             AS OperDate
         , Movement_Tax.OperDate                         AS OperDate_Tax
         , Object_To.ValueData  AS JuridicalName
         , tmpData.GoodsCode
         , tmpData.GoodsName
         , tmpData.GoodsKindName

         , tmpData.LineNum             :: integer                                         -- сквозная нумерация строк налоговой  и  корректировок (начиная с 31,03,18)
         , tmpData.LineNumTax          :: integer                                         -- № п/п из  налоговой который корректируется
         , COALESCE (tmpData.LineNumTaxCorr_calc, 0) :: integer AS LineNumTaxCorr_calc    -- № п/п строки которая корректируется
         , COALESCE (tmpData.LineNum_calc, 0)   :: integer AS LineNum_calc                -- расчетный № п/п
         , tmpData.Amount         :: TFloat
         , tmpData.Price          :: TFloat
         , tmpData.CountForPrice  :: TFloat
         , tmpData.AmountSumm     :: TFloat
         , tmpData.AmountSumm_original  :: TFloat
         , tmpData.SummTaxDiff_calc     :: TFloat
         , tmpData.AmountTax_calc :: TFloat
         , CASE WHEN tmpData.isNPP_calc = FALSE THEN 0 ELSE tmpData.AmountTax END  :: TFloat  AS AmountTax
         , CASE WHEN tmpData.isNPP_calc = TRUE AND COALESCE (tmpData.AmountTax_calc, 0) <> COALESCE (tmpData.AmountTax, 0) THEN TRUE ELSE FALSE END AS isAmountTax
    FROM tmpData
         LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
         LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
         LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = tmpData.MovementId_Tax
         
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

WHERE (tmpData.GoodsId = inGoodsId OR inGoodsId = 0)
    ORDER BY 1 DESC, tmpData.LineNum
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.04.18         *
 02.04.18         *
 30.03.18         *
*/

-- тест
-- SELECT * FROM gpReport_CheckTaxCorrective_NPP (inMovementId:= 5199861, inGoodsId:= 0, inSession:= zfCalc_UserAdmin());