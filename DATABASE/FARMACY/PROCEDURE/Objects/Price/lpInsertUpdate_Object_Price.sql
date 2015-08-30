 -- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Price (Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Price (Integer, Integer, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Price(
    IN inGoodsId        Integer  , -- ИД товара
    IN inUnitId         Integer,   -- ИД подразделения
    IN inPrice          tFloat,    -- Цена
    IN inDate           TDateTime, -- Дата документа
    IN inUserId         Integer    -- пользователь
)
RETURNS VOID
AS
$BODY$
    DECLARE vbId Integer;
    DECLARE vbPrice_Value TFloat;
    DECLARE vbDateChange TDateTime;
BEGIN
    -- Если такая запись есть - достаем её ключу подр.-товар
    SELECT
        Id, 
        price, 
        DateChange 
    INTO 
        vbId, 
        vbPrice_Value, 
        vbDateChange
    FROM 
        Object_Price_View
    WHERE
        GoodsId = inGoodsId
        AND
        UnitId = inUnitID;
    IF COALESCE(vbId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        vbId := lpInsertUpdate_Object (vbId, zc_Object_Price(), 0, '');

        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), vbId, inGoodsId);

        -- сохранили связь с <подразделение>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), vbId, inUnitId);
    END IF;
  
    IF (vbDateChange is null or inDate >= vbDateChange)
    THEN
        IF COALESCE(vbPrice_Value,0) <> inPrice
        THEN
            -- сохранили св-во < Цена >
            PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_Value(), vbId, inPrice);
        END IF;

        -- сохранили св-во < Дата изменения >
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_DateChange(), vbId, inDate);

        -- сохранили протокол
        PERFORM lpInsert_ObjectProtocol (vbId, inUserId);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 11.02.14                        *
 05.02.14                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_Price (inGoodsId := 1, inUnitId := 1, inPrice := 10.0, inUserId := 3)
