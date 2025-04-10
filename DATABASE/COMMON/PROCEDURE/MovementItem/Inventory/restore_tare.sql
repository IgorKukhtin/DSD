-- update MovementItem set Amount = Amount_calc from (

with tmpMI_ScaleCeh AS (SELECT 0 AS MovementItemId
                           , CASE WHEN zc_Movement_Inventory() = zc_Movement_ProductionUnion() AND FALSE = TRUE
                                       THEN CASE WHEN -123 > 0 THEN -123 ELSE zc_Goods_ReWork() END

                                  ELSE MovementItem.ObjectId
                             END AS GoodsId

                           , CASE WHEN zc_Movement_Inventory() = zc_Movement_ProductionUnion() AND FALSE = TRUE
                                       THEN zc_GoodsKind_Basis() -- NULL

                                  ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                             END AS GoodsKindId

                           , COALESCE (MILinkObject_StorageLine.ObjectId, 0) AS StorageLineId

                           , COALESCE (MILinkObject_Asset.ObjectId, 0)       AS AssetId
                           , COALESCE (MILinkObject_Asset_two.ObjectId, 0)   AS AssetId_two

                           , 0 :: Integer AS PartionCellId

                           , MIString_PartNumber.ValueData                   AS PartNumber

                           , CASE WHEN zc_Movement_Inventory() = zc_Movement_ProductionUnion() AND FALSE = TRUE
                                       THEN NULL
                                  WHEN TRUE = FALSE AND zc_Movement_Inventory() = zc_Movement_ProductionUnion()
                                       THEN NULL
                                  WHEN zc_Unit_RK() = zc_Unit_RK() -- Розподільчий комплекс
                                       AND 1=1
                                       --AND vbUserId <> 5 -- !!!tmp
                                       THEN COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())

                                  ELSE MIDate_PartionGoods.ValueData
                             END AS PartionGoodsDate

                           , CASE WHEN zc_Movement_Inventory() = zc_Movement_ProductionUnion() AND FALSE = TRUE
                                       THEN NULL
                                  WHEN TRUE = FALSE AND zc_Movement_Inventory() = zc_Movement_ProductionUnion()
                                       THEN ''
                                  ELSE COALESCE (MIString_PartionGoods.ValueData, '')
                             END AS PartionGoods

                           , CASE WHEN TRUE = FALSE AND zc_Movement_Inventory() = zc_Movement_ProductionUnion() AND -12345 = zc_Enum_DocumentKind_PackDiff()
                                       THEN MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                  WHEN TRUE = FALSE AND zc_Movement_Inventory() = zc_Movement_ProductionUnion()
                                       THEN 0
                                  ELSE MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                             END AS Amount -- !!! вес только для пересортицы в переработку!!
                           , CASE WHEN TRUE = FALSE AND zc_Movement_Inventory() = zc_Movement_ProductionUnion()

                                       THEN 0
                                  ELSE COALESCE (MIFloat_Count.ValueData, 0)
                             END AS Count
                           , CASE WHEN TRUE = FALSE AND zc_Movement_Inventory() = zc_Movement_ProductionUnion()
                                       THEN 0
                                  ELSE COALESCE (MIFloat_CountPack.ValueData, 0)
                             END AS CountPack
                           , CASE WHEN TRUE = FALSE AND zc_Movement_Inventory() = zc_Movement_ProductionUnion()
                                       THEN 0
                                  ELSE COALESCE (MIFloat_HeadCount.ValueData, 0)
                             END AS HeadCount
                           , CASE WHEN TRUE = FALSE AND zc_Movement_Inventory() = zc_Movement_ProductionUnion()
                                       THEN 0
                                  ELSE COALESCE (MIFloat_LiveWeight.ValueData, 0)
                             END AS LiveWeight

                           , MovementItem.Amount AS Amount_mi
                           , CASE WHEN zc_Movement_Inventory() = zc_Movement_Inventory()
                                       THEN 0 -- надо суммировать

                                  WHEN 1 = 101 -- если Упаковка
                                   AND zc_Movement_Inventory() = zc_Movement_Send()
                                       THEN MovementItem.Id -- не надо суммировать

                                  WHEN 1 BETWEEN 201 AND 210 -- если Обвалка
                                   AND zc_Movement_Inventory() = zc_Movement_ProductionUnion() AND FALSE = TRUE
                                       THEN 0 -- надо суммировать

                                  WHEN 1 NOT BETWEEN 201 AND 210 -- если НЕ Обвалка
                                       THEN 0 -- можно суммировать
                                  -- !!!Убрал т.к. раньше для Упаковки была какая-то другая схема ....!!!
                                  -- WHEN zc_Movement_Inventory() = zc_Movement_ProductionUnion() AND 1 BETWEEN 201 AND 210 -- если Обвалка
                                  --      THEN 0 -- надо суммировать
                                  ELSE MovementItem.Id -- пока не надо суммировать
                             END AS myId
                             
                             -- нужен чтоб найти ящики для инвентаризации
                           , CASE WHEN zc_Unit_RK() = zc_Unit_RK() AND zc_Movement_Inventory() = zc_Movement_Inventory()
                                   AND 1 = 1
                                   -- AND vbIsAuto = TRUE
                                       THEN MovementItem.Id
                                  ELSE 0
                             END AS MovementItemId_find

                           , COALESCE (MIFloat_MovementItemId.ValueData, 0) :: Integer AS MovementItemId_Partion

                      FROM MovementItem

                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                      AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                       ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                                       AND zc_Movement_Inventory() <> zc_Movement_ProductionSeparate() -- !!!надо убрать партии, т.к. в UNION их нет!!!
                                                       AND zc_Movement_Inventory() <> zc_Movement_ProductionUnion() -- !!!надо убрать партии, т.к. в UNION их нет!!!

                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                       AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                           LEFT JOIN MovementItemString AS MIString_KVK
                                                        ON MIString_KVK.MovementItemId = MovementItem.Id
                                                       AND MIString_KVK.DescId = zc_MIString_KVK()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalKVK
                                                            ON MILinkObject_PersonalKVK.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PersonalKVK.DescId         = zc_MILinkObject_PersonalKVK()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                            ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                                                           AND zc_Movement_Inventory()                <> zc_Movement_Inventory()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                            ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset.DescId         = zc_MILinkObject_Asset()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                            ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset_two.DescId         = zc_MILinkObject_Asset_two()
                           LEFT JOIN MovementItemFloat AS MIFloat_PartionCell
                                                       ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                               AND zc_Movement_Inventory() = zc_Movement_ProductionUnion() AND FALSE = TRUE -- !!!важно!!!
                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                 ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                                AND zc_Movement_Inventory() = zc_Movement_ProductionUnion() AND FALSE = TRUE -- !!!важно!!!

                      WHERE MovementItem.MovementId in ( 
30839496 
,  30839499 
, 30838383 
)
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     )


