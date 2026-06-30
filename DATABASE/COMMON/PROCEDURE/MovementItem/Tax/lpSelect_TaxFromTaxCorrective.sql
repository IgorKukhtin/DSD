-- Function: lpSelect_TaxFromTaxCorrective()

DROP FUNCTION IF EXISTS lpSelect_TaxFromTaxCorrective (Integer);
DROP FUNCTION IF EXISTS lpSelect_TaxFromTaxCorrective (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lpSelect_TaxFromTaxCorrective(
    IN inMovementId             Integer,    -- Ключ объекта <Документ> - Налоговая
    IN inOperDate_TaxCorrective TDateTime
)
RETURNS TABLE (MovementId         Integer
             , Kind               Integer
             , GoodsId            Integer
             , GoodsKindId        Integer
             , GoodsKindId_exists Integer
             , Amount_Tax_find    TFloat
             , Price              TFloat
             , LineNum            Integer
             , GoodsName_its      TVarChar
              )
AS
$BODY$
BEGIN

    
    RETURN QUERY
    WITH 
     -- Найдем корректировку цены
     tmpMICorrectivePrice AS (SELECT MovementItem.ObjectId                                          AS GoodsId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                  AS GoodsKindId
                                   , 1 * (COALESCE (MIFloat_PriceTax_calc.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0)) AS Price
                                   , COALESCE (MIFloat_NPP_calc.ValueData, 0)            :: Integer AS LineNum_calc
                                     -- № п/п
                                   , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) ORDER BY Movement.OperDate DESC) AS Ord
                              FROM Movement
                                   INNER JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                                   ON MovementLinkMovement_Child.MovementId      = Movement.Id
                                                                  AND MovementLinkMovement_Child.DescId          = zc_MovementLinkMovement_Child()
                                                                  AND MovementLinkMovement_Child.MovementChildId = inMovementId
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                                 ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                                AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                                                AND MovementLinkObject_DocumentTaxKind.ObjectId   IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                                                     )
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                   LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                                               ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_PriceTax_calc.DescId         = zc_MIFloat_PriceTax_calc()
                                   LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                               ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                              AND MIFloat_NPP_calc.DescId       = zc_MIFloat_NPP_calc()
                              WHERE Movement.OperDate <= inOperDate_TaxCorrective
                                AND Movement.DescId   = zc_Movement_TaxCorrective()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                             )

   , tmpMITax AS (SELECT MovementItem.ObjectId                                             AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                     AS GoodsKindId
                       , MovementItem.Amount                                               AS Amount_Tax_find
                       , COALESCE (tmpMICorrectivePrice.Price, MIFloat_Price.ValueData, 0)      :: TFloat  AS Price
                       , COALESCE (tmpMICorrectivePrice.LineNum_calc, MIFloat_NPP.ValueData, 0) :: Integer AS LineNum
                       , COUNT(*) OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0), MIFloat_Price.ValueData) AS LineCount1
                       , COUNT(*) OVER (PARTITION BY MovementItem.ObjectId, MIFloat_Price.ValueData)                                                AS LineCount2
                       , MIString_GoodsName.ValueData                        ::TVarChar AS GoodsName_its
                  FROM MovementItem
                       LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()
                       LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                                   ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                                  AND MIFloat_NPP.DescId = zc_MIFloat_NPP()

                       LEFT JOIN MovementItemString AS MIString_GoodsName
                                                    ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                                   AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
                       LEFT JOIN tmpMICorrectivePrice ON tmpMICorrectivePrice.GoodsId     = MovementItem.ObjectId
                                                     AND tmpMICorrectivePrice.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                     AND tmpMICorrectivePrice.Ord         = 1
                  WHERE MovementItem.MovementId  = inMovementId
                    AND MovementItem.DescId      = zc_MI_Master()
                    AND MovementItem.isErased    = FALSE
                  )

                  -- результат
                  SELECT inMovementId AS MovementId
                       , 1 :: Integer AS Kind
                       , tmp.GoodsId, tmp.GoodsKindId, tmp.GoodsKindId, tmp.Amount_Tax_find, tmp.Price
                       , (CASE WHEN tmp.LineCount1 <> 1 THEN -1 ELSE 1 END * tmp.LineNum) :: Integer AS LineNum
                       , tmp.GoodsName_its ::TVarChar
                  FROM (SELECT tmpMITax.*
                             , ROW_NUMBER() OVER (PARTITION BY tmpMITax.GoodsId, tmpMITax.GoodsKindId, tmpMITax.Price ORDER BY tmpMITax.LineNum ASC) AS Ord
                        FROM tmpMITax
                       ) AS tmp
                  WHERE tmp.Ord = 1
                 UNION ALL
                  SELECT inMovementId AS MovementId
                       , 2 :: Integer AS Kind
                       , tmp.GoodsId, 0 AS GoodsKindId, tmp.GoodsKindId, tmp.Amount_Tax_find, tmp.Price
                       , (CASE WHEN tmp.LineCount2 <> 1 THEN -1 ELSE 1 END * tmp.LineNum) :: Integer AS LineNum
                       , tmp.GoodsName_its ::TVarChar
                  FROM (SELECT tmpMITax.*
                             , ROW_NUMBER() OVER (PARTITION BY tmpMITax.GoodsId, tmpMITax.Price ORDER BY tmpMITax.LineNum ASC) AS Ord
                        FROM tmpMITax
                       ) AS tmp
                  WHERE tmp.Ord = 1
                 ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
12.06.24          * GoodsName_its
28.03.16                                         * ALL
26.03.16          *
*/

-- тест
-- SELECT * FROM lpSelect_TaxFromTaxCorrective (inMovementId:= 34437819, inOperDate_TaxCorrective:= '01.06.2026')
