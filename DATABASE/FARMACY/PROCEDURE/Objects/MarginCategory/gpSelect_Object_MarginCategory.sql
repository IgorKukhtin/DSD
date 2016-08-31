--Function: gpSelect_Object_MarginCategory(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MarginCategory(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_MarginCategory(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MarginCategory(
    IN inShowAll     Boolean,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Percent TFloat
             , isSite Boolean
             , isErased boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_MarginCategory());

   RETURN QUERY 
   WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

   SELECT Object_MarginCategory.Id         AS Id 
        , Object_MarginCategory.ObjectCode AS Code
        , Object_MarginCategory.ValueData  AS Name
        , ObjectFloat_Percent.ValueData    AS Percent
        , COALESCE(ObjectBoolean_Site.ValueData, FALSE)   AS isSite
        , Object_MarginCategory.isErased   AS isErased
   FROM tmpIsErased
        INNER JOIN Object AS Object_MarginCategory
                          ON Object_MarginCategory.isErased = tmpIsErased.isErased
                         AND Object_MarginCategory.DescId = zc_Object_MarginCategory()
        LEFT JOIN ObjectFloat AS ObjectFloat_Percent 	
                              ON ObjectFloat_Percent.ObjectId = Object_MarginCategory.Id
                             AND ObjectFloat_Percent.DescId = zc_ObjectFloat_MarginCategory_Percent()  
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Site 	
                                ON ObjectBoolean_Site.ObjectId = Object_MarginCategory.Id
                               AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_MarginCategory_Site()  
   ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_MarginCategory (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.04.16         *
 05.04.16         *
 09.04.15                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MarginCategory ('2')
