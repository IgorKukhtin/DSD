-- Function: gpInsertUpdate_MovementItem_PriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceList(Integer, Integer, Integer, TFloat, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PriceList(Integer, Integer, Integer, Integer, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PriceList(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsMainId         Integer   , -- Товары
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPartionGoodsDate    TDateTime , -- Партия товара
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_PriceList());
     vbUserId := inSession;

     PERFORM lpInsertUpdate_MovementItem_PriceList(ioId, inMovementId, inGoodsMainId, 
                 inGoodsId, inAmount, inPartionGoodsDate, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.09.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PriceList (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
