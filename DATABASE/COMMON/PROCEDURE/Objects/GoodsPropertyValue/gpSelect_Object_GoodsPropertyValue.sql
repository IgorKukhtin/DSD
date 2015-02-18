-- Function: gpSelect_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPropertyValue (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPropertyValue (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPropertyValue(
    IN inGoodsPropertyId   Integer,       -- 
    IN inShowAll           Boolean,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Amount TFloat
             , BarCode TVarChar, Article TVarChar, BarCodeGLN TVarChar, ArticleGLN TVarChar, GroupName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, MeasureName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsPropertyValue());

   IF inShowAll = FALSE
   THEN

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
       , ObjectString_GroupName.ValueData     AS GroupName

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
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId

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

        LEFT JOIN ObjectString AS ObjectString_GroupName
                               ON ObjectString_GroupName.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_GroupName.DescId = zc_ObjectString_GoodsPropertyValue_GroupName()


        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                             ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

   WHERE Object_GoodsPropertyValue.DescId = zc_Object_GoodsPropertyValue()
     AND (ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId OR inGoodsPropertyId = 0);

   ELSE 

   RETURN QUERY
 WITH tmpGoods AS (SELECT Object_Goods.Id             AS GoodsId
                        , Object_Goods.ObjectCode     AS GoodsCode 
                        , Object_Goods.ValueData      AS GoodsName
                        , Object_Measure.ValueData    AS MeasureName
                   FROM Object_InfoMoney_View
                        INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                              ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                             AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                        INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                   WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_30200())
                  )

   SELECT
         tmpObjectLink.GoodsPropertyValueId         AS Id
       , tmpObjectLink.GoodsPropertyValueCode       AS Code
       , tmpObjectLink.GoodsPropertyValueName       AS Name

       , tmpObjectLink.Amount
       , tmpObjectLink.BarCode
       , tmpObjectLink.Article
       , tmpObjectLink.BarCodeGLN
       , tmpObjectLink.ArticleGLN
       , tmpObjectLink.GroupName

       , Object_GoodsProperty.Id              AS GoodsPropertyId
       , Object_GoodsProperty.ValueData       AS GoodsPropertyName

       , tmpObjectLink. GoodsKindId
       , tmpObjectLink.GoodsKindName

       , tmpGoods.GoodsId                     AS GoodsId
       , tmpGoods.GoodsCode                   AS GoodsCode
       , tmpGoods.GoodsName                   AS GoodsName
       , tmpGoods.MeasureName                 AS MeasureName

       ,tmpObjectLink.isErased

    FROM tmpGoods 
        LEFT JOIN (SELECT Object_GoodsPropertyValue.Id          AS GoodsPropertyValueId
                        , Object_GoodsPropertyValue.ObjectCode  AS GoodsPropertyValueCode
                        , Object_GoodsPropertyValue.ValueData   AS GoodsPropertyValueName
                        , Object_GoodsPropertyValue.isErased    AS isErased
                        , ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId  as GoodsPropertyId
 
                        , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId         as GoodsId

                        , ObjectFloat_Amount.ValueData         AS Amount
                        , ObjectString_BarCode.ValueData       AS BarCode
                        , ObjectString_Article.ValueData       AS Article
                        , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
                        , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
                        , ObjectString_GroupName.ValueData     AS GroupName

                        , Object_GoodsKind.Id                  AS GoodsKindId
                        , Object_GoodsKind.ValueData           AS GoodsKindName

                   FROM ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId =  ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                          
                      LEFT JOIN Object AS Object_GoodsPropertyValue
                                       ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId 
                                       
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                            
                      LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId
        
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

                     LEFT JOIN ObjectString AS ObjectString_GroupName
                               ON ObjectString_GroupName.ObjectId = Object_GoodsPropertyValue.Id 
                              AND ObjectString_GroupName.DescId = zc_ObjectString_GoodsPropertyValue_GroupName()                      
                              
                   WHERE ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                      AND (ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId)  
                   ) AS tmpObjectLink ON tmpObjectLink.GoodsId = tmpGoods.GoodsId 
         
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = COALESCE (tmpObjectLink.GoodsPropertyId, inGoodsPropertyId)
       ;
     END IF;         
    
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.02.15         * add inGoodsPropertyId
 10.10.14                                                       *
 28.04.14                                        * add GoodsCode and MeasureName
 14.03.14         * add все свойства
 12.06.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsPropertyValue (351299 , TRUE, '2')
