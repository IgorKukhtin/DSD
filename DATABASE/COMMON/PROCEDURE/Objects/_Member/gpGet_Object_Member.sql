-- Function: gpGet_Object_Member (Integer,TVarChar)

--DROP FUNCTION gpGet_Object_Member (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Member(
    IN inId          Integer,        -- Физические лица 
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, INN TVarChar, isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Member());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS INN
           , CAST (NULL AS Boolean) AS isErased
        FROM Object 
       WHERE Object.DescId = zc_Object_Member();
   ELSE
       RETURN QUERY 
     SELECT 
           Object_Member.Id             AS Id
         , Object_Member.ObjectCode     AS Code
         , Object_Member.ValueData      AS Name
         
         , ObjectString_INN.ValueData   AS INN
         , Object_Member.isErased       AS isErased
         
     FROM OBJECT AS Object_Member
          LEFT JOIN ObjectString AS ObjectString_INN ON ObjectString_INN.ObjectId = Object_Member.Id 
                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
     WHERE Object_Member.Id = inId;
     
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Member(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Member('2')