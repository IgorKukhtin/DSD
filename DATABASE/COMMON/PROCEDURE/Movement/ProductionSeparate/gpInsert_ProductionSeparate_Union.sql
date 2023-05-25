-- Function: gpInsert_ProductionSeparate_Union()

DROP FUNCTION IF EXISTS gpInsert_ProductionSeparate_Union (TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ProductionSeparate_Union(
   OUT outMovementId         Integer ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbFromId   Integer;
   DECLARE vbToId     Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPartionGoods_min TVarChar;
   DECLARE vbPartionGoods_max TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionSeparate());


    -- документы для объединения
    CREATE TEMP TABLE tmpListDoc (MovementId Integer, OperDate TDateTime, FromId Integer, ToId Integer, PartionGoods TVarchar) ON COMMIT DROP;
    INSERT INTO tmpListDoc(MovementId, OperDate, FromId, ToId, PartionGoods)
       WITH tmpMovement AS (SELECT Movement.Id
                                 , Movement.OperDate
                                 , MovementLinkObject_From.ObjectId         AS FromId
                                 , MovementLinkObject_To.ObjectId           AS ToId
                                 , MovementString_PartionGoods.ValueData    AS PartionGoods
                            FROM (SELECT DISTINCT LockUnique.KeyData ::Integer AS Id
                                  FROM LockUnique
                                  WHERE LockUnique.UserId = vbUserId
                                  ) AS tmp
                               INNER JOIN Movement ON Movement.Id = tmp.Id
                                                  AND Movement.DescId = zc_Movement_ProductionSeparate()
                                                  -- AND Movement.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
                               LEFT JOIN MovementString AS MovementString_PartionGoods
                                                        ON MovementString_PartionGoods.MovementId = Movement.Id
                                                       AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                           )
       -- Результат
       SELECT tmpMovement.Id , tmpMovement.OperDate, tmpMovement.FromId, tmpMovement.ToId, tmpMovement.PartionGoods
       FROM tmpMovement;


    /* проверка происходит при завписи в LockUnique
    -- проверка что одинаковая партия в выбранных документах
    IF (SELECT COUNT (DISTINCT tmpListDoc.FromId) FROM tmpListDoc) > 1
    THEN
       -- ошибка
       RAISE EXCEPTION 'Ошибка.Нельзя объединять документы из разных подразделений.';
    END IF;

    -- проверка что одинаковая партия в выбранных документах
    IF (SELECT COUNT (DISTINCT tmpListDoc.PartionGoods) FROM tmpListDoc) > 1
    THEN
       -- ошибка
       RAISE EXCEPTION 'Ошибка.Нельзя объединять документы с разными партиями.';
    END IF;
    */

    --выбираем строки документов
    CREATE TEMP TABLE tmpListMI (MovementId Integer, ToId Integer, DescId Integer, GoodsId Integer, GoodsKindId Integer, StorageLineId Integer, Amount TFloat, LiveWeight TFloat, HeadCount TFloat ) ON COMMIT DROP;
    INSERT INTO tmpListMI (MovementId, ToId, DescId, GoodsId, GoodsKindId, StorageLineId, Amount, LiveWeight, HeadCount)
      WITH
      tmpMI AS (SELECT MovementItem.MovementId AS MovementId
                     , tmpListDoc.ToId         AS ToId
                     , MovementItem.Id         AS Id
                     , MovementItem.DescId     AS DescId
                     , MovementItem.ObjectId   AS GoodsId
                     , MovementItem.Amount     AS Amount
                FROM tmpListDoc
                     JOIN MovementItem ON MovementItem.MovementId = tmpListDoc.MovementId
                             --AND MovementItem.DescId     = zc_MI_Master()   -- zc_MI_Child()
                                      AND MovementItem.isErased   = FALSE
               )
    , tmpMIFloat AS (SELECT MovementItemFloat.*
                     FROM MovementItemFloat
                     WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                       AND MovementItemFloat.DescId IN (zc_MIFloat_LiveWeight(), zc_MIFloat_HeadCount())
                    )
    , tmpMILO AS (SELECT MovementItemLinkObject.*
                     FROM MovementItemLinkObject
                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                       AND MovementItemLinkObject.DescId IN (zc_MILinkObject_StorageLine(), zc_MILinkObject_GoodsKind())
                 )
      -- Результат
      SELECT MovementItem.MovementId            AS MovementId
           , MovementItem.ToId                  AS ToId
           , MovementItem.DescId                AS DescId
           , MovementItem.GoodsId    		AS GoodsId
           , MILinkObject_GoodsKind.ObjectId    AS GoodsKindId
           , MILinkObject_StorageLine.ObjectId  AS StorageLineId
           , MovementItem.Amount		AS Amount
           , MIFloat_LiveWeight.ValueData       AS LiveWeight
           , MIFloat_HeadCount.ValueData 	AS HeadCount

       FROM tmpMI AS MovementItem
            LEFT JOIN tmpMIFloat AS MIFloat_LiveWeight
                                 ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
            LEFT JOIN tmpMIFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

            LEFT JOIN tmpMILO AS MILinkObject_StorageLine
                                             ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                            AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
            ;
    --
    /*
   -- проверка что одинаковый товар в мастере в выбранных документах
   IF (SELECT COUNT (DISTINCT tmpListMI.GoodsId) FROM tmpListMI WHERE tmpListMI.DescId = zc_MI_Master()) > 1
   THEN
      -- ошибка
      RAISE EXCEPTION 'Ошибка.Нельзя объединять документы с разными товарами.';
   END IF;
    */

    -- определили документ, из которого будут взяты данные шапки (мин Ид док. где от кого = кому)
    vbFromId  := (SELECT DISTINCT tmpListDoc.FromId FROM tmpListDoc);
    vbToId    := (SELECT CASE -- если есть хоть один приход в vbFromId
                              WHEN EXISTS (SELECT 1 FROM tmpListDoc WHERE tmpListDoc.ToId = vbFromId)
                                   THEN vbFromId
                              -- если есть приходы в разные ToId
                              WHEN EXISTS (SELECT 1 FROM tmpListDoc WHERE tmpListDoc.ToId NOT IN (SELECT MIN (tmpListDoc_ch.ToId) FROM tmpListDoc AS tmpListDoc_ch))
                                   THEN vbFromId
                              -- иначе все приходы в один ToId
                              ELSE (SELECT DISTINCT tmpListDoc.ToId FROM tmpListDoc)
                         END);
    vbOperDate:= (SELECT MIN (tmpListDoc.OperDate) FROM tmpListDoc);


   --
   SELECT MIN (tmpListDoc.PartionGoods), MAX (tmpListDoc.PartionGoods) INTO vbPartionGoods_min, vbPartionGoods_max FROM tmpListDoc;
   IF vbPartionGoods_min <> vbPartionGoods_max
   THEN
        RAISE EXCEPTION 'Ошибка.Нельзя объединить разные партии: <%> и <%>', vbPartionGoods_min, vbPartionGoods_max;
   END IF;


   IF EXISTS (SELECT 1 FROM tmpListDoc)
   THEN
       -- создаем 1 <Документ>
       outMovementId := (SELECT lpInsertUpdate_Movement_ProductionSeparate (ioId          := 0
                                                                          , inInvNumber   := CAST (NEXTVAL ('movement_productionseparate_seq') AS TVarChar)
                                                                          , inOperDate    := vbOperDate
                                                                          , inFromId      := vbFromId
                                                                          , inToId        := vbToId
                                                                          , inPartionGoods:= (SELECT DISTINCT tmpListDoc.PartionGoods FROM tmpListDoc)
                                                                          , inUserId      := vbUserId
                                                                           )
                        );
   END IF;

   -- сохраняем свойства - <Дата/время> + <пользователь>
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Union(), tmp.MovementId, CURRENT_TIMESTAMP)
         , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Union(), tmp.MovementId, vbUserId)
   FROM (SELECT tmpListDoc.MovementId FROM tmpListDoc
        UNION
         SELECT outMovementId AS MovementId WHERE outMovementId > 0
        ) AS tmp;


   -- сохранили <Элемент документа мастера>
   PERFORM lpInsertUpdate_MI_ProductionSeparate_Master (ioId               := 0
                                                      , inMovementId       := outMovementId
                                                      , inGoodsId          := tmpListMI.GoodsId
                                                      , inGoodsKindId      := tmpListMI.GoodsKindId
                                                      , inStorageLineId    := tmpListMI.StorageLineId
                                                      , inAmount           := SUM (COALESCE (tmpListMI.Amount,0))     :: TFloat
                                                      , inLiveWeight       := SUM (COALESCE (tmpListMI.LiveWeight,0)) :: TFloat
                                                      , inHeadCount        := SUM (COALESCE (tmpListMI.HeadCount,0))  :: TFloat
                                                      , inUserId           := vbUserId
                                                       )
   FROM tmpListMI
   WHERE tmpListMI.DescId = zc_MI_Master()
   GROUP BY tmpListMI.GoodsId
          , tmpListMI.GoodsKindId
          , tmpListMI.StorageLineId;

   -- сохранили <Элемент документа чайлд>
   PERFORM lpInsertUpdate_MI_ProductionSeparate_Child (ioId               := 0
                                                     , inMovementId       := outMovementId
                                                     , inParentId         := NULL
                                                     , inGoodsId          := tmpListMI.GoodsId
                                                     , inGoodsKindId      := tmpListMI.GoodsKindId
                                                     , inStorageLineId    := tmpListMI.StorageLineId
                                                     , inAmount           := SUM (COALESCE (tmpListMI.Amount,0))     :: TFloat
                                                     , inLiveWeight       := SUM (COALESCE (tmpListMI.LiveWeight,0)) :: TFloat
                                                     , inHeadCount        := SUM (COALESCE (tmpListMI.HeadCount,0))  :: TFloat
                                                     , inUserId           := vbUserId
                                                      )
   FROM tmpListMI
   WHERE tmpListMI.DescId = zc_MI_Child()
   GROUP BY tmpListMI.GoodsId
          , tmpListMI.GoodsKindId
          , tmpListMI.StorageLineId;


   -- документы ПЕремещения
   CREATE TEMP TABLE tmpListDocSend (ToId Integer, PartionGoods TVarChar, MovementId Integer) ON COMMIT DROP;
   INSERT INTO tmpListDocSend(ToId, PartionGoods, MovementId)
      SELECT tmp.ToId
           , tmp.PartionGoods
           , lpInsertUpdate_Movement_Send (ioId               := 0
                                         , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                         , inOperDate         := tmpDate.OperDate
                                         , inFromId           := vbFromId
                                         , inToId             := tmp.ToId
                                         , inDocumentKindId   := 0
                                         , inSubjectDocId     := 0
                                         , inComment          := '' ::TVarChar
                                         , inUserId           := vbUserId
                                          )
      FROM -- Кому надо Перемещать
           (SELECT DISTINCT tmpListDoc.ToId, tmpListDoc.PartionGoods FROM tmpListDoc WHERE tmpListDoc.ToId <> vbToId
           ) AS tmp
           -- в какую дату будет Перемещение
           INNER JOIN (SELECT tmpListDoc.ToId, MIN (tmpListDoc.OperDate) AS OperDate FROM tmpListDoc WHERE tmpListDoc.ToId <> vbToId GROUP BY tmpListDoc.ToId
                      ) AS tmpDate ON tmpDate.ToId = tmp.ToId;

   -- сохраняем свойства - <Дата/время> + <пользователь>
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Union(), tmp.MovementId, CURRENT_TIMESTAMP)
         , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Union(), tmp.MovementId, vbUserId)
   FROM tmpListDocSend AS tmp;


   -- строки док ПЕремещения
   PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := 0
                                           , inMovementId          := tmpListDocSend.MovementId
                                           , inGoodsId             := tmpListMI.GoodsId
                                           , inAmount              := tmpListMI.Amount       :: TFloat
                                           , inPartionGoodsDate    := NULL                   :: TDateTime
                                           , inCount               := 0                      :: TFloat
                                           , inHeadCount           := tmpListMI.HeadCount    :: TFloat
                                           , ioPartionGoods        := tmpListDocSend.PartionGoods
                                           , ioPartNumber          := NULL                   ::TVarChar
                                           , inGoodsKindId         := tmpListMI.GoodsKindId  :: Integer
                                           , inGoodsKindCompleteId := 0
                                           , inAssetId             := 0
                                           , inAssetId_two         := 0
                                           , inUnitId              := 0
                                           , inStorageId           := 0
                                           , inPartionModelId      := 0
                                           , inPartionGoodsId      := 0
                                           , inUserId              := vbUserId
                                            )
   FROM tmpListDocSend
        INNER JOIN (SELECT tmpListMI.ToId
                         , tmpListMI.GoodsId
                         , COALESCE (tmpListMI.GoodsKindId, 0)     AS GoodsKindId
                         , SUM (COALESCE (tmpListMI.Amount, 0))    AS Amount
                         , SUM (COALESCE (tmpListMI.HeadCount, 0)) AS HeadCount
                    FROM tmpListMI
                    WHERE tmpListMI.DescId = zc_MI_Child()
                    GROUP BY tmpListMI.ToId
                           , tmpListMI.GoodsId
                           , COALESCE (tmpListMI.GoodsKindId, 0)
                   ) AS tmpListMI ON tmpListMI.ToId = tmpListDocSend.ToId
   ;


   -- помечаем "предыдущие" док. на удаление
   PERFORM gpSetErased_Movement_ProductionSeparate (tmpListDoc.MovementId, inSession)
   FROM tmpListDoc;

   -- проводим новый док ProductionSeparate
   IF outMovementId > 0
   THEN
       PERFORM gpComplete_Movement_ProductionSeparate (outMovementId, FALSE, inSession);
   END IF;

   -- удаление после проводок ProductionSeparate
   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
   THEN
       DROP TABLE _tmpItem;
       DROP TABLE _tmpItemSumm;
   END IF;

   -- проводим новые док ProductionSeparate и Send
   PERFORM gpComplete_Movement_Send (tmp.MovementId, FALSE, inSession)
   FROM tmpListDocSend AS tmp
   WHERE COALESCE (tmp.MovementId, 0) <> 0 ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.18         *
*/

-- тест
-- SELECT * FROM gpInsert_ProductionSeparate_Union ( inSession:= '5')
