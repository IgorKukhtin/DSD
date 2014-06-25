-- Function: gpGet_Object_GoodsGroup (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroup(
    IN inId          Integer,       -- Группа товаров 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean
             , ParentId Integer, ParentName TVarChar
              )
AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsGroup()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
           , CAST (0 as Integer)    AS ParentId
           , CAST ('' as TVarChar)  AS ParentName;
   ELSE
       RETURN QUERY 
       SELECT 
           Object_GoodsGroup.Id         AS Id 
         , Object_GoodsGroup.ObjectCode AS Code
         , Object_GoodsGroup.ValueData  AS Name
         , Object_GoodsGroup.isErased   AS isErased

         , Object_Parent.Id         AS ParentId
         , Object_Parent.ValueData  AS ParentName

       FROM OBJECT AS Object_GoodsGroup
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = Object_GoodsGroup.Id
                                AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_GoodsGroup.ChildObjectId

       WHERE Object_GoodsGroup.Id = inId;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsGroup (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.14         *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsGroup('2')