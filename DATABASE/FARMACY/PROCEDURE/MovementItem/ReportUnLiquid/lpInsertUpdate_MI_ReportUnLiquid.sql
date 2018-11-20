-- Function: lpInsertUpdate_MI_ReportUnLiquid()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ReportUnLiquid (Integer, Integer, Integer
                                                                  , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                  , TDateTime, TDateTime, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ReportUnLiquid (Integer, Integer, Integer
                                                                  , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                  , TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ReportUnLiquid(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- 
    IN inRemainsStart        TFloat    , --
    IN inRemainsEnd          TFloat    , --
    IN inAmountM1            TFloat    , --
    IN inAmountM3            TFloat    , --
    IN inAmountM6            TFloat    , --
    IN inAmountIncome        TFloat    , --
    IN inSumm                TFloat    , --
    IN inSummStart           TFloat    , --
    IN inSummEnd             TFloat    , --
    IN inSummM1              TFloat    , --
    IN inSummM3              TFloat    , --
    IN inSummM6              TFloat    , --
    IN inDateIncome          TDateTime , -- 
    IN inMinExpirationDate   TDateTime , -- 
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
BEGIN

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsStart(), ioId, inRemainsStart);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RemainsEnd(), ioId, inRemainsEnd);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountM1(), ioId, inAmountM1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountM3(), ioId, inAmountM3);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountM6(), ioId, inAmountM6);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Income(), ioId, inAmountIncome);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), ioId, inSumm);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummStart(), ioId, inSummStart);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummEnd(), ioId, inSummEnd);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummM1(), ioId, inSummM1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummM3(), ioId, inSummM3);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummM6(), ioId, inSummM6);
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Income(), ioId, inDateIncome);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_MinExpirationDate(), ioId, inMinExpirationDate);
     
     -- сохранили свойство <>
     --PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);



     -- сохранили протокол
     --PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.18         *
*/

-- тест
--