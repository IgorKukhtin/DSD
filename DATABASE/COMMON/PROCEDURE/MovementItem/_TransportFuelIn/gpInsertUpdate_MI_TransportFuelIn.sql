-- Function: gpInsertUpdate_MI_TransportFuelIn()

-- DROP FUNCTION gpInsertUpdate_MI_TransportFuelIn();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_TransportFuelIn(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inFuelId              Integer   , -- Топливо
    IN inAmount              TFloat    , -- Количество

    IN inFromId              Integer   , -- Откуда идет заправка Юр. лицо, Подразделение
    IN inGoodsId             Integer   , -- Какой вид топлива расходуется
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TransportFuelIn());
     vbUserId := inSession;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inFuelId, inMovementId, inAmount, NULL);
  
     -- сохранили связь с <Откуда идет заправка>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_From(), ioId, inFromId); 

     -- сохранили связь с <Какой вид топлива расходуется>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);

      -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.13         * 
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_TransportFuelIn (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
