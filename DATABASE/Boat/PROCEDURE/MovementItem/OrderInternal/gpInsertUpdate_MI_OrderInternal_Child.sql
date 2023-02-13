-- Function: gpInsertUpdate_MI_OrderInternal_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderInternal_Child(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inObjectId               Integer   , -- Комплектующие 
    IN inReceiptLevelId         Integer   , -- Этап сборки
    IN inColorPatternId         Integer   , -- Шаблон Boat Structure 
    IN inProdColorPatternId     Integer   , -- Boat Structure  
    IN inProdOptionsId          Integer   , -- Опция
    IN inUnitId                 Integer   , -- Место учета
    IN inAmount                 TFloat    , -- Количество (шаблон сборки)
    IN inAmountReserv           TFloat    , -- Количество резерв
    IN inAmountSend             TFloat    , -- Кол-во приход от поставщ./перемещение
    IN inForCount               TFloat    , -- Для кол-во
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := lpGetUserBySession (inSession);


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MI_OrderInternal_Child (ioId                := ioId
                                               , inParentId          := inParentId
                                               , inMovementId        := inMovementId
                                               , inObjectId          := inObjectId
                                               , inReceiptLevelId    := inReceiptLevelId
                                               , inColorPatternId    := inColorPatternId
                                               , inProdColorPatternId:= inProdColorPatternId
                                               , inProdOptionsId     := inProdOptionsId
                                               , inUnitId            := inUnitId
                                               , inAmount            := inAmount
                                               , inAmountReserv      := inAmountReserv
                                               , inAmountSend        := inAmountSend
                                               , inForCount          := inForCount
                                               , inUserId            := vbUserId
                                                ) AS tmp;

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
 13.02.23         *
*/

-- тест
-- SELECT * FROM 