, tmp_1  as (-- элементы взвешивания - ТАРА
                      SELECT distinct OL_Box_Goods.ChildObjectId AS GoodsId
                      FROM tmpMI_ScaleCeh
                            INNER JOIN MovementItemFloat AS MIF_MovementItemId
                                                         ON MIF_MovementItemId.MovementItemId = tmpMI_ScaleCeh.MovementItemId_find
                                                        AND MIF_MovementItemId.DescId         = zc_MIFloat_MovementItemId()

                           INNER JOIN (SELECT zc_MIFloat_CountTare1() AS DescId_MIF, zc_MILinkObject_Box1() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare2() AS DescId_MIF, zc_MILinkObject_Box2() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare3() AS DescId_MIF, zc_MILinkObject_Box3() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare4() AS DescId_MIF, zc_MILinkObject_Box4() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare5() AS DescId_MIF, zc_MILinkObject_Box5() AS DescId_MILO
                                      ) AS tmpDesc ON tmpDesc.DescId_MIF > 0
                            INNER JOIN MovementItemFloat AS MIF_CountTare
                                                         ON MIF_CountTare.MovementItemId = MIF_MovementItemId.ValueData :: Integer
                                                        AND MIF_CountTare.DescId         = tmpDesc.DescId_MIF
                                                        AND MIF_CountTare.ValueData      > 0
                            INNER JOIN MovementItemLinkObject AS MILO_Box
                                                              ON MILO_Box.MovementItemId = MIF_MovementItemId.ValueData :: Integer
                                                             AND MILO_Box.DescId         = tmpDesc.DescId_MILO
                            INNER JOIN ObjectLink AS OL_Box_Goods
                                                  ON OL_Box_Goods.ObjectId = MILO_Box.ObjectId
                                                 AND OL_Box_Goods.DescId   = zc_ObjectLink_Box_Goods()

                      WHERE tmpMI_ScaleCeh.MovementItemId_find > 0
                      GROUP BY OL_Box_Goods.ChildObjectId
)

           -- элементы документа (были сохранены раньше)
          , tmpMI AS
                     (SELECT MovementItem.Id                                     AS MovementItemId
                           , MovementItem.ObjectId                               AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                           , CASE WHEN zc_Movement_Inventory() = zc_Movement_Inventory()
                                       -- Склад Реализации + Склад База ГП
                                 --AND MLO_From.ObjectId IN (8459, 8458)
                                       THEN 0
                                  ELSE COALESCE (MILinkObject_StorageLine.ObjectId, 0)
                             END AS StorageLineId

                           , COALESCE (MILinkObject_Asset.ObjectId, 0)                AS AssetId
                           , COALESCE (MILinkObject_Asset_two.ObjectId, 0)            AS AssetId_two
                         --, COALESCE (MIFloat_PartionCell.ValueData, 0)   :: Integer AS PartionCellId
                           , 0   :: Integer AS PartionCellId

                           , CASE
                                  WHEN zc_Unit_RK() = zc_Unit_RK() -- Розподільчий комплекс
                                       AND 1=1
                                       --AND vbUserId = 5 -- !!!tmp
                                       THEN COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())

                                  WHEN zc_Movement_Inventory() = zc_Movement_Inventory()
                                       -- Склад Реализации + Склад База ГП
                                   AND MLO_From.ObjectId IN (zc_Unit_RK(), 8458)
                                       THEN NULL
                                  ELSE MIDate_PartionGoods.ValueData
                             END AS PartionGoodsDate

                           , CASE WHEN zc_Movement_Inventory() = zc_Movement_Inventory()
                                       -- Склад Реализации + Склад База ГП
                                   AND MLO_From.ObjectId IN (zc_Unit_RK(), 8458)
                                       THEN ''
                                  ELSE COALESCE (MIString_PartionGoods.ValueData, '')
                             END AS PartionGoods

                           , MIString_PartNumber.ValueData                       AS PartNumber
                           , MovementItem.Amount                                 AS Amount
                           , COALESCE (MIFloat_Count.ValueData, 0)               AS Count
                           , COALESCE (MIFloat_CountPack.ValueData, 0)           AS CountPack
                           , COALESCE (MIFloat_HeadCount.ValueData, 0)           AS HeadCount
                           , COALESCE (MIFloat_LiveWeight.ValueData, 0)          AS LiveWeight

                           , 0                                                   AS Amount_mi
                           , 0                                                   AS myId

                           , 0                                                   AS MovementItemId_Partion

                             --  № п/п
                           , ROW_NUMBER() OVER (PARTITION BY -- Склад Реализации + Склад База ГП
                                                             CASE WHEN zc_Movement_Inventory() = zc_Movement_Inventory() AND MLO_From.ObjectId IN (zc_Unit_RK(), 8458) THEN 0 ELSE MovementItem.Id END
                                                           , MovementItem.ObjectId, MILinkObject_GoodsKind.ObjectId
                                                           , CASE WHEN zc_Unit_RK() = zc_Unit_RK()
                                                                   AND 1=1
                                                                       THEN COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                                                                  ELSE zc_DateStart()
                                                             END
                                                ORDER BY MovementItem.Amount DESC) AS Ord

                      FROM (SELECT zc_MI_Master() AS DescId, 0 AS Amount WHERE zc_Movement_Inventory() = zc_Movement_Inventory()
                           ) AS tmp
                           INNER JOIN MovementItem ON MovementItem.MovementId = 30840634
                                                  AND MovementItem.DescId     = tmp.DescId
                                                  AND MovementItem.isErased   = FALSE
                                                  AND MovementItem.Amount <> tmp.Amount
