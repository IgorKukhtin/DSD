-- Function: gpSelect_Object_GoodsFuel()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsFuel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsFuel(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , MeasureName TVarChar
             , Weight TFloat
             , ItemName TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbIsIrna Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Ирна!!!
     vbIsIrna:= zfCalc_User_isIrna (vbUserId);


     RETURN QUERY
       WITH tmpUserTransport AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Transport())
     SELECT Object_Goods.Id
          , Object_Goods.ObjectCode AS Code
          , zfCalc_Text_replace (Object_Goods.ValueData, CHR (39), '`' ) :: TVarChar AS Name
          , Object_GoodsGroup.ValueData AS GoodsGroupName
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
          , Object_Measure.ValueData     AS MeasureName
          , ObjectFloat_Weight.ValueData AS Weight
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
         
          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel
                               ON ObjectLink_Goods_Fuel.ObjectId = Object_Goods.Id 
                              AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                  ON ObjectBoolean_Guide_Irna.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

     WHERE Object_Goods.DescId = zc_Object_Goods()
       AND (COALESCE (ObjectLink_Goods_Fuel.ChildObjectId,0) = 0
         OR vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
           )
       AND (COALESCE (vbIsIrna, FALSE) = FALSE
         OR (vbIsIrna = TRUE  AND ObjectBoolean_Guide_Irna.ValueData = TRUE)
           )

   UNION ALL
     SELECT Object_Asset.Id
          , Object_Asset.ObjectCode AS Code
          , zfCalc_Text_replace (Object_Asset.ValueData, CHR (39), '`' ) :: TVarChar AS Name
          , Object_AssetGroup.ValueData AS GoodsGroupName
          , ObjectString_Asset_FullName.ValueData AS GoodsGroupNameFull
          , ''      :: TVarChar AS MeasureName
          , 0       :: TFloat   AS Weight
          , ObjectDesc.ItemName AS DescName
          , Object_Asset.isErased
     FROM Object AS Object_Asset
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Asset.DescId
          LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetGroup
                               ON ObjectLink_Asset_AssetGroup.ObjectId = Object_Asset.Id
                              AND ObjectLink_Asset_AssetGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
          LEFT JOIN Object AS Object_AssetGroup
                           ON Object_AssetGroup.Id = ObjectLink_Asset_AssetGroup.ChildObjectId
         
          LEFT JOIN ObjectString AS ObjectString_Asset_FullName
                                 ON ObjectString_Asset_FullName.ObjectId = Object_Asset.Id
                                AND ObjectString_Asset_FullName.DescId = zc_ObjectString_Asset_FullName()

     WHERE Object_Asset.DescId = zc_Object_Asset()
       AND vbUserId NOT IN (SELECT UserId FROM tmpUserTransport)
       AND COALESCE (vbIsIrna, FALSE) = FALSE

   UNION ALL
     SELECT Object_Fuel.Id
          , Object_Fuel.ObjectCode AS Code     
          , Object_Fuel.ValueData AS Name
          , '' :: TVarChar AS GoodsGroupName
          , '' :: TVarChar AS GoodsGroupNameFull
          , '' :: TVarChar AS MeasureName
          , 0  :: TFloat   AS Weight
          , ObjectDesc.ItemName AS DescName
          , Object_Fuel.isErased
     FROM Object AS Object_Fuel
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Fuel.DescId
     WHERE Object_Fuel.DescId = zc_Object_Fuel()
       AND COALESCE (vbIsIrna, FALSE) = FALSE
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
