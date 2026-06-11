-- Function: gpGet_Object_NotBudgPromo()

DROP FUNCTION IF EXISTS gpGet_Object_NotBudgPromo(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_NotBudgPromo(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_NotBudgPromo());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_NotBudgPromo()) AS Code
           , CAST ('' as TVarChar)  AS Name  
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_NotBudgPromo.Id            AS Id 
         , Object_NotBudgPromo.ObjectCode    AS Code
         , Object_NotBudgPromo.ValueData     AS Name 
         , ObjectString_Comment.ValueData    AS Comment
         , Object_NotBudgPromo.isErased      AS isErased
     FROM OBJECT AS Object_NotBudgPromo
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_NotBudgPromo.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_NotBudgPromo_Comment()   

     WHERE Object_NotBudgPromo.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.26         *
*/

-- тест
-- SELECT * FROM gpGet_Object_NotBudgPromo(0, '2')