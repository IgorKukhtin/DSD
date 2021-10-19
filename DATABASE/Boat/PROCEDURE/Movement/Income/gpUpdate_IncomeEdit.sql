 -- Function: gpUpdate_MI_Income_Price()

DROP FUNCTION IF EXISTS gpUpdate_IncomeEdit (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_IncomeEdit(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inTotalSummMVAT         TFloat    , -- 
 INOUT ioDiscountTax           TFloat    , -- 
 INOUT ioSummTaxMVAT           TFloat    , -- 
 INOUT ioSummTaxPVAT           TFloat    , -- 
    IN inSummPost              TFloat    , -- 
    IN inSummPack              TFloat    , -- 
    IN inSummInsur             TFloat    , -- 
 INOUT ioTotalDiscountTax      TFloat    , -- 
 INOUT ioTotalSummTaxMVAT      TFloat    , -- 
 INOUT ioTotalSummTaxPVAT      TFloat    , -- 
   OUT outSumm2                TFloat    , -- 
   OUT outSumm3                TFloat    , -- 
   OUT outSumm4                TFloat    , -- 
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

        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Элемент не сохранен.' :: TVarChar
                                              , inProcedureName := 'gpUpdate_IncomeEdit'   :: TVarChar
                                              , inUserId        := vbUserId);
     END IF;

    --% НДС из шапки документа
    vbVATPercent := (SELECT MovementFloat_VATPercent.ValueData 
                     FROM Movement AS Movement_Income
                         LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                 ON MovementFloat_VATPercent.MovementId = Movement_Income.Id
                                                AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                     WHERE Movement_Income.Id = inId
                       AND Movement_Income.DescId = zc_Movement_Income());

     -- Получаем сохраненные параметры
     --vbTotalSummMVAT    := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSummMVAT());
     vbDiscountTax      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_DiscountTax());
     vbSummTaxMVAT      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTaxMVAT());
     vbSummTaxPVAT      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummTaxPVAT());
     vbSummPost         := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummPost());
     vbSummPack         := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummPack());
     vbSummInsur        := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_SummInsur());
     vbTotalDiscountTax := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalDiscountTax());
     vbTotalSummTaxMVAT := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSummTaxMVAT());
     vbTotalSummTaxPVAT := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inId AND MF.DescId = zc_MovementFloat_TotalSummTaxPVAT());

--RAISE EXCEPTION '0. vbPravilo <%> ' , vbPravilo;
     
     -- если ничего не поменялось сразу выходим
     IF vbDiscountTax = ioDiscountTax AND vbSummTaxMVAT = ioSummTaxMVAT AND vbSummTaxPVAT = ioSummTaxPVAT 
    AND vbSummPost = inSummPost AND vbSummPack = inSummPack AND vbSummInsur = inSummInsur
    AND vbTotalDiscountTax = ioTotalDiscountTax AND vbTotalSummTaxMVAT = ioTotalSummTaxMVAT AND vbTotalSummTaxPVAT = ioTotalSummTaxPVAT
     THEN
         RETURN;
     END IF;
     
     --определяем что поменялось
     IF COALESCE (vbDiscountTax,0) <> COALESCE (ioDiscountTax,0)
     THEN
        ioSummTaxPVAT := (inTotalSummMVAT / 100 * ioDiscountTax);
        ioSummTaxMVAT := zfCalc_SummWVAT (ioSummTaxPVAT, vbVATPercent);
     END IF;

     IF COALESCE (vbSummTaxPVAT,0) <> COALESCE (ioSummTaxPVAT,0)
     THEN
         ioDiscountTax := CAST ((CASE WHEN inTotalSummMVAT <> 0 THEN ioSummTaxPVAT*100 / inTotalSummMVAT ELSE 0 END) AS NUMERIC (16,1));
         ioSummTaxMVAT := zfCalc_SummWVAT (ioSummTaxPVAT, vbVATPercent);
     END IF; 

     IF COALESCE (vbSummTaxMVAT,0) <> COALESCE (ioSummTaxMVAT,0)
     THEN
         ioSummTaxPVAT := zfCalc_Summ_NoVAT (ioSummTaxMVAT, vbVATPercent);
         ioDiscountTax := CAST ((CASE WHEN inTotalSummMVAT <> 0 THEN ioSummTaxPVAT*100 / inTotalSummMVAT ELSE 0 END) AS NUMERIC (16,1));
     END IF; 

     outSumm2 := COALESCE (inTotalSummMVAT,0) - COALESCE (ioSummTaxPVAT,0);
     outSumm3 := COALESCE (outSumm2,0) + COALESCE (inSummPack,0) + COALESCE (inSummPost,0) + COALESCE (inSummInsur,0);

     IF COALESCE (vbTotalDiscountTax,0) <> COALESCE (ioTotalDiscountTax,0)
     THEN
         ioTotalSummTaxPVAT := (outSumm3 / 100 * ioTotalDiscountTax);
         ioTotalSummTaxMVAT := zfCalc_SummWVAT (ioTotalSummTaxPVAT, vbVATPercent);
     END IF;

     IF COALESCE (vbTotalSummTaxPVAT,0) <> COALESCE (ioTotalSummTaxPVAT,0)
     THEN
         ioTotalDiscountTax := CAST ((CASE WHEN outSumm3 <> 0 THEN ioTotalSummTaxPVAT * 100 / outSumm3 ELSE 0 END) AS NUMERIC (16,1));
         ioTotalSummTaxMVAT := zfCalc_SummWVAT (ioTotalSummTaxPVAT, vbVATPercent);
     END IF;

     IF COALESCE (vbTotalSummTaxMVAT,0) <> COALESCE (ioTotalSummTaxMVAT,0)
     THEN
         ioTotalSummTaxPVAT := zfCalc_Summ_NoVAT (ioTotalSummTaxMVAT, vbVATPercent);
         ioTotalDiscountTax := CAST ((CASE WHEN outSumm3 <> 0 THEN ioTotalSummTaxPVAT*100 / outSumm3 ELSE 0 END) AS NUMERIC (16,1));
     END IF; 

     outSumm4 := COALESCE (outSumm3,0) - COALESCE (ioTotalSummTaxPVAT,0);

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
