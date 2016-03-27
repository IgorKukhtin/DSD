-- Function: gpInsertUpdate_MovementItem_Tax()

DROP FUNCTION IF EXISTS lpSelect_TaxFromTaxCorrective(integer);

CREATE OR REPLACE FUNCTION lpSelect_TaxFromTaxCorrective(
    IN inMovementId          Integer    -- Ключ объекта <Документ>
)
RETURNS TABLE (GoodsId Integer
             , Price TFloat
             , LineNum Integer
              )
AS
$BODY$
BEGIN
    RETURN QUERY
    WITH 
     tmpMITax AS (SELECT MovementItem.ObjectId                                          AS GoodsId
                       , MIFloat_Price.ValueData                                        AS Price
                       , CAST (row_number() OVER (ORDER BY Object_Goods.ValueData, Object_GoodsKind.ValueData) AS Integer) AS LineNum
                  FROM MovementItem 
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
                    AND MovementItem.isErased = False
                  )

                  SELECT  tmp.GoodsId, tmp.Price, tmp.LineNum
                  FROM (
                        SELECT *
                             , ROW_NUMBER()OVER(PARTITION BY tmpMITax.GoodsId, tmpMITax.Price Order By tmpMITax.GoodsId, tmpMITax.LineNum  DESC) AS Ord
                        FROM tmpMITax) AS tmp
                  WHERE tmp.Ord = 1
                  ORDER BY 1;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
26.03.16          *
*/

-- тест
-- SELECT * FROM lpSelect_TaxFromTaxCorrective (inMovementId:= 10)