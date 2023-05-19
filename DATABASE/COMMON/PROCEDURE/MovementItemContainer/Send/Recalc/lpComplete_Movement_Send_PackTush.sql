-- Function: lpComplete_Movement_Send_PackTush (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Send_PackTush (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send_PackTush(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUnitId            Integer  , --
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_Tush Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- нашли дату
     vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);


     -- Временно захардкодил - !!!только для этого склада!!!
     IF -- ЦЕХ упаковки Тушенки
        8006902 = (SELECT DISTINCT _tmpItem.UnitId_From FROM _tmpItem)
        OR  (8451 = (SELECT DISTINCT _tmpItem.UnitId_From FROM _tmpItem) -- ЦЕХ упаковки
         AND 8459 = (SELECT DISTINCT _tmpItem.UnitId_To   FROM _tmpItem) -- Розподільчий комплекс
             AND EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_30102()) -- Тушенка
            )
     THEN
         -- таблица
         IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItemProduction_master'))
         THEN
             DELETE FROM _tmpItemProduction_master;
             DELETE FROM _tmpItemProduction_child;
         ELSE
             -- таблица - элементы
             CREATE TEMP TABLE _tmpItemProduction_master (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, ReceiptId Integer, Amount TFloat) ON COMMIT DROP;
             -- таблица - элементы
             CREATE TEMP TABLE _tmpItemProduction_child (MovementItemId Integer, ParentId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
         END IF;


         -- Поиск "Производство"
         vbMovementId_Tush:= (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Production());

         -- Распровели
         IF vbMovementId_Tush <> 0
         THEN
             PERFORM lpUnComplete_Movement (inMovementId := vbMovementId_Tush
                                          , inUserId     := inUserId
                                           );
         END IF;

         -- создается документ - <Производство смешивание>
         vbMovementId_Tush:= lpInsertUpdate_Movement_ProductionUnion (ioId             := vbMovementId_Tush
                                                                    , inInvNumber      := CASE WHEN vbMovementId_Tush <> 0 THEN (SELECT InvNumber FROM Movement WHERE Id = vbMovementId_Tush) ELSE CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar) END
                                                                    , inOperDate       := vbOperDate
                                                                    , inFromId         := inUnitId
                                                                    , inToId           := inUnitId
                                                                    , inDocumentKindId := 0
                                                                    , inIsPeresort     := FALSE
                                                                    , inUserId         := inUserId
                                                                     );
         -- сохранили свойство <автоматически сформирован>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId_Tush, TRUE);

         -- Сохранили связь документов
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Production(), vbMovementId_Tush, inMovementId);


         -- элементы - Master
         INSERT INTO _tmpItemProduction_master (MovementItemId, GoodsId, GoodsKindId, ReceiptId, Amount)
            SELECT 0                                                      AS MovementItemId
                 , _tmpItem.GoodsId                                       AS GoodsId
                 , _tmpItem.GoodsKindId                                   AS GoodsKindId
                 , MAX (ObjectLink_Receipt_Goods.ObjectId)                AS ReceiptId
                 , SUM (_tmpItem.OperCount)                               AS Amount
            FROM _tmpItem
                 INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                       ON ObjectLink_Receipt_Goods.ChildObjectId = _tmpItem.GoodsId
                                      AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                 LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                      ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                     AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                 INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                    AND Object_Receipt.isErased = FALSE
                 INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                          ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                         AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                         AND ObjectBoolean_Main.ValueData = TRUE
            WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = _tmpItem.GoodsKindId
              -- Тушенка
              AND _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_30102()
            GROUP BY _tmpItem.GoodsId
                   , _tmpItem.GoodsKindId
                    ;

         -- нашли MovementItemId - Master
         UPDATE _tmpItemProduction_master SET MovementItemId = tmpMI.MovementItemId
         FROM (SELECT MovementItem.Id                                     AS MovementItemId
                    , MovementItem.ObjectId                               AS GoodsId
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) AS Ord
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               WHERE MovementItem.MovementId = vbMovementId_Tush
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
              ) AS tmpMI
         WHERE _tmpItemProduction_master.GoodsId     = tmpMI.GoodsId
           AND _tmpItemProduction_master.GoodsKindId = tmpMI.GoodsKindId
           AND tmpMI.Ord                           = 1
        ;
         -- сохранили элементы - Master
         UPDATE _tmpItemProduction_master SET MovementItemId = tmpMI.MovementItemId_new
         FROM (SELECT tmp.MovementItemId_new, tmp.GoodsId, tmp.GoodsKindId
                      -- еще св-во связь с <Рецептуры>
                    , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), tmp.MovementItemId_new, tmp.ReceiptId)

               FROM (SELECT tmp.GoodsId, tmp.GoodsKindId, tmp.ReceiptId
                            -- сохранили элементы - Master
                          , lpInsertUpdate_MI_ProductionUnion_Master
                                                        (ioId                     := tmp.MovementItemId
                                                       , inMovementId             := vbMovementId_Tush
                                                       , inGoodsId                := tmp.GoodsId
                                                       , inAmount                 := tmp.Amount
                                                       , inCount                  := 0
                                                       , inCuterWeight            := 0
                                                       , inPartionGoodsDate       := NULL
                                                       , inPartionGoods           := NULL
                                                       , inPartNumber             := NULL
                                                       , inModel                  := NULL
                                                       , inGoodsKindId            := tmp.GoodsKindId
                                                       , inGoodsKindId_Complete   := NULL
                                                       , inStorageId              := NULL
                                                       , inUserId                 := inUserId
                                                        ) AS MovementItemId_new
                     FROM (-- взяли только там где есть ReceiptId
                           SELECT DISTINCT _tmpItemProduction_master.MovementItemId, _tmpItemProduction_master.GoodsId, _tmpItemProduction_master.GoodsKindId, _tmpItemProduction_master.ReceiptId, _tmpItemProduction_master.Amount
                           FROM _tmpItemProduction_master
                                LEFT JOIN MovementItem ON MovementItem.Id = _tmpItemProduction_master.MovementItemId
                           WHERE _tmpItemProduction_master.ReceiptId > 0
                             AND _tmpItemProduction_master.Amount <> COALESCE (MovementItem.Amount, 0)
                          ) AS tmp
                    ) AS tmp
              ) AS tmpMI
         WHERE _tmpItemProduction_master.GoodsId     = tmpMI.GoodsId
           AND _tmpItemProduction_master.GoodsKindId = tmpMI.GoodsKindId
          ;


         -- элементы - Child
         INSERT INTO _tmpItemProduction_child (MovementItemId, ParentId, GoodsId, GoodsKindId, Amount)
            SELECT 0                                                      AS MovementItemId
                 , _tmpItemProduction_master.MovementItemId               AS ParentId
                 , ObjectLink_ReceiptChild_Goods.ChildObjectId            AS GoodsId
                 , ObjectLink_ReceiptChild_GoodsKind.ChildObjectId        AS GoodsKindId
                 , SUM (CASE WHEN ObjectFloat_Value_master.ValueData <> 0 THEN _tmpItemProduction_master.Amount * COALESCE (ObjectFloat_Value.ValueData, 0) / ObjectFloat_Value_master.ValueData ELSE 0 END) AS Amount
            FROM _tmpItemProduction_master
                 LEFT JOIN ObjectFloat AS ObjectFloat_Value_master
                                       ON ObjectFloat_Value_master.ObjectId = _tmpItemProduction_master.ReceiptId
                                      AND ObjectFloat_Value_master.DescId   = zc_ObjectFloat_Receipt_Value()
                                      AND ObjectFloat_Value_master.ValueData <> 0
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                      ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = _tmpItemProduction_master.ReceiptId
                                     AND ObjectLink_ReceiptChild_Receipt.DescId        = zc_ObjectLink_ReceiptChild_Receipt()
                 LEFT JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id       = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                        AND Object_ReceiptChild.isErased = FALSE
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                      ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectLink_ReceiptChild_Goods.DescId   = zc_ObjectLink_ReceiptChild_Goods()
                 LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                      ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                     AND ObjectLink_ReceiptChild_GoodsKind.DescId   = zc_ObjectLink_ReceiptChild_GoodsKind()
                 LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                       ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                      AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptChild_Value()
            GROUP BY _tmpItemProduction_master.MovementItemId
                   , ObjectLink_ReceiptChild_Goods.ChildObjectId
                   , ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                    ;

         -- нашли MovementItemId - Child
         UPDATE _tmpItemProduction_child SET MovementItemId = tmpMI.MovementItemId
         FROM (SELECT MovementItem.Id                                     AS MovementItemId
                    , MovementItem.ParentId                               AS ParentId
                    , MovementItem.ObjectId                               AS GoodsId
                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId, MovementItem.ObjectId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) AS Ord
               FROM MovementItem
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
               WHERE MovementItem.MovementId = vbMovementId_Tush
                 AND MovementItem.DescId     = zc_MI_Child()
                 AND MovementItem.isErased   = FALSE
              ) AS tmpMI
         WHERE _tmpItemProduction_child.ParentId    = tmpMI.ParentId
           AND _tmpItemProduction_child.GoodsId     = tmpMI.GoodsId
           AND _tmpItemProduction_child.GoodsKindId = tmpMI.GoodsKindId
           AND tmpMI.Ord                            = 1
        ;


         -- сохранили элементы - Child
         UPDATE _tmpItemProduction_Child
            SET MovementItemId = CASE WHEN NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = _tmpItemProduction_Child.MovementItemId AND MovementItem.Amount = _tmpItemProduction_Child.Amount)
                                           THEN lpInsertUpdate_MI_ProductionUnion_Child (ioId                  := _tmpItemProduction_Child.MovementItemId
                                                                                       , inMovementId          := vbMovementId_Tush
                                                                                       , inGoodsId             := _tmpItemProduction_Child.GoodsId
                                                                                       , inAmount              := _tmpItemProduction_Child.Amount
                                                                                       , inParentId            := _tmpItemProduction_Child.ParentId
                                                                                       , inPartionGoodsDate    := NULL
                                                                                       , inPartionGoods        := NULL
                                                                                       , inPartNumber          := NULL
                                                                                       , inModel               := NULL
                                                                                       , inGoodsKindId         := _tmpItemProduction_Child.GoodsKindId
                                                                                       , inGoodsKindCompleteId := NULL
                                                                                       , inStorageId           := NULL
                                                                                       , inCount_onCount       := 0
                                                                                       , inUserId              := inUserId
                                                                                        )
                                      ELSE _tmpItemProduction_Child.MovementItemId
                                 END;

