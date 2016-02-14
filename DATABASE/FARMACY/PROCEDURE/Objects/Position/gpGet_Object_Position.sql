-- Function: gpGet_Object_Position (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Position (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Position(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , TaxService TFloat
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Position());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Position()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (0 as TFloat)     AS TaxService
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
     SELECT 
           Object_Position.Id                 AS Id
         , Object_Position.ObjectCode         AS Code
         , Object_Position.ValueData          AS Name
         , ObjectFloat_TaxService.ValueData   AS TaxService
         , Object_Position.isErased           AS isErased
     FROM OBJECT AS Object_Position
        LEFT JOIN ObjectFloat AS ObjectFloat_TaxService
                              ON ObjectFloat_TaxService.ObjectId = Object_Position.Id
                             AND ObjectFloat_TaxService.DescId = zc_ObjectFloat_Position_TaxService()

     WHERE Object_Position.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Position(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.02.06         *
 21.01.16         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Position(0,'2')