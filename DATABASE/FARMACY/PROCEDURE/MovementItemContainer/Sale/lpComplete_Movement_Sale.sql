DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbSaleDate TDateTime;
BEGIN

    -- создаются временные таблицы - для формирование данных для проводок
    PERFORM lpComplete_Movement_Finance_CreateTemp();

    -- !!!обязательно!!! очистили таблицу проводок
    DELETE FROM _tmpMIContainer_insert;
    
    -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
    DELETE FROM _tmpItem;

    vbAccountId := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                              , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- Cклад 
                                              , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                              , inInfoMoneyId            := NULL
                                              , inUserId                 := inUserId);

    SELECT 
        Movement_Sale.UnitId
       ,ObjectLink_Unit_Juridical.ChildObjectId 
       ,Movement_Sale.OperDate       
    INTO 
        vbUnitId
       ,vbJuridicalId
       ,vbSaleDate
    FROM 
        Movement_Sale_View AS Movement_Sale
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON Movement_Sale.UnitId = ObjectLink_Unit_Juridical.ObjectId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
    WHERE 
        Movement_Sale.Id = inMovementId;

    -- А сюда товары
    WITH 
        Sale AS( -- строки документа продажи
                    SELECT 
                        MovementItem.Id       as MovementItemId 
                       ,MovementItem.ObjectId as ObjectId
                       ,MovementItem.Amount   as Amount
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.IsErased = FALSE
                      AND COALESCE(MovementItem.Amount,0) > 0
                ),
        DD AS  (  -- строки документа продажи размазанные по текущему остатку(Контейнерам) на подразделении
                    SELECT 
                        Sale.MovementItemId 
                      , Sale.Amount 
                      , Container.Amount AS ContainerAmount
                      , Container.ObjectId 
                      , Container.Id
                      , SUM(Container.Amount) OVER (PARTITION BY Container.objectid ORDER BY Movement.OperDate,Container.Id) 
                    FROM Container 
                        JOIN Sale ON Sale.objectid = Container.objectid 
                        JOIN containerlinkobject AS CLI_MI 
                                                 ON CLI_MI.containerid = Container.Id
                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                        JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                        JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
                        JOIN Movement ON Movement.Id = movementitem.movementid
                    WHERE 
                        Container.Amount > 0 
                        AND
                        Container.WhereObjectId = vbUnitId
                ), 
  
        tmpItem AS ( -- контейнеры и кол-во(Сумма), которое с них будет списано (с подразделения)
                        SELECT 
                            DD.Id             AS Container_AmountId
                          , Container_Summ.Id AS Container_SummId  
			              , DD.MovementItemId
                          , DD.ObjectId
			              , CASE 
                              WHEN DD.Amount - DD.SUM > 0 THEN DD.ContainerAmount 
                              ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                            END AS Amount
                          , CASE 
                              WHEN DD.Amount - DD.SUM > 0 THEN Container_Summ.Amount
                              ELSE (DD.Amount - DD.SUM + DD.ContainerAmount) * (Container_Summ.Amount / DD.ContainerAmount)
                            END AS Summ
                          , TRUE AS IsActive
                        FROM DD
                            LEFT OUTER JOIN Container AS Container_Summ
                                                      ON Container_Summ.ParentId = DD.Id
                                                     AND Container_Summ.DescId = zc_Container_Summ() 
                        WHERE (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
                    )
    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate,IsActive)
    SELECT --контейнеры по количество
        zc_Container_Count()
      , zc_Movement_Sale()  
      , inMovementId
      , tmpItem.MovementItemId
      , tmpItem.Container_AmountId
      , vbAccountId
      , -tmpItem.Amount
      , vbSaleDate
      , tmpItem.IsActive
    FROM tmpItem
    UNION ALL
    SELECT --Контейнеры по сумме
        zc_Container_Summ()
      , zc_Movement_Sale()  
      , inMovementId
      , tmpItem.MovementItemId
      , tmpItem.Container_SummId
      , vbAccountId
      , -tmpItem.Summ
      , vbSaleDate
      , tmpItem.IsActive
    FROM tmpItem;
    
    PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Sale()
                               , inUserId     := inUserId
                                );

    --пересчитали суммы по документу (для суммы закупки, которая считается после проведения документа)
    PERFORM lpInsertUpdate_MovementFloat_TotalSummSale (inMovementId);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 13.10.15                                                                     * 
*/