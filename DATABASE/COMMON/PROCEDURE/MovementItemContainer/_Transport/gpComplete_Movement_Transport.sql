-- Function: gpComplete_Movement_Transport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_Transport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Transport(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Transport());
     vbUserId:=2; -- CAST (inSession AS Integer);


     -- таблица - Проводки 
     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer, Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

     -- Проводим Документ
     PERFORM lpComplete_Movement_Transport (inMovementId := inMovementId
                                          , inUserId     := vbUserId);


     -- !!!таблицы для подчиненных Документов!!!

     -- таблица - элементы по контрагенту, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPartner (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, PartionMovementId Integer, OperSumm_Partner TFloat) ON COMMIT DROP;

     -- таблица - элементы по Сотруднику (заготовитель), со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummPacker (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Packer TFloat) ON COMMIT DROP;

     -- таблица - элементы по Сотруднику (Водитель), со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem_SummDriver (ContainerId Integer, AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, OperSumm_Driver TFloat) ON COMMIT DROP;

     -- таблица - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer, ContainerId_CountSupplier Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime
                               , OperCount TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat
                               , AccountId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_Detail Integer, InfoMoneyId_Detail Integer
                               , BusinessId Integer
                               , isPartionCount Boolean, isPartionSumm Boolean, isCountSupplier Boolean
                               , PartionGoodsId Integer) ON COMMIT DROP;

     -- Проводим подчиненные Документы
     PERFORM lpComplete_Movement_Income (inMovementId     := Movement.Id
                                       , inUserId         := vbUserId
                                       , inIsLastComplete := TRUE)
     FROM Movement
     WHERE Movement.ParentId = inMovementId
       AND Movement.DescId   = zc_Movement_Income()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 149639, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Transport (inMovementId:= 149639, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 149639, inSession:= '2')
