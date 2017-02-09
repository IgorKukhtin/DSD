-- Function: gpSelect_Object_GoodsExternal()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsExternal( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsExternal(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
            
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

       RETURN QUERY 
       SELECT 
             Object_GoodsExternal.Id         AS Id
           , Object_GoodsExternal.ObjectCode AS Code
           , Object_GoodsExternal.ValueData  AS NAME

           , Object_Goods.Id                 AS GoodsId
           , Object_Goods.ValueData          AS GoodsName       
           , Object_GoodsKind.Id             AS GoodsKindId
           , Object_GoodsKind.ValueData      AS GoodsKindName   
           , Object_GoodsExternal.isErased   AS isErased

       FROM OBJECT AS Object_GoodsExternal
        LEFT JOIN ObjectLink AS ObjectLink_GoodsExternal_Goods
                             ON ObjectLink_GoodsExternal_Goods.ObjectId = Object_GoodsExternal.Id 
                            AND ObjectLink_GoodsExternal_Goods.DescId = zc_ObjectLink_GoodsExternal_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsExternal_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsExternal_GoodsKind
                             ON ObjectLink_GoodsExternal_GoodsKind.ObjectId = Object_GoodsExternal.Id 
                            AND ObjectLink_GoodsExternal_GoodsKind.DescId = zc_ObjectLink_GoodsExternal_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsExternal_GoodsKind.ChildObjectId
                              
       WHERE Object_GoodsExternal.DescId = zc_Object_GoodsExternal();
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.12.15         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsExternal ( zfCalc_UserAdmin())
