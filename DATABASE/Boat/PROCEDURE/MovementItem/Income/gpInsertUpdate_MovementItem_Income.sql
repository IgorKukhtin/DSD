-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income(Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPartionId           Integer   , -- Партия
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inOperPrice           TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inPartNumber          TVarChar  , --№ по тех паспорту
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_Income (ioId
                                               , inMovementId
                                               , inPartionId
                                               , inGoodsId
                                               , inAmount
                                               , inOperPrice
                                               , inCountForPrice
                                               , inPartNumber
                                               , inComment
                                               , vbUserId
                                               );

                  
     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.02.21         *
*/

-- тест
-- 