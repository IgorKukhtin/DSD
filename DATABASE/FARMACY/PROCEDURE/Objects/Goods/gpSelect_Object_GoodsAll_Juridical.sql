-- Function: gpSelect_Object_Goods()
 
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsAll_Juridical(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsAll_Juridical(
     IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer--, GoodsMainCode Integer, GoodsMainName TVarChar
             , GoodsId Integer, GoodsCodeInt Integer, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar, NDS TFloat

             , MinimumLot TFloat, isClose boolean, isTOP boolean, isPromo boolean
             , PercentMarkup TFloat, Price TFloat
             --, IsUpload Boolean, IsPromo Boolean, isSpecCondition Boolean
             , ObjectDescName TVarChar, ObjectName TVarChar
             , MakerName TVarChar
             , isErased boolean
            
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
             Object_Goods_View.ObjectId         AS Id 
           , LinkGoods_Main.GoodsMainId  
           , Object_Goods_View.Id               AS GoodsId 
           , Object_Goods_View.GoodsCodeInt     AS GoodsCodeInt
           , Object_Goods_View.GoodsName        AS GoodsName
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
           , ObjectDesc_GoodsObject.itemname    AS  ObjectDescName
           , Object_GoodsObject.ValueData       AS  ObjectName
           , Object_Goods_View.MakerName
           , Object_Goods_View.isErased

    FROM Object_Goods_View 
       LEFT JOIN  Object_LinkGoods_View AS LinkGoods_Main ON LinkGoods_Main.GoodsId = Object_Goods_View.Id

       LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = Object_Goods_View.ObjectId
       LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId

       LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                               ON ObjectBoolean_Goods_IsPromo.ObjectId = Object_Goods_View.Id
                              AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()
          
   WHERE Object_Goods_View.ObjectId <> vbObjectId;
                        
  
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
 --SELECT * FROM gpSelect_Object_GoodsAll_Juridical('3')