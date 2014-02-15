-- Function: gpGet_Object_RateFuelKind (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_RateFuelKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RateFuelKind(
    IN inId          Integer,       -- ключ объекта <Автомобиль>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Tax TFloat
             , isErased Boolean
              )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_RateFuelKind());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_RateFuelKind()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as TFloat)     AS Tax
           , CAST (NULL AS Boolean) AS isErased
       ;
   ELSE
       RETURN QUERY 
       SELECT 
              Object_RateFuelKind.Id         AS Id 
            , Object_RateFuelKind.ObjectCode AS Code
            , Object_RateFuelKind.ValueData  AS Name
      
            , ObjectFloat_Tax.ValueData      AS Tax
       
            , Object_RateFuelKind.isErased   AS isErased
      
        FROM Object AS Object_RateFuelKind
             LEFT JOIN ObjectFloat AS ObjectFloat_Tax ON ObjectFloat_Tax.ObjectId = Object_RateFuelKind.Id 
                                                     AND ObjectFloat_Tax.DescId = zc_ObjectFloat_RateFuelKind_Tax()
       WHERE Object_RateFuelKind.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_RateFuelKind (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.09.13          * 

*/

-- тест
-- SELECT * FROM gpGet_Object_RateFuelKind (2, '')
