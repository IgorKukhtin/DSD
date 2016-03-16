-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsAll_Retail(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsAll_Retail(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               GoodsMainId Integer,
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               NDS TFloat, MinimumLot TFloat, isClose boolean, 
               isTOP boolean, isPromo boolean,
               PercentMarkup TFloat, Price TFloat,
               ObjectDescName TVarChar, ObjectName TVarChar,
               MakerName TVarChar
              ) AS
$BODY$ 
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   RETURN QUERY 
   SELECT 
             Object_Goods_View.Id
           , Object_Goods_View.GoodsCodeInt     AS Code
          -- , ObjectString.ValueData             AS GoodsCode
           , Object_Goods_View.GoodsName        AS Name
           , Object_Goods_View.isErased
           , LinkGoods_Main.GoodsMainId 
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
           , COALESCE(ObjectBoolean_Goods_IsPromo.ValueData,FALSE)  AS IsPromo      
           , Object_Goods_View.PercentMarkup  
           , Object_Goods_View.Price
           , ObjectDesc_GoodsObject.itemname   AS  ObjectDescName
           , Object_GoodsObject.ValueData       AS  ObjectName
           , Object_Goods_View.MakerName
    FROM Object_Goods_View 
       LEFT JOIN  Object_LinkGoods_View AS LinkGoods_Main ON LinkGoods_Main.GoodsId = Object_Goods_View.Id

       LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = Object_Goods_View.ObjectId
       LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId

       LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                               ON ObjectBoolean_Goods_IsPromo.ObjectId = Object_Goods_View.Id
                              AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()

   WHERE Object_Goods_View.ObjectId = vbObjectId;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.02.16         *


*/

-- тест
 --SELECT * FROM gpSelect_Object_GoodsAll_Retail('2')


