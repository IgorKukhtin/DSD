-- Function: gpSelect_Object_BrandSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BrandSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BrandSP(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_BrandSP());

   RETURN QUERY 
     SELECT Object_BrandSP.Id                 AS Id
          , Object_BrandSP.ObjectCode         AS Code
          , Object_BrandSP.ValueData          AS Name
          , Object_BrandSP.isErased           AS isErased
     FROM OBJECT AS Object_BrandSP
     WHERE Object_BrandSP.DescId = zc_Object_BrandSP();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_BrandSP(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.16         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_BrandSP('2')