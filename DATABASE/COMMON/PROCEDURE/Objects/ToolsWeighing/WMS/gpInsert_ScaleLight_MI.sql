-- Function: gpInsert_ScaleLight_MI()

DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (BigInt, BigInt, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

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
             , isFull_1        Boolean   -- ящик_1 заполнен
             , isFull_2        Boolean   -- ящик_2 заполнен
             , isFull_3        Boolean   -- ящик_3 заполнен
             , WeightOnBox     TFloat
             , CountOnBox      TFloat
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
   DECLARE vbWmsBarCode       TVarChar;
   DECLARE vb_sku_id          TVarChar;
   DECLARE vb_sku_code        TVarChar;
   DECLARE vbIsFull           Boolean;
   DECLARE vbWeightOnBox      TFloat;   -- факт - Вес
   DECLARE vbCountOnBox       TFloat;   -- факт - шт (информативно?)
   DECLARE vbMovementId       Integer;  -- Документ zc_Movement_WeighingProduction
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
     -- привели к 3-м символам
     vbDay:= REPEAT ('0', 3 - LENGTH (vbDay)) || vbDay;
     -- вес - КГ
     vbW_1:= (FLOOR (inRealWeight) :: Integer) :: TVarChar;
     -- привели к 1-му символу
     IF LENGTH (vbW_1) <> 1 THEN vbW_1:= SUBSTRING(vbW_1, LENGTH (vbW_1), 1); vbW_1 := REPEAT ('0', 1 - LENGTH (vbW_1)); END IF;
     -- вес - ГР.
     vbW_3:= (FLOOR (MOD (inRealWeight, 1) * 1000) :: Integer) :: TVarChar;
     -- привели к 3-м символам
     vbW_3 := REPEAT ('0', 3 - LENGTH (vbW_3)) || vbW_3;
     
     -- привели к 4-м символам
     inWmsCode_Sh := REPEAT ('0', 4 - LENGTH (inWmsCode_Sh))  || inWmsCode_Sh;
     inWmsCode_Nom:= REPEAT ('0', 4 - LENGTH (inWmsCode_Nom)) || inWmsCode_Nom;
     inWmsCode_Ves:= REPEAT ('0', 4 - LENGTH (inWmsCode_Ves)) || inWmsCode_Ves;


         -- 1.1. если попали в вес для ШТ.
         IF ((inRealWeight BETWEEN (inWeightMin + inWeightMax) / 2 - 0.002 AND (inWeightMin + inWeightMax) / 2 + 0.002)
         -- или возможны только ШТ.
         OR (COALESCE (inGoodsTypeKindId_Nom, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
      -- OR 1=1
            )
         -- и возможны ШТ.
         AND inGoodsTypeKindId_Sh > 0
         THEN
             -- это ШТ.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Sh;
             -- Id ВМС + код ВМС
             SELECT tmp.sku_id_Sh, tmp.sku_code_Sh
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_Object_GoodsByGoodsKind_wms (inGoodsId, inGoodsKindId, inSession) AS tmp;
             -- 12-значн. Ш/К для ВМС: 3(1)+дни(3)+WmsCode(4)+вес(4)+контрольная(1)
             vbWmsBarCode:= '3' || vbDay || inWmsCode_Sh || vbW_1 || vbW_3;
             -- 13-значн. Ш/К для ВМС: +контрольная(1)
             vbWmsBarCode:= vbWmsBarCode || zfCalc_SummBarCode (vbWmsBarCode) :: TVarChar;

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
          -- OR 1=1
               )
             -- и возможен НОМ.
             AND inGoodsTypeKindId_Nom > 0
         THEN
             -- это НОМ.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Nom;
             -- Id ВМС + код ВМС
             SELECT tmp.sku_id_Nom, tmp.sku_code_Nom
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_Object_GoodsByGoodsKind_wms (inGoodsId, inGoodsKindId, inSession) AS tmp;
             -- 12-значн. Ш/К для ВМС: 3(1)+дни(3)+WmsCode(4)+вес(4)+контрольная(1)
             vbWmsBarCode := '3' || vbDay || inWmsCode_Nom || vbW_1 || vbW_3;
             -- 13-значн. Ш/К для ВМС: +контрольная(1)
             vbWmsBarCode := vbWmsBarCode || zfCalc_SummBarCode (vbWmsBarCode) :: TVarChar;

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
             -- Id ВМС + код ВМС
             SELECT tmp.sku_id_Ves, tmp.sku_code_Ves
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_Object_GoodsByGoodsKind_wms (inGoodsId, inGoodsKindId, inSession) AS tmp;
             -- 12-значн. Ш/К для ВМС: 3(1)+дни(3)+WmsCode(4)+вес(4)+контрольная(1)
             vbWmsBarCode := '3' || vbDay || inWmsCode_Ves || vbW_1 || vbW_3;
             -- 13-значн. Ш/К для ВМС: +контрольная(1)
             vbWmsBarCode := vbWmsBarCode || zfCalc_SummBarCode (vbWmsBarCode) :: TVarChar;

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
                                                    , inWmsBarCode          := vbWmsBarCode
                                                    , in_sku_id             := vb_sku_id
                                                    , in_sku_code           := vb_sku_code
                                                    , inPartionDate         := vbOperDate
                                                    , inSession             := inSession
                                                     );

     -- факт - Вес + шт (информативно?)
     SELECT SUM (MovementItem.RealWeight)
          , SUM (MovementItem.Amount)
            INTO vbWeightOnBox, vbCountOnBox
     FROM MI_WeighingProduction AS MovementItem
     WHERE MovementItem.MovementId      = inMovementId
       AND MovementItem.isErased        = FALSE
       AND MovementItem.ParentId        IS NULL
       AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
       AND MovementItem.BarCodeBoxId    = vbBarCodeBoxId
            ;


     -- если уже взвешено >= вложенность - Вес
     vbIsFull:= CASE WHEN vbWeightOnBox >= CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                                THEN inWeightOnBox_1 -- вложенность - 1
                                                WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                                THEN inWeightOnBox_2 -- вложенность - 2
                                                WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                                THEN inWeightOnBox_3 -- вложенность - 3
                                           END
                     THEN TRUE
                     ELSE FALSE
                END;
     
     -- !!!если НАДО ЗАКРЫТЬ ОДИН ящик!!!
     IF vbIsFull = TRUE
     THEN
         -- Создали Документ zc_Movement_WeighingProduction
         vbMovementId:= gpInsertUpdate_Movement_WeighingProduction (ioId                  := 0
                                                                  , inOperDate            := Movement.OperDate
                                                                  , inMovementDescId      := Movement.MovementDescId
                                                                  , inMovementDescNumber  := Movement.MovementDescNumber
                                                                  , inWeighingNumber      := 1 + COALESCE ((SELECT COUNT(*)
                                                                                                            FROM MI_WeighingProduction AS MovementItem
                                                                                                            WHERE MovementItem.MovementId      = inMovementId
                                                                                                              AND MovementItem.isErased        = FALSE
                                                                                                              AND MovementItem.ParentId        > 0
                                                                                                              AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
                                                                                                           )
                                                                                                         , 0) :: Integer
                                                                  , inFromId              := Movement.FromId
                                                                  , inToId                := Movement.ToId
                                                                  , inDocumentKindId      := 0
                                                                  , inPartionGoods        := ''
                                                                  , inIsProductionIn      := FALSE
                                                                  , inSession             := inSession
                                                                   )
         FROM Movement_WeighingProduction AS Movement WHERE Movement.Id = inMovementId;

         -- в Документ еще сохранили <КАТЕГОРИЯ товара (груза)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsTypeKind(), vbMovementId, vbGoodsTypeKindId);
         -- в Документ еще сохранили <Ш/К ящика (груза)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BarCodeBox(), vbMovementId, vbBarCodeBoxId);
    

         -- Добавили элемент - zc_MI_Master
         PERFORM gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := 0
                                                               , inMovementId          := vbMovementId
                                                               , inGoodsId             := Movement.GoodsId
                                                               , inAmount              := CASE WHEN inMeasureId = zc_Measure_Sh() THEN Movement.Amount ELSE Movement.RealWeight END
                                                               , inIsStartWeighing     := FALSE
                                                               , inRealWeight          := Movement.RealWeight
                                                               , inWeightTare          := 0
                                                               , inLiveWeight          := 0
                                                               , inHeadCount           := 0
                                                               , inCount               := 0
                                                               , inCountPack           := Movement.Amount
                                                               , inCountSkewer1        := 0
                                                               , inWeightSkewer1       := 0
                                                               , inCountSkewer2        := 0
                                                               , inWeightSkewer2       := 0
                                                               , inWeightOther         := 0
                                                               , inPartionGoodsDate    := NULL
                                                               , inPartionGoods        := ''
                                                               , inMovementItemId      := 0
                                                               , inGoodsKindId         := Movement.GoodsKindId
                                                               , inStorageLineId       := NULL
                                                               , inSession             := inSession
                                                                )
         FROM (SELECT Movement.GoodsId, Movement.GoodsKindId
                    , SUM (MovementItem.RealWeight) AS RealWeight
                    , SUM (MovementItem.Amount)     AS Amount
               FROM Movement_WeighingProduction AS Movement
                    INNER JOIN MI_WeighingProduction AS MovementItem
                                                     ON MovementItem.MovementId      = Movement.Id
                                                    AND MovementItem.isErased        = FALSE
                                                    AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
                                                    AND MovementItem.BarCodeBoxId    = vbBarCodeBoxId
                                                    AND MovementItem.ParentId        IS NULL
               WHERE Movement.Id = inMovementId
               GROUP BY Movement.GoodsId, Movement.GoodsKindId
              ) AS Movement;



         -- Обнулили одну из линий - Ш/К для ящика
         UPDATE Movement_WeighingProduction SET BarCodeBoxId_1 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                                                           THEN 0
                                                                      ELSE Movement_WeighingProduction.BarCodeBoxId_1
                                                                 END
                                              , BarCodeBoxId_2 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                                                           THEN 0
                                                                      ELSE Movement_WeighingProduction.BarCodeBoxId_2
                                                                 END
                                              , BarCodeBoxId_3 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                                                           THEN 0
                                                                      ELSE Movement_WeighingProduction.BarCodeBoxId_3
                                                                 END
         WHERE Movement_WeighingProduction.Id = inMovementId
        ;

         -- сохранили что 1 ящик ЗАКРЫТ
         UPDATE MI_WeighingProduction SET ParentId = vbMovementId
         WHERE MI_WeighingProduction.MovementId      = inMovementId
        -- AND MI_WeighingProduction.isErased        = FALSE
           AND MI_WeighingProduction.ParentId        IS NULL
           AND MI_WeighingProduction.GoodsTypeKindId = vbGoodsTypeKindId
           AND MI_WeighingProduction.BarCodeBoxId    = vbBarCodeBoxId
        ;

     END IF;

     -- Результат
     RETURN QUERY
       SELECT vbId
            , vbGoodsTypeKindId
            , vbBarCodeBoxId
            , vbLineCode
            , vbWmsBarCode
            , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1 THEN vbIsFull ELSE FALSE END :: Boolean AS isFull_1
            , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2 THEN vbIsFull ELSE FALSE END :: Boolean AS isFull_2
            , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3 THEN vbIsFull ELSE FALSE END :: Boolean AS isFull_3
            , vbWeightOnBox AS WeightOnBox
            , vbCountOnBox  AS CountOnBox
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
