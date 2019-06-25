-- Function: gpGet_Object_GoodsScaleCeh(integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsScaleCeh (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsScaleCeh(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               FromId Integer, FromName TVarChar,
               ToId Integer, ToName TVarChar,
               GoodsId Integer, GoodsName TVarChar              
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsScaleCeh());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
         
           , CAST (0 as Integer)   AS FromId  
           , CAST ('' as TVarChar) AS FromName

           , CAST (0 as Integer)   AS ToId
           , CAST ('' as TVarChar) AS ToName

           , CAST (0 as Integer)   AS GoodsId
           , CAST ('' as TVarChar) AS GoodsName
       ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_GoodsScaleCeh.Id            AS Id

         , Object_From.Id             AS FromId
         , Object_From.ValueData      AS FromName

         , Object_To.Id               AS ToId
         , Object_To.ValueData        AS ToName

         , Object_Goods.Id            AS GoodsId
         , Object_Goods.ValueData     AS GoodsName

     FROM Object AS Object_GoodsScaleCeh
          LEFT JOIN ObjectLink AS ObjectLink_GoodsScaleCeh_Goods
                               ON ObjectLink_GoodsScaleCeh_Goods.ObjectId = Object_GoodsScaleCeh.Id
                              AND ObjectLink_GoodsScaleCeh_Goods.DescId = zc_ObjectLink_GoodsScaleCeh_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsScaleCeh_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsScaleCeh_To
                              ON ObjectLink_GoodsScaleCeh_To.ObjectId = Object_GoodsScaleCeh.Id
                             AND ObjectLink_GoodsScaleCeh_To.DescId = zc_ObjectLink_GoodsScaleCeh_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_GoodsScaleCeh_To.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsScaleCeh_From
                               ON ObjectLink_GoodsScaleCeh_From.ObjectId = Object_GoodsScaleCeh.Id
                              AND ObjectLink_GoodsScaleCeh_From.DescId = zc_ObjectLink_GoodsScaleCeh_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = ObjectLink_GoodsScaleCeh_From.ChildObjectId

     WHERE Object_GoodsScaleCeh.Id = inId;
     
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.19         *
*/

-- тест
-- SELECT * FROM gpGet_Object_GoodsScaleCeh (100, '2')
