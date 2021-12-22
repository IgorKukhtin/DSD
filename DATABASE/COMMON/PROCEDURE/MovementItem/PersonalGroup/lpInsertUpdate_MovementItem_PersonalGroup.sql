-- Function: lpInsertUpdate_MovementItem_PersonalGroup()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalGroup(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inPersonalId            Integer   , -- Сотрудники
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , --
    IN inWorkTimeKindId        Integer   , --
    IN inAmount                TFloat    , -- 
    IN inUserId                Integer     -- пользователь
)                               
RETURNS Integer AS               
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохрнен.';
     END IF;

     -- проверка уникальности
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                                       ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                                      AND MILinkObject_Position.ObjectId = inPositionId
                     INNER JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                      ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                                     AND MILinkObject_PositionLevel.ObjectId = inPositionLevelId
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.Id <> ioId
                  AND MovementItem.ObjectId = inPersonalId
                )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе уже существует <%> <%> <%>.Дублирование запрещено.', lfGet_Object_ValueData (inPersonalId), lfGet_Object_ValueData (inPositionId), lfGet_Object_ValueData (inPositionLevelId);
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, inAmount, NULL);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_WorkTimeKind(), ioId, inWorkTimeKindId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.21         *
*/

-- тест
-- 