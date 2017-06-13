-- Function: gpDelete_Object_MCS (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_MCS (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_MCS(
    IN inUnitId     Integer, -- ID подразделение
    IN inSession    TVarChar -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE
        vbUserId Integer;
BEGIN
    vbUserId := lpGetUserBySession (inSession);
    IF COALESCE(inUnitId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите подразделение';
    END IF;

    --
    CREATE TEMP TABLE tmpObject_Price (Id Integer, Price TFloat, MCSValue TFloat) ON COMMIT DROP;
    INSERT INTO tmpObject_Price (Id, MCSValue, MCSValue)
        SELECT ObjectLink_Price_Unit.ObjectId          AS Id
             , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
             , MCS_Value.ValueData                     AS MCSValue 
        FROM ObjectLink AS ObjectLink_Price_Unit
             LEFT JOIN ObjectFloat AS Price_Value
                                   ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
             LEFT JOIN ObjectFloat AS MCS_Value
                                   ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
        WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
          AND ObjectLink_Price_Unit.ChildObjectId = inUnitId;

    -- записываем в историю 
    PERFORM
        gpInsertUpdate_ObjectHistory_Price(
            ioId       := 0::Integer,    -- ключ объекта <Элемент истории прайса>
            inPriceId  := tmpObject_Price.ID::Integer,    -- Прайс
            inOperDate := CURRENT_TIMESTAMP::TDateTime,  -- Дата действия прайса
            inPrice    := tmpObject_Price.Price::TFloat,     -- Цена
            inMCSValue := NULL :: TFloat,  -- НТЗ
            inMCSPeriod:= NULL :: TFloat,  -- Количество дней для анализа НТЗ
            inMCSDay   := NULL :: TFloat,  -- Страховой запас дней НТЗ
            inSession  := inSession)
    FROM tmpObject_Price 
    WHERE tmpObject_Price.MCSValue is not null;
        
    -- Удаляем данные по НТЗ
    DELETE FROM ObjectFloat
    WHERE DescId = zc_ObjectFloat_Price_MCSValue()
      AND ObjectId in (SELECT tmpObject_Price.Id FROM tmpObject_Price);
	               
    -- Удаляем данные по датам НТЗ / 
    DELETE FROM ObjectDate
    WHERE DescId in (zc_ObjectDate_Price_MCSDateChange()
                   , zc_ObjectDate_Price_MCSIsCloseDateChange()
                   , zc_ObjectDate_Price_MCSNotRecalcDateChange())
      AND ObjectId in (SELECT tmpObject_Price.Id FROM tmpObject_Price);
	
    -- Удаляем данные по галкам "закрыто" и "не пересчитывать" НТЗ
    DELETE FROM ObjectBoolean
    WHERE DescId in (zc_ObjectBoolean_Price_MCSIsClose(),zc_ObjectBoolean_Price_MCSNotRecalc())
      AND ObjectId in (SELECT tmpObject_Price.Id FROM tmpObject_Price);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_MCS (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 12.06.17         * ушли от Object_Price_View
 27.10.15                                                           *
*/

