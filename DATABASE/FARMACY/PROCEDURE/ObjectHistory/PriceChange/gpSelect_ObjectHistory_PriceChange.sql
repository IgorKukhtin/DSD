-- Function: gpSelect_ObjectHistory_PriceChange ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceChange (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceChange(
    IN inPriceChangeId       Integer   , -- Прайс
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, 
               PriceChange TFloat, FixValue TFloat,
               FixPercent TFloat,
               FixDiscount TFloat,
               PercentMarkup TFloat,
               Multiplicity TFloat,
               FixEndDate TDateTime
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
          , ObjectHistoryFloat_PriceChange_FixDiscount.ValueData           AS FixDiscount
          , ObjectHistoryFloat_PriceChange_PercentMarkup.ValueData         AS PercentMarkup
          , ObjectHistoryFloat_PriceChange_Multiplicity.ValueData          AS Multiplicity
          , ObjectHistoryDate_PriceChange_FixEndDate.ValueData             AS FixEndDate
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

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_FixDiscount
                                         ON ObjectHistoryFloat_PriceChange_FixDiscount.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_FixDiscount.DescId = zc_ObjectHistoryFloat_PriceChange_FixDiscount()

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_Value
                                         ON ObjectHistoryFloat_PriceChange_Value.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_Value.DescId = zc_ObjectHistoryFloat_PriceChange_Value()

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_PercentMarkup
                                         ON ObjectHistoryFloat_PriceChange_PercentMarkup.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_PercentMarkup.DescId = zc_ObjectHistoryFloat_PriceChange_PercentMarkup()

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange_Multiplicity
                                         ON ObjectHistoryFloat_PriceChange_Multiplicity.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                        AND ObjectHistoryFloat_PriceChange_Multiplicity.DescId = zc_ObjectHistoryFloat_PriceChange_Multiplicity()

            LEFT JOIN ObjectHistoryDate AS ObjectHistoryDate_PriceChange_FixEndDate
                                        ON ObjectHistoryDate_PriceChange_FixEndDate.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                       AND ObjectHistoryDate_PriceChange_FixEndDate.DescId = zc_ObjectHistoryDate_PriceChange_FixEndDate()
           ;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_PriceChange (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.  Шаблий О.В.
 30.04.21                                                                                     * FixEndDate
 04.12.19                                                                                     * FixDiscount
 08.02.19         * FixPercent
 24.02.16         *
 24.12.15                                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceChange (0, '')
