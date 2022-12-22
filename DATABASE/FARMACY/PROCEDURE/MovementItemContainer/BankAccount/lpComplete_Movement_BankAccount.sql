-- Function: lpComplete_Movement_BankAccount (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_BankAccount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_BankAccount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS void
--  RETURNS TABLE (OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, ContainerId Integer, AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer, ProfitLossGroupId Integer, ProfitLossDirectionId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, BusinessId Integer, JuridicalId_Basis Integer, UnitId Integer, ContractId Integer, PaidKindId Integer, IsActive Boolean)
AS
$BODY$
BEGIN

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMovement_BankAccount_View'))
     THEN
       DROP TABLE tmpMovement_BankAccount_View;
     END IF;
	
     CREATE TEMP TABLE tmpMovement_BankAccount_View ON COMMIT DROP AS 
	   (SELECT       
             Movement.Id
           , Movement.InvNumber
           , Movement.ParentId
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           , MovementItem.Amount
           , MovementItem.ObjectId             AS BankAccountId
           , bankaccount_juridical.childobjectid  AS JuridicalId_Basis
           , MILinkObject_MoneyPlace.ObjectId  AS MoneyPlaceId
           , MovementLinkMovement_Child.MovementChildId AS IncomeId

       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN objectlink AS bankaccount_juridical 
		                         ON bankaccount_juridical.objectid = MovementItem.ObjectId
		                        AND bankaccount_juridical.descid = zc_objectlink_bankaccount_juridical()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                         ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                        AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                           ON MovementLinkMovement_Child.MovementId = Movement.Id
                                          AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()

           WHERE Movement.DescId = zc_Movement_BankAccount()
             AND Movement.Id = inMovementId);
		
	ANALYSE tmpMovement_BankAccount_View;
		
   -- Проводки по суммам документа
   
   INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)   
   SELECT Movement_BankAccount_View.MoneyPlaceId
        , - Movement_BankAccount_View.Amount
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     --, inInsert                 := TRUE
                                     , inUserId                 := inUserId)
        , Movement_BankAccount_View.JuridicalId_Basis
        , Movement_BankAccount_View.OperDate
     FROM tmpMovement_BankAccount_View AS Movement_BankAccount_View;
	
	ANALYSE _tmpItem;
	
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Summ()
              , zc_Movement_BankAccount()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId Остатка
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
           FROM _tmpItem;

	ANALYSE _tmpMIContainer_insert;

   DELETE FROM _tmpItem;          
   
   INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)   
   SELECT Movement_BankAccount_View.BankAccountId
        , Movement_BankAccount_View.Amount
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_40000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_40300()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     --, inInsert                 := TRUE
                                     , inUserId                 := inUserId)
        , Movement_BankAccount_View.JuridicalId_Basis
        , Movement_BankAccount_View.OperDate
     FROM tmpMovement_BankAccount_View AS Movement_BankAccount_View;

	ANALYSE _tmpItem;

    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Summ()
              , zc_Movement_BankAccount()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId Остатка
                          inParentId        := NULL               , -- Главный Container
                          inObjectId := _tmpItem.AccountId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL, -- <элемент с/с> - необычная аналитика счета 
                          inDescId_1          := zc_ContainerLinkObject_BankAccount(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.ObjectId) 
              , AccountId
              , OperSumm
              , OperDate
           FROM _tmpItem;

    ANALYSE _tmpMIContainer_insert;

    -- Сумма платежа
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT zc_Container_SummIncomeMovementPayment()
              , zc_Movement_BankAccount()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                          inParentId          := NULL               , -- Главный Container
                          inObjectId          := lpInsertFind_Object_PartionMovement (Movement_BankAccount_View.IncomeId), -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := CASE WHEN _tmpItem.OperDate < '16.02.2016' THEN COALESCE (MovementLinkObject_Juridical.ObjectId, _tmpItem.JuridicalId_Basis) ELSE  _tmpItem.JuridicalId_Basis END, -- Главное юридическое лицо
                          inBusinessId        := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId      := NULL) -- <элемент с/с> - необычная аналитика счета) 
              , NULL
              , OperSumm
              , _tmpItem.OperDate
         FROM tmpMovement_BankAccount_View AS Movement_BankAccount_View
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                           ON MovementLinkObject_Juridical.MovementId = Movement_BankAccount_View.IncomeId
                                          AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                         -- AND _tmpItem.OperDate < '16.02.2016' -- !!!только для загрузки из Sybase!!!
              LEFT JOIN _tmpItem ON 1 = 1
         
		 ;

     ANALYSE _tmpMIContainer_insert;

     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_BankAccount()
                                , inUserId     := inUserId
                                 );
                              
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.     Воробкало А.А.
 08.01.18         *
 08.12.15                                                            *
 13.02.15                         * 
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_BankAccount (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())

