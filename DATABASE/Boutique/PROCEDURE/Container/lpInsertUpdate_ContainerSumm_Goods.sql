-- Function: lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerSumm_Goods (
    IN inOperDate                TDateTime, 
    IN inUnitId                  Integer  , 
    IN inMemberId                Integer  , 
    IN inJuridicalId_basis       Integer  , 
    IN inBusinessId              Integer  , 
    IN inAccountId               Integer  , 
    IN inInfoMoneyDestinationId  Integer  , 
    IN inInfoMoneyId             Integer  , 
    IN inInfoMoneyId_Detail      Integer  , 
    IN inContainerId_Goods       Integer  , 
    IN inGoodsId                 Integer  , 
    IN inPartionId               Integer  , -- Партия в Object_PartionGoods.MovementItemId
    IN inAssetId                 Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

          -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Подразделение  2)Товар 3)Статьи назначения 4)Статьи назначения(детализация с/с)
          -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1)Физ. лицо (МО) 2)Товар 3)Статьи назначения 4)Статьи назначения(детализация с/с)
          vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                 , inParentId          := inContainerId_Goods
                                                 , inObjectId          := inAccountId
                                                 , inPartionId         := inPartionId
                                                 , inJuridicalId_basis := inJuridicalId_basis
                                                 , inBusinessId        := inBusinessId
                                                 , inDescId_1          := zc_ContainerLinkObject_Goods()
                                                 , inObjectId_1        := inGoodsId
                                                 , inDescId_2          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                 , inObjectId_2        := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE inUnitId                      END
                                                 , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                 , inObjectId_3        := inInfoMoneyId
                                                 , inDescId_4          := zc_ContainerLinkObject_InfoMoneyDetail()
                                                 , inObjectId_4        := inInfoMoneyId_Detail
                                                  );


     -- Возвращаем значение
     RETURN (vbContainerId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.17                                        * all
*/

-- тест
-- SELECT * FROM lpInsertUpdate_ContainerSumm_Goods ()
