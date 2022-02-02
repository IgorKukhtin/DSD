 -- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Loss (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Loss(
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
   DECLARE vbLossDate TDateTime;
   DECLARE vbOperDate TDateTime;
   DECLARE vbArticleLossId Integer;
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

    SELECT MovementLinkObject.ObjectId, ObjectLink_Unit_Juridical.ChildObjectId, Movement.OperDate, MovementLinkObject_ArticleLoss.ObjectId 
    INTO vbUnitId, vbJuridicalId, vbOperDate, vbArticleLossId
    FROM MovementLinkObject
        LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                   ON MovementLinkObject.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        JOIN Movement ON Movement.Id = MovementLinkObject.MovementId                          
        LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                     ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                    AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
    WHERE MovementLinkObject.MovementId = inMovementId 
      AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit();
      
    SELECT Movement.OperDate INTO vbLossDate
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
WITH LOSS AS ( SELECT 
                MovementItem.Id                    as MovementItemId 
               ,MovementItem.ObjectId              as ObjectId
               ,MovementItem.Amount                as Amount
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.IsErased = FALSE
                AND COALESCE(MovementItem.Amount,0) > 0
             ),
    REMAINS AS ( --остатки на дату документа
                        SELECT 
                            Container.Id 
                           ,Container.ObjectId --Товар
                           ,(Container.Amount - COALESCE(SUM(MovementItemContainer.amount),0.0))::TFloat as Amount  --Тек. остаток - Движение после даты переучета
                        FROM Container
                            LEFT OUTER JOIN MovementItemContainer ON Container.Id = MovementItemContainer.ContainerId
                                                                 AND 
                                                                 (
                                                                    date_trunc('day', MovementItemContainer.Operdate) > vbOperDate
                                                                 )
                            JOIN ContainerLinkObject AS CLI_Unit 
                                                     ON CLI_Unit.containerid = Container.Id
                                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                                    AND CLI_Unit.ObjectId = vbUnitId                                   
                        WHERE 
                            Container.DescID = zc_Container_Count()
                        GROUP BY 
                            Container.Id 
                           ,Container.ObjectId
                    ),
    PartionDate AS (SELECT REMAINS.Id
                         , Min(ObjectDate_ExpirationDate.ValueData)               AS ExpirationDate
                    FROM REMAINS
                
                         INNER JOIN Container ON Container.ParentId = REMAINS.Id
                                             AND Container.DescID = zc_Container_CountPartionDate()
                                             AND Container.Amount > 0 
                                             
                         INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                       AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                      
                         INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                               ON ObjectDate_ExpirationDate.ObjectId =  ContainerLinkObject.ObjectId 
                                              AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                    GROUP BY REMAINS.Id
               ),
  DD AS (SELECT 
            LOSS.MovementItemId 
          , LOSS.Amount 
          , REMAINS.Amount AS ContainerAmount 
          , vbLossDate AS OperDate 
          , REMAINS.Id
          , SUM(REMAINS.Amount) OVER (PARTITION BY REMAINS.objectid ORDER BY COALESCE(PartionDate.ExpirationDate, MIDate_ExpirationDate.ValueData), REMAINS.Id)
        FROM REMAINS 
            JOIN LOSS ON LOSS.objectid = REMAINS.objectid 
            LEFT JOIN PartionDate ON PartionDate.ID = REMAINS.ID
            JOIN containerlinkobject AS CLI_MI 
                                     ON CLI_MI.containerid = REMAINS.Id
                                    AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
            JOIN containerlinkobject AS CLI_Unit 
			                         ON CLI_Unit.containerid = REMAINS.Id
                                    AND CLI_Unit.descid = zc_ContainerLinkObject_Unit()
                                    AND CLI_Unit.ObjectId = vbUnitId
            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
            -- элемент прихода
            LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
            -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
            -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
            LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                 -- AND 1=0
            LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                             ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
        WHERE REMAINS.Amount > 0), 
  
  tmpItem AS (SELECT 
                Id
			  , MovementItemId
			  , OperDate
			  , CASE 
                  WHEN Amount - SUM > 0 THEN ContainerAmount 
                  ELSE Amount - SUM + ContainerAmount
                END AS Amount
              FROM DD
              WHERE (Amount - (SUM - ContainerAmount) > 0)
              )


    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
         SELECT 
                zc_Container_Count()
              , zc_Movement_Loss()  
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
   
     -- если это обычное списание, но все равно надо списать сроковые партии
     IF EXISTS (SELECT 1 FROM Container WHERE Container.DescId   = zc_Container_CountPartionDate()
                                          AND Container.Amount   > 0
                                          AND Container.ParentId IN (SELECT _tmpMIContainer_insert.ContainerId FROM _tmpMIContainer_insert
                                                                     WHERE _tmpMIContainer_insert.DescId   = zc_MIContainer_Count()
                                                                     ))
     THEN
       WITH -- Остатки сроковых партий - zc_Container_CountPartionDate
           DD AS (SELECT _tmpMIContainer_insert.MovementItemId
                         -- сколько надо получить
                       , -1 * _tmpMIContainer_insert.Amount AS Amount
                         -- остаток
                       , Container.Amount AS AmountRemains
                       , _tmpMIContainer_insert.OperDate    AS OperDate
                       , Container.Id     AS ContainerId
                         -- итого "накопительный" остаток
                       , SUM (Container.Amount) OVER (PARTITION BY Container.ParentId ORDER BY COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()), Container.Id) AS AmountRemains_sum
                         -- для последнего элемента - не смотрим на остаток
                       , ROW_NUMBER() OVER (PARTITION BY _tmpMIContainer_insert.MovementItemId ORDER BY COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()) DESC, Container.Id DESC) AS DOrd
                   FROM _tmpMIContainer_insert
                        JOIN Container ON Container.ParentId = _tmpMIContainer_insert.ContainerId
                                      AND Container.DescId   = zc_Container_CountPartionDate()
                                      AND Container.Amount   > 0.0
                        LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                     AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                        LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                      ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId  
                                                     AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()                             
                   WHERE _tmpMIContainer_insert.DescId      = zc_MIContainer_Count()
                  )

           -- распределение
         , tmpItem AS (SELECT ContainerId
                            , MovementItemId
                            , OperDate
                            , CASE WHEN DD.Amount - DD.AmountRemains_sum > 0.0 AND DD.DOrd <> 1
                                        THEN DD.AmountRemains
                                   ELSE DD.Amount - DD.AmountRemains_sum + DD.AmountRemains
                              END AS Amount
                         FROM DD
                         WHERE (DD.Amount > 0 AND DD.Amount - (DD.AmountRemains_sum - DD.AmountRemains) > 0))
        -- Результат - проводки по срокам - расход
        INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
          SELECT zc_MIContainer_CountPartionDate()
               , zc_Movement_Loss()
               , inMovementId
               , tmpItem.MovementItemId
               , tmpItem.ContainerId
               , NULL
               , -1 * Amount
               , OperDate
          FROM tmpItem; 
     END IF;
   
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Loss()
                                , inUserId     := inUserId
                                 );
    --пересчитываем сумму документа по приходным ценам
    PERFORM lpInsertUpdate_MovementFloat_TotalSummLossAfterComplete(inMovementId);    
    
    --Пересчет полного списания в зарплате
    IF COALESCE(vbArticleLossId, 0) = 13892113
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesFullCharge (vbUnitId, vbOperDate, inUserId::TVarChar); 
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий О.В.
 23.07.19                                                                     * 
 21.07.15                                                                     * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
--    IN inMovementId        Integer  , -- ключ Документа
--    IN inUserId            Integer    -- Пользователь
-- SELECT * FROM lpComplete_Movement_Loss (inMovementId:= 12671, inUserId:= zfCalc_UserAdmin()::Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM MovementItemContainer WHERE MovementId = 12671