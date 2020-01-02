-- Function: lpInsertUpdate_MovementItem_LoyaltySaveMoney()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_LoyaltySaveMoney (Integer, Integer, Integer, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_LoyaltySaveMoney(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inBuyerID             Integer   , -- сумма скидки
    IN inComment             TVarChar  , -- повторов
    IN inUnitID              Integer   , -- повторов
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbAmount TFloat;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    IF vbIsInsert = FALSE
    THEN
      SELECT MovementItem.Amount
      INTO vbAmount
      FROM MovementItem
      WHERE MovementItem.ID = ioId;
    ELSE
      vbAmount := 0;
    END IF;

    IF COALESCE(inBuyerID, 0) = 0
    THEN
       RAISE EXCEPTION 'Ошибка. Не заполнен покупатель.';
    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.ID <> COALESCE (ioId, 0)
                                           AND MovementItem.MovementId = inMovementId
                                           AND MovementItem.ObjectID = inBuyerID)
    THEN
       RAISE EXCEPTION 'Ошибка. По покупателю может быть только одна запись в программе.';
    END IF;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inBuyerID, inMovementId, vbAmount, NULL, zc_Enum_Process_Auto_PartionClose());

    -- сохранили свойство <Примечание>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
    -- сохранили связь с <Аптекой>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitID);

    IF vbIsInsert = TRUE
    THEN
        -- сохранили связь с <>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
    ELSE
        -- сохранили связь с <>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.12.19                                                       *
 */