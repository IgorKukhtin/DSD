-- Function: lpInsertUpdate_MovementItem_ServiceItemAdd()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ServiceItemAdd(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- отдел 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
    IN inDateStart           TDateTime , --
    IN inDateEnd             TDateTime , --
    IN inAmount              TFloat    , -- 
    IN inUserId              Integer    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
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

     --переопределяем Нач. дата всегда 1 число месяца, конечная  - последнее
     inDateStart := DATE_TRUNC ('Month',inDateStart);
     inDateEnd   := DATE_TRUNC ('Month',inDateEnd + INTERVAL '1 Month') - INTERVAL '1 DAY';
     
     -- проверка для ServiceItemAdd
     IF (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId) = zc_Movement_ServiceItemAdd()
     THEN   
         IF NOT EXISTS (SELECT 1 FROM gpSelect_MovementItem_ServiceItem_onDate (inOperDate   := inDateStart ::TDateTime
                                                                              , inUnitId     := inUnitId
                                                                              , inInfoMoneyId:= inInfoMoneyId
                                                                              , inSession    := inUserId  ::TVarChar
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
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_DateStart(), ioId, inDateStart); 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_DateEnd(), ioId, inDateEnd);
     -- Здесь дата
     --PERFORM lpInsertUpdate_Movement (inMovementId, zc_Movement_ServiceItem(), (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId), inDateEnd, NULL, inUserId);


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
--