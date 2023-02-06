-- Function: gpSelect_ObjectHistory_CashSettings ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_CashSettings (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_CashSettings(
    IN inCashSettingsId    Integer   , -- Прайс
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, StartDate TDateTime, EndDate TDateTime, 
               FixedPercent TFloat)
AS
$BODY$
BEGIN

    IF COALESCE(inCashSettingsId, 0) = 0
    THEN
      SELECT COALESCE(Object_CashSettings.Id, 0)
      INTO inCashSettingsId
      FROM Object AS Object_CashSettings
      WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
      LIMIT 1;
    END IF;

     -- Выбираем данные
    RETURN QUERY
        WITH ObjectHistory_CashSettings AS
        (
            SELECT 
                * 
            FROM 
                ObjectHistory
            WHERE 
                ObjectHistory.ObjectId = inCashSettingsId
                AND 
                ObjectHistory.DescId = zc_ObjectHistory_CashSettings()
        ),
        tmpObjectHistoryFloat AS (SELECT * 
                                  FROM ObjectHistoryFloat
                                  WHERE ObjectHistoryFloat.ObjectHistoryId IN (SELECT ObjectHistory_CashSettings.Id FROM ObjectHistory_CashSettings))
        SELECT
            ObjectHistory_CashSettings.Id                                   AS Id
          , ObjectHistory_CashSettings.StartDate                            AS StartDate
          , ObjectHistory_CashSettings.EndDate                              AS EndDate
          , ObjectHistoryFloat_CashSettings_FixedPercent.ValueData          AS FixedPercent
        FROM 
            ObjectHistory_CashSettings

            LEFT JOIN tmpObjectHistoryFloat AS ObjectHistoryFloat_CashSettings_FixedPercent
                                            ON ObjectHistoryFloat_CashSettings_FixedPercent.ObjectHistoryId = ObjectHistory_CashSettings.Id
                                           AND ObjectHistoryFloat_CashSettings_FixedPercent.DescId = zc_ObjectHistoryFloat_CashSettings_FixedPercent()
                                           
        ORDER BY ObjectHistory_CashSettings.StartDate;


END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_ObjectHistory_CashSettings (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.21                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_CashSettings (0, '')

select * from gpSelect_ObjectHistory_CashSettings(inCashSettingsId := 0 ,  inSession := '3');