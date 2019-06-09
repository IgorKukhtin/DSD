-- Function: gpInsertUpdate_Movement_WeighingProduction_wms()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction_wms (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction_wms (BigInt, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingProduction_wms(
 INOUT ioId                  BigInt    , -- Ключ объекта <Документ>
--  IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
--  IN inStartWeighing       TDateTime , -- Протокол начало взвешивания
--  IN inEndWeighing         TDateTime , -- Протокол окончание  взвешивания
    IN inMovementDescId      Integer   , -- Вид документа
    IN inMovementDescNumber  Integer   , -- Код операции (взвешивание)
    IN inPlaceNumber         Integer   , -- номер рабочего места
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inGoodsId             Integer   , -- 
    IN inGoodsKindId         Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS BigInt
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingProduction_wms());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар не определен.';
     END IF;
     -- проверка
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Вид товара не определен.';
     END IF;


     IF COALESCE (ioId, 0) = 0 THEN
        -- создали <Документ>
        INSERT INTO Movement_WeighingProduction (InvNumber, OperDate, StatusId, FromId, ToId, GoodsId, GoodsKindId, MovementDescId, MovementDescNumber, PlaceNumber, UserId, StartWeighing, EndWeighing)
               VALUES (CAST (NEXTVAL ('Movement_WeighingProduction_wms_seq') AS TVarChar)
                     , inOperDate
                     , zc_Enum_Status_UnComplete()
                     , inFromId
                     , inToId
                     , inGoodsId
                     , inGoodsKindId
                     , inMovementDescId
                     , inMovementDescNumber
                     , inPlaceNumber
                     , vbUserId
                     , CURRENT_TIMESTAMP
                     , NULL
                      )
                 RETURNING Id INTO ioId;
     ELSE
        -- изменили <Документ>
        UPDATE Movement_WeighingProduction
               SET OperDate             = inOperDate
              -- , InvNumber            = inInvNumber
                 , FromId               = inFromId
                 , ToId                 = inToId
                 , GoodsId              = inGoodsId
                 , GoodsKindId          = inGoodsKindId
                 , MovementDescId       = inMovementDescId
                 , MovementDescNumber   = inMovementDescNumber
                 , PlaceNumber          = inPlaceNumber
                 , UserId               = inUserId
              -- , StartWeighing        = inStartWeighing
              -- , EndWeighing          = inEndWeighing
         WHERE Id = ioId
           RETURNING StatusId INTO vbStatusId;
   
        --
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Ошибка.Не найден ioId = <%>.', ioId;
        END IF;

        --
        IF vbStatusId <> zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
        END IF;
   
   
     END IF;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.19                                        *
*/

-- тест
--