-- Function: lpInsertUpdate_MovementItem_LossPersonal ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LossPersonal (Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_LossPersonal(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- ключ Документа
    IN inPersonalId             Integer   , -- Сотрудник 
    IN inAmount                 TFloat    , -- Сумма Корректировки
    IN inBranchId               Integer   , -- Филиал
    IN inInfoMoneyId            Integer   , -- Статьи назначения
    IN inPositionId             Integer   , -- Должность
    IN inPersonalServiceListId  Integer   , -- Ведомость начисления
    IN inUnitId                 Integer   , -- Подразделение
    IN inComment                TVarChar  , -- Примечание
    IN inUserId                 Integer     -- Пользователь
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF COALESCE (inPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлен <Сотрудник>.';
     END IF;
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлена <УП статья назначения>.';
     END IF;
     IF COALESCE (inUnitId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено <Подразделение>.';
     END IF;
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлена <Должность>.';
     END IF;
     IF COALESCE (inPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлена <Ведомость начисления>.';
     END IF;
     IF COALESCE (inBranchId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлена <Ведомость начисления>.';
     END IF;
     
     -- проверка
     IF EXISTS (SELECT MovementItem.Id
                FROM MovementItem
                     JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                                                AND MILinkObject_InfoMoney.ObjectId = inInfoMoneyId
                     JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                 ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                AND MILinkObject_Unit.ObjectId = inUnitId
                     JOIN MovementItemLinkObject AS MILinkObject_Position
                                                 ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                                AND MILinkObject_Position.ObjectId = inPositionId
                     JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                 ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList()
                                                AND MILinkObject_PersonalServiceList.ObjectId = inPersonalServiceListId   
                     JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                 ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                                AND MILinkObject_Branch.ObjectId = inBranchId
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.ObjectId = inPersonalId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.Id <> COALESCE (ioId, 0)
                  AND MovementItem.isErased = FALSE
                )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе уже существует <%> <%> <%> <%> <%> <%>.Дублирование запрещено.', lfGet_Object_ValueData (inPersonalId)
                                                                                                            , lfGet_Object_ValueData (inPositionId)
                                                                                                            , lfGet_Object_ValueData (inPersonalServiceListId)
                                                                                                            , lfGet_Object_ValueData (inInfoMoneyId)
                                                                                                            , lfGet_Object_ValueData (inBranchId)
                                                                                                            , lfGet_Object_ValueData (inUnitId);
     END IF;

 

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, inAmount, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioId, inBranchId);
     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- сохранили связь с <Подразделение>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- пересчитали Итоговые суммы по документу
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.02.18         *
*/

-- тест
-- 