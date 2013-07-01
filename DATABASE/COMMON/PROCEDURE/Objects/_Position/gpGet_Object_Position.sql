-- Function: gpGet_Object_Position (Integer,TVarChar)

--DROP FUNCTION gpGet_Object_Position (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Position(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Position());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased
        FROM Object 
       WHERE Object.DescId = zc_Object_Position();
   ELSE
       RETURN QUERY 
     SELECT 
           Object_Position.Id             AS Id
         , Object_Position.ObjectCode     AS Code
         , Object_Position.ValueData      AS Name
         , Object_Position.isErased       AS isErased
     FROM OBJECT AS Object_Position
     WHERE Object_Position.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Position(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Position('2')