-- Function: lpInsertUpdate_MovementItem_TechnicalRediscount()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_TechnicalRediscount(Integer, Integer, Integer, TFloat, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_TechnicalRediscount(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inCommentTRID         Integer   , -- Комментарий
    IN isExplanation         TVarChar  , -- Пояснение
    IN isComment             TVarChar  , -- Комментарий 2
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
 DECLARE vbIsInsert Boolean;
BEGIN

     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, Null);

     -- Сохранили <Комментарий>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentTR(), ioId, inCommentTRID);
     -- Сохранили <Пояснение>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Explanation(), ioId, isExplanation);
     -- Сохранили <Комментарий 2>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, isComment);

     PERFORM lpUpdate_Movement_TechnicalRediscount_TotalDiff (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/

-- тест

