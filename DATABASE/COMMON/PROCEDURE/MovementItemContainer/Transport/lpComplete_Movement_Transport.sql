-- Function: lpComplete_Movement_Transport (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Transport (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Transport(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbOperDate TDateTime;
  DECLARE vbMemberDriverId Integer;
  DECLARE vbCarId Integer;
  DECLARE vbUnitId_Forwarding Integer;

  DECLARE vbJuridicalId_Basis Integer;
  -- DECLARE vbBusinessId_Car Integer; !!!стало ненужным!!!

  DECLARE vbStartSummCash TFloat;
  DECLARE vbStartAmountTicketFuel TFloat;
  DECLARE vbStartAmountFuel TFloat;
BEGIN

     -- !!!обязательно!!! очистили таблицу проводок
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;

     -- !!!обязательно!!! очистили таблицу свойств (остатки) документа/элементов
     DELETE FROM _tmpPropertyRemains;
     -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_Transport;
     -- !!!обязательно!!! очистили таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_TransportSumm_Transport;
     -- !!!обязательно!!! очистили таблицу - элементы по Сотруднику (ЗП) + затраты "командировочные" + "дальнобойные" + "такси", со всеми свойствами для формирования Аналитик в проводках
     DELETE FROM _tmpItem_SummPersonal;


     -- !!!обязательно!!! пересчитали Child - нормы
     /*PERFORM lpInsertUpdate_MI_Transport_Child_byMaster (inMovementId := inMovementId, inParentId := MovementItem.Id, inRouteKindId:= MILinkObject_RouteKind.ObjectId, inUserId := inUserId)
     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind
                                           ON MILinkObject_RouteKind.MovementItemId = MovementItem.Id 
                                          AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master();*/


     -- пересохраняем
     IF 1=0
     THEN
                  -- пересохранили свойство <Ставка грн/ч коммандировочных>
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TimePrice(), MovementItem.Id, COALESCE (ObjectFloat_TimePrice.ValueData, 0))
                  -- сохранили свойство <Ставка грн/км (дальнобойные)>
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_RatePrice(), MovementItem.Id, COALESCE (ObjectFloat_RatePrice.ValueData, 0))
                  -- пересохранили свойство <Сумма коммандировочных>
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSumma(), MovementItem.Id, CASE WHEN ObjectFloat_TimePrice.ValueData > 0
                                                                                                       THEN ObjectFloat_TimePrice.ValueData
                                                                                                          * CAST (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0) AS TFloat)
                                                                                                  ELSE COALESCE (ObjectFloat_RateSumma.ValueData, 0)
                                                                                             END)
                  -- пересохранили свойство <Сумма доплата (дальнобойные)>
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_RateSummaAdd(), MovementItem.Id, CASE WHEN ObjectFloat_RatePrice.ValueData > 0
                                                                                                          THEN 0
                                                                                                     ELSE COALESCE (ObjectFloat_RateSummaAdd.ValueData, 0)
                                                                                                END)
          FROM MovementItem
               LEFT JOIN MovementFloat AS MovementFloat_HoursWork
                                       ON MovementFloat_HoursWork.MovementId = inMovementId
                                      AND MovementFloat_HoursWork.DescId     = zc_MovementFloat_HoursWork()
               LEFT JOIN MovementFloat AS MovementFloat_HoursAdd
                                       ON MovementFloat_HoursAdd.MovementId = inMovementId
                                      AND MovementFloat_HoursAdd.DescId     = zc_MovementFloat_HoursAdd()
               LEFT JOIN ObjectFloat AS ObjectFloat_RateSumma
                                     ON ObjectFloat_RateSumma.ObjectId = MovementItem.ObjectId
                                    AND ObjectFloat_RateSumma.DescId   = zc_ObjectFloat_Route_RateSumma()
               LEFT JOIN ObjectFloat AS ObjectFloat_RatePrice
                                     ON ObjectFloat_RatePrice.ObjectId = MovementItem.ObjectId
                                    AND ObjectFloat_RatePrice.DescId   = zc_ObjectFloat_Route_RatePrice()
               LEFT JOIN ObjectFloat AS ObjectFloat_TimePrice
                                     ON ObjectFloat_TimePrice.ObjectId = MovementItem.ObjectId
                                    AND ObjectFloat_TimePrice.DescId   = zc_ObjectFloat_Route_TimePrice()
               LEFT JOIN ObjectFloat AS ObjectFloat_RateSummaAdd
                                     ON ObjectFloat_RateSummaAdd.ObjectId = MovementItem.ObjectId
                                    AND ObjectFloat_RateSummaAdd.DescId   = zc_ObjectFloat_Route_RateSummaAdd()
          WHERE MovementItem.MovementId = inMovementId
            AND MovementItem.DescId     = zc_MI_Master()
            AND MovementItem.isErased   = FALSE;

     END IF;



     -- Эти параметры нужны для формирования Аналитик в проводках
     SELECT _tmp.MovementDescId
          , _tmp.OperDate
          , _tmp.MemberDriverId, _tmp.CarId, _tmp.UnitId_Forwarding
          , _tmp.JuridicalId_Basis
          -- , _tmp.BusinessId_Car
            INTO vbMovementDescId, vbOperDate
               , vbMemberDriverId, vbCarId, vbUnitId_Forwarding
               , vbJuridicalId_Basis -- эти аналитики берутся у Подразделение (Место отправки) (и используется только для проводок по прибыли)
               -- , vbBusinessId_Car -- !!!стало ненужным!!! эта аналитика берется у подразделения за которым числится Автомобиль (и используется только для проводок по суммовым остаткам)
     FROM (SELECT Movement.DescId AS MovementDescId
                , Movement.OperDate
                , COALESCE (ObjectLink_PersonalDriver_Member.ChildObjectId, 0)     AS MemberDriverId
                , COALESCE (MovementLinkObject_Car.ObjectId, 0)                    AS CarId
                , COALESCE (MovementLinkObject_UnitForwarding.ObjectId, 0)         AS UnitId_Forwarding
                , COALESCE (ObjectLink_UnitForwarding_Juridical.ChildObjectId, 0)  AS JuridicalId_Basis
                -- , COALESCE (ObjectLink_UnitCar_Business.ChildObjectId, 0)          AS BusinessId_Car
           FROM Movement
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                             ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                            AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                             ON MovementLinkObject_Car.MovementId = Movement.Id
                                            AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                             ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                            AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
                LEFT JOIN ObjectLink AS ObjectLink_PersonalDriver_Member
                                     ON ObjectLink_PersonalDriver_Member.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                    AND ObjectLink_PersonalDriver_Member.DescId = zc_ObjectLink_Personal_Member()
                /*LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                     ON ObjectLink_Car_Unit.ObjectId = MovementLinkObject_Car.ObjectId
                                    AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_UnitCar_Business
                                     ON ObjectLink_UnitCar_Business.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                    AND ObjectLink_UnitCar_Business.DescId = zc_ObjectLink_Unit_Business()*/
                LEFT JOIN ObjectLink AS ObjectLink_UnitForwarding_Juridical
                                     ON ObjectLink_UnitForwarding_Juridical.ObjectId = MovementLinkObject_UnitForwarding.ObjectId
                                    AND ObjectLink_UnitForwarding_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           WHERE Movement.Id = inMovementId
             AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             AND Movement.DescId = zc_Movement_Transport()
          ) AS _tmp;



     -- !!!Проверка!!!
     IF vbJuridicalId_Basis = 0
     THEN
        RAISE EXCEPTION 'Ошибка. Место отправки не определено.';
     END IF;


     -- !!!Начали!!! Расчет/сохранение некоторых свойств (остатки) документа/элементов

     -- Получили все нужные нам количественные/суммовые контейнеры по определенным товарам/счетам !!!без ограничения по Бизнесу и Главному юр.лицу!!!
     WITH tmpContainer AS  (SELECT Id, Amount, 0 AS FuelId, 1 AS Kind
                            FROM Container
                                               -- ограничили списком счетов: (30500) Дебиторы + сотрудники (подотчетные лица) + (20400) Общефирменные + ГСМ
                            WHERE ObjectId IN (SELECT AccountId FROM Object_Account_View WHERE AccountDirectionId = zc_Enum_AccountDirection_30500() AND InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400())
                                         -- Ограничили по Аналитике <Автомобиль>
                              AND Id IN (SELECT ContainerId FROM ContainerLinkObject WHERE DescId = zc_ContainerLinkObject_Car() AND ObjectId = vbCarId)
                              AND DescId = zc_Container_Summ()
                           UNION
                            SELECT Id, Amount, 0 AS FuelId, 2 AS Kind
                            FROM Container
                                               -- ограничили списком товаров: (20400)ГСМ
                            WHERE ObjectId IN (SELECT GoodsId FROM Object_Goods_View WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20400())
                                          -- Ограничили по Аналитике <Сотрудник>
                              AND Id IN (SELECT ContainerId FROM ContainerLinkObject WHERE DescId = zc_ContainerLinkObject_Member() AND ObjectId = vbMemberDriverId)
                              AND DescId = zc_Container_Count()
                           UNION
                            SELECT Id, Amount, Container.ObjectId AS FuelId, 3 AS Kind
                            FROM Container
                                              -- Ограничили списком Виды топлива
                            WHERE ObjectId IN (SELECT Id FROM Object WHERE DescId = zc_Object_Fuel())
                                          -- Ограничили по Аналитике <Автомобиль>
                              AND Id IN (SELECT ContainerId FROM ContainerLinkObject WHERE DescId =  zc_ContainerLinkObject_Car() AND ObjectId = vbCarId)
                              AND DescId = zc_Container_Count()
                           )
     -- Расчет
     INSERT INTO _tmpPropertyRemains (Kind, FuelId, Amount)
       SELECT tmpRemains.Kind
           , tmpRemains.FuelId
            , SUM (tmpRemains.AmountRemainsStart) AS Amount
       FROM (SELECT tmpContainer.Id, tmpContainer.FuelId, tmpContainer.Kind, tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS AmountRemainsStart
             FROM tmpContainer
                  LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Containerid = tmpContainer.Id
                                                                AND MIContainer.OperDate >= vbOperDate
             GROUP BY tmpContainer.Id, tmpContainer.FuelId, tmpContainer.Kind, tmpContainer.Amount
             HAVING tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
           ) AS tmpRemains
       GROUP BY tmpRemains.Kind
              , tmpRemains.FuelId;

     -- Получили остатки по нужным Kind
     SELECT SUM (CASE WHEN Kind = 1 THEN Amount ELSE 0 END) AS StartSummCash         -- Начальный остаток денег Автомобиль(Подотчет)
          , SUM (CASE WHEN Kind = 2 THEN Amount ELSE 0 END) AS StartAmountTicketFuel -- Начальный остаток талонов на топливо Сотрудник (водитель)
            INTO vbStartSummCash, vbStartAmountTicketFuel
     FROM _tmpPropertyRemains WHERE Kind IN (1, 2);

     -- сохранили свойство документа <Начальный остаток денег Автомобиль(Подотчет)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_StartSummCash(), inMovementId, vbStartSummCash);
     -- сохранили свойство документа <Начальный остаток талонов на топливо Сотрудник (водитель)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_StartAmountTicketFuel(), inMovementId, vbStartAmountTicketFuel);

     -- !!!Почти закончили!!! Расчет/сохранение некоторых свойств (остатки) документа/элементов


     -- заполняем таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
     INSERT INTO _tmpItem_Transport (MovementItemId, MovementItemId_parent, UnitId_ProfitLoss, BranchId_ProfitLoss, RouteId_ProfitLoss, UnitId_Route, BranchId_Route
                                   , ContainerId_Goods, GoodsId, AssetId
                                   , OperCount
                                   , ProfitLossGroupId, ProfitLossDirectionId, InfoMoneyDestinationId, InfoMoneyId
                                   , BusinessId_Car, BusinessId_Route
                                    )
        SELECT
              _tmp.MovementItemId
            , _tmp.MovementItemId_parent
            , _tmp.UnitId_ProfitLoss
            , _tmp.BranchId_ProfitLoss
            , _tmp.RouteId_ProfitLoss
            , _tmp.UnitId_Route
            , _tmp.BranchId_Route
            , 0 AS ContainerId_Goods -- сформируем позже
            , _tmp.GoodsId
            , _tmp.AssetId
            , _tmp.OperCount
            , _tmp.ProfitLossGroupId      -- Группы ОПиУ
            , _tmp.ProfitLossDirectionId  -- Аналитики ОПиУ  - направления
            , _tmp.InfoMoneyDestinationId -- Управленческие назначения
            , _tmp.InfoMoneyId            -- Статьи назначения
              -- !!!стало ненужным!!! Бизнес для остатков по Автомобилю, эта аналитика берется у подразделения за которым числится Автомобиль
            , 0 AS BusinessId_Car -- vbBusinessId_Car AS BusinessId_Car
              -- Бизнес для Прибыль, эта аналитика всегда берется по принадлежности маршрута к подразделению
            , _tmp.BusinessId_Route

        FROM (SELECT
                     MovementItem.Id AS MovementItemId
                   , MovementItem.ParentId AS MovementItemId_parent
--                   , COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)       AS UnitId_ProfitLoss   -- сейчас затраты по принадлежности маршрута к подразделению, иначе надо изменить на vbUnitId_Car, тогда затраты будут по принадлежности авто к подразделению
--                   , COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) AS BranchId_ProfitLoss -- сейчас затраты по принадлежности маршрута к подразделению, иначе надо изменить на vbBranchId_Car, тогда затраты будут по принадлежности авто к подразделению
                   , CASE WHEN ObjectLink_UnitRoute_Branch.ChildObjectId IS NULL
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)) -- если филиал = "пусто", тогда затраты по принадлежности маршрута к подразделению, т.е. это мясо(з+сб), снабжение, админ, произв.
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)) -- если "собственный" маршрут, тогда затраты по принадлежности маршрута к подразделению, т.е. это филиалы
                          ELSE vbUnitId_Forwarding -- иначе Подразделение (Место отправки), т.е. везут на филиалы но затраты к ним не падают
                     END AS UnitId_ProfitLoss
                   , CASE WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                               THEN COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0) -- если "собственный" маршрут, тогда затраты по принадлежности маршрута к подразделению и к филиалу
                          ELSE 0 -- иначе затраты без принадлежности к филиалу
                     END AS BranchId_ProfitLoss

                   , COALESCE (MovementItem_Parent.ObjectId, 0)                                                      AS RouteId_ProfitLoss -- всегда zc_MI_Master
                   , COALESCE (MILinkObject_Unit_parent.ObjectId, COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)) AS UnitId_Route       -- всегда у Маршрута для zc_MI_Master
                   , COALESCE (ObjectLink_UnitRoute_Branch.ChildObjectId, 0)                                         AS BranchId_Route     -- всегда у Маршрута для zc_MI_Master
                     -- для Автомобиля это Вид топлива
                   , MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
                   , MovementItem.Amount AS OperCount
                     -- Группы ОПиУ
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossGroupId, 0) AS ProfitLossGroupId
                     -- Аналитики ОПиУ - направления
                   , COALESCE (lfObject_Unit_byProfitLossDirection.ProfitLossDirectionId, 0) AS ProfitLossDirectionId
                     -- Управленческие назначения
                   , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                     -- Статьи назначения
                   , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                     -- Бизнес для Прибыль, эта аналитика всегда берется по принадлежности маршрута к подразделению
                   , COALESCE (ObjectLink_UnitRoute_Business.ChildObjectId, 0) AS BusinessId_Route

              FROM Movement
                   JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE
                   JOIN MovementItem AS MovementItem_Parent ON MovementItem_Parent.Id = MovementItem.ParentId AND MovementItem_Parent.isErased = FALSE
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit_parent
                                                    ON MILinkObject_Unit_parent.MovementItemId = MovementItem_Parent.Id
                                                   AND MILinkObject_Unit_parent.DescId = zc_MILinkObject_Unit()
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                   LEFT JOIN ObjectLink AS ObjectLink_Route_Branch
                                        ON ObjectLink_Route_Branch.ObjectId = MovementItem_Parent.ObjectId
                                       AND ObjectLink_Route_Branch.DescId = zc_ObjectLink_Route_Branch()
                   LEFT JOIN ObjectLink AS ObjectLink_Route_Unit
                                        ON ObjectLink_Route_Unit.ObjectId = MovementItem_Parent.ObjectId
                                       AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Branch
                                        ON ObjectLink_UnitRoute_Branch.ObjectId = COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId)
                                       AND ObjectLink_UnitRoute_Branch.DescId = zc_ObjectLink_Unit_Branch()
                   LEFT JOIN ObjectLink AS ObjectLink_UnitRoute_Business
                                        ON ObjectLink_UnitRoute_Business.ObjectId = COALESCE (MILinkObject_Unit_parent.ObjectId, ObjectLink_Route_Unit.ChildObjectId)
                                       AND ObjectLink_UnitRoute_Business.DescId = zc_ObjectLink_Unit_Business()
                   -- для затрат
                   LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId
                   = CASE WHEN ObjectLink_UnitRoute_Branch.ChildObjectId IS NULL
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)) -- если филиал = "пусто", тогда затраты по принадлежности маршрута к подразделению, т.е. это мясо(з+сб), снабжение, админ, произв.
                          WHEN ObjectLink_UnitRoute_Branch.ChildObjectId  = COALESCE (ObjectLink_Route_Branch.ChildObjectId, 0)
                               THEN COALESCE (MILinkObject_Unit_parent.ObjectId, COALESCE (ObjectLink_Route_Unit.ChildObjectId, 0)) -- если "собственный" маршрут, тогда затраты по принадлежности маршрута к подразделению, т.е. это филиалы
                          ELSE vbUnitId_Forwarding -- иначе Подразделение (Место отправки), т.е. везут на филиалы но затраты к ним не падают
                     END
                   -- здесь нужен только 20401; "ГСМ";
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_20401()

              WHERE Movement.Id = inMovementId
                AND Movement.DescId = zc_Movement_Transport()
                AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
             ) AS _tmp
        ;

     -- заполняем таблицу - элементы по Сотруднику (ЗП) + затраты "командировочные" + "дальнобойные" + "такси", со всеми свойствами для формирования Аналитик в проводках, здесь по !!!MovementItemId!!!
     INSERT INTO _tmpItem_SummPersonal (MovementItemId, OperSumm_Add, OperSumm_AddLong, OperSumm_Taxi
                                      , ContainerId, AccountId, InfoMoneyDestinationId, InfoMoneyId
                                      , PersonalId, BranchId, UnitId, PositionId, ServiceDateId, PersonalServiceListId
                                      , BusinessId_ProfitLoss, BranchId_ProfitLoss, UnitId_ProfitLoss
                                      , ContainerId_ProfitLoss
                                       )
        SELECT _tmpItem.MovementItemId_parent            AS MovementItemId
             , MIFloat_RateSumma.ValueData               AS OperSumm_Add
             , COALESCE (MIFloat_RatePrice.ValueData, 0) * (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_DistanceFuelChild.ValueData, 0))
             + COALESCE (MIFloat_RateSummaAdd.ValueData, 0) AS OperSumm_AddLong
             , CASE WHEN MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriverMore() THEN COALESCE (MIFloat_TaxiMore.ValueData, 0) ELSE COALESCE (MIFloat_Taxi.ValueData, 0) END AS OperSumm_Taxi

               -- для Сотрудника (ЗП)
             , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                     , inParentId          := NULL
                                     , inObjectId          := lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()          -- Кредиторы
                                                                                         , inAccountDirectionId     := zc_Enum_AccountDirection_70500()      -- Кредиторы + Сотрудники
                                                                                         , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId
                                                                                         , inInfoMoneyId            := NULL
                                                                                         , inUserId                 := inUserId
                                                                                          )
                                     , inJuridicalId_basis := vbJuridicalId_Basis
                                     , inBusinessId        := NULL
                                     , inObjectCostDescId  := NULL
                                     , inObjectCostId      := NULL
                                     , inDescId_1          := zc_ContainerLinkObject_Personal()
                                     , inObjectId_1        := MovementLinkObject_PersonalDriver.ObjectId
                                     , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                     , inObjectId_2        := View_InfoMoney.InfoMoneyId
                                     , inDescId_3          := zc_ContainerLinkObject_Branch()
                                     , inObjectId_3        := COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                     , inDescId_4          := zc_ContainerLinkObject_Unit()
                                     , inObjectId_4        := ObjectLink_Personal_Unit.ChildObjectId
                                     , inDescId_5          := zc_ContainerLinkObject_Position()
                                     , inObjectId_5        := ObjectLink_Personal_Position.ChildObjectId
                                     , inDescId_6          := zc_ContainerLinkObject_ServiceDate()
                                     , inObjectId_6        := lpInsertFind_Object_ServiceDate (inOperDate:= vbOperDate)
                                     , inDescId_7          := zc_ContainerLinkObject_PersonalServiceList()
                                     , inObjectId_7        := ObjectLink_Personal_PersonalServiceList.ChildObjectId
                                      ) AS ContainerId
               -- для Сотрудника (ЗП)
             , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()          -- Кредиторы
                                          , inAccountDirectionId     := zc_Enum_AccountDirection_70500()      -- Кредиторы + Сотрудники
                                          , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId
                                          , inInfoMoneyId            := NULL
                                          , inUserId                 := inUserId
                                           ) AS AccountId

             , View_InfoMoney.InfoMoneyDestinationId
             , View_InfoMoney.InfoMoneyId
             , MovementLinkObject_PersonalDriver.ObjectId                         AS PersonalId
             , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId
             , ObjectLink_Personal_Unit.ChildObjectId                             AS UnitId
             , ObjectLink_Personal_Position.ChildObjectId                         AS PositionId
             , lpInsertFind_Object_ServiceDate (inOperDate:= vbOperDate)          AS ServiceDateId
             , ObjectLink_Personal_PersonalServiceList.ChildObjectId              AS PersonalServiceListId

             , _tmpItem.BusinessId_Route    AS BusinessId_ProfitLoss -- !!!т.е. затраты из маршрута!!!
             , _tmpItem.BranchId_ProfitLoss AS BranchId_ProfitLoss   -- !!!т.е. затраты могут не соответствовать Сотруднику (ЗП)!!!
             , _tmpItem.UnitId_ProfitLoss   AS UnitId_ProfitLoss     -- !!!т.е. затраты могут не соответствовать Сотруднику (ЗП)!!!

               -- для ОПиУ
             , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                     , inParentId          := NULL
                                     , inObjectId          := zc_Enum_Account_100301()  -- прибыль текущего периода
                                     , inJuridicalId_basis := vbJuridicalId_Basis
                                     , inBusinessId        := _tmpItem.BusinessId_Route -- !!!т.е. затраты из маршрута!!!
                                     , inObjectCostDescId  := NULL
                                     , inObjectCostId      := NULL
                                     , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                     , inObjectId_1        := lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem.ProfitLossGroupId
                                                                                            , inProfitLossDirectionId  := _tmpItem.ProfitLossDirectionId
                                                                                            , inInfoMoneyDestinationId := View_InfoMoney.InfoMoneyDestinationId -- ???Заработная плата
                                                                                            , inInfoMoneyId            := NULL
                                                                                            , inUserId                 := inUserId
                                                                                             )
                                     , inDescId_2          := zc_ContainerLinkObject_Branch()
                                     , inObjectId_2        := _tmpItem.BranchId_ProfitLoss -- !!!т.е. затраты могут не соответствовать Сотруднику (ЗП)!!!
                                      ) AS ContainerId_ProfitLoss

        FROM (SELECT DISTINCT _tmpItem_Transport.MovementItemId_parent
                            , _tmpItem_Transport.BusinessId_Route
                            , _tmpItem_Transport.BranchId_ProfitLoss
                            , _tmpItem_Transport.UnitId_ProfitLoss
                            , _tmpItem_Transport.ProfitLossGroupId
                            , _tmpItem_Transport.ProfitLossDirectionId
              FROM _tmpItem_Transport
             ) AS _tmpItem
             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver_check
                                          ON MovementLinkObject_PersonalDriver_check.MovementId = inMovementId
                                         AND MovementLinkObject_PersonalDriver_check.DescId     = zc_MovementLinkObject_PersonalDriver()
                                         AND MovementLinkObject_PersonalDriver_check.ObjectId   > 0 
             LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                          ON MovementLinkObject_PersonalDriver.MovementId = inMovementId
                                         AND MovementLinkObject_PersonalDriver.DescId     IN (zc_MovementLinkObject_PersonalDriver(), zc_MovementLinkObject_PersonalDriverMore())
                                         AND MovementLinkObject_PersonalDriver.ObjectId   > 0 
                                         AND (MovementLinkObject_PersonalDriver.ObjectId   <> COALESCE (MovementLinkObject_PersonalDriver_check.ObjectId ,0)
                                           OR MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                                             )
             LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60101() -- Заработная плата

             LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                  ON ObjectLink_Personal_Unit.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                 AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                  ON ObjectLink_Personal_Position.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                 AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
             LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                  ON ObjectLink_Personal_PersonalServiceList.ObjectId = MovementLinkObject_PersonalDriver.ObjectId
                                 AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                  ON ObjectLink_Unit_Branch.ObjectId = ObjectLink_Personal_Unit.ChildObjectId
                                 AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

             LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.Id         = _tmpItem.MovementItemId_parent

             LEFT JOIN MovementItemFloat AS MIFloat_DistanceFuelChild
                                         ON MIFloat_DistanceFuelChild.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_DistanceFuelChild.DescId         = zc_MIFloat_DistanceFuelChild()
             LEFT JOIN MovementItemFloat AS MIFloat_RateSumma
                                         ON MIFloat_RateSumma.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_RateSumma.DescId = zc_MIFloat_RateSumma()
             LEFT JOIN MovementItemFloat AS MIFloat_RatePrice
                                         ON MIFloat_RatePrice.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_RatePrice.DescId = zc_MIFloat_RatePrice()
             LEFT JOIN MovementItemFloat AS MIFloat_RateSummaAdd
                                         ON MIFloat_RateSummaAdd.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_RateSummaAdd.DescId = zc_MIFloat_RateSummaAdd()
             LEFT JOIN MovementItemFloat AS MIFloat_Taxi
                                         ON MIFloat_Taxi.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_Taxi.DescId = zc_MIFloat_Taxi()
             LEFT JOIN MovementItemFloat AS MIFloat_TaxiMore
                                         ON MIFloat_TaxiMore.MovementItemId = _tmpItem.MovementItemId_parent
                                        AND MIFloat_TaxiMore.DescId = zc_MIFloat_TaxiMore()

        WHERE MIFloat_RateSumma.ValueData <> 0
           OR MIFloat_RatePrice.ValueData <> 0
           OR MIFloat_RateSummaAdd.ValueData <> 0
           OR CASE WHEN MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriverMore() THEN COALESCE (MIFloat_TaxiMore.ValueData, 0) ELSE COALESCE (MIFloat_Taxi.ValueData, 0) END <> 0
       ;


     -- !!!формируются расчитанные свойства в Подчиненых элементах документа!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartAmountFuel(), tmp.MovementItemId, tmp.StartAmountFuel)
     FROM (SELECT _tmpItem_Transport.MovementItemId, COALESCE (_tmpPropertyRemains.Amount, 0) AS StartAmountFuel
           FROM (SELECT (MovementItemId) AS MovementItemId, GoodsId FROM _tmpItem_Transport
                ) AS _tmpItem_Transport
                LEFT JOIN (SELECT MAX (MovementItemId) AS MovementItemId, GoodsId FROM _tmpItem_Transport GROUP BY GoodsId
                          ) AS _tmpItem_Transport_max ON _tmpItem_Transport_max.GoodsId = _tmpItem_Transport.GoodsId
                LEFT JOIN _tmpPropertyRemains ON _tmpPropertyRemains.FuelId = _tmpItem_Transport.GoodsId
                                             AND _tmpPropertyRemains.Kind = 3
                                             AND _tmpItem_Transport_max.MovementItemId = _tmpItem_Transport.MovementItemId
          UNION ALL
           -- Прийдется сформировать элементы, если в документе их нет, а остаток по топливу есть
           SELECT (SELECT ioId FROM lpInsertUpdate_MI_Transport_Child (ioId                 := 0
                                                                     , inMovementId         := inMovementId
                                                                     , inParentId           := tmpItem_Transport.MovementItemId_parent
                                                                     , inFuelId             := tmp.FuelId
                                                                     , inIsCalculated       := TRUE
                                                                     , inIsMasterFuel       := FALSE
                                                                     , ioAmount             := 0
                                                                     , inColdHour           := 0
                                                                     , inColdDistance       := 0
                                                                     , inAmountFuel         := 0
                                                                     , inAmountColdHour     := 0
                                                                     , inAmountColdDistance := 0
                                                                     , inNumber             := 4
                                                                     , inRateFuelKindTax    := 0
                                                                     , inRateFuelKindId     := 0
                                                                     , inUserId             := inUserId
                                                                      )
                 ) AS MovementItemId
               , tmp.StartAmountFuel
           FROM (SELECT _tmpPropertyRemains.FuelId, _tmpPropertyRemains.Amount AS StartAmountFuel
                 FROM _tmpPropertyRemains
                      LEFT JOIN (SELECT MAX (MovementItemId) AS MovementItemId, GoodsId FROM _tmpItem_Transport GROUP BY GoodsId
                                ) AS _tmpItem_Transport ON _tmpItem_Transport.GoodsId = _tmpPropertyRemains.FuelId
                 WHERE _tmpPropertyRemains.Kind = 3
                   AND _tmpItem_Transport.GoodsId IS NULL
                ) AS tmp
                JOIN (SELECT MIN (Id) AS MovementItemId_parent FROM MovementItem WHERE MovementId = inMovementId AND DescId = zc_MI_Master() AND isErased = FALSE
                     ) AS tmpItem_Transport ON 1=1
          ) AS tmp;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПРОВОДКИ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 1.1.1. определяется ContainerId_Goods для количественного учета
     UPDATE _tmpItem_Transport SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                          , inUnitId                 := NULL
                                                                                          , inCarId                  := vbCarId
                                                                                          , inMemberId               := NULL
                                                                                          , inInfoMoneyDestinationId := _tmpItem_Transport.InfoMoneyDestinationId
                                                                                          , inGoodsId                := _tmpItem_Transport.GoodsId
                                                                                          , inGoodsKindId            := 0
                                                                                          , inIsPartionCount         := FALSE
                                                                                          , inPartionGoodsId         := 0
                                                                                          , inAssetId                := _tmpItem_Transport.AssetId
                                                                                          , inBranchId               := 0
                                                                                          , inAccountId              := NULL -- эта аналитика нужна для "товар в пути"
                                                                                           );

     -- 1.2.1. самое интересное: заполняем таблицу - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках !!!(кроме Тары)!!!
     INSERT INTO _tmpItem_TransportSumm_Transport (MovementItemId, ContainerId_ProfitLoss, ContainerId, AccountId, OperSumm)
        SELECT
              _tmpItem_Transport.MovementItemId
            , 0 AS ContainerId_ProfitLoss
            , Container_Summ.Id AS ContainerId
            , Container_Summ.ObjectId AS AccountId
            , SUM (_tmpItem_Transport.OperCount * COALESCE (HistoryCost.Price, 0)) AS OperSumm -- убрал ABS
        FROM _tmpItem_Transport
             -- так находим для остальных
             JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem_Transport.ContainerId_Goods
                                             AND Container_Summ.DescId = zc_Container_Summ()
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = Container_Summ.Id
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = Container_Summ.Id -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!если нужны проводки!!!
          AND _tmpItem_Transport.OperCount * COALESCE (HistoryCost.Price, 0) <> 0 -- здесь нули !!!НЕ НУЖНЫ!!! 
          AND InfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "Оборотная тара"
        GROUP BY _tmpItem_Transport.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId;


     -- 2.1. определяется ContainerId_ProfitLoss для проводок суммового учета по счету Прибыль
     UPDATE _tmpItem_TransportSumm_Transport SET ContainerId_ProfitLoss = _tmpItem_Transport_byContainer.ContainerId_ProfitLoss
     FROM _tmpItem_Transport
          JOIN
          (SELECT lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                        , inJuridicalId_basis := vbJuridicalId_Basis
                                        , inBusinessId        := _tmpItem_Transport_byProfitLoss.BusinessId_Route -- !!!подставляем Бизнес для Прибыль!!!
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_Transport_byProfitLoss.ProfitLossId
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := _tmpItem_Transport_byProfitLoss.BranchId_ProfitLoss -- !!!подставляем Филиал для Прибыль!!!
                                         ) AS ContainerId_ProfitLoss
                , _tmpItem_Transport_byProfitLoss.ProfitLossDirectionId
                , _tmpItem_Transport_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_Transport_byProfitLoss.BusinessId_Route
                , _tmpItem_Transport_byProfitLoss.BranchId_ProfitLoss

           FROM (SELECT lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_Transport_group.ProfitLossGroupId
                                                      , inProfitLossDirectionId  := _tmpItem_Transport_group.ProfitLossDirectionId
                                                      , inInfoMoneyDestinationId := _tmpItem_Transport_group.InfoMoneyDestinationId
                                                      , inInfoMoneyId            := NULL
                                                      , inUserId                 := inUserId
                                                       ) AS ProfitLossId
                      , _tmpItem_Transport_group.ProfitLossDirectionId
                      , _tmpItem_Transport_group.InfoMoneyDestinationId
                      , _tmpItem_Transport_group.BusinessId_Route
                      , _tmpItem_Transport_group.BranchId_ProfitLoss

                 FROM (SELECT _tmpItem_Transport.ProfitLossGroupId
                            , _tmpItem_Transport.ProfitLossDirectionId
                            , _tmpItem_Transport.InfoMoneyDestinationId
                            , _tmpItem_Transport.BusinessId_Route
                            , _tmpItem_Transport.BranchId_ProfitLoss
                       FROM _tmpItem_TransportSumm_Transport
                            JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = _tmpItem_TransportSumm_Transport.MovementItemId
                       GROUP BY _tmpItem_Transport.ProfitLossGroupId
                              , _tmpItem_Transport.ProfitLossDirectionId
                              , _tmpItem_Transport.InfoMoneyDestinationId
                              , _tmpItem_Transport.BusinessId_Route
                              , _tmpItem_Transport.BranchId_ProfitLoss
                      ) AS _tmpItem_Transport_group
                ) AS _tmpItem_Transport_byProfitLoss
          ) AS _tmpItem_Transport_byContainer ON _tmpItem_Transport_byContainer.ProfitLossDirectionId  = _tmpItem_Transport.ProfitLossDirectionId
                                             AND _tmpItem_Transport_byContainer.InfoMoneyDestinationId = _tmpItem_Transport.InfoMoneyDestinationId
                                             AND _tmpItem_Transport_byContainer.BusinessId_Route       = _tmpItem_Transport.BusinessId_Route
                                             AND _tmpItem_Transport_byContainer.BranchId_ProfitLoss    = _tmpItem_Transport.BranchId_ProfitLoss
     WHERE _tmpItem_TransportSumm_Transport.MovementItemId = _tmpItem_Transport.MovementItemId;

     -- 2.2. формируются Проводки - Прибыль
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpProfitLoss.MovementItemId
            , tmpProfitLoss.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId              -- прибыль текущего периода
            , 0                                       AS AnalyzerId             -- в ОПиУ как правило не нужена аналитика, т.к. большинство отчетов строится на AnalyzerId <> 0
            , _tmpItem_Transport.GoodsId              AS ObjectId_Analyzer      -- Товар
            , vbCarId                                 AS WhereObjectId_Analyzer -- Автомобиль
            , 0                                       AS ContainerId_Analyzer   -- в ОПиУ не нужен
            , _tmpItem_Transport.UnitId_ProfitLoss    AS ObjectIntId_Analyzer   -- Подраделение (ОПиУ), а могло быть UnitId_Route
            , _tmpItem_Transport.BranchId_ProfitLoss  AS ObjectExtId_Analyzer   -- Филиал (ОПиУ), а могло быть BranchId_Route
            , 0                                       AS ParentId
            , tmpProfitLoss.OperSumm
            , vbOperDate
            , FALSE                                   AS isActive               -- !!!ОПиУ всегда по Кредиту!!!
       FROM (SELECT _tmpItem_TransportSumm_Transport.MovementItemId
                  , _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                  , SUM (_tmpItem_TransportSumm_Transport.OperSumm) AS OperSumm
             FROM _tmpItem_TransportSumm_Transport
             GROUP BY _tmpItem_TransportSumm_Transport.MovementItemId, _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
            ) AS tmpProfitLoss
            JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = tmpProfitLoss.MovementItemId
       ;


     -- 1.1.2. формируются Проводки для количественного учета, !!!после прибыли, т.к. нужен ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItem_Transport.MovementItemId
            , _tmpItem_Transport.ContainerId_Goods
            , 0                                       AS AccountId              -- нет счета
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId             -- есть аналитика, т.е. то что относится к ОПиУ
            , _tmpItem_Transport.GoodsId              AS ObjectId_Analyzer      -- Товар
            , vbCarId                                 AS WhereObjectId_Analyzer -- Автомобиль
            , tmpProfitLoss.ContainerId_ProfitLoss    AS ContainerId_Analyzer   -- статья ОПиУ
            , _tmpItem_Transport.UnitId_ProfitLoss    AS ObjectIntId_Analyzer   -- Подраделение (ОПиУ), а могло быть UnitId_Route
            , _tmpItem_Transport.BranchId_ProfitLoss  AS ObjectExtId_Analyzer   -- Филиал (ОПиУ), а могло быть BranchId_Route
            , 0                                       AS ParentId
            , -1 * OperCount
            , vbOperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_Transport
           LEFT JOIN (SELECT DISTINCT _tmpItem_TransportSumm_Transport.MovementItemId, _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss FROM _tmpItem_TransportSumm_Transport
                     ) AS tmpProfitLoss ON tmpProfitLoss.MovementItemId = _tmpItem_Transport.MovementItemId;

     -- 1.2.2. формируются Проводки для суммового учета !!!после прибыли, т.к. нужен ContainerId_ProfitLoss!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_Summ.MovementItemId
            , _tmpItem_Summ.ContainerId
            , _tmpItem_Summ.AccountId                 AS AccountId              -- счет есть всегда
            , zc_Enum_AnalyzerId_ProfitLoss()         AS AnalyzerId             -- есть аналитика, т.е. то что относится к ОПиУ
            , _tmpItem_Transport.GoodsId              AS ObjectId_Analyzer      -- Товар
            , vbCarId                                 AS WhereObjectId_Analyzer -- Автомобиль
            , _tmpItem_Summ.ContainerId_ProfitLoss    AS ContainerId_Analyzer   -- статья ОПиУ
            , _tmpItem_Transport.UnitId_ProfitLoss    AS ObjectIntId_Analyzer   -- Подраделение (ОПиУ), а могло быть UnitId_Route
            , _tmpItem_Transport.BranchId_ProfitLoss  AS ObjectExtId_Analyzer   -- Филиал (ОПиУ), а могло быть BranchId_Route
            , 0                                       AS ParentId
            , -1 * _tmpItem_Summ.OperSumm
            , vbOperDate
            , FALSE                                   AS isActive
       FROM _tmpItem_TransportSumm_Transport AS _tmpItem_Summ
            JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = _tmpItem_Summ.MovementItemId
       ;

     -- 2.4. формируются Проводки - долг Сотруднику (ЗП) AND ОПиУ + !!!добавлен MovementItemId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, AccountId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, IsActive)
       WITH _tmpItem AS (SELECT _tmpItem_SummPersonal.MovementItemId
                              , _tmpItem_SummPersonal.ContainerId
                              , zc_Enum_AnalyzerId_Transport_Add()     AS AnalyzerId -- Сумма командировочные
                              , _tmpItem_SummPersonal.OperSumm_Add     AS OperSumm
                         FROM _tmpItem_SummPersonal
                         WHERE _tmpItem_SummPersonal.OperSumm_Add <> 0 -- !!!надо ограничивать!!!
                        UNION ALL
                         SELECT _tmpItem_SummPersonal.MovementItemId
                              , _tmpItem_SummPersonal.ContainerId
                              , zc_Enum_AnalyzerId_Transport_AddLong() AS AnalyzerId -- Сумма дальнобойные (тоже командировочные)
                              , _tmpItem_SummPersonal.OperSumm_AddLong AS OperSumm
                         FROM _tmpItem_SummPersonal
                         WHERE _tmpItem_SummPersonal.OperSumm_AddLong <> 0 -- !!!надо ограничивать!!!
                        UNION ALL
                         SELECT _tmpItem_SummPersonal.MovementItemId
                              , _tmpItem_SummPersonal.ContainerId
                              , zc_Enum_AnalyzerId_Transport_Taxi()    AS AnalyzerId -- Сумма на такси
                              , _tmpItem_SummPersonal.OperSumm_Taxi    AS OperSumm
                         FROM _tmpItem_SummPersonal
                         WHERE _tmpItem_SummPersonal.OperSumm_Taxi <> 0 -- !!!надо ограничивать!!!
                        )
       -- долг Сотруднику (ЗП)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId
            , _tmpItem_SummPersonal.AccountId         AS AccountId                -- счет есть всегда
            , _tmpItem.AnalyzerId                     AS AnalyzerId               -- есть аналитика, т.е. деление ...
            , _tmpItem_SummPersonal.PersonalId        AS ObjectId_Analyzer        -- Сотрудник (ЗП)
            , vbCarId                                 AS WhereObjectId_Analyzer   -- Автомобиль, а было Физ.лицо (ЗП) - vbMemberDriverId
            , _tmpItem_SummPersonal.ContainerId_ProfitLoss AS ContainerId_Analyzer -- Контейнер - ОПиУ (корреспондент)
            , zc_Enum_Account_100301()                AS AccountId_Analyzer       -- Счет - ОПиУ (корреспондент) - прибыль текущего периода
            , _tmpItem_SummPersonal.UnitId            AS ObjectIntId_Analyzer     -- !!!добавил Подразделение (ЗП)!!!
            , _tmpItem_SummPersonal.BranchId          AS ObjectExtId_Analyzer     -- Филиал (ЗП)
            , 0                                       AS ContainerIntId_Analyzer  -- вроде не нужен
            , 0                                       AS ParentId
            , -1 * (_tmpItem.OperSumm)
            , vbOperDate                              AS OperDate
            , TRUE                                    AS isActive
       FROM _tmpItem
            INNER JOIN _tmpItem_SummPersonal ON _tmpItem_SummPersonal.MovementItemId = _tmpItem.MovementItemId
                                            AND _tmpItem_SummPersonal.ContainerId    = _tmpItem.ContainerId
      UNION ALL
       -- Прибыль
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_SummPersonal.MovementItemId
            , _tmpItem_SummPersonal.ContainerId_ProfitLoss
            , zc_Enum_Account_100301()                AS AccountId                -- прибыль текущего периода
            , _tmpItem.AnalyzerId                     AS AnalyzerId               -- есть аналитика, т.е. деление ... !!!хотя в других проводках ОПиУ этого не делалось!!!
            , _tmpItem_SummPersonal.PersonalId        AS ObjectId_Analyzer        -- Сотрудник (ЗП)
            , vbCarId                                 AS WhereObjectId_Analyzer   -- Автомобиль, а было Физ.лицо (ЗП) - vbMemberDriverId
            , _tmpItem_SummPersonal.ContainerId       AS ContainerId_Analyzer     -- Контейнер - корреспондент
            , _tmpItem_SummPersonal.AccountId         AS AccountId_Analyzer       -- Счет - корреспондент
            , _tmpItem_SummPersonal.UnitId_ProfitLoss AS ObjectIntId_Analyzer     -- Подразделение (ОПиУ)
            , _tmpItem_SummPersonal.BranchId_ProfitLoss AS ObjectExtId_Analyzer   -- Филиал (ОПиУ), а может было б лучше BusinessId_ProfitLoss
            , 0                                       AS ContainerIntId_Analyzer  -- вроде не нужен
            , 0                                       AS ParentId
            , 1 * (_tmpItem.OperSumm)
            , vbOperDate                              AS OperDate
            , FALSE                                   AS isActive               -- !!!ОПиУ всегда по Кредиту!!!
       FROM _tmpItem
            INNER JOIN _tmpItem_SummPersonal ON _tmpItem_SummPersonal.MovementItemId = _tmpItem.MovementItemId
                                            AND _tmpItem_SummPersonal.ContainerId    = _tmpItem.ContainerId
      ;


     -- !!!Проводки для отчета больше не нужны!!!
     IF 1=0 THEN

     -- 3. формируются Проводки для отчета (Аналитики: Товар и Прибыль)
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem_Transport.MovementItemId
                                              , inActiveContainerId  := _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                                              , inPassiveContainerId := _tmpItem_TransportSumm_Transport.ContainerId
                                              , inActiveAccountId    := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                              , inPassiveAccountId   := _tmpItem_TransportSumm_Transport.AccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                                                                                                    , inPassiveContainerId := _tmpItem_TransportSumm_Transport.ContainerId
                                                                                                    , inActiveAccountId    := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                                                                                    , inPassiveAccountId   := _tmpItem_TransportSumm_Transport.AccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_TransportSumm_Transport.ContainerId_ProfitLoss
                                                                                                             , inPassiveContainerId := _tmpItem_TransportSumm_Transport.ContainerId
                                                                                                             , inActiveAccountId    := zc_Enum_Account_100301 () -- 100301; "прибыль текущего периода"
                                                                                                             , inPassiveAccountId   := _tmpItem_TransportSumm_Transport.AccountId
                                                                                                             , inAccountKindId_1    := NULL
                                                                                                             , inContainerId_1      := NULL
                                                                                                             , inAccountId_1        := NULL
                                                                                                     )
                                              , inAmount   := _tmpItem_TransportSumm_Transport.OperSumm
                                              , inOperDate := vbOperDate
                                               )
     FROM _tmpItem_TransportSumm_Transport
          LEFT JOIN _tmpItem_Transport ON _tmpItem_Transport.MovementItemId = _tmpItem_TransportSumm_Transport.MovementItemId
     WHERE _tmpItem_TransportSumm_Transport.OperSumm <> 0;

     END IF; -- if 1=0 -- !!!Проводки для отчета больше не нужны!!!


     -- !!!4. формируются свойства в элементах документа из данных для проводок!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(),        tmp.MovementItemId, tmp.UnitId_ProfitLoss)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(),      tmp.MovementItemId, tmp.BranchId_ProfitLoss)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Route(),       tmp.MovementItemId, tmp.RouteId_ProfitLoss)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_UnitRoute(),   tmp.MovementItemId, tmp.UnitId_Route)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_BranchRoute(), tmp.MovementItemId, tmp.BranchId_Route)
     FROM (SELECT DISTINCT _tmpItem_Transport.MovementItemId, _tmpItem_Transport.UnitId_ProfitLoss, _tmpItem_Transport.BranchId_ProfitLoss, _tmpItem_Transport.RouteId_ProfitLoss, _tmpItem_Transport.UnitId_Route, _tmpItem_Transport.BranchId_Route
           FROM _tmpItem_Transport
          ) AS tmp;


     -- 5.0. сохранили  "Сумма затрат" - расчет для удобства отображения в журналах
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCost(), inMovementId, tmp.AmountCost)
           , lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountMemberCost(), inMovementId, tmp.AmountMemberCost)
     FROM (SELECT (SELECT SUM (_tmpItem_TransportSumm_Transport.OperSumm) FROM _tmpItem_TransportSumm_Transport) AS AmountCost
                , (SELECT SUM (tmpItem.OperSumm_Add + tmpItem.OperSumm_AddLong + tmpItem.OperSumm_Taxi) FROM _tmpItem_SummPersonal AS tmpItem) AS AmountMemberCost
          ) AS tmp
     ;

     -- 5.1. ФИНИШ - Обязательно сохраняем Проводки
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Transport()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 11.03.14                                        * err on zc_MIFloat_StartAmountFuel
 26.01.14                                        * правильные проводки по филиалу
 21.12.13                                        * Personal -> Member
 11.12.13                                        * убрал пересчитали Child - нормы
 03.11.13                                        * add zc_MILinkObject_Route
 02.11.13                                        * add zc_MILinkObject_Branch, zc_MILinkObject_UnitRoute, zc_MILinkObject_BranchRoute
 02.11.13                                        * group AS _tmpItem_Transport
 27.10.13                                        * err zc_MovementFloat_StartAmountTicketFuel
 26.10.13                                        * add !!!обязательно!!! очистили таблицу...
 26.10.13                                        * err
 25.10.13                                        * add lpInsertUpdate_MI_Transport_Child_byMaster
 21.10.13                                        * err ObjectId IN (SELECT GoodsId...
 14.10.13                                        * add lpInsertUpdate_MovementItemLinkObject
 06.10.13                                        * add inUserId
 02.10.13                                        * add BusinessId_Route
 02.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_Transport (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
