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
    -- записываем в историю 
    PERFORM
        gpInsertUpdate_ObjectHistory_Price(
            ioId       := 0::Integer,    -- ключ объекта <Элемент истории прайса>
            inPriceId  := Object_Price_View.ID::Integer,    -- Прайс
            inOperDate := CURRENT_TIMESTAMP::TDateTime,  -- Дата действия прайса
            inPrice    := Object_Price_View.Price::TFloat,     -- Цена
            inMCSValue := NULL::TFloat,     -- НТЗ
            inSession  := inSession)
    FROM
        Object_Price_View 
    WHERE 
        UnitId = inUnitID
        AND
        MCSValue is not null;
        
    -- Удаляем данные по НТЗ
	DELETE FROM ObjectFloat
    WHERE 
	    DescId = zc_ObjectFloat_Price_MCSValue()
		AND
	    ObjectId in (SELECT ID FROM Object_Price_View WHERE UnitId = inUnitID);
	
	-- Удаляем данные по датам НТЗ / 
	DELETE FROM ObjectDate
    WHERE 
	    DescId in (zc_ObjectDate_Price_MCSDateChange()
                  ,zc_ObjectDate_Price_MCSIsCloseDateChange()
                  ,zc_ObjectDate_Price_MCSNotRecalcDateChange())
	    AND
	    ObjectId in (SELECT ID FROM Object_Price_View WHERE UnitId = inUnitID);
	
	-- Удаляем данные по галкам "закрыто" и "не пересчитывать" НТЗ
	DELETE FROM ObjectBoolean
    WHERE 
	    DescId in (zc_ObjectBoolean_Price_MCSIsClose(),zc_ObjectBoolean_Price_MCSNotRecalc())
	    AND
	    ObjectId in (SELECT ID FROM Object_Price_View WHERE UnitId = inUnitID);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_MCS (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 27.10.15                                                           *
*/

