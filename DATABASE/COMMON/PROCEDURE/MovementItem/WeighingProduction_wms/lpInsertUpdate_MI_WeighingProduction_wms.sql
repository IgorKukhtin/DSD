-- Function: lpInsertUpdate_MI_WeighingProduction_wms()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_WeighingProduction_wms (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_WeighingProduction_wms (Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_WeighingProduction_wms(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- 
    IN inGoodsTypeKindId     Integer   , -- 
    IN inBarCodeBoxId        Integer   , -- 
    IN inLineCode            Integer   , --
    IN inDateInsert          TDateTime , --
    IN inDateUpdate          TDateTime , --
    IN inAmount              TFloat    , --
    IN inRealWeight          TFloat    , --
    IN inWmsCode             TVarChar  , --
    IN inUserId              Integer    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

         -- изменили
         UPDATE MI_WeighingProduction
                SET MovementId        = inMovementId
                  , ParentId          = inParentId
                  , GoodsTypeKindId   = inGoodsTypeKindId
                  , BarCodeBoxId      = inBarCodeBoxId
                  , LineCode          = inLineCode
                  , DateInsert        = inDateInsert
                  , DateUpdate        = inDateUpdate
                  , Amount            = inAmount
                  , RealWeight        = inRealWeight
                  , WmsCode           = inWmsCode
         WHERE MI_WeighingProduction.Id = ioId;    
    
     -- сохранили протокол
     --PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.05.19         *
*/

-- тест
--