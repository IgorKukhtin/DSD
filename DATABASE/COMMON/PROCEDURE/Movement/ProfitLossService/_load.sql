     -- таблица - элементы документа
     CREATE TEMP TABLE _tmpMIChild (isVirtual Boolean, MovementId Integer, MovementItemId Integer, OperDate TDateTime, JuridicalId Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer, Summ_Sale TFloat, Summ_Baza TFloat, Summ_Baza_recalc TFloat, Amount_recalc TFloat) ON COMMIT DROP;
select lpInsertUpdate_MI_ProfitLossService_AmountPartner (inMovementId:= Movement.Id
                                                                  , inAmount    := -1 * MovementItem.Amount
                                                                  , inUserId    := 5
                                                                   )
from Movement
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                                  and MovementItem.Amount <> 0
            /*INNER JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                             ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
                                            AND MILinkObject_ContractChild.ObjectId > 0 */
            left JOIN MovementItem as MovementItem2 ON MovementItem2.MovementId = Movement.Id AND MovementItem2.DescId = zc_MI_Child() AND MovementItem2.isErased = FALSE
where Movement.DescId = zc_Movement_ProfitLossService()
  AND Movement.OperDate BETWEEN '01.03.2015' AND '31.03.2015'
  AND Movement.StatusId = zc_Enum_Status_Complete()
  AND MovementItem2.MovementId is null
