-- Function: gpInsertUpdate_MovementItem_ServiceItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItem (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ServiceItem(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- отдел 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
    IN inDateEnd             TDateTime , --
    IN inAmount              TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inArea                TFloat    , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ServiceItem());

     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inUnitId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Отдел>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inInfoMoneyId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Статья>.';
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUnitId, inMovementId, inAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Area(), ioId, inArea);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), ioId, inCommentInfoMoneyId);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.22         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_ServiceItem (ioId := 56 , inMovementId := 17 , inUnitId := 446 , inPartionId := 50 , inAmount := 3 , ioCountForPrice := 1 , inOperPrice := 100 ,  inSession := '2');
