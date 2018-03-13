-- Function: lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerSumm_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerSumm_Goods (
    IN inOperDate                TDateTime,
    IN inUnitId                  Integer  ,
    IN inMemberId                Integer  ,
    IN inClientId                Integer  , -- ***Покупатель - т.к. делаем переброску на Покупателя, а потом ВСЕГДА продажу - от него
    IN inJuridicalId_basis       Integer  ,
    IN inBusinessId              Integer  ,
    IN inAccountId               Integer  ,
    IN inInfoMoneyDestinationId  Integer  ,
    IN inInfoMoneyId             Integer  ,
    IN inContainerId_Goods       Integer  ,
    IN inGoodsId                 Integer  ,
    IN inGoodsSizeId             Integer  ,
    IN inPartionId               Integer  , -- Партия в Object_PartionGoods.MovementItemId
    IN inPartionId_MI            Integer    -- ***Партия продажи
)
RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     IF inPartionId_MI > 0 OR inClientId > 0
     THEN
         -- Движение по inClientId - Покупатель
         -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1+2)Товар 3)Покупатель 4)Подразделение 5)Партия продажи 6)Статьи назначения
         vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                , inParentId          := inContainerId_Goods
                                                , inObjectId          := inAccountId
                                                , inPartionId         := inPartionId
                                                , inJuridicalId_basis := inJuridicalId_basis
                                                , inBusinessId        := inBusinessId
                                                , inDescId_1          := zc_ContainerLinkObject_Goods()
                                                , inObjectId_1        := inGoodsId
                                                , inDescId_2          := zc_ContainerLinkObject_GoodsSize()
                                                , inObjectId_2        := inGoodsSizeId
                                                , inDescId_3          := zc_ContainerLinkObject_Client()
                                                , inObjectId_3        := inClientId
                                                , inDescId_4          := zc_ContainerLinkObject_Unit()
                                                , inObjectId_4        := inUnitId
                                                , inDescId_5          := zc_ContainerLinkObject_PartionMI()
                                                , inObjectId_5        := inPartionId_MI
                                                , inDescId_6          := zc_ContainerLinkObject_InfoMoney()
                                                , inObjectId_6        := inInfoMoneyId
                                                 );

     ELSE
         -- Движение по inUnitId
         -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1+2)Товар 3)Подразделение  4)Статьи назначения
         -- 0.1.)Счет 0.2.)Главное Юр лицо 0.3.)Бизнес 1+2)Товар 3)Физ. лицо (МО) 4)Статьи назначения
         vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                , inParentId          := inContainerId_Goods
                                                , inObjectId          := inAccountId
                                                , inPartionId         := inPartionId
                                                , inJuridicalId_basis := inJuridicalId_basis
                                                , inBusinessId        := inBusinessId
                                                , inDescId_1          := zc_ContainerLinkObject_Goods()
                                                , inObjectId_1        := inGoodsId
                                                , inDescId_2          := zc_ContainerLinkObject_GoodsSize()
                                                , inObjectId_2        := inGoodsSizeId
                                                , inDescId_3          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                , inObjectId_3        := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE inUnitId                      END
                                                , inDescId_4          := zc_ContainerLinkObject_InfoMoney()
                                                , inObjectId_4        := inInfoMoneyId
                                                 );

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
 05.06.17                                        * all
*/

-- тест
-- SELECT * FROM lpInsertUpdate_ContainerSumm_Goods ()