and MovementItem.ObjectId in (SELECT GoodsId from tmp_1 )
                      
                           LEFT JOIN MovementLinkObject AS MLO_From
                                                        ON MLO_From.MovementId = 30840634
                                                       AND MLO_From.DescId     = zc_MovementLinkObject_From()
                           LEFT JOIN MovementItemFloat AS MIFloat_Count
                                                       ON MIFloat_Count.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Count.DescId = zc_MIFloat_Count()
                           LEFT JOIN MovementItemFloat AS MIFloat_CountPack
                                                       ON MIFloat_CountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_CountPack.DescId = zc_MIFloat_CountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                       ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                      AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                           LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                       ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                      AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()

                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                        ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                       AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                           LEFT JOIN MovementItemString AS MIString_PartNumber
                                                        ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                       AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                                            ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                            ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset_two
                                                            ON MILinkObject_Asset_two.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Asset_two.DescId = zc_MILinkObject_Asset_two()
                           LEFT JOIN MovementItemFloat AS MIFloat_PartionCell
                                                       ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                      AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
where coalesce (MIFloat_Price.ValueData, 0) = 0
and MovementItem.Amount                    <> 53
and MovementItem.Amount                    <> 31
)


                SELECT 
-- x ,
MAX (tmp.MovementItemId)      AS MovementItemId_find
                     , tmp.MovementItemId_Partion
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , tmp.StorageLineId
                     , tmp.AssetId
                     , tmp.AssetId_two
                     , tmp.PartionCellId
                     , tmp.PartionGoodsDate
                     , tmp.PartionGoods
                     , tmp.PartNumber
                     , SUM (tmp.Amount)       AS Amount_calc
                     , SUM (tmp.Amount_two)       AS Amount_two
                     , SUM (tmp.Count)        AS Count
                     , SUM (tmp.CountPack)    AS CountPack
                     , SUM (tmp.HeadCount)    AS HeadCount
                     , SUM (tmp.LiveWeight)   AS LiveWeight
