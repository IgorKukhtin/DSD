-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail_Save(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Retail_Save(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               NDS TFloat, MinimumLot TFloat, ReferCode TFloat, ReferPrice TFloat
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
           , ObjectFloat_Goods_ReferCode.ValueData  AS ReferCode
           , ObjectFloat_Goods_ReferPrice.ValueData AS ReferPrice


    FROM Object_Goods_View 
          LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_ReferCode
                               ON ObjectFloat_Goods_ReferCode.ObjectId = Object_Goods_View.Id 
                              AND ObjectFloat_Goods_ReferCode.DescId = zc_ObjectFloat_Goods_ReferCode()   
        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_ReferPrice
                               ON ObjectFloat_Goods_ReferPrice.ObjectId = Object_Goods_View.Id 
                              AND ObjectFloat_Goods_ReferPrice.DescId = zc_ObjectFloat_Goods_ReferPrice()   
 WHERE Object_Goods_View.ObjectId = vbObjectId;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Retail_Save(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.11.14                         * 

*/

-- тест
 --SELECT * FROM gpSelect_Object_Goods('2')