--    RAISE EXCEPTION 'Ошибка.<%>', (select count(*) from _tmpItemProduction_Chil);

         -- удаляются элементы - Master
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                         , inUserId        := inUserId
                                          )
         FROM MovementItem
              LEFT JOIN _tmpItemProduction_master ON _tmpItemProduction_master.MovementItemId = MovementItem.Id
         WHERE MovementItem.MovementId = vbMovementId_Tush
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND _tmpItemProduction_master.MovementItemId IS NULL
        ;
         -- удаляются элементы - Child
         PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                         , inUserId        := inUserId
                                          )
         FROM MovementItem
              LEFT JOIN _tmpItemProduction_child ON _tmpItemProduction_child.MovementItemId = MovementItem.Id
         WHERE MovementItem.MovementId = vbMovementId_Tush
           AND MovementItem.DescId     = zc_MI_Child()
           AND MovementItem.isErased   = FALSE
           AND _tmpItemProduction_child.MovementItemId IS NULL
        ;

         -- создаются временные таблицы - для формирование данных для проводок
         PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
         -- Проводим
         PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := vbMovementId_Tush
                                                    , inIsHistoryCost  := TRUE
                                                    , inUserId         := inUserId)
        ;
         -- !!!обязательно!!! очистили таблицу проводок
         DELETE FROM _tmpMIContainer_insert;
         DELETE FROM _tmpMIReport_insert;
         -- !!!обязательно!!! удалили таблицы
         DROP TABLE _tmpItem_pr;
         DROP TABLE _tmpItemSumm_pr;
         DROP TABLE _tmpItemChild;
         DROP TABLE _tmpItemSummChild;
         DROP TABLE _tmpItem_Partion;
         DROP TABLE _tmpItem_Partion_child;


     END IF; -- if ... Временно захардкодил - !!!только для этого склада!!!

     -- Админу только отладка
   --if inUserId = 5 then RAISE EXCEPTION 'Нет Прав и нет Проверки - что б ничего не делать'; end if;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.16                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Send_PackTush (inMovementId:= 4691383, inUnitId:= 8459, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpReComplete_Movement_SendOnPrice (inMovementId:= 4691383, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReComplete_Movement_Sale (inMovementId:= 4691383, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
