-- Function: lpSelect_TaxFromTaxCorrective()

DROP FUNCTION IF EXISTS lpSelect_TaxFromTaxCorrective (Integer);

CREATE OR REPLACE FUNCTION lpSelect_TaxFromTaxCorrective(
    IN inMovementId          Integer    -- ���� ������� <��������> - ���������
)
RETURNS TABLE (MovementId  Integer
             , Kind        Integer
             , GoodsId     Integer
             , GoodsKindId Integer
             , GoodsKindId_exists Integer
             , Price       TFloat
             , LineNum     Integer
              )
AS
$BODY$
BEGIN
    RETURN QUERY
    WITH 
     tmpMITax AS (SELECT MovementItem.ObjectId                                          AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                  AS GoodsKindId
                       , MIFloat_Price.ValueData                                        AS Price
                       , COALESCE (MIFloat_NPP.ValueData, 0)                 :: Integer AS LineNum
                       , COUNT(*) OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0), MIFloat_Price.ValueData) AS LineCount1
                       , COUNT(*) OVER (PARTITION BY MovementItem.ObjectId, MIFloat_Price.ValueData)                                                AS LineCount2
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
                  WHERE MovementItem.MovementId  = inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  )

                  -- ���������
                  SELECT inMovementId AS MovementId
                       , 1 :: Integer AS Kind
                       , tmp.GoodsId, tmp.GoodsKindId, tmp.GoodsKindId, tmp.Price
                       , (CASE WHEN tmp.LineCount1 <> 1 THEN -1 ELSE 1 END * tmp.LineNum) :: Integer AS LineNum
                  FROM (SELECT tmpMITax.*
                             , ROW_NUMBER() OVER (PARTITION BY tmpMITax.GoodsId, tmpMITax.GoodsKindId, tmpMITax.Price ORDER BY tmpMITax.LineNum ASC) AS Ord
                        FROM tmpMITax
                       ) AS tmp
                  WHERE tmp.Ord = 1
                 UNION ALL
                  SELECT inMovementId AS MovementId
                       , 2 :: Integer AS Kind
                       , tmp.GoodsId, 0 AS GoodsKindId, tmp.GoodsKindId, tmp.Price
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
28.03.16                                         * ALL
26.03.16          *
*/

-- ����
-- SELECT * FROM lpSelect_TaxFromTaxCorrective (inMovementId:= 171760)
