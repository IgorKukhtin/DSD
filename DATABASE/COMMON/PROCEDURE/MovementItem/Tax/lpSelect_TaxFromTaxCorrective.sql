-- Function: lpSelect_TaxFromTaxCorrective()

DROP FUNCTION IF EXISTS lpSelect_TaxFromTaxCorrective (Integer);

CREATE OR REPLACE FUNCTION lpSelect_TaxFromTaxCorrective(
    IN inMovementId          Integer    -- Ключ объекта <Документ> - Налоговая
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
     tmpMITax AS (SELECT MovementItem.ObjectId                                          AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                  AS GoodsKindId
                       , MovementItem.Amount                                            AS Amount_Tax_find
                       , COALESCE (MIFloat_Price.ValueData, 0)               :: TFloat  AS Price
                       , COALESCE (MIFloat_NPP.ValueData, 0)                 :: Integer AS LineNum
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
-- SELECT * FROM lpSelect_TaxFromTaxCorrective (inMovementId:= 171760)
