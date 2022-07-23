-- Function: gpUpdate_MI_GoodsSPSearch_1303_Order()

DROP FUNCTION IF EXISTS gpUpdate_MI_GoodsSPSearch_1303_Order (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_GoodsSPSearch_1303_Order(
    IN inId                  Integer   ,    -- Ключ объекта <Элемент документа>
    IN inOrderNumberSP       Integer   ,    -- № накау, в якому внесено ЛЗ(Соц. проект)(12)
    IN inOrderDateSP         TDateTime ,    -- Дата наказу, в якому внесено ЛЗ(Соц. проект)(12)
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    IF COALESCE (inId, 0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';    
    END IF;
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OrderNumberSP(), inId, inOrderNumberSP);

    -- сохранили <>
    PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OrderDateSP(), inId, inOrderDateSP);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.07.22                                                       *
*/
-- select * from gpUpdate_MI_GoodsSPSearch_1303_Order(inId := 523696543 , inMovementId := 28341113 , inGoodsID := 12006218 , inCol := 6995 ,  inSession := '3');