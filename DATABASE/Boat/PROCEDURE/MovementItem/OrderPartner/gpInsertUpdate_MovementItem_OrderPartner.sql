-- Function: gpInsertUpdate_MovementItem_OrderPartner()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderPartner(Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderPartner(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
 INOUT ioOperPrice           TFloat    , -- Цена со скидкой
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderPartner());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     SELECT tmp.ioId, tmp.ioOperPrice
            INTO ioId , ioOperPrice
     FROM lpInsertUpdate_MovementItem_OrderPartner (ioId
                                                  , inMovementId
                                                  , inGoodsId
                                                  , inAmount
                                                  , ioOperPrice
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
 12.04.21         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
