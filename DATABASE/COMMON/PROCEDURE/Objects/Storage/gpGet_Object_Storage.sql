-- Function: gpGet_Object_Storage()

DROP FUNCTION IF EXISTS gpGet_Object_Storage(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Storage(
    IN inId          Integer,       -- ключ объекта <Места хранения>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar 
             , AreaUnitId Integer, AreaUnitName TVarChar, Room TVarChar
             , Address TVarChar, Comment TVarChar
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
           , lfGet_ObjectCode(0, zc_Object_Storage()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)    AS UnitId
           , CAST ('' as TVarChar)  AS UnitName

           , CAST (0 as Integer)    AS AreaUnitId
           , CAST ('' as TVarChar)  AS AreaUnitName
           , CAST ('' as TVarChar)  AS Room
           , CAST ('' as TVarChar)  AS Address
           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Storage.Id         AS Id
           , Object_Storage.ObjectCode AS Code
           , Object_Storage.ValueData  AS Name

           , Object_Unit.Id            AS UnitId
           , Object_Unit.ValueData     AS UnitName

           , Object_AreaUnit.Id            AS AreaUnitId
           , Object_AreaUnit.ValueData     AS AreaUnitName
           , ObjectString_Storage_Room.ValueData      AS Room
           , ObjectString_Storage_Address.ValueData   AS Address
           , ObjectString_Storage_Comment.ValueData   AS Comment

           , Object_Storage.isErased   AS isErased

       FROM Object AS Object_Storage
            LEFT JOIN ObjectString AS ObjectString_Storage_Address
                                   ON ObjectString_Storage_Address.ObjectId = Object_Storage.Id 
                                  AND ObjectString_Storage_Address.DescId = zc_ObjectString_Storage_Address()
            LEFT JOIN ObjectString AS ObjectString_Storage_Comment
                                   ON ObjectString_Storage_Comment.ObjectId = Object_Storage.Id 
                                  AND ObjectString_Storage_Comment.DescId = zc_ObjectString_Storage_Comment()
            LEFT JOIN ObjectString AS ObjectString_Storage_Room
                                   ON ObjectString_Storage_Room.ObjectId = Object_Storage.Id 
                                  AND ObjectString_Storage_Room.DescId = zc_ObjectString_Storage_Room()

            LEFT JOIN ObjectLink AS ObjectLink_Storage_Unit
                                 ON ObjectLink_Storage_Unit.ObjectId = Object_Storage.Id 
                                AND ObjectLink_Storage_Unit.DescId = zc_ObjectLink_Storage_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Storage_Unit.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Storage_AreaUnit
                                 ON ObjectLink_Storage_AreaUnit.ObjectId = Object_Storage.Id 
                                AND ObjectLink_Storage_AreaUnit.DescId = zc_ObjectLink_Storage_AreaUnit()
            LEFT JOIN Object AS Object_AreaUnit ON Object_AreaUnit.Id = ObjectLink_Storage_AreaUnit.ChildObjectId
       WHERE Object_Storage.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Storage(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.07.16         *
 28.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Storage (0, '2')