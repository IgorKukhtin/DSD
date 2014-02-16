-- Function: gpSelect_Object_RateFuelKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_RateFuelKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RateFuelKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
              , Tax TFloat
              , isErased Boolean
              ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_RateFuelKind());

   RETURN QUERY 
   SELECT
        Object_RateFuelKind.Id         AS Id 
      , Object_RateFuelKind.ObjectCode AS Code
      , Object_RateFuelKind.ValueData  AS NAME
      
      , ObjectFloat_Tax.ValueData      AS Tax
       
      , Object_RateFuelKind.isErased   AS isErased
      
   FROM OBJECT AS Object_RateFuelKind
        LEFT JOIN ObjectFloat AS ObjectFloat_Tax ON ObjectFloat_Tax.ObjectId = Object_RateFuelKind.Id 
                                                AND ObjectFloat_Tax.DescId = zc_ObjectFloat_RateFuelKind_Tax()
                                                
   WHERE Object_RateFuelKind.DescId = zc_Object_RateFuelKind();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RateFuelKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.09.13          * add zc_ObjectFloat_RateFuelKind_Tax
 25.09.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_RateFuelKind('2')
