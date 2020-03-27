-- Function: gpUpdate_MI_TaxCorrective_NPP()

DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TaxCorrective_NPP(
    IN inId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inLineNumTaxCorr_calc  TFloat    , -- № п/п НН-Корр.(налог.)
    IN inLineNumTaxCorr       TFloat    , -- № п/п НН-Корр.
    IN inLineNumTaxNew        TFloat    , -- № п/п Корр. ц.
    IN inAmountTax_calc       TFloat    , -- Кол-во для НН-Корр.(налог.)
    IN inSummTaxDiff_calc     TFloat    , -- Сумма КОРРЕКТИРОВКИ для НН-Корр.(налог.) 
    IN inPriceTax_calc        TFloat    , -- Цена для НН-Корр.цены(налог.)
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_TaxCorrective_NPP());
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());


     -- Проверка - Статус
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                        AND Movement.StatusId <> zc_Enum_Status_UnComplete()
                WHERE MovementItem.Id = inId
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.'
                       , (SELECT Movement.InvNumber
                          FROM MovementItem
                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                  AND Movement.StatusId <> zc_Enum_Status_UnComplete()
                          WHERE MovementItem.Id = inId
                         )
                       , lfGet_Object_ValueData ((SELECT Movement.StatusId
                                                  FROM MovementItem
                                                       INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                          AND Movement.StatusId <> zc_Enum_Status_UnComplete()
                                                  WHERE MovementItem.Id = inId
                                                ))
         ;
     END IF;


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(), inId, inLineNumTaxCorr_calc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP_calc(), inId, inLineNumTaxCorr);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(), inId, inAmountTax_calc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTaxDiff_calc(), inId, inSummTaxDiff_calc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceTax_calc(), inId, inPriceTax_calc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTaxNew_calc(), inId, inLineNumTaxNew);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.03.20         * add inLineNumTaxNew
 12.04.18         * add PriceTax_calc
 04.04.18         * add inSummTaxDiff_calc
 30.03.18         *
*/

-- тест
--