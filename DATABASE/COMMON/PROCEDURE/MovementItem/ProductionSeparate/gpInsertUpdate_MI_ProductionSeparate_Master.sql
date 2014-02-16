-- Function: gpInsertUpdate_MI_ProductionSeparate_Master()

-- DROP FUNCTION gpInsertUpdate_MI_ProductionSeparate_Master();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionSeparate_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inHeadCount           TFloat    , -- Количество голов	           
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionSeparate());
   vbUserId := inSession;

   -- сохранили <Элемент документа>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);
   -- сохранили свойство <Количество голов>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_HeadCount(), ioId, inHeadCount);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.07.13         *              

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionSeparate_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inSession:= '2')
