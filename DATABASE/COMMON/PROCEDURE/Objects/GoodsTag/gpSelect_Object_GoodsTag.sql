-- Function: gpSelect_Object_GoodsTag()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsTag(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsTag(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, GoodsGroupAnalystId Integer, GoodsGroupAnalystName TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsTag()());

   RETURN QUERY 
   SELECT 
     Object_GoodsTag.Id         AS Id 
   , Object_GoodsTag.ObjectCode AS Code
   , Object_GoodsTag.ValueData  AS NAME
   
   , Object_GoodsGroupAnalyst.Id           AS GoodsGroupAnalystId
   , Object_GoodsGroupAnalyst.ValueData    AS GoodsGroupAnalystName  

   , Object_GoodsTag.isErased   AS isErased
   
   FROM Object AS Object_GoodsTag
          LEFT JOIN ObjectLink AS ObjectLink_GoodsTag_GoodsGroupAnalyst
                               ON ObjectLink_GoodsTag_GoodsGroupAnalyst.ObjectId = Object_GoodsTag.Id 
                              AND ObjectLink_GoodsTag_GoodsGroupAnalyst.DescId = zc_ObjectLink_GoodsTag_GoodsGroupAnalyst()
          LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_GoodsTag_GoodsGroupAnalyst.ChildObjectId  

   WHERE Object_GoodsTag.DescId = zc_Object_GoodsTag();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsTag(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.15         * add GoodsGroupAnalyst  
 15.09.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsTag('2')