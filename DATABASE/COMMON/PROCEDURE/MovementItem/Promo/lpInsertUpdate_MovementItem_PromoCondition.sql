-- Function: lpInsertUpdate_MovementItem_PromoCondition()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PromoCondition(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inConditionPromoId    Integer   , -- Ключ объекта <Условие участия в акции>
    IN inAmount              TFloat    , -- % скидки на товар
    IN inComment             TVarChar  , -- Комментарий
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inConditionPromoId, inMovementId, inAmount, NULL);

    --Сохранили <комментарий>
    PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А,
 05.11.15                                                                       *
 */