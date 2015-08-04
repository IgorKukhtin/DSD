 -- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Inventory (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Inventory(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbInventoryDate TDateTime;
BEGIN

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
  --   DELETE FROM _tmpMIReport_insert;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem;

   vbAccountId := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- Cклад 
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId);

    SELECT MovementLinkObject.ObjectId, ObjectLink_Unit_Juridical.ChildObjectId INTO vbUnitId, vbJuridicalId
    FROM MovementLinkObject
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON MovementLinkObject.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
    WHERE MovementLinkObject.MovementId = inMovementId 
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();
      
    SELECT Movement.OperDate INTO vbInventoryDate
    FROM Movement
    WHERE Movement.Id = inMovementId;

   -- Проводки по суммам документа. Деньги в кассу
   
/*   INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)   
   SELECT Movement_Income_View.FromId
        , Movement_Income_View.TotalSumm
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_Income_View.JuridicalId
        , Movement_Income_View.OperDate
     FROM Movement_Income_View
    WHERE Movement_Income_View.Id =  inMovementId;
    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Summ()
              , zc_Movement_Income()  
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
              , - OperSumm
              , OperDate
           FROM _tmpItem;
                 
           SELECT SUM(OperSumm) INTO vbOperSumm_Partner
             FROM _tmpItem;

    -- Сумма платежа
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_SummIncomeMovementPayment()
              , zc_Movement_Income()  
              , inMovementId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                          inParentId        := NULL               , -- Главный Container
                          inObjectId := lpInsertFind_Object_PartionMovement(inMovementId), -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL) -- <элемент с/с> - необычная аналитика счета) 
              , null
              , OperSumm
              , OperDate
           FROM _tmpItem;

  */               
 /*    CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, OperSumm_Currency TFloat, OperSumm_Diff TFloat
                               , MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, ContainerId_Diff Integer, ProfitLossId_Diff Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Balance Integer, BusinessId_ProfitLoss Integer, JuridicalId_Basis Integer
                               , UnitId Integer, PositionId Integer, BranchId_Balance Integer, BranchId_ProfitLoss Integer, ServiceDateId Integer, ContractId Integer, PaidKindId Integer
                               , AnalyzerId Integer
                               , CurrencyId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
*/
/*
   DELETE FROM _tmpItem;
   INSERT INTO _tmpItem(MovementDescId, MovementItemId, ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate, UnitId)   
   SELECT
          zc_Movement_Income()
        , MovementItem_Income_View.Id
        , MovementItem_Income_View.GoodsId
        , MovementItem_Income_View.Amount
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- Cклад 
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_Income_View.JuridicalId
        , Movement_Income_View.OperDate
        , Movement_Income_View.ToId
     FROM MovementItem_Income_View, Movement_Income_View
    WHERE MovementItem_Income_View.MovementId = Movement_Income_View.Id AND Movement_Income_View.Id =  inMovementId;
 */

    -- А сюда товары
    --Добавить в переучет строки, которые есть на остатке, но нет в переучете
    PERFORM lpInsertUpdate_MovementItem_Inventory(ioId := 0, inMovementId := inMovementId, inGoodsId := Saldo.ObjectId, inAmount := 0, inPrice := 0, inSumm := 0, inUserId := inUserId)
    FROM (
        SELECT 
            T0.ObjectId
           ,SUM(T0.Amount) as Amount
        FROM(
            SELECT 
                Container.Id 
               ,Container.ObjectId --Товар
               ,Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0) as Amount  --Тек. остаток - Движение после даты переучета
            FROM 
                Container
                LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                     AND MovementItemContainer.Operdate > vbInventoryDate
                           JOIN containerlinkobject AS CLI_Unit ON CLI_Unit.containerid = Container.Id
                                                               AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                               AND CLI_Unit.ObjectId = vbUnitId                                   
            WHERE Container.DescID = zc_Container_Count()
            GROUP BY 
                Container.Id 
               ,Container.ObjectId
            ) as T0
        GROUP By T0.ObjectId
        ) as Saldo
        LEFT OUTER JOIN MovementItem AS MovementItem_Inventory
                                     ON Saldo.ObjectId = MovementItem_Inventory.ObjectId
                                    AND MovementItem_Inventory.MovementId = inMovementId
                                    AND MovementItem_Inventory.DescId = zc_MI_Master()
    WHERE
        Saldo.Amount > 0
        AND
        MovementItem_Inventory.Id is null;
    
