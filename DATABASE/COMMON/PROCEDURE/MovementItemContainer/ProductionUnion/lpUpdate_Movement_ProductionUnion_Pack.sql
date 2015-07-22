-- Function: lpUpdate_Movement_ProductionUnion_Pack (Boolean, TDateTime, TDateTime, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_ProductionUnion_Pack (Boolean, TDateTime, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ProductionUnion_Pack(
    IN inIsUpdate     Boolean   , --
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    -- 
    IN inUserId       Integer     -- Пользователь
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, isDelete Boolean, DescId_mi Integer, MovementItemId Integer, ContainerId Integer
             , OperCount TFloat, OperCount_Weight TFloat, OperCount_two TFloat
             , ReceiptCode_master Integer, ReceiptName_master TVarChar
             , GoodsCode_master Integer, GoodsName_master TVarChar, GoodsKindName_master TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , MovementItemId_master Integer, ContainerId_master Integer
              )
AS
$BODY$
BEGIN
     -- таблица - 
     CREATE TEMP TABLE _tmpResult (MovementId Integer, OperDate TDateTime, MovementItemId Integer, ContainerId Integer, GoodsId Integer, ReceiptId_master Integer, GoodsId_master Integer, DescId_mi Integer, OperCount TFloat, OperCount_Weight TFloat, OperCount_two TFloat, isDelete Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpResult_child (MovementId Integer, OperDate TDateTime, MovementItemId_master Integer, MovementItemId Integer, ContainerId_master Integer, ContainerId Integer, GoodsId Integer, OperCount TFloat, isDelete Boolean) ON COMMIT DROP;

     -- данные по приход/расход "цех Упаковки" + найденные MovementItemId (!!!для zc_MI_Child!!! здесь не определяется)
     INSERT INTO _tmpResult (MovementId, OperDate, MovementItemId, ContainerId, GoodsId, ReceiptId_master, GoodsId_master, DescId_mi, OperCount, OperCount_Weight, OperCount_two, isDelete)
             WITH tmpUnit AS (SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect -- Склады База + Реализации
                             UNION
                              SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (8460) AS lfSelect -- Возвраты общие
                             UNION
                              SELECT Object.Id AS UnitId FROM Object WHERE Object.Id = 8452-- Возвраты общие
                             )
                , tmpMI AS (-- получаем:
                            SELECT tmp.ContainerId
                                 , tmp.OperDate
                                 , tmp.DescId_mi
                                 , SUM (tmp.OperCount) AS OperCount
                            FROM
                            -- получаем движение: приход/расход
                           (SELECT MIContainer.ContainerId
                                 , MIContainer.OperDate
                                   -- расход будет zc_MI_Master() приход будет zc_MI_Child
                                 , CASE WHEN MIContainer.isActive = FALSE THEN zc_MI_Master() ELSE zc_MI_Child() END   AS DescId_mi
                                 , SUM (MIContainer.Amount * CASE WHEN MIContainer.isActive = TRUE THEN 1 ELSE -1 END) AS OperCount
                            FROM MovementItemContainer AS MIContainer
                                 INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.AnalyzerId
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.MovementDescId         = zc_Movement_Send()
                            GROUP BY MIContainer.ContainerId
                                   , MIContainer.OperDate
                                   , MIContainer.isActive
                           UNION
                            -- минус zc_Enum_AnalyzerId_ReWork
                            SELECT MIContainer.ContainerId
                                 , MIContainer.OperDate
                                 , zc_MI_Child() AS DescId_mi
                                 , SUM (MIContainer.Amount) AS OperCount
                            FROM MovementItemContainer AS MIContainer 
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.AnalyzerId             = zc_Enum_AnalyzerId_ReWork() -- 
                              AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                              AND MIContainer.isActive               = FALSE
                            GROUP BY MIContainer.ContainerId
                                   , MIContainer.OperDate
                           ) AS tmp
                            GROUP BY tmp.ContainerId
                                   , tmp.OperDate
                                   , tmp.DescId_mi
                            HAVING SUM (tmp.OperCount) > 0
                           )
            , tmpMI_all AS (-- существующее "производство" для isAuto = TRUE
                            SELECT MIContainer.MovementId
                                 , MIContainer.ContainerId
                                 , MIContainer.MovementItemId
                                 , MIContainer.OperDate
                                 , CASE WHEN MIContainer.isActive = TRUE THEN zc_MI_Master() ELSE zc_MI_Child() END AS DescId_mi
                            FROM MovementItemContainer AS MIContainer
                                 INNER JOIN MovementBoolean AS MovementBoolean_isAuto ON MovementBoolean_isAuto.MovementId = MIContainer.MovementId
                                                                                     AND MovementBoolean_isAuto.DescId     = zc_MovementBoolean_isAuto()
                                                                                     AND MovementBoolean_isAuto.ValueData  = TRUE
                            WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                              AND MIContainer.WhereObjectId_Analyzer = inUnitId
                              AND MIContainer.AnalyzerId             = inUnitId
                              AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
                           )
          , tmpMovement AS (-- поиск одного документа за OperDate
                            SELECT tmpMI_all.OperDate
                                 , MAX (tmpMI_all.MovementId) AS MovementId
                            FROM tmpMI_all
                            GROUP BY tmpMI_all.OperDate
                           )
           , tmpMI_find AS (-- нужен только один из элементов Прихода с пр-ва (по нему будет Update, иначе Insert, остальные Delete)
                            SELECT tmpMI_all.ContainerId
                                 , tmpMI_all.OperDate
                                 , MAX (tmpMI_all.MovementItemId) AS MovementItemId
                            FROM tmpMovement
                                 INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMovement.MovementId
                            WHERE tmpMI_all.DescId_mi = zc_MI_Master()
                            GROUP BY tmpMI_all.ContainerId
                                   , tmpMI_all.OperDate
                           )
         , tmpMI_result AS (-- данные по элементам Прихода с пр-ва
                            SELECT COALESCE (tmpMovement.MovementId, 0)    AS MovementId
                                 , COALESCE (tmpMI_find.MovementItemId, 0) AS MovementItemId
                                 , Container.ObjectId                      AS GoodsId
                                 , COALESCE (CLO_GoodsKind.ObjectId)       AS GoodsKindId
                                 , tmpMI.OperDate
                                 , tmpMI.ContainerId
                                 , tmpMI.DescId_mi
                                 , tmpMI.OperCount
                            FROM tmpMI
                                 LEFT JOIN tmpMovement ON tmpMovement.OperDate = tmpMI.OperDate
                                 LEFT JOIN Container ON Container.Id = tmpMI.ContainerId
                                 LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                               ON CLO_GoodsKind.ContainerId = tmpMI.ContainerId
                                                              AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                                 LEFT JOIN tmpMI_find ON tmpMI_find.ContainerId = tmpMI.ContainerId
                                                     AND tmpMI_find.OperDate    = tmpMI.OperDate
                                 LEFT JOIN tmpMI_all ON tmpMI_all.MovementItemId = tmpMI_find.MovementItemId
                            WHERE tmpMI.DescId_mi = zc_MI_Master() -- !!!т.е. приход!!!
                              AND tmpMI.OperCount <> 0
                           )
   , tmpMI_child_result AS (-- данные по элементам Расход на пр-во
                            SELECT Container.ObjectId                      AS GoodsId
                                 , tmpMI.OperDate
                                 , tmpMI.ContainerId
                                 , tmpMI.DescId_mi
                                 , tmpMI.OperCount
                            FROM tmpMI
                                 LEFT JOIN Container ON Container.Id = tmpMI.ContainerId
                            WHERE tmpMI.DescId_mi = zc_MI_Child()
                              AND tmpMI.OperCount <> 0
                           )
          , tmpMI_list AS (-- список найденных элементов Прихода с пр-ва
                            SELECT tmpMI_result.MovementId, 0                           AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementId     <> 0
                      UNION SELECT 0         AS MovementId, tmpMI_result.MovementItemId AS MovementItemId FROM tmpMI_result WHERE tmpMI_result.MovementItemId <> 0
                           )
            , tmpReceipt AS (-- поиск Рецептур
                             SELECT tmpGoods.GoodsId
                                  , tmpGoods.GoodsKindId
                                  , MAX (ObjectLink_Receipt_Goods.ObjectId) AS ReceiptId
                             FROM (SELECT tmpMI_result.GoodsId, tmpMI_result.GoodsKindId FROM tmpMI_result GROUP BY tmpMI_result.GoodsId, tmpMI_result.GoodsKindId) AS tmpGoods
                                  INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                        ON ObjectLink_Receipt_Goods.ChildObjectId = tmpGoods.GoodsId
                                                       AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                  INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                        ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                       AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                       AND ObjectLink_Receipt_GoodsKind.ChildObjectId = tmpGoods.GoodsKindId
                                  INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                     AND Object_Receipt.isErased = FALSE
                                  INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                           ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                          AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                          AND ObjectBoolean_Main.ValueData = TRUE
                             GROUP BY tmpGoods.GoodsId
                                    , tmpGoods.GoodsKindId
                            )

          -- Результат:
          -- элементы Прихода с пр-ва
          SELECT tmpMI_result.MovementId
               , tmpMI_result.OperDate
               , tmpMI_result.MovementItemId
               , tmpMI_result.ContainerId
               , tmpMI_result.GoodsId
               , COALESCE (tmpReceipt.ReceiptId, 0)                                             AS ReceiptId_master
               , COALESCE (ObjectLink_Receipt_Goods_parent.ChildObjectId, tmpMI_result.GoodsId) AS GoodsId_master
               , tmpMI_result.DescId_mi
               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN tmpMI_result.OperCount - COALESCE (tmpMI_child_result.OperCount, 0) ELSE 0 END AS OperCount
               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN tmpMI_result.OperCount - COALESCE (tmpMI_child_result.OperCount, 0) ELSE 0 END
               * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END AS OperCount_Weight
               , CASE WHEN tmpMI_result.OperCount > COALESCE (tmpMI_child_result.OperCount, 0) THEN COALESCE (tmpMI_child_result.OperCount, 0) ELSE tmpMI_result.OperCount END AS OperCount_two
               , FALSE AS isDelete
          FROM tmpMI_result
               LEFT JOIN tmpMI_child_result ON tmpMI_child_result.ContainerId = tmpMI_result.ContainerId
                                           AND tmpMI_child_result.OperDate    = tmpMI_result.OperDate
               LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId = tmpMI_result.GoodsId
                                   AND tmpReceipt.GoodsKindId = tmpMI_result.GoodsKindId
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent
                                     ON ObjectLink_Receipt_Parent.ObjectId = tmpReceipt.ReceiptId
                                    AND ObjectLink_Receipt_Parent.DescId   = zc_ObjectLink_Receipt_Parent()
               LEFT JOIN Object AS Object_Receipt_parent ON Object_Receipt_parent.Id       = ObjectLink_Receipt_Parent.ChildObjectId
                                                         AND Object_Receipt_parent.isErased = FALSE
               LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_parent
                                     ON ObjectLink_Receipt_Goods_parent.ObjectId = ObjectLink_Receipt_Parent.ChildObjectId
                                    AND ObjectLink_Receipt_Goods_parent.DescId   = zc_ObjectLink_Receipt_Goods()
                                    AND ObjectLink_Receipt_Goods_parent.ChildObjectId > 0

               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI_result.GoodsId
                                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
               LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                     ON ObjectFloat_Weight.ObjectId = tmpMI_result.GoodsId
                                    AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
         UNION ALL
          -- данные все "новые" расходы (понадобятся потом)
          SELECT 0 AS MovementId
               , tmpMI_child_result.OperDate
               , 0 AS MovementItemId
               , tmpMI_child_result.ContainerId
               , tmpMI_child_result.GoodsId
               , 0 AS ReceiptId_master -- не нужен
               , 0 AS GoodsId_master   -- не нужен
               , tmpMI_child_result.DescId_mi
               , CASE WHEN tmpMI_child_result.OperCount > COALESCE (tmpMI_result.OperCount, 0) THEN tmpMI_child_result.OperCount - COALESCE (tmpMI_result.OperCount, 0) ELSE 0 END AS OperCount
               , 0 AS OperCount_Weight -- не нужен
               , tmpMI_child_result.OperCount AS OperCount_two -- информативно, для теста
               , FALSE AS isDelete
          FROM tmpMI_child_result
               LEFT JOIN tmpMI_result ON tmpMI_result.ContainerId = tmpMI_child_result.ContainerId
                                     AND tmpMI_result.OperDate    = tmpMI_child_result.OperDate

         UNION ALL
          -- данные все существующие расходы (понадобятся потом)
          SELECT tmpMI_all.MovementId
               , tmpMI_all.OperDate
               , tmpMI_all.MovementItemId
               , tmpMI_all.ContainerId
               , 0 AS GoodsId          -- не нужен
               , 0 AS ReceiptId_master -- не нужен
               , 0 AS GoodsId_master   -- не нужен
               , tmpMI_all.DescId_mi
               , 0 AS OperCount            -- не нужен
               , 0 AS OperCount_Weight     -- не нужен
               , 0 AS OperCount_two        -- не нужен
               , FALSE AS isDelete
          FROM tmpMI_all
          WHERE tmpMI_all.DescId_mi = zc_MI_Child()
         UNION
          -- документы которые надо удалить
          SELECT tmpMI_all.MovementId
               , zc_DateStart() AS OperDate
               , 0 AS MovementItemId
               , 0 AS ContainerId
               , 0 AS GoodsId
               , 0 AS ReceiptId_master
               , 0 AS GoodsId_master
               , tmpMI_all.DescId_mi
               , 0 AS OperCount
               , 0 AS OperCount_Weight
               , 0 AS OperCount_two
               , TRUE AS isDelete
          FROM tmpMI_all
               LEFT JOIN tmpMI_list ON tmpMI_list.MovementId = tmpMI_all.MovementId
          WHERE tmpMI_all.DescId_mi = zc_MI_Master() -- !!!только для zc_MI_Master!!!
            AND tmpMI_list.MovementId IS NULL
         UNION
          -- элементы которые надо удалить
          SELECT tmpMI_all.MovementId     AS MovementId
               , zc_DateStart()           AS OperDate
               , tmpMI_all.MovementItemId AS MovementItemId
               , 0 AS ContainerId
               , 0 AS GoodsId
               , 0 AS ReceiptId_master
               , 0 AS GoodsId_master
               , tmpMI_all.DescId_mi
               , 0 AS OperCount
               , 0 AS OperCount_Weight
               , 0 AS OperCount_two
               , TRUE AS isDelete
          FROM tmpMI_all
               LEFT JOIN tmpMI_list ON tmpMI_list.MovementItemId = tmpMI_all.MovementItemId
          WHERE tmpMI_all.DescId_mi = zc_MI_Master() -- !!!только для zc_MI_Master!!!
            AND tmpMI_list.MovementItemId IS NULL
         ;



     -- данные
     INSERT INTO _tmpResult_child (MovementId, OperDate, MovementItemId_master, MovementItemId, ContainerId_master, ContainerId, GoodsId, OperCount, isDelete)
       WITH tmpResult_MI_all AS (-- находим ParentId всем существующим элементам Расхода на пр-во
                                 SELECT _tmpResult.*, MovementItem.ParentId
                                 FROM _tmpResult
                                      INNER JOIN MovementItem ON MovementItem.Id = _tmpResult.MovementItemId
                                 WHERE _tmpResult.DescId_mi = zc_MI_Child()
                                   AND _tmpResult.MovementItemId > 0
                                )
       , tmpResult_MI_find_all AS (-- выбираем только 1-н для каждого ContainerId + ParentId
                                   SELECT tmpResult_MI_all.ContainerId, MAX (tmpResult_MI_all.MovementItemId) AS MovementItemId
                                   FROM tmpResult_MI_all
                                   GROUP BY tmpResult_MI_all.ContainerId, tmpResult_MI_all.ParentId
                                  )
           , tmpResult_MI_find AS (-- получили все параметры для выбранных
                                   SELECT tmpResult_MI_all.*
                                   FROM tmpResult_MI_find_all
                                        LEFT JOIN tmpResult_MI_all ON tmpResult_MI_all.MovementItemId = tmpResult_MI_find_all.MovementItemId
                                  )

          , tmpResult_master AS (-- взяли данные, которые будут в zc_MI_Master
                                 SELECT _tmpResult.* FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Master() AND _tmpResult.isDelete = FALSE AND (_tmpResult.OperCount + _tmpResult.OperCount_two) > 0)
           , tmpResult_child AS (-- взяли данные, которые будут в zc_MI_Child
                                 SELECT _tmpResult.* FROM _tmpResult WHERE _tmpResult.DescId_mi = zc_MI_Child()  AND _tmpResult.isDelete = FALSE AND _tmpResult.OperCount > 0)

          , tmpAll AS (-- данные zc_MI_Master, если будут делаться из найденных "главных" товаров
                       SELECT tmpResult_master.OperDate, tmpResult_master.GoodsId, tmpResult_master.GoodsId_master            FROM tmpResult_master WHERE tmpResult_master.OperCount > 0 GROUP BY tmpResult_master.OperDate, tmpResult_master.GoodsId, tmpResult_master.GoodsId_master
                      UNION
                       -- данные zc_MI_Master, еще могут делаться из самих себя
                       SELECT tmpResult_master.OperDate, tmpResult_master.GoodsId, tmpResult_master.GoodsId AS GoodsId_master FROM tmpResult_master WHERE tmpResult_master.OperCount > 0 GROUP BY tmpResult_master.OperDate, tmpResult_master.GoodsId
                      )
          , tmpAll_total AS (-- итог по будущим zc_MI_Master, если бы товаром был "из чего будет делаться"
                             SELECT tmpResult_master.OperDate, tmpAll.GoodsId_master, SUM (tmpResult_master.OperCount_Weight) AS OperCount_Weight
                             FROM tmpAll
                                  INNER JOIN tmpResult_master ON tmpResult_master.GoodsId = tmpAll.GoodsId AND tmpResult_master.OperDate = tmpAll.OperDate
                             GROUP BY tmpResult_master.OperDate, tmpAll.GoodsId_master
                            )
                              
          , tmpResult_new AS (-- результат - распределение + нашли им существующие MovementItemId
                              SELECT tmpResult_MI_find.MovementId     AS MovementId
                                   , tmpResult_child.OperDate         AS OperDate
                                   , tmpResult_master.MovementItemId  AS MovementItemId_master
                                   , tmpResult_master.ContainerId     AS ContainerId_master
                                   , tmpResult_MI_find.MovementItemId AS MovementItemId
                                   , tmpResult_child.ContainerId      AS ContainerId
                                   , tmpResult_child.GoodsId          AS GoodsId
                                   , tmpResult_child.OperCount * tmpResult_master.OperCount_Weight / tmpAll_total.OperCount_Weight AS OperCount
                                   , FALSE AS isPeresort
                              FROM tmpResult_child
                                   INNER JOIN tmpAll_total     ON tmpAll_total.GoodsId_master     = tmpResult_child.GoodsId
                                                              AND tmpAll_total.OperDate           = tmpResult_child.OperDate
                                   INNER JOIN tmpResult_master ON tmpResult_master.GoodsId_master = tmpResult_child.GoodsId
                                                              AND tmpResult_master.OperDate       = tmpResult_child.OperDate
                                                              AND tmpResult_master.OperCount     <> 0 
                                   LEFT JOIN tmpResult_MI_find ON tmpResult_MI_find.ParentId    = tmpResult_master.MovementItemId
                                                              AND tmpResult_MI_find.ContainerId = tmpResult_child.ContainerId
                             UNION ALL
                              -- добавлена "пересортица" + нашли им существующие MovementItemId
                              SELECT tmpResult_MI_find.MovementId     AS MovementId
                                   , tmpResult_master.OperDate        AS OperDate
                                   , tmpResult_master.MovementItemId  AS MovementItemId_master
                                   , tmpResult_master.ContainerId     AS ContainerId_master
                                   , tmpResult_MI_find.MovementItemId AS MovementItemId
                                   , tmpResult_master.ContainerId     AS ContainerId
                                   , tmpResult_master.GoodsId         AS GoodsId
                                   , tmpResult_master.OperCount_two   AS OperCount
                                   , TRUE AS isPeresort
                              FROM tmpResult_master
                                   LEFT JOIN tmpResult_MI_find ON tmpResult_MI_find.ParentId    = tmpResult_master.MovementItemId
                                                              AND tmpResult_MI_find.ContainerId = tmpResult_master.ContainerId
                              WHERE tmpResult_master.OperCount_two > 0
                             )
         , tmpResult_diff AS (-- Итог - сколько получилось погрешности на "копейки" после распределения
                              SELECT tmpResult_child.OperDate                  AS OperDate
                                   , tmpResult_child.ContainerId               AS ContainerId
                                   , tmpResult_child.OperCount - tmp.OperCount AS OperCount
                              FROM (SELECT tmpResult_new.OperDate, tmpResult_new.ContainerId, SUM (tmpResult_new.OperCount) AS OperCount FROM tmpResult_new WHERE tmpResult_new.isPeresort = FALSE GROUP BY tmpResult_new.OperDate, tmpResult_new.ContainerId) AS tmp
                                   INNER JOIN tmpResult_child  ON tmpResult_child.ContainerId     = tmp.ContainerId
                                                              AND tmpResult_child.OperDate        = tmp.OperDate
                              WHERE tmp.OperCount <> tmpResult_child.OperCount
                             )
    , tmpResult_diff_find AS (-- находим для "погрешности" такой ContainerId: сначала с MAX (OperCount) потом MAX (ContainerId_master)
                              SELECT tmp.OperDate                           AS OperDate
                                   , tmp.ContainerId                        AS ContainerId
                                   , MAX (tmpResult_new.ContainerId_master) AS ContainerId_master
                              FROM (SELECT tmpResult_diff.OperDate, tmpResult_diff.ContainerId, MAX (tmpResult_new.OperCount) AS OperCount
                                    FROM tmpResult_diff
                                         INNER JOIN tmpResult_new ON tmpResult_new.ContainerId =  tmpResult_diff.ContainerId
                                    GROUP BY tmpResult_diff.OperDate, tmpResult_diff.ContainerId
                                   ) AS tmp
                                   INNER JOIN tmpResult_new ON tmpResult_new.OperDate    =  tmp.OperDate
                                                           AND tmpResult_new.ContainerId =  tmp.ContainerId
                                                           AND tmpResult_new.OperCount   =  tmp.OperCount
                              GROUP BY tmp.OperDate, tmp.ContainerId
                             )
          -- элементы
          SELECT tmpResult_new.MovementId
               , tmpResult_new.OperDate
               , tmpResult_new.MovementItemId_master
               , tmpResult_new.MovementItemId
               , tmpResult_new.ContainerId_master
               , tmpResult_new.ContainerId
               , tmpResult_new.GoodsId
               , tmpResult_new.OperCount + COALESCE (tmpResult_diff.OperCount, 0) AS OperCount
               , FALSE AS isDelete
          FROM tmpResult_new
               LEFT JOIN tmpResult_diff_find ON tmpResult_diff_find.OperDate           = tmpResult_new.OperDate
                                            AND tmpResult_diff_find.ContainerId_master = tmpResult_new.ContainerId_master
                                            AND tmpResult_diff_find.ContainerId = tmpResult_new.ContainerId
               LEFT JOIN tmpResult_diff ON tmpResult_diff.OperDate    = tmpResult_diff_find.OperDate
                                       AND tmpResult_diff.ContainerId = tmpResult_diff_find.ContainerId
         UNION ALL
          -- элементы которые надо удалить
          SELECT tmpResult_MI_all.MovementId
               , zc_DateStart() AS OperDate
               , 0 AS MovementItemId_master
               , tmpResult_MI_all.MovementItemId
               , 0 AS ContainerId_master
               , 0 AS ContainerId
               , 0 AS GoodsId
               , 0 AS OperCount
               , TRUE AS isDelete
          FROM tmpResult_MI_all
               LEFT JOIN tmpResult_new ON tmpResult_new.MovementItemId = tmpResult_MI_all.MovementItemId
          WHERE tmpResult_new.MovementItemId IS NULL
      ;


     -- !!!не всегда!!!
     IF inIsUpdate = TRUE
     THEN

     -- Распроводим
     PERFORM lpUnComplete_Movement (inMovementId     := tmp.MovementId
                                  , inUserId         := zc_Enum_Process_Auto_Pack())
     FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.MovementId <> 0 GROUP BY _tmpResult.MovementId) AS tmp
          INNER JOIN Movement ON Movement.Id = tmp.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete();

     -- удаляются документы !!!важно MovementItemId = 0!!!
     PERFORM lpSetErased_Movement (inMovementId:= tmp.MovementId
                                 , inUserId    := zc_Enum_Process_Auto_Pack()
                                  )
     FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = TRUE AND _tmpResult.MovementId <> 0 AND _tmpResult.MovementItemId = 0 GROUP BY _tmpResult.MovementId) AS tmp
    ;
     -- удаляются элементы - Master
     PERFORM lpSetErased_MovementItem (inMovementItemId:= _tmpResult.MovementItemId
                                     , inUserId        := zc_Enum_Process_Auto_Pack()
                                      )
     FROM _tmpResult
          LEFT JOIN _tmpResult AS _tmpResult_movement ON _tmpResult_movement.MovementId     = _tmpResult.MovementId
                                                     AND _tmpResult_movement.isDelete       = TRUE
                                                     AND _tmpResult_movement.MovementItemId = 0 -- !!!важно MovementItemId = 0!!!
     WHERE _tmpResult.isDelete = TRUE AND _tmpResult.MovementItemId <> 0
       AND _tmpResult_movement.MovementId IS NULL -- т.е. только те которые не попали в удаление документов
    ;
     -- удаляются элементы - Child
     PERFORM lpSetErased_MovementItem (inMovementItemId:= _tmpResult_child.MovementItemId
                                     , inUserId        := zc_Enum_Process_Auto_Pack()
                                      )
     FROM _tmpResult_child
          LEFT JOIN _tmpResult AS _tmpResult_movement ON _tmpResult_movement.MovementId     = _tmpResult_child.MovementId
                                                     AND _tmpResult_movement.isDelete       = TRUE
                                                     AND _tmpResult_movement.MovementItemId = 0 -- !!!важно MovementItemId = 0!!!
     WHERE _tmpResult_child.isDelete = TRUE -- AND _tmpResult_child.MovementItemId <> 0
       AND _tmpResult_movement.MovementId IS NULL -- т.е. только те которые не попали в удаление документов
    ;

     -- создаются документы - <Производство смешивание>
     UPDATE _tmpResult SET MovementId = tmp.MovementId
     FROM (SELECT tmp.OperDate
                , lpInsertUpdate_Movement_ProductionUnion (ioId                    := 0
                                                         , inInvNumber             := CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar)
                                                         , inOperDate              := tmp.OperDate
                                                         , inFromId                := inUnitId
                                                         , inToId                  := inUnitId
                                                         , inIsPeresort            := FALSE
                                                         , inUserId                := zc_Enum_Process_Auto_Pack()
                                                          ) AS MovementId
           FROM (SELECT _tmpResult.OperDate
                 FROM _tmpResult
                 WHERE _tmpResult.MovementId = 0 AND _tmpResult.isDelete = FALSE
                 GROUP BY _tmpResult.OperDate
                 ) AS tmp
          ) AS tmp
     WHERE _tmpResult.OperDate = tmp.OperDate;


     -- сохраняются элементы - Master
     UPDATE _tmpResult SET MovementItemId = lpInsertUpdate_MI_ProductionUnion_Master
                                                  (ioId                     := _tmpResult.MovementItemId
                                                 , inMovementId             := _tmpResult.MovementId
                                                 , inGoodsId                := _tmpResult.GoodsId
                                                 , inAmount                 := _tmpResult.OperCount + _tmpResult.OperCount_two
                                                 , inCount                  := 0
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := tmp.GoodsKindId
                                                 , inUserId                 := zc_Enum_Process_Auto_Pack()
                                                  )
     FROM (SELECT _tmpResult.ContainerId, CLO_GoodsKind.ObjectId AS GoodsKindId
           FROM _tmpResult
                LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                              ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                             AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
           WHERE _tmpResult.DescId_mi   = zc_MI_Master()
             AND _tmpResult.isDelete    = FALSE
           GROUP BY _tmpResult.ContainerId, CLO_GoodsKind.ObjectId
          ) AS tmp
     WHERE _tmpResult.ContainerId = tmp.ContainerId
       AND _tmpResult.DescId_mi   = zc_MI_Master()
       AND _tmpResult.isDelete    = FALSE;


     -- сохраняются элементы - Child из распределения
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child
                                                  (ioId                     := _tmpResult_child.MovementItemId
                                                 , inMovementId             := _tmpResult.MovementId
                                                 , inGoodsId                := _tmpResult_child.GoodsId
                                                 , inAmount                 := _tmpResult_child.OperCount
                                                 , inParentId               := _tmpResult.MovementItemId
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                 , inCount_onCount          := 0
                                                 , inUserId                 := zc_Enum_Process_Auto_Pack()
                                                  )
     FROM _tmpResult_child
          LEFT JOIN _tmpResult ON _tmpResult.ContainerId = _tmpResult_child.ContainerId_master
                              AND _tmpResult.OperDate    = _tmpResult_child.OperDate
                              AND _tmpResult.DescId_mi   = zc_MI_Master()
                              AND _tmpResult.isDelete    = FALSE
          LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                        ON CLO_GoodsKind.ContainerId = _tmpResult_child.ContainerId
                                       AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
     WHERE _tmpResult_child.isDelete    = FALSE;

     -- сохраняются элементы - Child из рецепта
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child
                                                  (ioId                     := 0
                                                 , inMovementId             := _tmpResult.MovementId
                                                 , inGoodsId                := ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                 , inAmount                 := (_tmpResult.OperCount + _tmpResult.OperCount_two) * ObjectFloat_Value.ValueData / ObjectFloat_Value_master.ValueData
                                                 , inParentId               := _tmpResult.MovementItemId
                                                 , inPartionGoodsDate       := NULL
                                                 , inPartionGoods           := NULL
                                                 , inGoodsKindId            := ObjectLink_ReceiptChild_GoodsKind.ChildObjectId
                                                 , inCount_onCount          := 0
                                                 , inUserId                 := zc_Enum_Process_Auto_Pack()
                                                  )
     FROM _tmpResult
                              INNER JOIN ObjectFloat AS ObjectFloat_Value_master
                                                     ON ObjectFloat_Value_master.ObjectId = _tmpResult.ReceiptId_master
                                                    AND ObjectFloat_Value_master.DescId = zc_ObjectFloat_Receipt_Value()
                                                    AND ObjectFloat_Value_master.ValueData <> 0
                              INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt
                                                   ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = _tmpResult.ReceiptId_master
                                                  AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                              INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                                      AND Object_ReceiptChild.isErased = FALSE
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_Goods
                                                   ON ObjectLink_ReceiptChild_Goods.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_Goods.DescId = zc_ObjectLink_ReceiptChild_Goods()
                              LEFT JOIN ObjectLink AS ObjectLink_ReceiptChild_GoodsKind
                                                   ON ObjectLink_ReceiptChild_GoodsKind.ObjectId = Object_ReceiptChild.Id
                                                  AND ObjectLink_ReceiptChild_GoodsKind.DescId = zc_ObjectLink_ReceiptChild_GoodsKind()
                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptChild.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptChild_Value()
                                                    AND ObjectFloat_Value.ValueData <> 0
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_ReceiptChild_Goods.ChildObjectId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                              INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                              AND Object_InfoMoney_View.InfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_30000()             -- Доходы
                                                              AND Object_InfoMoney_View.InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна

     WHERE _tmpResult.DescId_mi   = zc_MI_Master()
       AND _tmpResult.isDelete    = FALSE;

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
     -- !!!Проводим но не ВСЁ!!!
     PERFORM lpComplete_Movement_ProductionUnion (inMovementId     := tmp.MovementId
                                                , inIsHistoryCost  := TRUE
                                                , inUserId         := zc_Enum_Process_Auto_Pack())
     FROM (SELECT _tmpResult.MovementId FROM _tmpResult WHERE _tmpResult.isDelete = FALSE AND _tmpResult.MovementId <> 0 AND _tmpResult.DescId_mi = zc_MI_Master() GROUP BY _tmpResult.MovementId) AS tmp
          INNER JOIN Movement ON Movement.Id = tmp.MovementId
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
    ;

     END IF; -- if inIsUpdate = TRUE -- !!!т.е. не всегда!!!


    -- Результат
    RETURN QUERY
    SELECT _tmpResult.MovementId
         , _tmpResult.OperDate
         , Movement.InvNumber
         , _tmpResult.isDelete
         , _tmpResult.DescId_mi
         , _tmpResult.MovementItemId, _tmpResult.ContainerId
         , _tmpResult.OperCount
         , _tmpResult.OperCount_Weight
         , _tmpResult.OperCount_two
         , Object_Receipt_master.ObjectCode AS ReceiptCode_master
         , Object_Receipt_master.ValueData  AS ReceiptName_master
         , Object_Goods_master.ObjectCode AS GoodsCode_master
         , Object_Goods_master.ValueData  AS GoodsName_master
         , NULL :: TVarChar AS GoodsKindName_master

         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData  AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
         , 0 AS MovementItemId_master
         , 0 AS ContainerId_master

    FROM _tmpResult
         LEFT JOIN Movement ON Movement.Id = _tmpResult.MovementId
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpResult.GoodsId
         LEFT JOIN Object AS Object_Goods_master ON Object_Goods_master.Id = _tmpResult.GoodsId_master
         LEFT JOIN Object AS Object_Receipt_master ON Object_Receipt_master.Id = _tmpResult.ReceiptId_master
         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                       ON CLO_GoodsKind.ContainerId = _tmpResult.ContainerId
                                      AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = CLO_GoodsKind.ObjectId
   UNION ALL
    SELECT _tmpResult.MovementId
         , _tmpResult.OperDate
         , Movement.InvNumber
         , _tmpResult_child.isDelete
         , -1 AS DescId_mi
         , _tmpResult_child.MovementItemId, _tmpResult_child.ContainerId
         , _tmpResult_child.OperCount
         , _tmpResult.OperCount_Weight
         , _tmpResult.OperCount_two
         , Object_Receipt_master.ObjectCode AS ReceiptCode_master
         , Object_Receipt_master.ValueData  AS ReceiptName_master
         , Object_Goods_master.ObjectCode AS GoodsCode_master
         , Object_Goods_master.ValueData  AS GoodsName_master
         , Object_GoodsKind_master.ValueData AS GoodsKindName_master
         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData  AS GoodsName
         , Object_GoodsKind.ValueData AS GoodsKindName
         , _tmpResult_child.MovementItemId_master
         , _tmpResult_child.ContainerId_master
    FROM _tmpResult_child
         LEFT JOIN _tmpResult ON _tmpResult.ContainerId = _tmpResult_child.ContainerId_master
                             AND _tmpResult.DescId_mi   = zc_MI_Master()
                             AND _tmpResult.OperDate    = _tmpResult_child.OperDate
                             AND _tmpResult.isDelete    = FALSE

         LEFT JOIN Movement ON Movement.Id = _tmpResult.MovementId
         LEFT JOIN Object AS Object_Goods_master ON Object_Goods_master.Id = _tmpResult.GoodsId
         LEFT JOIN Object AS Object_Receipt_master ON Object_Receipt_master.Id = _tmpResult.ReceiptId_master
         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind_master
                                       ON CLO_GoodsKind_master.ContainerId = _tmpResult.ContainerId
                                      AND CLO_GoodsKind_master.DescId = zc_ContainerLinkObject_GoodsKind()
         LEFT JOIN Object AS Object_GoodsKind_master ON Object_GoodsKind_master.Id = CLO_GoodsKind_master.ObjectId

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpResult_child.GoodsId
         LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                       ON CLO_GoodsKind.ContainerId = _tmpResult_child.ContainerId
                                      AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = CLO_GoodsKind.ObjectId
    ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.15                                        *
