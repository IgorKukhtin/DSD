-- Function: gpComplete_Movement_SaleCommerc()

DROP FUNCTION IF EXISTS gpComplete_Movement_SaleCommerc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SaleCommerc(
    IN inMovementId        Integer    , -- ключ Документа
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SaleCommerc());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Удалили!!!
     UPDATE MovementItem SET isErased = TRUE
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Detail()
       AND MovementItem.isErased   = FALSE
      ;

     -- нашли
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

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
     INSERT INTO _tmpBonus (ContractId_child, ContractId_bonus, ContractId, ContractConditionKindId, BonusKindId, PaidKindId, InfoMoneyId, BonusValue)
        WITH tmpMI_Master AS (SELECT MovementItem.*
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
           , tmpData AS (SELECT DISTINCT
                                tmpMI_Master.ObjectId                        AS ContractId
                              , ObjectLink_Partner_Juridical.ChildObjectId   AS JuridicalId
                              , MILinkObject_PaidKind.ObjectId               AS PaidKindId
                         FROM tmpMI_Master
                              LEFT JOIN tmpMILO_Master AS MILinkObject_Partner
                                                       ON MILinkObject_Partner.MovementItemId = tmpMI_Master.Id
                                                      AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                              LEFT JOIN tmpMILO_Master AS MILinkObject_PaidKind
                                                       ON MILinkObject_PaidKind.MovementItemId = tmpMI_Master.Id
                                                      AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                   ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_Partner.ObjectId
                                                  AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                        )

      -- Результат
      SELECT tmpData.ContractId AS ContractId_child
           , lpSelect.ContractId_bonus
           , lpSelect.ContractId
           , lpSelect.ContractConditionKindId
           , lpSelect.BonusKindId
           , lpSelect.PaidKindId
           , lpSelect.InfoMoneyId
           , lpSelect.BonusValue
      FROM (SELECT * FROM tmpData ORDER BY tmpData.ContractId /*LIMIT 5*/) AS tmpData
           CROSS JOIN lpSelect_Movement_Recalc_commerc (inContractId := tmpData.ContractId
                                                      , inJuridicalId:= tmpData.JuridicalId
                                                      , inPaidKindId := tmpData.PaidKindId
                                                      , inOperDate   := vbOperDate
                                                      , inUserId     := vbUserId
                                                       ) AS lpSelect;


     -- сохранили <Бонусы>
     PERFORM lpInsertUpdate_MI_SaleCommerc_Detail (ioId                      := 0 :: Integer
                                                 , inMovementId              := inMovementId
                                                 , inContractId_child        := _tmpBonus.ContractId_child
                                                 , inContractId_bonus        := _tmpBonus.ContractId_bonus
                                                 , inContractId              := _tmpBonus.ContractId
                                                 , inContractConditionKindId := _tmpBonus.ContractConditionKindId
                                                 , inBonusKindId             := _tmpBonus.BonusKindId
                                                 , inPaidKindId              := _tmpBonus.PaidKindId
                                                 , inInfoMoneyId             := _tmpBonus.InfoMoneyId
                                                 , inBonusValue              := _tmpBonus.BonusValue
                                                 , inUserId                  := vbUserId
                                                  )
     FROM _tmpBonus
    ;


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