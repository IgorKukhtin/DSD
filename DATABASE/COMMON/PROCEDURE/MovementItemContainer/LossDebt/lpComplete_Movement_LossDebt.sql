-- Function: lpComplete_Movement_LossDebt (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_LossDebt (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_LossDebt(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate   TDateTime;
   DECLARE vbAccountId  Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbIsLossOnly Boolean;
   DECLARE vbIsListOnly Boolean;
BEGIN
     -- проверка
     IF inMovementId = 123096 -- № 15 от 31.12.2013
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не может быть проведен.';
     END IF;

     -- определяется
     SELECT Movement.OperDate
          , COALESCE (MovementLinkObject_Account.ObjectId, 0)                             AS AccountId
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, zc_Enum_PaidKind_FirstForm()) AS PaidKindId
          , COALESCE (MovementBoolean.ValueData, FALSE)                                   AS isListOnly
            INTO vbOperDate, vbAccountId, vbPaidKindId, vbIsListOnly
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Account
                                       ON MovementLinkObject_Account.MovementId = Movement.Id
                                      AND MovementLinkObject_Account.DescId = zc_MovementLinkObject_Account()
                                      -- AND MovementLinkObject_Account.ObjectId = zc_Enum_Account_50401() -- Расходы будущих периодов - Маркетинг
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = Movement.Id
                                   AND MovementBoolean.DescId     = zc_MovementBoolean_List()
     WHERE Movement.Id     = inMovementId
       AND Movement.DescId = zc_Movement_LossDebt()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
    ;

     -- проверка
     IF vbOperDate IS NULL
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
     END IF;

     -- определяется
     vbIsLossOnly:= -- (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) >= '01.01.2015' AND inMovementId <> 2943608; -- № 43 от 30.11.2015 (Киев нал)
                    EXISTS (SELECT MovementItem.MovementId
                            FROM MovementItem
                                 /*LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                             ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Summ.DescId = zc_MIFloat_Summ()*/
                                 LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                               ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                              AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.isErased = FALSE
                              -- AND COALESCE (MIFloat_Summ.ValueData, 0) = 0
                              AND COALESCE (MIBoolean_Calculated.ValueData, FALSE) = FALSE
                           );
     -- проверка
     IF EXISTS (SELECT MovementItem.MovementId
                FROM MovementItem
                     LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                 ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                     LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                   ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                  AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.isErased = FALSE
                  AND ((vbIsLossOnly = FALSE AND (MovementItem.Amount    <> 0 OR MIBoolean_Calculated.ValueData = FALSE))
                    OR (vbIsLossOnly = TRUE  AND (MIFloat_Summ.ValueData <> 0 OR MIBoolean_Calculated.ValueData = TRUE))
                      )
               )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе может быть выполнено или <Ввод долга> или <Списание долга>.';
     END IF;


     -- проверка
     IF vbIsLossOnly = FALSE
      AND EXISTS (SELECT MovementItem.MovementId
                  FROM MovementItem
                       INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                         ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                                        AND MILinkObject_Currency.ObjectId       <> zc_Enum_Currency_Basis()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.isErased   = FALSE
                 )
     THEN
         RAISE EXCEPTION 'Ошибка.В документе для валюты может быть только <Списание долга>.';
     END IF;

     -- !!!обязательно!!! удаление "пустых" долгов
     UPDATE MovementItem SET isErased = TRUE
     FROM (SELECT MovementItem.Id
           FROM MovementItem
                INNER JOIN MovementItemBoolean AS MIBoolean_Calculated
                                               ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                              AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                              AND MIBoolean_Calculated.ValueData = TRUE
                LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                            ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                           AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                            ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                           AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.isErased = FALSE
             AND COALESCE (MIFloat_Summ.ValueData, 0) = 0
             AND COALESCE (MIFloat_ContainerId.ValueData, 0) = 0 -- !!!только если НЕТ партии!!!
             AND vbIsLossOnly = FALSE -- !!!только если НЕ списание!!!
             AND vbIsListOnly = FALSE -- !!!только если НЕ для списка!!!
          ) AS tmp
     WHERE MovementItem.Id = tmp.Id;


     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmplistcontainer')
     THEN
         DELETE FROM _tmpListContainer;
         DELETE FROM _tmpListMI;
     ELSE
         -- таблица - список
         CREATE TEMP TABLE _tmpListContainer (ContainerId Integer, ContainerId_Asset Integer, Amount TFloat
                                            , JuridicalId Integer, PartnerId Integer, BranchId Integer, InfoMoneyId Integer, PaidKindId Integer
                                            , JuridicalId_Basis Integer, PartionMovementId Integer, BusinessId Integer
                                             ) ON COMMIT DROP;
         -- таблица - список
         CREATE TEMP TABLE _tmpListMI (ObjectId Integer, PartnerId Integer, OperSumm TFloat, OperSumm_Currency TFloat, MovementItemId Integer, ContainerId Integer, ContainerId_Asset Integer
                                     , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer, AccountId_main Integer
                                     , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                                     , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                     , BusinessId Integer, JuridicalId_Basis Integer, UnitId Integer, BranchId Integer
                                     , ContractId Integer, PaidKindId Integer, PartionMovementId Integer, isCalculated Boolean
                                     , CurrencyId Integer
                                      ) ON COMMIT DROP;
     END IF;


     -- !!!УП должна соответствовать договору!!!
     UPDATE MovementItemLinkObject SET ObjectId = tmpUpdate.InfoMoneyId
     FROM (SELECT MovementItem.Id, View_Contract_InvNumber.InfoMoneyId
           FROM MovementItem
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                 ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId
                LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
           WHERE MovementItem.MovementId = inMovementId
             AND COALESCE (View_Contract_InvNumber.InfoMoneyId, 0) <> COALESCE (MILinkObject_InfoMoney.ObjectId, 0)
          ) AS tmpUpdate
     WHERE MovementItemLinkObject.MovementItemId = tmpUpdate.Id
       AND MovementItemLinkObject.DescId = zc_MILinkObject_InfoMoney()
       AND tmpUpdate.InfoMoneyId > 0;


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpListMI (ObjectId, PartnerId, OperSumm, OperSumm_Currency, MovementItemId, ContainerId
                           , AccountGroupId, AccountDirectionId, AccountId, AccountId_main
                           , ProfitLossGroupId, ProfitLossDirectionId, InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                           , BusinessId, JuridicalId_Basis, UnitId, BranchId
                           , ContractId, PaidKindId, PartionMovementId, isCalculated
                           , CurrencyId
                            )
        SELECT -- vbOperDate AS OperDate
               COALESCE (MovementItem.ObjectId, 0) AS ObjectId
               -- еще одна аналитика для 2-ой формы и не наши компании
             , CASE WHEN MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                     AND View_Constant_isCorporate.InfoMoneyId IS NULL
                     AND COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) = FALSE
                         THEN COALESCE (MILinkObject_Partner.ObjectId, 0)
                    ELSE 0
               END AS PartnerId
             , CASE WHEN MIBoolean_Calculated.ValueData = TRUE THEN COALESCE (MIFloat_Summ.ValueData, 0) ELSE MovementItem.Amount END AS OperSumm
             , COALESCE (MIFloat_AmountCurrency.ValueData, 0) AS OperSumm_Currency
             , MovementItem.Id AS MovementItemId
             -- , inMovementId    AS MovementId
             , COALESCE (MIFloat_ContainerId.ValueData, 0)   AS ContainerId         -- сформируем позже, или ...
             , COALESCE (View_Account.AccountGroupId, 0)     AS AccountGroupId      -- сформируем позже, или ...
             , COALESCE (View_Account.AccountDirectionId, 0) AS AccountDirectionId  -- сформируем позже, или ...
             , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- Маркетинг
                         -- MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502(), zc_Enum_InfoMoney_21512()) -- Бонусы за продукцию + Бонусы за мясное сырье + Маркетинговый бюджет
                         THEN vbAccountId
                    ELSE vbAccountId -- 0
               END AS AccountId
             , vbAccountId AS AccountId_main

               -- Группы ОПиУ
             , 0 AS ProfitLossGroupId
               -- Аналитики ОПиУ - направления
             , 0 AS ProfitLossDirectionId
             -- Управленческие группы назначения
             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
             -- Управленческие назначения
             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
             -- Управленческие статьи назначения
             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
               -- Бизнес: нет
             , 0  AS BusinessId
               -- Главное Юр.лицо: всегда из договора
             , CASE WHEN MILinkObject_JuridicalBasis.ObjectId > 0 THEN MILinkObject_JuridicalBasis.ObjectId ELSE COALESCE (ObjectLink_Contract_JuridicalBasis.ChildObjectId, zc_Juridical_Basis()) END AS JuridicalId_Basis
               -- Подразделение (затраты): нет
             , 0 AS UnitId
               -- еще одна аналитика для 2-ой формы и не наши компании
             , CASE WHEN MILinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                     AND View_Constant_isCorporate.InfoMoneyId IS NULL
                     AND COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) = FALSE
                         THEN COALESCE (MILinkObject_Branch.ObjectId, 0) -- !!! zc_Branch_Basis
                    ELSE 0
               END AS BranchId
             , COALESCE (MILinkObject_Contract.ObjectId, 0)  AS ContractId
             , COALESCE (MILinkObject_PaidKind.ObjectId, 0)  AS PaidKindId
             , lpInsertFind_Object_PartionMovement (COALESCE (MIFloat_MovementId.ValueData, 0) :: Integer, NULL) AS PartionMovementId
             , MIBoolean_Calculated.ValueData AS isCalculated
             , COALESCE (MILinkObject_Currency.ObjectId, zc_Enum_Currency_Basis())  AS CurrencyId
        FROM MovementItem
             LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                         ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                        AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountCurrency
                                         ON MIFloat_AmountCurrency.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountCurrency.DescId = zc_MIFloat_AmountCurrency()
             LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                         ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                        AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                              ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                              ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                              ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                              ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                              ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_JuridicalBasis
                                              ON MILinkObject_JuridicalBasis.MovementItemId = MovementItem.Id
                                             AND MILinkObject_JuridicalBasis.DescId         = zc_MILinkObject_JuridicalBasis()
             LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                           ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                          AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
             LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis ON ObjectLink_Contract_JuridicalBasis.ObjectId = MILinkObject_Contract.ObjectId
                                                                       AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
             LEFT JOIN Object_Account_View   AS View_Account   ON View_Account.AccountId     = vbAccountId

             LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                     ON ObjectBoolean_isCorporate.ObjectId = MovementItem.ObjectId
                                    AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
             LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                                  ON ObjectLink_Juridical_InfoMoney.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Juridical_InfoMoney.DescId   = zc_ObjectLink_Juridical_InfoMoney()
             LEFT JOIN Constant_InfoMoney_isCorporate_View AS View_Constant_isCorporate ON View_Constant_isCorporate.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
       ;

     WITH tmpListContainer AS (-- Все контейнеры - по которым есть ПАРТИЯ
                               SELECT Container.Id                                       AS ContainerId
                                    , Container.Amount
                                    , COALESCE (ContainerLO_Juridical.ObjectId, 0)       AS JuridicalId
                                    , COALESCE (ContainerLO_Partner.ObjectId, 0)         AS PartnerId
                                    , COALESCE (ContainerLO_Branch.ObjectId, 0)          AS BranchId
                                    , COALESCE (ContainerLO_InfoMoney.ObjectId, 0)       AS InfoMoneyId
                                    , COALESCE (ContainerLO_PaidKind.ObjectId, 0)        AS PaidKindId
                                    , COALESCE (ContainerLO_JuridicalBasis.ObjectId, 0)  AS JuridicalId_Basis
                                    , COALESCE (ContainerLO_PartionMovement.ObjectId, 0) AS PartionMovementId
                                    , COALESCE (ContainerLO_Business.ObjectId, 0)        AS BusinessId
                               FROM (SELECT DISTINCT ContainerId FROM _tmpListMI WHERE isCalculated = TRUE AND ContainerId <> 0
                                    ) AS tmpMI
                                    LEFT JOIN Container ON Container.Id     = tmpMI.ContainerId
                                                       AND Container.DescId = zc_Container_Summ()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                  ON ContainerLO_Juridical.ContainerId = Container.Id
                                                                 AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                                                  ON ContainerLO_Partner.ContainerId = Container.Id
                                                                 AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                                  ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                                 AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                                  ON ContainerLO_PaidKind.ContainerId = Container.Id
                                                                 AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                                                  ON ContainerLO_JuridicalBasis.ContainerId = Container.Id
                                                                 AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Business
                                                                  ON ContainerLO_Business.ContainerId = Container.Id
                                                                 AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                                  ON ContainerLO_Branch.ContainerId = Container.Id
                                                                 AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PartionMovement
                                                                  ON ContainerLO_PartionMovement.ContainerId = Container.Id
                                                                 AND ContainerLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                               WHERE vbIsLossOnly = FALSE -- !!!только если НЕ списание!!!
                              UNION
                               -- Все контейнеры - по которым есть ввод долга + счет в документе + Вид формы оплаты
                               SELECT Container.Id                               AS ContainerId
                                    , Container.Amount
                                    , tmpMovementItem.JuridicalId
                                    , COALESCE (ContainerLO_Partner.ObjectId, 0) AS PartnerId
                                    -- , COALESCE (ContainerLO_Branch.ObjectId, 0)  AS BranchId
                                    , tmpMovementItem.BranchId
                                    , tmpMovementItem.InfoMoneyId
                                    , tmpMovementItem.PaidKindId
                                    , tmpMovementItem.JuridicalId_Basis
                                    , tmpMovementItem.PartionMovementId
                                    , tmpMovementItem.BusinessId
                               FROM (SELECT DISTINCT ObjectId AS JuridicalId, InfoMoneyId, PaidKindId, JuridicalId_Basis, BranchId, BusinessId, PartionMovementId, AccountId FROM _tmpListMI WHERE isCalculated = TRUE AND ContainerId = 0
                                    ) AS tmpMovementItem
                                    JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                            AND ContainerLO_Juridical.ObjectId = tmpMovementItem.JuridicalId
                                    JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                             ON ContainerLO_InfoMoney.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                            AND ContainerLO_InfoMoney.ObjectId = tmpMovementItem.InfoMoneyId
                                    JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                             ON ContainerLO_PaidKind.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                            AND ContainerLO_PaidKind.ObjectId = tmpMovementItem.PaidKindId
                                    JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                                             ON ContainerLO_JuridicalBasis.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                            AND ContainerLO_JuridicalBasis.ObjectId = tmpMovementItem.JuridicalId_Basis
                                    JOIN ContainerLinkObject AS ContainerLO_Business
                                                             ON ContainerLO_Business.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                                            AND ContainerLO_Business.ObjectId = tmpMovementItem.BusinessId
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                                  ON ContainerLO_Branch.ContainerId = ContainerLO_Juridical.ContainerId
                                                                 AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                    JOIN ContainerLinkObject AS ContainerLO_PartionMovement
                                                             ON ContainerLO_PartionMovement.ContainerId = ContainerLO_Juridical.ContainerId
                                                            AND ContainerLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                                                            AND ContainerLO_PartionMovement.ObjectId = tmpMovementItem.PartionMovementId
                                    JOIN Container ON Container.Id = ContainerLO_Juridical.ContainerId
                                                  AND Container.DescId = zc_Container_Summ()
                                                  AND (Container.ObjectId = tmpMovementItem.AccountId
                                                    OR (tmpMovementItem.AccountId = 0 AND Container.ObjectId <> zc_Enum_Account_50401()) -- Расходы будущих периодов - Маркетинг
                                                      )
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                                                  ON ContainerLO_Partner.ContainerId = ContainerLO_Juridical.ContainerId
                                                                 AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                               WHERE vbIsLossOnly = FALSE -- !!!только если НЕ списание!!!
                                 AND (ContainerLO_Branch.ObjectId = tmpMovementItem.BranchId
                                   OR tmpMovementItem.BranchId = 0
                                     )
                                 /*AND ((ContainerLO_Branch.ObjectId IN (zc_Branch_Basis(), 0)
                                       AND inMovementId = 1110118  -- № 27 от 31.12.2014
                                      ) OR inMovementId <> 1110118) -- № 27 от 31.12.2014*/
                              UNION
                               -- Все контейнеры - по счету в документе + Вид формы оплаты
                               SELECT Container.Id                               AS ContainerId
                                    , Container.Amount
                                    , ContainerLO_Juridical.ObjectId             AS JuridicalId
                                    , COALESCE (ContainerLO_Partner.ObjectId, 0) AS PartnerId
                                    , COALESCE (ContainerLO_Branch.ObjectId, 0)  AS BranchId
                                    , ContainerLO_InfoMoney.ObjectId             AS InfoMoneyId
                                    , ContainerLO_PaidKind.ObjectId              AS PaidKindId
                                    , ContainerLO_JuridicalBasis.ObjectId        AS JuridicalId_Basis
                                    , ContainerLO_PartionMovement.ObjectId       AS PartionMovementId
                                    , ContainerLO_Business.ObjectId              AS BusinessId
                               FROM Object_Account_View AS View_Account
                                    -- JOIN Object_Account_View AS View_Account_find ON View_Account_find.AccountDirectionId = View_Account.AccountDirectionId
                                    JOIN Object_Account_View AS View_Account_find ON View_Account_find.AccountId = View_Account.AccountId
                                    JOIN Container ON Container.ObjectId = View_Account_find.AccountId
                                                  AND Container.DescId = zc_Container_Summ()
                                    JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                             ON ContainerLO_PaidKind.ContainerId = Container.Id
                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                            AND ContainerLO_PaidKind.ObjectId = vbPaidKindId
                                    JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.ContainerId = Container.Id
                                                            AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                    JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                             ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                            AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                    JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                                             ON ContainerLO_JuridicalBasis.ContainerId = Container.Id
                                                            AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                    JOIN ContainerLinkObject AS ContainerLO_Business
                                                             ON ContainerLO_Business.ContainerId = Container.Id
                                                            AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                                                  ON ContainerLO_Partner.ContainerId = Container.Id
                                                                 AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                                  ON ContainerLO_Branch.ContainerId = ContainerLO_Juridical.ContainerId
                                                                 AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PartionMovement
                                                                  ON ContainerLO_PartionMovement.ContainerId = Container.Id
                                                                 AND ContainerLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                               WHERE vbAccountId <> 0
                                 AND View_Account.AccountId = vbAccountId
                                 AND vbIsLossOnly = FALSE -- !!!только если НЕ списание!!!
                                 AND vbIsListOnly = FALSE -- !!!только если НЕ для списка!!!
                                 AND ((ContainerLO_Branch.ObjectId IN (zc_Branch_Basis(), 0)
                                       AND inMovementId = 1110118  -- № 27 от 31.12.2014
                                      )
                                   OR (ContainerLO_Branch.ObjectId IN (8378) -- Донецк
                                       AND inMovementId = 1374968 -- № 36 от 31.12.2014
                                      )
                                   OR (ContainerLO_Branch.ObjectId IN (8379) -- филиал Киев
                                       AND inMovementId = 2943608 -- № 43 от 30.11.2015 (Киев нал)
                                      )
                                   OR inMovementId NOT IN (1110118, 1374968, 2943608) -- № 27 от 31.12.2014 + № 36 от 31.12.2014 + № 43 от 30.11.2015
                                     )
                              UNION
                               -- Все контейнеры - для Вид формы оплаты, если пустой счет
                               SELECT Container.Id                               AS ContainerId
                                    , Container.Amount
                                    , ContainerLO_Juridical.ObjectId             AS JuridicalId
                                    , COALESCE (ContainerLO_Partner.ObjectId, 0) AS PartnerId
                                    , COALESCE (ContainerLO_Branch.ObjectId, 0)  AS BranchId
                                    , ContainerLO_InfoMoney.ObjectId             AS InfoMoneyId
                                    , ContainerLO_PaidKind.ObjectId              AS PaidKindId
                                    , ContainerLO_JuridicalBasis.ObjectId        AS JuridicalId_Basis
                                    , ContainerLO_PartionMovement.ObjectId       AS PartionMovementId
                                    , ContainerLO_Business.ObjectId              AS BusinessId
                               FROM (SELECT Object_Account_View.AccountId
                                     FROM Object_Account_View
                                     WHERE Object_Account_View.AccountDirectionId NOT IN (zc_Enum_AccountDirection_30300() -- Дебиторы по услугам
                                                                                        , zc_Enum_AccountDirection_70200() -- Кредиторы по услугам
                                                                                        , zc_Enum_AccountDirection_70300() -- Кредиторы по маркетингу
                                                                                        , zc_Enum_AccountDirection_70400() -- Коммунальные услуги
                                                                                         )
                                       AND Object_Account_View.AccountGroupId IN (zc_Enum_AccountGroup_30000() -- Дебиторы
                                                                                , zc_Enum_AccountGroup_70000() -- Кредиторы
                                                                                , zc_Enum_AccountGroup_80000() -- Кредитование
                                                                                , zc_Enum_AccountGroup_90000() -- Расчеты с бюджетом
                                                                                 )
                                       AND vbAccountId = 0
                                       AND inMovementId <> 123096  -- № 15 от 31.12.2013
                                       AND inMovementId <> 1110118 -- № 27 от 31.12.2014
                                       AND inMovementId <> 1374968 -- № 36 от 31.12.2014
                                    ) AS tmpAccount
                                    JOIN ContainerLinkObject AS ContainerLO_PaidKind
                                                             ON ContainerLO_PaidKind.ObjectId = vbPaidKindId
                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                    JOIN Container ON Container.Id       = ContainerLO_PaidKind.ContainerId
                                                  AND Container.ObjectId = tmpAccount.AccountId
                                                  AND Container.DescId   = zc_Container_Summ()

                                    JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                             ON ContainerLO_Juridical.ContainerId = Container.Id
                                                            AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                    JOIN ContainerLinkObject AS ContainerLO_InfoMoney
                                                             ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                            AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                    JOIN ContainerLinkObject AS ContainerLO_JuridicalBasis
                                                             ON ContainerLO_JuridicalBasis.ContainerId = Container.Id
                                                            AND ContainerLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                    JOIN ContainerLinkObject AS ContainerLO_Business
                                                             ON ContainerLO_Business.ContainerId = Container.Id
                                                            AND ContainerLO_Business.DescId = zc_ContainerLinkObject_Business()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Partner
                                                                  ON ContainerLO_Partner.ContainerId = Container.Id
                                                                 AND ContainerLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                                  ON ContainerLO_Branch.ContainerId = ContainerLO_Juridical.ContainerId
                                                                 AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                                    LEFT JOIN ContainerLinkObject AS ContainerLO_PartionMovement
                                                                  ON ContainerLO_PartionMovement.ContainerId = Container.Id
                                                                 AND ContainerLO_PartionMovement.DescId = zc_ContainerLinkObject_PartionMovement()
                               WHERE vbIsLossOnly = FALSE -- !!!только если НЕ списание!!!
                                 AND vbIsListOnly = FALSE -- !!!только если НЕ для списка!!!
                              )

     -- Первый
     INSERT INTO _tmpListContainer (ContainerId, Amount, JuridicalId, PartnerId, BranchId, InfoMoneyId, PaidKindId, JuridicalId_Basis, PartionMovementId, BusinessId)
        SELECT tmpListContainer.ContainerId, tmpListContainer.Amount, tmpListContainer.JuridicalId, tmpListContainer.PartnerId, tmpListContainer.BranchId, tmpListContainer.InfoMoneyId, tmpListContainer.PaidKindId, tmpListContainer.JuridicalId_Basis, tmpListContainer.PartionMovementId, tmpListContainer.BusinessId
        FROM tmpListContainer;

IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.<%>   %     %   %'
    , (select _tmpListContainer.Amount from _tmpListContainer limit 1)
    , (select count(*) from _tmpListContainer)
    , (select count(*) from _tmpListMI)
    , vbIsLossOnly
    ;
END IF;


     -- Нашли для забаланса
     UPDATE _tmpListContainer SET ContainerId_Asset = lpInsertFind_Container (inContainerDescId   := zc_Container_SummAsset()
                                                                            , inParentId          := NULL
                                                                            , inObjectId          := (SELECT Container.ObjectId FROM Container WHERE Container.Id = _tmpListContainer.ContainerId)
                                                                            , inJuridicalId_basis := _tmpListContainer.JuridicalId_Basis
                                                                            , inBusinessId        := _tmpListContainer.BusinessId
                                                                            , inObjectCostDescId  := NULL
                                                                            , inObjectCostId      := NULL
                                                                            , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                                            , inObjectId_1        := _tmpListContainer.JuridicalId
                                                                            , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                                            , inObjectId_2        := (SELECT CLO.ObjectId FROM ContainerLinkObject AS CLO WHERE CLO.ContainerId = _tmpListContainer.ContainerId AND CLO.DescId = zc_ContainerLinkObject_Contract())
                                                                            , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                                            , inObjectId_3        := _tmpListContainer.InfoMoneyId
                                                                            , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                                            , inObjectId_4        := _tmpListContainer.PaidKindId
                                                                            , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                                            , inObjectId_5        := 0 -- !!!по этой аналитике учет пока не ведем!!!
                                                                            , inDescId_6          := CASE WHEN _tmpListContainer.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                                            , inObjectId_6        := CASE WHEN _tmpListContainer.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN _tmpListContainer.PartnerId ELSE NULL END
                                                                            , inDescId_7          := CASE WHEN _tmpListContainer.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                                            , inObjectId_7        := CASE WHEN _tmpListContainer.PaidKindId = zc_Enum_PaidKind_SecondForm() THEN zc_Branch_Basis() ELSE NULL END -- долг Поставщика всегда на Главном филиале
                                                                            , inDescId_8          := CASE WHEN (SELECT CLO.ObjectId FROM ContainerLinkObject AS CLO WHERE CLO.ContainerId = _tmpListContainer.ContainerId AND CLO.DescId = zc_ContainerLinkObject_Currency()) = zc_Enum_Currency_Basis() THEN NULL ELSE zc_ContainerLinkObject_Currency() END
                                                                            , inObjectId_8        := CASE WHEN (SELECT CLO.ObjectId FROM ContainerLinkObject AS CLO WHERE CLO.ContainerId = _tmpListContainer.ContainerId AND CLO.DescId = zc_ContainerLinkObject_Currency()) = zc_Enum_Currency_Basis() THEN NULL ELSE (SELECT CLO.ObjectId FROM ContainerLinkObject AS CLO WHERE CLO.ContainerId = _tmpListContainer.ContainerId AND CLO.DescId = zc_ContainerLinkObject_Currency()) END
                                                                             )
     FROM Object_InfoMoney_View AS View_InfoMoney
     WHERE vbOperDate >= zc_DateStart_Asset()
       AND View_InfoMoney.InfoMoneyId = _tmpListContainer.InfoMoneyId
       AND View_InfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
    ;
     -- Нашли для забаланса
     UPDATE _tmpListMI SET ContainerId_Asset = _tmpListContainer.ContainerId_Asset
     FROM _tmpListContainer
     WHERE _tmpListMI.ContainerId = _tmpListContainer.ContainerId
    ;


     -- оптимизация
     ANALYZE _tmpListContainer;

     -- Второй
     WITH tmpContainerSumm AS (SELECT tmpListContainer.ContainerId
                                    , tmpListContainer.ContainerId_Asset
                                    , tmpListContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS SummRemainsEnd
                                    , tmpListContainer.JuridicalId
                                    , tmpListContainer.PartnerId
                                    , tmpListContainer.BranchId
                                    , tmpListContainer.InfoMoneyId
                                    , tmpListContainer.PaidKindId
                                    , tmpListContainer.JuridicalId_Basis
                                    , tmpListContainer.PartionMovementId
                                    , tmpListContainer.BusinessId
                               FROM _tmpListContainer AS tmpListContainer
                                    LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpListContainer.ContainerId
                                                                                  AND MIContainer.OperDate > vbOperDate
                               GROUP BY tmpListContainer.ContainerId
                                      , tmpListContainer.ContainerId_Asset
                                      , tmpListContainer.Amount
                                      , tmpListContainer.JuridicalId
                                      , tmpListContainer.PartnerId
                                      , tmpListContainer.BranchId
                                      , tmpListContainer.InfoMoneyId
                                      , tmpListContainer.PaidKindId
                                      , tmpListContainer.JuridicalId_Basis
                                      , tmpListContainer.PartionMovementId
                                      , tmpListContainer.BusinessId
                               HAVING tmpListContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)  <> 0
                              )
        , tmpResult AS (-- те, которые НАШЛИСЬ
                        SELECT tmpMovementItem.ObjectId
                             , tmpMovementItem.PartnerId
                             , tmpMovementItem.BranchId
                             , CASE WHEN tmpMovementItem.isCalculated = TRUE
                                         THEN tmpMovementItem.OperSumm - COALESCE (tmpContainerSumm_real.SummRemainsEnd, COALESCE (tmpContainerSumm.SummRemainsEnd, 0))
                                    ELSE tmpMovementItem.OperSumm
                               END AS OperSumm
                             , CASE WHEN tmpMovementItem.isCalculated = TRUE
                                         THEN 0
                                    ELSE tmpMovementItem.OperSumm_Currency
                               END AS OperSumm_Currency
                             , tmpMovementItem.MovementItemId
                             , COALESCE (tmpContainerSumm.ContainerId, tmpMovementItem.ContainerId) AS ContainerId
                             , COALESCE (tmpContainerSumm.ContainerId_Asset, tmpMovementItem.ContainerId_Asset) AS ContainerId_Asset

                             , tmpMovementItem.AccountGroupId, tmpMovementItem.AccountDirectionId, tmpMovementItem.AccountId

                             , tmpMovementItem.ProfitLossGroupId
                             , tmpMovementItem.ProfitLossDirectionId
                             , tmpMovementItem.InfoMoneyGroupId
                             , tmpMovementItem.InfoMoneyDestinationId
                             , tmpMovementItem.InfoMoneyId
                             , tmpMovementItem.BusinessId
                             , tmpMovementItem.JuridicalId_Basis
                             , tmpMovementItem.UnitId
                             , tmpMovementItem.ContractId
                             , tmpMovementItem.PaidKindId
                             , tmpMovementItem.PartionMovementId
                             , tmpMovementItem.CurrencyId
                        FROM _tmpListMI AS tmpMovementItem
                             -- "в первую очередь"
                             LEFT JOIN (SELECT tmpContainerSumm.*
                                        FROM tmpContainerSumm
                                       ) AS tmpContainerSumm_real ON tmpContainerSumm_real.ContainerId = tmpMovementItem.ContainerId
                             -- "во вторую очередь"
                             LEFT JOIN (SELECT tmpContainerSumm.*, ContainerLO_Contract.ObjectId AS ContractId
                                        FROM tmpContainerSumm
                                             JOIN ContainerLinkObject AS ContainerLO_Contract
                                                                      ON ContainerLO_Contract.ContainerId = tmpContainerSumm.ContainerId
                                                                     AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                       ) AS tmpContainerSumm ON tmpContainerSumm.JuridicalId       = tmpMovementItem.ObjectId
                                                            AND tmpContainerSumm.PartnerId         = tmpMovementItem.PartnerId
                                                            AND tmpContainerSumm.BranchId          = tmpMovementItem.BranchId
                                                            AND tmpContainerSumm.InfoMoneyId       = tmpMovementItem.InfoMoneyId
                                                            AND tmpContainerSumm.PaidKindId        = tmpMovementItem.PaidKindId
                                                            AND tmpContainerSumm.JuridicalId_Basis = tmpMovementItem.JuridicalId_Basis
                                                            AND tmpContainerSumm.BusinessId        = tmpMovementItem.BusinessId
                                                            AND tmpContainerSumm.ContractId        = tmpMovementItem.ContractId
                                                            AND tmpContainerSumm.PartionMovementId = tmpMovementItem.PartionMovementId
                                                            AND tmpContainerSumm_real.ContainerId IS NULL -- !!!т.е. НЕТ "в первую очередь"!!!
                      UNION ALL
                        -- те, которых НЕТ
                        SELECT tmpContainerSumm.JuridicalId AS ObjectId
                             , tmpContainerSumm.PartnerId
                             , tmpContainerSumm.BranchId
                             , -1 * tmpContainerSumm.SummRemainsEnd AS OperSumm
                             , 0                                    AS OperSumm_Currency
                             , lpInsertUpdate_MovementItem_LossDebt (ioId                   := 0
                                                                   , inMovementId           := inMovementId
                                                                   , inJuridicalId          := tmpContainerSumm.JuridicalId
                                                                   , inPartnerId            := tmpContainerSumm.PartnerId
                                                                   , inBranchId             := tmpContainerSumm.BranchId
                                                                   , inContainerId          := 0
                                                                   , inAmount               := 0
                                                                   , inSumm                 := 0
                                                                   , inCurrencyPartnerValue := 0
                                                                   , inParPartnerValue      := 0
                                                                   , inAmountCurrency       := 0
                                                                   , inIsCalculated         := TRUE
                                                                   , inContractId           := ContainerLO_Contract.ObjectId
                                                                   , inPaidKindId           := tmpContainerSumm.PaidKindId
                                                                   , inInfoMoneyId          := tmpContainerSumm.InfoMoneyId
                                                                   , inUnitId               := NULL
                                                                   , inCurrencyId           := NULL
                                                                   , inUserId               := inUserId
                                                                    ) AS MovementItemId
                             , tmpContainerSumm.ContainerId
                             , tmpContainerSumm.ContainerId_Asset
                             , 0 AS AccountGroupId, 0 AS AccountDirectionId -- сформируем позже, или ...
                             , CASE WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- Маркетинг
                                         -- tmpContainerSumm.InfoMoneyId IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502()) -- Бонусы за продукцию + Бонусы за мясное сырье
                                         -- tmpContainerSumm.InfoMoneyId IN (zc_Enum_InfoMoney_21501(), zc_Enum_InfoMoney_21502(), zc_Enum_InfoMoney_21512()) -- Бонусы за продукцию + Бонусы за мясное сырье + Маркетинговый бюджет
                                         THEN vbAccountId
                                    ELSE vbAccountId -- 0
                               END AS AccountId

                               -- Группы ОПиУ
                             , 0 AS ProfitLossGroupId
                               -- Аналитики ОПиУ - направления
                             , 0 AS ProfitLossDirectionId
                               -- Управленческие группы назначения
                             , COALESCE (View_InfoMoney.InfoMoneyGroupId, 0) AS InfoMoneyGroupId
                               -- Управленческие назначения
                             , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                               -- Управленческие статьи назначения
                             , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                               -- Бизнес: нет
                             , 0  AS BusinessId
                             , tmpContainerSumm.JuridicalId_Basis
                               -- Подразделение (затраты): нет
                             , 0 AS UnitId
                             , ContainerLO_Contract.ObjectId AS ContractId
                             , tmpContainerSumm.PaidKindId
                             , tmpContainerSumm.PartionMovementId
                             , zc_Enum_Currency_Basis() AS CurrencyId
                        FROM tmpContainerSumm
                             JOIN ContainerLinkObject AS ContainerLO_Contract
                                                      ON ContainerLO_Contract.ContainerId = tmpContainerSumm.ContainerId
                                                     AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                                                     -- AND ContainerLO_Contract.ObjectId > 0
                             LEFT JOIN _tmpListMI AS tmpMovementItem_real ON tmpMovementItem_real.ContainerId = tmpContainerSumm.ContainerId
                             LEFT JOIN _tmpListMI AS tmpMovementItem
                                    ON tmpMovementItem.ObjectId          = tmpContainerSumm.JuridicalId
                                   AND tmpMovementItem.PartnerId         = tmpContainerSumm.PartnerId
                                   AND tmpMovementItem.BranchId          = tmpContainerSumm.BranchId
                                   AND tmpMovementItem.InfoMoneyId       = tmpContainerSumm.InfoMoneyId
                                   AND tmpMovementItem.PaidKindId        = tmpContainerSumm.PaidKindId
                                   AND tmpMovementItem.JuridicalId_Basis = tmpContainerSumm.JuridicalId_Basis
                                   AND tmpMovementItem.BusinessId        = tmpContainerSumm.BusinessId
                                   AND tmpMovementItem.ContractId        = COALESCE (ContainerLO_Contract.ObjectId, 0) -- !!!важно, т.к. может быть NULL!!!
                                   AND tmpMovementItem.PartionMovementId = tmpContainerSumm.PartionMovementId
                             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpContainerSumm.InfoMoneyId
                        WHERE tmpContainerSumm.SummRemainsEnd <> 0
                          AND tmpMovementItem.ObjectId IS NULL
                          AND tmpMovementItem_real.ContainerId IS NULL
                       )
     -- Расчет
     INSERT INTO _tmpItem (MovementDescId, OperDate, ObjectId, ObjectDescId, OperSumm, OperSumm_Currency, OperSumm_Asset
                         , MovementItemId, ContainerId
                         , AccountGroupId, AccountDirectionId, AccountId
                         , ProfitLossGroupId, ProfitLossDirectionId
                         , InfoMoneyGroupId, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_Balance, BusinessId_ProfitLoss, JuridicalId_Basis
                         , UnitId, PositionId, BranchId_Balance, BranchId_ProfitLoss, ServiceDateId, ContractId, PaidKindId
                         , PartionMovementId
                         , CurrencyId
                         , IsActive, IsMaster
                          )
        -- 1. PartnerId or JuridicalId
        SELECT zc_Movement_LossDebt() AS MovementDescId
             , vbOperDate             AS OperDate
               -- "Главным" будет или Контрагент или Юр.лицо
             , CASE WHEN tmpResult.PartnerId <> 0
                         THEN tmpResult.PartnerId
                    ELSE tmpResult.ObjectId
               END AS ObjectId
             , CASE WHEN tmpResult.PartnerId <> 0
                         THEN zc_Object_Partner()
                    ELSE zc_Object_Juridical()
               END AS ObjectDescId
             , tmpResult.OperSumm
               -- если переносим в забаланс
             , CASE WHEN vbOperDate >= zc_DateStart_Asset() AND tmpResult.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                    THEN 0 -- ничего делать не надо
                    ELSE tmpResult.OperSumm_Currency
               END AS OperSumm_Currency

             , 0 AS OperSumm_Asset

             , tmpResult.MovementItemId

             , tmpResult.ContainerId
             , tmpResult.AccountGroupId, tmpResult.AccountDirectionId, tmpResult.AccountId

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId -- не используется

             , tmpResult.InfoMoneyGroupId
             , tmpResult.InfoMoneyDestinationId
             , tmpResult.InfoMoneyId

               -- Бизнес Баланс
             , tmpResult.BusinessId AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо
             , tmpResult.JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: (нужен для НАЛ долгов)
             , tmpResult.BranchId AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , tmpResult.ContractId
             , tmpResult.PaidKindId

             , tmpResult.PartionMovementId

             , tmpResult.CurrencyId

             , CASE WHEN tmpResult.OperSumm >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , TRUE AS IsMaster
        FROM tmpResult
        WHERE tmpResult.OperSumm <> 0
           OR CASE WHEN vbOperDate >= zc_DateStart_Asset() AND tmpResult.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
                   THEN 0 -- ничего делать не надо
                   ELSE tmpResult.OperSumm_Currency
              END <> 0

       UNION ALL
        -- 2. ОПиУ
        SELECT zc_Movement_LossDebt() AS MovementDescId
             , vbOperDate             AS OperDate
             -- , CASE WHEN vbOperDate < '01.06.2014' THEN zc_Enum_ProfitLoss_80301() ELSE 0 END AS ObjectId -- Расходы с прибыли + Списание дебиторской задолженности + Продукция
             , CASE WHEN vbOperDate < '01.01.2015' THEN zc_Enum_ProfitLoss_80301() ELSE 0 END AS ObjectId -- Расходы с прибыли + Списание дебиторской задолженности + Продукция
             , 0 AS ObjectDescId

             , -1 * tmpResult.OperSumm
             , 0 AS OperSumm_Currency
             , 0 AS OperSumm_Asset

             , tmpResult.MovementItemId

             , 0 AS ContainerId                                                     -- сформируем позже
             , 0 AS AccountGroupId, 0 AS AccountDirectionId, 0 AS AccountId         -- сформируем позже, или ...

               -- Группы ОПиУ (для затрат)
             , tmpResult.ProfitLossGroupId
               -- Аналитики ОПиУ - направления (для затрат)
             , CASE WHEN vbOperDate < '01.06.2014' THEN tmpResult.ProfitLossDirectionId ELSE zc_Enum_ProfitLossDirection_80300() END AS ProfitLossDirectionId -- Списание дебиторской задолженности

             , tmpResult.InfoMoneyGroupId
             , tmpResult.InfoMoneyDestinationId
             , tmpResult.InfoMoneyId

               -- Бизнес Баланс: не используется
             , 0 AS BusinessId_Balance
               -- Бизнес ОПиУ:
             , tmpResult.BusinessId

               -- Главное Юр.лицо
             , tmpResult.JuridicalId_Basis

             , tmpResult.UnitId
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: не используется
             , 0 AS BranchId_Balance
               -- Филиал ОПиУ:
             , tmpResult.BranchId

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , 0 AS ContractId -- не используется
             , 0 AS PaidKindId -- не используется

             , 0 AS PartionMovementId -- не используется

             , zc_Enum_Currency_Basis() AS CurrencyId -- !!!ОПиУ - ВСЕГДА в ГРН!!!

             , CASE WHEN tmpResult.OperSumm >= 0 THEN FALSE ELSE TRUE END AS IsActive
             , FALSE AS IsMaster
        FROM tmpResult
        WHERE tmpResult.OperSumm <> 0

       UNION ALL
        -- 3. забаланс
        SELECT zc_Movement_LossDebt() AS MovementDescId
             , vbOperDate             AS OperDate
               -- "Главным" будет или Контрагент или Юр.лицо
             , CASE WHEN tmpResult.PartnerId <> 0
                         THEN tmpResult.PartnerId
                    ELSE tmpResult.ObjectId
               END AS ObjectId
             , CASE WHEN tmpResult.PartnerId <> 0
                         THEN zc_Object_Partner()
                    ELSE zc_Object_Juridical()
               END AS ObjectDescId

             , 0 AS OperSumm
             , 0 AS OperSumm_Currency

             , -1 * tmpResult.OperSumm AS OperSumm_Asset

             , tmpResult.MovementItemId

             , tmpResult.ContainerId_Asset
             , tmpResult.AccountGroupId, tmpResult.AccountDirectionId, tmpResult.AccountId

             , 0 AS ProfitLossGroupId, 0 AS ProfitLossDirectionId -- не используется

             , tmpResult.InfoMoneyGroupId
             , tmpResult.InfoMoneyDestinationId
             , tmpResult.InfoMoneyId

               -- Бизнес Баланс
             , tmpResult.BusinessId AS BusinessId_Balance
               -- Бизнес ОПиУ: не используется
             , 0 AS BusinessId_ProfitLoss

               -- Главное Юр.лицо
             , tmpResult.JuridicalId_Basis

             , 0 AS UnitId     -- не используется
             , 0 AS PositionId -- не используется

               -- Филиал Баланс: (нужен для НАЛ долгов)
             , tmpResult.BranchId AS BranchId_Balance
               -- Филиал ОПиУ: не используется
             , 0 AS BranchId_ProfitLoss

               -- Месяц начислений: не используется
             , 0 AS ServiceDateId

             , tmpResult.ContractId
             , tmpResult.PaidKindId

             , tmpResult.PartionMovementId

             , tmpResult.CurrencyId

             , NOT CASE WHEN tmpResult.OperSumm >= 0 THEN TRUE ELSE FALSE END AS IsActive
             , FALSE AS IsMaster
        FROM tmpResult
        WHERE tmpResult.OperSumm <> 0
          AND vbOperDate >= zc_DateStart_Asset() AND tmpResult.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_70000()
       ;

     -- проверка
     IF EXISTS (SELECT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.ObjectId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определено <Юридическое лицо>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.ContractId FROM _tmpItem WHERE _tmpItem.ContractId = 0 AND _tmpItem.IsMaster = TRUE AND 1=0)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определен <№ дог.>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.PaidKindId FROM _tmpItem WHERE _tmpItem.PaidKindId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определена <Форма оплаты>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.InfoMoneyId FROM _tmpItem WHERE _tmpItem.InfoMoneyId = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.В документе не определена <УП статья назначения>.Проведение невозможно.';
     END IF;
     IF EXISTS (SELECT _tmpItem.JuridicalId_Basis FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0 AND _tmpItem.IsMaster = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.У <Договора> не установлено <Главное юридическое лицо>.Проведение невозможно.<%><%>', lfGet_Object_ValueData ((SELECT MAX (ObjectId) FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0 AND _tmpItem.IsMaster = TRUE)), (SELECT MAX (ContractId) FROM _tmpItem WHERE _tmpItem.JuridicalId_Basis = 0 AND _tmpItem.IsMaster = TRUE);
     END IF;

     /*
     -- !!!5.0. формируются свойства в элементах документа из данных для проводок!!!
     UPDATE MovementItem SET Amount =  _tmpItem.OperSumm
     FROM _tmpItem
          JOIN MovementItemBoolean AS MIBoolean_Calculated
                                   ON MIBoolean_Calculated.MovementItemId = _tmpItem.MovementItemId
                                  AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                                  AND MIBoolean_Calculated.ValueData = TRUE
     WHERE MovementItem.Id = _tmpItem.MovementItemId
       AND _tmpItem.IsMaster = TRUE
    ;*/

     -- 5.1. ФИНИШ - формируем/сохраняем Проводки
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);


     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_LossDebt()
                                , inUserId     := inUserId
                                 );

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 07.09.14                                        * add BranchId
 31.08.14                                        * add PartnerId
 17.08.14                                        * add MovementDescId
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 20.04.14                                        * add HAVING ...
 20.03.14                                        * add !!!некрасивое решение!!!
 19.03.14                                        * add View_Account_find
 10.03.14                                        * add zc_Enum_Account_50401
 30.01.14                                        * all
 27.01.14         *
