-- Function: lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

-- DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Goods (
    IN inOperDate               TDateTime,
    IN inUnitId                 Integer ,
    IN inCarId                  Integer ,
    IN inMemberId               Integer ,
    IN inInfoMoneyDestinationId Integer ,
    IN inInfoMoneyId            Integer ,
    IN inGoodsId                Integer ,
    IN inGoodsKindId            Integer ,
    IN inIsPartionCount         Boolean ,
    IN inPartionGoodsId         Integer ,
    IN inAssetId                Integer ,
    IN inBranchId               Integer , -- эта аналитика нужна для филиала
    IN inAccountId              Integer   -- эта аналитика нужна для "товар в пути / виртуальный склад"
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     -- 1.0. - 70000 Инвестиции: Капитальные инвестиции + Капитальный ремонт + Долгосрочные инвестиции + Капитальное строительство
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_70100(), zc_Enum_InfoMoneyDestination_70200(), zc_Enum_InfoMoneyDestination_70300(), zc_Enum_InfoMoneyDestination_70400()
                                    )
    AND inPartionGoodsId <> 0
     THEN
         -- !!!обнулили!!!
         inAccountId:= 0;

                           -- 0)Товар или ОС 1)Подразделение  2)Партия товара 3)Основные средства (для которого закуплено ОС или ТМЦ)
                           -- 0)Товар или ОС 1)Физ. лицо (МО) 2)Партия товара 3)Основные средства (для которого закуплено ОС или ТМЦ)
                           -- 0)Товар или ОС 1)Автомобиль     2)Партия товара 3)Основные средства (для которого закуплено ОС или ТМЦ)
          vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_2          := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_2        := inPartionGoodsId
                                                 , inDescId_3          := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_3        := inAssetId
                                                  );

     ELSE
     -- 1.1. - 10100 Мясное сырье
     IF inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
     THEN
          -- IF 1=1 THEN inGoodsKindId:= 0; END IF;

          -- замена для цех колбасный + цех с/к + цех деликатесов + цех тушенка + ирна склады хранения + ирна цех колбасный
          IF inOperDate < '01.01.2024' AND inUnitId IN (8447    -- ЦЕХ ковбасних виробів
                                                      , 8449    -- Цех сирокопчених ковбас
                                                      , 8448    -- Дільниця делікатесів
                                                      , 2790412 -- ЦЕХ Тушенка
                                                        --
                                                      , 8020711 -- ЦЕХ колбасный (Ирна)
                                                      , 8020708 -- Склад МИНУСОВКА (Ирна)
                                                      , 8020709 -- Склад ОХЛАЖДЕНКА (Ирна)
                                                      , 8020710 -- Участок мясного сырья (Ирна)
                                                       )
          THEN inGoodsKindId:= 0;
          END IF;
         
          -- 0)Товар 1)Подразделение 2)!Партия товара! 3)Вид товара - не всегда 4)Счет - не всегда
          -- 0)Товар 1)Физ. лицо (МО) 2)!Партия товара! 3)Вид товара - не всегда 4)Счет - не всегда
          vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_1        := inPartionGoodsId -- CASE WHEN inIsPartionCount THEN inPartionGoodsId ELSE 0 END
                                                 , inDescId_2          := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2        := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_3          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_3        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                 , inDescId_4          := CASE WHEN COALESCE (inGoodsKindId, 0) IN (0, zc_GoodsKind_Basis()) THEN NULL ELSE zc_ContainerLinkObject_GoodsKind() END
                                                 , inObjectId_4        := CASE WHEN COALESCE (inGoodsKindId, 0) IN (0, zc_GoodsKind_Basis()) THEN NULL ELSE inGoodsKindId END
                                                  );
     ELSE
     -- 1.2. - 20400 ГСМ + 70000 Инвестиции: Капитальные инвестиции + Капитальный ремонт + Долгосрочные инвестиции + Капитальное строительство
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20400()
                                   , zc_Enum_InfoMoneyDestination_70100(), zc_Enum_InfoMoneyDestination_70200(), zc_Enum_InfoMoneyDestination_70300(), zc_Enum_InfoMoneyDestination_70400()
                                    )
                           -- 0)Товар 1)Подразделение 2)Основные средства(для которого закуплено ТМЦ)
                           -- 0)Товар 1)Физ. лицо (МО) 2)Основные средства(для которого закуплено ТМЦ)
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_2          := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_2        := inAssetId
                                                 , inDescId_3          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_3        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                  );
     ELSE
     -- 1.3. - 20103 Запчасти и Ремонты + Шины
     IF inInfoMoneyId IN (zc_Enum_InfoMoney_20103())
         AND inPartionGoodsId > 0
                           -- 0)Товар 1)Автомобиль / Физ.лицо(МО) / Подразделение 2)Партия товара 2)Основные средства(для которого закуплено ТМЦ) 3) Партия
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_2          := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_2        := inAssetId
                                                 , inDescId_3          := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_3        := inPartionGoodsId
                                                 , inDescId_4          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_4        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                  );
     ELSE
     -- 1.4. - 20100 Запчасти и Ремонты
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100())
                           -- 0)Товар 1)Автомобиль / Физ.лицо(МО) / Подразделение 2)Основные средства(для которого закуплено ТМЦ) 3) Партия
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_2          := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_2        := inAssetId
                                                 , inDescId_3          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                 , inObjectId_3        := CASE WHEN inMemberId <> 0 THEN inPartionGoodsId                      ELSE NULL END
                                                 , inDescId_4          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_4        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                  );
     ELSE
     -- 1.5. - 20200 Прочие ТМЦ + 20300 МНМА
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20200(), zc_Enum_InfoMoneyDestination_20300())
          -- 0)Товар 1)Автомобиль / Подразделение 2)Физ. лицо(МО) 3)!Партия товара!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN inCarId <> 0 THEN inCarId                      ELSE COALESCE (inUnitId, 0)        END
                                                 , inDescId_2          := zc_ContainerLinkObject_Member()
                                                 , inObjectId_2        := inMemberId
                                                 , inDescId_3          := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_3        := inPartionGoodsId
                                                 , inDescId_4          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_4        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                  );
     ELSE
     -- 1.6. - 20700 Товары + 20900 Ирна + 30100 Продукция + 30200 Мясное сырье
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200())
          -- 0)Товар 1)Подразделение  2)Вид товара 3)!!!Партия товара!!!
          -- 0)Товар 1)Физ. лицо (МО) 2)Вид товара 3)!!!Партия товара!!!
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_2          := zc_ContainerLinkObject_GoodsKind()
                                                 , inObjectId_2        := CASE WHEN COALESCE (inBranchId, 0) IN (0
                                                                                                               , zc_Branch_Basis()
                                                                                                               , 8374   -- !!!+ филиал Одесса!!!    select * from Object where ObjectCode=4 and DescId = zc_Object_Branch()
                                                                                                               , 8376   -- !!!+ филиал Крым!!!      select * from Object where ObjectCode=6 and DescId = zc_Object_Branch()
                                                                                                               , 18342  -- !!!+ филиал Никополь!!!  select * from Object where ObjectCode=10 and DescId = zc_Object_Branch()
                                                                                                               , 301310 -- !!!+ филиал Запорожье!!! select * from Object where ObjectCode=11 and DescId = zc_Object_Branch()
                                                                                                                )
                                                                                    THEN inGoodsKindId
                                                                               WHEN inOperDate >= '01.11.2015' AND inBranchId IN (
                                                                                                                 8381 -- филиал Харьков
                                                                                                               , 8377 -- филиал Кр.Рог
                                                                                                               , 8375 -- филиал Черкассы (Кировоград)
                                                                                                               , 8373 -- филиал Николаев (Херсон)
                                                                                                               -- , 8379 -- филиал Киев
                                                                                                                )
                                                                                    THEN inGoodsKindId
                                                                               WHEN inOperDate >= '01.01.2016' AND inBranchId IN (
                                                                                                                 8379 -- филиал Киев
                                                                                                                )
                                                                                    THEN inGoodsKindId
                                                                               WHEN inOperDate >= '01.01.2017'
                                                                                    THEN inGoodsKindId
                                                                               ELSE 0
                                                                          END
                                                 , inDescId_3          := CASE WHEN inPartionGoodsId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                 , inObjectId_3        := CASE WHEN inPartionGoodsId <> 0 THEN inPartionGoodsId ELSE NULL END
                                                 , inDescId_4          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_4        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                  );
     -- 2.1. !!!Other!!!
          -- 0)Товар 1)Подразделение
          -- 0)Товар 1)Физ. лицо (МО)
     ELSE vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_1        := CASE WHEN COALESCE (inMemberId, 0) <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_2          := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN zc_ContainerLinkObject_Account() ELSE NULL END
                                                 , inObjectId_2        := CASE WHEN COALESCE (inAccountId, 0) <> 0 THEN inAccountId ELSE NULL END
                                                 , inDescId_5   := CASE WHEN inMemberId <> 0 THEN 0 WHEN inPartionGoodsId <> 0 THEN zc_ContainerLinkObject_PartionGoods() ELSE NULL END
                                                 , inObjectId_5 := CASE WHEN inMemberId <> 0 THEN 0 WHEN inPartionGoodsId <> 0 THEN inPartionGoodsId ELSE NULL END
                                                   );
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;

     -- Возвращаем значение
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

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