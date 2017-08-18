-- Function: gpUpdate_Object_Price_CheckPrice ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Price_CheckPrice (Integer, Integer, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Price_CheckPrice(
    IN inUnitId              Integer   ,    -- ключ объекта < подразделение >
    IN inGoodsId             Integer   ,    -- Товар
    IN inisCorrectMCS        Boolean   ,    -- Появился на рынке - исправить НТЗ
 INOUT ioCheckPriceDate      TDateTime ,    -- НТЗ - значение которое вернется по окончании периода
    IN inSession             TVarChar       -- сессия пользователя
)
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbPriceId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    IF inisCorrectMCS = TRUE AND COALESCE (ioCheckPriceDate, NULL) = NULL
    THEN
   
        -- нашли элемент Цены
        vbPriceId:= (SELECT ObjectLink_Price_Unit.ObjectId AS Id
                     FROM ObjectLink AS ObjectLink_Price_Unit
                          INNER JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId        =  zc_ObjectLink_Price_Goods()
                                               AND Price_Goods.ChildObjectId = inGoodsId
                     WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                       AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                    );
        
        -- сохранили свойство <НТЗ для периода>
        ioCheckPriceDate := CURRENT_TIMESTAMP;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_CheckPrice(), vbPriceId, ioCheckPriceDate);

    END IF;
    
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (vbPriceId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 18.08.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Price_MCSAuto()
--select * from gpUpdate_Object_Price_MCSAuto(inMCSValue := 4 ::TFloat , inGoodsId := 652, inDays := 3 ::TFloat,  inSession := '3'::TVarChar);


