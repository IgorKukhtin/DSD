-- Function: gpGet_Object_Education (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Education (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Education(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameUkr TVarChar, isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Education());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Education()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS NameUkr
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
     SELECT 
           Object_Education.Id                       AS Id
         , Object_Education.ObjectCode               AS Code
         , Object_Education.ValueData                AS Name
         , ObjectString_Education_NameUkr.ValueData  AS NameUkr
         , Object_Education.isErased                 AS isErased
     FROM OBJECT AS Object_Education
          LEFT JOIN ObjectString AS ObjectString_Education_NameUkr
                                 ON ObjectString_Education_NameUkr.ObjectId = Object_Education.Id 
                                AND ObjectString_Education_NameUkr.DescId = zc_ObjectString_Education_NameUkr()
     WHERE Object_Education.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Education(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.16         *

*/

-- тест
-- SELECT * FROM gpSelect_Education('2')