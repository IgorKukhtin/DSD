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
/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                      , TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar
                                                                       );*/
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WeighingProduction (Integer, Integer, Integer, TFloat, Boolean
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                                      , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                                      , TDateTime, TDateTime, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar
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

    IN inPartionGoodsDate             TDateTime , -- Партия товара (дата)
    IN inPartionGoodsDate_PartionCell TDateTime , -- Партия товара (дата)

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
   DECLARE vbDescId_MILO_PartionCell Integer;
   DECLARE vbDescId_MIBoolean_PartionCell Integer;
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
        OR inPartionCellId > 0
     THEN
         -- Еще сохранили № паспорта
         IF vbIsInsert = TRUE
         THEN
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionNum(), ioId, CAST (NEXTVAL ('MI_PartionPassport_seq') AS TFloat));
         END IF;

         IF inPartionCellId > 0
         THEN
             -- находим свободную ячейку
             vbDescId_MILO_PartionCell:=
                (WITH tmpDesc_MILO AS (SELECT MovementItemLinkObjectDesc.Id AS DescId FROM MovementItemLinkObjectDesc
                                       WHERE MovementItemLinkObjectDesc.Id IN (zc_MILinkObject_PartionCell_1(), zc_MILinkObject_PartionCell_2(), zc_MILinkObject_PartionCell_3(), zc_MILinkObject_PartionCell_4(), zc_MILinkObject_PartionCell_5()
                                                                             , zc_MILinkObject_PartionCell_6(), zc_MILinkObject_PartionCell_7(), zc_MILinkObject_PartionCell_8(), zc_MILinkObject_PartionCell_9(), zc_MILinkObject_PartionCell_10()
                                                                             , zc_MILinkObject_PartionCell_11(), zc_MILinkObject_PartionCell_12(), zc_MILinkObject_PartionCell_13(), zc_MILinkObject_PartionCell_14(), zc_MILinkObject_PartionCell_15()
                                                                             , zc_MILinkObject_PartionCell_16(), zc_MILinkObject_PartionCell_17(), zc_MILinkObject_PartionCell_18(), zc_MILinkObject_PartionCell_19(), zc_MILinkObject_PartionCell_20()
                                                                             , zc_MILinkObject_PartionCell_21(), zc_MILinkObject_PartionCell_22()
                                                                              )
                                      )
                 , tmpMIBoolean AS (SELECT DISTINCT MIBoolean.MovementItemId
                                    FROM MovementItemBoolean AS MIBoolean
                                    WHERE MIBoolean.DescId IN (zc_MIBoolean_PartionCell_Close_1()
                                                             , zc_MIBoolean_PartionCell_Close_2()
                                                             , zc_MIBoolean_PartionCell_Close_3()
                                                             , zc_MIBoolean_PartionCell_Close_4()
                                                             , zc_MIBoolean_PartionCell_Close_5()
                                                             , zc_MIBoolean_PartionCell_Close_6()
                                                             , zc_MIBoolean_PartionCell_Close_7()
                                                             , zc_MIBoolean_PartionCell_Close_8()
                                                             , zc_MIBoolean_PartionCell_Close_9()
                                                             , zc_MIBoolean_PartionCell_Close_10()
                                                             , zc_MIBoolean_PartionCell_Close_11()
                                                             , zc_MIBoolean_PartionCell_Close_12()
                                                             , zc_MIBoolean_PartionCell_Close_13()
                                                             , zc_MIBoolean_PartionCell_Close_14()
                                                             , zc_MIBoolean_PartionCell_Close_15()
                                                             , zc_MIBoolean_PartionCell_Close_16()
                                                             , zc_MIBoolean_PartionCell_Close_17()
                                                             , zc_MIBoolean_PartionCell_Close_18()
                                                             , zc_MIBoolean_PartionCell_Close_19()
                                                             , zc_MIBoolean_PartionCell_Close_20()
                                                             , zc_MIBoolean_PartionCell_Close_21()
                                                             , zc_MIBoolean_PartionCell_Close_22()
                                                              )
                                      -- партия открыта
                                      AND MIBoolean.ValueData = FALSE
                                   )

                      -- нашли
                    , tmpMI AS (SELECT MovementItem.Id AS MovementItemId, MovementItem.MovementId
                                FROM MovementItem
                                WHERE MovementItem.Id IN (SELECT tmpMIBoolean.MovementItemId FROM tmpMIBoolean)
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  -- в ячейке товар
                                  AND MovementItem.ObjectId   = inGoodsId
                                  AND MovementItem.isErased   = FALSE
                               )
                 , tmpMILO_GoodsKind AS (SELECT MILO.*
                                         FROM MovementItemLinkObject AS MILO
                                         WHERE MILO.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                                           -- в ячейке вид
                                           AND MILO.ObjectId       = inGoodsKindId
                                           AND MILO.DescId         = zc_MILinkObject_GoodsKind()
                                        )
               , tmpMILO_PartionCell AS (SELECT MILO.*
                                         FROM MovementItemLinkObject AS MILO
                                         WHERE MILO.MovementItemId IN (SELECT DISTINCT tmpMILO_GoodsKind.MovementItemId FROM tmpMILO_GoodsKind)
                                           AND MILO.ObjectId       > 0
                                           AND MILO.DescId         IN (zc_MILinkObject_PartionCell_1(), zc_MILinkObject_PartionCell_2(), zc_MILinkObject_PartionCell_3(), zc_MILinkObject_PartionCell_4(), zc_MILinkObject_PartionCell_5()
                                                                     , zc_MILinkObject_PartionCell_6(), zc_MILinkObject_PartionCell_7(), zc_MILinkObject_PartionCell_8(), zc_MILinkObject_PartionCell_9(), zc_MILinkObject_PartionCell_10()
                                                                     , zc_MILinkObject_PartionCell_11(), zc_MILinkObject_PartionCell_12(), zc_MILinkObject_PartionCell_13(), zc_MILinkObject_PartionCell_14(), zc_MILinkObject_PartionCell_15()
                                                                     , zc_MILinkObject_PartionCell_16(), zc_MILinkObject_PartionCell_17(), zc_MILinkObject_PartionCell_18(), zc_MILinkObject_PartionCell_19(), zc_MILinkObject_PartionCell_20()
                                                                     , zc_MILinkObject_PartionCell_21(), zc_MILinkObject_PartionCell_22()
                                                                      )
                                        )
            , tmpMIDate_PartionGoods AS (SELECT MID.*
                                         FROM MovementItemDate AS MID
                                         WHERE MID.MovementItemId IN (SELECT DISTINCT tmpMILO_PartionCell.MovementItemId FROM tmpMILO_PartionCell)
                                           AND MID.DescId         = zc_MIDate_PartionGoods()
                                           AND MID.ValueData      > zc_DateStart()
                                        )
              , tmpMovement AS (SELECT Movement.*
                                FROM Movement
                                WHERE Movement.Id IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                               )

                , tmpMLO_To AS (SELECT MLO_To.*
                                FROM MovementLinkObject AS MLO_To
                                WHERE MLO_To.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                                  AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                  AND MLO_To.ObjectId   = zc_Unit_RK()
                               )
                   -- нашли занятые ячейки
                 , tmp_find AS (SELECT DISTINCT MILO.DescId
                                FROM tmpMILO_PartionCell AS MILO
                                     LEFT JOIN tmpMIDate_PartionGoods AS MIDate_PartionGoods
                                                                      ON MIDate_PartionGoods.MovementItemId = MILO.MovementItemId
                                                                   --AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                           
                                     INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementItemId = MILO.MovementItemId
                                     INNER JOIN tmpMILO_GoodsKind AS MILO_GoodsKind
                                                                  ON MILO_GoodsKind.MovementItemId = MILO.MovementItemId
                                                               --AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                                     LEFT JOIN tmpMovement AS Movement ON Movement.Id = MovementItem.MovementId
                           
                                     INNER JOIN tmpMLO_To AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                       --AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                       --AND MovementLinkObject_To.ObjectId   = zc_Unit_RK()
               
                                WHERE -- Перемещение + Взвешивание
                                      ((Movement.DescId = zc_Movement_Send() AND Movement.StatusId <> zc_Enum_Status_Erased())
                                    OR (Movement.DescId = zc_Movement_WeighingProduction() AND Movement.StatusId = zc_Enum_Status_UnComplete())
                                      )
                                  -- в ячейке Партия ...
                                  AND COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) = inPartionGoodsDate_PartionCell
                               )
                 -- Результат - находим свободную ячейку
                 SELECT tmpDesc_MILO.DescId
                 FROM tmpDesc_MILO
                      LEFT JOIN tmp_find ON tmp_find.DescId = tmpDesc_MILO.DescId
                 WHERE tmp_find.DescId IS NULL
                 ORDER BY tmpDesc_MILO.DescId ASC
                 LIMIT 1
                );
                       
             -- Проверка
             IF COALESCE (vbDescId_MILO_PartionCell, 0) = 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Все ячейки заняты.';
             END IF;

             -- находим свободную ячейку
             vbDescId_MIBoolean_PartionCell:= CASE vbDescId_MILO_PartionCell WHEN zc_MILinkObject_PartionCell_1()  THEN zc_MIBoolean_PartionCell_Close_1()
                                                                             WHEN zc_MILinkObject_PartionCell_2()  THEN zc_MIBoolean_PartionCell_Close_2()
                                                                             WHEN zc_MILinkObject_PartionCell_3()  THEN zc_MIBoolean_PartionCell_Close_3()
                                                                             WHEN zc_MILinkObject_PartionCell_4()  THEN zc_MIBoolean_PartionCell_Close_4()
                                                                             WHEN zc_MILinkObject_PartionCell_5()  THEN zc_MIBoolean_PartionCell_Close_5()
                                                                             WHEN zc_MILinkObject_PartionCell_6()  THEN zc_MIBoolean_PartionCell_Close_6()
                                                                             WHEN zc_MILinkObject_PartionCell_7()  THEN zc_MIBoolean_PartionCell_Close_7()
                                                                             WHEN zc_MILinkObject_PartionCell_8()  THEN zc_MIBoolean_PartionCell_Close_8()
                                                                             WHEN zc_MILinkObject_PartionCell_9()  THEN zc_MIBoolean_PartionCell_Close_9()
                                                                             WHEN zc_MILinkObject_PartionCell_10() THEN zc_MIBoolean_PartionCell_Close_10()
                                                                             WHEN zc_MILinkObject_PartionCell_11() THEN zc_MIBoolean_PartionCell_Close_11()
                                                                             WHEN zc_MILinkObject_PartionCell_12() THEN zc_MIBoolean_PartionCell_Close_12()
                                                                             WHEN zc_MILinkObject_PartionCell_13() THEN zc_MIBoolean_PartionCell_Close_13()
                                                                             WHEN zc_MILinkObject_PartionCell_14() THEN zc_MIBoolean_PartionCell_Close_14()
                                                                             WHEN zc_MILinkObject_PartionCell_15() THEN zc_MIBoolean_PartionCell_Close_15()
                                                                             WHEN zc_MILinkObject_PartionCell_16() THEN zc_MIBoolean_PartionCell_Close_16()
                                                                             WHEN zc_MILinkObject_PartionCell_17() THEN zc_MIBoolean_PartionCell_Close_17()
                                                                             WHEN zc_MILinkObject_PartionCell_18() THEN zc_MIBoolean_PartionCell_Close_18()
                                                                             WHEN zc_MILinkObject_PartionCell_19() THEN zc_MIBoolean_PartionCell_Close_19()
                                                                             WHEN zc_MILinkObject_PartionCell_20() THEN zc_MIBoolean_PartionCell_Close_20()
                                                                             WHEN zc_MILinkObject_PartionCell_21() THEN zc_MIBoolean_PartionCell_Close_21()
                                                                             WHEN zc_MILinkObject_PartionCell_22() THEN zc_MIBoolean_PartionCell_Close_22()
                                              END;

         END IF;

         -- Ячейка хранения
         IF inPartionCellId > 0
         THEN
             PERFORM lpInsertUpdate_MovementItemLinkObject (vbDescId_MILO_PartionCell, ioId, inPartionCellId);
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (vbDescId_MIBoolean_PartionCell, ioId, FALSE);

             -- сохранили в table
             PERFORM lpInsertUpdate_MI_PartionCell_table (inMovementId    := inMovementId
                                                        , inMovementItemId:= ioId
                                                        , inDescId_MILO   := vbDescId_MILO_PartionCell
                                                        , inPartionCellId := inPartionCellId
                                                        , inUserId        := vbUserId
                                                         );
         END IF;


         -- Автоматически
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, TRUE);


         -- можно заполнить 9 параметров
         IF (CASE WHEN inCountTare1  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare2  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare3  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare4  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare5  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare6  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare7  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare8  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare9  > 0 THEN 1 ELSE 0 END
           + CASE WHEN inCountTare10 > 0 THEN 1 ELSE 0 END) > 9
         THEN
             RAISE EXCEPTION 'Ошибка.Заполнено более 9 значений';
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


         PERFORM CASE WHEN tmp.Ord = 1  THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(),  ioId, tmp.BoxId)
                      WHEN tmp.Ord = 2  THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box2(),  ioId, tmp.BoxId)
                      WHEN tmp.Ord = 3  THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box3(),  ioId, tmp.BoxId)
                      WHEN tmp.Ord = 4  THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box4(),  ioId, tmp.BoxId)
                      WHEN tmp.Ord = 5  THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box5(),  ioId, tmp.BoxId)
                      WHEN tmp.Ord = 6  THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box6(),  ioId, tmp.BoxId)
                      WHEN tmp.Ord = 7  THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box7(),  ioId, tmp.BoxId)
                      WHEN tmp.Ord = 8  THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box8(),  ioId, tmp.BoxId)
                      WHEN tmp.Ord = 9  THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box9(),  ioId, tmp.BoxId)
                      WHEN tmp.Ord = 10 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box10(), ioId, tmp.BoxId)
                 END
               , CASE WHEN tmp.Ord = 1  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(),  ioId, 0) -- CASE WHEN vbUserId = 5 THEN 0 ELSE tmp.CountTare END
                      WHEN tmp.Ord = 2  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare2(),  ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 3  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare3(),  ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 4  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare4(),  ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 5  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare5(),  ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 6  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare6(),  ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 7  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare7(),  ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 8  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare8(),  ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 9  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare9(),  ioId, tmp.CountTare ::TFloat)
                      WHEN tmp.Ord = 10 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare10(), ioId, tmp.CountTare ::TFloat)
                 END

               , CASE WHEN tmp.Ord = 1  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare1(),  ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 2  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare2(),  ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 3  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare3(),  ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 4  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare4(),  ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 5  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare5(),  ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 6  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare6(),  ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 7  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare7(),  ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 8  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare8(),  ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 9  THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare9(),  ioId, tmp.WeightTare ::TFloat)
                      WHEN tmp.Ord = 10 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTare10(), ioId, tmp.WeightTare ::TFloat)
                 END

         FROM (WITH tmpParamAll AS (SELECT inTareId_1  AS BoxId, COALESCE (inCountTare1,0)  AS CountTare, COALESCE (inWeightTare1, 0)  AS WeightTare, 1  AS npp
                          UNION ALL SELECT inTareId_2  AS BoxId, COALESCE (inCountTare2,0)  AS CountTare, COALESCE (inWeightTare2, 0)  AS WeightTare, 2  AS npp
                          UNION ALL SELECT inTareId_3  AS BoxId, COALESCE (inCountTare3,0)  AS CountTare, COALESCE (inWeightTare3, 0)  AS WeightTare, 3  AS npp
                          UNION ALL SELECT inTareId_4  AS BoxId, COALESCE (inCountTare4,0)  AS CountTare, COALESCE (inWeightTare4, 0)  AS WeightTare, 4  AS npp
                          UNION ALL SELECT inTareId_5  AS BoxId, COALESCE (inCountTare5,0)  AS CountTare, COALESCE (inWeightTare5, 0)  AS WeightTare, 5  AS npp
                          UNION ALL SELECT inTareId_6  AS BoxId, COALESCE (inCountTare6,0)  AS CountTare, COALESCE (inWeightTare6, 0)  AS WeightTare, 6  AS npp
                          UNION ALL SELECT inTareId_7  AS BoxId, COALESCE (inCountTare7,0)  AS CountTare, COALESCE (inWeightTare7, 0)  AS WeightTare, 7  AS npp
                          UNION ALL SELECT inTareId_8  AS BoxId, COALESCE (inCountTare8,0)  AS CountTare, COALESCE (inWeightTare8, 0)  AS WeightTare, 8  AS npp
                          UNION ALL SELECT inTareId_9  AS BoxId, COALESCE (inCountTare9,0)  AS CountTare, COALESCE (inWeightTare9, 0)  AS WeightTare, 9  AS npp
                          UNION ALL SELECT inTareId_10 AS BoxId, COALESCE (inCountTare10,0) AS CountTare, COALESCE (inWeightTare10, 0) AS WeightTare, 10 AS npp
                                   )
                     , tmpParam AS (SELECT tmpParamAll.*
                                           -- здесь только № = 1
                                         , ROW_NUMBER() OVER (ORDER BY tmpParamAll.npp) AS Ord
                                    FROM tmpParamAll
                                    WHERE tmpParamAll.CountTare <> 0 AND tmpParamAll.BoxId <> 0
                                      -- только поддоны
                                      AND tmpParamAll.npp <= 2

                                  UNION ALL
                                    SELECT tmpParamAll.*
                                           -- всегда с № = 2
                                         , 1 + ROW_NUMBER() OVER (ORDER BY tmpParamAll.npp) AS Ord
                                    FROM tmpParamAll
                                    WHERE tmpParamAll.CountTare <> 0 AND tmpParamAll.BoxId <> 0
                                      -- без поддонов
                                      AND tmpParamAll.npp > 2
                                   )
                            -- всегда 5 параметров если вдруг нужно что-то обнулить
                          , tmp AS (SELECT 1  AS Ord
                          UNION ALL SELECT 2  AS Ord
                          UNION ALL SELECT 3  AS Ord
                          UNION ALL SELECT 4  AS Ord
                          UNION ALL SELECT 5  AS Ord
                          UNION ALL SELECT 6  AS Ord
                          UNION ALL SELECT 7  AS Ord
                          UNION ALL SELECT 8  AS Ord
                          UNION ALL SELECT 9  AS Ord
                          UNION ALL SELECT 10 AS Ord
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
