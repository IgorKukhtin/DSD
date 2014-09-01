-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Juridical(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Juridical(
    IN inObjectId    INTEGER , 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, GoodsCode TVarChar, Name TVarChar, isErased boolean, 
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar
              ) AS
$BODY$
BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
             Object_Goods_View.Id
           , Object_Goods_View.GoodsCodeInt
           , ObjectString.ValueData                           AS GoodsCode
           , Object_Goods_View.GoodsName
           , Object_Goods_View.isErased
           , Object_Goods_View.GoodsGroupId
           , Object_Goods_View.GoodsGroupName
           , Object_Goods_View.MeasureId
           , Object_Goods_View.MeasureName
           , Object_Goods_View.NDSKindId
           , Object_Goods_View.NDSKindName

    FROM Object_Goods_View 
   WHERE Object_Goods_View.ObjectId = inObjectId;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Juridical(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.06.14         *
 20.06.13                         *

*/

-- тест
 --SELECT * FROM gpSelect_Object_Goods('2')


