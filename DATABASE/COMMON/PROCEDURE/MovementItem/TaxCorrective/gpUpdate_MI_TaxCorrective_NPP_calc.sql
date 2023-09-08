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
             , NPPTaxNew_calc   Integer
             , AmountTax_calc   TFloat
             , SummTaxDiff_calc TFloat
             , Amount           TFloat
              )
AS
$BODY$
   DECLARE vbUserId                Integer;
   DECLARE vbMovementId_tax        Integer;
   DECLARE vbDocumentTaxKindId_tax Integer;
   DECLARE vbOperDate              TDateTime;
   DECLARE vbOperDate_begin        TDateTime;
   DECLARE vbMovementId_Corrective Integer; -- для Корректировки №2 (переносим строчки с другой причиной корректировки)
   DECLARE vbDocumentTaxKindId     Integer; -- вид Корректировки
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());


     -- проверка
     IF  (EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Registered() AND ValueData = TRUE)
       OR EXISTS (SELECT MovementId FROM MovementBoolean WHERE MovementId = inMovementId AND DescId = zc_MovementBoolean_Electron()   AND ValueData = TRUE))
     AND vbUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Установлен признак <Электронный документ> в <%> № <%> от <%>.<Изменение> невозможно.', (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                                                                                                       , (SELECT InvNumber FROM Movement WHERE Id = inMovementId)
                                                                                                       , zfConvert_DateToString ((SELECT OperDate FROM Movement WHERE Id = inMovementId))
                                                                                                        ;
     END IF;


     -- определяются параметры для <Корректировка>
     SELECT Movement.OperDate
          , CASE WHEN MovementDate_DateRegistered.ValueData > Movement.OperDate THEN MovementDate_DateRegistered.ValueData ELSE Movement.OperDate END AS OperDate_begin
            -- MovementId налоговой
          , MovementLinkMovement_Child.MovementChildId AS MovementId_tax
            -- вид корр
          , MLO_DocumentTaxKind.ObjectId      AS DocumentTaxKindId
            -- вид налоговой
          , MLO_DocumentTaxKind_tax.ObjectId  AS DocumentTaxKindId_tax
            INTO vbOperDate, vbOperDate_begin, vbMovementId_tax, vbDocumentTaxKindId, vbDocumentTaxKindId_tax
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                 ON MovementDate_DateRegistered.MovementId = Movement.Id
                                AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                         ON MovementLinkMovement_Child.MovementId = Movement.Id
                                        AND MovementLinkMovement_Child.DescId     = zc_MovementLinkMovement_Child()
          LEFT JOIN MovementLinkObject AS MLO_DocumentTaxKind
                                       ON MLO_DocumentTaxKind.MovementId = Movement.Id
                                      AND MLO_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
          LEFT JOIN MovementLinkObject AS MLO_DocumentTaxKind_tax
                                       ON MLO_DocumentTaxKind_tax.MovementId = MovementLinkMovement_Child.MovementChildId
                                      AND MLO_DocumentTaxKind_tax.DescId     = zc_MovementLinkObject_DocumentTaxKind()
     WHERE Movement.Id = inMovementId
     ;


     -- Проверка
     IF COALESCE (vbMovementId_tax, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение <№ налоговой>.';
     END IF;

     -- !!!Проверка - Можно ли МЕНЯТЬ!!!
     IF -- если был сформирован № п/п
        EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                                 ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                                AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
                     LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                 ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.Amount     <> 0
                  AND (MIFloat_NPPTax_calc.ValueData <> 0
                    OR MIFloat_NPP_calc.ValueData    <> 0
                      )
               )
         -- Найдены В Этот день другие Корректировки
     AND EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                                     ON MovementLinkMovement_Child.MovementId      = Movement.Id
                                                    AND MovementLinkMovement_Child.DescId          = zc_MovementLinkMovement_Child()
                                                    AND MovementLinkMovement_Child.MovementChildId = vbMovementId_tax
                WHERE Movement.OperDate = vbOperDate
                  AND Movement.DescId   = zc_Movement_TaxCorrective()
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND Movement.Id       <> inMovementId
               )
     THEN
         RAISE EXCEPTION 'Ошибка.В корректировке уже сформированы данные <№ п/п в колонке 1/2строка - для колонки 7 с "плюсом" - формируется в Корректировке по правилу: № п/п + 1>%Необходимо сначала обнулить значение <№ п/п в 1/2строка> и <Кол-во в 7/1строка>, потом повторить операцию.', CHR (13);
     END IF;

     -- !!!Проверка - Можно ли МЕНЯТЬ!!!
     IF vbDocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_Corrective()
                                  , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()
                                  , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                  , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()
                                  , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                  , zc_Enum_DocumentTaxKind_CorrectivePrice()
                                  , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                  , zc_Enum_DocumentTaxKind_Prepay() 
                                  , zc_Enum_DocumentTaxKind_ChangePercent()
                                   )
     THEN
         -- IF inSession <> '5' THEN
         RAISE EXCEPTION 'Ошибка.Для документа <%> выбранная функция не предусмотрена.'
                       , lfGet_Object_ValueData_sh (vbDocumentTaxKindId);
         -- END IF;
     END IF;


     -- !!!Проверка - PriceTax_calc!!!
     IF vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                              , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                              , zc_Enum_DocumentTaxKind_ChangePercent()
                               )
    AND EXISTS (SELECT 1
                FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                                  ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                                 AND MIFloat_PriceTax_calc.DescId        = zc_MIFloat_PriceTax_calc()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.Amount     <> 0
                  AND COALESCE (MIFloat_PriceTax_calc.ValueData, 0) = 0
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлена Цена продажи которая корректируется.Для документа <%> выбранная функция не предусмотрена.'
                       , lfGet_Object_ValueData_sh (vbDocumentTaxKindId);
     END IF;


     -- !!!важно - ОБНУЛИЛИ!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(),      MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(),   MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTaxDiff_calc(), MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP_calc(),         MovementItem.Id, 0)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTaxNew_calc(),   MovementItem.Id, 0)
             -- для корр.цены
      --!!!, lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTax_calc(),    MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       -- AND MovementItem.isErased   = FALSE
       -- AND MovementItem.Amount     <> 0
         ;

     IF vbUserId = 5 AND 1=0
     THEN
         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
         --
         RETURN;

     END IF;


     -- таблица - Список
     CREATE TEMP TABLE _tmpRes (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, NPPTax_calc Integer, NPP_calc Integer, NPPTaxNew_calc Integer, AmountTax_calc TFloat, SummTaxDiff_calc TFloat, Amount TFloat, OperPrice TFloat, CountForPrice TFloat, PriceTax_calc TFloat) ON COMMIT DROP;


     -- !!!Временно - если уже был расчет - Тогда только Переносим строчки!!!
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.ValueData = TRUE AND MB.DescId = zc_MovementBoolean_NPP_calc())
        -- и есть строчки с количеством = "все" что "корректируется"
        AND EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                                     ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                      AND MovementItem.Amount     = MIFloat_AmountTax_calc.ValueData
                   )
        -- и есть строчки с количеством <> "все" что "корректируется"
        AND EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                                     ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                                    AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                      AND MovementItem.Amount     <> MIFloat_AmountTax_calc.ValueData
                      AND MIFloat_AmountTax_calc.ValueData <> 0
                   )
        -- и есть строчки с NPP_calc
        AND EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                     ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                    AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                      AND MIFloat_NPP_calc.ValueData > 0
                   )
        AND vbDocumentTaxKindId NOT IN (--zc_Enum_DocumentTaxKind_CorrectivePrice()
                                    --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                        zc_Enum_DocumentTaxKind_Goods()
                                      , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                      , zc_Enum_DocumentTaxKind_Prepay()
                                       )
     THEN
         -- сохранили - !!!БЕЗ расчета №п/п!!!
         INSERT INTO _tmpRes (MovementItemId, GoodsId, GoodsKindId, NPPTax_calc, NPP_calc, NPPTaxNew_calc, AmountTax_calc, SummTaxDiff_calc, Amount, OperPrice, CountForPrice)
           SELECT MovementItem.Id                                     AS MovementItemId
                , MovementItem.ObjectId                               AS GoodsId
                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                , COALESCE (MIFloat_NPPTax_calc.ValueData, 0)         AS NPPTax_calc
                , COALESCE (MIFloat_NPP_calc.ValueData, 0)            AS NPP_calc
                , COALESCE (MIFloat_NPPTaxNew_calc.ValueData, 0)      AS NPPTaxNew_calc
                , COALESCE (MIFloat_AmountTax_calc.ValueData, 0)      AS AmountTax_calc
                , COALESCE (zc_MIFloat_SummTaxDiff_calc.ValueData, 0) AS SummTaxDiff_calc
                , MovementItem.Amount                                 AS Amount
                , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                , COALESCE (MIFloat_CountForPrice.ValueData, 1)       AS CountForPrice
           FROM MovementItem
                LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                            ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                           AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                            ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                           AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
                LEFT JOIN MovementItemFloat AS MIFloat_NPPTaxNew_calc
                                            ON MIFloat_NPPTaxNew_calc.MovementItemId = MovementItem.Id
                                           AND MIFloat_NPPTaxNew_calc.DescId         = zc_MIFloat_NPPTaxNew_calc()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                            ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                LEFT JOIN MovementItemFloat AS zc_MIFloat_SummTaxDiff_calc
                                            ON zc_MIFloat_SummTaxDiff_calc.MovementItemId = MovementItem.Id
                                           AND zc_MIFloat_SummTaxDiff_calc.DescId         = zc_MIFloat_SummTaxDiff_calc()

                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                           -- AND MIFloat_Price.ValueData <> 0
                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId     = zc_MI_Master()
             AND MovementItem.isErased   = FALSE
             AND MovementItem.Amount     <> 0
          ;

     ELSE
         -- сохранили - !!!с расчетом №п/п!!!
         WITH -- Все корректировки
              tmpMovement AS
                 (SELECT MovementLinkMovement_Child.MovementId
                       , Movement.OperDate
                       , CASE WHEN MovementString_InvNumberRegistered.ValueData <> '' THEN TRUE ELSE FALSE END AS isRegistered
                       , MovementLinkObject_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                  FROM MovementLinkMovement AS MovementLinkMovement_Child
                       INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Child.MovementId
                                          AND Movement.StatusId = zc_Enum_Status_Complete()
                                          AND Movement.OperDate <= vbOperDate
                       LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                                ON MovementString_InvNumberRegistered.MovementId = MovementLinkMovement_Child.MovementId
                                               AND MovementString_InvNumberRegistered.DescId     = zc_MovementString_InvNumberRegistered()
                       INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                     ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                                    AND MovementLinkObject_DocumentTaxKind.ObjectId   IN (zc_Enum_DocumentTaxKind_Corrective()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                                        , zc_Enum_DocumentTaxKind_Goods()
                                                                                                        , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                                                                        , zc_Enum_DocumentTaxKind_Prepay()
                                                                                                        , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                                                         )
                  WHERE MovementLinkMovement_Child.MovementChildId = vbMovementId_tax
                    AND MovementLinkMovement_Child.DescId          = zc_MovementLinkMovement_Child()
                    AND MovementLinkMovement_Child.MovementId      <> inMovementId
                    -- пока считаем что для Корр.Цены нет Корр.Кол-ва
                    -- AND vbDocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                    --                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                    --                                )
                 UNION
                  -- Зарегистрированные
                  SELECT MovementLinkMovement_Child.MovementId
                       , Movement.OperDate
                       , TRUE                                        AS isRegistered
                       , MovementLinkObject_DocumentTaxKind.ObjectId AS DocumentTaxKindId
                  FROM MovementLinkMovement AS MovementLinkMovement_Child
                       INNER JOIN Movement ON Movement.Id       = MovementLinkMovement_Child.MovementId
                                          AND Movement.StatusId = zc_Enum_Status_Complete()
                                          AND Movement.OperDate < DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH'
                       INNER JOIN MovementString AS MovementString_InvNumberRegistered
                                                ON MovementString_InvNumberRegistered.MovementId = MovementLinkMovement_Child.MovementId
                                               AND MovementString_InvNumberRegistered.DescId     = zc_MovementString_InvNumberRegistered()
                                               AND MovementString_InvNumberRegistered.ValueData  <> ''
                       INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                                     ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                                    AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                                    AND MovementLinkObject_DocumentTaxKind.ObjectId   IN (zc_Enum_DocumentTaxKind_Corrective()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                                        , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                                        , zc_Enum_DocumentTaxKind_Prepay()
                                                                                                        , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                                                         )
                  WHERE MovementLinkMovement_Child.MovementChildId = vbMovementId_tax
                    AND MovementLinkMovement_Child.DescId          = zc_MovementLinkMovement_Child()
                    AND MovementLinkMovement_Child.MovementId      <> inMovementId
                    -- пока считаем что для Корр.Цены нет Корр.Кол-ва
                    -- AND vbDocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                    --                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                    --                                )
                 )
              -- ВСЕ корректировки (кроме текущей)
            , tmpMI_All AS
                 (SELECT MovementItem.Id               AS Id
                       , MovementItem.MovementId       AS MovementId
                       , MovementItem.ObjectId         AS GoodsId
                       , MovementItem.Amount           AS Amount
                       , tmpMovement.OperDate          AS OperDate
                       , tmpMovement.isRegistered      AS isRegistered
                       , tmpMovement.DocumentTaxKindId AS DocumentTaxKindId
                  FROM tmpMovement
                       INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.MovementId
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = FALSE
                                              AND MovementItem.Amount     <> 0
                       LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                                   ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PriceTax_calc.DescId        = zc_MIFloat_PriceTax_calc()
                  WHERE tmpMovement.DocumentTaxKindId NOT IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                            , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                            , zc_Enum_DocumentTaxKind_ChangePercent())
                     OR MIFloat_PriceTax_calc.ValueData <> 0
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
                    AND MovementItemLinkObject.DescId         = zc_MILinkObject_GoodsKind()
                 )
              -- ВСЕ корректировки (кроме текущей) + СВ-ВА
            , tmpMI_Corr_all_all AS
                 (SELECT tmpMI_All.Id                                   AS Id
                       , tmpMI_All.MovementId                           AS MovementId
                       , tmpMI_All.OperDate                             AS OperDate
                       , tmpMI_All.isRegistered                         AS isRegistered
                       , tmpMI_All.DocumentTaxKindId                    AS DocumentTaxKindId
                       , tmpMI_All.GoodsId                              AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                       , tmpMI_All.Amount                               AS Amount
                       , CASE WHEN tmpMI_All.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                 , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                 , zc_Enum_DocumentTaxKind_ChangePercent())
                              THEN COALESCE (MIFloat_PriceTax_calc.ValueData, 0)
                              ELSE COALESCE (MIFloat_Price.ValueData, 0)
                         END AS Price
                       , COALESCE (MIFloat_AmountTax_calc.ValueData, 0) AS AmountTax_calc

                       , CASE WHEN COALESCE (MIFloat_NPPTaxNew_calc.ValueData, 0) > COALESCE (MIFloat_NPP_calc.ValueData, 0)
                                   THEN COALESCE (MIFloat_NPPTaxNew_calc.ValueData, 0)
                              ELSE COALESCE (MIFloat_NPP_calc.ValueData, 0)
                         END  AS NPP_calc

                       , COALESCE (MIFloat_NPP_calc.ValueData, 0)       AS NPP_calc_original
                       , COALESCE (MIFloat_NPPTaxNew_calc.ValueData, 0) AS NPPTaxNew_calc

                       , COALESCE (MIFloat_NPPTax_calc.ValueData, 0)    AS NPPTax_calc

                         -- Сумма - для Итого
                       , CAST (tmpMI_All.Amount
                             * CASE WHEN tmpMI_All.DocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                       , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                       , zc_Enum_DocumentTaxKind_ChangePercent())
                                    THEN COALESCE (MIFloat_PriceTax_calc.ValueData, 0)
                                    ELSE COALESCE (MIFloat_Price.ValueData, 0)
                               END AS NUMERIC (16, 2))
                       + COALESCE (MIFloat_SummTaxDiff_calc.ValueData, 0) AS AmountSumm
                  FROM tmpMI_All
                       LEFT JOIN tmpMIFloat AS MIFloat_NPPTax_calc
                                            ON MIFloat_NPPTax_calc.MovementItemId = tmpMI_All.Id
                                           AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
                                           AND MIFloat_NPPTax_calc.ValueData      > 0
                       LEFT JOIN tmpMIFloat AS MIFloat_NPP_calc
                                            ON MIFloat_NPP_calc.MovementItemId = tmpMI_All.Id
                                           AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                           AND MIFloat_NPP_calc.ValueData      > 0
                       LEFT JOIN tmpMIFloat AS MIFloat_NPPTaxNew_calc
                                            ON MIFloat_NPPTaxNew_calc.MovementItemId = tmpMI_All.Id
                                           AND MIFloat_NPPTaxNew_calc.DescId         = zc_MIFloat_NPPTaxNew_calc()
                                           AND MIFloat_NPPTaxNew_calc.ValueData      > 0
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
                       LEFT JOIN tmpMIFloat AS MIFloat_PriceTax_calc
                                            ON MIFloat_PriceTax_calc.MovementItemId = tmpMI_All.Id
                                           AND MIFloat_PriceTax_calc.DescId         = zc_MIFloat_PriceTax_calc()
                       LEFT JOIN tmpGoodsKind AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = tmpMI_All.Id
                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                 )
              -- ВСЕ корректировки (кроме текущей) + СВ-ВА
            , tmpMI_Corr_all AS
                 (SELECT tmpMI_Corr_all_all.Id
                       , tmpMI_Corr_all_all.MovementId
                       , tmpMI_Corr_all_all.OperDate
                       , tmpMI_Corr_all_all.isRegistered
                       , tmpMI_Corr_all_all.DocumentTaxKindId
                       , tmpMI_Corr_all_all.GoodsId
                       , tmpMI_Corr_all_all.GoodsKindId
                       , tmpMI_Corr_all_all.Amount
                       , tmpMI_Corr_all_all.Price
                       , tmpMI_Corr_all_all.AmountTax_calc
                       , tmpMI_Corr_all_all.NPP_calc
                       , tmpMI_Corr_all_all.NPP_calc_original
                       , tmpMI_Corr_all_all.NPPTax_calc
                         -- Сумма - для Итого
                       , tmpMI_Corr_all_all.AmountSumm
                         -- № п/п - Что б выбрать !!!ПОСЛЕДНЮЮ!!!
                       , ROW_NUMBER() OVER (PARTITION BY tmpMI_Corr_all_all.GoodsId, tmpMI_Corr_all_all.GoodsKindId
                                                       , tmpMI_Corr_all_all.Price
                                            ORDER BY tmpMI_Corr_all_all.NPP_calc DESC, tmpMI_Corr_all_all.Id DESC) AS Ord1
                         -- № п/п - Что б выбрать !!!ПОСЛЕДНЮЮ!!!
                       , ROW_NUMBER() OVER (PARTITION BY tmpMI_Corr_all_all.GoodsId, tmpMI_Corr_all_all.GoodsKindId
                                                       , tmpMI_Corr_all_all.Price
                                            ORDER BY tmpMI_Corr_all_all.NPP_calc DESC, tmpMI_Corr_all_all.Id DESC) AS Ord2
                  FROM tmpMI_Corr_all_all
                 )
              -- SUMMA
            , tmpMI_Corr_sum_1 AS
                 (SELECT tmpMI_Corr_all.GoodsId
                       , tmpMI_Corr_all.GoodsKindId
                       , tmpMI_Corr_all.Price
                       , SUM (CASE WHEN (tmpMI_Corr_all.NPPTax_calc = 0 AND tmpMI_Corr_all.OperDate < vbOperDate)
                                     OR tmpMI_Corr_all.NPPTax_calc  > 0
                                     OR tmpMI_Corr_all.isRegistered = TRUE

                                   THEN tmpMI_Corr_all.Amount
                                   ELSE 0
                              END) AS Amount
                       , SUM (CASE WHEN (tmpMI_Corr_all.NPPTax_calc = 0 AND tmpMI_Corr_all.OperDate < vbOperDate)
                                     OR tmpMI_Corr_all.NPPTax_calc > 0
                                     OR tmpMI_Corr_all.isRegistered = TRUE

                                   THEN tmpMI_Corr_all.Amount
                                   ELSE 0
                              END) AS Amount_all
                       , SUM (CASE WHEN (tmpMI_Corr_all.NPPTax_calc = 0 AND tmpMI_Corr_all.OperDate < vbOperDate)
                                     OR tmpMI_Corr_all.NPPTax_calc  > 0
                                     OR tmpMI_Corr_all.isRegistered = TRUE

                                   THEN tmpMI_Corr_all.AmountSumm
                                   ELSE 0
                              END) AS AmountSumm
                       -- , SUM (tmpMI_Corr_all.Amount)     AS Amount_all
                       -- , SUM (tmpMI_Corr_all.AmountSumm) AS AmountSumm
                  FROM tmpMI_Corr_all
                  GROUP BY tmpMI_Corr_all.GoodsId
                         , tmpMI_Corr_all.GoodsKindId
                         , tmpMI_Corr_all.Price
                 )
            , tmpMI_Corr_sum_2 AS
                 (SELECT tmpMI_Corr_all.GoodsId
                       , tmpMI_Corr_all.Price
                       , SUM (CASE WHEN (tmpMI_Corr_all.NPPTax_calc = 0 AND tmpMI_Corr_all.OperDate < vbOperDate)
                                     OR tmpMI_Corr_all.NPPTax_calc  > 0
                                     OR tmpMI_Corr_all.isRegistered = TRUE

                                   THEN tmpMI_Corr_all.Amount
                                   ELSE 0
                              END) AS Amount
                       , SUM (CASE WHEN (tmpMI_Corr_all.NPPTax_calc = 0 AND tmpMI_Corr_all.OperDate < vbOperDate)
                                     OR tmpMI_Corr_all.NPPTax_calc  > 0
                                     OR tmpMI_Corr_all.isRegistered = TRUE

                                   THEN tmpMI_Corr_all.Amount
                                   ELSE 0
                              END) AS Amount_all
                       , SUM (CASE WHEN (tmpMI_Corr_all.NPPTax_calc = 0 AND tmpMI_Corr_all.OperDate < vbOperDate)
                                     OR tmpMI_Corr_all.NPPTax_calc  > 0
                                     OR tmpMI_Corr_all.isRegistered = TRUE

                                   THEN tmpMI_Corr_all.AmountSumm
                                   ELSE 0
                              END) AS AmountSumm
                       -- , SUM (tmpMI_Corr_all.Amount)     AS Amount_all
                       -- , SUM (tmpMI_Corr_all.AmountSumm) AS AmountSumm
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
                       , CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                         , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                         , zc_Enum_DocumentTaxKind_ChangePercent())
                              THEN COALESCE (MIFloat_PriceTax_calc.ValueData, 0) 
                              ELSE COALESCE (MIFloat_Price.ValueData, 0)
                         END AS Price
                       , COALESCE (MIFloat_CountForPrice.ValueData, 1)  AS CountForPrice
                       , CASE WHEN COALESCE (MIBoolean_isAuto.ValueData, TRUE) = TRUE THEN 0 ELSE COALESCE (MIFloat_NPP.ValueData, 0) END AS NPP
                  FROM MovementItem
                       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                   ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                  AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                                  -- AND MIFloat_Price.ValueData <> 0
                       LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                                   ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                                  AND MIFloat_PriceTax_calc.DescId         = zc_MIFloat_PriceTax_calc()
                       LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
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
                       , COALESCE (tmpMI_tax1.Price, tmpMI_tax2.Price, 0) AS PriceTax_calc
                       , tmpMI_Corr_curr_all.CountForPrice

                         -- Кол-во из налог. за минусом "предыдущих" корр.
                       , COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find) - COALESCE (tmpMI_Corr_sum_1.Amount, tmpMI_Corr_sum_2.Amount, 0) AS AmountTax_calc

                         -- Сумма DIFF - из налог. за минусом ...
                       , CAST (COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find) * COALESCE (tmpMI_tax1.Price, tmpMI_tax2.Price) AS NUMERIC (16, 2))
                         -- минус "предыдущие" корр. (ВСЕ)
                       - COALESCE (tmpMI_Corr_sum_1.AmountSumm, tmpMI_Corr_sum_2.AmountSumm, 0) AS SummTaxDiff_calc

                         -- № п/п из налог. ИЛИ текущий
                       , CASE WHEN tmpMI_Corr_curr_all.NPP = 0 THEN COALESCE (tmpMI_tax1.LineNum, tmpMI_tax2.LineNum) ELSE tmpMI_Corr_curr_all.NPP END :: Integer AS NPP

                         -- № п/п внутренний для ЗАПРОСА с 1... и до... - Что б увеличить счетчик на + 1
                       , ROW_NUMBER() OVER (ORDER BY CASE -- для ....
                                                          WHEN vbDocumentTaxKindId IN (-- zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                   --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                       zc_Enum_DocumentTaxKind_Goods()
                                                                                     , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                                                   --, zc_Enum_DocumentTaxKind_Prepay()
                                                                                      )
                                                               THEN COALESCE (tmpMI_tax1.LineNum, tmpMI_tax2.LineNum, 0)

                                                          -- если корректируют все "оставшееся" кол-во
                                                          WHEN COALESCE (tmpMI_Corr_sum_1.Amount_all, tmpMI_Corr_sum_1.Amount_all, 0) + tmpMI_Corr_curr_all.Amount
                                                             = COALESCE (tmpMI_tax1.Amount_Tax_find, tmpMI_tax2.Amount_Tax_find, 0)
                                                               THEN 12345678

                                                          -- если (как правило) вручную № п/п НЕ вводили
                                                          WHEN tmpMI_Corr_curr_all.NPP = 0 THEN COALESCE (tmpMI_tax1.LineNum, tmpMI_tax2.LineNum, 0)

                                                          -- если (вдруг) вводили вручную № п/п
                                                          ELSE tmpMI_Corr_curr_all.NPP

                                                     END ASC
                                           ) AS Ord
                  FROM tmpMI_Corr_curr_all
                       -- номера строк в НН
                       LEFT JOIN tmpMI_tax AS tmpMI_tax1 ON tmpMI_tax1.Kind        = 1
                                                        AND tmpMI_tax1.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                        AND tmpMI_tax1.GoodsKindId = tmpMI_Corr_curr_all.GoodsKindId
                                                        AND tmpMI_tax1.Price       = CASE WHEN vbDocumentTaxKindId IN (--zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                                                   --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                                                       zc_Enum_DocumentTaxKind_Goods()
                                                                                                                     , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                                                                                   --, zc_Enum_DocumentTaxKind_Prepay()
                                                                                                                      )
                                                                                               THEN tmpMI_tax1.Price
                                                                                          ELSE tmpMI_Corr_curr_all.Price
                                                                                     END

                       LEFT JOIN tmpMI_tax AS tmpMI_tax2 ON tmpMI_tax2.Kind        = 2
                                                        AND tmpMI_tax2.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                        AND tmpMI_tax2.Price       = CASE WHEN vbDocumentTaxKindId IN (--zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                                                                   --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                                                       zc_Enum_DocumentTaxKind_Goods()
                                                                                                                     , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                                                                                   --, zc_Enum_DocumentTaxKind_Prepay()
                                                                                                                      )
                                                                                               THEN tmpMI_tax2.Price
                                                                                          ELSE tmpMI_Corr_curr_all.Price
                                                                                     END
                                                        AND tmpMI_tax1.GoodsId     IS NULL
                       -- итоги в корр
                       LEFT JOIN tmpMI_Corr_sum_1 ON tmpMI_Corr_sum_1.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                 AND tmpMI_Corr_sum_1.GoodsKindId = tmpMI_Corr_curr_all.GoodsKindId
                                                 AND tmpMI_Corr_sum_1.Price       = tmpMI_Corr_curr_all.Price
                                                 AND vbDocumentTaxKindId NOT IN (-- zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                             --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                 zc_Enum_DocumentTaxKind_Goods()
                                                                               , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                                             --, zc_Enum_DocumentTaxKind_Prepay()
                                                                                )
                       LEFT JOIN tmpMI_Corr_sum_2 ON tmpMI_Corr_sum_2.GoodsId     = tmpMI_Corr_curr_all.GoodsId
                                                 AND tmpMI_Corr_sum_2.Price       = tmpMI_Corr_curr_all.Price
                                                 -- !!!обязательно!!! - если и в налоговой НЕТ GoodsKindId
                                                 AND tmpMI_tax1.GoodsId           IS NULL
                                                 AND vbDocumentTaxKindId NOT IN (--zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                             --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                                 zc_Enum_DocumentTaxKind_Goods()
                                                                               , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                                             --, zc_Enum_DocumentTaxKind_Prepay()
                                                                                )
                 )
              -- Результат
            , tmpMI_Data AS
                 (SELECT tmpMI_Corr_curr.Id AS MovementItemId
                       , tmpMI_Corr_curr.GoodsId
                       , tmpMI_Corr_curr.GoodsKindId

                         -- № п/п в колонке 1/1строка - для колонки 7 с "минусом"
                       , CASE WHEN vbDocumentTaxKindId IN (--zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                       --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                           zc_Enum_DocumentTaxKind_Goods()
                                                         , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                       --, zc_Enum_DocumentTaxKind_Prepay()
                                                          )
                                   THEN tmpMI_Corr_curr.NPP                     -- № п/п в налоговом документе
                              ELSE COALESCE (tmpMI_Corr_all1.NPP_calc_original  -- № п/п в последней корр
                                           , tmpMI_Corr_all2.NPP_calc_original  -- № п/п в последней корр - БЕЗ GoodsKindId
                                           , tmpMI_Corr_curr.NPP                -- № п/п в налоговой
                                            )
                         END :: Integer AS NPPTax_calc

                         -- Кол-во для НН в колонке 7/1строка
                       , CASE WHEN vbDocumentTaxKindId IN (--zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                       --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                           zc_Enum_DocumentTaxKind_Goods()
                                                         , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                       --, zc_Enum_DocumentTaxKind_Prepay()
                                                          )
                                   THEN tmpMI_Corr_curr.AmountTax_calc -- кол-во в налоговой

                              ELSE COALESCE (tmpMI_Corr_all1.AmountTax_calc - tmpMI_Corr_all1.Amount  -- кол-во в последней корр МИНУС какая там корр.
                                           , tmpMI_Corr_all2.AmountTax_calc - tmpMI_Corr_all2.Amount  -- кол-во в последней корр МИНУС какая там корр. - БЕЗ GoodsKindId
                                           , tmpMI_Corr_curr.AmountTax_calc                           -- кол-во в налоговой
                                            )
                         END :: TFloat AS AmountTax_calc

                         -- Сумма DIFF для НН в колонке 13/1строка - из налог. за минусом ...
                       , CASE WHEN vbDocumentTaxKindId IN (--zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                       --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                           zc_Enum_DocumentTaxKind_Goods()
                                                         , zc_Enum_DocumentTaxKind_Change(), zc_Enum_DocumentTaxKind_ChangeErr()
                                                       --, zc_Enum_DocumentTaxKind_Prepay()
                                                          )
                                   THEN 0

                              ELSE CASE -- Если была Корректировка с № п/п - ТОГДА НЕ НАДО "копеек"
                                        WHEN tmpMI_Corr_curr.NPP
                                          <> COALESCE (tmpMI_Corr_all1.NPP_calc_original  -- № п/п в последней корр
                                                     , tmpMI_Corr_all2.NPP_calc_original  -- № п/п в последней корр - БЕЗ GoodsKindId
                                                     , tmpMI_Corr_curr.NPP                -- № п/п в налоговой
                                                      )
                                             THEN 0

                                        -- иначе посчитаем копейки
                                        ELSE
                                        tmpMI_Corr_curr.SummTaxDiff_calc
                                      - CAST (COALESCE (tmpMI_Corr_all1.AmountTax_calc - tmpMI_Corr_all1.Amount  -- кол-во в последней корр МИНУС какая там корр.
                                                      , tmpMI_Corr_all2.AmountTax_calc - tmpMI_Corr_all2.Amount  -- кол-во в последней корр МИНУС какая там корр. - БЕЗ GoodsKindId
                                                      , tmpMI_Corr_curr.AmountTax_calc                           -- кол-во в налоговой
                                                       )
                                            * tmpMI_Corr_curr.Price AS NUMERIC (16, 2))
                                   END

                         END AS SummTaxDiff_calc

                         -- № п/п в ТЕКУЩЕЙ корректировка - Что б увеличить счетчик на + 1
                       , tmpMI_Corr_curr.Ord
                         -- Кол-во в ТЕКУЩЕЙ корректировка
                       , tmpMI_Corr_curr.Amount
                         -- Цена в ТЕКУЩЕЙ корректировка
                       , tmpMI_Corr_curr.Price
                       , tmpMI_Corr_curr.CountForPrice
                         -- Цена в налоговой - для Корр цены
                       , tmpMI_Corr_curr.PriceTax_calc
                  FROM tmpMI_Corr_curr
                       -- НН
                       LEFT JOIN tmpMI_tax AS tmpMI_tax1 ON tmpMI_tax1.Kind        = 1
                                                        AND tmpMI_tax1.GoodsId     = tmpMI_Corr_curr.GoodsId
                                                        AND tmpMI_tax1.GoodsKindId = tmpMI_Corr_curr.GoodsKindId
                                                        AND tmpMI_tax1.Price       = tmpMI_Corr_curr.Price
                       --
                       LEFT JOIN tmpMI_Corr_all AS tmpMI_Corr_all1 ON tmpMI_Corr_all1.GoodsId     = tmpMI_Corr_curr.GoodsId
                                                                  AND tmpMI_Corr_all1.GoodsKindId = tmpMI_Corr_curr.GoodsKindId
                                                                  AND tmpMI_Corr_all1.Price       = tmpMI_Corr_curr.Price
                                                                  AND tmpMI_Corr_all1.Ord1        = 1 -- т.е. по всем св-вам
                                                                  AND tmpMI_Corr_all1.NPP_calc_original > 0
                       LEFT JOIN tmpMI_Corr_all AS tmpMI_Corr_all2 ON tmpMI_Corr_all2.GoodsId     = tmpMI_Corr_curr.GoodsId
                                                                  AND tmpMI_Corr_all2.Price       = tmpMI_Corr_curr.Price
                                                                  AND tmpMI_Corr_all2.Ord2        = 2 -- т.е. по св-вам БЕЗ GoodsKindId
                                                                  AND tmpMI_Corr_all2.NPP_calc_original > 0
                                                                  AND tmpMI_tax1.GoodsId          IS NULL
                 )
         -- сохранили
         INSERT INTO _tmpRes (MovementItemId, GoodsId, GoodsKindId, NPPTax_calc, NPP_calc, NPPTaxNew_calc, AmountTax_calc, SummTaxDiff_calc, Amount, OperPrice, CountForPrice, PriceTax_calc)
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

                 + CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                   , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                   , zc_Enum_DocumentTaxKind_ChangePercent() )
                         AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                       , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                       , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                       , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                        )
                             THEN CASE WHEN tmpMI_Data.AmountTax_calc > tmpMI_Data.Amount
                                            THEN tmpMI_Data.Ord + tmpMI_Data.Ord
                                        ELSE 0
                                  END
                        ELSE tmpMI_Data.Ord -- № п/п - Что б увеличить счетчик на + 1
                   END
                  ) :: Integer AS NPP_calc

                  -- № п/п в колонке 1/3строка - для колонки 7 с "плюсом" - "строчка для налогой с НОВОЙ ценой"
                , (COALESCE ((SELECT MAX (tmp.NPP)
                              FROM (SELECT MAX (tmpMI_Data.NPPTax_calc)  AS NPP FROM tmpMI_Data
                                   UNION ALL
                                    SELECT MAX (tmpMI_tax.LineNum)       AS NPP FROM tmpMI_tax
                                   UNION ALL
                                    SELECT MAX (tmpMI_Corr_all.NPP_calc) AS NPP FROM tmpMI_Corr_all
                                   ) AS tmp
                             ), 0)

                 + CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                   , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                   , zc_Enum_DocumentTaxKind_ChangePercent()
                                                   )
                         AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                       , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                       , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                       , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                        )
                         AND tmpMI_Data.AmountTax_calc > tmpMI_Data.Amount
                             THEN tmpMI_Data.Ord + tmpMI_Data.Ord - 1
                        ELSE tmpMI_Data.Ord + COALESCE ((SELECT MAX (tmpMI_Data_find.Ord) FROM tmpMI_Data AS tmpMI_Data_find WHERE tmpMI_Data_find.AmountTax_calc > tmpMI_Data_find.Amount), 0)
                   END
                  ) :: Integer AS NPPTaxNew_calc

                  -- Кол-во для НН в колонке 7/1строка
                , tmpMI_Data.AmountTax_calc

                  -- Сумма DIFF для НН в колонке 13/1строка - !!!всегда!!!
                  -- , CASE WHEN tmpMI_Data.AmountTax_calc = tmpMI_Data.Amount THEN tmpMI_Data.SummTaxDiff_calc ELSE 0 END AS SummTaxDiff_calc
                , tmpMI_Data.SummTaxDiff_calc

                  -- Кол-во в ТЕКУЩЕЙ корректировка
                , tmpMI_Data.Amount
                  -- Цена в ТЕКУЩЕЙ корректировка
                , tmpMI_Data.Price AS OperPrice
                , tmpMI_Data.CountForPrice

                  -- Цена в налоговой - для Корр цены
                , tmpMI_Data.PriceTax_calc

           FROM tmpMI_Data;

     END IF; -- сохранили - !!!с расчетом №п/п!!!


     -- Проверка
     IF EXISTS (SELECT 1 FROM _tmpRes WHERE _tmpRes.NPPTax_calc IS NULL)
     THEN
         RAISE EXCEPTION 'Ошибка.<%>.', (SELECT COUNT(*) FROM _tmpRes WHERE _tmpRes.NPPTax_calc IS NULL);
     END IF;

     -- РЕЗУЛЬТАТ - сохранили ВСЕ что расчитали для № п/п
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(),      _tmpRes.MovementItemId, _tmpRes.NPPTax_calc)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc()
                                             , _tmpRes.MovementItemId
                                             , CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                               , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                                )
                                                      AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                                    , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                                    , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                                    , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                                     )
                                                    THEN _tmpRes.AmountTax_calc -- !!!подставили из Налоговой!!!
                                                    
                                                    WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                               , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                             --, zc_Enum_DocumentTaxKind_Prepay()
                                                                                )
                                                    THEN ABS (_tmpRes.Amount) -- !!!подставили что ввели, а не из Налоговой!!!
                                                    ELSE _tmpRes.AmountTax_calc
                                               END
                                              )
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTaxDiff_calc(), _tmpRes.MovementItemId, _tmpRes.SummTaxDiff_calc)
             -- !!!важно - сохранили ТОЛЬКО если есть еще что возвращать!!!
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP_calc()
                                             , _tmpRes.MovementItemId
                                             , CASE -- WHEN inSession = '5' THEN 0
                                                    WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                               , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                                )
                                                     AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                                   , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                                   , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                                   , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                                    )
                                                     AND _tmpRes.AmountTax_calc > _tmpRes.Amount
                                                         THEN _tmpRes.NPP_calc

                                                    WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                               , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                             --, zc_Enum_DocumentTaxKind_Prepay()
                                                                                )
                                                         THEN _tmpRes.NPP_calc

                                                    WHEN _tmpRes.AmountTax_calc > _tmpRes.Amount THEN _tmpRes.NPP_calc
                                                    ELSE 0
                                               END
                                              )
             -- !!!важно - zc_MIFloat_NPPTaxNew_calc!!!
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTaxNew_calc()
                                             , _tmpRes.MovementItemId
                                             , CASE -- WHEN inSession = '5' THEN 0
                                                    WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                               , zc_Enum_DocumentTaxKind_ChangePercent()                                                                               
                                                                                )
                                                     AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                                   , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                                   , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                                   , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                                    )
                                                         THEN _tmpRes.NPPTaxNew_calc
                                                    ELSE 0
                                               END
                                              )
             -- !!!для корр.цены!!!
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTax_calc()
                                             , _tmpRes.MovementItemId
                                             , CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                               , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                               , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                             --, zc_Enum_DocumentTaxKind_Prepay()
                                                                                )
                                                    THEN _tmpRes.PriceTax_calc
                                                    ELSE 0
                                               END
                                              )
     FROM _tmpRes;


     -- схема - переносим ЧАСТЬ корректировки - строчки с другой причиной корректировки
     IF   EXISTS (SELECT 1 FROM _tmpRes WHERE _tmpRes.AmountTax_calc =  _tmpRes.Amount AND _tmpRes.Amount <> 0)
      AND EXISTS (SELECT 1 FROM _tmpRes WHERE _tmpRes.AmountTax_calc <> _tmpRes.Amount AND _tmpRes.Amount <> 0)
      AND vbDocumentTaxKindId NOT IN (--zc_Enum_DocumentTaxKind_CorrectivePrice()
                                  --, zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                      zc_Enum_DocumentTaxKind_Prepay()
                                     )
      AND vbOperDate_begin < '01.12.2018'
     THEN
         -- создаем новую <Корректировку>
         vbMovementId_Corrective:= lpInsertUpdate_Movement_TaxCorrective 
                                                   (ioId               :=0
                                                  , inInvNumber        := NEXTVAL ('movement_taxcorrective_seq') :: TVarChar
                                                  , inInvNumberPartner := lpInsertFind_Object_InvNumberTax (zc_Movement_TaxCorrective(), vbOperDate, '') :: TVarChar
                                                  , inInvNumberBranch  := ''
                                                  , inOperDate         := vbOperDate
                                                  , inChecked          := FALSE
                                                  , inDocument         := FALSE
                                                  , inPriceWithVAT     := (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT())
                                                  , inVATPercent       := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_VATPercent())
                                                  , inFromId           := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                  , inToId             := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                  , inPartnerId        := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Partner())
                                                  , inContractId       := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                  , inDocumentTaxKindId:= vbDocumentTaxKindId
                                                  , inUserId           := vbUserId
                                                   );
         -- сохранили связь с <филиал>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), vbMovementId_Corrective, (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Branch()));

         -- сформировали связь <Корректировки> с <Возврат от покупателя> или <Перевод долга (приход)>
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), vbMovementId_Corrective
                                                    , (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Master())
                                                     );
         -- сформировали связь <Корректировки> с Налоговой
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), vbMovementId_Corrective, vbMovementId_tax);

         -- создаем строчную часть заново в <Корректировке>
         PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                          , inMovementId         := vbMovementId_Corrective
                                                          , inGoodsId            := _tmpRes.GoodsId
                                                          , inAmount             := _tmpRes.Amount
                                                          , inPrice              := _tmpRes.OperPrice
                                                          , inPriceTax_calc      := 0
                                                          , ioCountForPrice      := _tmpRes.CountForPrice
                                                          , inGoodsKindId        := _tmpRes.GoodsKindId
                                                          , inUserId             := vbUserId
                                                           )
         FROM _tmpRes
         WHERE _tmpRes.AmountTax_calc = _tmpRes.Amount
           AND _tmpRes.Amount <> 0
          ;

         -- сохранили !!!для vbMovementId_Corrective!!! - ВСЕ что расчитали для № п/п
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(),      tmpMI.MovementItemId, _tmpRes.NPPTax_calc)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(),   tmpMI.MovementItemId, _tmpRes.AmountTax_calc)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTaxDiff_calc(), tmpMI.MovementItemId, _tmpRes.SummTaxDiff_calc)
         FROM _tmpRes
              LEFT JOIN (SELECT MovementItem.Id                                AS MovementItemId
                              , MovementItem.ObjectId                          AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                              , MovementItem.Amount                            AS Amount
                              , COALESCE (MIFloat_Price.ValueData, 0)          AS OperPrice
                         FROM MovementItem
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                         AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                              LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                         WHERE MovementItem.MovementId = vbMovementId_Corrective
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased   = FALSE
                           AND MovementItem.Amount     <> 0
                        ) AS tmpMI
                          ON tmpMI.GoodsId     = _tmpRes.GoodsId
                         AND tmpMI.GoodsKindId = _tmpRes.GoodsKindId
                         AND tmpMI.OperPrice   = _tmpRes.OperPrice
                         AND tmpMI.Amount      = _tmpRes.Amount
         WHERE _tmpRes.AmountTax_calc = _tmpRes.Amount
           AND _tmpRes.Amount <> 0
          ;

         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId_Corrective);

         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
         FROM MovementItem
         WHERE MovementItem.MovementId = vbMovementId_Corrective
           AND MovementItem.DescId     = zc_MI_Master()
           ;

         -- сохранили протокол
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NPP_calc(), vbMovementId_Corrective, TRUE)
               , lpInsertUpdate_MovementDate    (zc_MovementDate_NPP_calc(),    vbMovementId_Corrective, CURRENT_TIMESTAMP)
                ;

         -- Провели - vbMovementId_Corrective
         PERFORM lpComplete_Movement_TaxCorrective (vbMovementId_Corrective, vbUserId);


         -- удалили !!!для inMovementId!!! - ВРЕМЕННО без провереи Док - РАСПРОВЕДЕН
         UPDATE MovementItem SET isErased = TRUE
         FROM _tmpRes
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.Id         = _tmpRes.MovementItemId
           AND _tmpRes.AmountTax_calc  = _tmpRes.Amount
           AND _tmpRes.Amount          <> 0
          ;

     END IF; -- схема - переносим ЧАСТЬ корректировки - строчки с другой причиной корректировки


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (_tmpRes.MovementItemId, vbUserId, FALSE)
     FROM _tmpRes;

     -- сохранили протокол
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NPP_calc(), inMovementId, TRUE)
           , lpInsertUpdate_MovementDate    (zc_MovementDate_NPP_calc(),    inMovementId, CURRENT_TIMESTAMP)
            ;

     -- пересчитали Итоговые суммы по накладной - обязательно ПОСЛЕ сохранили протокол
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     IF inSession <> '5' OR 1=0
     THEN
         -- Результат
         RETURN;
     ELSE
         -- Результат
         RETURN QUERY
           SELECT _tmpRes.MovementItemId, _tmpRes.GoodsId, _tmpRes.GoodsKindId, _tmpRes.NPPTax_calc
                , CASE WHEN _tmpRes.AmountTax_calc > _tmpRes.Amount THEN _tmpRes.NPP_calc ELSE 0 END AS NPP_calc
                , _tmpRes.NPPTaxNew_calc
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
      LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                  ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                 AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
      LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                  ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                 AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
      LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                  ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                 AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
 WHERE Movement.OperDate >= '01.03.2018'
   AND Movement.DescId   = zc_Movement_TaxCorrective()
   AND Movement.StatusId = zc_Enum_Status_Complete()
   AND (MIFloat_NPPTax_calc.ValueData    <> 0
     OR MIFloat_NPP_calc.ValueData       <> 0
     OR MIFloat_AmountTax_calc.ValueData <> 0
       )
*/
-- тест
-- SELECT * FROM gpUpdate_MI_TaxCorrective_NPP_calc (inMovementId:= 16132903, inSession:= zfCalc_UserAdmin())
