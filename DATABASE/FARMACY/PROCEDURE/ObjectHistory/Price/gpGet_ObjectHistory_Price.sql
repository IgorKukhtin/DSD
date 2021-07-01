-- Function: gpGet_ObjectHistory_Price ()

DROP FUNCTION IF EXISTS gpGet_ObjectHistory_Price (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_Price(
    IN inPriceId        Integer   , -- Юр.лицо
    IN inOperDate       TDateTime , -- Дата Истории
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, 
               Price TFloat, MCSValue TFloat)
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
                AND 
                inOperDate >= ObjectHistory.StartDate 
                AND 
                inOperDate < ObjectHistory.EndDate
        )
        SELECT
            ObjectHistory_Price.Id                                              AS Id
          , COALESCE(ObjectHistory_Price.StartDate, Empty.StartDate)            AS StartDate
          , ObjectHistoryFloat_Price_Value.ValueData                            AS Price
          , ObjectHistoryFloat_Price_MCSValue.ValueData                         AS MCSValue
        FROM 
            ObjectHistory_Price
            FULL JOIN (
                        SELECT 
                            zc_DateStart() AS StartDate, 
                            inPriceId AS ObjectId 
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_Price.ObjectID
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price_MCSValue
                                         ON ObjectHistoryFloat_Price_MCSValue.ObjectHistoryId = ObjectHistory_Price.Id
                                        AND ObjectHistoryFloat_Price_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()
            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price_Value
                                         ON ObjectHistoryFloat_Price_Value.ObjectHistoryId = ObjectHistory_Price.Id
                                        AND ObjectHistoryFloat_Price_Value.DescId = zc_ObjectHistoryFloat_Price_Value();
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_ObjectHistory_Price (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 24.12.15                                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_Price (0, CURRENT_TIMESTAMP)
