-- Function: lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Goods (
    IN inOperDate                TDateTime,
    IN inUnitId                  Integer  ,
    IN inMemberId                Integer  ,
    IN inClientId                Integer  , -- ***Покупатель - т.к. делаем переброску на Покупателя, а потом ВСЕГДА продажу - от него
    IN inInfoMoneyDestinationId  Integer  ,
    IN inGoodsId                 Integer  ,
    IN inPartionId               Integer  , -- Партия в Object_PartionGoods.MovementItemId
    IN inPartionId_MI            Integer  , -- ***Партия продажи
    IN inGoodsSizeId             Integer  ,
    IN inAccountId               Integer    -- эта аналитика нужна для "товар в пути / виртуальный склад"
)
RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

     IF inPartionId_MI > 0 OR inClientId > 0
     THEN
         -- Движение по inClientId - Покупатель
                          -- 0)Товар или ОС 2)Покупатель 3)Подразделение 4)Партия продажи
         vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                , inParentId          := NULL
                                                , inObjectId          := inGoodsId
                                                , inPartionId         := inPartionId
                                                , inJuridicalId_basis := NULL
                                                , inBusinessId        := NULL
                                                , inDescId_1          := zc_ContainerLinkObject_GoodsSize()
                                                , inObjectId_1        := inGoodsSizeId
                                                , inDescId_2          := zc_ContainerLinkObject_Client()
                                                , inObjectId_2        := inClientId
                                                , inDescId_3          := zc_ContainerLinkObject_Unit()
                                                , inObjectId_3        := inUnitId
                                                , inDescId_4          := zc_ContainerLinkObject_PartionMI()
                                                , inObjectId_4        := inPartionId_MI
                                                 );
     ELSE
         -- Движение по inUnitId

                          -- 0)Товар или ОС 1)Подразделение
                          -- 0)Товар или ОС 1)Физ. лицо (МО)
         vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                , inParentId          := NULL
                                                , inObjectId          := inGoodsId
                                                , inPartionId         := inPartionId
                                                , inJuridicalId_basis := NULL
                                                , inBusinessId        := NULL
                                                , inDescId_1          := zc_ContainerLinkObject_GoodsSize()
                                                , inObjectId_1        := inGoodsSizeId
                                                , inDescId_2          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                , inObjectId_2        := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE inUnitId                      END
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
-- SELECT * FROM lpInsertUpdate_ContainerCount_Goods ()
