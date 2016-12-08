-- Function: gpUpdate_MI_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_Price(Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Price(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
 INOUT ioAmount              TFloat    , -- Цена
    IN inPercent             TFloat    , -- % скидки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
   --DECLARE vbAmount TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_PriceList());
     vbUserId := inSession;

     ioAmount :=  CAST ((ioAmount + (ioAmount * inPercent / 100)) ::NUMERIC (16, 2) AS TFloat);

     -- обновили цену в <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, ioAmount, NULL);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.09.14                         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Price (inId:= 0, inMovementId:= 10, inGoodsId:= 1, ioAmount:= 0, inPercent := inSession:= '2')