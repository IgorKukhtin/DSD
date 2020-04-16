-- Function: gpSelect_ObjectHistory_PriceChange ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PesentSalary (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PesentSalary(
    IN inRetailId       Integer   , -- торговая сеть
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime
             , PesentSalary TFloat
             , RetailId Integer
             , RetailName TVarChar
               )
AS
$BODY$
BEGIN
     -- Выбираем данные
    RETURN QUERY
        WITH ObjectHistory_PesentSalary AS
        (
            SELECT * 
            FROM ObjectHistory
            WHERE (ObjectHistory.ObjectId = inRetailId OR inRetailId = 0)
              AND ObjectHistory.DescId = zc_ObjectHistory_PesentSalary()
        )
        SELECT
            ObjectHistory_PesentSalary.Id                                   AS Id
          , COALESCE(ObjectHistory_PesentSalary.StartDate, Empty.StartDate) AS StartDate
          , ObjectHistoryFloat_PesentSalary_Value.ValueData                 AS PesentSalary

          , Object_Retail.Id        AS RetailId
          , Object_Retail.ValueData AS RetailName
        FROM 
            ObjectHistory_PesentSalary
            FULL JOIN (
                        SELECT 
                            zc_DateStart() AS StartDate, 
                            inRetailId AS ObjectId 
                        WHERE COALESCE (inRetailId,0) <> 0
                      ) AS Empty
                        ON Empty.ObjectId = ObjectHistory_PesentSalary.ObjectId

            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PesentSalary_Value
                                         ON ObjectHistoryFloat_PesentSalary_Value.ObjectHistoryId = ObjectHistory_PesentSalary.Id
                                        AND ObjectHistoryFloat_PesentSalary_Value.DescId = zc_ObjectHistoryFloat_PesentSalary_Value()

            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectHistory_PesentSalary.ObjectId

           ;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 16.04.20         *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PesentSalary (0, '')
