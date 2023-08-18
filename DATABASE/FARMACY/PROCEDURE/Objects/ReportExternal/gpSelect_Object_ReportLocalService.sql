-- Function: gpSelect_Object_ReportLocalService()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportLocalService (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReportLocalService(
    IN inSession     TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name     TVarChar
             , isErased Boolean
              ) 
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReportExternal());

      RETURN;

      RETURN QUERY
        SELECT 0
             , 0 AS Code
             , 'gpReport_IncomeConsumptionBalance'::TVarChar  AS Name
             , False
        ORDER BY 3
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.   Шаблий О.В.
  15.04.19                                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReportLocalService (inSession:= zfCalc_UserAdmin())
