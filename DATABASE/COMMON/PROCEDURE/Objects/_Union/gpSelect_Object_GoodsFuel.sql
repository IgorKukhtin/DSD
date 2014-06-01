-- Function: gpSelect_Object_GoodsFuel()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsFuel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsFuel(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, GoodsGroupName TVarChar, ItemName TVarChar, isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       WITH tmpUserTransport AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Transport())
     SELECT Object_Goods.Id
          , Object_Goods.ObjectCode AS Code
          , Object_Goods.ValueData AS Name
          , Object_GoodsGroup.ValueData AS GoodsGroupName
          , ObjectDesc.ItemName AS DescName
          , Object_Goods.isErased
     FROM Object AS Object_Goods
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup 
                           ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                          AND Object_GoodsGroup.DescId = zc_Object_GoodsGroup()
         
          LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                               ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
     WHERE Object_Goods.DescId = zc_Object_Goods()
       AND (COALESCE (ObjectLink_Goods_Fuel.ChildObjectId,0) = 0
         OR vbUserId NOT IN (SELECT UserId FROM tmpUserTransport))
   UNION ALL
     SELECT Object_Fuel.Id
          , Object_Fuel.ObjectCode AS Code     
          , Object_Fuel.ValueData AS Name
          , ''::TVarChar AS GoodsGroupName
          , ObjectDesc.ItemName AS DescName
          , Object_Fuel.isErased
     FROM Object AS Object_Fuel
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Fuel.DescId
     WHERE Object_Fuel.DescId = zc_Object_Fuel()
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsFuel (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.14                                        * add tmpUserTransport
 10.02.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsFuel (inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_GoodsFuel (inSession := '9818')
