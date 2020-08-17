-- Function: lpInsertUpdate_ContainerSumm_Asset (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Asset (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerSumm_Asset (
    IN inOperDate               TDateTime, 
    IN inUnitId                 Integer , 
    IN inCarId                  Integer , 
    IN inMemberId               Integer , 
    IN inBranchId               Integer , -- эта аналитика нужна для филиала
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



     -- 70000 Инвестиции: Капитальные инвестиции + Капитальный ремонт + Долгосрочные инвестиции + Капитальное строительство
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_70100(), zc_Enum_InfoMoneyDestination_70200(), zc_Enum_InfoMoneyDestination_70300(), zc_Enum_InfoMoneyDestination_70400()
                                    )
    AND inPartionGoodsId <> 0
     THEN
                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение  2)Товар или ОС 3)Партии товара 4)Основные средства (для которого закуплено ОС или ТМЦ) 5)Статьи назначения 6)Статьи назначения(детализация с/с)
                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Физ. лицо (МО) 2)Товар или ОС 3)Партии товара 4)Основные средства (для которого закуплено ОС или ТМЦ) 5)Статьи назначения 6)Статьи назначения(детализация с/с)
                           -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Автомобиль     2)Товар или ОС 3)Партии товара 4)Основные средства (для которого закуплено ОС или ТМЦ) 5)Статьи назначения 6)Статьи назначения(детализация с/с)
          vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_SummAsset()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1 := inGoodsId
                                                 , inDescId_2   := CASE WHEN inCarId <> 0 THEN zc_ContainerLinkObject_Car() WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2 := CASE WHEN inCarId <> 0 THEN inCarId                      WHEN inMemberId <> 0 THEN inMemberId                      ELSE CASE WHEN inUnitId <> 0 THEN inUnitId ELSE zc_Juridical_Basis() END END
                                                 , inDescId_3   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_3 := inInfoMoneyId_Detail
                                                 , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_4 := inInfoMoneyId
                                                 , inDescId_5   := zc_ContainerLinkObject_PartionGoods()
                                                 , inObjectId_5 := inPartionGoodsId
                                                 , inDescId_6   := zc_ContainerLinkObject_AssetTo()
                                                 , inObjectId_6 := inAssetId
                                                  );

     ELSE
         RAISE EXCEPTION 'Ошибка.забалансовай счет не предусмотрен для <%>', lfGet_Object_ValueData (inInfoMoneyDestinationId);
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
 05.08.20                                        *

*/

-- тест
-- SELECT * FROM lpInsertUpdate_ContainerSumm_Asset ()
