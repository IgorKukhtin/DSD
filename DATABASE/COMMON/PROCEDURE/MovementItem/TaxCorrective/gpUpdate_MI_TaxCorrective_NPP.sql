-- Function: gpUpdate_MI_TaxCorrective_NPP()

DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_NPP (Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TaxCorrective_NPP(
    IN inId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inLineNumTaxCorr_calc  TFloat    , -- № п/п НН-Корр.(налог.)
    IN inLineNumTaxCorr       TFloat    , -- № п/п НН-Корр.
    IN inAmountTax_calc       TFloat    , -- Кол-во для НН-Корр.(налог.)
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_TaxCorrective_NPP());

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPPTax_calc(), inId, inLineNumTaxCorr_calc);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP_calc(), inId, inLineNumTaxCorr);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTax_calc(), inId, inAmountTax_calc);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.18         *
*/

-- тест
--