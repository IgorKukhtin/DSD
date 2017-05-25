-- Function: gpGet_Object_StorageLine()

DROP FUNCTION IF EXISTS gpGet_Object_StorageLine(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StorageLine(
    IN inId          Integer,       -- ключ объекта <Места хранения>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar
             , isErased boolean
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_StorageLine()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)    AS UnitId
           , CAST ('' as TVarChar)  AS UnitName

           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_StorageLine.Id         AS Id
            , Object_StorageLine.ObjectCode AS Code
            , Object_StorageLine.ValueData  AS Name

            , Object_Unit.Id            AS UnitId
            , Object_Unit.ValueData     AS UnitName

            , ObjectString_StorageLine_Comment.ValueData   AS Comment
            , Object_StorageLine.isErased   AS isErased
       FROM Object AS Object_StorageLine
            LEFT JOIN ObjectString AS ObjectString_StorageLine_Comment
                                   ON ObjectString_StorageLine_Comment.ObjectId = Object_StorageLine.Id 
                                  AND ObjectString_StorageLine_Comment.DescId = zc_ObjectString_StorageLine_Comment()
            LEFT JOIN ObjectLink AS ObjectLink_StorageLine_Unit
                                 ON ObjectLink_StorageLine_Unit.ObjectId = Object_StorageLine.Id 
                                AND ObjectLink_StorageLine_Unit.DescId = zc_ObjectLink_StorageLine_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_StorageLine_Unit.ChildObjectId
       WHERE Object_StorageLine.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.16         *
*/

-- тест
-- SELECT * FROM gpGet_Object_StorageLine (0, '2')