-- Function: gpInsertUpdate_Object_Price (Integer, Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_MCSIsClose (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_MCSIsClose(
    IN inUnitId              Integer   ,    -- ключ объекта < подразделение >
    IN inGoodsId             Integer   ,    -- Товар
    IN inMCSIsClose          Boolean   ,    -- НТЗ закрыт
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Void
AS
$BODY$
    DECLARE
        vbUserId Integer;
        vbMCSIsClose Boolean;
        vbId Integer;
        vbMCSValue TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- проверка подразделения
    IF COALESCE (inUnitId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Подразделение не определено.';
    END IF; 

    -- Находим запись - достаем её ключу подр.-товар
    SELECT Price_Goods.ObjectId                  AS Id
         , COALESCE(MCS_isClose.ValueData,False) AS MCSIsClose
         , COALESCE(MCS_Value.ValueData, 0) AS MCSValue 
      INTO vbId, vbMCSIsClose, vbMCSValue
    FROM ObjectLink AS Price_Goods
        INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                              ON ObjectLink_Price_Unit.ObjectId = Price_Goods.ObjectId
                             AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                             AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
        LEFT JOIN ObjectBoolean AS MCS_isClose
                             ON MCS_isClose.ObjectId = Price_Goods.ObjectId
                            AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
        LEFT JOIN ObjectFloat AS MCS_Value
                              ON MCS_Value.ObjectId = Price_Goods.ObjectId
                             AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
       WHERE Price_Goods.DescId = zc_ObjectLink_Price_Goods()
         AND Price_Goods.ChildObjectId = inGoodsId;
       
    IF (inMCSIsClose is not null) AND (COALESCE(vbMCSIsClose,False) <> inMCSIsClose)
    THEN
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSIsClose(), vbId, inMCSIsClose);
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSIsCloseDateChange(), vbId, CURRENT_DATE);

        IF COALESCE(inMCSIsClose, False) = TRUE AND COALESCE (vbMCSValue, 0) <> 0
        THEN
           PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), vbId, 0);
        END IF;
    END IF;
    
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
    
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 15.07.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Price_MCSIsClose()