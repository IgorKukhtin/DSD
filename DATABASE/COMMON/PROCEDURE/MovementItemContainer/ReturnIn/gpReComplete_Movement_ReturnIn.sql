-- Function: gpReComplete_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpReComplete_Movement_ReturnIn (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     -- таблица - Проводки
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     CREATE TEMP TABLE _tmpMIReport_insert (Id Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ActiveContainerId Integer, PassiveContainerId Integer, ActiveAccountId Integer, PassiveAccountId Integer, ReportContainerId Integer, ChildReportContainerId Integer, Amount TFloat, OperDate TDateTime) ON COMMIT DROP;

     -- таблица - альтернативные ContainerId
     CREATE TEMP TABLE _tmpList_Alternative (ContainerId_Goods Integer, ContainerId_Summ_Alternative Integer, ContainerId_Summ Integer) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_10800 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_Goods_Alternative Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_Partner TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat
                               , ContainerId_ProfitLoss_10700 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_To Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean
                               , PartionGoodsId Integer
                               , Price TFloat, CountForPrice TFloat) ON COMMIT DROP;

     -- Проводим Документ
     PERFORM lpComplete_Movement_ReturnIn (inMovementId     := inMovementId
                                         , inUserId         := vbUserId
                                         , inIsLastComplete := inIsLastComplete);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.11.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_ReturnIn (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
