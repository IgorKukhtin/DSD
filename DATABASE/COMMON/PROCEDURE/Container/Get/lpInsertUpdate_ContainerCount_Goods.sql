-- Function: lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Goods (
    IN inOperDate               TDateTime, 
    IN inUnitId                 Integer , 
    IN inCarId                  Integer , 
    IN inMemberId               Integer , 
    IN inInfoMoneyDestinationId Integer , 
    IN inGoodsId                Integer , 
    IN inGoodsKindId            Integer , 
    IN inIsPartionCount         Boolean , 
    IN inPartionGoodsId         Integer , 
    IN inAssetId                Integer , 
    IN inBranchId               Integer , -- эта аналитика нужна для филиала
    IN inAccountId              Integer   -- эта аналитика нужна для "товар в пути"
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     -- 10100 Мясное сырье
     IF inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
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
                                                 , inObjectId_1        := inPartionGoodsId -- CASE WHEN inIsPartionCount THEN inPartionGoodsId ELSE 0 END
                                                 , inDescId_2          := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2        := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId ELSE COALESCE (inUnitId, 0) END
                                                 , inDescId_3          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_3        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                  );
     ELSE
     -- 20100 Запчасти и Ремонты + 20400 ГСМ
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100(), zc_Enum_InfoMoneyDestination_20400())
          -- 0)Товар 1)Подразделение 2)Основные средства(для которого закуплено ТМЦ)
          -- 0)Товар 1)Сотрудник (МО) 2)Основные средства(для которого закуплено ТМЦ)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN zc_ContainerLinkObject_Car() WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN inCarId WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId ELSE COALESCE (inUnitId, 0) END
                                                 , inDescId_2          := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_2        := inAssetId
                                                 , inDescId_3          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_3        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                  );
     ELSE
     -- 20200 Прочие ТМЦ + 20300 МНМА
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300())
          -- 0)Товар 1)Подразделение 2)Сотрудник (МО) 3)!Партия товара!
          -- 0)Товар 1)Автомобиль 2)Сотрудник (МО) 3)!Партия товара!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN zc_ContainerLinkObject_Car() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inCarId, 0) <> 0 THEN inCarId ELSE inUnitId END
                                                 , inDescId_2          := zc_ContainerLinkObject_Member()
                                                 , inObjectId_2        := inMemberId
                                                 , inDescId_3          := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_3        := inPartionGoodsId
                                                 , inDescId_4          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_4        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                  );
     ELSE
     -- 20700 Товары + 20900 Ирна + 30100 Продукция + 30200 Мясное сырье
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200())
          -- 0)Товар 1)Подразделение 2)Вид товара 3)!!!Партия товара!!!
          -- 0)Товар 1)Сотрудник (МО) 2)Вид товара 3)!!!Партия товара!!!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId ELSE COALESCE (inUnitId, 0) END
                                                 , inDescId_2          := zc_ContainerLinkObject_GoodsKind()
                                                 , inObjectId_2        := CASE WHEN COALESCE (inBranchId, 0) IN (0
                                                                                                               , zc_Branch_Basis()
                                                                                                               , 8374   -- !!!+ филиал Одесса!!!    select * from Object where ObjectCode=4 and DescId = zc_Object_Branch()
                                                                                                               , 8376   -- !!!+ филиал Крым!!!      select * from Object where ObjectCode=6 and DescId = zc_Object_Branch()
                                                                                                               , 18342  -- !!!+ филиал Никополь!!!  select * from Object where ObjectCode=10 and DescId = zc_Object_Branch()
                                                                                                               , 301310 -- !!!+ филиал Запорожье!!! select * from Object where ObjectCode=11 and DescId = zc_Object_Branch()
                                                                                                                ) THEN inGoodsKindId ELSE 0 END 
                                                 , inDescId_3          := CASE WHEN inPartionGoodsId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                 , inObjectId_3        := CASE WHEN inPartionGoodsId <> 0 THEN inPartionGoodsId ELSE NULL END
                                                 , inDescId_4          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_4        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                  );
     -- !!!Other!!!
          -- 0)Товар 1)Подразделение
          -- 0)Товар 1)Сотрудник (МО)
     ELSE vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId ELSE COALESCE (inUnitId, 0) END
                                                 , inDescId_2          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_2        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                   );
     END IF;
     END IF;
     END IF;
     END IF;

     -- Возвращаем значение
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.11.14                                        * add inAccountId
 08.11.14                                        * add !!!+ филиал Запорожье!!
 17.08.14                                        * add inPartionGoodsId always
 27.07.14                                        * add МНМА
 18.03.14                                        * add zc_Enum_InfoMoneyDestination_30200
 21.12.13                                        * Personal -> Member
 11.10.13                                        * add zc_Enum_InfoMoneyDestination_20400
 30.09.13                                        * add inCarId
 19.09.13                                        * sort by optimize
 17.09.13                                        * CASE -> IF
 16.09.13                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_ContainerCount_Goods ()