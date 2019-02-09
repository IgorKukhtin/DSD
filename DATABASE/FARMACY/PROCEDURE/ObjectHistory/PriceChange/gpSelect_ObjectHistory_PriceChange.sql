-- Function: gpSelect_ObjectHistory_PriceChange ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceChange (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceChange(
    IN inPriceChangeId       Integer   , -- Прайс
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, 
               PriceChange TFloat, FixValue TFloat,
               FixPercent TFloat,
               PercentMarkup TFloat
               )
AS
$BODY$
BEGIN
     -- Выбираем данные
    RETURN QUERY
        WITH ObjectHistory_PriceChange AS
        (
            SELECT 
                * 
            FROM 
                ObjectHistory
            WHERE 
                ObjectHistory.ObjectId = inPriceChangeId
                AND 
                ObjectHistory.DescId = zc_ObjectHistory_PriceChange()
        )
        SELECT
            ObjectHistory_PriceChange.Id                                   AS Id
          , COALESCE(ObjectHistory_PriceChange.StartDate, Empty.StartDate) AS StartDate
          , ObjectHistoryFloat_PriceChange_Value.ValueData                 AS PriceChange
          , ObjectHistoryFloat_PriceChange_FixValue.ValueData              AS FixValue
          , ObjectHistoryFloat_PriceChange_FixPercent.ValueData            AS FixPercent
          , ObjectHistoryFloat_PriceChange_PercentMarkup.ValueData         AS PercentMarkup
        FROM 
            ObjectHistory_PriceChange
            FULL JOIN (
                        SELECT 
                            zc_DateStart() AS StartDate, 
                            inPriceChangeId AS ObjectId 
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_PriceChange.ObjectID

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_FixValue
                                         ON ObjectHistoryFloat_PriceChange_FixValue.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_FixValue.DescId = zc_ObjectHistoryFloat_PriceChange_FixValue()

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_FixPercent
                                         ON ObjectHistoryFloat_PriceChange_FixPercent.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_FixPercent.DescId = zc_ObjectHistoryFloat_PriceChange_FixPercent()

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_Value
                                         ON ObjectHistoryFloat_PriceChange_Value.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_Value.DescId = zc_ObjectHistoryFloat_PriceChange_Value()

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_PercentMarkup
                                         ON ObjectHistoryFloat_PriceChange_PercentMarkup.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_PercentMarkup.DescId = zc_ObjectHistoryFloat_PriceChange_PercentMarkup()
           ;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_PriceChange (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 08.02.19         * FixPercent
 24.02.16         *
 24.12.15                                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceChange (0, '')
