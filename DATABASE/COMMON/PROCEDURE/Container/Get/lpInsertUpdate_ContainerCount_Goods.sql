-- Function: lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Goods (
    IN inOperDate               TDateTime, 
    IN inUnitId                 Integer , 
    IN inCarId                  Integer , 
    IN inPersonalId             Integer , 
    IN inInfoMoneyDestinationId Integer , 
    IN inGoodsId                Integer , 
    IN inGoodsKindId            Integer , 
    IN inIsPartionCount         Boolean , 
    IN inPartionGoodsId         Integer , 
    IN inAssetId                Integer
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     IF inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Мясное сырье -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
          -- 0)Товар 1)Подразделение 2)!Партия товара!
          -- 0)Товар 1)Сотрудник (МО) 2)!Партия товара!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_1        := CASE WHEN inIsPartionCount THEN inPartionGoodsId ELSE 0 END
                                                 , inDescId_2          := CASE WHEN COALESCE (inPersonalId, 0) <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2        := CASE WHEN COALESCE (inPersonalId, 0) <> 0 THEN inPersonalId ELSE COALESCE (inUnitId, 0) END
                                                   );
     ELSE
     IF inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
          -- 0)Товар 1)Подразделение 2)Основные средства(для которого закуплено ТМЦ)
          -- 0)Товар 1)Сотрудник (МО) 2)Основные средства(для которого закуплено ТМЦ)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN zc_ContainerLinkObject_Car() WHEN COALESCE (inPersonalId, 0) <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN inCarId WHEN COALESCE (inPersonalId, 0) <> 0 THEN inPersonalId ELSE COALESCE (inUnitId, 0) END
                                                 , inDescId_2          := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_2        := inAssetId
                                                   );
     ELSE
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700()  -- Товары    -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                   , zc_Enum_InfoMoneyDestination_20900()  -- Ирна      -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()
                                   , zc_Enum_InfoMoneyDestination_30100()) -- Продукция -- select * from lfSelect_Object_InfoMoney() where inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
          -- 0)Товар 1)Подразделение 2)Вид товара 3)!!!Партия товара!!!
          -- 0)Товар 1)Сотрудник (МО) 2)Вид товара 3)!!!Партия товара!!!
     THEN vbContainerId := CASE WHEN inPartionGoodsId <> 0
                                     THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                                , inParentId          := NULL
                                                                , inObjectId          := inGoodsId
                                                                , inJuridicalId_basis := NULL
                                                                , inBusinessId        := NULL
                                                                , inObjectCostDescId  := NULL
                                                                , inObjectCostId      := NULL
                                                                , inDescId_1          := zc_ContainerLinkObject_PartionGoods()
                                                                , inObjectId_1        := inPartionGoodsId
                                                                , inDescId_2          := CASE WHEN COALESCE (inPersonalId, 0) <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                                , inObjectId_2        := CASE WHEN COALESCE (inPersonalId, 0) <> 0 THEN inPersonalId ELSE COALESCE (inUnitId, 0) END
                                                                , inDescId_3          := zc_ContainerLinkObject_GoodsKind()
                                                                , inObjectId_3        := inGoodsKindId
                                                                 )
                                ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                           , inParentId          := NULL
                                                           , inObjectId          := inGoodsId
                                                           , inJuridicalId_basis := NULL
                                                           , inBusinessId        := NULL
                                                           , inObjectCostDescId  := NULL
                                                           , inObjectCostId      := NULL
                                                           , inDescId_1          := CASE WHEN COALESCE (inPersonalId, 0) <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                           , inObjectId_1        := CASE WHEN COALESCE (inPersonalId, 0) <> 0 THEN inPersonalId ELSE COALESCE (inUnitId, 0) END
                                                           , inDescId_2          := zc_ContainerLinkObject_GoodsKind()
                                                           , inObjectId_2        := inGoodsKindId
                                                            )
                           END ;
          -- 0)Товар 1)Подразделение
          -- 0)Товар 1)Сотрудник (МО)
     ELSE vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inPersonalId, 0) <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inPersonalId, 0) <> 0 THEN inPersonalId ELSE COALESCE (inUnitId, 0) END
                                                   );
     END IF;
     END IF;
     END IF;

     -- Возвращаем значение
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13                                        * add inCarId
 19.09.13                                        * sort by optimize
 17.09.13                                        * CASE -> IF
 16.09.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_ContainerCount_Goods ()