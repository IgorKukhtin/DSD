-- Function: gpUpdate_MI_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_Price(Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Price(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsMainId         Integer   , -- Товары
    IN inAmount              TFloat    , -- Цена
    IN inPercent             TFloat    , -- % скидки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_PriceList());
     vbUserId := inSession;


     -- обновили цену в <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsMainId, inMovementId, inAmount, NULL);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.12.16         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Price (inId:= 0, inMovementId:= 10, inGoodsMainId:= 1, inAmount:= 0, inSession:= '2')
