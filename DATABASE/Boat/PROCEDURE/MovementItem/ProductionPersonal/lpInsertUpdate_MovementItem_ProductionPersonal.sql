-- Function: gpInsertUpdate_MovementItem_ProductionPersonal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionPersonal(Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionPersonal(Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ProductionPersonal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalId          Integer   , -- 
    IN inProductId           Integer   , --
    IN inGoodsId             Integer   , -- 
    IN inStartBegin          TDateTime ,
    IN inEndBegin            TDateTime ,
    IN inAmount              TFloat    , -- Количество
    IN inComment             TVarChar  ,
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Product(), ioId, inProductId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_StartBegin(), ioId, inStartBegin);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EndBegin(), ioId, inEndBegin);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- сохранили свойство <примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     END IF;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.12.22         *
 13.07.21         *
*/

-- тест
--