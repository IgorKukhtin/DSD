-- select * from MovementItemContainer where MovementItemId = (select min (MovementItemId) from MovementItemContainer where MovementId =3615883  and ContainerId = 297223) order by 1
-- delete from MovementItemContainer where Id>= 2747898647 and MovementItemId = (select min (MovementItemId) from MovementItemContainer where MovementId =3615883  and ContainerId = 297223)

-- update Container set Amount = Container.Amount + tmp.Amount from (

DO $$
    DECLARE vbMovementId Integer;
BEGIN

vbMovementId :=29503688 ;
PERFORM gpUnComplete_Movement_Inventory (vbMovementId, zc_Enum_Process_Auto_PrimeCost() :: TVarChar);


     CREATE TEMP TABLE _tmpRes ON COMMIT DROP AS 
        WITH tmp_to AS (SELECT _tmp_part_2024_09.ContainerId
                             , _tmp_part_2024_09.GoodsId
                             , _tmp_part_2024_09.GoodsKindId
                             , _tmp_part_2024_09.PartionGoodsId
                             , _tmp_part_2024_09.PartionGoodsDate
                             , _tmp_part_2024_09.Amount_rem
                              -- № п/п
                            , ROW_NUMBER() OVER (PARTITION BY _tmp_part_2024_09.GoodsId, _tmp_part_2024_09.GoodsKindId ORDER BY _tmp_part_2024_09.Amount_rem DESC) AS Ord
                        FROM _tmp_part_2024_09
                        -- !!!
                        WHERE _tmp_part_2024_09.Amount_rem > 0
                       )

          , tmpContainer AS (SELECT Container.Id AS ContainerId
                                  , Container.ObjectId AS GoodsId
                                  , Container.Amount
                                  , CLO_GoodsKind.ObjectId as GoodsKindId
                                  , CLO_PartionGoods.ObjectId as PartionGoodsId
                                  , COALESCE (ObjectDate_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                             FROM Container
                                  INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                ON CLO_Unit.ContainerId = Container.Id
                                                               AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                               and CLO_Unit.ObjectId    = zc_Unit_RK()
                                  LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = Container.Id
                                                                                AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                  LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                                  LEFT JOIN ObjectDate AS ObjectDate_Value ON ObjectDate_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                                           AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()

                                  LEFT JOIN  ContainerLinkObject as CLO_0
                                                                 on CLO_0.ContainerId = Container.Id
                                                                AND CLO_0.DescId      = zc_ContainerLinkObject_Account()

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Container.ObjectId
                                                      AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()


                                  INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                                  ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                 and InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                                            , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                             )
                             WHERE Container.DescId = zc_Container_Count()
                               AND CLO_0.ObjectId is null
                            )

     -- остаток на начало дня - РК
   , tmpContainer_rem AS (SELECT tmpContainer.ContainerId
                               , tmpContainer.GoodsId
                               , tmpContainer.GoodsKindId
                               , tmpContainer.Amount
                               , tmpContainer.PartionGoodsId
                               , tmpContainer.PartionGoodsDate
                               , tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount_rem
                          FROM tmpContainer
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                              -- !!!на конец дня
                                                              AND MIContainer.OperDate    >= '01.10.2024'
                          GROUP BY tmpContainer.ContainerId
                               , tmpContainer.GoodsId
                               , tmpContainer.GoodsKindId
                               , tmpContainer.Amount
                               , tmpContainer.PartionGoodsId
                               , tmpContainer.PartionGoodsDate
                          -- !!!
                          HAVING tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) > 0
                         )
