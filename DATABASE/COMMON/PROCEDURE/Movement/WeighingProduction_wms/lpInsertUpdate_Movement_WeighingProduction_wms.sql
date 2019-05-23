-- Function: lpInsertUpdate_Movement_WeighingProduction _wms()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_WeighingProduction _wms (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_WeighingProduction _wms(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inStartWeighing       TDateTime , -- Протокол начало взвешивания
    IN inEndWeighing         TDateTime , -- Протокол окончание  взвешивания
    IN inMovementDescId      Integer   , -- Вид документа
    IN inMovementDescNumber  Integer   , -- Код операции (взвешивание)
    IN inPlaceNumber         Integer   , -- номер рабочего места
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN GoodsId               Integer   , -- 
    IN GoodsKindId           Integer   , -- 
    IN inUserId              Integer    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
BEGIN

     THEN
         -- изменили
         UPDATE Movement_WeighingProduction
                SET InvNumber            = inInvNumber
                  , OperDate             = inOperDate
                  , FromId               = inFromId
                  , ToId                 = inToId
                  , GoodsId              = inGoodsId
                  , GoodsKindId          = inGoodsKindId
                  , MovementDescId       = inMovementDescId
                  , MovementDescNumber   = inMovementDescNumber
                  , PlaceNumber          = inPlaceNumber
                  , UserId               = inUserId
                  , StartWeighing        = inStartWeighing
                  , EndWeighing          = inEndWeighing
         WHERE Movement_WeighingProduction.Id = ioId;

     -- сохранили протокол
     --PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.05.19         *
*/

-- тест
--