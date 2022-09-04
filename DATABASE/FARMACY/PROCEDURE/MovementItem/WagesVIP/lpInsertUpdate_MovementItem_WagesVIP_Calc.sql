-- Function: lpInsertUpdate_MovementItem_WagesVIP_Calc()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesVIP_Calc (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesVIP_Calc(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserWagesId         Integer   , -- Сотрудник
    IN inAmountAccrued       TFloat    , -- Начисленная З/П сотруднику	
    IN inApplicationAward    TFloat    , -- Премия за приложение
    IN inHoursWork           TFloat    , -- Отработано часов
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserWagesId, inMovementId, inAmountAccrued, NULL);

    -- сохранили свойство <Отработано часов>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HoursWork(), ioId, inHoursWork);    

    -- сохранили свойство <Премия за приложение>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ApplicationAward(), ioId, inApplicationAward);    

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.09.21                                                        *
*/