, tmp_check AS (select tmp_from.Amount_rem, tmp_to.Amount_rem, Object_Goods.*, Object_GoodsKind.*
                FROM 
                     (select tmpContainer_rem.GoodsId
                           , tmpContainer_rem.GoodsKindId
                      
                           , sum(tmpContainer_rem.Amount_rem) AS Amount_rem
                      from tmpContainer_rem
                      GROUP BY tmpContainer_rem.GoodsId
                             , tmpContainer_rem.GoodsKindId
                     ) AS tmp_from
                     
                     full join
                     (select tmp_to.GoodsId
                           , tmp_to.GoodsKindId
                      
                           , sum(tmp_to.Amount_rem) AS Amount_rem
                      from tmp_to
                      GROUP BY tmp_to.GoodsId
                             , tmp_to.GoodsKindId
                     ) AS tmp_to
                       ON tmp_to.GoodsId     = tmp_from.GoodsId
                      AND tmp_to.GoodsKindId = tmp_from.GoodsKindId
                      
                     left join Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmp_to.GoodsId, tmp_from.GoodsId)
                     left join Object AS Object_GoodsKind ON Object_GoodsKind.Id = COALESCE (tmp_to.GoodsKindId, tmp_from.GoodsKindId)

                WHERE COALESCE (tmp_to.Amount_rem, 0) <> COALESCE (tmp_from.Amount_rem, 0)
               )

-- select * from tmpContainer_rem
-- select * from tmp_check

