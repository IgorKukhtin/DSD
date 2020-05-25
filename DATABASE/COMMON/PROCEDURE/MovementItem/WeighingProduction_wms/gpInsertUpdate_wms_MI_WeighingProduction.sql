-- Function: gpInsertUpdate_wms_MI_WeighingProduction()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_wms_MI_WeighingProduction (BigInt, BigInt, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_wms_MI_WeighingProduction (BigInt, BigInt, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_wms_MI_WeighingProduction(
 INOUT ioId                  BigInt    , -- Ключ объекта <Элемент документа>
    IN inMovementId          BigInt    , -- Ключ объекта <Документ>
 -- IN inParentId            Integer   , --
    IN inGoodsTypeKindId     Integer   , --
    IN inBarCodeBoxId        Integer   , --
    IN inLineCode            Integer   , --
    IN inAmount              TFloat    , --
    IN inRealWeight          TFloat    , --
 -- IN inInsertDate          TDateTime , --
 -- IN inUpdateDate          TDateTime , --
    IN inWmsBarCode          TVarChar  , --
    IN in_sku_id             TVarChar  , --
    IN in_sku_code           TVarChar  , --
    IN inPartionDate         TDateTime , --
    IN inIsErrSave           Boolean   , -- режим, когда вызываем во второй раз и надо сохранить ошибку
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS BigInt
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbParentId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_wms_MI_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);


     -- поиск
     vbStatusId:= (SELECT wms_Movement_WeighingProduction.StatusId FROM wms_Movement_WeighingProduction WHERE wms_Movement_WeighingProduction.Id = inMovementId);
     -- проверка
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.'
                       , (SELECT wms_Movement_WeighingProduction.InvNumber FROM wms_Movement_WeighingProduction WHERE wms_Movement_WeighingProduction.Id = inMovementId)
                       , lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- проверка
     IF COALESCE (inGoodsTypeKindId, 0) = 0 AND inIsErrSave = FALSE
     THEN
         RAISE EXCEPTION 'Ошибка.Категория товара не определена.<%>', inGoodsTypeKindId;
     END IF;

     -- проверка
     IF COALESCE (inBarCodeBoxId, 0) = 0 AND inIsErrSave = FALSE
     THEN
         RAISE EXCEPTION 'Ошибка. Ш/К ящика не определен.<%>', inBarCodeBoxId;
     END IF;

     -- проверка
     IF COALESCE (inLineCode, 0) NOT IN (1, 2, 3) AND inIsErrSave = FALSE
     THEN
         RAISE EXCEPTION 'Ошибка.Код линии (1,2 или 3) не определен.<%>', inLineCode;
     END IF;


     IF COALESCE (ioId, 0) = 0 THEN
        -- создали
        INSERT INTO wms_MI_WeighingProduction (MovementId, ParentId, GoodsTypeKindId, BarCodeBoxId, LineCode
                                             , Amount, RealWeight, InsertDate, UpdateDate
                                             , WmsCode, sku_id, sku_code
                                             , PartionDate
                                             , StatusId_wms
                                             , IsErased
                                              )
               VALUES (inMovementId
                     , NULL
                     , COALESCE (inGoodsTypeKindId, 0)
                     , COALESCE (inBarCodeBoxId, 0)
                     , COALESCE (inLineCode, 0)
                     , inAmount
                     , inRealWeight
                     , CURRENT_TIMESTAMP
                     , NULL
                     , COALESCE (inWmsBarCode, '')
                     , COALESCE (in_sku_id, '')
                     , COALESCE (in_sku_code, '')
                     , inPartionDate
                     , NULL
                     , CASE WHEN inIsErrSave = TRUE THEN TRUE ELSE FALSE END
                      )
                 RETURNING Id INTO ioId;
     ELSE
        -- изменили
        UPDATE wms_MI_WeighingProduction
                SET MovementId        = inMovementId
               -- , ParentId          = inParentId
                  , GoodsTypeKindId   = inGoodsTypeKindId
                  , BarCodeBoxId      = inBarCodeBoxId
                  , LineCode          = inLineCode
                  , Amount            = inAmount
                  , RealWeight        = inRealWeight
               -- , InsertDate        = inInsertDate
                  , UpdateDate        = CURRENT_TIMESTAMP
                  , WmsCode           = inWmsBarCode
                  , sku_id            = in_sku_id
                  , sku_code          = in_sku_code
                  , PartionDate       = inPartionDate
                  , StatusId_wms      = NULL
        WHERE wms_MI_WeighingProduction.Id = ioId RETURNING ParentId INTO vbParentId;

        --
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Ошибка.Не найден ioId = <%>.', ioId;
        END IF;

        -- проверка
        IF COALESCE (vbParentId, 0) > 0
        THEN
            RAISE EXCEPTION 'Ошибка.Ящик уже закрыт.Изменения невозможны.';
        END IF;

     END IF;

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

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
