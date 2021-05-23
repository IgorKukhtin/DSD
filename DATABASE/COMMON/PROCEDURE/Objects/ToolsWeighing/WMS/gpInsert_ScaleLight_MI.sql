-- Function: gpInsert_ScaleLight_MI()

-- DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (BigInt, BigInt, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ScaleLight_MI (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleLight_MI(
 -- IN inId                  BigInt    , -- Ключ объекта <Элемент документа>
 -- IN inMovementId          BigInt    , -- Ключ объекта <Документ>
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , --
    IN inGoodsKindId         Integer   , --
    IN inGoodsId_sh          Integer   , --
    IN inGoodsKindId_sh      Integer   , --
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
    IN inWeightOnBox_1       TFloat    , -- вложенность по Весу - !средняя!
    IN inCountOnBox_1        TFloat    , -- Вложенность - шт (НЕ информативно!)
    -- 2-ая линия - Всегда этот цвет
    IN inGoodsTypeKindId_2   Integer   , -- выбранный тип для этого ЦВЕТА
    IN inBarCodeBoxId_2      Integer   , -- Id для Ш/К ящика
    IN inLineCode_2          Integer   , -- код линии = 1,2 или 3
    IN inWeightOnBox_2       TFloat    , -- вложенность по Весу - !средняя!
    IN inCountOnBox_2        TFloat    , -- Вложенность - шт (НЕ информативно!)
    -- 3-ья линия - Всегда этот цвет
    IN inGoodsTypeKindId_3   Integer   , -- выбранный тип для этого ЦВЕТА
    IN inBarCodeBoxId_3      Integer   , -- Id для Ш/К ящика
    IN inLineCode_3          Integer   , -- код линии = 1,2 или 3
    IN inWeightOnBox_3       TFloat    , -- вложенность по Весу - !средняя!
    IN inCountOnBox_3        TFloat    , -- Вложенность - шт (НЕ информативно!)

    IN inWeightMin           TFloat    , -- минимальный вес 1шт. - !!!временно
    IN inWeightMax           TFloat    , -- максимальный вес 1шт.- !!!временно

    IN inWeightMin_Sh        TFloat    , -- минимальный вес 1шт.
    IN inWeightMin_Nom       TFloat    , --
    IN inWeightMin_Ves       TFloat    , --
    IN inWeightMax_Sh        TFloat    , -- максимальный вес 1шт.
    IN inWeightMax_Nom       TFloat    , --
    IN inWeightMax_Ves       TFloat    , --

    IN inAmount              TFloat    , -- Кол-во, как правило = 1
    IN inRealWeight          TFloat    , -- Вес

    IN inBranchCode          Integer   , --

    IN inIsErrSave           Boolean   , -- режим, когда вызываем во второй раз и надо сохранить ошибку

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
             , ResultText      Text      -- Ошибка
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
   DECLARE vbCountOnBox       TFloat;   -- факт - шт (НЕ информативно!)
   DECLARE vbMovementId       Integer;  -- Документ zc_Movement_WeighingProduction
   DECLARE vbResultText       Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleCeh_MI());
     vbUserId:= lpGetUserBySession (inSession);


/* if vbUserId = 5
 then
 RAISE EXCEPTION 'Ошибка.ok  %  %' ,
      inWeightMin_Sh       ,
     , CHR (13), vbResultText
;
 end if;*/

     -- пока нет ошибки
     vbResultText:= '';


     -- проверка - вес ДО 10 кг.
     IF FLOOR (inRealWeight) >= 10
     THEN
       --RAISE EXCEPTION 'Ошибка.Вес = <%> не должен быть больше 9.999 кг.', inRealWeight;
         vbResultText:= 'Ошибка.Вес = <' || zfConvert_FloatToString (inRealWeight) || '> не должен быть больше 9.999 кг.';
         -- IF inIsErrSave = FALSE THEN RETURN; END IF;
     END IF;
     -- проверка - вес больше 0.010 кг.
     IF inRealWeight <= 0.050
     THEN
       --RAISE EXCEPTION 'Ошибка.Вес = <%> должен быть меньше 0.050 кг.', inRealWeight;
         vbResultText:= 'Ошибка.Вес = <' || zfConvert_FloatToString (inRealWeight) || '> не должен быть меньше 0.050 кг.';
         -- IF inIsErrSave = FALSE THEN RETURN; END IF;
     END IF;


     -- нашли Дату партии
     vbOperDate:= (SELECT Movement.OperDate FROM wms_Movement_WeighingProduction AS Movement WHERE Movement.Id = inMovementId);

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


         -- 1.1. если возможны ШТ.
         IF inGoodsTypeKindId_Sh > 0
            -- и если попали в вес для ШТ.
        AND inRealWeight BETWEEN inWeightMin_Sh AND inWeightMax_Sh
      /*AND ((inRealWeight BETWEEN (inWeightMin + inWeightMax) / 2 - 0.002 AND (inWeightMin + inWeightMax) / 2 + 0.002)
         -- или возможны только ШТ.
         OR (COALESCE (inGoodsTypeKindId_Nom, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
      -- OR 1=1
            )*/
         THEN
             -- это ШТ.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Sh;
             -- Id ВМС + код ВМС
             SELECT tmp.sku_id_Sh, tmp.sku_code_Sh
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_wms_Object_GoodsByGoodsKind (CASE WHEN inGoodsId_sh > 0 THEN inGoodsId_sh ELSE inGoodsId END, CASE WHEN inGoodsKindId_sh > 0 THEN inGoodsKindId_sh ELSE inGoodsKindId END, inSession) AS tmp;
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
               --RAISE EXCEPTION 'Ошибка. Не определено <ШТ.> или <НОМ.> или <ВЕС>';
                 vbResultText:= 'Ошибка.Не определена линия для <ШТ.> или <НОМ.> или <ВЕС>';
                 -- IF inIsErrSave = FALSE THEN RETURN; END IF;
             END IF;


         -- 1.2. если возможен НОМ.
         ELSEIF inGoodsTypeKindId_Nom > 0
                -- и если попали в вес для НОМ.
            AND inRealWeight BETWEEN inWeightMin_Nom AND inWeightMax_Nom
          /*AND ((inRealWeight BETWEEN inWeightMin AND inWeightMax)
              -- или возможен только НОМ.
              OR (COALESCE (inGoodsTypeKindId_Sh, 0) <= 0 AND COALESCE (inGoodsTypeKindId_Ves, 0) <= 0)
           -- OR 1=1
                )*/
         THEN
             -- это НОМ.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Nom;
             -- Id ВМС + код ВМС
             SELECT tmp.sku_id_Nom, tmp.sku_code_Nom
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_wms_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inSession) AS tmp;
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
               --RAISE EXCEPTION 'Ошибка. Не определено <ШТ.> или <НОМ.> или <ВЕС>';
                 vbResultText:= 'Ошибка.Не определена линия для <ШТ.> или <НОМ.> или <ВЕС>';
                 -- IF inIsErrSave = FALSE THEN RETURN; END IF;
             END IF;


         -- 1.3. если возможен ВЕС
         ELSEIF inGoodsTypeKindId_Ves > 0
                -- и если попали в вес для ВЕС.
            AND inRealWeight BETWEEN inWeightMin_Ves AND inWeightMax_Ves
         THEN
             -- это Ves.
             vbGoodsTypeKindId:= inGoodsTypeKindId_Ves;
             -- Id ВМС + код ВМС
             SELECT tmp.sku_id_Ves, tmp.sku_code_Ves
                    INTO vb_sku_id, vb_sku_code
             FROM lpInsertFind_wms_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inSession) AS tmp;
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
               --RAISE EXCEPTION 'Ошибка. Не определено <ШТ.> или <НОМ.> или <ВЕС>';
                 vbResultText:= 'Ошибка.Не определена линия для <ШТ.> или <НОМ.> или <ВЕС>';
                 -- IF inIsErrSave = FALSE THEN RETURN; END IF;
             END IF;


         -- 1.4.
         ELSE
           --RAISE EXCEPTION 'НЕФОРМАТ.Для ВЕСА = <% кг.> Не определено <ШТ.> или <НОМ.> или <ВЕС>.Допустимый диапазон от <% кг.> до <% кг.>', inRealWeight;
             vbResultText:= 'НЕФОРМАТ.'
             || CHR (13) || 'Для ВЕСА = <' || zfConvert_FloatToString (inRealWeight) || ' кг.>'
                         || 'Не определено <ШТ.> или <НОМ.> или <ВЕС>.'
             || CHR (13) || 'Допустимый диапазон от <' || zfConvert_FloatToString (CASE WHEN inGoodsTypeKindId_Ves > 0 THEN inWeightMin_Ves
                                                                                        WHEN inGoodsTypeKindId_Nom > 0 THEN inWeightMin_Nom
                                                                                        WHEN inGoodsTypeKindId_Sh  > 0 THEN inWeightMin_Sh
                                                                                        ELSE 0
                                                                                   END
                                                                                  ) || ' кг.>'

                         ||                    ' до <' || zfConvert_FloatToString (CASE WHEN inGoodsTypeKindId_Ves > 0 THEN inWeightMax_Ves
                                                                                        WHEN inGoodsTypeKindId_Nom > 0 THEN inWeightMax_Nom
                                                                                        WHEN inGoodsTypeKindId_Sh  > 0 THEN inWeightMax_Sh
                                                                                        ELSE 0
                                                                                   END
                                                                                  ) || ' кг.>'
                         ;
         END IF;


     -- сохранили
     IF vbResultText = '' OR inIsErrSave = TRUE
     THEN
         vbId:= gpInsertUpdate_wms_MI_WeighingProduction (ioId                  := 0
                                                        , inMovementId          := inMovementId
                                                        , inGoodsTypeKindId     := vbGoodsTypeKindId
                                                        , inBarCodeBoxId        := vbBarCodeBoxId
                                                        , inLineCode            := vbLineCode
                                                        , inAmount              := inAmount
                                                        , inRealWeight          := inRealWeight
                                                        , inWmsBarCode          := CASE WHEN inIsErrSave = TRUE THEN '' ELSE vbWmsBarCode END
                                                        , in_sku_id             := vb_sku_id
                                                        , in_sku_code           := vb_sku_code
                                                        , inPartionDate         := vbOperDate
                                                        , inIsErrSave           := inIsErrSave
                                                        , inSession             := inSession
                                                         );

         -- !!! Режим созранения ошибочного взвешивания!!!
         IF inIsErrSave = FALSE
         THEN
             -- факт - Вес + шт (НЕ информативно!)
             SELECT SUM (MovementItem.RealWeight)
                  , SUM (MovementItem.Amount)
                    INTO vbWeightOnBox, vbCountOnBox
             FROM wms_MI_WeighingProduction AS MovementItem
             WHERE MovementItem.MovementId      = inMovementId
               AND MovementItem.isErased        = FALSE
               AND MovementItem.ParentId        IS NULL
               AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
               AND MovementItem.BarCodeBoxId    = vbBarCodeBoxId
                    ;
    
        -- RAISE EXCEPTION '<%> %', vbWeightOnBox, inWeightOnBox_2;
    
             -- если уже пора закрыть
             vbIsFull:= CASE -- взвешено ШТ >= вложенность по ШТ
                             WHEN vbGoodsTypeKindId <> inGoodsTypeKindId_Ves
                              -- установлена вложенность по ШТ
                              AND CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                       THEN inCountOnBox_1 -- вложенность - 1
                                       WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                       THEN inCountOnBox_2 -- вложенность - 2
                                       WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                       THEN inCountOnBox_3 -- вложенность - 3
                                  END > 0
                              AND vbCountOnBox >= CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                                        THEN inCountOnBox_1 -- вложенность - 1
                                                        WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                                        THEN inCountOnBox_2 -- вложенность - 2
                                                        WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                                        THEN inCountOnBox_3 -- вложенность - 3
                                                   END
                             -- закрыли
                             THEN TRUE
    
                             -- взвешено >= вложенность по Весу - !средняя!
                             WHEN vbWeightOnBox >= CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1 AND inCountOnBox_1 = 0
                                                        THEN inWeightOnBox_1 -- вложенность - 1
                                                        WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2 AND inCountOnBox_2 = 0
                                                        THEN inWeightOnBox_2 -- вложенность - 2
                                                        WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3 AND inCountOnBox_3 = 0
                                                        THEN inWeightOnBox_3 -- вложенность - 3
                                                   END
                             -- закрыли
                             THEN TRUE
    
                             -- еще рано закрывать
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
                                                                                                                    FROM (SELECT DISTINCT MovementItem.BarCodeBoxId
                                                                                                                          FROM wms_MI_WeighingProduction AS MovementItem
                                                                                                                          WHERE MovementItem.MovementId = inMovementId
                                                                                                                            AND MovementItem.isErased   = FALSE
                                                                                                                            AND MovementItem.ParentId   > 0
                                                                                                                         ) AS tmp
                                                                                                                   )
                                                                                                                 , 0) :: Integer
                                                                          , inFromId              := Movement.FromId
                                                                          , inToId                := Movement.ToId
                                                                          , inDocumentKindId      := 0
                                                                          , inPartionGoods        := ''
                                                                          , inIsProductionIn      := FALSE
                                                                          , inSession             := inSession
                                                                           )
                 FROM wms_Movement_WeighingProduction AS Movement WHERE Movement.Id = inMovementId;
    
                 -- в Документ еще сохранили <КАТЕГОРИЯ товара (груза)>
                 PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsTypeKind(), vbMovementId, vbGoodsTypeKindId);
                 -- в Документ еще сохранили <Ш/К ящика (груза)>
                 PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BarCodeBox(), vbMovementId, vbBarCodeBoxId);
    
    
                 -- Добавили элемент - zc_MI_Master
                 PERFORM gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := 0
                                                                       , inMovementId          := vbMovementId
                                                                       , inGoodsId             := Movement.GoodsId
                                                                       , inAmount              := CASE WHEN Movement.GoodsId = inGoodsId_sh OR inMeasureId = zc_Measure_Sh() THEN Movement.Amount ELSE Movement.RealWeight END
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
                 FROM (SELECT CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_sh AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh     ELSE Movement.GoodsId     END AS GoodsId
                            , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_sh AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsKindId_link_sh ELSE Movement.GoodsKindId END GoodsKindId
                            , SUM (MovementItem.RealWeight) AS RealWeight
                            , SUM (MovementItem.Amount)     AS Amount
                       FROM wms_Movement_WeighingProduction AS Movement
                            INNER JOIN wms_MI_WeighingProduction AS MovementItem
                                                                 ON MovementItem.MovementId      = Movement.Id
                                                                AND MovementItem.isErased        = FALSE
                                                                AND MovementItem.GoodsTypeKindId = vbGoodsTypeKindId
                                                                AND MovementItem.BarCodeBoxId    = vbBarCodeBoxId
                                                                AND MovementItem.ParentId        IS NULL
                       WHERE Movement.Id = inMovementId
                       GROUP BY CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_sh AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsId_link_sh     ELSE Movement.GoodsId     END
                              , CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_sh AND Movement.GoodsId_link_sh > 0 THEN Movement.GoodsKindId_link_sh ELSE Movement.GoodsKindId END
                      ) AS Movement;
    
    
    
                 -- Обнулили одну из линий - Ш/К для ящика
                 UPDATE wms_Movement_WeighingProduction SET BarCodeBoxId_1 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_1
                                                                                        THEN 0
                                                                                   ELSE wms_Movement_WeighingProduction.BarCodeBoxId_1
                                                                              END
                                                           , BarCodeBoxId_2 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_2
                                                                                        THEN 0
                                                                                   ELSE wms_Movement_WeighingProduction.BarCodeBoxId_2
                                                                              END
                                                           , BarCodeBoxId_3 = CASE WHEN vbGoodsTypeKindId = inGoodsTypeKindId_3
                                                                                        THEN 0
                                                                                   ELSE wms_Movement_WeighingProduction.BarCodeBoxId_3
                                                                              END
                 WHERE wms_Movement_WeighingProduction.Id = inMovementId
                ;
    
                 -- сохранили что 1 ящик ЗАКРЫТ
                 UPDATE wms_MI_WeighingProduction SET ParentId = vbMovementId
                 WHERE wms_MI_WeighingProduction.MovementId      = inMovementId
                -- AND wms_MI_WeighingProduction.isErased        = FALSE
                   AND wms_MI_WeighingProduction.ParentId        IS NULL
                   AND wms_MI_WeighingProduction.GoodsTypeKindId = vbGoodsTypeKindId
                   AND wms_MI_WeighingProduction.BarCodeBoxId    = vbBarCodeBoxId
                ;
             END IF; -- if vbIsFull = TRUE

         END IF; -- if inIsErrSave = FALSE

     END IF; -- if vbResultText = '' OR inIsErrSave = TRUE

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
            , vbResultText  AS ResultText
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
