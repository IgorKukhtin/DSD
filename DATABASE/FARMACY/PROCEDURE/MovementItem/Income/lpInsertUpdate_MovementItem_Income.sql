-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, TVarChar, TFloat, TFloat, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsName           TVarChar  , -- Наименование товара
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inFEA                 TVarChar  , -- УК ВЭД
    IN inMeasure             TVarChar  , -- Ед. измерения
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_FEA(), ioId, inFEA);

     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Measure(), ioId, inMeasure);

     IF COALESCE(inGoodsName, '') <> '' THEN
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GoodsName(), ioId, inGoodsName);
     END IF;
     
     IF length(REPLACE(REPLACE(REPLACE(inFEA, ' ', ''), '.', ''), Chr(160), '')) >= 4 AND 
        length(REPLACE(REPLACE(REPLACE(inFEA, ' ', ''), '.', ''), Chr(160), '')) <= 10
     THEN
       PERFORM gpUpdate_Goods_CodeUKTZED (inGoodsId, inFEA, inUserId::TVarChar);
     END IF;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 11.05.18                                                                      * 
 06.03.14                        *
 07.12.14                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inGoodsName = '', inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')