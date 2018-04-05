-- Function: gpUpdate_MI_TaxCorrective_NPP_calc (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP_calc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TaxCorrective_NPP_calc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementItemId   Integer
             , GoodsId          Integer
             , GoodsKindId      Integer
             , NPPTax_calc      Integer
             , NPP_calc         Integer
             , AmountTax_calc   TFloat
             , SummTaxDiff_calc TFloat
             , Amount           TFloat
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbMovementId_tax Integer;
   DECLARE vbOperDate       TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());


     -- !!!Проверка - Можно ли МЕНЯТЬ!!!
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                  ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                 AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                                 AND MIFloat_NPP_calc.ValueData < 0
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.Amount     <> 0
               )
     THEN
         RAISE EXCEPTION 'Ошибка.В корректировке уже сформированы данные <№ п/п в колонке 1/2строка - для колонки 7 с "плюсом" - формируется в Корректировке по правилу: № п/п + 1>';
     END IF;
     -- !!!Проверка - Можно ли МЕНЯТЬ!!!
     IF NOT EXISTS (SELECT 1
                    FROM MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                    WHERE MovementLinkObject_DocumentTaxKind.MovementId = inMovementId
                      AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                      AND MovementLinkObject_DocumentTaxKind.ObjectId   IN (zc_Enum_DocumentTaxKind_Corrective()
                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()
                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()
                                                                          , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                                                           )
                   )
     THEN
         RAISE EXCEPTION 'Ошибка.Для документа <%> выбранная функция не предусмотрена.'
                       , lfGet_Object_ValueData_sh ((SELECT MovementLinkObject_DocumentTaxKind.ObjectId
                                                     FROM MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                     WHERE MovementLinkObject_DocumentTaxKind.MovementId = inMovementId
                                                       AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                                   ));
     END IF;


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


     -- таблица - Список
     CREATE TEMP TABLE _tmpRes (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, NPPTax_calc Integer, NPP_calc Integer, AmountTax_calc TFloat, SummTaxDiff_calc TFloat, Amount TFloat) ON COMMIT DROP;


     WITH -- Все корректировки
          tmpMovement AS
             (SELECT MovementLinkMovement_Child.MovementId
              FROM MovementLinkMovement AS MovementLinkMovement_Child
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
                AND MovementLinkMovement_Child.MovementId      <> inMovementId
             )
          -- ВСЕ корректировки (кроме текущей)
        , tmpMI_All AS
             (SELECT MovementItem.Id                             AS Id
                   , MovementItem.MovementId                     AS MovementId
                   , MovementItem.ObjectId                       AS GoodsId
                   , MovementItem.Amount                         AS Amount
              FROM tmpMovement
                   INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
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
                   , COALESCE (MIFloat_NPP_calc.ValueData, 0)       AS NPP_calc
                     --  Сумма - для Итого
                   , CAST (tmpMI_All.Amount * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2)) + COALESCE (MIFloat_SummTaxDiff_calc.ValueData, 0) AS AmountSumm
                     --  № п/п - Что б выбрать !!!ПОСЛЕДНЮЮ!!!
                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_All.GoodsId, MILinkObject_GoodsKind.ObjectId, MIFloat_Price.ValueData ORDER BY COALESCE (MIFloat_NPP_calc.ValueData, 1) DESC, tmpMI_All.Id DESC) AS Ord1
                     --  № п/п - Что б выбрать !!!ПОСЛЕДНЮЮ!!!
                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_All.GoodsId, MILinkObject_GoodsKind.ObjectId, MIFloat_Price.ValueData ORDER BY COALESCE (MIFloat_NPP_calc.ValueData, 1) DESC, tmpMI_All.Id DESC) AS Ord2
              FROM tmpMI_All
                   LEFT JOIN tmpMIFloat AS MIFloat_NPP_calc
                                        ON MIFloat_NPP_calc.MovementItemId = tmpMI_All.Id
                                       AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                       AND MIFloat_NPP_calc.ValueData      > 0
                   LEFT JOIN tmpMIFloat AS MIFloat_AmountTax_calc
                                        ON MIFloat_AmountTax_calc.MovementItemId = tmpMI_All.Id
                                       AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                   LEFT JOIN tmpMIFloat AS MIFloat_SummTaxDiff_calc
                                        ON MIFloat_SummTaxDiff_calc.MovementItemId = tmpMI_All.Id
                                       AND MIFloat_SummTaxDiff_calc.DescId         = zc_MIFloat_SummTaxDiff_calc()
                   LEFT JOIN tmpMIFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMI_All.Id
                                       AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                       -- AND MIFloat_Price.ValueData <> 0
                   LEFT JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                          ON MILinkObject_GoodsKind.MovementItemId = tmpMI_All.Id
                                         AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
             )
          -- SUMMA
        , tmpMI_Corr_sum_1 AS
             (SELECT tmpMI_Corr_all.GoodsId
                   , tmpMI_Corr_all.GoodsKindId
                   , tmpMI_Corr_all.Price
                   , SUM (CASE WHEN tmpMI_Corr_all.NPP_calc = 0 THEN tmpMI_Corr_all.Amount ELSE 0 END) AS Amount
                   , SUM (tmpMI_Corr_all.Amount)     AS Amount_all
                   , SUM (tmpMI_Corr_all.AmountSumm) AS AmountSumm
              FROM tmpMI_Corr_all
              GROUP BY tmpMI_Corr_all.GoodsId
                     , tmpMI_Corr_all.GoodsKindId
                     , tmpMI_Corr_all.Price
             )
        , tmpMI_Corr_sum_2 AS
             (SELECT tmpMI_Corr_all.GoodsId
                   , tmpMI_Corr_all.Price
                   , SUM (CASE WHEN tmpMI_Corr_all.NPP_calc = 0 THEN tmpMI_Corr_all.Amount ELSE 0 END) AS Amount
                   , SUM (tmpMI_Corr_all.Amount)     AS Amount_all
                   , SUM (tmpMI_Corr_all.AmountSumm) AS AmountSumm
              FROM tmpMI_Corr_all
              GROUP BY tmpMI_Corr_all.GoodsId
                     , tmpMI_Corr_all.Price
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
                     -- Кол-во из налог. за минусом "предыдущих" корр. (т.е. без "схемы")
                   , COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find) - COALESCE (tmpMI_Corr_sum_1.Amount, tmpMI_Corr_sum_2.Amount, 0) AS AmountTax_calc
                     -- Сумма DIFF - из налог. за минусом ...
                   , CAST (COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find) * COALESCE (tmpMI_tax1.Price, tmpMI_tax2.Price) AS NUMERIC (16, 2))
                           -- минус "предыдущие" корр. (ВСЕ)
                         - COALESCE (tmpMI_Corr_sum_1.AmountSumm, tmpMI_Corr_sum_2.AmountSumm, 0)
                     AS SummTaxDiff_calc
                     -- № п/п из налог. ИЛИ текущий
                   , CASE WHEN tmpMI_Corr_curr_all.NPP = 0 THEN COALESCE (tmpMI_tax1.LineNum, tmpMI_tax2.LineNum) ELSE tmpMI_Corr_curr_all.NPP END :: Integer AS NPP
                     -- № п/п внутренний для ЗАПРОСА с 1... и до... - Что б увеличить счетчик на + 1
                   , ROW_NUMBER() OVER (ORDER BY CASE WHEN COALESCE (tmpMI_Corr_sum_1.Amount_all, tmpMI_Corr_sum_1.Amount_all, 0) + tmpMI_Corr_curr_all.Amount
                                                         = COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find, 0)
                                                           THEN 12345678
                                                      WHEN tmpMI_Corr_curr_all.NPP = 0 THEN COALESCE (tmpMI_tax1.LineNum, tmpMI_tax2.LineNum, 0)
                                                      ELSE tmpMI_Corr_curr_all.NPP END ASC
                                       ) AS Ord
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
                   -- итоги в корр
                   LEFT JOIN tmpMI_Corr_sum_1 ON tmpMI_Corr_sum_1.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                             AND tmpMI_Corr_sum_1.GoodsKindId = tmpMI_Corr_curr_all.GoodsKindId
                                             AND tmpMI_Corr_sum_1.Price       = tmpMI_Corr_curr_all.Price
                   LEFT JOIN tmpMI_Corr_sum_2 ON tmpMI_Corr_sum_2.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                             AND tmpMI_Corr_sum_2.Price       = tmpMI_Corr_curr_all.Price
                                             -- !!!обязательно!!! - если и в налоговой НЕТ GoodsKindId
                                             AND tmpMI_tax1.GoodsId           IS NULL
             )
          -- Результат
        , tmpMI_Data AS
             (SELECT tmpMI_Corr_curr.Id AS MovementItemId
                   , tmpMI_Corr_curr.GoodsId
                   , tmpMI_Corr_curr.GoodsKindId
                     -- № п/п в колонке 1/1строка - для колонки 7 с "минусом"
                   , COALESCE (tmpMI_Corr_all1.NPP_calc  -- № п/п в последней корр
                             , tmpMI_Corr_all2.NPP_calc  -- № п/п в последней корр - БЕЗ GoodsKindId
                             , tmpMI_Corr_curr.NPP       -- № п/п в налоговой
                              ) :: Integer AS NPPTax_calc
                     -- Кол-во для НН в колонке 7/1строка
                   , COALESCE (tmpMI_Corr_all1.AmountTax_calc - tmpMI_Corr_all1.Amount  -- кол-во в последней корр МИНУС какая там корр.
                             , tmpMI_Corr_all2.AmountTax_calc - tmpMI_Corr_all2.Amount  -- кол-во в последней корр МИНУС какая там корр. - БЕЗ GoodsKindId
                             , tmpMI_Corr_curr.AmountTax_calc                           -- кол-во в налоговой
                              ) :: TFloat AS AmountTax_calc
                     -- Сумма DIFF для НН в колонке 13/1строка - из налог. за минусом ...
                   , tmpMI_Corr_curr.SummTaxDiff_calc
                   - CAST (COALESCE (tmpMI_Corr_all1.AmountTax_calc - tmpMI_Corr_all1.Amount  -- кол-во в последней корр МИНУС какая там корр.
                                   , tmpMI_Corr_all2.AmountTax_calc - tmpMI_Corr_all2.Amount  -- кол-во в последней корр МИНУС какая там корр. - БЕЗ GoodsKindId
                                   , tmpMI_Corr_curr.AmountTax_calc                           -- кол-во в налоговой
                                    )
                         * tmpMI_Corr_curr.Price AS NUMERIC (16, 2))
                     AS SummTaxDiff_calc

                     -- № п/п в ТЕКУЩЕЙ корректировка - Что б увеличить счетчик на + 1
                   , tmpMI_Corr_curr.Ord
                     -- Кол-во в ТЕКУЩЕЙ корректировка
                   , tmpMI_Corr_curr.Amount

              FROM tmpMI_Corr_curr
                   LEFT JOIN tmpMI_Corr_all AS tmpMI_Corr_all1 ON tmpMI_Corr_all1.GoodsId     = tmpMI_Corr_curr.GoodsId
                                                              AND tmpMI_Corr_all1.GoodsKindId = tmpMI_Corr_curr.GoodsKindId
                                                              AND tmpMI_Corr_all1.Price       = tmpMI_Corr_curr.Price
                                                              AND tmpMI_Corr_all1.Ord1        = 1 -- т.е. по всем св-вам
                                                              AND tmpMI_Corr_all1.NPP_calc    > 0
                   LEFT JOIN tmpMI_Corr_all AS tmpMI_Corr_all2 ON tmpMI_Corr_all2.GoodsId     = tmpMI_Corr_curr.GoodsId
                                                              AND tmpMI_Corr_all2.Price       = tmpMI_Corr_curr.Price
                                                              AND tmpMI_Corr_all2.Ord2        = 2 -- т.е. по св-вам БЕЗ GoodsKindId
                                                              AND tmpMI_Corr_all2.NPP_calc    > 0
             )
     -- сохранили
     INSERT INTO _tmpRes (MovementItemId, GoodsId, GoodsKindId, NPPTax_calc, NPP_calc, AmountTax_calc, SummTaxDiff_calc, Amount)
       SELECT tmpMI_Data.MovementItemId
            , tmpMI_Data.GoodsId
            , tmpMI_Data.GoodsKindId
              -- № п/п в колонке 1/1строка - для колонки 7 с "минусом"
            , tmpMI_Data.NPPTax_calc
              -- № п/п в колонке 1/2строка - для колонки 7 с "плюсом" - формируется в Корректировке по правилу: № п/п + 1
            , (COALESCE ((SELECT MAX (tmp.NPP)
                          FROM (SELECT MAX (tmpMI_Data.NPPTax_calc)  AS NPP FROM tmpMI_Data
                               UNION ALL
                                SELECT MAX (tmpMI_tax.LineNum)       AS NPP FROM tmpMI_tax
                               UNION ALL
                                SELECT MAX (tmpMI_Corr_all.NPP_calc) AS NPP FROM tmpMI_Corr_all
                               ) AS tmp
                         ), 0)
             + tmpMI_Data.Ord -- № п/п - Что б увеличить счетчик на + 1
              ) :: Integer AS NPP_calc
              -- Кол-во для НН в колонке 7/1строка
            , tmpMI_Data.AmountTax_calc
              -- Сумма DIFF для НН в колонке 13/1строка - !!!всегда!!!
              -- , CASE WHEN tmpMI_Data.AmountTax_calc = tmpMI_Data.Amount THEN tmpMI_Data.SummTaxDiff_calc ELSE 0 END AS SummTaxDiff_calc
            , tmpMI_Data.SummTaxDiff_calc
              -- Кол-во в ТЕКУЩЕЙ корректировка
            , tmpMI_Data.Amount

       FROM tmpMI_Data;


     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(),      _tmpRes.MovementItemId, _tmpRes.NPPTax_calc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(),   _tmpRes.MovementItemId, _tmpRes.AmountTax_calc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTaxDiff_calc(), _tmpRes.MovementItemId, _tmpRes.SummTaxDiff_calc)
             -- !!!важно - сохранили ТОЛЬКО если есть еще что возвращать!!!
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP_calc()
                                             , _tmpRes.MovementItemId
                                             , CASE -- WHEN inSession = '5' THEN 0
                                                    WHEN _tmpRes.AmountTax_calc > _tmpRes.Amount THEN _tmpRes.NPP_calc
                                                    ELSE 0
                                               END
                                              )
     FROM _tmpRes;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (_tmpRes.MovementItemId, vbUserId, FALSE)
     FROM _tmpRes;


     -- сохранили протокол
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NPP_calc(), inMovementId, TRUE)
           , lpInsertUpdate_MovementDate    (zc_MovementDate_NPP_calc(),    inMovementId, CURRENT_TIMESTAMP)
            ;



     IF inSession <> '5' OR 1=1
     THEN
         -- Результат
         RETURN;
     ELSE
         -- Результат
         RETURN QUERY
           SELECT _tmpRes.MovementItemId, _tmpRes.GoodsId, _tmpRes.GoodsKindId, _tmpRes.NPPTax_calc
                , CASE WHEN _tmpRes.AmountTax_calc > _tmpRes.Amount THEN _tmpRes.NPP_calc ELSE 0 END AS NPP_calc
                , _tmpRes.AmountTax_calc, _tmpRes.SummTaxDiff_calc, _tmpRes.Amount
           FROM _tmpRes;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.03.18                                        *
*/
/*
 SELECT DISTINCT Movement.*
 FROM Movement
      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                             AND MovementItem.Amount     <> 0
      INNER JOIN MovementItemFloat AS MIFloat_NPP_calc
                                   ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                  AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                  AND MIFloat_NPP_calc.ValueData      > 0
 WHERE Movement.OperDate >= '01.03.2018'
   AND Movement.DescId   = zc_Movement_TaxCorrective()
   AND Movement.StatusId = zc_Enum_Status_Complete()
*/
-- тест
-- SELECT * FROM gpUpdate_MI_TaxCorrective_NPP_calc (inMovementId:= 8842841, inSession:= zfCalc_UserAdmin())
