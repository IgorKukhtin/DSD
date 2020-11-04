 -- Function: lpComplete_Movement_ChangeIncomePayment (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_ChangeIncomePayment (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ChangeIncomePayment(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
BEGIN

    -- !!!обязательно!!! очистили таблицу проводок
    DELETE FROM _tmpMIContainer_insert;
    -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
    DELETE FROM _tmpItem;

    -- Проводки по суммам документа
    INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate, AnalyzerId)   
    SELECT 
        Movement_ChangeIncomePayment_View.FromId
      , Movement_ChangeIncomePayment_View.TotalSumm
      , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                   , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                   , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                   , inInfoMoneyId            := NULL
                                   , inUserId                 := inUserId)
      , Movement_ChangeIncomePayment_View.JuridicalId
      , Movement_ChangeIncomePayment_View.OperDate
      , Movement_ChangeIncomePayment_View.ChangeIncomePaymentKindId
     FROM Movement_ChangeIncomePayment_View
    WHERE Movement_ChangeIncomePayment_View.Id =  inMovementId;
    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_Summ()
      , zc_Movement_ChangeIncomePayment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId := zc_Container_Summ(), -- DescId Остатка
                               inParentId        := NULL               , -- Главный Container
                               inObjectId := _tmpItem.AccountId, -- Объект (Счет или Товар или ...)
                               inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                               inBusinessId := NULL, -- Бизнесы
                               inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                               inObjectCostId       := NULL, -- <элемент с/с> - необычная аналитика счета 
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId для 1-ой Аналитики
                               inObjectId_1        := _tmpItem.ObjectId) 
      , AccountId
      , OperSumm
      , OperDate
    FROM _tmpItem
    WHERE COALESCE(AnalyzerId, 0) <> zc_Enum_ChangeIncomePaymentKind_PartialSale();
                 
    -- Сумма Бонуса / Возврата / прочего / Оплаты частями
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_ChangeIncomePayment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                               inParentId          := NULL               , -- Главный Container
                               inObjectId          := _tmpItem.AnalyzerId, -- Объект (Счет или Товар или ...)
                               inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                               inBusinessId        := NULL, -- Бизнесы
                               inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                               inObjectCostId      := NULL, -- <элемент с/с> - необычная аналитика счета
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId для 1-ой Аналитики
                               inObjectId_1        := _tmpItem.ObjectId,
                               inDescId_2          := zc_ContainerLinkObject_JuridicalBasis(), -- DescId для 2-ой Аналитики
                               inObjectId_2        := _tmpItem.JuridicalId_Basis) 
      , null
      , OperSumm
      , OperDate
    FROM _tmpItem;

    PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ChangeIncomePayment()
                               , inUserId     := inUserId
                                 );
                                 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 21.12.15                                                                      * 
*/
