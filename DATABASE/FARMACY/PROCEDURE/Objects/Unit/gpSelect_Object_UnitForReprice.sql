-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitForReprice(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForReprice(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitName TVarChar, IntegerKey Integer, StringKey TVarChar) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
     
    SELECT Object_Unit_View.Id, Object_Unit_View.Name, Object_ImportExportLink_View.IntegerKey, Object_ImportExportLink_View.StringKey 
      FROM Object_Unit_View

       LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = Object_Unit_View.id
           WHERE Object_ImportExportLink_View.LinkTypeId =  zc_Enum_ImportExportLinkType_UnitUnitId() ;         
            
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.15                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitForReprice ('2')