-- Function: gpSelect_ObjectHistory_Price ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_Price(
    IN inPriceId        Integer   , -- Прайс
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, 
               Price TFloat, MCSValue TFloat,
               MCSPeriod TFloat, MCSDay TFloat)
AS
$BODY$
BEGIN
     -- Выбираем данные
    RETURN QUERY
        WITH ObjectHistory_Price AS
        (
            SELECT 
                * 
            FROM 
                ObjectHistory
            WHERE 
                ObjectHistory.ObjectId = inPriceId
                AND 
                ObjectHistory.DescId = zc_ObjectHistory_Price()
        ),
        tmpObjectHistoryFloat AS (SELECT * 
                                  FROM ObjectHistoryFloat
                                  WHERE ObjectHistoryFloat.ObjectHistoryId IN (SELECT ObjectHistory_Price.Id FROM ObjectHistory_Price))
        SELECT
            ObjectHistory_Price.Id                                   AS Id
          , COALESCE(ObjectHistory_Price.StartDate, Empty.StartDate) AS StartDate
          , ObjectHistoryFloat_Price_Value.ValueData                 AS Price
          , ObjectHistoryFloat_Price_MCSValue.ValueData              AS MCSValue
          , ObjectHistoryFloat_Price_MCSPeriod.ValueData             AS MCSPeriod
          , ObjectHistoryFloat_Price_MCSDay.ValueData                AS MCSDay
        FROM 
            ObjectHistory_Price
            FULL JOIN (
                        SELECT 
                            zc_DateStart() AS StartDate, 
                            inPriceId AS ObjectId 
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_Price.ObjectID
            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_Price_MCSValue
                                            ON ObjectHistoryFloat_Price_MCSValue.ObjectHistoryId = ObjectHistory_Price.Id
                                           AND ObjectHistoryFloat_Price_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()
            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_Price_Value
                                            ON ObjectHistoryFloat_Price_Value.ObjectHistoryId = ObjectHistory_Price.Id
                                           AND ObjectHistoryFloat_Price_Value.DescId = zc_ObjectHistoryFloat_Price_Value()

            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_Price_MCSPeriod
                                            ON ObjectHistoryFloat_Price_MCSPeriod.ObjectHistoryId = ObjectHistory_Price.Id
                                           AND ObjectHistoryFloat_Price_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_Price_MCSDay
                                            ON ObjectHistoryFloat_Price_MCSDay.ObjectHistoryId = ObjectHistory_Price.Id
                                           AND ObjectHistoryFloat_Price_MCSDay.DescId = zc_ObjectHistoryFloat_Price_MCSDay();


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_Price (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 24.02.16         *
 24.12.15                                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_Price (0, '')

select * from gpSelect_ObjectHistory_Price(inPriceId := 558486 ,  inSession := '3');