, tmp.myId
                FROM (-- элементы взвешивания - ТАРА
                      SELECT 1 as x 
, 0 AS MovementItemId
                           , OL_Box_Goods.ChildObjectId AS GoodsId

                           , 0 AS GoodsKindId

                           , 0 AS StorageLineId

                           , 0 AS AssetId
                           , 0 AS AssetId_two

                           , 0 AS PartionCellId

                           , '' AS PartNumber

                           , zc_DateStart() :: TDateTime AS PartionGoodsDate

                           , '' AS PartionGoods

                           , SUM (MIF_CountTare.ValueData) AS Amount
, 0 as Amount_two
                           , 0 AS Count
                           , 0 AS CountPack
                           , 0 AS HeadCount
                           , 0 AS LiveWeight

                           , SUM (MIF_CountTare.ValueData) AS Amount_mi
                           , 0 AS myId

                           , 0 AS MovementItemId_Partion

                      FROM tmpMI_ScaleCeh
                            INNER JOIN MovementItemFloat AS MIF_MovementItemId
                                                         ON MIF_MovementItemId.MovementItemId = tmpMI_ScaleCeh.MovementItemId_find
                                                        AND MIF_MovementItemId.DescId         = zc_MIFloat_MovementItemId()

                           INNER JOIN (SELECT zc_MIFloat_CountTare1() AS DescId_MIF, zc_MILinkObject_Box1() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare2() AS DescId_MIF, zc_MILinkObject_Box2() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare3() AS DescId_MIF, zc_MILinkObject_Box3() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare4() AS DescId_MIF, zc_MILinkObject_Box4() AS DescId_MILO
                                 UNION SELECT zc_MIFloat_CountTare5() AS DescId_MIF, zc_MILinkObject_Box5() AS DescId_MILO
                                      ) AS tmpDesc ON tmpDesc.DescId_MIF > 0
                            INNER JOIN MovementItemFloat AS MIF_CountTare
                                                         ON MIF_CountTare.MovementItemId = MIF_MovementItemId.ValueData :: Integer
                                                        AND MIF_CountTare.DescId         = tmpDesc.DescId_MIF
                                                        AND MIF_CountTare.ValueData      > 0
                            INNER JOIN MovementItemLinkObject AS MILO_Box
                                                              ON MILO_Box.MovementItemId = MIF_MovementItemId.ValueData :: Integer
                                                             AND MILO_Box.DescId         = tmpDesc.DescId_MILO
                            INNER JOIN ObjectLink AS OL_Box_Goods
                                                  ON OL_Box_Goods.ObjectId = MILO_Box.ObjectId
                                                 AND OL_Box_Goods.DescId   = zc_ObjectLink_Box_Goods()

                      WHERE tmpMI_ScaleCeh.MovementItemId_find > 0
-- and OL_Box_Goods.ChildObjectId  = 3538 
                      GROUP BY OL_Box_Goods.ChildObjectId

                     UNION ALL
                      -- элементы документа (были сохранены раньше)
                      SELECT 2 as x
, tmpMI.MovementItemId
                           , tmpMI.GoodsId
                           , tmpMI.GoodsKindId
                           , tmpMI.StorageLineId
                           , tmpMI.AssetId
                           , tmpMI.AssetId_two
                           , tmpMI.PartionCellId
                           , coalesce (tmpMI.PartNumber, '') as PartNumber
                           , tmpMI.PartionGoodsDate
                           , tmpMI.PartionGoods


                           , 0 as Amount -- tmpMI.Amount
, tmpMI.Amount as Amount_two
                           , tmpMI.Count
                           , tmpMI.CountPack
                           , tmpMI.HeadCount
                           , tmpMI.LiveWeight

                           , tmpMI.Amount_mi
                           , tmpMI.myId

                           , tmpMI.MovementItemId_Partion
                      FROM tmpMI
                      WHERE tmpMI.Ord = 1
                     ) AS tmp
-- where x = 1
where PartionGoodsDate = zc_DateStart() 

                GROUP BY tmp.MovementItemId_Partion
                       , tmp.GoodsId
                       , tmp.GoodsKindId
                       , tmp.StorageLineId
                       , tmp.AssetId
                       , tmp.AssetId_two
                       , tmp.PartionCellId
                       , tmp.PartionGoodsDate
                       , tmp.PartionGoods
                       , tmp.PartNumber
                       , tmp.myId -- если нет суммирования - каждое взвешивание в отдельной строчке

 -- ) as z
 -- where MovementItem.Id = z.MovementItemId_find


-- , x

-- select * from object where Id = 7945
--        select lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), 321076098, null);
-- select * from MovementItem where Id = 321076098 
-- update MovementItem set isErased = false where Id = 321076098 
-- update MovementItem set Amount = 1 where Id = 321076098 


-- select * from lpInsertUpdate_MovementItem(ioId := 0 , inDescId:=1, inObjectId := 5492   , inMovementId := 30840634 , inAmount := 1 , inParentId := NULL, inUserId:= zc_Enum_Process_Auto_PartionClose());