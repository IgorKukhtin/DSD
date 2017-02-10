-- Function: gpGet_Object_Freight()

DROP FUNCTION IF EXISTS gpGet_Object_Freight (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Freight(
    IN inId          Integer,       -- ключ объекта <Автомобиль>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Freight());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (Object_Freight.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (NULL AS Boolean) AS isErased

       FROM Object AS Object_Freight
       WHERE Object_Freight.DescId = zc_Object_Freight();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Freight.Id          AS Id
           , Object_Freight.ObjectCode  AS Code
           , Object_Freight.ValueData   AS Name
           
           , Object_Freight.isErased AS isErased
           
       FROM Object AS Object_Freight
       WHERE Object_Freight.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Freight(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13          * 

*/

-- тест
-- SELECT * FROM gpGet_Object_Freight (2, '')
