-- Function: gpSelect_Object_Storage()

DROP FUNCTION IF EXISTS gpSelect_Object_Storage(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Storage(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar, BranchName TVarChar
             , AreaUnitId Integer, AreaUnitName TVarChar, Room TVarChar
             , Address TVarChar, Comment TVarChar
             , isErased boolean
) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Storage()());

   RETURN QUERY 
   SELECT 
     Object_Storage.Id         AS Id 
   , Object_Storage.ObjectCode AS Code
   , Object_Storage.ValueData  AS Name

   , Object_Unit.Id            AS UnitId
   , Object_Unit.ValueData     AS UnitName
   , Object_Branch.ValueData   AS BranchName

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

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

   WHERE Object_Storage.DescId = zc_Object_Storage();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Storage(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.07.16         *
 28.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Storage('2')