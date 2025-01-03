-- Function: gpSelect_Object_Juridical_ExportPriceForHelsi()

DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_ExportPriceForHelsi(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical_ExportPriceForHelsi(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (JuridicalId Integer
             , JuridicalCode Integer
             , JuridicalName TVarChar) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY
     SELECT DISTINCT
            Juridical.JuridicalID
          , Juridical.JuridicalCode
          , Juridical.JuridicalName
     FROM gpSelect_Object_Unit_ExportPriceForHelsi (inSession) AS Juridical;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В
 23.10.19                                                                     *

*/

-- тест
-- SELECT * FROM Object WHERE DescId = zc_Object_Unit();
--
SELECT * FROM gpSelect_Object_Juridical_ExportPriceForHelsi ('3')