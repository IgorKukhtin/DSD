-- Function: gpInsertUpdate_MovementItem_ProductionUnion()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionUnion(Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ProductionUnion(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inObjectId            Integer   , -- Комплектующие
    IN inReceiptProdModelId  Integer   , -- 
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
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inObjectId, NULL, inMovementId, inAmount, NULL,inUserId);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptProdModel(), ioId, inReceiptProdModelId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
         
         --при инсерте zc_MI_Master автоматом формировать zc_MI_Child - по значениям план, при update пока ничего не делаем
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId         := 0
                                                        , inParentId   := ioId
                                                        , inMovementId := inMovementId
                                                        , inObjectId   := tmp.ObjectId
                                                        , inAmount     := (COALESCE (tmp.Value,0) + COALESCE (tmp.Value_service,0)) :: TFloat
                                                        , inUserId     := inUserId
                                                        )
         FROM gpSelect_MI_ProductionUnion_Child (inMovementId, TRUE, FALSE, inUserId ::TVarChar) AS tmp
         WHERE tmp.ParentId = ioId;
         
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
--