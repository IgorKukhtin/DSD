-- Function: gpSelect_ObjectHistory_PriceSite ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceSite (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceSite(
    IN inPriceSiteId    Integer   , -- Прайс
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, 
               Price TFloat)
AS
$BODY$
BEGIN
     -- Выбираем данные
    RETURN QUERY
        WITH ObjectHistory_PriceSite AS
        (
            SELECT 
                * 
            FROM 
                ObjectHistory
            WHERE 
                ObjectHistory.ObjectId = inPriceSiteId
                AND 
                ObjectHistory.DescId = zc_ObjectHistory_PriceSite()
        ),
        tmpObjectHistoryFloat AS (SELECT * 
                                  FROM ObjectHistoryFloat
                                  WHERE ObjectHistoryFloat.ObjectHistoryId IN (SELECT ObjectHistory_PriceSite.Id FROM ObjectHistory_PriceSite))
        SELECT
            ObjectHistory_PriceSite.Id                                   AS Id
          , COALESCE(ObjectHistory_PriceSite.StartDate, Empty.StartDate) AS StartDate
          , ObjectHistoryFloat_PriceSite_Value.ValueData                 AS Price
        FROM 
            ObjectHistory_PriceSite
            FULL JOIN (
                        SELECT 
                            zc_DateStart() AS StartDate, 
                            inPriceSiteId AS ObjectId 
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_PriceSite.ObjectID
            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_PriceSite_Value
                                            ON ObjectHistoryFloat_PriceSite_Value.ObjectHistoryId = ObjectHistory_PriceSite.Id
                                           AND ObjectHistoryFloat_PriceSite_Value.DescId = zc_ObjectHistoryFloat_PriceSite_Value();


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_PriceSite (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.21                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceSite (0, '')

select * from gpSelect_ObjectHistory_PriceSite(inPriceSiteId := 558486 ,  inSession := '3');
