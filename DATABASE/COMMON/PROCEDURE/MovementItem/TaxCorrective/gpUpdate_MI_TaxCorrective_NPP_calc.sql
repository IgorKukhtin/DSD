-- Function: gpUpdate_MI_TaxCorrective_NPP_calc (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP_calc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TaxCorrective_NPP_calc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbMovementId_tax Integer;
   DECLARE vbOperDate       TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());


     -- определяется <Налоговый документ> и его параметры
     SELECT Movement.OperDate
          , MovementLinkMovement_Child.MovementChildId AS MovementId_tax
            INTO vbOperDate, vbMovementId_tax
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                         ON MovementLinkMovement_Child.MovementId = Movement.Id
                                        AND MovementLinkMovement_Child.DescId     = zc_MovementLinkMovement_Child()
     WHERE Movement.Id = inMovementId
     ;


     WITH -- Все корректировки
          tmpMovement AS
             (SELECT MovementLinkMovement_Child.MovementId
              FROM MovementLinkMovement_Child
                   INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Child.MovementId
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                      AND Movement.OperDate <= vbOperDate
                   INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                 ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                                AND MovementLinkObject_DocumentTaxKind.ObjectId   IN (zc_Enum_DocumentTaxKind_Corrective()
                                                                                                    , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()
                                                                                                    , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                                                                                    , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()
                                                                                                    , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                                                                                     )
              WHERE MovementLinkMovement_Child.MovementChildId = vbMovementId_tax
                AND MovementLinkMovement_Child.DescId          = zc_MovementLinkMovement_Child()
             )
          -- ВСЕ корректировки (кроме текущей)
        , tmpMI_All AS
             (SELECT MovementItem.Id                             AS Id
                   , MovementItem.MovementId                     AS MovementId
                   , MovementItem.ObjectId                       AS GoodsId
                   , MovementItem.Amount                         AS Amount
              FROM tmpMovement
                   INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                                          AND MovementItem.Amount     <> 0
             )
          -- св-ва - оптимизация
        , tmpMIFloat AS
             (SELECT MovementItemFloat.*
              FROM MovementItemFloat
              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
             )
          -- св-ва - оптимизация
        , tmpGoodsKind AS
             (SELECT MovementItemLinkObject.*
              FROM MovementItemLinkObject
              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                AND MovementItemLinkObject.DescId        = zc_MILinkObject_GoodsKind()
             )
          -- ВСЕ корректировки (кроме текущей) + СВ-ВА
        , tmpMI_Corr_all AS
             (SELECT tmpMI_All.Id                                   AS Id
                   , tmpMI_All.MovementId                           AS MovementId
                   , tmpMI_All.GoodsId                              AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                   , tmpMI_All.Amount                               AS Amount
                   , COALESCE (MIFloat_Price.ValueData, 0)          AS Price
                   , COALESCE (MIFloat_AmountTax_calc.ValueData, 0) AS AmountTax_calc
                   , MIFloat_NPP_calc.ValueData                     AS NPP_calc
                     --  № п/п - Что б выбрать !!!ПОСЛЕДНЮЮ!!!
                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_All.GoodsId, MILinkObject_GoodsKind.ObjectId, MIFloat_Price.ValueData ORDER BY MIFloat_NPP_calc.ValueData DESC) AS Ord1
                     --  № п/п - Что б выбрать !!!ПОСЛЕДНЮЮ!!!
                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_All.GoodsId, MILinkObject_GoodsKind.ObjectId, MIFloat_Price.ValueData ORDER BY MIFloat_NPP_calc.ValueData DESC) AS Ord1
              FROM tmpMI_All
                   INNER JOIN tmpMIFloat AS MIFloat_NPP_calc
                                         ON MIFloat_NPP_calc.MovementItemId = tmpMI_All.Id
                                        AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                        AND MIFloat_NPP_calc.ValueData      > 0
                   LEFT JOIN tmpMIFloat AS MIFloat_AmountTax_calc
                                        ON MIFloat_AmountTax_calc.MovementItemId = tmpMI_All.Id
                                       AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                   LEFT JOIN tmpMIFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMI_All.Id
                                       AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                       -- AND MIFloat_Price.ValueData <> 0
                   LEFT JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                          ON MILinkObject_GoodsKind.MovementItemId = tmpMI_All.Id
                                         AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
             )
          -- ТЕКУЩАЯ ОДНА - корректировка
        , tmpMI_Corr_curr_all AS
             (SELECT MovementItem.Id                                AS Id
                   , MovementItem.MovementId                        AS MovementId
                   , MovementItem.ObjectId                          AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                   , MovementItem.Amount                            AS Amount
                   , COALESCE (MIFloat_Price.ValueData, 0)          AS Price
                   , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, TRUE) = TRUE THEN 0 ELSE COALESCE (MIFloat_NPP.ValueData, 0) END AS NPP
              FROM MovementItem
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                              -- AND MIFloat_Price.ValueData <> 0
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                               ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                              AND MIFloat_NPP.DescId         = zc_MIFloat_NPP()
                   LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                 ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                                AND MIBoolean_isAuto.DescId         = zc_MIBoolean_isAuto()
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
                AND MovementItem.Amount     <> 0
             )

         -- Строчная часть налоговой с № п/п
       , tmpMI_tax AS (SELECT * FROM lpSelect_TaxFromTaxCorrective (vbMovementId_tax))
          -- ТЕКУЩАЯ ОДНА - корректировка + № п/п из налоговой
        , tmpMI_Corr_curr AS
             (SELECT tmpMI_Corr_curr_all.Id
                   , tmpMI_Corr_curr_all.MovementId
                   , tmpMI_Corr_curr_all.GoodsId
                   , tmpMI_Corr_curr_all.GoodsKindId
                   , tmpMI_Corr_curr_all.Amount
                   , tmpMI_Corr_curr_all.Price
                   , COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find) AS AmountTax_calc
                   , CASE WHEN tmpMI_Corr_curr_all.NPP = 0 THEN COALESCE (tmpMI_tax1.LineNum, tmpMI_tax2.LineNum) ELSE tmpMI_Corr_curr_all.NPP END :: Integer AS NPP
                     --  № п/п - Что б увеличить счетчик на + 1
                   , ROW_NUMBER() OVER (ORDER BY CASE WHEN tmpMI_Corr_curr_all.NPP = 0 THEN COALESCE (tmpMI_tax1.LineNum, tmpMI_tax2.LineNum) ELSE tmpMI_Corr_curr_all.NPP END ASC) AS Ord
              FROM tmpMI_Corr_curr_all
                   -- номера строк в НН
                   LEFT JOIN tmpMI_tax AS tmpMI_tax1 ON tmpMI_tax1.Kind        = 1
                                                    AND tmpMI_tax1.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                    AND tmpMI_tax1.GoodsKindId = tmpMI_Corr_curr_all.GoodsKindId
                                                    AND tmpMI_tax1.Price       = tmpMI_Corr_curr_all.Price
       
                   LEFT JOIN tmpMI_tax AS tmpMI_tax2 ON tmpMI_tax2.Kind        = 2
                                                    AND tmpMI_tax2.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                    AND tmpMI_tax2.Price       = tmpMI_Corr_curr_all.Price
                                                    AND tmpMI_tax1.GoodsId     IS NULL
             )


     -- сохранили
     SELECT tmpMI_Corr_curr.Id AS MovementItemId
            -- № п/п в колонке 1/1строка - для колонки 7 с "минусом" 
          , AS NPPTax_calc
            -- № п/п в колонке 1/2строка - для колонки 7 с "плюсом" - формируется в Корректировке по правилу: № п/п + 1 
          , AS NPPTax_calc
            -- Кол-во для НН в колонке 7/1строка 
          , AS NPPTax_calc

     FROM tmpMI_Corr_curr
          LEFT tmpMI_Corr_all AS tmpMI_Corr_all1 ON tmpMI_Corr_all1.GoodsId     = tmpMI_Corr_curr.GoodsId
                                                AND tmpMI_Corr_all1.GoodsKindId = tmpMI_Corr_curr.GoodsKindId
                                                AND tmpMI_Corr_all1.Price       = tmpMI_Corr_curr.Price
          LEFT tmpMI_Corr_all AS tmpMI_Corr_all2 ON tmpMI_Corr_all2.GoodsId     = tmpMI_Corr_curr.GoodsId
                                                AND tmpMI_Corr_all2.Price       = tmpMI_Corr_curr.Price


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.12.15         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_TaxCorrective_NPP_calc
