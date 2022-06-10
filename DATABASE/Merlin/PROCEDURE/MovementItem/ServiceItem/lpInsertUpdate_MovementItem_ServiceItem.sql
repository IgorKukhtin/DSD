-- Function: lpInsertUpdate_MovementItem_ServiceItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ServiceItem (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ServiceItem(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- отдел 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
    IN inDateEnd             TDateTime , --
    IN inAmount              TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inArea                TFloat    , -- 
    IN inUserId              Integer    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <ццц>.';
        
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

     --проверка для ServiceItemAdd
     IF (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId) = zc_Movement_ServiceItemAdd()
     THEN   
         IF NOT EXISTS (SELECT 1 FROM gpSelect_MovementItem_ServiceItem_onDate (inOperDate := inDateEnd ::TDateTime
                                                                              , inUnitId   := inUnitId
                                                                              , inSession  := inUserId  ::TVarChar
                                                                               ) AS tmpMI_Main 
                        WHERE tmpMI_Main.InfoMoneyId = inInfoMoneyId
                        )
         THEN   
              RAISE EXCEPTION 'Ошибка.Не найдено Основное условие аренды для <%> <%>', lfGet_Object_TreeNameFull (inUnitId  ,zc_ObjectLink_Unit_Parent()), lfGet_Object_ValueData (inInfoMoneyId); 
         END IF;
     END IF;
     
     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUnitId, inMovementId, inAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Area(), ioId, inArea);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_DateEnd(), ioId, inDateEnd);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_CommentInfoMoney(), ioId, inCommentInfoMoneyId);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

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
