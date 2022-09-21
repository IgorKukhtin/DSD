-- Function: gpGet_Object_Area()

DROP FUNCTION IF EXISTS gpGet_Object_Area(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Area(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , TelegramGroupId Integer, TelegramGroupName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Area()) AS Code
           , CAST ('' AS TVarChar)  AS Name 
           , CAST (0 as Integer)    AS TelegramGroupId
           , CAST ('' AS TVarChar)  AS TelegramGroupName
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object_TelegramGroup.Id        ::Integer  AS TelegramGroupId
           , Object_TelegramGroup.ValueData ::TVarChar AS TelegramGroupName
           , Object.isErased   AS isErased
       FROM Object
        LEFT JOIN ObjectLink AS ObjectLink_Area_TelegramGroup
                             ON ObjectLink_Area_TelegramGroup.ObjectId = Object.Id
                            AND ObjectLink_Area_TelegramGroup.DescId = zc_ObjectLink_Area_TelegramGroup()
        LEFT JOIN Object AS Object_TelegramGroup ON Object_TelegramGroup.Id = ObjectLink_Area_TelegramGroup.ChildObjectId
       WHERE Object.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.13         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Area (0, '2')