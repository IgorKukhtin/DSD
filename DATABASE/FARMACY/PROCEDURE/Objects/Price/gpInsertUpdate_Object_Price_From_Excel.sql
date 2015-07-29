-- Function: gpInsertUpdate_Object_Price_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price_From_Excel (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price_From_Excel(
    IN inUnitId     Integer, -- ID подразделение
    IN inGoodsCode  Integer, -- Code Товар
    IN inPriceValue   TFloat,  -- Цена
    IN inSession    TVarChar -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE
      vbUserId Integer;
      vbGoodsId Integer;
      vbObjectId Integer;
      vbId Integer;
      vbPriceValue TFloat;
BEGIN
    vbUserId := lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    vbGoodsId := 0;
    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите подразделение';
    END IF;
    --поискали товар по коду
    Select Id INTO vbGoodsId from Object_Goods_View Where ObjectId = vbObjectId AND GoodsCodeInt = inGoodsCode;
    --проверили, а есть ли такой товар в базе
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION 'Ошибка. В базе данных не найден товар с кодом <%>', inGoodsCode;
    END IF;
    
    IF inPriceValue is not null AND (inPriceValue<0)
    THEN
        RAISE EXCEPTION 'Ошибка. Цена <%> Не может быть меньше нуля.', inPriceValue;
    END IF;
   
    -- Если такая запись есть - достаем её
    SELECT Id, Price
      INTO vbId, vbPriceValue
    from Object_Price_View
    Where
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
    -- сохранили св-во < Цена >
    IF (inPriceValue is not null) AND (inPriceValue <> COALESCE(vbPriceValue,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_Value(), vbId, inPriceValue);
        -- сохранили св-во < Дата изменения цены>
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_DateChange(), vbId, CURRENT_DATE);
    END IF;
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Price_From_Excel (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 27.07.15                                                           *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Price()
