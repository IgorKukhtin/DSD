DROP FUNCTION IF EXISTS lpComplete_Movement_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Send(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitFromId Integer;
   DECLARE vbUnitToId Integer;
   DECLARE vbJuridicalFromId Integer;
   DECLARE vbJuridicalToId Integer;
   DECLARE vbSendDate TDateTime;
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

    SELECT 
        MovementLinkObject_From.ObjectId
       ,ObjectLink_Unit_Juridical_From.ChildObjectId 
       ,MovementLinkObject_To.ObjectId
       ,ObjectLink_Unit_Juridical_To.ChildObjectId
       ,Movement.OperDate       
    INTO 
        vbUnitFromId
       ,vbJuridicalFromId
       ,vbUnitToId
       ,vbJuridicalToId
       ,vbSendDate
    FROM 
        Movement
        Inner Join MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From() 
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical_From
                                   ON MovementLinkObject_From.ObjectId = ObjectLink_Unit_Juridical_From.ObjectId
                                  AND ObjectLink_Unit_Juridical_From.DescId = zc_ObjectLink_Unit_Juridical()
        Inner Join MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To() 
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical_To
                                   ON MovementLinkObject_To.ObjectId = ObjectLink_Unit_Juridical_To.ObjectId
                                  AND ObjectLink_Unit_Juridical_To.DescId = zc_ObjectLink_Unit_Juridical()
    WHERE Movement.Id = inMovementId;
      

    -- А сюда товары
    WITH 
        Send AS( -- строки документа перемещения
                    SELECT 
                        MovementItem.Id       as MovementItemId 
                       ,MovementItem.ObjectId as ObjectId
                       ,MovementItem.Amount   as Amount
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.IsErased = FALSE
                      AND COALESCE(MovementItem.Amount,0) > 0
                ),
        DD AS  (  -- строки документа перемещения размазанные по текущему остатку(Контейнерам) на подразделении "From"
                    SELECT 
                        Send.MovementItemId 
                      , Send.Amount 
                      , Container.Amount AS ContainerAmount
                      , Container.ObjectId 
                      , OperDate 
                      , Container.Id
                      , SUM(Container.Amount) OVER (PARTITION BY Container.objectid ORDER BY OPERDATE,Container.Id) 
                      , movementitem.Id AS PartionMovementItemId
                    FROM Container 
                        JOIN Send ON Send.objectid = Container.objectid 
                        JOIN containerlinkobject AS CLI_MI 
                                                 ON CLI_MI.containerid = Container.Id
                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                        JOIN containerlinkobject AS CLI_Unit 
			                                     ON CLI_Unit.containerid = Container.Id
                                                AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                AND CLI_Unit.ObjectId = vbUnitFromId
                        JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                        JOIN movementitem ON movementitem.Id = Object_PartionMovementItem.ObjectCode
                        JOIN Movement ON Movement.Id = movementitem.movementid
                    WHERE Container.Amount > 0
                ), 
  
        tmpItem AS ( -- контейнеры и кол-во(Сумма), которое с них будет списано (с подразделения "From")
                        SELECT 
                            DD.Id             AS Container_AmountId
                          , Container_Summ.Id AS Container_SummId 
                          , DD.PartionMovementItemId
			              , DD.MovementItemId
                          , DD.ObjectId
			              , DD.OperDate
			              , CASE 
                              WHEN DD.Amount - DD.SUM > 0 THEN DD.ContainerAmount 
                              ELSE DD.Amount - DD.SUM + DD.ContainerAmount
                            END AS Amount
                          , CASE 
                              WHEN DD.Amount - DD.SUM > 0 THEN Container_Summ.Amount
                              ELSE (DD.Amount - DD.SUM + DD.ContainerAmount) * (Container_Summ.Amount / DD.ContainerAmount)
                            END AS Summ
                        FROM DD
                            LEFT OUTER JOIN Container AS Container_Summ
                                                      ON Container_Summ.ParentId = DD.Id
                                                     AND Container_Summ.DescId = zc_Container_Summ() 
                        WHERE (DD.Amount - (DD.SUM - DD.ContainerAmount) > 0)
                    ),
        tmpAll AS  ( --Контейнеры и количество которое будет списано с подразделения "From"
                        SELECT
                            Container_AmountId
                           ,MovementItemId
                           ,ObjectId
                           ,vbSendDate AS OperDate
                           ,Amount
                           ,True       AS IsActive
                        FROM tmpItem
                        UNION ALL --    + Контейнеры и количество которое будет приходовано на подразделение "To"
                        SELECT 
                            lpInsertFind_Container(
                                                    inContainerDescId   := zc_Container_Count(), -- DescId Остатка
                                                    inParentId          := NULL  , -- Главный Container
                                                    inObjectId          := tmpItem.ObjectId, -- Объект (Счет или Товар или ...)
                                                    inJuridicalId_basis := vbJuridicalToId, -- Главное юридическое лицо
                                                    inBusinessId        := NULL, -- Бизнесы
                                                    inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                                                    inObjectCostId      := NULL,
                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                                                    inObjectId_1        := vbUnitToId,
                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem(tmpItem.PartionMovementItemId)) as Id
                           ,tmpItem.MovementItemId  AS MovementItemId 
                           ,tmpItem.ObjectId        AS ObjectId 
                           ,vbSendDate              AS OperDate
                           ,-TmpItem.Amount
                           ,False                    AS IsActive
                        FROM tmpItem
                    ),
        tmpSumm AS (  --Контейнеры и Сумма которое будет списано с подразделения "From"
                        SELECT
                            Container_SummId
                           ,MovementItemId
                           ,ObjectId
                           ,vbSendDate AS OperDate
                           ,Summ
                           ,True       AS isActive
                        FROM tmpItem
                        UNION ALL  --    + Контейнеры и сумма которая будет приходовано на подразделение "To"
                        SELECT 
                            lpInsertFind_Container(
                                                    inContainerDescId   := zc_Container_Summ(), -- DescId Остатка
                                                    inParentId          := lpInsertFind_Container(
                                                                                                    inContainerDescId   := zc_Container_Count(), -- DescId Остатка
                                                                                                    inParentId          := NULL    , -- Главный Container
                                                                                                    inObjectId          := tmpItem.ObjectId, -- Объект (Счет или Товар или ...)
                                                                                                    inJuridicalId_basis := vbJuridicalToId, -- Главное юридическое лицо
                                                                                                    inBusinessId        := NULL, -- Бизнесы
                                                                                                    inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                                                                                                    inObjectCostId      := NULL,
                                                                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                                                                                                    inObjectId_1        := vbUnitToId,
                                                                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                                                                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem(tmpItem.PartionMovementItemId))               , -- Главный Container
                                                    inObjectId          := tmpItem.ObjectId, -- Объект (Счет или Товар или ...)
                                                    inJuridicalId_basis := vbJuridicalToId, -- Главное юридическое лицо
                                                    inBusinessId        := NULL, -- Бизнесы
                                                    inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                                                    inObjectCostId      := NULL,
                                                    inDescId_1          := zc_ContainerLinkObject_Unit(), -- DescId для 1-ой Аналитики
                                                    inObjectId_1        := vbUnitToId,
                                                    inDescId_2          := zc_ContainerLinkObject_PartionMovementItem(), -- DescId для 2-ой Аналитики
                                                    inObjectId_2        := lpInsertFind_Object_PartionMovementItem(tmpItem.MovementItemId)) as Id
                           ,tmpItem.MovementItemId  AS MovementItemId 
                           ,tmpItem.ObjectId        AS ObjectId 
                           ,vbSendDate              AS OperDate
                           ,-TmpItem.Summ
                           ,False                   AS isActive
                        FROM tmpItem
                    )

    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate,IsActive)
    SELECT --контейнеры по количество
        zc_Container_Count()
      , zc_Movement_Send()  
      , inMovementId
      , tmpAll.MovementItemId
      , tmpAll.Container_AmountId
      , vbAccountId
      , -Amount
      , OperDate
      ,IsActive
    FROM tmpAll
    UNION ALL
    SELECT --Контейнеры по сумме
        zc_Container_Summ()
      , zc_Movement_Send()  
      , inMovementId
      , tmpSumm.MovementItemId
      , tmpSumm.Container_SummId
      , vbAccountId
      , -Summ
      , OperDate
      ,IsActive
    FROM tmpSumm;
    
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Send()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 29.07.15                                                                     * 
*/
