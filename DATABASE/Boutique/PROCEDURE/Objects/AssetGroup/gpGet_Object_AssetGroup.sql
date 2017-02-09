-- Function: gpGet_Object_AssetGroup()

--DROP FUNCTION gpGet_Object_AssetGroup();

CREATE OR REPLACE FUNCTION gpGet_Object_AssetGroup(
    IN inId          Integer,       --  Группы основных средств 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ParentId Integer, ParentCode Integer, ParentName TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_AssetGroup());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as Integer)    AS ParentId
           , CAST (0 as Integer)    AS ParentCode
           , CAST ('' as TVarChar)  AS ParentName
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_AssetGroup();
   ELSE
     RETURN QUERY 
     SELECT 
           Object_AssetGroup.Id            AS Id 
         , Object_AssetGroup.ObjectCode    AS Code
         , Object_AssetGroup.ValueData     AS Name
         
         , AssetGroup_Parent.Id         AS ParentId
         , AssetGroup_Parent.ObjectCode AS ParentCode
         , AssetGroup_Parent.ValueData  AS ParentName
         
         , Object_AssetGroup.isErased   AS isErased
     FROM OBJECT AS Object_AssetGroup
          LEFT JOIN ObjectLink AS ObjectLink_AssetGroup_Parent
                 ON ObjectLink_AssetGroup_Parent.ObjectId = Object_AssetGroup.Id
                AND ObjectLink_AssetGroup_Parent.DescId = zc_ObjectLink_AssetGroup_Parent()
          LEFT JOIN Object AS AssetGroup_Parent ON AssetGroup_Parent.Id = ObjectLink_AssetGroup_Parent.ChildObjectId
       WHERE Object_AssetGroup.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_AssetGroup(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.13          *

*/

-- тест
-- SELECT * FROM gpSelect_AssetGroup('2')