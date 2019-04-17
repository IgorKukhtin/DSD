-- Function: gpUpdate_MI_OrderInternalPromoChild()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternalPromoChild (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternalPromoChild(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId            Integer   , --
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- Подразделение
    IN inAmount              TFloat    , -- Количество из мастера
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
  
    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inUnitId, inMovementId, inAmount, inParentId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.04.19         *
*/