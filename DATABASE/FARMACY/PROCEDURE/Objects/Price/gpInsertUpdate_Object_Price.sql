-- Function: gpInsertUpdate_Object_Price (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Price (Integer, TDateTime, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Price(
 INOUT ioId                       Integer   ,    -- ключ объекта < Цена >
    IN inOperDate                 TDateTime , 
    IN inPrice                    TFloat    ,    -- цена
    IN inMCSValue                 TFloat    ,    -- Неснижаемый товарный запас
    IN inMCSPeriod                TFloat    ,    -- Количество дней для анализа НТЗ
    IN inMCSDay                   TFloat    ,    -- Страховой запас дней НТЗ
    IN inGoodsId                  Integer   ,    -- Товар
    IN inUnitId                   Integer   ,    -- подразделение
    IN inMCSIsClose               Boolean   ,    -- НТЗ закрыт
    IN inMCSNotRecalc             Boolean   ,    -- НТЗ не пересчитывается
    IN inFix                      Boolean   ,    -- Фиксированная цена
   OUT outDateChange              TDateTime ,    -- Дата изменения цены
   OUT outMCSDateChange           TDateTime ,    -- Дата изменения неснижаемого товарного запаса
   OUT outMCSIsCloseDateChange    TDateTime ,    -- Дата изменения признака "Убить код"
   OUT outMCSNotRecalcDateChange  TDateTime ,    -- Дата изменения признака "Спецконтроль кода"
   OUT outFixDateChange           TDateTime ,    -- Дата изменения признака "Фиксированная цена"
    IN inSession                  TVarChar       -- сессия пользователя
)
AS
$BODY$
    DECLARE
        vbUserId Integer;
        vbPrice TFloat;
        vbMCSValue TFloat;
        vbMCSIsClose Boolean;
        vbMCSNotRecalc Boolean;
        vbFix Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- проверили корректность записи по дате
    IF inOperDate < CURRENT_TIMESTAMP  - interval '1 minute' 
    THEN
        RAISE EXCEPTION 'Ошибка.Дата сохранения данных <%> меньше текущей.', inOperDate;
    END IF;

    -- проверили корректность цены
    IF inPrice = 0
    THEN
        inPrice := null;
    END IF;
    IF inPrice is not null AND (inPrice<0)
    THEN
        RAISE EXCEPTION 'Ошибка.Цена <%> должна быть больше 0.', inPrice;
    END IF;
    -- проверили корректность цены
    IF inMCSValue is not null AND (inMCSValue<0)
    THEN
        RAISE EXCEPTION 'Ошибка.Неснижаемый товарный запас <%> Не может быть меньше 0.', inMCSValue;
    END IF;
    -- Если такая запись есть - достаем её ключу подр.-товар
    SELECT 
        Id, 
        Price, 
        MCSValue, 
        DateChange, 
        MCSDateChange, 
        MCSIsClose, 
        MCSNotRecalc,
        Fix
    INTO 
        ioId, 
        vbPrice, 
        vbMCSValue, 
        outDateChange, 
        outMCSDateChange,
        vbMCSIsClose, 
        vbMCSNotRecalc,
        vbFix
    FROM Object_Price_View


    WHERE
        GoodsId = inGoodsId
        AND
        UnitId = inUnitID;
    IF COALESCE(ioId,0)=0
    THEN
        -- сохранили/получили <Объект> по ИД
        ioId := lpInsertUpdate_Object (ioId, zc_Object_Price(), 0, '');

        -- сохранили связь с <товар>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), ioId, inGoodsId);

        -- сохранили связь с <подразделение>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), ioId, inUnitId);
    END IF;
    
    IF vbFix is null or (vbFix <> COALESCE(inFix,FALSE))
    THEN
        -- сохранили свойство <фиксированная цена>
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_Fix(), ioId, inFix);
        -- сохранили дату изменения <фиксированная цена>
        outFixDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_FixDateChange(), ioId, outFixDateChange);
    END IF;    

    -- сохранили св-во < Цена >
    IF (inPrice is not null) AND (inPrice <> COALESCE(vbPrice,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_Value(), ioId, inPrice);
        -- сохранили св-во < Дата изменения >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_DateChange(), ioId, outDateChange);
    END IF;
    -- сохранили св-во < Неснижаемый товарный запас >
    IF (inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_MCSValue(), ioId, inMCSValue);
        -- сохранили св-во < Дата изменения Неснижаемого товарного запаса>
        outMCSDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSDateChange(), ioId, outMCSDateChange);
    END IF;
    --сохранили историю
    IF ((inPrice is not null) AND (inPrice <> COALESCE(vbPrice,0))) 
       OR
       ((inMCSValue is not null) AND (inMCSValue <> COALESCE(vbMCSValue,0)))
       
    THEN
        PERFORM
            gpInsertUpdate_ObjectHistory_Price(
                ioId       := 0::Integer,    -- ключ объекта <Элемент истории прайса>
                inPriceId  := ioId,    -- Прайс
                inOperDate := CURRENT_TIMESTAMP::TDateTime,  -- Дата действия прайса
                inPrice    := COALESCE(inPrice,vbPrice)::TFloat,     -- Цена
                inMCSValue := COALESCE(inMCSValue,vbMCSValue)::TFloat,     -- НТЗ
                inMCSPeriod:= COALESCE(inMCSPeriod)::TFloat,  -- Количество дней для анализа НТЗ
                inMCSDay   := COALESCE(inMCSDay)::TFloat,     -- Страховой запас дней НТЗ
                inSession  := inSession);
    END IF;
    IF (inMCSIsClose is not null) AND (COALESCE(vbMCSIsClose,False) <> inMCSIsClose)
    THEN
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSIsClose(), ioId, inMCSIsClose);
        outMCSIsCloseDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSIsCloseDateChange(), ioId, outMCSIsCloseDateChange);
    END IF;
    
    IF (inMCSNotRecalc is not null) AND (COALESCE(vbMCSNotRecalc,False) <> inMCSNotRecalc)
    THEN
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_MCSNotRecalc(), ioId, inMCSNotRecalc);
        outMCSNotRecalcDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_Price_MCSNotRecalcDateChange(), ioId, outMCSNotRecalcDateChange);
    END IF;
    
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Price (Integer, TFloat, TFloat, Integer, Integer, Boolean, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 22.12.15                                                         *
 29.08.15                                                         *
 08.06.15                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Price()