*/
/*
SELECT Movement.Id, Movement.InvNumber, Movement.OperDate
     , COALESCE (MovementItem.ObjectId, 0) AS JuridicalId
     , COALESCE (MILinkObject_InfoMoney.ObjectId, 0) AS InfoMoneyId
     , COALESCE (MILinkObject_Contract.ObjectId, 0) AS ContractId
     , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId
     , COALESCE (MILinkObject_Partner.ObjectId, 0) AS PartnerId
     , COALESCE (MILinkObject_Branch.ObjectId, 0) AS BranchId
     , min (MovementItem.Amount), max (MovementItem.Amount)
     , min (COALESCE (MIFloat_Summ.ValueData, 0))
     , max (COALESCE (MIFloat_Summ.ValueData, 0))
FROM Movement
     inner join MovementItem on MovementId = Movement.Id
                      AND MovementItem.isErased = FALSE
     left JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                     AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
     left JOIN MovementItemLinkObject AS MILinkObject_Contract
                                      ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
     left JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                      ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                     AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
     left JOIN MovementItemLinkObject AS MILinkObject_Partner
                                      ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
     left JOIN MovementItemLinkObject AS MILinkObject_Branch
                                      ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                     AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
     LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                 ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
WHERE Movement.DescId = zc_Movement_LossDebt()
group by Movement.Id, Movement.InvNumber, Movement.OperDate
       , COALESCE (MovementItem.ObjectId, 0)
       , COALESCE (MILinkObject_InfoMoney.ObjectId, 0)
       , COALESCE (MILinkObject_Contract.ObjectId, 0)
       , COALESCE (MILinkObject_PaidKind.ObjectId, 0)
       , COALESCE (MILinkObject_Partner.ObjectId, 0)
       , COALESCE (MILinkObject_Branch.ObjectId, 0)
having count(*) >1
order by 3, 2
*/
-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_LossDebt (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- (Киев нал)
-- select * from gpUpdate_Status_LossDebt (inMovementId:= 2943608, inStatusCode:= 1, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
-- select * from gpComplete_Movement_LossDebt (inMovementId:= 2943608, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TVarChar);
