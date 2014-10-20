select Movement.*, Object.*, Object1.*, Object2.* 
from ContainerLinkObject AS ContainerLO_Juridical 
     JOIN ContainerLinkObject AS ContainerLO_PaidKind  ON ContainerLO_PaidKind.ContainerId = ContainerLO_Juridical.ContainerId
                                                      AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                      AND ContainerLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm() 
  
     JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = ContainerLO_Juridical.ContainerId
                                              AND MIContainer.OperDate BETWEEN '01.06.2014' AND '30.06.2014'
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
CREATE TEMP TABLE _tmp1 (Id Integer) ON COMMIT DROP;
insert into _tmp1 (Id)
 select Movement.Id from Movement join MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                                         and MovementLinkObject.DescId = zc_MovementLinkObject_PaidKind()
                                                         and MovementLinkObject.ObjectId = zc_Enum_PaidKind_FirstForm()
 where Movement.OperDate BETWEEN '01.06.2014' AND '30.06.2014' and Movement.DescId IN (zc_Movement_Sale()/*, zc_Movement_ReturnIn()*/) and Movement.StatusId = zc_Enum_Status_Complete()
;
-- !!! распроводим все !!!
select lpUnComplete_Movement (inMovementId := _tmp1.Id
                            , inUserId     := zfCalc_UserAdmin() :: Integer)
from _tmp1;

     -- таблица - <ѕроводки>
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;

     -- таблица - суммовые элементы документа, со всеми свойствами дл€ формировани€ јналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10500 Integer, ContainerId_ProfitLoss_10400 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_ChangePercent TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- таблица - количественные элементы документа, со всеми свойствами дл€ формировани€ јналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_ChangePercent TFloat, OperCount_Partner TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat
                               , ContainerId_ProfitLoss_10100 Integer, ContainerId_ProfitLoss_10200 Integer, ContainerId_ProfitLoss_10300 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean, isLossMaterials Boolean
                               , PartionGoodsId Integer
                               , PriceListPrice TFloat, Price TFloat, CountForPrice TFloat) ON COMMIT DROP;
-- !!! проводим все !!!
perform lpComplete_Movement_Sale (inMovementId     := _tmp1.Id
                               , inUserId         := zfCalc_UserAdmin() :: Integer
                               , inIsLastComplete := TRUE)
from _tmp1;

END $$;
