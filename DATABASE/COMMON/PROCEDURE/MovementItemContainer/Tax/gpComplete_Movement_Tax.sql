-- Function: gpComplete_Movement_Tax()

DROP FUNCTION IF EXISTS gpComplete_Movement_Tax (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Tax (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Tax(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
 RETURNS VOID
--  RETURNS TABLE (OperSumm_Partner_byItem TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent_byItem TFloat, OperSumm_Partner_ChangePercent TFloat, PriceWithVAT Boolean, VATPercent TFloat, DiscountPercent TFloat, ExtraChargesPercent TFloat, UnitId_From Integer, PersonalId_From Integer, BranchId_From Integer, AccountDirectionId_From Integer, isPartionDate Boolean, JuridicalId_To Integer, IsCorporate Boolean, PersonalId_To Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, InfoMoneyDestinationId_Contract Integer, InfoMoneyId_Contract Integer, PaidKindId Integer, ContractId Integer, JuridicalId_basis Integer)
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, OperCount TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat, AccountId_Partner Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Tax());


     -- 6.2. ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_Tax() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.02.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Tax (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')