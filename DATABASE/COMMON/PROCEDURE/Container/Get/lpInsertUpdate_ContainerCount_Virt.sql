-- Function: lpInsertUpdate_ContainerCount_Virt (TDateTime, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Virt (TDateTime, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Virt (
    IN inOperDate               TDateTime,
    IN inUnitId                 Integer ,
    IN inInfoMoneyDestinationId Integer ,
    IN inInfoMoneyId            Integer ,
    IN inGoodsId                Integer ,
    IN inGoodsKindId            Integer ,
)
  RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     -- 1. - 20700 Товары + 20900 Ирна + 30100 Продукция
     IF inInfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_30100())
     THEN vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_CountVirt()
                                                 , inParentId          := NULL
                                                 , inObjectId          := inGoodsId
                                                 , inJuridicalId_basis := NULL
                                                 , inBusinessId        := NULL
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1          := zc_ContainerLinkObject_Unit()
                                                 , inObjectId_1        := inUnitId
                                                 , inDescId_2          := zc_ContainerLinkObject_GoodsKind()
                                                 , inObjectId_2        := inGoodsKindId
                                                  );
     -- 2.1. !!!Other!!!
     ELSE
         vbContainerId:= 0;
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
 20.07.26                                        * add inAccountId
*/

-- тест
-- SELECT * FROM lpInsertUpdate_ContainerCount_Virt ()