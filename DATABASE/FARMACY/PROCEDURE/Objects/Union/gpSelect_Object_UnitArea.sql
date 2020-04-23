-- Function: gpSelect_Object_UnitArea()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitArea(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_UnitArea(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitArea(
    IN inisErased    Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DescName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN


   RETURN QUERY 
       SELECT 
             Object.Id             AS Id
           , Object.ObjectCode     AS Code
           , Object.ValueData      AS Name
           , ObjectDesc.ItemName   AS DescName
           , Object.isErased       AS isErased
           
       FROM Object
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
       WHERE Object.DescId IN (zc_Object_Area(), zc_Object_Unit())
         AND (Object.isErased = inisErased OR inisErased = TRUE);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.04.20         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_UnitArea (true,'2')