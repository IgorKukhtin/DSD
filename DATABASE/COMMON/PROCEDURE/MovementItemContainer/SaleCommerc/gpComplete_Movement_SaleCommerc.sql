-- Function: gpComplete_Movement_SaleCommerc()

DROP FUNCTION IF EXISTS gpComplete_Movement_SaleCommerc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SaleCommerc(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SaleCommerc());
      vbUserId:= lpGetUserBySession (inSession);


     -- Бонусы
     CREATE TEMP TABLE _tmpBonus (-- Договор (БАЗА)
                                  ContractId_child Integer
                                  -- Договор (условие бонуса)
                                , ContractId_bonus Integer
                                  -- Договор(начисление)
                                , ContractId Integer
                                  -- Вид Условия договора - Только % бонуса за отгрузку-возврат
                                , ContractConditionKindId Integer
                                  -- Вид бонуса
                                , BonusKindId Integer
                                  -- Форма оплаты (Договор начисление)
                                , PaidKindId Integer
                                  -- Форма оплаты
                                , InfoMoneyId Integer
                                  -- % бонуса
                                , BonusValue TFloat
                                 ) ON COMMIT DROP;

     -- Бонусы
     INSERT INTO _tmpBonus (ContractId_bonus, ContractId, ContractConditionKindId, BonusKindId, PaidKindId, InfoMoneyId, BonusValue)

      WITH
        tmpMI_Master AS (SELECT MovementItem.*
                         FROM MovementItem 
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased   = FALSE
                         )
      , tmpMILO_Master AS (SELECT MovementItemLinkObject.*
                           FROM MovementItemLinkObject
                           WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                             AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Partner()
                                                                 , zc_MILinkObject_PaidKind()
                                                                 )
                          )
                          


      -- проводим Документ + сохранили протокол
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_SaleCommerc()
                                 , inUserId     := vbUserId
                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.07.26         *
 */

-- тест
--