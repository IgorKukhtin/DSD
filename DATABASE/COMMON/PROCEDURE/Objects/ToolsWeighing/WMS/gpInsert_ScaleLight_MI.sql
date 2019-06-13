-- Function: gpInsert_ScaleLight_MI()

DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (BigInt, BigInt, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleLight_MI(
 -- IN inId                  BigInt    , -- Ключ объекта <Элемент документа>
 -- IN inMovementId          BigInt    , -- Ключ объекта <Документ>
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
    IN inWeightOnBox_1       TFloat    , -- вложенность - Вес
    IN inCountOnBox_1        TFloat    , -- Вложенность - шт (информативно?)
    -- 2-ая линия - Всегда этот цвет
    IN inGoodsTypeKindId_2   Integer   , -- выбранный тип для этого ЦВЕТА
    IN inBarCodeBoxId_2      Integer   , -- Id для Ш/К ящика
    IN inLineCode_2          Integer   , -- код линии = 1,2 или 3
    IN inWeightOnBox_2       TFloat    , -- вложенность - Вес
    IN inCountOnBox_2        TFloat    , -- Вложенность - шт (информативно?)
    -- 1-ая линия - Всегда этот цвет
    IN inGoodsTypeKindId_3   Integer   , -- выбранный тип для этого ЦВЕТА
    IN inBarCodeBoxId_3      Integer   , -- Id для Ш/К ящика
    IN inLineCode_3          Integer   , -- код линии = 1,2 или 3
    IN inWeightOnBox_3       TFloat    , -- вложенность - Вес
    IN inCountOnBox_3        TFloat    , -- Вложенность - шт (информативно?)

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
   DECLARE vbId               Integer;
   DECLARE vbOperDate         TDateTime;
   DECLARE vbDay              TVarChar;
   DECLARE vbW_1              TVarChar;
   DECLARE vbW_3              TVarChar;
   DECLARE vbGoodsTypeKindId  Integer;
   DECLARE vbBarCodeBoxId     Integer;
   DECLARE vbLineCode         Integer;
   DECLARE vbWmsCode          TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleCeh_MI());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка - вес ДО 10 кг.
     IF FLOOR (inRealWeight) >= 10
     THEN
         RAISE EXCEPTION 'Ошибка.Вес = <%> не должен быть больше 9.999 кг.', inRealWeight;
     END IF;
     -- проверка - вес больше 0.010 кг.
     IF FLOOR (inRealWeight) <= 0.010
     THEN
         RAISE EXCEPTION 'Ошибка.Вес = <%> должен быть больше 0.010 кг.', inRealWeight;
     END IF;

     -- нашли Дату партии
     vbOperDate:= (SELECT Movement.OperDate FROM Movement_WeighingProduction AS Movement WHERE Movement.Id = inMovementId);
     
     -- сколько дней
     vbDay:= (1 + EXTRACT (DAY FROM (vbOperDate - DATE_TRUNC ('YEAR', vbOperDate)) :: INTERVAL)) :: TVarChar;
     vbDay:= REPEAT ('0', 3 - LENGTH (vbDay)) || vbDay;
     -- вес - КГ
     vbW_1:= (FLOOR (inRealWeight) :: Integer) :: TVarChar;
     -- вес - ГР.
     vbW_3:= (FLOOR (MOD (inRealWeight, 1) * 1000) :: Integer) :: TVarChar;
     
     -- привели к 4-м символам
     inWmsCode_Sh := REPEAT ('0', 4 - LENGTH (inWmsCode_Sh))  || inWmsCode_Sh;
     inWmsCode_Nom:= REPEAT ('0', 4 - LENGTH (inWmsCode_Nom)) || inWmsCode_Nom;
     inWmsCode_Ves:= REPEAT ('0', 4 - LENGTH (inWmsCode_Ves)) || inWmsCode_Ves;


         -- 1.1. если попали в вес для ШТ.
         IF ((inRealWeight BETWEEN (inWeightMin + inWeightMax) / 2 - 0.002 AND (inWeightMin + inWeightMax) / 2 + 0.002)
         -- или возможны только ШТ.
         OR (COALESCE (inGoodsTypeKindId_Nom, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
            )
         -- и возможны ШТ.
         AND inGoodsTypeKindId_Sh > 0
         THEN
             -- это ШТ.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Sh;
             -- 12-значн. Ш/К для ВМС: 3(1)+дни(3)+WmsCode(4)+вес(4)+контрольная(1)
             vbWmsCode := '3' || vbDay || inWmsCode_Sh || vbW_1 || vbW_3;
             -- 13-значн. Ш/К для ВМС: +контрольная(1)
             vbWmsCode := vbWmsCode || zfCalc_SummBarCode(vbWmsCode) :: TVarChar;

             -- нашли на какой это линии
             IF inGoodsTypeKindId_1 = inGoodsTypeKindId_Sh
             THEN
                 -- 1
                 vbBarCodeBoxId:= inBarCodeBoxId_1;
                 vbLineCode    := inLineCode_1;

             ELSEIF inGoodsTypeKindId_2 = inGoodsTypeKindId_Sh
             THEN
                 -- 2
                 vbBarCodeBoxId:= inBarCodeBoxId_2;
                 vbLineCode    := inLineCode_2;

             ELSEIF inGoodsTypeKindId_3 = inGoodsTypeKindId_Sh
             THEN
                 -- 3
                 vbBarCodeBoxId:= inBarCodeBoxId_3;
                 vbLineCode    := inLineCode_3;

             ELSE
                 RAISE EXCEPTION 'Ошибка. Не определено <ШТ.> или <НОМ.> или <ВЕС>';
             END IF;
             

         -- 1.2. если попали в вес для НОМ.
         ELSEIF((inRealWeight BETWEEN inWeightMin AND inWeightMax)
             -- или возможен только НОМ.
             OR (COALESCE (inGoodsTypeKindId_Sh, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
               )
             -- и возможен НОМ.
             AND inGoodsTypeKindId_Nom > 0
         THEN
             -- это НОМ.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Nom;
             -- 12-значн. Ш/К для ВМС: 3(1)+дни(3)+WmsCode(4)+вес(4)+контрольная(1)
             vbWmsCode := '3' || vbDay || inWmsCode_Nom || vbW_1 || vbW_3;
             -- 13-значн. Ш/К для ВМС: +контрольная(1)
             vbWmsCode := vbWmsCode || zfCalc_SummBarCode(vbWmsCode) :: TVarChar;

             -- нашли на какой это линии
             IF inGoodsTypeKindId_1 = inGoodsTypeKindId_Nom
             THEN
                 -- 1
                 vbBarCodeBoxId:= inBarCodeBoxId_1;
                 vbLineCode    := inLineCode_1;

             ELSEIF inGoodsTypeKindId_2 = inGoodsTypeKindId_Nom
             THEN
                 -- 2
                 vbBarCodeBoxId:= inBarCodeBoxId_2;
                 vbLineCode    := inLineCode_2;

             ELSEIF inGoodsTypeKindId_3 = inGoodsTypeKindId_Nom
             THEN
                 -- 3
                 vbBarCodeBoxId:= inBarCodeBoxId_3;
                 vbLineCode    := inLineCode_3;

             ELSE
                 RAISE EXCEPTION 'Ошибка. Не определено <ШТ.> или <НОМ.> или <ВЕС>';
             END IF;


         -- 1.3. если возможен ВЕС
         ELSEIF inGoodsTypeKindId_Ves > 0
         THEN
             -- это Ves.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Ves;
             -- 12-значн. Ш/К для ВМС: 3(1)+дни(3)+WmsCode(4)+вес(4)+контрольная(1)
             vbWmsCode := '3' || vbDay || inWmsCode_Ves || vbW_1 || vbW_3;
             -- 13-значн. Ш/К для ВМС: +контрольная(1)
             vbWmsCode := vbWmsCode || zfCalc_SummBarCode(vbWmsCode) :: TVarChar;

             -- нашли на какой это линии
             IF inGoodsTypeKindId_1 = inGoodsTypeKindId_Ves
             THEN
                 -- 1
                 vbBarCodeBoxId:= inBarCodeBoxId_1;
                 vbLineCode    := inLineCode_1;

             ELSEIF inGoodsTypeKindId_2 = inGoodsTypeKindId_Ves
             THEN
                 -- 2
                 vbBarCodeBoxId:= inBarCodeBoxId_2;
                 vbLineCode    := inLineCode_2;

             ELSEIF inGoodsTypeKindId_3 = inGoodsTypeKindId_Ves
             THEN
                 -- 3
                 vbBarCodeBoxId:= inBarCodeBoxId_3;
                 vbLineCode    := inLineCode_3;

             ELSE
                 RAISE EXCEPTION 'Ошибка. Не определено <ШТ.> или <НОМ.> или <ВЕС>';
             END IF;
             

         -- 1.4. 
         ELSE
             RAISE EXCEPTION 'Ошибка.ДЛЯ ВЕСА <% кг.> Не определено <ШТ.> или <НОМ.> или <ВЕС>', inRealWeight;
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
