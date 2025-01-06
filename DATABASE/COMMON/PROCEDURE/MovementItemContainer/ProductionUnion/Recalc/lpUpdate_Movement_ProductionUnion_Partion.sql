-- Function: lpUpdate_Movement_ProductionUnion_Partion (Boolean, TDateTime, TDateTime, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Movement_ProductionUnion_Partion (TDateTime, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Movement_ProductionUnion_Partion (Boolean, TDateTime, TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ProductionUnion_Partion(
    IN inIsUpdate     Boolean   , --
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inFromId       Integer,    -- 
    IN inToId         Integer,    -- 
    IN inUserId       Integer     -- Пользователь
)                              
RETURNS TABLE (MovementItemId_gp Integer, MovementItemId_out Integer, ContainerId Integer
             , OperCount TFloat, OperCount_GP TFloat, OperCount_PF_out TFloat, OperCount_PF_in TFloat
             , isPartionClose Boolean, PartionGoodsDate Date, PartionGoodsDateClose Date
             , GoodsCode Integer, GoodsName TVarChar
              )
AS
$BODY$
  DECLARE vbMovementId_inv Integer;
BEGIN
     -- !!!Временно!!!
     IF inFromId = 951601 -- ЦЕХ упаковки мясо
     THEN
         -- RETURN;
         inFromId:= 8447; -- ЦЕХ колбасный
         inToId  := 8439; -- Участок мясного сырья
     END IF;

     -- !!!Временно!!!
     /*IF inFromId = 981821 -- ЦЕХ шприц. мясо
     THEN
         -- RAISE EXCEPTION '<%> <%>', inFromId, inToId;
         inToId:= 951601; -- ЦЕХ упаковки мясо
     END IF;*/


     -- определяется документ Инвентаризация, т.к. надо её учесть + распределить "Ковбаси сирокопчені"
     vbMovementId_inv:= (SELECT DISTINCT Movement.Id
                         FROM (SELECT Movement.Id
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                 AND MovementLinkObject_From.ObjectId = inFromId
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.isErased = FALSE
                                                           AND (MovementItem.Amount <> 0) -- OR inFromId = 8020711 -- ЦЕХ колбаса + деликатесы (Ирна)
                                    INNER JOIN ObjectLink ON ObjectLink.ObjectId = MovementItem.ObjectId
                                                         AND ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney()
                                    INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink.ChildObjectId
                                                                                      AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                                                                                  , zc_Enum_InfoMoneyDestination_30100() -- Продукция
                                                                                                                                   )
                               WHERE Movement.OperDate = DATE_TRUNC ('MONTH', inStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 AND Movement.DescId = zc_Movement_Inventory()
                                 AND (EXTRACT (MONTH FROM Movement.OperDate) < EXTRACT (MONTH FROM CURRENT_DATE)
                                   OR EXTRACT (YEAR FROM Movement.OperDate)  < EXTRACT (YEAR FROM CURRENT_DATE)
                                     )
                              UNION
                               SELECT Movement.Id
                               FROM Movement
                                    LEFT JOIN MovementBoolean AS MovementBoolean_GoodsGroupExc
                                                              ON MovementBoolean_GoodsGroupExc.MovementId = Movement.Id
                                                             AND MovementBoolean_GoodsGroupExc.DescId     = zc_MovementBoolean_GoodsGroupExc()
                                                             AND MovementBoolean_GoodsGroupExc.ValueData  = TRUE
                                    
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                 AND MovementLinkObject_From.ObjectId = inFromId
                                                                 -- !!!захардкодил!!!
                                                                 -- AND inFromId = 951601 -- ЦЕХ упаковки мясо
                                                                 AND inFromId = 981821 -- ЦЕХ шприц. мясо
                                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                           AND MovementItem.isErased = FALSE
                                                           AND MovementItem.Amount <> 0
                                    INNER JOIN ObjectLink ON ObjectLink.ObjectId = MovementItem.ObjectId
                                                         AND ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney()
                                    INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink.ChildObjectId
                                                                                      AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                               WHERE Movement.OperDate = DATE_TRUNC ('MONTH', inStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 AND Movement.DescId = zc_Movement_Inventory()
                                 AND (EXTRACT (MONTH FROM Movement.OperDate) < EXTRACT (MONTH FROM CURRENT_DATE)
                                   OR EXTRACT (YEAR FROM Movement.OperDate)  < EXTRACT (YEAR FROM CURRENT_DATE)
                                     )
                                 -- без этого св-ва
                                 AND MovementBoolean_GoodsGroupExc.MovementId IS NULL
                              ) AS Movement
                               --LIMIT 1
                        );


     --RAISE EXCEPTION '<%> <%>  <%>', inFromId, inToId, vbMovementId_inv;


     -- таблица - Приходы ГП с пр-ва
     CREATE TEMP TABLE _tmpItem_GP (MovementId Integer, MovementItemId_gp Integer, GoodsId Integer, OperCount TFloat) ON COMMIT DROP;
     -- таблица - Расходы ПФ(ГП) на пр-во ГП (без этикетки)
     CREATE TEMP TABLE _tmpItem_PF (MovementId Integer, MovementItemId_gp Integer, MovementItemId_out Integer, ContainerId Integer, GoodsId Integer, InfoMoneyDestinationId Integer, PartionGoodsId Integer, TermProduction TFloat, OperCount TFloat) ON COMMIT DROP;
     -- таблица - найденные партии пр-ва ПФ(ГП)
     CREATE TEMP TABLE _tmpItem_PF_find (ContainerId Integer, MovementItemId_in Integer, OperCount TFloat, isPartionClose Boolean, PartionGoodsDate TDateTime, PartionGoodsDateClose TDateTime) ON COMMIT DROP;
     -- таблица - распределение пр-во ПФ(ГП) -> Приходы ГП
     CREATE TEMP TABLE _tmpItem_Result (MovementId Integer, MovementItemId_gp Integer, MovementItemId_out Integer, ContainerId Integer, GoodsId Integer, InfoMoneyDestinationId Integer, OperCount TFloat) ON COMMIT DROP;


     -- Приходы ГП с пр-ва на Склад + Упаковка Мяса
     INSERT INTO _tmpItem_GP (MovementId, MovementItemId_gp, GoodsId, OperCount)
             -- !!!Товары временно захардкодил: Ковбаси сирокопчені!!! - без ЦЕХ колбасный (Ирна)
        WITH tmpGoodsCK AS (SELECT ObjectId AS GoodsId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst() AND ObjectLink.ChildObjectId = 340591 AND vbMovementId_inv IS NULL /*AND inFromId NOT IN (8020711)*/)
           , tmpUnitTo AS (SELECT tmp.UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS tmp)
        SELECT MIContainer.MovementId
             , MIContainer.MovementItemId           AS MovementItemId_gp
             , MIContainer.ObjectId_Analyzer        AS GoodsId
             , MIContainer.Amount                   AS OperCount
        FROM MovementItemContainer AS MIContainer
             LEFT JOIN tmpGoodsCK ON tmpGoodsCK.GoodsId = MIContainer.ObjectId_Analyzer
        WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
          AND MIContainer.MovementDescId         = zc_Movement_ProductionUnion()
          AND MIContainer.DescId                 = zc_MIContainer_Count()
          AND MIContainer.isActive               = TRUE
          AND MIContainer.AnalyzerId             = inFromId
          AND MIContainer.WhereObjectId_Analyzer IN (SELECT tmpUnitTo.UnitId FROM tmpUnitTo)
          AND tmpGoodsCK.GoodsId IS NULL
       ;

     -- Расходы ПФ(ГП) на пр-во (без этикетки)
     INSERT INTO _tmpItem_PF (MovementId, MovementItemId_gp, MovementItemId_out, ContainerId, GoodsId, InfoMoneyDestinationId, PartionGoodsId, TermProduction, OperCount)
        WITH tmpMIGoods AS (-- Товары ГП: важное св-во TermProduction
                            SELECT tmp.GoodsId, COALESCE (ObjectFloat_TermProduction.ValueData, 0) AS TermProduction
                            FROM (SELECT _tmpItem_GP.GoodsId FROM _tmpItem_GP GROUP BY _tmpItem_GP.GoodsId) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                                      ON ObjectLink_OrderType_Goods.ChildObjectId = tmp.GoodsId
                                                     AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                                 LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                                       ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                                      AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction() 
                           )
           , tmpItem_GP AS (-- Товары ГП: важное св-во TermProduction
                            SELECT _tmpItem_GP.*
                                 , View_InfoMoney.InfoMoneyDestinationId
                            FROM _tmpItem_GP
                                 LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                      ON ObjectLink_Goods_InfoMoney.ObjectId = _tmpItem_GP.GoodsId
                                                     AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                 LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                           )
        SELECT _tmpItem_GP.MovementId                  AS MovementId
             , _tmpItem_GP.MovementItemId_gp           AS MovementItemId_gp
             , MIContainer.MovementItemId              AS MovementItemId_out
             , MIContainer.ContainerId                 AS ContainerId
             , MIContainer.ObjectId_Analyzer           AS GoodsId
             , _tmpItem_GP.InfoMoneyDestinationId      AS InfoMoneyDestinationId -- !!!не совсем корректно, т.к. это "GP", а надо бы для ObjectId_Analyzer!!!
             , CLO_PartionGoods.ObjectId               AS PartionGoodsId
             , COALESCE (tmpMIGoods.TermProduction, 0) AS TermProduction
             , MIContainer.Amount                      AS OperCount      -- !!не используется, только для теста!!!
        FROM tmpItem_GP AS _tmpItem_GP
             INNER JOIN MovementItem ON MovementItem.MovementId = _tmpItem_GP.MovementId
                                    AND MovementItem.ParentId   = _tmpItem_GP.MovementItemId_gp
                                    AND MovementItem.DescId     = zc_MI_Child()
                                    AND MovementItem.isErased   = FALSE
             LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                           ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                          AND MIBoolean_isAuto.DescId     = zc_MIBoolean_isAuto()
             INNER JOIN MovementItemContainer AS MIContainer
                                              ON MIContainer.MovementId = _tmpItem_GP.MovementId
                                             AND MIContainer.MovementItemId = MovementItem.Id
                                             AND MIContainer.DescId = zc_MIContainer_Count()
             LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                           ON CLO_GoodsKind.ContainerId = MIContainer.ContainerId
                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
             INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                            ON CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
             LEFT JOIN tmpMIGoods ON tmpMIGoods.GoodsId = _tmpItem_GP.GoodsId
        WHERE (CLO_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress() -- !!!ПФ(ГП)!!!
            OR _tmpItem_GP.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()  -- Основное сырье + Мясное сырье
              )
         AND (MIBoolean_isAuto.ValueData = TRUE -- !!! только если сформирован пользователем zc_Enum_Process_Auto_PartionDate!!!
         --OR inFromId IN (8020711)             -- !!! ЦЕХ колбасный (Ирна)
             )
            ;
            


     -- Производство + Остатки партий, их и будем распределять
     INSERT INTO _tmpItem_PF_find (ContainerId, MovementItemId_In, OperCount, isPartionClose, PartionGoodsDate, PartionGoodsDateClose)
       WITH tmpInventory_PF AS (-- Инвентаризация ПФ(ГП)
                                SELECT MovementItem.ObjectId                    AS GoodsId
                                     , MIDate_PartionGoods.ValueData            AS PartionGoodsDate
                                     , MILinkObject_GoodsKind.ObjectId          AS GoodsKindId
                                     , COALESCE (MILinkObject_GoodsKind_complete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete
                                     , SUM (MovementItem.Amount)                AS Amount
                                FROM MovementItem
                                     INNER JOIN MovementItemDate AS MIDate_PartionGoods
                                                                 ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                                AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                     INNER JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_complete
                                                                      ON MILinkObject_GoodsKind_complete.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind_complete.DescId = zc_MILinkObject_GoodsKindComplete()
                                WHERE MovementItem.MovementId = vbMovementId_inv
                                  AND MovementItem.isErased = FALSE
                                  AND MovementItem.Amount <> 0
                                GROUP BY MovementItem.ObjectId
                                       , MIDate_PartionGoods.ValueData
                                       , MILinkObject_GoodsKind.ObjectId
                                       , MILinkObject_GoodsKind_complete.ObjectId
                               UNION
                                SELECT MovementItem.ObjectId                    AS GoodsId
                                     , MIDate_PartionGoods.ValueData            AS PartionGoodsDate
                                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                             AS GoodsKindId
                                     , COALESCE (MILinkObject_GoodsKind_complete.ObjectId, zc_GoodsKind_Basis()) AS GoodsKindId_complete
                                     , SUM (MovementItem.Amount)                AS Amount
                                FROM MovementItem
                                     INNER JOIN MovementItemDate AS MIDate_PartionGoods
                                                                 ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                                AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                     INNER JOIN ObjectLink ON ObjectLink.ObjectId = MovementItem.ObjectId
                                                          AND ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney()
                                     INNER JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink.ChildObjectId
                                                                                       AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_complete
                                                                      ON MILinkObject_GoodsKind_complete.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_GoodsKind_complete.DescId = zc_MILinkObject_GoodsKindComplete()
                                WHERE MovementItem.MovementId = vbMovementId_inv
                                  AND MovementItem.isErased = FALSE
                                  AND MovementItem.Amount <> 0
                                  -- !!!захардкодил!!!
                                  -- AND inFromId = 951601 -- ЦЕХ упаковки мясо
                                  AND inFromId = 981821 -- ЦЕХ шприц. мясо
                                GROUP BY MovementItem.ObjectId
                                       , MIDate_PartionGoods.ValueData
                                       , MILinkObject_GoodsKind.ObjectId
                                       , MILinkObject_GoodsKind_complete.ObjectId
                               )
                , tmpOut_PF AS (-- "другие" расходы ПФ(ГП)
                                SELECT tmp.ContainerId
                                     , -1 * SUM (MIContainer.Amount) AS Amount
                                FROM (SELECT _tmpItem_PF.ContainerId FROM _tmpItem_PF GROUP BY _tmpItem_PF.ContainerId) AS tmp
                                     INNER JOIN MovementItemContainer AS MIContainer
                                                                      ON MIContainer.ContainerId = tmp.ContainerId
                                                                     AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                                     AND MIContainer.MovementDescId IN (zc_Movement_ProductionUnion(), zc_Movement_Loss(), zc_Movement_Send())
                                                                     AND MIContainer.DescId      = zc_MIContainer_Count()
                                                                     AND MIContainer.isActive    = FALSE
                                     LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                                   ON MIBoolean_isAuto.MovementItemId = MIContainer.MovementItemId
                                                                  AND MIBoolean_isAuto.DescId     = zc_MIBoolean_isAuto()
                                                                  AND MIBoolean_isAuto.ValueData = TRUE
                                WHERE MIBoolean_isAuto.MovementItemId IS NULL
                                GROUP BY tmp.ContainerId
                               )
          , tmpContainer_PF AS (-- Партии ПФ(ГП)
                                SELECT tmp.ContainerId
                                     , tmp.GoodsId
                                     , tmp.PartionGoodsId
                                     , CASE WHEN (ObjectDate_PartionGoods_Value.ValueData + (COALESCE (tmp.TermProduction, 0) :: TVarChar || ' DAY') :: INTERVAL) <= inEndDate
                                              OR vbMovementId_inv > 0
                                                 THEN TRUE
                                            ELSE FALSE
                                       END AS isPartionClose
                                     , ObjectDate_PartionGoods_Value.ValueData AS PartionGoodsDate
                                     , ObjectDate_PartionGoods_Value.ValueData + (COALESCE (tmp.TermProduction, 0) :: TVarChar || ' DAY') :: INTERVAL AS PartionGoodsDateClose
                                FROM (-- Расходы ПФ(ГП) + !!!минимальный TermProduction!!! т.к. их может быть несколько
                                      SELECT _tmpItem_PF.ContainerId
                                           , _tmpItem_PF.GoodsId
                                           , _tmpItem_PF.PartionGoodsId
                                           , MIN (_tmpItem_PF.TermProduction) AS TermProduction
                                      FROM _tmpItem_PF
                                      GROUP BY _tmpItem_PF.ContainerId
                                             , _tmpItem_PF.GoodsId
                                             , _tmpItem_PF.PartionGoodsId
                                     ) AS tmp
                                     INNER JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                           ON ObjectDate_PartionGoods_Value.ObjectId = tmp.PartionGoodsId
                                                          AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                               )
        , tmpMIContainer_PF AS (-- Движение ПФ(ГП)
                                SELECT tmpContainer_PF.ContainerId
                                     , tmpContainer_PF.GoodsId
                                     , tmpContainer_PF.PartionGoodsId
                                     , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                 THEN MIContainer.MovementItemId -- нужен только для zc_Movement_ProductionUnion, т.к. надо закрыть по нему партию
                                            ELSE 0
                                       END AS MovementItemId_In
                                     , SUM (CASE WHEN tmpContainer_PF.isPartionClose = FALSE
                                                      THEN 0
                                                 WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                      THEN MIContainer.Amount
                                                 WHEN MIContainer.OperDate < inStartDate
                                                      THEN MIContainer.Amount
                                                 ELSE 0
                                            END) AS Amount
                                     , tmpContainer_PF.isPartionClose
                                     , tmpContainer_PF.PartionGoodsDate      -- информативно
                                     , tmpContainer_PF.PartionGoodsDateClose -- информативно
                                FROM tmpContainer_PF
                                     INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_PF.ContainerId
                                GROUP BY tmpContainer_PF.ContainerId
                                       , tmpContainer_PF.GoodsId
                                       , tmpContainer_PF.PartionGoodsId
                                       , CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                   THEN MIContainer.MovementItemId
                                              ELSE 0
                                         END
                                       , tmpContainer_PF.isPartionClose
                                       , tmpContainer_PF.PartionGoodsDate
                                       , tmpContainer_PF.PartionGoodsDateClose
                                HAVING SUM (CASE WHEN MIContainer.OperDate BETWEEN inStartDate AND inEndDate AND MIContainer.isActive = TRUE AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                      THEN MIContainer.Amount
                                                 WHEN MIContainer.OperDate < inStartDate
                                                      THEN MIContainer.Amount
                                                 ELSE 0
                                            END) <> 0
       
                               )
        -- результат - ВСЕ партии которые надо закрыть/открыть
        SELECT tmp.ContainerId
             , 0 AS MovementItemId_In
             , tmp.Amount - COALESCE (tmpInventory_PF.Amount, 0) - COALESCE (tmpOut_PF.Amount, 0) AS Amount
             , tmp.isPartionClose
             , tmp.PartionGoodsDate
             , tmp.PartionGoodsDateClose
        FROM (SELECT tmpMIContainer_PF.ContainerId
                   , tmpMIContainer_PF.GoodsId
                   , SUM (tmpMIContainer_PF.Amount) AS Amount
                   , tmpMIContainer_PF.isPartionClose
                   , tmpMIContainer_PF.PartionGoodsId
                   , tmpMIContainer_PF.PartionGoodsDate
                   , tmpMIContainer_PF.PartionGoodsDateClose
              FROM tmpMIContainer_PF
              GROUP BY tmpMIContainer_PF.ContainerId
                     , tmpMIContainer_PF.GoodsId
                     , tmpMIContainer_PF.isPartionClose
                     , tmpMIContainer_PF.PartionGoodsId
                     , tmpMIContainer_PF.PartionGoodsDate
                     , tmpMIContainer_PF.PartionGoodsDateClose
             ) AS tmp
                  LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = tmp.ContainerId
                                                                AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                       ON ObjectLink_GoodsKindComplete.ObjectId = tmp.PartionGoodsId
                                      AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                  LEFT JOIN tmpInventory_PF ON tmpInventory_PF.GoodsId              = tmp.GoodsId
                                           AND tmpInventory_PF.PartionGoodsDate     = tmp.PartionGoodsDate
                                           AND tmpInventory_PF.GoodsKindId          = COALESCE (CLO_GoodsKind.ObjectId, 0)
                                           AND tmpInventory_PF.GoodsKindId_complete = COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis())
                  LEFT JOIN tmpOut_PF ON tmpOut_PF.ContainerId = tmp.ContainerId
        WHERE tmp.Amount - COALESCE (tmpInventory_PF.Amount, 0) - COALESCE (tmpOut_PF.Amount, 0) > 0
       UNION ALL
        SELECT tmpMIContainer_PF.ContainerId
             , tmpMIContainer_PF.MovementItemId_In
             , 0 AS Amount
             , tmpMIContainer_PF.isPartionClose
             , tmpMIContainer_PF.PartionGoodsDate
             , tmpMIContainer_PF.PartionGoodsDateClose
        FROM tmpMIContainer_PF
        WHERE tmpMIContainer_PF.MovementItemId_In > 0
       ;

     -- удалили "ненужные" партии
     DELETE FROM _tmpItem_PF_find WHERE _tmpItem_PF_find.MovementItemId_In > 0 AND _tmpItem_PF_find.ContainerId NOT IN (SELECT tmp.ContainerId FROM _tmpItem_PF_find AS tmp WHERE tmp.MovementItemId_In = 0);


     -- распределение Производство + Остатки партий ИТОГ ПФ(ГП) -> _tmpItem_PF
     INSERT INTO _tmpItem_Result (MovementId, MovementItemId_gp, MovementItemId_out, ContainerId, GoodsId, InfoMoneyDestinationId, OperCount)
        WITH tmp_All AS (-- Эементы Приход ГП с пр-ва + Расход ПФ(ГП) в одну строку, если не 1:1 будет !!!ошибка, надо исправить!!!
                         SELECT _tmpItem_PF.MovementId
                              , _tmpItem_PF.MovementItemId_gp
                              , _tmpItem_PF.MovementItemId_out
                              , _tmpItem_PF.ContainerId
                              , _tmpItem_PF.GoodsId
                              , _tmpItem_PF.InfoMoneyDestinationId
                                -- переводится в вес
                              , _tmpItem_GP.OperCount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END AS OperCount_Weight
                         FROM _tmpItem_PF
                              INNER JOIN _tmpItem_GP ON _tmpItem_GP.MovementItemId_gp = _tmpItem_PF.MovementItemId_gp
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = _tmpItem_GP.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                    ON ObjectFloat_Weight.ObjectId = _tmpItem_GP.GoodsId
                                                   AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        )
        -- результат - распределение
        SELECT tmp_All.MovementId
             , tmp_All.MovementItemId_gp
             , tmp_All.MovementItemId_out
             , tmp_All.ContainerId
             , tmp_All.GoodsId
             , tmp_All.InfoMoneyDestinationId
             , CAST (CASE WHEN tmp_All_sum.OperCount_Weight > 0 THEN tmpPF_find.OperCount * tmp_All.OperCount_Weight / tmp_All_sum.OperCount_Weight ELSE 0 END AS NUMERIC(16, 4)) AS OperCount
        FROM tmp_All
             LEFT JOIN (-- Итог по Производство + Остатки партий ПФ(ГП) !!!если надо закрыть!!!
                        SELECT _tmpItem_PF_find.ContainerId, SUM (_tmpItem_PF_find.OperCount) AS OperCount FROM _tmpItem_PF_find WHERE _tmpItem_PF_find.isPartionClose = TRUE GROUP BY _tmpItem_PF_find.ContainerId
                       ) AS tmpPF_find ON tmpPF_find.ContainerId = tmp_All.ContainerId
             LEFT JOIN (-- Итог по Приход ГП с пр-ва
                        SELECT tmp_All.ContainerId, SUM (tmp_All.OperCount_Weight) AS OperCount_Weight FROM tmp_All GROUP BY tmp_All.ContainerId
                       ) AS tmp_All_sum ON tmp_All_sum.ContainerId = tmp_All.ContainerId
       ;

     -- если распределение было с погрешностью на "копейки" - добавим в MAX (OperCount)
     UPDATE _tmpItem_Result SET OperCount = _tmpItem_Result.OperCount + tmp_sum2.OperCount - tmp_sum1.OperCount
     FROM (-- находится MovementItemId_out с MAX (OperCount)
           SELECT _tmpItem_Result.ContainerId, MAX (_tmpItem_Result.MovementItemId_out) AS MovementItemId_out
           FROM (SELECT _tmpItem_Result.ContainerId, MAX (_tmpItem_Result.OperCount) AS OperCount FROM _tmpItem_Result GROUP BY _tmpItem_Result.ContainerId) AS tmp
                INNER JOIN _tmpItem_Result ON _tmpItem_Result.ContainerId = tmp.ContainerId
                                          AND _tmpItem_Result.OperCount   = tmp.OperCount
           GROUP BY _tmpItem_Result.ContainerId
          ) AS tmp_find
          -- Итог - сколько получилось после распределения
          INNER JOIN (SELECT _tmpItem_Result.ContainerId, SUM (_tmpItem_Result.OperCount) AS OperCount
                      FROM _tmpItem_Result
                      GROUP BY _tmpItem_Result.ContainerId
                     ) AS tmp_sum1 ON tmp_sum1.ContainerId = tmp_find.ContainerId
          -- Итог - сколько для распределения !!!если надо закрыть!!!
          INNER JOIN (SELECT _tmpItem_PF_find.ContainerId, SUM (_tmpItem_PF_find.OperCount) AS OperCount FROM _tmpItem_PF_find WHERE _tmpItem_PF_find.isPartionClose = TRUE GROUP BY _tmpItem_PF_find.ContainerId
                     ) AS tmp_sum2 ON tmp_sum2.ContainerId = tmp_find.ContainerId
                                  AND tmp_sum2.OperCount  <> tmp_sum1.OperCount -- !!!т.е. два итога не равны!!!
     WHERE _tmpItem_Result.MovementItemId_out = tmp_find.MovementItemId_out;


     -- Провека - не должно быть < 0
     IF EXISTS (SELECT _tmpItem_Result.OperCount FROM _tmpItem_Result WHERE _tmpItem_Result.OperCount < 0)
     THEN
         RAISE EXCEPTION 'Ошибка. Кол-во после распределения не может быть < 0  <%> <%>', (SELECT _tmpItem_Result.MovementItemId_out FROM _tmpItem_Result WHERE _tmpItem_Result.OperCount < 0 ORDER BY _tmpItem_Result.MovementItemId_out LIMIT 1), (SELECT _tmpItem_Result.OperCount FROM _tmpItem_Result WHERE _tmpItem_Result.OperCount < 0 ORDER BY _tmpItem_Result.MovementItemId_out LIMIT 1);
     END IF;


     -- !!!т.е. не всегда!!!
     IF inIsUpdate = TRUE
     THEN

     -- Сохраненние что партия закрыта/открыта ЕСЛИ OperCount > 0 !!!для всех _tmpItem_GP!!!
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionClose(), _tmpItem_GP.MovementItemId_gp, CASE WHEN tmp.OperCount > 0 THEN TRUE ELSE FALSE END)
     FROM _tmpItem_GP
          LEFT JOIN (SELECT _tmpItem_Result.MovementItemId_gp, SUM (_tmpItem_Result.OperCount) AS OperCount FROM _tmpItem_Result GROUP BY _tmpItem_Result.MovementItemId_gp
                    ) AS tmp ON tmp.MovementItemId_gp = _tmpItem_GP.MovementItemId_gp
    ;

     -- Сохраненние что партия закрыта/открыта ЕСЛИ OperCount > 0 !!!для всех _tmpItem_PF_find!!! после корректировок не все парти удастся открыть (надо будет доделать)
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionClose(), _tmpItem_PF_find.MovementItemId_in, CASE WHEN tmp.OperCount > 0 THEN TRUE ELSE FALSE END)
     FROM _tmpItem_PF_find
          LEFT JOIN (SELECT _tmpItem_Result.ContainerId, SUM (_tmpItem_Result.OperCount) AS OperCount FROM _tmpItem_Result GROUP BY _tmpItem_Result.ContainerId
                    ) AS tmp ON tmp.ContainerId = _tmpItem_PF_find.ContainerId
     WHERE _tmpItem_PF_find.MovementItemId_in > 0
    ;

     -- сохраняются элементы - расход на производство
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId                  := _tmpItem_Result.MovementItemId_out
                                                    , inMovementId          := _tmpItem_Result.MovementId
                                                    , inGoodsId             := _tmpItem_Result.GoodsId
                                                    , inAmount              := _tmpItem_Result.OperCount
                                                    , inParentId            := _tmpItem_Result.MovementItemId_gp
                                                    , inPartionGoodsDate    := MIDate_PartionGoods.ValueData
                                                    , inPartionGoods        := NULL
                                                    , inGoodsKindId         := CASE WHEN _tmpItem_Result.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                                                                                         THEN zc_GoodsKind_WorkProgress() -- !!!ПФ(ГП)!!!
                                                                                    ELSE zc_GoodsKind_WorkProgress() -- !!!ПФ(ГП)!!!
                                                                               END
                                                    , inGoodsKindCompleteId := NULL
                                                    , inCount_onCount       := COALESCE (MIFloat_Count.ValueData, 0)
                                                    , inUserId              := zc_Enum_Process_Auto_PartionClose()
                                                     )
     FROM _tmpItem_Result
          LEFT JOIN MovementItemFloat AS MIFloat_Count
                                      ON MIFloat_Count.MovementItemId = _tmpItem_Result.MovementItemId_gp
                                     AND MIFloat_Count.DescId = zc_MIFloat_Count()
          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                     ON MIDate_PartionGoods.MovementItemId = _tmpItem_Result.MovementItemId_gp
                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
     WHERE _tmpItem_Result.OperCount > 0;

     
     END IF; -- if inIsUpdate = TRUE -- !!!т.е. не всегда!!!


    IF inUserId = zfCalc_UserAdmin() :: Integer
    THEN

    -- Результат
    RETURN QUERY
    SELECT COALESCE (_tmpItem_Result.MovementItemId_gp, _tmpItem_GP.MovementItemId_gp) :: Integer AS MovementItemId_gp
        , _tmpItem_Result.MovementItemId_out, _tmpItem_Result.ContainerId
        , _tmpItem_Result.OperCount
        , _tmpItem_GP.OperCount      AS OperCount_gp
        , _tmpItem_PF.OperCount      AS OperCount_PF_out
        , _tmpItem_PF_find.OperCount AS OperCount_PF_in
        , _tmpItem_PF_find.isPartionClose
        , DATE (_tmpItem_PF_find.PartionGoodsDate)
        , DATE (_tmpItem_PF_find.PartionGoodsDateClose)
        , Object_Goods.ObjectCode AS GoodsCode
        , Object_Goods.ValueData  AS GoodsName
    FROM _tmpItem_Result
         LEFT JOIN Object AS Object_Goods on Object_Goods.Id = _tmpItem_Result.GoodsId
         LEFT JOIN _tmpItem_PF on _tmpItem_PF.MovementItemId_out = _tmpItem_Result.MovementItemId_out
         LEFT JOIN _tmpItem_GP on _tmpItem_GP.MovementItemId_gp = _tmpItem_Result.MovementItemId_gp
         LEFT JOIN _tmpItem_PF_find on _tmpItem_PF_find.ContainerId = _tmpItem_PF.ContainerId
                                   AND _tmpItem_PF_find.MovementItemId_In = 0
    ;
    END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.07.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.07.2017', inEndDate:= '20.07.2017', inFromId:=8448,   inToId:=8458, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ деликатесов       + Склад База ГП
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.07.2017', inEndDate:= '20.07.2017', inFromId:=8447,   inToId:=8458, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ колбасный         + Склад База ГП
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.02.2017', inEndDate:= '13.02.2017', inFromId:=951601, inToId:=8439, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ упаковки мясо + Участок мясного сырья
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '01.03.2017', inEndDate:= '02.03.2017', inFromId:=981821, inToId:=951601, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ шприц. мясо + ЦЕХ упаковки мясо
-- SELECT * FROM lpUpdate_Movement_ProductionUnion_Partion (inIsUpdate:= TRUE, inStartDate:= '04.07.2022', inEndDate:= '04.07.2022', inFromId:=8020711, inToId:=8020714, inUserId:= zfCalc_UserAdmin() :: Integer) -- ЦЕХ колбаса + деликатесы (Ирна) + Склад База ГП (Ирна)


-- where ContainerId = 628180
-- select * from MovementItemContainer where ContainerId = 568111

