-- Function: gpGet_Object_PairDay()

DROP FUNCTION IF EXISTS gpGet_Object_PairDay(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PairDay(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PairDay());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PairDay()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_PairDay.Id                 AS Id 
         , Object_PairDay.ObjectCode         AS Code
         , Object_PairDay.ValueData          AS Name
         , ObjectString_Comment.ValueData    AS Comment
         , Object_PairDay.isErased           AS isErased
     FROM OBJECT AS Object_PairDay
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_PairDay.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_PairDay_Comment()   
       WHERE Object_PairDay.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_PairDay(0, '2')