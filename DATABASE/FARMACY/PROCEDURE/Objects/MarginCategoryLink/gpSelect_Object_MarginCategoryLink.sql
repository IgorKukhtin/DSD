--Function: gpSelect_Object_MarginCategoryItem(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MarginCategoryLink(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MarginCategoryLink(
    IN inSession          TVarChar       -- сессия пользователя
)

RETURNS TABLE (Id Integer, MarginCategoryId Integer, MarginCategoryName TVarChar
             , UnitId Integer, UnitName TVarChar, JuridicalId Integer, JuridicalName TVarChar
             , isSite Boolean
             , isErased boolean
) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MarginCategory());

   RETURN QUERY  
   SELECT 
        Object_MarginCategoryLink.Id, 
        Object_MarginCategoryLink.MarginCategoryId, 
        Object_MarginCategoryLink.MarginCategoryName, 
        Object_MarginCategoryLink.UnitId, 
        Object_MarginCategoryLink.UnitName, 
        Object_MarginCategoryLink.JuridicalId, 
        Object_MarginCategoryLink.JuridicalName,
        COALESCE(ObjectBoolean_Site.ValueData, FALSE)   AS isSite,
        MarginCategoryLink.isErased 
    FROM Object_MarginCategoryLink_View AS Object_MarginCategoryLink
          LEFT JOIN Object AS MarginCategoryLink ON MarginCategoryLink.Id = Object_MarginCategoryLink.Id
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Site 	
                                  ON ObjectBoolean_Site.ObjectId = Object_MarginCategoryLink.MarginCategoryId
                                 AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_MarginCategory_Site()

;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MarginCategoryLink(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.04.16         *
 09.04.15                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_MarginCategoryLink('2')