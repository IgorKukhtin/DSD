 -- Function: lpUpdate_MI_Income_Price()

DROP FUNCTION IF EXISTS lpUpdate_MI_Income_Price (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_Income_Price(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inAmount              TFloat    , -- 
    IN inOperPrice_orig      TFloat    , -- Вх. цена без скидки
    IN inCountForPrice       TFloat    , -- Цена за кол.
 INOUT ioDiscountTax         TFloat    , -- % скидки
 INOUT ioOperPrice           TFloat    , -- Вх. цена с учетом скидки в элементе
 INOUT ioSummIn              TFloat    , -- Сумма вх. с учетом скидки
    IN inAmount_old          TFloat    , --
    IN inOperPrice_orig_old  TFloat    , --
    IN inDiscountTax_old     TFloat    , --
    IN inOperPrice_old       TFloat    , --
    IN inSummIn_old          TFloat    , --
    IN inUserId              Integer    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN

     -- Пересчитали
     SELECT gpGet.ioDiscountTax, gpGet.ioOperPrice, gpGet.ioSummIn
            INTO ioDiscountTax, ioOperPrice, ioSummIn
     FROM gpGet_MI_Income_Price (ioAmount              := inAmount
                               , ioOperPrice_orig      := inOperPrice_orig
                               , inCountForPrice       := inCountForPrice
                               , ioDiscountTax         := ioDiscountTax
                               , ioOperPrice           := ioOperPrice
                               , ioSummIn              := ioSummIn
                               , inAmount_old          := inAmount_old
                               , inOperPrice_orig_old  := inOperPrice_orig_old
                               , inDiscountTax_old     := inDiscountTax_old
                               , inOperPrice_old       := inOperPrice_old
                               , inSummIn_old          := inSummIn_old
                               , inSession             := inUserId :: TVarChar
                                ) AS gpGet;
     

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_orig(), inId, inOperPrice_orig);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), inId, inCountForPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DiscountTax(), inId, ioDiscountTax);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), inId, ioOperPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummIn(), inId, ioSummIn);

     RAISE EXCEPTION 'Ошибка.<%>', ioSummIn;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm ((SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inId));

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
