 -- Function: gpUpdate_Movement_Income_summ()

DROP FUNCTION IF EXISTS gpUpdate_IncomeEdit (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_summ (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Income_summ (Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Income_summ(
    IN inId                    Integer   , -- Ключ объекта <Документ>
    IN inIsBefore              Boolean   , -- временный расчет на форме, тогда промежуточно сохраняем в ..._calc
    IN inTotalSummMVAT         TFloat    , -- Сумма по элементам (без НДС, но с учетом скидки в элементах, если была)
 INOUT ioDiscountTax           TFloat    , -- 1.1. % скидки
 INOUT ioSummTaxPVAT           TFloat    , -- 1.2. Сумма скидки с НДС
 INOUT ioSummTaxMVAT           TFloat    , -- 1.2. Сумма скидки без НДС
    IN inSummPost              TFloat    , -- 2.1. Почтовые расходы, без НДС
    IN inSummPack              TFloat    , -- 2.2. Упаковка расходы, без НДС
    IN inSummInsur             TFloat    , -- 2.3. Страховка расходы, без НДС
 INOUT ioTotalDiscountTax      TFloat    , -- 3.1. % скидки итого
 INOUT ioTotalSummTaxPVAT      TFloat    , -- 3.3. Сумма скидки с НДС итого
 INOUT ioTotalSummTaxMVAT      TFloat    , -- 3.2. Сумма скидки без НДС итого
   OUT outSumm2                TFloat    , -- сумма без НДС, после п.1.
   OUT outSumm3                TFloat    , -- сумма без НДС, после п.2.
   OUT outSumm4                TFloat    , -- сумма без НДС, после п.3. -
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbVATPercent TFloat;
   DECLARE vbDiscountTax TFloat;
   DECLARE vbSummTaxMVAT TFloat;
   DECLARE vbSummTaxPVAT TFloat;
   DECLARE vbSummPost TFloat;
   DECLARE vbSummPack TFloat;
   DECLARE vbSummInsur TFloat;
   DECLARE vbTotalDiscountTax TFloat;
   DECLARE vbTotalSummTaxMVAT TFloat;
   DECLARE vbTotalSummTaxPVAT TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());
     vbUserId := lpGetUserBySession (inSession);


     -- проверка - документ должен быть сохранен
     IF COALESCE (inId, 0) = 0 THEN

        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Документ не сохранен.' :: TVarChar
                                              , inProcedureName := 'gpUpdate_Movement_Income_summ'   :: TVarChar
                                              , inUserId        := vbUserId);
     END IF;

    -- % НДС из шапки документа
    vbVATPercent := (SELECT MovementFloat_VATPercent.ValueData
                     FROM Movement AS Movement_Income
                         LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                 ON MovementFloat_VATPercent.MovementId = Movement_Income.Id
                                                AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                     WHERE Movement_Income.Id = inId
                       AND Movement_Income.DescId = zc_Movement_Income());

     -- если надо только сохранить
     IF inIsBefore = FALSE
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax(), inId, ioDiscountTax);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTaxPVAT(), inId, ioSummTaxPVAT);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTaxMVAT(), inId, ioSummTaxMVAT);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPost(), inId, inSummPost);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPack(), inId, inSummPack);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummInsur(), inId, inSummInsur);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiscountTax(), inId, ioTotalDiscountTax);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTaxMVAT(), inId, ioTotalSummTaxMVAT);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTaxPVAT(), inId, ioTotalSummTaxPVAT);

         -- Сумма с учетом скидки, без НДС
         outSumm2 := COALESCE (inTotalSummMVAT,0) - COALESCE (ioSummTaxMVAT,0) ;
         -- Итого сумма без НДС, с учетом расходов
         outSumm3 := COALESCE (outSumm2,0) + COALESCE (inSummPack,0) + COALESCE (inSummPost,0) + COALESCE (inSummInsur,0);
         -- Сумма с учетом скидки, без НДС
         outSumm4 := COALESCE (outSumm3,0) - COALESCE (ioTotalSummTaxPVAT,0);


         -- проверка что нужный статус + закрытие периода
         PERFORM lpInsertUpdate_Movement (Movement.Id, Movement.DescId, Movement.InvNumber, Movement.OperDate, Movement.ParentId, vbUserId) FROM Movement WHERE Movement.Id = inId;

         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

     ELSE

         -- Получаем сохраненные параметры - для расчета в эдит форме
         vbDiscountTax      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountTax_calc());
         vbSummTaxPVAT      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTaxPVAT_calc());
         vbSummTaxMVAT      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTaxMVAT_calc());
         --
         vbSummPost         := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummPost_calc());
         vbSummPack         := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummPack_calc());
         vbSummInsur        := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummInsur_calc());
         --
         vbTotalDiscountTax := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalDiscountTax_calc());
         vbTotalSummTaxMVAT := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSummTaxMVAT_calc());
         vbTotalSummTaxPVAT := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSummTaxPVAT_calc());


         -- если ничего не поменялось
         IF vbDiscountTax = ioDiscountTax AND vbSummTaxMVAT = ioSummTaxMVAT AND vbSummTaxPVAT = ioSummTaxPVAT
            AND vbSummPost = inSummPost AND vbSummPack = inSummPack AND vbSummInsur = inSummInsur
            AND vbTotalDiscountTax = ioTotalDiscountTax AND vbTotalSummTaxMVAT = ioTotalSummTaxMVAT AND vbTotalSummTaxPVAT = ioTotalSummTaxPVAT
         THEN
             -- Сумма с учетом скидки, без НДС
             outSumm2 := COALESCE (inTotalSummMVAT,0) - COALESCE (ioSummTaxMVAT,0) ;
             -- Итого сумма без НДС, с учетом расходов
             outSumm3 := COALESCE (outSumm2,0) + COALESCE (inSummPack,0) + COALESCE (inSummPost,0) + COALESCE (inSummInsur,0);
             -- Сумма с учетом скидки, без НДС
             outSumm4 := COALESCE (outSumm3,0) - COALESCE (ioTotalSummTaxPVAT,0);

             -- !!!выход!!!
             RETURN;

         END IF;

         -- изменился % скидки
         IF COALESCE (vbDiscountTax,0) <> COALESCE (ioDiscountTax,0)
         THEN
             -- расчет Сумма скидки без НДС
             ioSummTaxMVAT := zfCalc_SummDiscount(inTotalSummMVAT, ioDiscountTax);
             -- расчет Сумма скидки с НДС
             ioSummTaxPVAT := zfCalc_SummWVAT (ioSummTaxMVAT, vbVATPercent);

         -- изменилась Сумма скидки без НДС
         ELSEIF COALESCE (vbSummTaxMVAT,0) <> COALESCE (ioSummTaxMVAT,0)
         THEN
             -- расчет Сумма скидки с НДС
             ioSummTaxPVAT := zfCalc_SummWVAT (ioSummTaxMVAT, vbVATPercent);
             -- расчет % скидки
             ioDiscountTax := zfCalc_DiscountTax (ioSummTaxMVAT, inTotalSummMVAT);

         -- изменилась Сумма скидки с НДС
         ELSEIF COALESCE (vbSummTaxPVAT,0) <> COALESCE (ioSummTaxPVAT,0)
         THEN
             -- расчет Сумма скидки без НДС
             ioSummTaxMVAT := zfCalc_Summ_NoVAT (ioSummTaxPVAT, vbVATPercent);
             -- расчет % скидки
             ioDiscountTax := zfCalc_DiscountTax (ioSummTaxMVAT, inTotalSummMVAT);

         END IF;

         -- Сумма с учетом скидки, без НДС
         outSumm2 := COALESCE (inTotalSummMVAT,0) - COALESCE (ioSummTaxMVAT,0) ;
         -- Итого сумма без НДС, с учетом расходов
         outSumm3 := COALESCE (outSumm2,0) + COALESCE (inSummPack,0) + COALESCE (inSummPost,0) + COALESCE (inSummInsur,0);


         -- изменился % скидки
         IF COALESCE (vbTotalDiscountTax,0) <> COALESCE (ioTotalDiscountTax,0)
         THEN
             -- расчет Сумма скидки без НДС
             ioTotalSummTaxMVAT := zfCalc_SummDiscount(outSumm3, ioTotalDiscountTax);
             -- расчет Сумма скидки с НДС
             ioTotalSummTaxPVAT := zfCalc_SummWVAT (ioTotalSummTaxMVAT, vbVATPercent);

         -- изменилась Сумма скидки без НДС
         ELSEIF COALESCE (vbTotalSummTaxMVAT,0) <> COALESCE (ioTotalSummTaxMVAT,0)
         THEN
             -- расчет Сумма скидки с НДС
             ioTotalSummTaxPVAT := zfCalc_SummWVAT (ioTotalSummTaxMVAT, vbVATPercent);
             -- расчет % скидки
             ioTotalDiscountTax := zfCalc_DiscountTax (ioTotalSummTaxMVAT, outSumm3);

         -- изменилась Сумма скидки с НДС
         ELSEIF COALESCE (vbTotalSummTaxPVAT,0) <> COALESCE (ioTotalSummTaxPVAT,0)
         THEN
             -- расчет Сумма скидки без НДС
             ioTotalSummTaxMVAT := zfCalc_Summ_NoVAT (ioTotalSummTaxPVAT, vbVATPercent);
             -- расчет % скидки
             ioTotalDiscountTax := zfCalc_DiscountTax (ioTotalSummTaxMVAT, outSumm3);
         END IF;


         -- Сумма с учетом скидки, без НДС
         outSumm4 := COALESCE (outSumm3,0) - COALESCE (ioTotalSummTaxMVAT,0);

         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DiscountTax_calc(), inId, ioDiscountTax);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTaxPVAT_calc(), inId, ioSummTaxPVAT);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummTaxMVAT_calc(), inId, ioSummTaxMVAT);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPost_calc(), inId, inSummPost);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPack_calc(), inId, inSummPack);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummInsur_calc(), inId, inSummInsur);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDiscountTax_calc(), inId, ioTotalDiscountTax);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTaxMVAT_calc(), inId, ioTotalSummTaxMVAT);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTaxPVAT_calc(), inId, ioTotalSummTaxPVAT);

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.10.21         *
*/

-- тест
--
