-- Function: lpSelect_TaxFromTaxCorrectiveReport()

DROP FUNCTION IF EXISTS lpSelect_TaxFromTaxCorrectiveReport (TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpSelect_TaxFromTaxCorrectiveReport(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inGoodsId        Integer     -- 
)
RETURNS TABLE (TaxCorrectiveId Integer
             , Kind        Integer
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
     tmpList AS (SELECT DISTINCT
                        MovementLinkMovement_Child.MovementChildId AS TaxId
                      , Movement.Id                                AS TaxCorrectiveId
                 FROM MovementItem
                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                      AND Movement.OperDate BETWEEN inStartDate and inEndDate
                                      AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                      AND Movement.DescId = zc_Movement_TaxCorrective()
                   INNER JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                   ON MovementLinkMovement_Child.MovementId = Movement.Id
                                                  AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
                 WHERE MovementItem.ObjectId = inGoodsId
                   AND MovementItem.isErased   = FALSE
                 )
   , tmpListTax AS (SELECT DISTINCT tmpList.TaxId FROM tmpList)
                                 
   , tmpMITax AS (SELECT tmpListTax.TaxId
                       , MovementItem.ObjectId                                          AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                  AS GoodsKindId
                       , MIFloat_Price.ValueData                                        AS Price
                       , COALESCE (MIFloat_NPP.ValueData, 0)                 :: Integer AS LineNum
                       , COUNT(*) OVER (PARTITION BY tmpListTax.TaxId, MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0), MIFloat_Price.ValueData) AS LineCount1
                       , COUNT(*) OVER (PARTITION BY tmpListTax.TaxId, MovementItem.ObjectId, MIFloat_Price.ValueData)                                                AS LineCount2
                  FROM tmpListTax
                     LEFT JOIN Movement ON Movement.Id = tmpListTax.TaxId
                     LEFT JOIN MovementItem ON MovementItem.MovementId = tmpListTax.TaxId
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                     LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                                 ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                                AND MIFloat_NPP.DescId = zc_MIFloat_NPP()
                  )

     , tmpResult AS (SELECT 1 :: Integer AS Kind
                          , tmp.GoodsId, tmp.GoodsKindId, tmp.Price
                          , (CASE WHEN tmp.LineCount1 <> 1 THEN -1 ELSE 1 END * tmp.LineNum) :: Integer AS LineNum
                          , tmp.TaxId
                     FROM (SELECT tmpMITax.*
                                , ROW_NUMBER() OVER (PARTITION BY tmpMITax.TaxId, tmpMITax.GoodsId, tmpMITax.GoodsKindId, tmpMITax.Price ORDER BY tmpMITax.LineNum ASC) AS Ord
                           FROM tmpMITax
                           WHERE tmpMITax.GoodsId = inGoodsId
                           ) AS tmp
                     WHERE tmp.Ord = 1
                   UNION ALL
                     SELECT 2 :: Integer AS Kind
                          , tmp.GoodsId, 0 AS GoodsKindId, tmp.Price
                          , (CASE WHEN tmp.LineCount2 <> 1 THEN -1 ELSE 1 END * tmp.LineNum) :: Integer AS LineNum
                          , tmp.TaxId
                     FROM (SELECT tmpMITax.*
                                , ROW_NUMBER() OVER (PARTITION BY tmpMITax.TaxId, tmpMITax.GoodsId, tmpMITax.Price ORDER BY tmpMITax.LineNum ASC) AS Ord
                           FROM tmpMITax
                           WHERE tmpMITax.GoodsId = inGoodsId
                          ) AS tmp
                     WHERE tmp.Ord = 1
                     )
        -- ÂÁÛÎ¸Ú‡Ú
        SELECT tmpList.TaxCorrectiveId
             , tmpResult.Kind
             , tmpResult.GoodsId
             , tmpResult.GoodsKindId
             , tmpResult.Price
             , tmpResult.LineNum
        FROM tmpResult
             LEFT JOIN tmpList ON tmpList.TaxId = tmpResult.TaxId
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   Ã‡Ì¸ÍÓ ƒ.¿.
28.03.16          *
*/

-- ÚÂÒÚ
-- SELECT * FROM lpSelect_TaxFromTaxCorrectiveReport (inStartDate:= '01.08.2015' ,inEndDate:= '01.08.2015', inGoodsId:=7493)
