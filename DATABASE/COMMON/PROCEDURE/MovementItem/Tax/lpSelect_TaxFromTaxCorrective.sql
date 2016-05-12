-- Function: lpSelect_TaxFromTaxCorrective()

DROP FUNCTION IF EXISTS lpSelect_TaxFromTaxCorrective (Integer);

CREATE OR REPLACE FUNCTION lpSelect_TaxFromTaxCorrective(
    IN inMovementId          Integer    -- Ключ объекта <Документ> - Налоговая
)
RETURNS TABLE (Kind        Integer
             , GoodsId     Integer
             , GoodsKindId Integer
             , Price       TFloat
             , LineNum     Integer
              )
AS
$BODY$
BEGIN
    RETURN QUERY
    WITH 
     tmpMITax AS (SELECT MovementItem.ObjectId                                          AS GoodsId
                       , MILinkObject_GoodsKind.ObjectId                                AS GoodsKindId
                       , MIFloat_Price.ValueData                                        AS Price
                       , CASE WHEN Movement.OperDate < '01.03.2016' AND 1=1
                                   THEN ROW_NUMBER() OVER (ORDER BY MovementItem.Id)
                              ELSE ROW_NUMBER() OVER (ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData, MovementItem.Id)
                         END :: Integer AS LineNum
                       , COUNT(*) OVER (PARTITION BY Object_Goods.Id, Object_GoodsKind.Id, MIFloat_Price.ValueData)        AS LineCount1
                       , COUNT(*) OVER (PARTITION BY Object_Goods.Id, MIFloat_Price.ValueData)                             AS LineCount2
                  FROM MovementItem
                     LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                  WHERE MovementItem.MovementId  = inMovementId--2637258  --inMovementId  Налоговой
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  )

                  -- результат
                  SELECT 1 :: Integer AS Kind
                       , tmp.GoodsId, tmp.GoodsKindId, tmp.Price
                       , (CASE WHEN tmp.LineCount1 <> 1 THEN -1 ELSE 1 END * tmp.LineNum) :: Integer AS LineNum
                  FROM (SELECT tmpMITax.*
                             , ROW_NUMBER() OVER (PARTITION BY tmpMITax.GoodsId, tmpMITax.GoodsKindId, tmpMITax.Price ORDER BY tmpMITax.LineNum ASC) AS Ord
                        FROM tmpMITax
                       ) AS tmp
                  WHERE tmp.Ord = 1
                 UNION ALL
                  SELECT 2 :: Integer AS Kind
                       , tmp.GoodsId, 0 AS GoodsKindId, tmp.Price
                       , (CASE WHEN tmp.LineCount2 <> 1 THEN -1 ELSE 1 END * tmp.LineNum) :: Integer AS LineNum
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
28.03.16                                         * ALL
26.03.16          *
*/

-- тест
-- SELECT * FROM lpSelect_TaxFromTaxCorrective (inMovementId:= 171760)
