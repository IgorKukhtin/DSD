-- Function: gpComplete_Movement_ReturnOut(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnOut (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnOut(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnOut());


     -- таблицы - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
     CREATE TEMP TABLE _tmp1___ (Id Integer) ON COMMIT DROP;
     CREATE TEMP TABLE _tmp2___ (Id Integer) ON COMMIT DROP;

     -- таблица - 
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;
     -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItemSumm (MovementItemId Integer, ContainerId_ProfitLoss_40208 Integer, ContainerId_ProfitLoss_70203 Integer, ContainerId Integer, AccountId Integer, OperSumm TFloat, OperSumm_Partner TFloat) ON COMMIT DROP;
     -- таблица - количественные элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Goods Integer, ContainerId_GoodsPartner Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, OperCount_Partner TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat
                               , ContainerId_ProfitLoss_70203 Integer
                               , ContainerId_Partner Integer, AccountId_Partner Integer, ContainerId_Transit Integer, AccountId_Transit Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_From Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isTareReturning Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;

     -- Проводим Документ
     PERFORM lpComplete_Movement_ReturnOut (inMovementId     := inMovementId
                                          , inUserId         := vbUserId
                                          , inIsLastComplete := inIsLastComplete);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.04.14                                        * !!!RESTORE!!!
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 122175 , inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ReturnOut (inMovementId:= 122175, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 122175 , inSession:= '2')
