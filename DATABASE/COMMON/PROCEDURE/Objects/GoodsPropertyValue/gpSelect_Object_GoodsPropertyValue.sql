-- Function: gpSelect_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPropertyValue (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPropertyValue (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPropertyValue(
    IN inGoodsPropertyId   Integer,       -- 
    IN inShowAll           Boolean,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Amount TFloat, BoxCount TFloat, AmountDoc TFloat
             , BarCodeShort TVarChar, BarCode TVarChar, Article TVarChar, BarCodeGLN TVarChar, ArticleGLN TVarChar, GroupName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsBoxId Integer, GoodsBoxCode Integer, GoodsBoxName TVarChar
             , isOrder Boolean
             , isErased Boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsPropertyValue());

   IF inShowAll = FALSE
   THEN

   RETURN QUERY
   WITH 
   tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                , ObjectBoolean_Order.ValueData AS isOrder
                           FROM ObjectBoolean AS ObjectBoolean_Order
                                LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                           WHERE ObjectBoolean_Order.ValueData = TRUE
                             AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                           )

   SELECT
         Object_GoodsPropertyValue.Id         AS Id
       , Object_GoodsPropertyValue.ObjectCode AS Code
       , Object_GoodsPropertyValue.ValueData  AS Name

       , ObjectFloat_Amount.ValueData         AS Amount
       , ObjectFloat_BoxCount.ValueData       AS BoxCount
       , ObjectFloat_AmountDoc.ValueData      AS AmountDoc
       , ObjectString_BarCodeShort.ValueData  AS BarCodeShort
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
       , Object_GoodsGroup.ValueData          AS GoodsGroupName 
       , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

       , Object_GoodsBox.Id                   AS GoodsBoxId
       , Object_GoodsBox.ObjectCode           AS GoodsBoxCode
       , Object_GoodsBox.ValueData            AS GoodsBoxName

       , COALESCE (tmpGoodsByGoodsKind.isOrder, FALSE) :: Boolean AS isOrder
       , Object_GoodsPropertyValue.isErased   AS isErased

   FROM Object AS Object_GoodsPropertyValue
        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                             ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                              ON ObjectFloat_Amount.ObjectId = Object_GoodsPropertyValue.Id
                             AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()

        LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                              ON ObjectFloat_BoxCount.ObjectId = Object_GoodsPropertyValue.Id
                             AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()

        LEFT JOIN ObjectFloat AS ObjectFloat_AmountDoc
                              ON ObjectFloat_AmountDoc.ObjectId = Object_GoodsPropertyValue.Id
                             AND ObjectFloat_AmountDoc.DescId = zc_ObjectFloat_GoodsPropertyValue_AmountDoc()

        LEFT JOIN ObjectString AS ObjectString_BarCodeShort
                               ON ObjectString_BarCodeShort.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_BarCodeShort.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeShort()
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

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                             ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
        LEFT JOIN Object AS Object_GoodsBox ON Object_GoodsBox.Id = ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

        LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = Object_Goods.Id
                                     AND tmpGoodsByGoodsKind.GoodsKindId = Object_GoodsKind.Id 

   WHERE Object_GoodsPropertyValue.DescId = zc_Object_GoodsPropertyValue()
     AND (ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId OR inGoodsPropertyId = 0);

   ELSE 

   RETURN QUERY
 WITH tmpGoods AS (SELECT Object_Goods.Id             AS GoodsId
                        , Object_Goods.ObjectCode     AS GoodsCode 
                        , Object_Goods.ValueData      AS GoodsName
                        , Object_Measure.ValueData    AS MeasureName
                        , Object_GoodsGroup.ValueData AS GoodsGroupName 
                        , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
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

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                              AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                   WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Прочее сырье
                                                                        -- , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                                        , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                        , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                        , zc_Enum_InfoMoneyDestination_20900() -- Ирна
                                                                        , zc_Enum_InfoMoneyDestination_21000() -- Чапли
                                                                        , zc_Enum_InfoMoneyDestination_21100() -- Дворкин
                                                                        , zc_Enum_InfoMoneyDestination_30100() -- Готовая продукция
                                                                        , zc_Enum_InfoMoneyDestination_30200() -- Тушенка
                                                                         )
                  )
 , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                , ObjectBoolean_Order.ValueData AS isOrder
                           FROM ObjectBoolean AS ObjectBoolean_Order
                                LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                           WHERE ObjectBoolean_Order.ValueData = TRUE
                             AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                           )

   SELECT
         tmpObjectLink.GoodsPropertyValueId         AS Id
       , tmpObjectLink.GoodsPropertyValueCode       AS Code
       , tmpObjectLink.GoodsPropertyValueName       AS Name

       , tmpObjectLink.Amount
       , tmpObjectLink.BoxCount
       , tmpObjectLink.AmountDoc
       , tmpObjectLink.BarCodeShort
       , tmpObjectLink.BarCode
       , tmpObjectLink.Article
       , tmpObjectLink.BarCodeGLN
       , tmpObjectLink.ArticleGLN
       , tmpObjectLink.GroupName

       , Object_GoodsProperty.Id              AS GoodsPropertyId
       , Object_GoodsProperty.ValueData       AS GoodsPropertyName

       , tmpObjectLink.GoodsKindId
       , tmpObjectLink.GoodsKindName

       , tmpGoods.GoodsId                     AS GoodsId
       , tmpGoods.GoodsCode                   AS GoodsCode
       , tmpGoods.GoodsName                   AS GoodsName
       , tmpGoods.MeasureName                 AS MeasureName

       , tmpGoods.GoodsGroupName 
       , tmpGoods.GoodsGroupNameFull

       , tmpObjectLink.GoodsBoxId
       , tmpObjectLink.GoodsBoxCode
       , tmpObjectLink.GoodsBoxName

       , COALESCE (tmpGoodsByGoodsKind.isOrder, FALSE) :: Boolean AS isOrder
       ,tmpObjectLink.isErased

    FROM tmpGoods 
        LEFT JOIN (SELECT Object_GoodsPropertyValue.Id          AS GoodsPropertyValueId
                        , Object_GoodsPropertyValue.ObjectCode  AS GoodsPropertyValueCode
                        , Object_GoodsPropertyValue.ValueData   AS GoodsPropertyValueName
                        , Object_GoodsPropertyValue.isErased    AS isErased
                        , ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId  as GoodsPropertyId
 
                        , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId          as GoodsId

                        , ObjectFloat_Amount.ValueData         AS Amount
                        , ObjectFloat_BoxCount.ValueData       AS BoxCount
                        , ObjectFloat_AmountDoc.ValueData      AS AmountDoc
                        , ObjectString_BarCodeShort.ValueData  AS BarCodeShort
                        , ObjectString_BarCode.ValueData       AS BarCode
                        , ObjectString_Article.ValueData       AS Article
                        , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
                        , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
                        , ObjectString_GroupName.ValueData     AS GroupName

                        , Object_GoodsKind.Id                  AS GoodsKindId
                        , Object_GoodsKind.ValueData           AS GoodsKindName

                        , Object_GoodsBox.Id                   AS GoodsBoxId
                        , Object_GoodsBox.ObjectCode           AS GoodsBoxCode
                        , Object_GoodsBox.ValueData            AS GoodsBoxName
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

                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                           ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = Object_GoodsPropertyValue.Id
                                          AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
                      LEFT JOIN Object AS Object_GoodsBox ON Object_GoodsBox.Id = ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId

                      LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                            ON ObjectFloat_Amount.ObjectId = Object_GoodsPropertyValue.Id 
                                           AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
                      LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                            ON ObjectFloat_BoxCount.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()
                      LEFT JOIN ObjectFloat AS ObjectFloat_AmountDoc
                                            ON ObjectFloat_AmountDoc.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectFloat_AmountDoc.DescId = zc_ObjectFloat_GoodsPropertyValue_AmountDoc()

                      LEFT JOIN ObjectString AS ObjectString_BarCodeShort
                                             ON ObjectString_BarCodeShort.ObjectId = Object_GoodsPropertyValue.Id
                                            AND ObjectString_BarCodeShort.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeShort()
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

        LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = tmpGoods.GoodsId
                                     AND tmpGoodsByGoodsKind.GoodsKindId = tmpObjectLink.GoodsKindId
       ;
     END IF;         
    
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.02.18         * add GoodsBox
 22.06.17         * add AmountDoc
 03.05.17         * add GoodsGroupName, GoodsGroupNameFull
 01.02.17         * add isOrder 
 17.09.15         * add BoxCount
 13.02.15         * add inGoodsPropertyId
 10.10.14                                                       *
 28.04.14                                        * add GoodsCode and MeasureName
 14.03.14         * add все свойства
 12.06.13         *
*/
/*
select GoodsPropertyId, GoodsId, GoodsKindId
from gpSelect_Object_GoodsPropertyValue(inGoodsPropertyId := 0 , inShowAll := 'False' ,  inSession := '5') as a
group by GoodsPropertyId, GoodsId, GoodsKindId
having Count(*)  > 1
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsPropertyValue (351299 , TRUE, '2')
