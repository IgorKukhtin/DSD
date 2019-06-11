-- Function: gpInsert_ScaleLight_MI()

DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleLight_MI(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- 
    IN inGoodsKindId         Integer   , -- 
    IN inMeasureId           Integer   , -- 

    IN inWmsCode_Sh          TVarChar  , -- Код ВМС - ШТ.
    IN inWmsCode_Nom         TVarChar  , -- Код ВМС - НОМ.
    IN inWmsCode_Ves         TVarChar  , -- Код ВМС - ВЕС

    IN inGoodsTypeKindId_Sh  Integer   , -- Id - есть ли ШТ.
    IN inGoodsTypeKindId_Nom Integer   , -- Id - есть ли НОМ.
    IN inGoodsTypeKindId_Ves Integer   , -- Id - есть ли ВЕС
    -- 1-ая линия - Всегда этот цвет
    IN inGoodsTypeKindId_1   Integer   , -- выбранный тип для этого ЦВЕТА
    IN inBarCodeBoxId_1      Integer   , -- Id для Ш/К ящика
    IN inLineCode_1          Integer   , -- код линии = 1,2 или 3
    IN inWeightOnBox_1       Integer   , -- вложенность - Вес
    IN inCountOnBox_1        Integer   , -- Вложенность - шт (информативно?)
    -- 1-ая линия - Всегда этот цвет
    IN inGoodsTypeKindId_2   Integer   , -- выбранный тип для этого ЦВЕТА
    IN inBarCodeBoxId_2      Integer   , -- Id для Ш/К ящика
    IN inLineCode_2          Integer   , -- код линии = 1,2 или 3
    -- 1-ая линия - Всегда этот цвет
    IN inGoodsTypeKindId_3   Integer   , -- выбранный тип для этого ЦВЕТА
    IN inBarCodeBoxId_3      Integer   , -- Id для Ш/К ящика
    IN inLineCode_3          Integer   , -- код линии = 1,2 или 3

    IN inWeightMin           TFloat    , -- минимальный вес 1шт.
    IN inWeightMax           TFloat    , -- максимальный вес 1шт.

    IN inAmount              TFloat    , -- Кол-во, как правило = 1
    IN inRealWeight          TFloat    , -- Вес

    IN inBranchCode          Integer   , -- 

    IN inSession             TVarChar    -- сессия пользователя
)                              

RETURNS TABLE (Id              Integer   -- Id сохраненного элемента
             , GoodsTypeKindId Integer   -- тип = ШТ. или НОМ. или ВЕС
             , BarCodeBoxId    Integer   -- Id для Ш/К ящика
             , LineCode        Integer   -- код линии = 1,2 или 3
             , WmsCode         TVarChar  -- Ш/К для ВМС: 3(1)+дни(3)+WmsCode(4)+вес(4)+контрольная(1)
             , isFull          Boolean   -- ящик заполнен
              )
AS
$BODY$
   DECLARE vbUserId           Integer;
   DECLARE vbGoodsTypeKindId  Integer;
   DECLARE vbBarCodeBoxId     Integer;
   DECLARE vbLineCode         Integer;
   DECLARE vbWmsCode          TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleCeh_MI());
     vbUserId:= lpGetUserBySession (inSession);



     IF inMeasureId = zc_Measure_Sh() OR inGoodsTypeKindId_Sh > 0
     THEN
         -- если это ШТ.
         IF inRealWeight BETWEEN (inWeightMin + inWeightMax) / 2 - 0.002  AND (inWeightMin + inWeightMax) / 2 + 0.002
         THEN
             -- это ШТ.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Sh;
             -- 13-значн. Ш/К.
                 vbWmsCode     := '3' || 

             -- нашли на какой это линии
             IF inGoodsTypeKindId_1 = inGoodsTypeKindId_Sh
             THEN
                 vbBarCodeBoxId:= inBarCodeBoxId_1;
                 vbLineCode    := inLineCode_1;

             ELSEIF inGoodsTypeKindId_2 = inGoodsTypeKindId_Sh
             THEN
             ELSE
                 RAISE EXCEPTION 'Ошибка. Не определено <ШТ.> или <НОМ.> или <ВЕС>', ;
             END IF;
             
         END IF;

     ELSE
     END IF;
     
     
     -- сохранили
     vbId:= gpInsertUpdate_MI_WeighingProduction_wms (ioId                  := 0
                                                    , inMovementId          := inMovementId
                                                    , inGoodsTypeKindId     := vbGoodsTypeKindId
                                                    , inBarCodeBoxId        := vbBarCodeBoxId
                                                    , inLineCode            := vbLineCode
                                                    , inAmount              := inAmount
                                                    , inRealWeight          := inRealWeight
                                                    , inWmsCode             := vbWmsCode
                                                    , inSession             := inSession
                                                     );




     -- Результат
     RETURN QUERY
       SELECT vbId
            , vbGoodsTypeKindId
            , vbBarCodeBoxId
            , vbLineCode
            , vbWmsCode
            , FALSE AS isFull
              ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsert_ScaleLight_MI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
