-- Function: lpInsertUpdate_MovementItem_Loyalty_GUID()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Loyalty_GUID (Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Loyalty_GUID(
    IN inMovementItemId      Integer   , -- Ключ объекта <Документ>
    IN inGUID                TVarChar  , -- GUID
    IN inUserId              Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
BEGIN
    -- определяется признак Создание/Корректировка
    IF COALESCE (inMovementItemId, 0) = 0 
    THEN
       RAISE EXCEPTION 'Содержимое документа не сохранено.';    
    END IF;

    IF EXISTS(SELECT 1 FROM MovementItem_Loyalty_GUID WHERE MovementItem_Loyalty_GUID.MovementItemId = inMovementItemId)    
    THEN
      UPDATE MovementItem_Loyalty_GUID SET GUID = inGUID WHERE MovementItem_Loyalty_GUID.MovementItemId = inMovementItemId;
    ELSE
      INSERT INTO MovementItem_Loyalty_GUID (MovementItemId, GUID) VALUES (inMovementItemId, inGUID);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *
*/