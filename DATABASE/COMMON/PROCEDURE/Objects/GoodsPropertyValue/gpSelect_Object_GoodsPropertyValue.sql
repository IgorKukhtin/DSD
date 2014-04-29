-- Function: gpSelect_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPropertyValue(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPropertyValue(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Amount TFloat
             , BarCode TVarChar, Article TVarChar, BarCodeGLN TVarChar, ArticleGLN TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, MeasureName TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsPropertyValue());

   RETURN QUERY 
   SELECT 
         Object_GoodsPropertyValue.Id         AS Id 
       , Object_GoodsPropertyValue.ObjectCode AS Code
       , Object_GoodsPropertyValue.ValueData  AS Name

       , ObjectFloat_Amount.ValueData         AS Amount
       , ObjectString_BarCode.ValueData       AS BarCode
       , ObjectString_Article.ValueData       AS Article
       , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
       , ObjectString_ArticleGLN.ValueData    AS ArticleGLN

       , Object_GoodsProperty.Id              AS GoodsPropertyId
       , Object_GoodsProperty.ValueData       AS GoodsPropertyName

       , Object_GoodsKind.Id                  AS GoodsKindId
       , Object_GoodsKind.ValueData           AS GoodsKindName
 
       , Object_Goods.Id                      AS GoodsId
       , Object_Goods.ObjectCode              AS GoodsCode
       , Object_Goods.ValueData               AS GoodsName
       , Object_Measure.ValueData             AS MeasureName
              
       , Object_GoodsPropertyValue.isErased   AS isErased
       
   FROM Object AS Object_GoodsPropertyValue
        LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                               ON ObjectFloat_Amount.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

        LEFT JOIN ObjectString AS ObjectString_BarCode
                               ON ObjectString_BarCode.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()                     

        LEFT JOIN ObjectString AS ObjectString_Article
                               ON ObjectString_Article.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()           
        
        LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                               ON ObjectString_BarCodeGLN.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()           
        
        LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                               ON ObjectString_ArticleGLN.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()           
        
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId

   WHERE Object_GoodsPropertyValue.DescId = zc_Object_GoodsPropertyValue();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_GoodsPropertyValue(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.14                                        * add GoodsCode and MeasureName
 14.03.14         * add все свойства              
 12.06.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsPropertyValue('2')