 -- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Check (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Check(
    IN inMovementId        Integer  , -- ключ Документа
   OUT outMessageText      Text     ,
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS Text
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

     -- создаются временные таблицы - для формирование данных для проводок
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMIContainer_insert'))
     THEN
         -- !!!обязательно!!! очистили таблицу проводок
         DELETE FROM _tmpMIContainer_insert;
         DELETE FROM _tmpMIReport_insert;
     ELSE
         PERFORM lpComplete_Movement_Finance_CreateTemp();
     END IF;

    -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
    DELETE FROM _tmpItem;


    -- Определить
    vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);

    -- Определить
    vbAccountId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- Запасы
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- Cклад 
                                             , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- Медикаменты
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId);

    -- Определить
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject 
                WHERE MovementLinkObject.MovementId = inMovementId 
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());

   
/*  
    -- Проводки по суммам документа. Деньги в кассу
    INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)   
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
                      inContainerDescId   := zc_Container_Summ(), -- DescId Остатка
                      inParentId          := NULL               , -- Главный Container
                      inObjectId          := _tmpItem.AccountId, -- Объект (Счет или Товар или ...)
                      inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- Главное юридическое лицо
                      inBusinessId        := NULL, -- Бизнесы
                      inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                      inObjectCostId      := NULL, -- <элемент с/с> - необычная аналитика счета 
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
/*
    CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, OperSumm_Currency TFloat, OperSumm_Diff TFloat
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

    -- данные почти все
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMIContainer_remains'))
    THEN
        DELETE FROM _tmpMIContainer_remains;
    ELSE
        -- таблица - данные почти все
        CREATE TEMP TABLE _tmpMIContainer_remains (MovementItemId Integer, GoodsId Integer, SaleAmount TFloat, ContainerAmount TFloat, ContainerId Integer, ContainerAmountSUM TFloat, DOrd Integer, SaleAmountTotal TFloat, ContainerAmountTotal TFloat);
    END IF;

    -- предварительно сохранили остаток + продажи + найденный 1 элемент 
    INSERT INTO _tmpMIContainer_remains (MovementItemId, GoodsId, SaleAmount, ContainerAmount, ContainerId, ContainerAmountSUM, DOrd, SaleAmountTotal, ContainerAmountTotal)
       WITH tmpMI AS (SELECT * FROM MovementItem AS MI_Sale WHERE MI_Sale.MovementId = inMovementId AND MI_Sale.Amount > 0 AND MI_Sale.isErased = FALSE)
          , tmpContainer AS (SELECT MI_Sale.Id          AS MovementItemId
                                  , MI_Sale.ObjectId    AS GoodsId
                                  , MI_Sale.Amount      AS SaleAmount
                                  , Container.Amount    AS ContainerAmount
                                  , Container.Id        AS ContainerId
                                  , SUM (Container.Amount) OVER (PARTITION BY Container.ObjectId ORDER BY Movement.OperDate, Container.Id, MI_Sale.Id) AS ContainerAmountSUM
                                  , ROW_NUMBER() OVER (PARTITION BY MI_Sale.ObjectId /*MI_Sale.Id*/ ORDER BY Movement.OperDate DESC, Container.Id DESC, MI_Sale.Id DESC) AS DOrd
                             FROM tmpMI AS MI_Sale
                                  INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                      AND Container.WhereObjectId = vbUnitId
                                                      AND Container.ObjectId = MI_Sale.ObjectId
                                                      AND Container.Amount > 0
                                  INNER JOIN ContainerLinkObject AS CLI_MI
                                                                 ON CLI_MI.ContainerId = Container.Id
                                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                  INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                  INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                            )
          , tmp_check AS (SELECT tmpFrom.GoodsId, tmpFrom.SaleAmount, COALESCE (tmpTo.ContainerAmount, 0) AS ContainerAmount
                          FROM (SELECT tmpMI.ObjectId AS GoodsId, SUM (tmpMI.Amount) AS SaleAmount FROM tmpMI GROUP BY tmpMI.ObjectId
                               ) AS tmpFrom
                               LEFT JOIN (SELECT tmpContainer.GoodsId, MAX (tmpContainer.ContainerAmountSUM) AS ContainerAmount FROM tmpContainer GROUP BY tmpContainer.GoodsId
                                         ) AS tmpTo ON tmpTo.GoodsId = tmpFrom.GoodsId
                          WHERE tmpFrom.SaleAmount > COALESCE (tmpTo.ContainerAmount, 0)
                          ORDER BY tmpFrom.SaleAmount DESC
                         )
       -- результат
       SELECT tmpMI.Id         AS MovementItemId
            , tmpMI.ObjectId   AS GoodsId
            , tmpMI.Amount     AS SaleAmount
            , COALESCE (tmpContainer.ContainerAmount, 0)     AS ContainerAmount
            , COALESCE (tmpContainer.ContainerId, 0)         AS ContainerId
            , COALESCE (tmpContainer.ContainerAmountSUM, 0)  AS ContainerAmountSUM
            , COALESCE (tmpContainer.DOrd, 0)                AS DOrd
            , tmp_check.SaleAmount                           AS SaleAmountTotal
            , tmp_check.ContainerAmount                      AS ContainerAmountTotal
       FROM tmpMI
            LEFT JOIN tmpContainer ON tmpContainer.MovementItemId = tmpMI.Id
            LEFT JOIN tmp_check    ON tmp_check.GoodsId           = tmpMI.ObjectId
      ;


       -- Проверим что б БЫЛ остаток
       IF EXISTS (SELECT 1 FROM _tmpMIContainer_remains WHERE SaleAmountTotal > ContainerAmountTotal)
       THEN
           -- Ошибка расч/факт остаток :
           outMessageText:= '<' || (SELECT STRING_AGG (tmp.Value, '(+)')
                                    FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') || ' Кол: ' || zfConvert_FloatToString (ContainerAmountTotal) || '/' || zfConvert_FloatToString (SaleAmountTotal) AS Value
                                          FROM (SELECT DISTINCT GoodsId, SaleAmountTotal, ContainerAmountTotal FROM _tmpMIContainer_remains WHERE SaleAmountTotal > ContainerAmountTotal) AS tmp
                                               LEFT JOIN Object ON Object.Id = tmp.GoodsId
                                         ) AS tmp
                                    )
                         || '>';

           -- Сохранили ошибку
           PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inMovementId, outMessageText);

           -- кроме Админа
           IF inUserId <> 3
           THEN
               -- больше ничего не делаем
               RETURN;
           ELSE
               DELETE FROM _tmpMIContainer_remains WHERE ContainerId = 0;
           END IF;

       END IF;


    -- Результат - проводки кол-во
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_Count()
      , zc_Movement_Check()  
      , inMovementId
      , tmpItem.MovementItemId
      , tmpItem.ContainerId
      , vbAccountId
      , - Amount
      , vbOperDate
    FROM (SELECT ContainerId
               , MovementItemId
               , CASE WHEN SaleAmount - ContainerAmountSUM > 0 AND DOrd <> 1
                           THEN ContainerAmount
                      ELSE SaleAmount - ContainerAmountSUM + ContainerAmount
                 END AS Amount
          FROM (SELECT * FROM _tmpMIContainer_remains) AS DD
          WHERE SaleAmount - (ContainerAmountSUM - ContainerAmount) > 0
         ) AS tmpItem;
    

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
                                , inDescId     := zc_Movement_Check()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.02.14                        * 
 05.02.14                        * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
--    IN inMovementId        Integer  , -- ключ Документа
--    IN inUserId            Integer    -- Пользователь
-- SELECT * FROM lpComplete_Movement_Check (inMovementId:= 12671, inUserId:= zfCalc_UserAdmin()::Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM MovementItemContainer WHERE MovementId = 12671
