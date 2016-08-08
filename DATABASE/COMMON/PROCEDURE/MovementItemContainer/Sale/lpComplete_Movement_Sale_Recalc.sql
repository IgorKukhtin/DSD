-- Function: lpComplete_Movement_Sale_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_Recalc (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_Recalc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUnitId            Integer  , -- 
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_Peresort Integer;
BEGIN
     -- Временно захардкодил - !!!только для этого склада!!!
     IF inUnitId = 8459 -- Склад Реализации
        -- AND inUserId = 5
     THEN

     -- Поиск "Пересортица"
     vbMovementId_Peresort:= (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Production());

     -- таблица - элементы
     CREATE TEMP TABLE _tmpItemPeresort_new (MovementItemId_to Integer, MovementItemId_from Integer, GoodsId_to Integer, GoodsKindId_to Integer, GoodsId_from Integer, GoodsKindId_from Integer, Amount_to TFloat) ON COMMIT DROP;

     -- элементы
     INSERT INTO _tmpItemPeresort_new (MovementItemId_to, MovementItemId_from, GoodsId_to, GoodsKindId_to, GoodsId_from, GoodsKindId_from, Amount_to)
        SELECT 0                                                      AS MovementItemId_to
             , 0                                                      AS MovementItemId_from
             , _tmpItem.GoodsId                                       AS GoodsId_to
             , _tmpItem.GoodsKindId                                   AS GoodsKindId_to
             , ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId     AS GoodsId_from
             , ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId AS GoodsKindId_from
             , SUM (_tmpItem.OperCount)                               AS Amount_to
        FROM _tmpItem
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                   ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = _tmpItem.GoodsId
                                  AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                   ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = _tmpItem.GoodsKindId
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsSub
                                   ON ObjectLink_GoodsByGoodsKind_GoodsSub.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                  AND ObjectLink_GoodsByGoodsKind_GoodsSub.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsSub()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId > 0
             INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindSub
                                   ON ObjectLink_GoodsByGoodsKind_GoodsKindSub.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub()
                                  AND ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId > 0
        WHERE _tmpItem.GoodsId      <> ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId
           OR _tmpItem.GoodsKindId  <> ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId
        GROUP BY _tmpItem.GoodsId
               , _tmpItem.GoodsKindId
               , ObjectLink_GoodsByGoodsKind_GoodsSub.ChildObjectId
               , ObjectLink_GoodsByGoodsKind_GoodsKindSub.ChildObjectId
       ;


     IF EXISTS (SELECT 1 FROM _tmpItemPeresort_new) AND '01.08.2016' <= (SELECT OperDate FROM Movement WHERE Id = inMovementId)
     THEN
         -- Распровели
         IF vbMovementId_Peresort <> 0
         THEN
             PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Peresort
                                          , inUserId     := inUserId
                                           );
         END IF;

         -- нашли MovementItemId - Master + Child
         UPDATE _tmpItemPeresort_new SET MovementItemId_to   = tmpMI.MovementItemId_to
                                       , MovementItemId_from = CASE WHEN _tmpItemPeresort_new.GoodsId_from = tmpMI.GoodsId_from AND _tmpItemPeresort_new.GoodsKindId_from = tmpMI.GoodsKindId_from
                                                                         THEN tmpMI.MovementItemId_from
                                                                    ELSE 0
                                                               END
         FROM (SELECT MovementItem.Id                                     AS MovementItemId_to
                    , MovementItem.ObjectId                               AS GoodsId_to
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId_to
                    , MI_Child.Id                                         AS MovementItemId_from
                    , MI_Child.ObjectId                                   AS GoodsId_from
                    , COALESCE (MILinkObject_GoodsKind_Child.ObjectId, 0) AS GoodsKindId_from
                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) AS Ord
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN MovementItem AS MI_Child
                                           ON MI_Child.MovementId = vbMovementId_Peresort
                                          AND MI_Child.DescId     = zc_MI_Child()
                                          AND MI_Child.isErased   = FALSE
                                          AND MI_Child.ParentId   = MovementItem.Id
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_Child
                                                     ON MILinkObject_GoodsKind_Child.MovementItemId = MI_Child.Id
                                                    AND MILinkObject_GoodsKind_Child.DescId = zc_MILinkObject_GoodsKind()
               WHERE MovementItem.MovementId = vbMovementId_Peresort
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
              ) AS tmpMI
         WHERE _tmpItemPeresort_new.GoodsId_to     = tmpMI.GoodsId_to
           AND _tmpItemPeresort_new.GoodsKindId_to = tmpMI.GoodsKindId_to
           AND tmpMI.Ord                           = 1
        ;

         -- создается документ - <Производство смешивание> - Пересортица
         vbMovementId_Peresort:= lpInsertUpdate_Movement_ProductionUnion (ioId             := vbMovementId_Peresort
                                                                        , inInvNumber      := CASE WHEN vbMovementId_Peresort <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = vbMovementId_Peresort) ELSE CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar) END
                                                                        , inOperDate       := (SELECT OperDate FROM Movement WHERE Id = inMovementId)
                                                                        , inFromId         := (SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                                        , inToId           := (SELECT ObjectId FROM MovementLinkObject AS MLO WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From())
                                                                        , inDocumentKindId := 0
                                                                        , inIsPeresort     := TRUE
                                                                        , inUserId         := inUserId
                                                                         );
         -- сохранили свойство <автоматически сформирован>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId_Peresort, TRUE);

         -- удаляются элементы - Master + Child
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                         , inUserId        := inUserId
                                          )
         FROM MovementItem
              LEFT JOIN (SELECT MovementItemId_to   AS MovementItemId FROM _tmpItemPeresort_new
                        UNION ALL
                         SELECT MovementItemId_from AS MovementItemId FROM _tmpItemPeresort_new
                       ) AS tmp ON tmp.MovementItemId = MovementItem.Id
         WHERE MovementItem.MovementId = vbMovementId_Peresort
           AND MovementItem.isErased   = FALSE
           AND tmp.MovementItemId IS NULL
        ;

         -- сохранили элементы - Master
         UPDATE _tmpItemPeresort_new SET MovementItemId_to = lpInsertUpdate_MI_ProductionUnion_Master
                                                  (ioId                     := _tmpItemPeresort_new.MovementItemId_to
                                                 , inMovementId             := vbMovementId_Peresort
                                                 , inGoodsId                := _tmpItemPeresort_new.GoodsId_to
                                                 , inAmount                 := _tmpItemPeresort_new.Amount_to
                                                 , inCount                  := 0
                                                 , inCuterWeight            := 0
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := _tmpItemPeresort_new.GoodsKindId_to
                                                 , inUserId                 := inUserId
                                                  );
         -- сохранили элементы - Child
         PERFORM lpInsertUpdate_MI_ProductionUnion_Child
                                                  (ioId                     := _tmpItemPeresort_new.MovementItemId_from
                                                 , inMovementId             := vbMovementId_Peresort
                                                 , inGoodsId                := _tmpItemPeresort_new.GoodsId_from
                                                 , inAmount                 := CASE WHEN ObjectFloat_Weight.ValueData <> 0 AND ObjectLink_Goods_Measure_to.ChildObjectId = zc_Measure_Sh()
                                                                                         THEN _tmpItemPeresort_new.Amount_to * ObjectFloat_Weight.ValueData
                                                                                    WHEN ObjectFloat_Weight.ValueData <> 0 AND ObjectLink_Goods_Measure_from.ChildObjectId = zc_Measure_Sh()
                                                                                         THEN _tmpItemPeresort_new.Amount_to / ObjectFloat_Weight.ValueData
                                                                                    ELSE _tmpItemPeresort_new.Amount_to
                                                                               END
                                                 , inParentId               := _tmpItemPeresort_new.MovementItemId_to
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := _tmpItemPeresort_new.GoodsKindId_from
                                                 , inGoodsKindCompleteId    := NULL
                                                 , inCount_onCount          := 0
                                                 , inUserId                 := inUserId
                                                  )
         FROM _tmpItemPeresort_new
              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_to ON ObjectLink_Goods_Measure_to.ObjectId = _tmpItemPeresort_new.GoodsId_to
                                                                 AND ObjectLink_Goods_Measure_to.DescId = zc_ObjectLink_Goods_Measure()
              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_from ON ObjectLink_Goods_Measure_from.ObjectId = _tmpItemPeresort_new.GoodsId_from
                                                                   AND ObjectLink_Goods_Measure_from.DescId = zc_ObjectLink_Goods_Measure()
              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                    ON ObjectFloat_Weight.ObjectId = CASE WHEN ObjectLink_Goods_Measure_to.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectLink_Goods_Measure_from.ChildObjectId, 0) <> zc_Measure_Sh()
                                                                               THEN ObjectLink_Goods_Measure_to.ObjectId
                                                                          WHEN ObjectLink_Goods_Measure_from.ChildObjectId = zc_Measure_Sh() AND COALESCE (ObjectLink_Goods_Measure_to.ChildObjectId, 0) <> zc_Measure_Sh()
                                                                               THEN ObjectLink_Goods_Measure_from.ObjectId
                                                                     END
                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight();

         -- Сохранили связь документов
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Production(), vbMovementId_Peresort, inMovementId);

         -- создаются временные таблицы - для формирование данных для проводок
         PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
         -- Проводим
         PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := vbMovementId_Peresort
                                                    , inIsHistoryCost  := TRUE
                                                    , inUserId         := inUserId)
        ;
         -- !!!обязательно!!! очистили таблицу проводок
         DELETE FROM _tmpMIContainer_insert;
         DELETE FROM _tmpMIReport_insert;
         -- !!!обязательно!!! удалили таблицы
         DROP TABLE _tmpItemChild;
         DROP TABLE _tmpItemSummChild;
         DROP TABLE _tmpItem_Partion;
         DROP TABLE _tmpItem_Partion_child;


     ELSE
         IF vbMovementId_Peresort <> 0 AND zc_Enum_Status_Erased() <> (SELECT StatusId FROM Movement WHERE Id = vbMovementId_Peresort)
         THEN
             PERFORM lpSetErased_Movement (inMovementId := vbMovementId_Peresort
                                         , inUserId     := inUserId
                                          );
         END IF;

     END IF;
     END IF; -- if ... Временно захардкодил - !!!только для этого склада!!!
     

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.08.16                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Sale_Recalc (inMovementId:= 4164174, inUnitId:= 8459, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpReComplete_Movement_Sale (inMovementId:= 4164174, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
