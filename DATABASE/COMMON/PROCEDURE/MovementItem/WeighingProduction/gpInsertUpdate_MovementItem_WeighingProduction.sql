-- Function: gpInsertUpdate_MovementItem_WeighingProduction()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                      , TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar
                                                                       );*/
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                      , TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar
                                                                       );

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WeighingProduction(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inIsStartWeighing     Boolean   , -- Режим начала взвешивания
    IN inRealWeight          TFloat    , -- Реальный вес (без учета: минус тара и прочее)
    IN inWeightTare          TFloat    , -- Вес тары
    IN inLiveWeight          TFloat    , -- Живой вес
    IN inHeadCount           TFloat    , -- Количество голов
    IN inCount               TFloat    , -- Количество батонов
    IN inCountPack           TFloat    , -- Количество упаковок
    IN inWeightPack          TFloat    , -- Вес 1-ой упаковки
    IN inCountSkewer1        TFloat    , -- Количество шпажек/крючков вида1
    IN inWeightSkewer1       TFloat    , -- Вес одной шпажки/крючка вида1
    IN inCountSkewer2        TFloat    , -- Количество шпажек вида2
    IN inWeightSkewer2       TFloat    , -- Вес одной шпажки вида2
    IN inWeightOther         TFloat    , -- Вес, прочее

    IN inCountTare1            TFloat    , -- Количество ящ. вида1
    IN inWeightTare1           TFloat    , -- Вес ящ. вида1
    IN inCountTare2            TFloat    , -- Количество ящ. вида2
    IN inWeightTare2           TFloat    , -- Вес ящ. вида2
    IN inCountTare3            TFloat    , -- Количество ящ. вида3
    IN inWeightTare3           TFloat    , -- Вес ящ. вида3
    IN inCountTare4            TFloat    , -- Количество ящ. вида4
    IN inWeightTare4           TFloat    , -- Вес ящ. вида4
    IN inCountTare5            TFloat    , -- Количество ящ. вида5
    IN inWeightTare5           TFloat    , -- Вес ящ. вида5
    IN inCountTare6            TFloat    , -- Количество ящ. вида6
    IN inWeightTare6           TFloat    , -- Вес ящ. вида6
    IN inCountTare7            TFloat    , -- Количество ящ. вида7
    IN inWeightTare7           TFloat    , -- Вес ящ. вида7
    IN inCountTare8            TFloat    , -- Количество ящ. вида8
    IN inWeightTare8           TFloat    , -- Вес ящ. вида8
    IN inCountTare9            TFloat    , -- Количество ящ. вида9
    IN inWeightTare9           TFloat    , -- Вес ящ. вида9
    IN inCountTare10           TFloat    , -- Количество ящ. вида10
    IN inWeightTare10          TFloat    , -- Вес ящ. вида10

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

    IN inPartionGoodsDate    TDateTime , -- Партия товара (дата)
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inNumberKVK           TVarChar  , -- № КВК
    IN inMovementItemId      Integer   , --
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inStorageLineId       Integer   , -- Линия пр-ва
    IN inPersonalId_KVK      Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Режим начала взвешивания>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_StartWeighing(), ioId, inIsStartWeighing);

     -- сохранили свойство <Дата/время создания>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);

     -- сохранили свойство <Реальный вес (без учета: минус тара и прочее)
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
     -- сохранили свойство <Вес тары>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare(), ioId, inWeightTare);
     -- сохранили свойство <Живой вес>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LiveWeight(), ioId, inLiveWeight);
     -- сохранили свойство <Количество голов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);
     -- сохранили свойство <Количество батонов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);
     -- сохранили свойство <Количество упаковок>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);
     -- сохранили свойство <Вес 1-ой упаковки>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightPack(), ioId, inWeightPack);



     -- сохранили свойство <Количество шпажек/крючков вида1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSkewer1(), ioId, inCountSkewer1);
     -- сохранили свойство <Вес одной шпажки/крючка вида1>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightSkewer1(), ioId, inWeightSkewer1);
     -- сохранили свойство <Количество шпажек вида2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountSkewer2(), ioId, inCountSkewer2);
     -- сохранили свойство <Вес одной шпажки вида2>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightSkewer2(), ioId, inWeightSkewer2);
     -- сохранили свойство <Вес, прочее>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightOther(), ioId, inWeightOther);

     -- сохранили свойство <MovementItemId - Партия производства>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMovementItemId);

     -- сохранили свойство <Партия товара (дата)>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
     -- сохранили свойство <№ КВК>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_KVK(), ioId, inNumberKVK);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- сохранили связь с <Линия пр-ва>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StorageLine(), ioId, inStorageLineId);
     -- сохранили связь с <Оператор КВК(Ф.И.О)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalKVK(), ioId, inPersonalId_KVK);


     IF inCountTare1  > 0
        OR inCountTare2  > 0
        OR inCountTare3  > 0
        OR inCountTare4  > 0
        OR inCountTare5  > 0
        OR inCountTare6  > 0
        OR inCountTare7  > 0
        OR inCountTare8  > 0
        OR inCountTare9  > 0
        OR inCountTare10 > 0
     THEN
         -- Еще сохранили № паспорта
         IF vbIsInsert = TRUE
         THEN
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionNum(), ioId, CAST (NEXTVAL ('MI_PartionPassport_seq') AS TFloat));
         END IF;

         -- Ячейка хранения
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), ioId, inPartionCellId);

         -- Автоматически
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, TRUE);


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

     END IF;

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
 10.05.15                                        * all
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_WeighingProduction (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
