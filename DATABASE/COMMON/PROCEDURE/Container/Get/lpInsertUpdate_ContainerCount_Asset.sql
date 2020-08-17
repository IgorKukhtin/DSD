-- Function: lpInsertUpdate_ContainerCount_Asset (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Asset (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Asset (
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
    IN inAccountId              Integer   -- эта аналитика нужна для "товар в пути / виртуальный склад"
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
         -- !!!обнулили!!!
         inAccountId:= 0;

                           -- 0)Товар или ОС 1)Подразделение  2)Партия товара 3)Основные средства (для которого закуплено ОС или ТМЦ)
                           -- 0)Товар или ОС 1)Физ. лицо (МО) 2)Партия товара 3)Основные средства (для которого закуплено ОС или ТМЦ)
                           -- 0)Товар или ОС 1)Автомобиль     2)Партия товара 3)Основные средства (для которого закуплено ОС или ТМЦ)
          vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_CountAsset()
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
-- SELECT * FROM lpInsertUpdate_ContainerCount_Asset ()
