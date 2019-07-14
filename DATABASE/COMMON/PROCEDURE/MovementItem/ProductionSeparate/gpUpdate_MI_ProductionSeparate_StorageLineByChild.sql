-- Function: gpUpdate_MI_ProductionSeparate_StorageLineByChild()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_StorageLineByChild (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionSeparate_StorageLineByChild(
    IN inMovementId          Integer   , -- Id документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionSeparate_StorageLine());

     -- проверка 2
     -- если в мастере уже проставили линии, т.е. хотя бы одна - то ничего не делаем
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                      ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
                  AND COALESCE (MILinkObject_StorageLine.ObjectId, 0) <> 0
                LIMIT 1
                )
     THEN
        RETURN;
        -- RAISE EXCEPTION 'Ошибка.Распределение уже выполнено.';
     END IF;

     -- проверка 3
     -- если в чайлде нет проставленных линий, то тоже ничего не делаем
     IF NOT EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                          ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Child()
                      AND MovementItem.isErased   = FALSE
                      AND COALESCE (MILinkObject_StorageLine.ObjectId, 0) <> 0
                    LIMIT 1
                    )
     THEN
        RETURN;
        -- RAISE EXCEPTION 'Ошибка.Линии производства не выбраны для товара приход.';


     END IF;

     -- проверка
     -- если кол-во внизу больше, тогда надо выдать сообщение об ошибке
     IF EXISTS (SELECT 1
                FROM (SELECT SUM (CASE WHEN MovementItem.DescId = zc_MI_Child() THEN 0 ELSE MovementItem.Amount END) AS Amount_master
                           , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS Amount_child
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.isErased   = FALSE
                      ) AS tmp
                WHERE tmp.Amount_master < tmp.Amount_child
                )
     THEN
        RAISE EXCEPTION 'Ошибка.Количество приход превышает количество расход. Документ № <%> от <%>.'
                      , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                      , zfConvert_DateToString ((SELECT Movement.OperDate  FROM Movement WHERE Movement.Id = inMovementId))
                      ;
     END IF;


     -- данные
     vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);
     --
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
          -- Распроводим Документ
          PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                       , inUserId     := vbUserId);

     END IF;

     -- данные из мастера
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMI_Master'))
     THEN
         DELETE FROM tmpMI_Master;
     ELSE
         CREATE TEMP TABLE tmpMI_Master (GoodsId Integer, GoodsKindId Integer, Amount TFloat, LiveWeight TFloat, HeadCount TFloat) ON COMMIT DROP;
     END IF;
     --
     INSERT INTO tmpMI_Master (GoodsId, GoodsKindId, Amount, LiveWeight, HeadCount)
            SELECT MovementItem.ObjectId                             AS GoodsId
                 , MILinkObject_GoodsKind.ObjectId                   AS GoodsKindId
                 , SUM (MovementItem.Amount)                         AS Amount
                 , SUM (COALESCE (MIFloat_LiveWeight.ValueData, 0))  AS LiveWeight
                 , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))   AS HeadCount
            FROM MovementItem
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                             ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                            AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
                 LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                             ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                            AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.isErased   = FALSE
            GROUP BY MovementItem.ObjectId
                   , MILinkObject_GoodsKind.ObjectId;

     -- данные из чайлда
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMI_Child'))
     THEN
         DELETE FROM tmpMI_Child;
     ELSE
         CREATE TEMP TABLE tmpMI_Child (StorageLineId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;
     --
     INSERT INTO tmpMI_Child (StorageLineId, Amount)
            SELECT MILinkObject_StorageLine.ObjectId AS StorageLineId
                 , SUM (MovementItem.Amount)         AS Amount
            FROM MovementItem
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                  ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                 AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Child()
              AND MovementItem.isErased   = FALSE
            GROUP BY MILinkObject_StorageLine.ObjectId;


     -- удаляем строки мастера (расход)
     UPDATE MovementItem
     SET isErased = TRUE
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE;
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master();
     -- записываем новые строки в мастер
     PERFORM lpInsertUpdate_MI_ProductionSeparate_Master (ioId               := 0
                                                        , inMovementId       := inMovementId
                                                        , inGoodsId          := tmp.GoodsId
                                                        , inGoodsKindId      := tmp.GoodsKindId
                                                        , inStorageLineId    := COALESCE (tmp.StorageLineId, 0) :: Integer
                                                        , inAmount           := tmp.Amount                      :: TFloat
                                                        , inLiveWeight       := COALESCE (tmpMI_Master.LiveWeight, 0)         :: TFloat
                                                        , inHeadCount        := COALESCE (tmpMI_Master.HeadCount, 0)          :: TFloat
                                                        , inUserId           := vbUserId
                                                         )
     FROM (-- не пустые
           SELECT tmpMI_Master.GoodsId
                , tmpMI_Master.GoodsKindId
                , COALESCE (tmpMI_Child.StorageLineId, 0) AS StorageLineId
                , tmpMI_Child.Amount
                , ROW_NUMBER() OVER (ORDER BY COALESCE (tmpMI_Child.StorageLineId, 0)) AS ord
           FROM tmpMI_Master
                INNER JOIN tmpMI_Child ON COALESCE (tmpMI_Child.StorageLineId, 0) <> 0
          UNION
           --
           SELECT tmpMI_Master.GoodsId
                , tmpMI_Master.GoodsKindId
                , 0 AS StorageLineId
                , (tmpMI_Master.Amount - tmpMI_Child.Amount) AS Amount
                , -1 AS ord
           FROM tmpMI_Master
                LEFT JOIN (SELECT SUM (tmpMI_Child.Amount) AS Amount FROM tmpMI_Child WHERE COALESCE (tmpMI_Child.StorageLineId, 0) <> 0
                           ) AS tmpMI_Child ON 1= 1
           WHERE (tmpMI_Master.Amount - tmpMI_Child.Amount) <> 0
           ) AS tmp
           -- в одну из строк запишем значения LiveWeight и HeadCount
           LEFT JOIN tmpMI_Master ON tmp.ord = 1;


     -- !!!Для старого периода - меняем проводки!!!
     IF (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) < '01.11.2018'
     THEN
         UPDATE MovementItemContainer SET MovementItemId = tmpMI.MovementItemId_new
         FROM (WITH tmpMI_old AS (SELECT MovementItem.Id AS MovementItemId
                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = TRUE
                                 )
                  , tmpMI_new AS (SELECT MovementItem.Id AS MovementItemId
                                         -- № п/п
                                       , ROW_NUMBER() OVER (ORDER BY MovementItem.Amount DESC) AS Ord
                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                 )
               SELECT tmpMI_old.MovementItemId AS MovementItemId_old
                    , tmpMI_new.MovementItemId AS MovementItemId_new
               FROM tmpMI_old
                    INNER JOIN tmpMI_new ON tmpMI_new.Ord = 1
              ) AS tmpMI
         WHERE MovementItemContainer.MovementId = inMovementId
           AND tmpMI.MovementItemId_old         = MovementItemContainer.MovementItemId
        ;
     END IF;


     --
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
          -- Распроводим Документ
          PERFORM gpComplete_Movement_ProductionSeparate (inMovementId    := inMovementId
                                                        , inIsLastComplete:= FALSE
                                                        , inSession       := (-1 * vbUserId) :: TVarChar
                                                         );
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.18         *
*/

-- тест
-- select * from gpUpdate_MI_ProductionSeparate_StorageLineByChild(inMovementId := 5265525 ,  inSession := '5');