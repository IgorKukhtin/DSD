-- Function: gpInsert_MovementItem_Inventory_bySeparate()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Inventory_bySeparate (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Inventory_bySeparate(
    IN inMovementId               Integer   , -- Ключ объекта <Документ инвенторизации>
    IN inMovementId_Separate      Integer   , -- Ключ объекта <Документ >
    IN inIsAdd                    Boolean   , -- добавить кол-во из накладной или отнять 
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbKoef Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     -- определяем нужно добавлять или минусовать кол-во из накладной перемещения
     vbKoef := (CASE WHEN inIsAdd = True THEN 1 ELSE -1 END);
     
     -- определяем
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());
     
     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE (tmp.MovementItemId, 0)
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmp.GoodsId
                                                  , inAmount             := COALESCE (tmp.Amount,0)
                                                  , inPartionGoodsDate   := CASE WHEN vbUnitId IN (8459 -- Склад Реализации
                                                                                                 , 8458 -- Склад База ГП
                                                                                                  )
                                                                                      THEN NULL
                                                                                  WHEN tmp.PartionGoodsDate = zc_DateStart() THEN NULL
                                                                                  ELSE tmp.PartionGoodsDate
                                                                            END
                                                  , inPrice              := 0
                                                  , inSumm               := 0
                                                  , inHeadCount          := 0
                                                  , inCount              := 0
                                                  , inPartionGoods       := tmp.PartionGoods
                                                  , inPartNumber         := NULL
                                                  , inPartionGoodsId     := NULL
                                                  , inGoodsKindId        := tmp.GoodsKindId
                                                  , inGoodsKindCompleteId:= tmp.GoodsKindCompleteId
                                                  , inAssetId            := NULL
                                                  , inUnitId             := NULL
                                                  , inStorageId          := NULL 
                                                  , inPartionModelId     := NULL
                                                  , inUserId             := vbUserId
                                                   )
     FROM (SELECT tmpMI.MovementItemId                                                          AS MovementItemId
                , COALESCE (tmpMI.GoodsId, tmpMI_Separate.GoodsId)                              AS GoodsId
                , COALESCE (tmpMI.GoodsKindId, tmpMI_Separate.GoodsKindId)                      AS GoodsKindId
                , COALESCE (tmpMI.GoodsKindCompleteId, 0)                                       AS GoodsKindCompleteId
                , COALESCE (tmpMI.PartionGoods, tmpMI_Separate.PartionGoods)                    AS PartionGoods
                , COALESCE (tmpMI.PartionGoodsDate, tmpMI_Separate.PartionGoodsDate)            AS PartionGoodsDate
                , (COALESCE (tmpMI.Amount, 0) + COALESCE (tmpMI_Separate.Amount, 0)) :: TFloat  AS Amount

           FROM (SELECT MovementItem.ObjectId                                    AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)            AS GoodsKindId
                      , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods
                      , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                      , SUM (MovementItem.Amount) * vbKoef                       AS Amount
                 FROM MovementItem
                    LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                               ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                              AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                              AND vbUnitId NOT IN (8459 -- Склад Реализации
                                                                 , 8458 -- Склад База ГП
                                                                  )
                    LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                 ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                WHERE MovementItem.MovementId = inMovementId_Separate
                  AND MovementItem.DescId     = zc_MI_Child()
                  AND MovementItem.isErased   = FALSE
                 GROUP BY MovementItem.ObjectId
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                        , COALESCE (MIString_PartionGoods.ValueData, '')
                        , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                ) tmpMI_Separate

                  LEFT JOIN (SELECT MovementItem.Id                                          AS MovementItemId
                                  , MovementItem.ObjectId                                    AS GoodsId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)            AS GoodsKindId
                                  , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)    AS GoodsKindCompleteId
                                  , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods
                                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                                  , MovementItem.Amount                                      AS Amount
                                    --  № п/п
                                  , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId
                                                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                                  , COALESCE (MIString_PartionGoods.ValueData, '')
                                                                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                                                       ORDER BY MovementItem.Amount DESC
                                                      ) AS Ord
                             FROM Movement
                                  INNER JOIN MovementItem ON Movement.id = MovementItem.MovementId
                                                         AND MovementItem.isErased = FALSE
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                   ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                               WHERE Movement.Id = inMovementId
                               ) AS tmpMI ON tmpMI.GoodsId          = tmpMI_Separate.GoodsId
                                         AND tmpMI.GoodsKindId      = tmpMI_Separate.GoodsKindId
                                         AND tmpMI.PartionGoods     = tmpMI_Separate.PartionGoods
                                         AND tmpMI.PartionGoodsDate = tmpMI_Separate.PartionGoodsDate
                                         AND tmpMI.Ord              = 1 -- !!!вдруг дублируются строки!!!
           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.01.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_bySeparate (ioId:= 0, inMovementId:= 10, inMovementId_Separate:= 1, inIsAdd := TRUE, inSession:= '2')
