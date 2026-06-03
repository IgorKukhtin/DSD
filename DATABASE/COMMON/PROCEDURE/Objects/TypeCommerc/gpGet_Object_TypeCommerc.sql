-- Function: gpGet_Object_TypeCommerc()

DROP FUNCTION IF EXISTS gpGet_Object_TypeCommerc(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_TypeCommerc(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_TypeCommerc());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_TypeCommerc()) AS Code
           , CAST ('' as TVarChar)  AS Name  
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_TypeCommerc.Id            AS Id 
         , Object_TypeCommerc.ObjectCode    AS Code
         , Object_TypeCommerc.ValueData     AS Name 
         , ObjectString_Comment.ValueData   AS Comment
         , Object_TypeCommerc.isErased      AS isErased
     FROM OBJECT AS Object_TypeCommerc
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_TypeCommerc.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_TypeCommerc_Comment()   

     WHERE Object_TypeCommerc.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.26         *
*/

-- тест
-- SELECT * FROM gpGet_Object_TypeCommerc(0, '2')