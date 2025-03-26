-- Function: gpInsertUpdate_MovementItem_WeighingPartner()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);*/

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingPartner (Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                   , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                   , TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingPartner(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inRealWeight          TFloat    , -- Реальный вес (без учета: минус тара и % скидки для кол-ва)
    IN inChangePercentAmount TFloat    , -- % скидки для кол-ва
    IN inCountTare           TFloat    , -- Количество тары
    IN inWeightTare          TFloat    , -- Вес тары

    IN inCountTare1          TFloat    , -- Количество ящ. вида1
    IN inWeightTare1         TFloat    , -- Вес ящ. вида1
    IN inCountTare2          TFloat    , -- Количество ящ. вида2
    IN inWeightTare2         TFloat    , -- Вес ящ. вида2
    IN inCountTare3          TFloat    , -- Количество ящ. вида3
    IN inWeightTare3         TFloat    , -- Вес ящ. вида3
    IN inCountTare4          TFloat    , -- Количество ящ. вида4
    IN inWeightTare4         TFloat    , -- Вес ящ. вида4
    IN inCountTare5          TFloat    , -- Количество ящ. вида5
    IN inWeightTare5         TFloat    , -- Вес ящ. вида5
    IN inCountTare6          TFloat    , -- Количество ящ. вида6
    IN inWeightTare6         TFloat    , -- Вес ящ. вида6
    IN inCountTare7          TFloat    , -- Количество ящ. вида7
    IN inWeightTare7         TFloat    , -- Вес ящ. вида7
    IN inCountTare8          TFloat    , -- Количество ящ. вида8
    IN inWeightTare8         TFloat    , -- Вес ящ. вида8
    IN inCountTare9          TFloat    , -- Количество ящ. вида9
    IN inWeightTare9         TFloat    , -- Вес ящ. вида9
    IN inCountTare10         TFloat    , -- Количество ящ. вида10
    IN inWeightTare10        TFloat    , -- Вес ящ. вида10

    IN inTareId_1              Integer   , --
    IN inTareId_2              Integer   , --
    IN inTareId_3              Integer   , --
    IN inTareId_4              Integer   , --
    IN inTareId_5              Integer   , --
    IN inTareId_6              Integer   , --
    IN inTareId_7              Integer   , --
    IN inTareId_8              Integer   , --
    IN inTareId_9              Integer   , --
    IN inTareId_10             Integer   , --

    IN inPartionCellId         Integer   , -- 

    IN inCountPack           TFloat    , -- Количество упаковок
    IN inHeadCount           TFloat    , -- Количество голов
    IN inBoxCount            TFloat    , -- Количество Ящик(гофро)
    IN inBoxNumber           TFloat    , -- Номер ящика
    IN inLevelNumber         TFloat    , -- Номер слоя
    IN inPrice               TFloat    , -- Цена
    IN inCountForPrice       TFloat    , -- Цена за количество
    IN inChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
    IN inPartionGoods        TVarChar  , -- Партия
    IN inPartionGoodsDate    TDateTime , -- Партия
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inPriceListId         Integer   , -- Прайс
    IN inBoxId               Integer   , -- Ящик(гофро)
    IN inMovementId_Promo    Integer   ,
    IN inIsBarCode           Boolean   , --
    IN inBranchCode          Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <MovementId-Акция>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, inMovementId_Promo);

     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- сохранили свойство <Дата/время создания>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     -- сохранили протокол
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);

     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- сохранили свойство <Реальный вес (без учета: минус тара и % скидки для кол-ва)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- сохранили свойство <% скидки для кол-ва>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);
     -- сохранили свойство <Количество упаковок>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);
     -- сохранили свойство <Количество голов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- сохранили свойство <Количество Ящик(гофро)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), ioId, inBoxCount);
     -- сохранили свойство <Номер ящика>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxNumber(), ioId, inBoxNumber);
     -- сохранили свойство <Номер слоя>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LevelNumber(), ioId, inLevelNumber);
     -- сохранили свойство <По сканеру>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), ioId, inIsBarCode);


     IF inBranchCode = 115
     THEN
         -- Еще сохранили № паспорта
         IF vbIsInsert = TRUE
         THEN
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionNum(), ioId, CAST (NEXTVAL ('MI_PartionPassport_seq') AS TFloat));
         END IF;
         

         -- Ячейка хранения 
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), ioId, inPartionCellId);

         -- Пользователь (создание)
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
         

         -- можно заполнить 5 параметров
         IF (CASE WHEN inCountTare1  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare2  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare3  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare4  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare5  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare6  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare7  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare8  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare9  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare10 > 0 THEN 1 ELSE 0 END) > 5
         THEN
             RAISE EXCEPTION 'Ошибка.Заполнено более 5 значений';
         END IF;
         
         -- можно заполнить
         IF inCountTare1 > 0 AND inCountTare2 > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Может быть указан только один вид поддона.';
         END IF;

         -- можно заполнить
         IF inCountTare1 NOT IN (0, 1)
         THEN
             RAISE EXCEPTION 'Ошибка.Кол-во поддонов может быть только = 1.';
         END IF;
         -- можно заполнить
         IF inCountTare2 NOT IN (0, 1)
         THEN
             RAISE EXCEPTION 'Ошибка.Кол-во поддонов может быть только = 1.';
         END IF;


         -- сохранили свойство <Количество упаковок>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountTare);
         -- сохранили свойство <Вес 1-ой упаковки>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightPack(), ioId, inWeightTare);

         PERFORM CASE WHEN tmp.Ord = 1 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), ioId, tmp.BoxId)
                      WHEN tmp.Ord = 2 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box2(), ioId, tmp.BoxId)
                      WHEN tmp.Ord = 3 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box3(), ioId, tmp.BoxId)
                      WHEN tmp.Ord = 4 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box4(), ioId, tmp.BoxId)
                      WHEN tmp.Ord = 5 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box5(), ioId, tmp.BoxId)
                 END
               , CASE WHEN tmp.Ord = 1 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 2 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare2(), ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 3 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare3(), ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 4 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare4(), ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 5 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare5(), ioId, tmp.CountTare ::TFloat)
                 END

               , CASE WHEN tmp.Ord = 1 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare1(), ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 2 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare2(), ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 3 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare3(), ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 4 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare4(), ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 5 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare5(), ioId, tmp.WeightTare ::TFloat)
                 END

         FROM (WITH tmpParamAll AS (SELECT inTareId_1 AS BoxId, COALESCE (inCountTare1,0) AS CountTare, COALESCE (inWeightTare1, 0) AS WeightTare, 1 AS npp
                          UNION ALL SELECT inTareId_2 AS BoxId, COALESCE (inCountTare2,0) AS CountTare, COALESCE (inWeightTare2, 0) AS WeightTare, 2 AS npp
                          UNION ALL SELECT inTareId_3 AS BoxId, COALESCE (inCountTare3,0) AS CountTare, COALESCE (inWeightTare3, 0) AS WeightTare, 3 AS npp
                          UNION ALL SELECT inTareId_4 AS BoxId, COALESCE (inCountTare4,0) AS CountTare, COALESCE (inWeightTare4, 0) AS WeightTare, 4 AS npp
                          UNION ALL SELECT inTareId_5 AS BoxId, COALESCE (inCountTare5,0) AS CountTare, COALESCE (inWeightTare5, 0) AS WeightTare, 5 AS npp
                          UNION ALL SELECT inTareId_6 AS BoxId, COALESCE (inCountTare6,0) AS CountTare, COALESCE (inWeightTare6, 0) AS WeightTare, 6 AS npp
                          UNION ALL SELECT inTareId_7 AS BoxId, COALESCE (inCountTare7,0) AS CountTare, COALESCE (inWeightTare7, 0) AS WeightTare, 7 AS npp
                          UNION ALL SELECT inTareId_8 AS BoxId, COALESCE (inCountTare8,0) AS CountTare, COALESCE (inWeightTare8, 0) AS WeightTare, 8 AS npp
                          UNION ALL SELECT inTareId_9 AS BoxId, COALESCE (inCountTare9,0) AS CountTare, COALESCE (inWeightTare9, 0) AS WeightTare, 9 AS npp
                          UNION ALL SELECT inTareId_10 AS BoxId, COALESCE (inCountTare10,0) AS CountTare, COALESCE (inWeightTare10, 0) AS WeightTare, 10 AS npp
                                   )
                     , tmpParam AS (SELECT tmpParamAll.*
                                         , ROW_NUMBER() OVER (ORDER BY tmpParamAll.npp) AS Ord
                                    FROM tmpParamAll
                                    WHERE tmpParamAll.CountTare <> 0 AND tmpParamAll.BoxId <> 0
                                      -- только поддоны
                                      AND tmpParamAll.npp <= 2

                                  UNION ALL
                                    SELECT tmpParamAll.*
                                         , 1 + ROW_NUMBER() OVER (ORDER BY tmpParamAll.npp) AS Ord
                                    FROM tmpParamAll
                                    WHERE tmpParamAll.CountTare <> 0 AND tmpParamAll.BoxId <> 0
                                      -- без поддонов
                                      AND tmpParamAll.npp > 2
                                   )
                            -- всегда 5 параметров если вдруг нужно что-то обнулить
                          , tmp AS (SELECT 1 AS Ord
                          UNION ALL SELECT 2 AS Ord
                          UNION ALL SELECT 3 AS Ord
                          UNION ALL SELECT 4 AS Ord
                          UNION ALL SELECT 5 AS Ord
                                    )
               SELECT COALESCE (tmpParam.BoxId, 0)      AS BoxId
                    , COALESCE (tmpParam.CountTare, 0)  AS CountTare
                    , COALESCE (tmpParam.WeightTare, 0) AS WeightTare
                    , tmp.Ord
               FROM tmp
                    LEFT JOIN tmpParam ON tmpParam.Ord = tmp.Ord
              ) AS tmp;

     ELSE

         -- сохранили свойство <Количество тары>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare(), ioId, inCountTare);
         -- сохранили свойство <Вес тары>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);

         -- сохранили свойство <Количество ящ. вида1>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), ioId, inCountTare1);
         -- сохранили свойство <Вес ящ. вида1>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare1(), ioId, inWeightTare1);
         -- сохранили свойство <Количество ящ. вида2>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare2(), ioId, inCountTare2);
         -- сохранили свойство <Вес ящ. вида2>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare2(), ioId, inWeightTare2);
         -- сохранили свойство <Количество ящ. вида3>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare3(), ioId, inCountTare3);
         -- сохранили свойство <Вес ящ. вида3>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare3(), ioId, inWeightTare3);
         -- сохранили свойство <Количество ящ. вида4>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare4(), ioId, inCountTare4);
         -- сохранили свойство <Вес ящ. вида4>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare4(), ioId, inWeightTare4);
         -- сохранили свойство <Количество ящ. вида5>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare5(), ioId, inCountTare5);
         -- сохранили свойство <Вес ящ. вида5>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare5(), ioId, inWeightTare5);
         -- сохранили свойство <Количество ящ. вида6>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare6(), ioId, inCountTare6);
         -- сохранили свойство <Вес ящ. вида6>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare6(), ioId, inWeightTare6);

     END IF;

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <Цена за количество>
     IF COALESCE (inCountForPrice, 0) = 0 THEN inCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);
     -- сохранили свойство <(-)% Скидки (+)% Наценки>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Прайс>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PriceList(), ioId, inPriceListId);
     -- сохранили связь с <Вид гофро. ящ.>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), ioId, inBoxId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.20         *
 13.11.15                                        *
 13.10.14                                        * all
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
