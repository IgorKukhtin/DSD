-- Function: gpInsertUpdate_MI_SendPartionDate_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_SendPartionDate_Child (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_SendPartionDate_Child(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId              Integer   , --
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    --IN inPartionDateKindId     Integer   , -- 
    IN inExpirationDate        TDateTime ,
    IN inExpirationDate_in     TDateTime ,
   OUT outisExpirationDateDiff Boolean   ,
    IN inAmount                TFloat    , -- Количество
    IN inContainerId           TFloat    , -- 
    IN inMovementId_Income     TFloat    , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendPartionDate());
    vbUserId := inSession;

    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inGoodsId, inMovementId, inAmount, inParentId);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);
    -- сохранили <цену>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_Income);
    
    -- сохранили <>
    --PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), ioId, inPartionDateKindId);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ExpirationDate(), ioId, inExpirationDate);
    
    -- пересчитали Итоговые суммы по накладной
    --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    outisExpirationDateDiff := CASE WHEN inExpirationDate <> inExpirationDate_in THEN TRUE ELSE FALSE END;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.19         *
 03.04.19         *
*/