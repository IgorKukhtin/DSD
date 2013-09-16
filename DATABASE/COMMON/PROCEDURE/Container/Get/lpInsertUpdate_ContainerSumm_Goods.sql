-- Function: lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

-- DROP FUNCTION lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerSumm_Goods (
    IN inOperDate               TDateTime, 
    IN inUnitId                 Integer , 
    IN inPersonalId             Integer , 
    IN inBranchId               Integer , 
    IN inJuridicalId_basis      Integer , 
    IN inBusinessId             Integer , 
    IN inAccountId              Integer , 
    IN inInfoMoneyDestinationId Integer , 
    IN inInfoMoneyId            Integer , 
    IN inInfoMoneyId_Detail     Integer , 
    IN inContainerId_Goods      Integer , 
    IN inGoodsId                Integer , 
    IN inGoodsKindId            Integer , 
    IN inIsPartionSumm          Boolean , 
    IN inPartionGoodsId         Integer , 
    IN inAssetId                Integer
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     SELECT CASE WHEN inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)!Партии товара! 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудник (МО) 2)Товар 3)!Партии товара! 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                      THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := zc_ObjectCost_Basis()
                                                                          -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)!Подразделение! 5)Товар 6)!Партии товара! 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                                          -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Сотрудник (МО) 5)Товар 6)!Партии товара! 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                 , inObjectCostId      := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                 , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                 , inObjectId_1 := inJuridicalId_basis
                                                                                                 , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                 , inObjectId_2 := inBusinessId
                                                                                                 , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                 , inObjectId_3 := inBranchId
                                                                                                 , inDescId_4   := CASE WHEN inPersonalId <> 0 THEN zc_ObjectCostLink_Personal() ELSE zc_ObjectCostLink_Unit() END
                                                                                                 , inObjectId_4 := CASE WHEN inPersonalId <> 0 AND inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inPersonalId WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inUnitId ELSE NULL END
                                                                                                 , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                 , inObjectId_5 := inGoodsId
                                                                                                 , inDescId_6   := zc_ObjectCostLink_PartionGoods()
                                                                                                 , inObjectId_6 := CASE WHEN inIsPartionSumm THEN inPartionGoodsId ELSE NULL END
                                                                                                 , inDescId_7   := zc_ObjectCostLink_InfoMoney()
                                                                                                 , inObjectId_7 := inInfoMoneyId
                                                                                                 , inDescId_8   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                 , inObjectId_8 := inInfoMoneyId_Detail
                                                                                                  )
                                                 , inDescId_1   := CASE WHEN inPersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1 := CASE WHEN inPersonalId <> 0 THEN inPersonalId ELSE inUnitId END
                                                                                                      , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                      , inObjectId_2 := inGoodsId
                                                                                                      , inDescId_3   := zc_ContainerLinkObject_PartionGoods()
                                                                                                      , inObjectId_3 := CASE WHEN inIsPartionSumm THEN inPartionGoodsId ELSE NULL END
                                                                                                      , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                      , inObjectId_4 := inInfoMoneyId
                                                                                                      , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                      , inObjectId_5 := inInfoMoneyId_Detail
                                                                                                       )
                 WHEN inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)Основные средства(для которого закуплено ТМЦ) 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудник (МО) 2)Товар 3)Основные средства(для которого закуплено ТМЦ) 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                      THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := zc_ObjectCost_Basis()
                                                                          -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)!Подразделение! 5)Товар 6)Основные средства(для которого закуплено ТМЦ) 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                                          -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Сотрудник (МО) 5)Товар 6)Основные средства(для которого закуплено ТМЦ) 7)Статьи назначения 8)Статьи назначения(детализация с/с)
                                                 , inObjectCostId      := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                 , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                 , inObjectId_1 := inJuridicalId_basis
                                                                                                 , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                 , inObjectId_2 := inBusinessId
                                                                                                 , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                 , inObjectId_3 := inBranchId
                                                                                                 , inDescId_4   := CASE WHEN inPersonalId <> 0 THEN zc_ObjectCostLink_Personal() ELSE zc_ObjectCostLink_Unit() END
                                                                                                 , inObjectId_4 := CASE WHEN inPersonalId <> 0 AND inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inPersonalId WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inUnitId ELSE NULL END
                                                                                                 , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                 , inObjectId_5 := inGoodsId
                                                                                                 , inDescId_6   := zc_ObjectCostLink_AssetTo()
                                                                                                 , inObjectId_6 := inAssetId
                                                                                                 , inDescId_7   := zc_ObjectCostLink_InfoMoney()
                                                                                                 , inObjectId_7 := inInfoMoneyId
                                                                                                 , inDescId_8   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                 , inObjectId_8 := inInfoMoneyId_Detail
                                                                                                  )
                                                 , inDescId_1   := CASE WHEN inPersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1 := CASE WHEN inPersonalId <> 0 THEN inPersonalId ELSE inUnitId END
                                                 , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_2 := inGoodsId
                                                 , inDescId_3   := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_3 := inAssetId
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_5 := inInfoMoneyId_Detail
                                                  )
                 WHEN inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700()  -- Товары    -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                 , zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                                 , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)!!!Партии товара!!! 4)Виды товаров 5)Статьи назначения 6)Статьи назначения(детализация с/с)
                                                                                -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудник (МО) 2)Товар 3)!!!Партии товара!!! 4)Виды товаров 5)Статьи назначения 6)Статьи назначения(детализация с/с)
                      THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := zc_ObjectCost_Basis()
                                                                          -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Подразделение 5)Товар 6)!!!Партии товара!!! 7)Виды товаров 8)Статьи назначения 9)Статьи назначения(детализация с/с)
                                                                          -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Сотрудник (МО) 5)Товар 6)!!!Партии товара!!! 7)Виды товаров 8)Статьи назначения 9)Статьи назначения(детализация с/с)
                                                 , inObjectCostId      := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                 , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                 , inObjectId_1 := inJuridicalId_basis
                                                                                                 , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                 , inObjectId_2 := inBusinessId
                                                                                                 , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                 , inObjectId_3 := inBranchId
                                                                                                 , inDescId_4   := CASE WHEN inPersonalId <> 0 THEN zc_ObjectCostLink_Personal() ELSE zc_ObjectCostLink_Unit() END
                                                                                                 , inObjectId_4 := CASE WHEN inPersonalId <> 0 THEN inPersonalId ELSE inUnitId END
                                                                                                 , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                 , inObjectId_5 := inGoodsId
                                                                                                 , inDescId_6   := CASE WHEN inPartionGoodsId <> 0 THEN zc_ObjectCostLink_PartionGoods() ELSE NULL END
                                                                                                 , inObjectId_6 := CASE WHEN inPartionGoodsId <> 0 THEN inPartionGoodsId ELSE NULL END
                                                                                                 , inDescId_7   := zc_ObjectCostLink_GoodsKind()
                                                                                                 , inObjectId_7 := inGoodsKindId
                                                                                                 , inDescId_8   := zc_ObjectCostLink_InfoMoney()
                                                                                                 , inObjectId_8 := inInfoMoneyId
                                                                                                 , inDescId_9   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                 , inObjectId_9 := inInfoMoneyId_Detail
                                                                                                  )
                                                 , inDescId_1   := CASE WHEN inPersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1 := CASE WHEN inPersonalId <> 0 THEN inPersonalId ELSE inUnitId END
                                                 , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_2 := inGoodsId
                                                 , inDescId_3   := CASE WHEN inPartionGoodsId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                 , inObjectId_3 := CASE WHEN inPartionGoodsId <> 0 THEN inPartionGoodsId ELSE NULL END
                                                 , inDescId_4   := zc_ContainerLinkObject_GoodsKind()
                                                 , inObjectId_4 := inGoodsKindId
                                                 , inDescId_5   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_5 := inInfoMoneyId
                                                 , inDescId_6   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_6 := inInfoMoneyId_Detail
                                                  )
                 WHEN inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500()) -- 20500; "Оборотная тара" -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500()
                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Товар 2)Статьи назначения 3)Статьи назначения(детализация с/с)
                      THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := NULL -- !!!Суммовая проводка не связана с количественной!!!
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := zc_ObjectCost_Basis()
                                                                          -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Товар 4)Статьи назначения 5)Статьи назначения(детализация с/с)
                                                 , inObjectCostId      := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                                 , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                                 , inObjectId_1 := inJuridicalId_basis
                                                                                                 , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                                 , inObjectId_2 := inBusinessId
                                                                                                 , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                                 , inObjectId_3 := NULL
                                                                                                 , inDescId_4   := zc_ObjectCostLink_Unit()
                                                                                                 , inObjectId_4 := NULL
                                                                                                 , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                                 , inObjectId_5 := inGoodsId
                                                                                                 , inDescId_6   := zc_ObjectCostLink_InfoMoney()
                                                                                                 , inObjectId_6 := inInfoMoneyId
                                                                                                 , inDescId_7   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                                 , inObjectId_7 := inInfoMoneyId_Detail
                                                                                                  )
                                                 , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                 , inObjectId_1 := NULL
                                                 , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_2 := inGoodsId
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_5 := inInfoMoneyId_Detail
                                                  )
                      -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение 2)Товар 3)Статьи назначения 4)Статьи назначения(детализация с/с)
                      -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Сотрудник (МО) 2)Товар 3)Статьи назначения 4)Статьи назначения(детализация с/с)
                 ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                            , inParentId          := inContainerId_Goods
                                            , inObjectId          := inAccountId
                                            , inJuridicalId_basis := inJuridicalId_basis
                                            , inBusinessId        := inBusinessId
                                            , inObjectCostDescId  := zc_ObjectCost_Basis()
                                                                     -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)!Подразделение! 5)Товар 6)Статьи назначения 7)Статьи назначения(детализация с/с)
                                                                     -- <элемент с/с>: 1.)Главное Юр лицо 2.)Бизнес 3)Филиал 4)Сотрудник (МО) 5)Товар 6)Статьи назначения 7)Статьи назначения(детализация с/с)
                                            , inObjectCostId      := lpInsertFind_ObjectCost (inObjectCostDescId:= zc_ObjectCost_Basis()
                                                                                            , inDescId_1   := zc_ObjectCostLink_JuridicalBasis()
                                                                                            , inObjectId_1 := inJuridicalId_basis
                                                                                            , inDescId_2   := zc_ObjectCostLink_Business()
                                                                                            , inObjectId_2 := inBusinessId
                                                                                            , inDescId_3   := zc_ObjectCostLink_Branch()
                                                                                            , inObjectId_3 := inBranchId
                                                                                            , inDescId_4   := CASE WHEN inPersonalId <> 0 THEN zc_ObjectCostLink_Personal() ELSE zc_ObjectCostLink_Unit() END
                                                                                            , inObjectId_4 := CASE WHEN inPersonalId <> 0 AND inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inPersonalId WHEN inOperDate >= zc_DateStart_ObjectCostOnUnit() THEN inUnitId ELSE NULL END
                                                                                            , inDescId_5   := zc_ObjectCostLink_Goods()
                                                                                            , inObjectId_5 := inGoodsId
                                                                                            , inDescId_6   := zc_ObjectCostLink_InfoMoney()
                                                                                            , inObjectId_6 := inInfoMoneyId
                                                                                            , inDescId_7   := zc_ObjectCostLink_InfoMoneyDetail()
                                                                                            , inObjectId_7 := inInfoMoneyId_Detail
                                                                                             )
                                            , inDescId_1   := CASE WHEN inPersonalId <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                            , inObjectId_1 := CASE WHEN inPersonalId <> 0 THEN inPersonalId ELSE inUnitId END
                                            , inDescId_2   := zc_ContainerLinkObject_Goods()
                                            , inObjectId_2 := inGoodsId
                                            , inDescId_3   := zc_ContainerLinkObject_InfoMoney()
                                            , inObjectId_3 := inInfoMoneyId
                                            , inDescId_4   := zc_ContainerLinkObject_InfoMoneyDetail()
                                            , inObjectId_4 := inInfoMoneyId_Detail
                                             )
            END
            INTO vbContainerId;


     -- Возвращаем значение
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.09.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_ContainerSumm_Goods ()