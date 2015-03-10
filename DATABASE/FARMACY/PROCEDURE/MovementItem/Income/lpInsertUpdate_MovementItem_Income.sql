-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inFEA                 TVarChar  , -- УК ВЭД
    IN inMeasure             TVarChar  , -- Ед. измерения
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_FEA(), ioId, inFEA);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Measure(), ioId, inMeasure);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.03.14                        *
 07.12.14                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
