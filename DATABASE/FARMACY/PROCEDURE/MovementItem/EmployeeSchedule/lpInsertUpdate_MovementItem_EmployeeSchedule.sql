-- Function: lpInsertUpdate_MovementItem_EmployeeSchedule()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_EmployeeSchedule (Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_EmployeeSchedule(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonId            Integer   , -- Сотрудник
    IN inComingValueDay      TVarChar  , -- Приходы на работу по дням
    IN inComingValueDayUser  TVarChar  , -- Приходы на работу по дням
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonId, inMovementId, 0, NULL);

    -- сохранили <приходы по дням>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComingValueDay(), ioId, inComingValueDay);

    -- сохранили <приходы по дням>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComingValueDayUser(), ioId, inComingValueDayUser);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 13.03.19         *
 09.12.18         *
*/