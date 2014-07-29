-- Function: gpInsertUpdate_MI_EDI()

DROP FUNCTION IF EXISTS lpInsert_Movement_EDIEvents(Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_EDIEvents(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inEDIEvent            TVarChar  , -- Описание события
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
DECLARE
  vbXML TVarChar;
BEGIN

  vbXML := '<XML><EDIEvent Value = "' || replace(inEDIEvent, '"', '&quot;') || '"/></XML>';

  -- Сохранили
  INSERT INTO MovementProtocol (MovementId, OperDate, UserId, ProtocolData, isInsert)
                       VALUES (inMovementId, current_timestamp, inUserId, vbXML, null);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.14                         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_EDI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountSecond:= 0, inGoodsKindId:= 0, inSession:= '2')
