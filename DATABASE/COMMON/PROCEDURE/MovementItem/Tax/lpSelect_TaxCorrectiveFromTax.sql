-- Function: lpSelect_TaxCorrectiveFromTax()

DROP FUNCTION IF EXISTS lpSelect_TaxCorrectiveFromTax (Integer);

CREATE OR REPLACE FUNCTION lpSelect_TaxCorrectiveFromTax(
    IN inMovementId          Integer    -- Ключ объекта <Документ> - Корректировка
)
RETURNS TABLE (GoodsId     Integer
             , GoodsKindId Integer
             , Price       TFloat
             , MessageText Text
              )
AS
$BODY$
  DECLARE vbMovementId_tax Integer;
--  DECLARE vbOperDate_begin TDateTime;
BEGIN

    -- !!!Выход!!!
    IF EXISTS (SELECT 1
               FROM MovementLinkMovement AS MovementLinkMovement_Master
                    INNER JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                                  ON MovementLinkObject_CurrencyDocument.MovementId = MovementLinkMovement_Master.MovementChildId
                                                 AND MovementLinkObject_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
                                                 AND MovementLinkObject_CurrencyDocument.ObjectId   <> zc_Enum_Currency_Basis()
               WHERE MovementLinkMovement_Master.MovementId = inMovementId
                 AND MovementLinkMovement_Master.DescId     = zc_MovementLinkMovement_Master()
              )
    THEN
        RETURN;
    END IF;


    -- нашли налоговую
    vbMovementId_tax:= (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Child());
    -- определили дату, т.к. проверка нужна с 01.04.2016
    /*vbOperDate_begin:= (SELECT CASE WHEN MovementDate_DateRegistered.ValueData > Movement.OperDate THEN MovementDate_DateRegistered.ValueData ELSE Movement.OperDate END
                        FROM Movement
                             LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                                    ON MovementDate_DateRegistered.MovementId = Movement.Id
                                                   AND MovementDate_DateRegistered.DescId     = zc_MovementDate_DateRegistered()
                        WHERE Movement.Id = inMovementId
                       );*/

    -- !!!проверка нужна с 01.04.2016!!!
    IF /*vbOperDate_begin >= '01.04.2016' OR*/ 1 = 1
    THEN

    RETURN QUERY
    WITH -- документ - корректировка
         tmpMovement AS (SELECT MovementLinkObject_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                         FROM Movement
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                           ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                         WHERE Movement.Id = inMovementId
                        )
         -- Строчная часть налоговой с № п/п
       , tmpMITax AS (SELECT * FROM lpSelect_TaxFromTaxCorrective (vbMovementId_tax))
         -- Строчная часть корректировки
       , tmpMICorrective AS
                    (SELECT MovementItem.ObjectId                         AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                          , CASE WHEN MovementLinkObject_DocumentTaxKind.ObjectId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                    , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                    , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                                     )
                                 THEN COALESCE (MIFloat_PriceTax_calc.ValueData, 0) 
                                 ELSE COALESCE (MIFloat_Price.ValueData, 0)
                            END AS Price
                          , CASE WHEN MIBoolean_isAuto.ValueData = FALSE THEN COALESCE (MIFloat_NPP.ValueData, 0) ELSE 0 END AS LineNumTax
                          , COALESCE (MIBoolean_isAuto.ValueData, TRUE)   AS isAuto
                          , MovementLinkObject_DocumentTaxKind.ObjectId   AS DocumentTaxKindId
                     FROM MovementItem
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                                      ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PriceTax_calc.DescId        = zc_MIFloat_PriceTax_calc()
                                                     
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                                      ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                                     AND MIFloat_NPP.DescId = zc_MIFloat_NPP()
                          LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                        ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                                       AND MIBoolean_isAuto.DescId = zc_MIBoolean_isAuto()
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                       ON MovementLinkObject_DocumentTaxKind.MovementId = MovementItem.MovementId
                                                      AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                    )
         -- Строчная часть коррерктировки
       , tmpResult AS
                    (SELECT tmpMICorrective.GoodsId
                          , tmpMICorrective.GoodsKindId
                          , tmpMICorrective.Price

                          , CASE WHEN tmpMICorrective.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                          , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                          , zc_Enum_DocumentTaxKind_Goods()
                                                                          , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                                          , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                           )
                                  AND tmpMICorrective.LineNumTax <> 0 
                                      THEN tmpMICorrective.LineNumTax

                                 WHEN COALESCE (tmpMITax1.LineNum, COALESCE (tmpMITax2.LineNum, 0)) <> 0
                                  AND tmpMICorrective.LineNumTax <> 0
                                  AND isAuto = FALSE AND tmpMICorrective.LineNumTax = COALESCE (tmpMITax1.LineNum, COALESCE (tmpMITax2.LineNum, 0))
                                      THEN tmpMICorrective.LineNumTax

                                 -- т.е. будет ОШИБКА
                                 WHEN isAuto = FALSE
                                      THEN 0

                                 ELSE COALESCE (tmpMITax1.LineNum, COALESCE (tmpMITax2.LineNum, 0))

                            END AS LineNumTax

                     FROM tmpMICorrective
                          LEFT JOIN tmpMITax AS tmpMITax1 ON tmpMITax1.Kind        = 1
                                                         AND tmpMITax1.GoodsId     = tmpMICorrective.GoodsId
                                                         AND tmpMITax1.GoodsKindId = tmpMICorrective.GoodsKindId
                                                         AND tmpMITax1.Price       = tmpMICorrective.Price
                          LEFT JOIN tmpMITax AS tmpMITax2 ON tmpMITax2.Kind        = 2
                                                         AND tmpMITax2.GoodsId     = tmpMICorrective.GoodsId
                                                         AND tmpMITax2.Price       = tmpMICorrective.Price
                                                         AND tmpMITax1.GoodsId     IS NULL
                    )

           -- результат
           SELECT tmpResult.GoodsId
                , tmpResult.GoodsKindId
                , tmpResult.Price :: TFloat AS Price
               , ('Ошибка. Не определено значение <№ п/п НН>'
               || CASE WHEN tmpResult.LineNumTax < 0 THEN ' = <' || tmpResult.LineNumTax :: TvarChar|| '>' ELSE '' END
   || CHR (13) || 'Для товара <' || lfGet_Object_ValueData (tmpResult.GoodsId)|| '>'
               || CASE WHEN tmpResult.GoodsKindId > 0 THEN CHR (13) || 'вид <' || lfGet_Object_ValueData (tmpResult.GoodsKindId) || '>' ELSE '' END
   || CHR (13) || 'с ценой = <' || tmpResult.Price :: TVarChar || '>'
   || CHR (13) || 'Налоговая № <' || COALESCE (MovementString_InvNumberPartner_tax.ValueData, '') || '> от <' || COALESCE (DATE (Movement_tax.OperDate) :: TVarChar, '???') || '>'
   || CHR (13) || 'Корректировка № <' || COALESCE (MovementString_InvNumberPartner.ValueData, '') || '> от <' || COALESCE (DATE (Movement.OperDate) :: TVarChar, '???') || '> сформирована и'
   || CHR (13) || 'НЕ ПРОВЕДЕНА.'
                 ) :: Text AS MessageText
           FROM tmpResult
                LEFT JOIN Movement ON Movement.Id = inMovementId
                LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                         ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                        AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                LEFT JOIN Movement AS Movement_tax ON Movement_tax.Id = vbMovementId_tax
                LEFT JOIN MovementString AS MovementString_InvNumberPartner_tax
                                         ON MovementString_InvNumberPartner_tax.MovementId =  Movement_tax.Id
                                        AND MovementString_InvNumberPartner_tax.DescId = zc_MovementString_InvNumberPartner()
           WHERE tmpResult.LineNumTax <= 0
           LIMIT 1
          ;

     END IF; -- !!!проверка нужна с 01.04.2016!!!

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
30.03.16                                         *
*/

-- тест
-- SELECT * FROM lpSelect_TaxCorrectiveFromTax (inMovementId:= 16067441)
