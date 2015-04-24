-- Function: lpInsertUpdate_MI_ProfitLossService_AmountPartner()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProfitLossService_AmountPartner (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProfitLossService_AmountPartner(
    IN inMovementId               Integer   , -- Ключ объекта <Документ>
    IN inAmount                   TFloat    , -- Сумма начислений
    IN inUserId                   Integer     -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate  TDateTime;
  DECLARE vbStartDate TDateTime;
  DECLARE vbEndDate   TDateTime;

  DECLARE vbMovementItemId Integer;
  DECLARE vbContractConditionKindId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbContractId_child Integer;
  DECLARE vbInfoMoneyId_child Integer;
  DECLARE vbPaidKindId_child Integer;
  DECLARE vbInfoMoneyId_all Integer;
  DECLARE vbPaidKindId_all Integer;

  DECLARE vbSumm_Baza TFloat;
  DECLARE vbSumm_Sale TFloat;
  DECLARE vbSumm_Baza_recalc TFloat;
  DECLARE vbAmount_recalc TFloat;
BEGIN

     -- Эти параметры нужны для 
     SELECT Movement.OperDate
          , MovementItem.Id                              AS MovementItemId
          , MovementItem.ObjectId                        AS JuridicalId
          , COALESCE (MILinkObject_ContractConditionKind.ObjectId, 0) AS ContractConditionKindId
          , COALESCE (MILinkObject_ContractChild.ObjectId, 0)         AS ContractId_child
          , ObjectLink_Contract_InfoMoney.ChildObjectId               AS InfoMoneyId_child
          , ObjectLink_Contract_PaidKind.ChildObjectId                AS PaidKindId_child
          , CASE WHEN MILinkObject_InfoMoney.ObjectId <> zc_Enum_InfoMoney_21502() -- Общефирменные + Маркетинг + Бонусы за мясное сырье
                      THEN zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                 ELSE NULL
            END AS InfoMoneyId_all
          , COALESCE (MILinkObject_PaidKind.ObjectId, 0) AS PaidKindId_all
            INTO vbOperDate, vbMovementItemId, vbJuridicalId, vbContractConditionKindId
               , vbContractId_child, vbInfoMoneyId_child, vbPaidKindId_child
               , vbInfoMoneyId_all, vbPaidKindId_all
     FROM MovementItem
          INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                           ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                           ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                           ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                          AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MILinkObject_ContractChild.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                               ON ObjectLink_Contract_PaidKind.ObjectId = MILinkObject_ContractChild.ObjectId
                              AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = FALSE
    ;

     -- Эти параметры нужны для 
     vbStartDate:= DATE_TRUNC ('MONTH', vbOperDate);
     vbEndDate:= DATE_TRUNC ('MONTH', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

     -- таблица - элементы документа
     CREATE TEMP TABLE _tmpMIChild (isVirtual Boolean, MovementId Integer, MovementItemId Integer, OperDate TDateTime, JuridicalId Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer, Summ_Sale TFloat, Summ_Baza TFloat, Summ_Baza_recalc TFloat, Amount_recalc TFloat) ON COMMIT DROP;

     -- 
     DELETE FROM _tmpMIChild;
     -- 
     INSERT INTO _tmpMIChild (isVirtual, MovementId, MovementItemId, OperDate, JuridicalId, UnitId, GoodsId, GoodsKindId, Summ_Sale, Summ_Baza, Summ_Baza_recalc, Amount_recalc)
      WITH 
          tmpContract AS (SELECT COALESCE (View_Contract_ContractKey_find.ContractId, View_Contract_ContractKey.ContractId) AS ContractId
                          FROM Object_Contract_ContractKey_View AS View_Contract_ContractKey
                               LEFT JOIN Object_Contract_ContractKey_View AS View_Contract_ContractKey_find ON View_Contract_ContractKey_find.ContractKeyId = View_Contract_ContractKey.ContractKeyId
                          WHERE View_Contract_ContractKey.ContractId = vbContractId_child
                         )
    , tmpContainer AS (-- данные по всем продажам, связанные с  <Договор "база"> этого юр. лица
                       SELECT Container.Id                   AS ContainerId
                            , ContainerLO_Juridical.ObjectId AS JuridicalId
                       FROM tmpContract
                            INNER JOIN ContainerLinkObject AS ContainerLO_Contract ON ContainerLO_Contract.ObjectId = tmpContract.ContractId
                                                                                  AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                            INNER JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = ContainerLO_Contract.ContainerId
                                                                                   AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                            INNER JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = ContainerLO_Contract.ContainerId
                                                                                   AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                                   AND ContainerLO_InfoMoney.ObjectId = vbInfoMoneyId_child
                            INNER JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = ContainerLO_Contract.ContainerId
                                                                                  AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                                  AND ContainerLO_PaidKind.ObjectId = vbPaidKindId_child
                            INNER JOIN Container ON Container.Id = ContainerLO_Contract.ContainerId
                                                AND Container.ObjectId NOT IN (SELECT AccountId FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                AND Container.DescId = zc_Container_Summ()
                      UNION
                       -- если не установлен <Договор "база"> тогда берем все продажи этого юр. лица
                       SELECT Container.Id                   AS ContainerId
                            , ContainerLO_Juridical.ObjectId AS JuridicalId
                       FROM ContainerLinkObject AS ContainerLO_Contract
                            INNER JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = ContainerLO_Contract.ContainerId
                                                                                   AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                                   AND ContainerLO_Juridical.ObjectId = vbJuridicalId
                            INNER JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = ContainerLO_Contract.ContainerId
                                                                                   AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                                   AND ContainerLO_InfoMoney.ObjectId = vbInfoMoneyId_all
                            INNER JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = ContainerLO_Contract.ContainerId
                                                                                  AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                                  AND ContainerLO_PaidKind.ObjectId = vbPaidKindId_all
                            INNER JOIN Container ON Container.Id = ContainerLO_Contract.ContainerId
                                                AND Container.ObjectId NOT IN (SELECT AccountId FROM Object_Account_View WHERE AccountGroupId = zc_Enum_AccountGroup_110000()) -- Транзит
                                                AND Container.DescId = zc_Container_Summ()
                       WHERE vbContractId_child = 0
                         AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract()
                      )
, tmpContainerDesc AS (SELECT tmpContainer.ContainerId
                            , tmpContainer.JuridicalId
                            , tmpDesc.DescId AS MovementDescId
                       FROM (SELECT zc_Movement_BankAccount() AS DescId, zc_Enum_ContractConditionKind_BonusPercentAccount()    AS ContractConditionKindId -- % бонуса за оплату
                            UNION
                             SELECT zc_Movement_Cash()        AS DescId, zc_Enum_ContractConditionKind_BonusPercentAccount()    AS ContractConditionKindId -- % бонуса за оплату
                            UNION
                             SELECT zc_Movement_SendDebt()    AS DescId, zc_Enum_ContractConditionKind_BonusPercentAccount()    AS ContractConditionKindId -- % бонуса за оплату
                            UNION
                             SELECT zc_Movement_Sale()        AS DescId, zc_Enum_ContractConditionKind_BonusPercentSaleReturn() AS ContractConditionKindId -- % бонуса за отгрузку-возврат
                            UNION
                             SELECT zc_Movement_ReturnIn()    AS DescId, zc_Enum_ContractConditionKind_BonusPercentSaleReturn() AS ContractConditionKindId -- % бонуса за отгрузку-возврат
                            UNION
                             SELECT zc_Movement_Sale()        AS DescId, zc_Enum_ContractConditionKind_BonusPercentSale()       AS ContractConditionKindId -- % бонуса за отгрузку
                            UNION
                             SELECT zc_Movement_Sale()        AS DescId, 0                                                      AS ContractConditionKindId -- распределяется на ВСЮ отгрузку
                            ) AS tmpDesc
                            INNER JOIN tmpContainer ON vbContractConditionKindId = tmpDesc.ContractConditionKindId
                      )
          , tmpBaza AS (SELECT tmpContainerDesc.JuridicalId
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.MovementId
                                    ELSE 0
                               END AS MovementId
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.MovementItemId
                                    ELSE 0
                               END AS MovementItemId
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.OperDate
                                    ELSE vbOperDate
                               END AS OperDate
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.ObjectId_Analyzer
                                    ELSE 0
                               END AS GoodsId
                             , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                         THEN MIContainer.WhereObjectId_Analyzer
                                    ELSE 0
                               END AS UnitId
                             , SUM (CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                              THEN MIContainer.Amount
                                         ELSE 0
                                    END) AS Summ_Sale
                             , SUM (CASE WHEN tmpContainerDesc.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash(), zc_Movement_SendDebt())
                                              THEN -1 * MIContainer.Amount
                                         ELSE MIContainer.Amount
                                    END) AS Summ_Baza
                        FROM tmpContainerDesc
                             JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.ContainerId = tmpContainerDesc.ContainerId
                                                       AND MIContainer.DescId = zc_MIContainer_Summ()
                                                       AND MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate
                                                       AND MIContainer.MovementDescId = tmpContainerDesc.MovementDescId
                                                       -- AND MIContainer.MovementItemId > 0
                        GROUP BY tmpContainerDesc.JuridicalId
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.MovementId
                                      ELSE 0
                                 END
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.MovementItemId
                                      ELSE 0
                                 END
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.OperDate
                                      ELSE vbOperDate
                                 END
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.ObjectId_Analyzer
                                      ELSE 0
                                 END
                               , CASE WHEN tmpContainerDesc.MovementDescId = zc_Movement_Sale()
                                           THEN MIContainer.WhereObjectId_Analyzer
                                      ELSE 0
                                 END
                       )
, tmpContainer_Sale AS (SELECT * FROM tmpContainer WHERE vbContractConditionKindId = zc_Enum_ContractConditionKind_BonusPercentAccount()
                       )
          , tmpSale AS (SELECT tmpContainer_Sale.JuridicalId
                             , MIContainer.MovementId
                             , MIContainer.MovementItemId
                             , MIContainer.OperDate
                             , MIContainer.ObjectId_Analyzer      AS GoodsId
                             , MIContainer.WhereObjectId_Analyzer AS UnitId
                             , SUM (MIContainer.Amount)           AS Summ_Sale
                        FROM tmpContainer_Sale
                             JOIN MovementItemContainer AS MIContainer
                                                        ON MIContainer.ContainerId = tmpContainer_Sale.ContainerId
                                                       AND MIContainer.DescId = zc_MIContainer_Summ()
                                                       AND MIContainer.OperDate BETWEEN vbStartDate AND vbEndDate
                                                       AND MIContainer.MovementDescId = zc_Movement_Sale()
                                                       -- AND MIContainer.MovementItemId > 0
                        GROUP BY tmpContainer_Sale.JuridicalId
                               , MIContainer.MovementId
                               , MIContainer.MovementItemId
                               , MIContainer.OperDate
                               , MIContainer.ObjectId_Analyzer
                               , MIContainer.WhereObjectId_Analyzer
                       )
        -- данные по База для распределения (!!!здесь еще могут быть продажи!!!)
        SELECT FALSE AS isVirtual
             , tmpBaza.MovementId
             , MAX (tmpBaza.MovementItemId) AS MovementItemId
             , tmpBaza.OperDate
             , tmpBaza.JuridicalId
             , tmpBaza.UnitId
             , tmpBaza.GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , SUM (tmpBaza.Summ_Sale)
             , SUM (tmpBaza.Summ_Baza)
             , 0 AS Summ_Baza_recalc
             , 0 AS Amount_recalc
        FROM tmpBaza
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = tmpBaza.MovementItemId
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        GROUP BY tmpBaza.MovementId
               , tmpBaza.OperDate
               , tmpBaza.JuridicalId
               , tmpBaza.UnitId
               , tmpBaza.GoodsId
               , MILinkObject_GoodsKind.ObjectId
       UNION ALL
        -- данные по продажам (!!!если в базе их нет, т.е. BonusPercentAccount!!!)
        SELECT FALSE AS isVirtual
             , tmpSale.MovementId
             , MAX (tmpSale.MovementItemId) AS MovementItemId
             , tmpSale.OperDate
             , tmpSale.JuridicalId
             , tmpSale.UnitId
             , tmpSale.GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , SUM (tmpSale.Summ_Sale)
             , 0 AS Summ_Baza
             , 0 AS Summ_Baza_recalc
             , 0 AS Amount_recalc
        FROM tmpSale
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = tmpSale.MovementItemId
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        GROUP BY tmpSale.MovementId
               , tmpSale.OperDate
               , tmpSale.JuridicalId
               , tmpSale.UnitId
               , tmpSale.GoodsId
               , MILinkObject_GoodsKind.ObjectId
       ;

     -- если нет данных по базе (есть или нет продажи - не важно)
     IF NOT EXISTS (SELECT MovementId FROM _tmpMIChild WHERE Summ_Sale > 0)
     THEN
         -- все пустые значения, кроме даты и юр.лица (т.к. оно в ОЛАПе)
         INSERT INTO _tmpMIChild (isVirtual, MovementId, MovementItemId, OperDate, JuridicalId, UnitId, GoodsId, GoodsKindId, Summ_Sale, Summ_Baza, Summ_Baza_recalc, Amount_recalc)
            SELECT TRUE AS isVirtual, 0 AS MovementId, 0 AS MovementItemId, vbOperDate AS OperDate, vbJuridicalId AS JuridicalId, 0 AS UnitId, 0 AS GoodsId, 0 AS GoodsKindId, 0 AS Summ_Sale, 0 AS Summ_Baza, 0 AS Summ_Baza_recalc, 0 AS Amount_recalc;
     END IF;

     -- опеределяется Итого - База для начисления (или сумма оплат, или сумма продаж, или сумма продажа минус возврат)
     vbSumm_Baza:= COALESCE ((SELECT SUM (Summ_Baza) FROM _tmpMIChild), 0);
     IF vbSumm_Baza < 0 THEN vbSumm_Baza:= 0; END IF;
     -- опеределяется Итого - Продажи
     vbSumm_Sale:= COALESCE ((SELECT SUM (Summ_Sale) FROM _tmpMIChild WHERE _tmpMIChild.Summ_Sale > 0), 0); -- теоретически могут быть продажи с "минусом"


     IF vbSumm_Baza = vbSumm_Sale AND vbSumm_Sale > 0 /*vbContractConditionKindId IN (zc_Enum_ContractConditionKind_BonusPercentSale(), 0)
        AND NOT EXISTS (SELECT Summ_Sale FROM _tmpMIChild WHERE Summ_Sale < 0) -- !!!т.е. нет продаж с "минусом"!!!*/
     THEN
         -- "База для начисления" равна "Продажам", распределять не надо
         UPDATE _tmpMIChild SET Summ_Baza_recalc = _tmpMIChild.Summ_Sale WHERE _tmpMIChild.Summ_Sale = _tmpMIChild.Summ_Baza; -- условие - т.к. они должны быть равны иначе ошибка

         -- распределяется "Сумма начислений" пропорционально "Продажам"
         UPDATE _tmpMIChild SET Amount_recalc = inAmount * _tmpMIChild.Summ_Sale / vbSumm_Sale WHERE _tmpMIChild.Summ_Sale > 0; -- теоретически могут быть продажи с "минусом"

         -- Расчет Итоговых сумм по по элементам
         SELECT SUM (_tmpMIChild.Amount_recalc) INTO vbAmount_recalc FROM _tmpMIChild;
         --
         -- если не равны ДВЕ Итоговые суммы "Сумма начислений"
         IF COALESCE (inAmount, 0) <> COALESCE (vbAmount_recalc, 0)
         THEN
             -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
             UPDATE _tmpMIChild SET Amount_recalc = _tmpMIChild.Amount_recalc - (vbAmount_recalc - inAmount)
             WHERE _tmpMIChild.MovementItemId IN (SELECT _tmpMIChild.MovementItemId FROM _tmpMIChild WHERE MovementItemId > 0 ORDER BY _tmpMIChild.Amount_recalc DESC LIMIT 1
                                                 );
         END IF;

     ELSE
     IF vbSumm_Sale > 0
     THEN
         -- распределяется "База для начисления" пропорционально "Продажам"
         UPDATE _tmpMIChild SET Summ_Baza_recalc = vbSumm_Baza * _tmpMIChild.Summ_Sale / vbSumm_Sale WHERE _tmpMIChild.Summ_Sale > 0; -- теоретически могут быть продажи с "минусом"

         -- распределяется "Сумма начислений" пропорционально "Продажам"
         UPDATE _tmpMIChild SET Amount_recalc = inAmount * _tmpMIChild.Summ_Sale / vbSumm_Sale WHERE _tmpMIChild.Summ_Sale > 0; -- теоретически могут быть продажи с "минусом"

         -- Расчет Итоговых сумм по по элементам
          SELECT SUM (_tmpMIChild.Summ_Baza_recalc), SUM (_tmpMIChild.Amount_recalc) INTO vbSumm_Baza_recalc, vbAmount_recalc FROM _tmpMIChild;
         --
         -- если не равны ДВЕ Итоговые суммы "База для начисления"
         IF COALESCE (vbSumm_Baza, 0) <> COALESCE (vbSumm_Baza_recalc, 0)
         THEN
             -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
             UPDATE _tmpMIChild SET Summ_Baza_recalc = _tmpMIChild.Summ_Baza_recalc - (vbSumm_Baza_recalc - vbSumm_Baza)
             WHERE _tmpMIChild.MovementItemId IN (SELECT _tmpMIChild.MovementItemId FROM _tmpMIChild WHERE MovementItemId > 0 ORDER BY _tmpMIChild.Summ_Baza_recalc DESC LIMIT 1
                                                 );
         END IF;
         -- если не равны ДВЕ Итоговые суммы "Сумма начислений"
         IF COALESCE (inAmount, 0) <> COALESCE (vbAmount_recalc, 0)
         THEN
             -- на разницу корректируем самую большую сумму (теоретически может получиться Значение < 0, но эту ошибку не обрабатываем)
             UPDATE _tmpMIChild SET Amount_recalc = _tmpMIChild.Amount_recalc - (vbAmount_recalc - inAmount)
             WHERE _tmpMIChild.MovementItemId IN (SELECT _tmpMIChild.MovementItemId FROM _tmpMIChild WHERE MovementItemId > 0 ORDER BY _tmpMIChild.Amount_recalc DESC LIMIT 1
                                                 );
         END IF;

     ELSE
         -- записывается в !!!одну!!! строку - "База для начисления" и "Сумма начислений"
         UPDATE _tmpMIChild SET Summ_Baza_recalc = vbSumm_Baza
                              , Amount_recalc = inAmount
         WHERE _tmpMIChild.Summ_Sale > 0 OR isVirtual = TRUE;
     END IF;
     END IF;

     -- !!!Проверка!!!
     IF vbSumm_Baza < 0 OR vbSumm_Baza <> COALESCE ((SELECT SUM (Summ_Baza_recalc) FROM _tmpMIChild), 0)
     THEN  
         RAISE EXCEPTION 'Ошибка распределения для <База>. Real = <%>   Calc = <%>   MovementId = <%>   InvNumber = <%>', vbSumm_Baza, (SELECT SUM (Summ_Baza_recalc) FROM _tmpMIChild), inMovementId, (SELECT InvNumber FROM Movement WHERE Id = inMovementId);
     END IF;
     -- !!!Проверка!!!
     IF inAmount <> COALESCE ((SELECT SUM (Amount_recalc) FROM _tmpMIChild), 0)
     THEN  
         RAISE EXCEPTION 'Ошибка распределения для <Сумма>. Real = <%>   Calc = <%>   MovementId = <%>   InvNumber = <%>', inAmount, (SELECT SUM (Amount_recalc) FROM _tmpMIChild), inMovementId, (SELECT InvNumber FROM Movement WHERE Id = inMovementId);
     END IF;


     -- удаляются предыдущие данные
     PERFORM lpSetErased_MovementItem (MovementItem.Id, inUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.isErased = FALSE
       AND MovementItem.DescId = zc_MI_Child();

     -- формируются данные - Child
     PERFORM lpInsertUpdate_MI_ProfitLossService_Child (ioId               := 0
                                                      , inParentId         := vbMovementItemId
                                                      , inMovementId       := inMovementId
                                                      , inJuridicalId      := vbJuridicalId
                                                      , inJuridicalId_Child:= _tmpMIChild.JuridicalId
                                                      , inPartnerId        := MovementLinkObject_To.ObjectId
                                                      , inBranchId         := COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) -- CASE WHEN vbContractId_child <> 0 THEN COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) END
                                                      , inGoodsId          := _tmpMIChild.GoodsId
                                                      , inGoodsKindId      := _tmpMIChild.GoodsKindId
                                                      , inAmount           := _tmpMIChild.Amount_recalc
                                                      , inAmountPartner    := _tmpMIChild.Summ_Sale
                                                      , inSumm             := _tmpMIChild.Summ_Baza_recalc
                                                      , inMovementId_child := _tmpMIChild.MovementId
                                                      , inOperDate         := _tmpMIChild.OperDate
                                                      , inUserId           := inUserId
                                                       )
     FROM _tmpMIChild
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = _tmpMIChild.MovementId
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = _tmpMIChild.UnitId
                              AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
     WHERE _tmpMIChild.Summ_Baza_recalc <> 0 OR _tmpMIChild.Summ_Sale <> 0 OR _tmpMIChild.Amount_recalc <> 0;


     -- обновляются данные - Master
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), vbMovementItemId, vbSumm_Sale);
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), vbMovementItemId, vbSumm_Baza);
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), vbMovementItemId, (SELECT _tmpMIChild.JuridicalId FROM _tmpMIChild WHERE _tmpMIChild.Summ_Baza_recalc <> 0 OR _tmpMIChild.Amount_recalc <> 0 GROUP BY _tmpMIChild.JuridicalId));


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.02.15                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProfitLossService_AmountPartner (inMovementId := 827585 , inAmount := 8563.5816, inUserId:= zfCalc_UserAdmin() :: Integer); -- Ритейл-К ТОВ
