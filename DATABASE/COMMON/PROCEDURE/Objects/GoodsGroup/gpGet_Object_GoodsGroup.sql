-- Function: gpGet_Object_GoodsGroup (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroup(
    IN inId          Integer,       -- Группа товаров 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ParentId Integer, ParentName TVarChar
             , GroupStatId Integer, GroupStatName TVarChar
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
           , CAST (0 as Integer)    AS ParentId
           , CAST ('' as TVarChar)  AS ParentName
           , CAST (0 as Integer)    AS GroupStatId
           , CAST ('' as TVarChar)  AS GroupStatName
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsGroup.Id            AS Id
           , Object_GoodsGroup.ObjectCode    AS Code
           , Object_GoodsGroup.ValueData     AS Name
           , GoodsGroup.Id            AS ParentId
           , GoodsGroup.ValueData     AS ParentName
           , GoodsGroupStat.Id        AS GroupStatId
           , GoodsGroupStat.ValueData AS GroupStatName
       FROM OBJECT AS Object_GoodsGroup
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                ON ObjectLink_GoodsGroup.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroup.DescId = zc_ObjectLink_GoodsGroup_Parent()
           LEFT JOIN Object AS GoodsGroup ON GoodsGroup.Id = ObjectLink_GoodsGroup.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupStat
                                ON ObjectLink_GoodsGroupStat.ObjectId = Object_GoodsGroup.Id
                               AND ObjectLink_GoodsGroupStat.DescId = zc_ObjectLink_GoodsGroup_GoodsGroupStat()
           LEFT JOIN Object AS GoodsGroupStat ON GoodsGroupStat.Id = ObjectLink_GoodsGroupStat.ChildObjectId
       WHERE Object_GoodsGroup.Id = inId;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsGroup (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.14         * add zc_ObjectLink_GoodsGroup_GoodsGroupStat
 06.09.13                         *
 12.06.13          *
 03.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_GoodsGroup('2')