WITH DIFFSALDO AS ( SELECT 
                        MovementItem.Id                                            as MovementItemId 
                       ,MovementItem.ObjectId                                      as ObjectId  
                       ,COALESCE(MovementItem.Amount,0) - COALESCE(Saldo.Amount,0) as Amount -- -недостача, +Излишек
                    FROM MovementItem
                        LEFT OUTER JOIN (SELECT T0.ObjectId, SUM(T0.Amount) as Amount
                                        FROM(SELECT Container.Id 
                                                   ,Container.ObjectId --Товар
                                                   ,Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0) as Amount  --Тек. остаток - Движение после даты переучета
                                             FROM Container
                                                LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                                     AND MovementItemContainer.Operdate > vbInventoryDate
                                                JOIN containerlinkobject AS CLI_Unit ON CLI_Unit.containerid = Container.Id
                                                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                                                    AND CLI_Unit.ObjectId = vbUnitId                                   
                                             WHERE Container.DescID = zc_Container_Count()
                                             GROUP BY Container.Id 
                                                     ,Container.ObjectId) as T0
                                         GROUP By ObjectId) as Saldo
                                                            ON MovementItem.ObjectId = Saldo.ObjectId
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.IsErased = FALSE
                      AND COALESCE(MovementItem.Amount,0) - COALESCE(Saldo.Amount,0) <> 0),

  DD AS (SELECT 
            DIFFSALDO.MovementItemId 
          , DIFFSALDO.Amount 
          , Container.Amount AS ContainerAmount 
          , OperDate 
          , Container.Id
          , SUM(Container.Amount) OVER (PARTITION BY Container.objectid ORDER BY OPERDATE) 
        FROM Container 
            JOIN DIFFSALDO ON DIFFSALDO.objectid = Container.objectid 
            JOIN containerlinkobject AS CLI_MI 
                                     ON CLI_MI.containerid = Container.Id
                                    AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
            JOIN containerlinkobject AS CLI_Unit 
			                         ON CLI_Unit.containerid = Container.Id
                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                    AND CLI_Unit.ObjectId = vbUnitId
            JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
            JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
            JOIN Movement ON Movement.Id = movementitem.movementid
        WHERE Container.Amount > 0 AND DIFFSALDO.Amount < 0), 
  
  tmpItem AS (SELECT 
                Id
			  , MovementItemId
			  , OperDate
			  , CASE 
                  WHEN -Amount - SUM > 0 THEN ContainerAmount 
                  ELSE -Amount - SUM + ContainerAmount
                END AS Amount
              FROM DD
              WHERE (Amount < 0 AND  -Amount - (SUM - ContainerAmount) >= 0)
              UNION ALL
              SELECT 
                lpInsertFind_Container(
                          inContainerDescId   := zc_Container_Count(), -- DescId Остатка
                          inParentId          := NULL               , -- Главный Container
                          inObjectId          := DIFFSALDO.ObjectId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := vbJuridicalId, -- Главное юридическое лицо
                          inBusinessId        := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId      := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := vbUnitId,
                          inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                          inObjectId_2        := lpInsertFind_Object_PartionMovementItem(DIFFSALDO.MovementItemId)) as Id, 
                DIFFSALDO.MovementItemId  as MovementItemId, 
                vbInventoryDate           as OperDate, 
                -DIFFSALDO.Amount
              FROM DIFFSALDO
              WHERE Amount > 0)


    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Count()
              , zc_Movement_Inventory()  
              , inMovementId
              , tmpItem.MovementItemId
              , tmpItem.Id
              , vbAccountId
              , -Amount
              , OperDate
           FROM tmpItem;
    
--     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer
  --                                           , AccountId Integer, AnalyzerId Integer, ObjectId_Analyzer Integer, WhereObjectId_Analyzer Integer, ContainerId_Analyzer Integer
    --                                         , Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

    -- ну и наконец-то суммы
 /*   INSERT INTO _tmpMIContainer_insert(AnalyzerId, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, AccountId, Amount, OperDate)
         SELECT 
                0
              , zc_Container_Summ()
              , zc_Movement_Income()  
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId Остатка
                          inParentId        := _tmpMIContainer_insert.ContainerId , -- Главный Container
                          inObjectId := _tmpItem.AccountId, -- Объект (Счет или Товар или ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                          inBusinessId := NULL, -- Бизнесы
                          inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                          inObjectCostId       := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Goods(), -- DescId для 1-ой Аналитики
                          inObjectId_1        := _tmpItem.ObjectId,
                          inDescId_2          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                          inObjectId_2        := _tmpItem.UnitId) 
              , nULL
              , _tmpItem.AccountId
              ,  CASE WHEN Movement_Income_View.PriceWithVAT THEN MovementItem_Income_View.AmountSumm
                      ELSE MovementItem_Income_View.AmountSumm * (1 + Movement_Income_View.NDS/100)
                 END::NUMERIC(16, 2)     
              , _tmpItem.OperDate
           FROM _tmpItem 
                JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.MovementItemId = _tmpItem.MovementItemId
                LEFT JOIN MovementItem_Income_View ON MovementItem_Income_View.Id = _tmpItem.MovementItemId
                LEFT JOIN Movement_Income_View ON Movement_Income_View.Id = MovementItem_Income_View.MovementId;

     
     SELECT SUM(Amount) INTO vbOperSumm_Partner_byItem FROM _tmpMIContainer_insert WHERE AnalyzerId = 0;
 
     IF (vbOperSumm_Partner <> vbOperSumm_Partner_byItem) THEN
        UPDATE _tmpMIContainer_insert SET Amount = Amount - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0 
                      AND Amount IN (SELECT MAX (Amount) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0)
                                 );
      END IF;    
   */
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Inventory()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 03.08.15                                                                  *Добавить в переучет строки, которые есть на остатке, но нет в переучете
 11.02.14                        * 
 05.02.14                        * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
--    IN inMovementId        Integer  , -- ключ Документа
--    IN inUserId            Integer    -- Пользователь
-- SELECT * FROM lpComplete_Movement_Inventory (inMovementId:= 12671, inUserId:= zfCalc_UserAdmin()::Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM MovementItemContainer WHERE MovementId = 12671