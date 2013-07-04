-- Function: gpSelect_Object_AssetGroup()

--DROP FUNCTION gpSelect_Object_AssetGroup();

CREATE OR REPLACE FUNCTION gpSelect_Object_AssetGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ParentId Integer, ParentCode Integer, ParentName TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AssetGroup());

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
    WHERE Object_AssetGroup.DescId = zc_Object_AssetGroup();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AssetGroup(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_AssetGroup('2')