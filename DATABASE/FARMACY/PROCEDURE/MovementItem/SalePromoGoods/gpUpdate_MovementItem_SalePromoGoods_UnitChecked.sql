-- Function: gpInsertUpdate_MovementItem_SalePromoGoodsSign()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_SalePromoGoods_UnitChecked (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_SalePromoGoods_UnitChecked(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUnitId              Integer   , -- Подразделение
 INOUT ioIsChecked           Boolean   , -- отмечен
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
  
     -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (inId, 0) = 0;

    IF COALESCE(inId, 0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;
    
    ioIsChecked := NOT ioIsChecked;

    -- сохранили <Элемент документа>
    inId := lpInsertUpdate_MovementItem (inId, zc_MI_Sign(), inUnitId, inMovementId, (CASE WHEN ioIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat, NULL);
         
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.05.23                                                       *
*/

