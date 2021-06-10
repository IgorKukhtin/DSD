-- Function: gpInsertUpdate_MovementItem_OrderClient()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderClient(Integer, Integer, Integer, TFloat, TFloat, TFloat,TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderClient(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderClient(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
 INOUT ioOperPrice           TFloat    , -- Цена со скидкой
    IN inOperPriceList       TFloat    , -- Цена без скидки
    IN inBasisPrice          TFloat    , -- Цена базовая
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderClient());
     vbUserId := lpGetUserBySession (inSession);


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     SELECT tmp.ioId, tmp.ioOperPrice
            INTO ioId , ioOperPrice
     FROM lpInsertUpdate_MovementItem_OrderClient (ioId
                                                 , inMovementId
                                                 , inGoodsId
                                                 , inAmount
                                                 , ioOperPrice
                                                 , inOperPriceList
                                                 , inBasisPrice
                                                 , inCountForPrice
                                                 , inComment
                                                 , vbUserId
                                                 ) AS tmp;


     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderClient (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
