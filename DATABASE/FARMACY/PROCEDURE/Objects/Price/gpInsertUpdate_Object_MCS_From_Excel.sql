-- Function: gpInsertUpdate_Object_MCS_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MCS_From_Excel (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MCS_From_Excel(
    IN inUnitId     Integer, -- ID подразделение
    IN inGoodsCode  Integer, -- Code Товар
    IN inMCSValue   TFloat,  -- Неснижаемый товарный запас
    IN inSession    TVarChar -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE
        vbUserId Integer;
        vbGoodsId Integer;
        vbObjectId Integer;
        vbId Integer;
        vbMCSValue TFloat;
BEGIN
    vbUserId := lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    vbGoodsId := 0;
    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите подразделение';
    END IF;
    --поискали товар по коду
    Select 
        ID 
    INTO 
        vbGoodsId 
    FROM 
        Object_Goods_View 
    WHERE 
        ObjectId = vbObjectId 
        AND 
        GoodsCodeInt = inGoodsCode;
    --проверили, а есть ли такой товар в базе
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION 'Ошибка. В базе данных не найден товар с кодом <%>', inGoodsCode;
    END IF;
    
    IF inMCSValue is not null AND (inMCSValue<0)
    THEN
        RAISE EXCEPTION 'Ошибка.Неснижаемый товарный запас <%> Не может быть меньше нуля.', inMCSValue;
    END IF;
   
    -- Если такая запись есть - достаем её
    SELECT 
        Id, 
        MCSValue
    INTO 
        vbId, 
        vbMCSValue
    FROM 
        Object_Price_View
    WHERE
        GoodsId = vbGoodsId
        AND
        UnitId = inUnitID;
    IF COALESCE(vbId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        vbId := lpInsertUpdate_Object (0, zc_Object_Price(), 0, '');
        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), vbId, vbGoodsId);
        -- сохранили связь с <подразделение>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), vbId, inUnitId);
    END IF;
    -- сохранили св-во < Неснижаемый товарный запас >
    IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), vbId, inMCSValue);
        -- сохранили св-во < Дата изменения Неснижаемого товарного запаса>
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), vbId, CURRENT_DATE);
    END IF;
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MCS_From_Excel (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 27.07.15                                                           *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Price()
