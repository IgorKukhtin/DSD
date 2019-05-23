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
   DECLARE vbIsInsert Boolean;
BEGIN

     IF COALESCE (ioId, 0) = 0
     THEN
         vbStartWeighing:= CURRENT_TIMESTAMP;
     END IF;

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF COALESCE (ioId, 0) <> 0
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
     ELSE
     -- если такой элемент не был найден
        -- добавили новый элемент
        INSERT INTO Movement_WeighingProduction (Id
                                               , InvNumber
                                               , OperDate
                                               , FromId
                                               , ToId
                                               , GoodsId
                                               , GoodsKindId
                                               , MovementDescId
                                               , MovementDescNumber
                                               , PlaceNumber
                                               , UserId
                                               , StartWeighing
                                               , EndWeighing
                                               )
            VALUES (ioId
                  , inInvNumber
                  , inOperDate
                  , inFromId
                  , inAToId
                  , inGoodsId
                  , inGoodsKindId
                  , inMovementDescId
                  , inMovementDescNumber
                  , inPlaceNumber
                  , inUserId
                  , inStartWeighing
                  , inEndWeighing);
     END IF;

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