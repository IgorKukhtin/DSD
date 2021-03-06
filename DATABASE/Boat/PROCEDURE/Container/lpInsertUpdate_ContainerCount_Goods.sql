-- Function: lpInsertUpdate_ContainerCount_Goods

DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_ContainerCount_Goods (TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ContainerCount_Goods (
    IN inOperDate                TDateTime,
    IN inUnitId                  Integer  ,
    IN inMemberId                Integer  ,
    IN inInfoMoneyDestinationId  Integer  ,
    IN inGoodsId                 Integer  ,
    IN inPartionId               Integer  , -- Партия в Object_PartionGoods.MovementItemId
    IN inIsReserve               Boolean  , -- признак что это резерв
    IN inAccountId               Integer    -- эта аналитика нужна для "товар в пути / виртуальный склад"
)
RETURNS Integer
AS
$BODY$
   DECLARE vbContainerId Integer;
BEGIN

         -- Движение по inUnitId

                          -- 0)Товар или ОС 1)Подразделение
                          -- 0)Товар или ОС 1)Физ. лицо (МО)
         vbContainerId := lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                , inParentId          := NULL
                                                , inObjectId          := inGoodsId
                                                , inPartionId         := inPartionId
                                                , inIsReserve         := inIsReserve
                                                , inJuridicalId_basis := NULL
                                                , inBusinessId        := NULL
                                                , inDescId_1          := CASE WHEN inMemberId <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Unit() END
                                                , inObjectId_1        := CASE WHEN inMemberId <> 0 THEN inMemberId                      ELSE inUnitId                      END
                                                 );

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
