-- Function: gpGet_Object_MobilePack()

DROP FUNCTION IF EXISTS gpGet_Object_MobilePack (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MobilePack(
    IN inId          Integer,       -- ключ объекта <Виды бонусов>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MobilePack());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MobilePack()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , ''       ::TVarChar    AS Comment
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_MobilePack.Id         AS Id
           , Object_MobilePack.ObjectCode AS Code
           , Object_MobilePack.ValueData  AS Name
           , ObjectString_Comment.ValueData AS Comment
           , Object_MobilePack.isErased   AS isErased
           
       FROM Object AS Object_MobilePack
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_MobilePack.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_MobilePack_Comment()
       WHERE Object_MobilePack.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MobilePack (0, '2')