*/

-- тест
-- where ContainerId = 568111
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= FALSE, inStartDate:= '10.05.2015', inEndDate:= '10.05.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки

-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '21.07.2015', inEndDate:= '21.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '20.07.2015', inEndDate:= '20.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '19.07.2015', inEndDate:= '19.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '18.07.2015', inEndDate:= '18.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '17.07.2015', inEndDate:= '17.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '16.07.2015', inEndDate:= '16.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '15.07.2015', inEndDate:= '15.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '14.07.2015', inEndDate:= '14.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '13.07.2015', inEndDate:= '13.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '12.07.2015', inEndDate:= '12.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '11.07.2015', inEndDate:= '11.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '10.07.2015', inEndDate:= '10.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '09.07.2015', inEndDate:= '09.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '08.07.2015', inEndDate:= '08.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '07.07.2015', inEndDate:= '07.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '06.07.2015', inEndDate:= '06.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '05.07.2015', inEndDate:= '05.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '04.07.2015', inEndDate:= '04.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '03.07.2015', inEndDate:= '03.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= true, inStartDate:= '02.07.2015', inEndDate:= '02.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate:= FALSE, inStartDate:= '01.07.2015', inEndDate:= '01.07.2015', inUnitId:= 8451, inUserId:= zfCalc_UserAdmin() :: Integer) -- Цех Упаковки
-- where (DescId_mi < 0 and GoodsCode in (101, 2207)) or (DescId_mi IN (  1,  zc_MI_Child())   and (GoodsCode in (101, 2207) or GoodsCode_master = 101))
-- where GoodsCode in (101, 2207) or GoodsCode_master in (101, 2207)
-- order by DescId_mi desc, GoodsName_master, GoodsKindName_master, GoodsName, GoodsKindName, OperDate

