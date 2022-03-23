-- Function: gpComplete_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderInternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_OrderInternal (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderInternal(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsLastComplete    Boolean DEFAULT False, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
-- RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, UnitId_From Integer, MemberId_From Integer, UnitId_To Integer, MemberId_To Integer, BranchId_To Integer, ContainerId_GoodsFrom Integer, ContainerId_GoodsTo Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate_From TDateTime, PartionGoodsDate_To TDateTime, OperCount TFloat, AccountDirectionId_From Integer, AccountDirectionId_To Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, JuridicalId_basis_To Integer, BusinessId_To Integer, isPartionCount Boolean, isPartionSumm Boolean, isPartionDate_From Boolean, isPartionDate_To Boolean, PartionGoodsId_From Integer, PartionGoodsId_To Integer)
-- RETURNS TABLE (MovementItemId Integer, MIContainerId_To Integer, ContainerId_From Integer, InfoMoneyId_Detail_From Integer, OperSumm TFloat)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession; --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderInternal());

     -- пересчет сумм документа
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId := inMovementId);

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_OrderInternal()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.11.14                        *
 03.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_OrderInternal (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