, tmp_res AS (SELECT tmp_to.GoodsId
                   , tmp_to.GoodsKindId
                   , tmp_to.PartionGoodsDate
                   , tmp_to.PartionGoodsId
                   , tmp_to.ContainerId AS ContainerId_to
                   , tmpContainer_rem.ContainerId AS ContainerId_from
                   , ROUND (tmpContainer_rem.Amount_rem * tmp_to.Amount_rem / tmp_to_total.Amount_rem, 2) AS Amount_rem_to_res
                   , tmp_to.Amount_rem as Amount_rem_to
                   , tmpContainer_rem.Amount_rem as Amount_rem_from
                   , tmp_to.Ord
                                    
              FROM tmp_to
                   INNER JOIN (select tmp_to.GoodsId
                                    , tmp_to.GoodsKindId
                                    , sum(tmp_to.Amount_rem) AS Amount_rem
                               from tmp_to
                               GROUP BY tmp_to.GoodsId
                                      , tmp_to.GoodsKindId
                              ) AS tmp_to_total
                                ON tmp_to_total.GoodsId     = tmp_to.GoodsId
                               AND tmp_to_total.GoodsKindId = tmp_to.GoodsKindId
                   INNER JOIN tmpContainer_rem
                                     ON tmpContainer_rem.GoodsId     = tmp_to.GoodsId
                                    AND tmpContainer_rem.GoodsKindId = tmp_to.GoodsKindId
              order by 1,2,3
              )
  select 0 :: Integer AS MovementItemId
       , tmp_res.GoodsId
       , tmp_res.GoodsKindId
       , tmp_res.PartionGoodsDate
       , tmp_res.PartionGoodsId
       , tmp_res.ContainerId_to
       , tmp_res.ContainerId_from
       , tmp_res.Amount_rem_to_res
       , tmp_res.Amount_rem_to
       , tmp_res.Amount_rem_from
       , tmp_res.Ord
       , tmp_res.Amount_rem_to_res + CASE WHEN tmp_res.Ord = 1 THEN COALESCE (tmpContainer_rem.Amount_rem, 0) - COALESCE (tmp_res_group.Amount_rem_to_res, 0) ELSE 0 END AS res_2 
       , CASE WHEN tmp_res.Ord = 1 THEN COALESCE (tmpContainer_rem.Amount_rem, 0) - COALESCE (tmp_res_group.Amount_rem_to_res, 0) ELSE 0 END AS diff
       
  from tmp_res
       LEFT JOIN (select tmp_res.GoodsId
                       , tmp_res.GoodsKindId
                       , sum (tmp_res.Amount_rem_to_res) AS Amount_rem_to_res
                  from tmp_res
                  group by tmp_res.GoodsId
                         , tmp_res.GoodsKindId
                 ) AS tmp_res_group
                   ON tmp_res_group.GoodsId     = tmp_res.GoodsId
                  AND tmp_res_group.GoodsKindId = tmp_res.GoodsKindId
                  --AND tmp_res.Ord = 1

       LEFT JOIN tmpContainer_rem
              ON tmpContainer_rem.GoodsId     = tmp_res.GoodsId
             AND tmpContainer_rem.GoodsKindId = tmp_res.GoodsKindId
             --AND tmp_res.Ord = 1
      ;


      UPDATE MovementItem set isErased = TRUE WHERE MovementId = vbMovementId AND DescId = zc_MI_Master() AND isErased = FALSE;
 
 
 
      UPDATE _tmpRes set MovementItemId = (SELECT lpInsertUpdate.ioId
                                           FROM lpInsertUpdate_MovementItem_Inventory (ioId                 := 0
                                                                                     , inMovementId         := vbMovementId
                                                                                     , inGoodsId            := GoodsId
                                                                                     , inAmount             := res_2 
                                                                                     , inPartionGoodsDate   := PartionGoodsDate
                                                                                     , inPrice              := 0
                                                                                     , inSumm               := 0
                                                                                     , inHeadCount          := 0
                                                                                     , inCount              := 0
                                                                                     , inPartionGoods       := ''
                                                                                     , inPartNumber         := ''
                                                                                     , inPartionGoodsId     := null -- PartionGoodsId
                                                                                     , inGoodsKindId        := GoodsKindId
                                                                                     , inGoodsKindCompleteId:= NULL
                                                                                     , inAssetId            := NULL
                                                                                     , inUnitId             := NULL
                                                                                     , inStorageId          := NULL
                                                                                     , inPartionModelId     := NULL
                                                                                     , inUserId             := zc_Enum_Process_Auto_PrimeCost()
                                                                                      ) AS lpInsertUpdate
                                          );

     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), _tmpRes.MovementItemId, _tmpRes.ContainerId_to)
     FROM _tmpRes;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Inventory_CreateTemp();


     -- формируются Проводки для количественного учета - расход
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, zc_Movement_Inventory() AS MovementDescId, vbMovementId, MovementItemId
            , ContainerId_from
            , 0                                       AS AccountId              -- нет счета
            , 0                                       AS AnalyzerId             -- нет аналитики
            , GoodsId                        AS ObjectId_Analyzer      -- Товар
            , zc_Unit_RK()                            AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , 0                                       AS ObjectExtId_Analyzer   -- !!!нет!!!
            , 0                                       AS ParentId
            , -1 * res_2 AS Amount
            , '01.09.2024'  :: TDateTime AS OperDate
            , FALSE
       FROM _tmpRes

      UNION ALL
       SELECT 0, zc_MIContainer_Count() AS DescId, zc_Movement_Inventory() AS MovementDescId, vbMovementId, MovementItemId
            , ContainerId_to
            , 0                                       AS AccountId              -- нет счета
            , 0                                       AS AnalyzerId             -- нет аналитики
            , GoodsId                        AS ObjectId_Analyzer      -- Товар
            , zc_Unit_RK()                            AS WhereObjectId_Analyzer -- Подраделение или...
            , 0                                       AS ContainerId_Analyzer   -- !!!нет!!!
            , GoodsKindId                    AS ObjectIntId_Analyzer   -- вид товара
            , 0                                       AS ObjectExtId_Analyzer   -- !!!нет!!!
            , 0                                       AS ParentId
            , 1 * res_2 AS Amount
            , '01.09.2024' :: TDateTime AS OperDate
            , TRUE
       FROM _tmpRes
      ;


     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();


     --UPDATE Movement set StatusId =  zc_Enum_Status_Complete() WHERE Id = vbMovementId;

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := vbMovementId
                                , inDescId     := zc_Movement_Inventory()
                                , inUserId     := zc_Enum_Process_Auto_PrimeCost()
                                 );


END $$;

