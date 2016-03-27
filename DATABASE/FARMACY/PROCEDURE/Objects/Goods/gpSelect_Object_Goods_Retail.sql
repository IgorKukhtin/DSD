-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Retail(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , NDS TFloat, MinimumLot TFloat, isClose Boolean
             , isTOP Boolean, isFirst Boolean
             , PercentMarkup TFloat, Price TFloat
             , Color_calc Integer
             , RetailCode Integer, RetailName TVarChar
              ) AS
$BODY$ 
  DECLARE vbUserId Integer;

  DECLARE vbObjectId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- поиск <Торговой сети>
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- !!!для Админа!!!
   IF (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
   RETURN QUERY 
   SELECT 
             Object_Goods_View.Id
           , Object_Goods_View.GoodsCodeInt
--           , ObjectString.ValueData                           AS GoodsCode
           , Object_Goods_View.GoodsName
           , Object_Goods_View.isErased
           , Object_Goods_View.GoodsGroupId
           , Object_Goods_View.GoodsGroupName
           , Object_Goods_View.MeasureId
           , Object_Goods_View.MeasureName
           , Object_Goods_View.NDSKindId
           , Object_Goods_View.NDSKindName
           , Object_Goods_View.NDS
           , Object_Goods_View.MinimumLot
           , Object_Goods_View.isClose
           , Object_Goods_View.isTOP          
           , Object_Goods_View.isFirst
           , Object_Goods_View.PercentMarkup  
           , Object_Goods_View.Price
           , CASE WHEN Object_Goods_View.isFirst = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc
           , Object_Retail.ObjectCode AS RetailCode
           , Object_Retail.ValueData  AS RetailName
    FROM Object AS Object_Retail
         INNER JOIN Object_Goods_View ON Object_Goods_View.ObjectId = Object_Retail.Id
    WHERE Object_Retail.DescId = zc_Object_Retail();

   ELSE

   -- для остальных...

   RETURN QUERY 
   SELECT 
             Object_Goods_View.Id
           , Object_Goods_View.GoodsCodeInt
--           , ObjectString.ValueData                           AS GoodsCode
           , Object_Goods_View.GoodsName
           , Object_Goods_View.isErased
           , Object_Goods_View.GoodsGroupId
           , Object_Goods_View.GoodsGroupName
           , Object_Goods_View.MeasureId
           , Object_Goods_View.MeasureName
           , Object_Goods_View.NDSKindId
           , Object_Goods_View.NDSKindName
           , Object_Goods_View.NDS
           , Object_Goods_View.MinimumLot
           , Object_Goods_View.isClose
           , Object_Goods_View.isTOP          
           , Object_Goods_View.isFirst
           , Object_Goods_View.PercentMarkup  
           , Object_Goods_View.Price
           , CASE WHEN Object_Goods_View.isFirst = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc
           , Object_Retail.ObjectCode AS RetailCode
           , Object_Retail.ValueData  AS RetailName
    FROM Object_Goods_View
         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = Object_Goods_View.ObjectId
    WHERE Object_Goods_View.ObjectId = vbObjectId;

   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.16                                        *
 16.02.15                         * 
 13.11.14                         * Add MinimumLot
 24.06.14         *
 20.06.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods_Retail (zfCalc_UserAdmin())
