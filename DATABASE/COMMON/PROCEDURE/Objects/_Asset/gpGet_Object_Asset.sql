-- Function: gpGet_Object_Asset()

--DROP FUNCTION gpGet_Object_Asset();

CREATE OR REPLACE FUNCTION gpGet_Object_Asset(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               AssetGroupId Integer, AssetGroupCode Integer, AssetGroupName TVarChar,
               InvNumber TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Asset());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE (MAX (ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (0 as Integer)    AS AssetGroupId
           , CAST (0 as Integer)    AS AssetGroupCode
           , CAST ('' as TVarChar)  AS AssetGroupName
           , CAST ('' as TVarChar)  AS InvNumber
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_Asset();
   ELSE
     RETURN QUERY 
     SELECT 
           Object_Asset.Id            AS Id 
         , Object_Asset.ObjectCode    AS Code
         , Object_Asset.ValueData     AS Name
         
         , Asset_AssetGroup.Id         AS AssetGroupId
         , Asset_AssetGroup.ObjectCode AS AssetGroupCode
         , Asset_AssetGroup.ValueData  AS AssetGroupName
         
         , ObjectString_InvNumber.ValueData AS InvNumber
         , Object_Asset.isErased            AS isErased
     FROM OBJECT AS Object_Asset
          LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetGroup
                 ON ObjectLink_Asset_AssetGroup.ObjectId = Object_Asset.Id
                AND ObjectLink_Asset_AssetGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
          LEFT JOIN Object AS Asset_AssetGroup ON Asset_AssetGroup.Id = ObjectLink_Asset_AssetGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_InvNumber
                 ON ObjectString_InvNumber.ObjectId = Object_Asset.Id
                AND ObjectString_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()

       WHERE Object_Asset.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Asset(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Asset('2')