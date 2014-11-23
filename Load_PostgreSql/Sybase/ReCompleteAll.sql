select Movement.*, Object.*, Object1.*, Object2.* 
from ContainerLinkObject AS ContainerLO_Juridical 
     JOIN ContainerLinkObject AS ContainerLO_PaidKind  ON ContainerLO_PaidKind.ContainerId = ContainerLO_Juridical.ContainerId
                                                      AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                      AND ContainerLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm() 
  
     JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = ContainerLO_Juridical.ContainerId
                                              AND MIContainer.OperDate BETWEEN '01.07.2014' AND '31.07.2014'
     JOIN Movement ON Movement.Id = MIContainer.MovementId
                AND Movement.DescId in (zc_Movement_Sale(), zc_Movement_ReturnIn())
     JOIN MovementLinkObject ON MovementLinkObject.MovementId = MIContainer.MovementId
     JOIN Object ON Object.Id = MovementLinkObject.ObjectId
                AND Object.DescId = zc_Object_Partner()
        LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                             ON ObjectLink_Partner_Juridical.ObjectId = Object.Id
                            AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
        LEFT JOIN Object as Object1 ON Object1.Id = ContainerLO_Juridical.ObjectId
        LEFT JOIN Object as Object2 ON Object2.Id = ObjectLink_Partner_Juridical.ChildObjectId
where ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
  AND ContainerLO_Juridical.ObjectId > 0
  AND ContainerLO_Juridical.ObjectId <> COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, 0)


DO $$
BEGIN

-- !!!!!!!!!!!!!!
-- !!! PG !!!
-- !!!!!!!!!!!!!!
CREATE TEMP TABLE _tmp1 (Id Integer, DescId Integer) ON COMMIT DROP;
with tmpUnit as (select 8411 AS UnitId -- Склад гп ф.Киев
           union select 8413 AS UnitId -- ф. Кр.Рог
           union select 8415 AS UnitId -- ф. Черкассы ( Кировоград)
           union select 8417 AS UnitId -- ф. Николаев (Херсон)
           union select 8421 AS UnitId -- ф. Донецк
           union select 8425 AS UnitId -- ф. Харьков
--           union select 301309 AS UnitId -- ф. Запорожье
--           union select 18341 AS UnitId -- ф. Никополь
--           union select 8419 AS UnitId -- ф. Крым
--           union select 8423 AS UnitId -- ф. Одесса
               )
insert into _tmp1 (Id, DescId)
 select Movement.Id, Movement.DescId from Movement
                                  /*join MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id
                                                                           and MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                                           and MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()*/
                                  join MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                                     and MLO_From.DescId = zc_MovementLinkObject_From()
                                                                     -- and MLO_From.ObjectId = 8411 -- ф. Киев
                                  join tmpUnit ON tmpUnit.UnitId = MLO_From.ObjectId
 where Movement.OperDate BETWEEN '01.06.2014' AND '30.06.2014' and Movement.DescId IN (zc_Movement_Sale(), zc_Movement_Loss(), zc_Movement_SendOnPrice()) and Movement.StatusId = zc_Enum_Status_Complete()
union
 select Movement.Id, Movement.DescId from Movement
                                 /*join MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id
                                                                          and MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                                          and MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()*/
                                  join MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                   and MLO_To.DescId = zc_MovementLinkObject_To()
                                                                   -- and MLO_To.ObjectId = 8411 -- ф. Киев
                                  join tmpUnit ON tmpUnit.UnitId = MLO_To.ObjectId
 where Movement.OperDate BETWEEN '01.06.2014' AND '30.06.2014' and Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_SendOnPrice()) and Movement.StatusId = zc_Enum_Status_Complete()
;


-- !!! распроводим все !!!
perform lpUnComplete_Movement (inMovementId := _tmp1.Id
                            , inUserId     := zfCalc_UserAdmin() :: Integer)
from _tmp1;


     -- таблица - <Проводки>
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;


-- !!!1 - Loss!!!
              -- !!!Loss!!! таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
              CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat) ON COMMIT DROP;
              -- !!!Loss!!! таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
              CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, PartionGoodsId_Item Integer
                               , OperCount TFloat
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId Integer
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;
-- !!! проводим все - Loss !!!
perform lpComplete_Movement_Loss (inMovementId     := _tmp1.Id
                                , inUserId         := zfCalc_UserAdmin() :: Integer)
from _tmp1
where DescId = zc_Movement_Loss();


-- !!!2 - SendOnPrice!!!
     -- !!!удаление!!!
     DROP TABLE _tmpItemSumm;
     DROP TABLE _tmpItem;

     -- !!!SendOnPrice!!! таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, isLossMaterials Boolean, isRestoreAccount_60000 Boolean, MIContainerId_To Integer, ContainerId_To Integer, AccountId_To Integer, ContainerId_ProfitLoss_20204 Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_60000 Integer, AccountId_60000 Integer, ContainerId_From Integer, AccountId_From Integer, InfoMoneyId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat, OperSumm_Account_60000 TFloat) ON COMMIT DROP;
     -- !!!SendOnPrice!!! таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, isLossMaterials Boolean
                               , MIContainerId_To Integer, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat
                               , InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer, BusinessId_To Integer
                               , isPartionCount Boolean, isPartionSumm Boolean
                               , PartionGoodsId_From Integer, PartionGoodsId_To Integer) ON COMMIT DROP;
-- !!! проводим все - SendOnPrice !!!
perform lpComplete_Movement_SendOnPrice (inMovementId     := _tmp1.Id
                                       , inUserId         := zfCalc_UserAdmin() :: Integer)
from _tmp1
where DescId = zc_Movement_SendOnPrice();


-- !!!3 - ReturnIn!!!
     -- !!!удаление!!!
     DROP TABLE _tmpItemSumm;
     DROP TABLE _tmpItem;

     -- !!!возвраты!!! таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10800 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- !!!возвраты!!!таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_Partner TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat
                               , ContainerId_ProfitLoss_10700 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_To Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean
                               , PartionGoodsId Integer
                               , Price TFloat, CountForPrice TFloat) ON COMMIT DROP;
-- !!! проводим все - возвраты !!!
perform lpComplete_Movement_ReturnIn (inMovementId     := _tmp1.Id
                               , inUserId         := zfCalc_UserAdmin() :: Integer
                               , inIsLastComplete := FALSE)
from _tmp1
where DescId = zc_Movement_ReturnIn();


-- !!!4 - Sale!!!
     -- !!!удаление!!!
     DROP TABLE _tmpItemSumm;
     DROP TABLE _tmpItem;

     -- !!!продажи!!! таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_ProfitLoss_10400 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- !!!продажи!!! таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat
                               , ContainerId_ProfitLoss_10100 Integer, ContainerId_ProfitLoss_10200 Integer, ContainerId_ProfitLoss_10300 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean, isLossMaterials Boolean
                               , PartionGoodsId Integer
                               , PriceListPrice TFloat, Price TFloat, CountForPrice TFloat) ON COMMIT DROP;
-- !!! проводим все - Продажи !!!
perform lpComplete_Movement_Sale (inMovementId     := _tmp1.Id
                               , inUserId         := zfCalc_UserAdmin() :: Integer
                               , inIsLastComplete := FALSE)
from _tmp1
where DescId = zc_Movement_Sale();


END $$;
