 -- Function: gpComplete_Movement_SendOnPrice()

DROP FUNCTION IF EXISTS gpComplete_Movement_SendOnPrice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SendOnPrice(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
 RETURNS VOID
--  RETURNS TABLE (OperSumm_Partner_byItem TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent_byItem TFloat, OperSumm_Partner_ChangePercent TFloat, PriceWithVAT Boolean, VATPercent TFloat, DiscountPercent TFloat, ExtraChargesPercent TFloat, MemberId_From Integer, PersonalId_From Integer, BranchId_From Integer, AccountDirectionId_From Integer, isPartionDate Boolean, JuridicalId_To Integer, IsCorporate Boolean, MemberId_To Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, InfoMoneyDestinationId_Contract Integer, InfoMoneyId_Contract Integer, PaidKindId Integer, ContractId Integer, JuridicalId_basis Integer)
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, ContainerId_Goods Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, PartionGoodsDate TDateTime, OperCount TFloat, tmpOperSumm_PriceList TFloat, OperSumm_PriceList TFloat, tmpOperSumm_Partner TFloat, OperSumm_Partner TFloat, OperSumm_Partner_ChangePercent TFloat, AccountId_Partner Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, isPartionCount Boolean, isPartionSumm Boolean, PartionGoodsId Integer)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendOnPrice());


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_SendOnPrice_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := inMovementId
                                            , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.14                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 3313, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_SendOnPrice (inMovementId:= 3313, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3313, inSession:= '2')
