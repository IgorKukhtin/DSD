-- Function: gpGet_Object_RouteTT()

DROP FUNCTION IF EXISTS gpGet_Object_RouteTT(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RouteTT(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_RouteTT());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_RouteTT()) AS Code
           , CAST ('' as TVarChar)  AS Name  
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_RouteTT.Id            AS Id 
         , Object_RouteTT.ObjectCode    AS Code
         , Object_RouteTT.ValueData     AS Name 
         , ObjectString_Comment.ValueData  AS Comment
         , Object_RouteTT.isErased      AS isErased
     FROM OBJECT AS Object_RouteTT
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_RouteTT.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_RouteTT_Comment()   
       WHERE Object_RouteTT.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.26         *
*/

-- тест
-- SELECT * FROM gpGet_Object_RouteTT(0, '2')