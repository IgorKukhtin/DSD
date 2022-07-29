-- Function: gpSelect_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPropertyValue (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_GoodsPropertyValue (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsPropertyValue(
    IN inGoodsPropertyId   Integer,       -- 
    IN inShowAll           Boolean,
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NameExternal TVarChar, ArticleExternal TVarChar
             , Amount TFloat, BoxCount TFloat, AmountDoc TFloat
             , BarCodeShort TVarChar, BarCode TVarChar, Article TVarChar, BarCodeGLN TVarChar, ArticleGLN TVarChar
             , CodeSticker TVarChar
             , GroupName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, MeasureName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsBoxId Integer, GoodsBoxCode Integer, GoodsBoxName TVarChar
             , GoodsKindSubId Integer, GoodsKindSubCode Integer, GoodsKindSubName TVarChar
             , Quality TVarChar, Quality2 TVarChar, Quality10 TVarChar
             , GoodsBrandName TVarChar
             , isOrder Boolean
             , isWeigth Boolean 
             , isGoodsKind Boolean
             , isErased Boolean
             , isGoodsTypeKind_Sh Boolean, isGoodsTypeKind_Nom Boolean, isGoodsTypeKind_Ves Boolean
             , BoxId Integer, BoxCode Integer, BoxName TVarChar
             , WeightOnBox TFloat, CountOnBox  TFloat
             )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsPropertyValue());

   IF inShowAll = FALSE
   THEN

   RETURN QUERY
   WITH 
   tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId                   AS GoodsId
                                , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                , ObjectBoolean_Order.ValueData                          AS isOrder
                                , Object_GoodsBrand.ValueData                            AS GoodsBrandName
                           FROM Object_GoodsByGoodsKind_View
                                LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                                        ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                       AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                              
                                LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBrand
                                                     ON ObjectLink_GoodsByGoodsKind_GoodsBrand.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                    AND ObjectLink_GoodsByGoodsKind_GoodsBrand.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBrand()
                                LEFT JOIN Object AS Object_GoodsBrand ON Object_GoodsBrand.Id = ObjectLink_GoodsByGoodsKind_GoodsBrand.ChildObjectId
                             
                           WHERE ObjectBoolean_Order.ValueData = TRUE 
                              OR COALESCE (ObjectLink_GoodsByGoodsKind_GoodsBrand.ChildObjectId, 0) <> 0
                           )

   SELECT
         Object_GoodsPropertyValue.Id         AS Id
       , Object_GoodsPropertyValue.ObjectCode AS Code
       , Object_GoodsPropertyValue.ValueData  AS Name
       , ObjectString_NameExternal.ValueData    AS NameExternal
       , ObjectString_ArticleExternal.ValueData AS ArticleExternal

       , ObjectFloat_Amount.ValueData         AS Amount
       , ObjectFloat_BoxCount.ValueData       AS BoxCount
       , ObjectFloat_AmountDoc.ValueData      AS AmountDoc
       , ObjectString_BarCodeShort.ValueData  AS BarCodeShort
       , ObjectString_BarCode.ValueData       AS BarCode
       , ObjectString_Article.ValueData       AS Article
       , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
       , ObjectString_ArticleGLN.ValueData    AS ArticleGLN
       , ObjectString_CodeSticker.ValueData   AS CodeSticker
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

       , Object_GoodsKindSub.Id               AS GoodsKindSubId
       , Object_GoodsKindSub.ObjectCode       AS GoodsKindSubCode
       , Object_GoodsKindSub.ValueData        AS GoodsKindSubName

       , ObjectString_Quality.ValueData       AS Quality
       , ObjectString_Quality2.ValueData      AS Quality2
       , ObjectString_Quality10.ValueData     AS Quality10
       
       , tmpGoodsByGoodsKind.GoodsBrandName :: TVarChar
       
       , COALESCE (tmpGoodsByGoodsKind.isOrder, FALSE)         :: Boolean AS isOrder
       , COALESCE (ObjectBoolean_Weigth.ValueData, FALSE)      :: Boolean AS isWeigth
       , COALESCE (ObjectBoolean_isGoodsKind.ValueData, FALSE) :: Boolean AS isGoodsKind
       , Object_GoodsPropertyValue.isErased   AS isErased

       , CASE WHEN COALESCE (ObjectLink_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Sh
       , CASE WHEN COALESCE (ObjectLink_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Nom
       , CASE WHEN COALESCE (ObjectLink_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Ves
       
       , Object_Box.Id                          AS BoxId
       , Object_Box.ObjectCode                  AS BoxCode
       , Object_Box.ValueData                   AS BoxName
       , ObjectFloat_WeightOnBox.ValueData      AS WeightOnBox
       , ObjectFloat_CountOnBox.ValueData       AS CountOnBox

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

        LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                              ON ObjectFloat_WeightOnBox.ObjectId = Object_GoodsPropertyValue.Id
                             AND ObjectFloat_WeightOnBox.DescId = zc_ObjectFloat_GoodsPropertyValue_WeightOnBox()
        LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                              ON ObjectFloat_CountOnBox.ObjectId = Object_GoodsPropertyValue.Id
                             AND ObjectFloat_CountOnBox.DescId = zc_ObjectFloat_GoodsPropertyValue_CountOnBox()

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

        LEFT JOIN ObjectString AS ObjectString_CodeSticker
                               ON ObjectString_CodeSticker.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_CodeSticker.DescId = zc_ObjectString_GoodsPropertyValue_CodeSticker()

        LEFT JOIN ObjectString AS ObjectString_Quality
                               ON ObjectString_Quality.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_Quality.DescId = zc_ObjectString_GoodsPropertyValue_Quality()
        LEFT JOIN ObjectString AS ObjectString_Quality2
                               ON ObjectString_Quality2.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_Quality2.DescId = zc_ObjectString_GoodsPropertyValue_Quality2()
        LEFT JOIN ObjectString AS ObjectString_Quality10
                               ON ObjectString_Quality10.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_Quality10.DescId = zc_ObjectString_GoodsPropertyValue_Quality10()

        LEFT JOIN ObjectString AS ObjectString_NameExternal
                               ON ObjectString_NameExternal.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_NameExternal.DescId = zc_ObjectString_GoodsPropertyValue_NameExternal()
        LEFT JOIN ObjectString AS ObjectString_ArticleExternal
                               ON ObjectString_ArticleExternal.ObjectId = Object_GoodsPropertyValue.Id
                              AND ObjectString_ArticleExternal.DescId = zc_ObjectString_GoodsPropertyValue_ArticleExternal()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Weigth
                                ON ObjectBoolean_Weigth.ObjectId = Object_GoodsPropertyValue.Id
                               AND ObjectBoolean_Weigth.DescId = zc_ObjectBoolean_GoodsPropertyValue_Weigth()

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

        LEFT JOIN ObjectLink AS ObjectLink_GoodsTypeKind_Sh
                             ON ObjectLink_GoodsTypeKind_Sh.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsTypeKind_Sh.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTypeKind_Nom
                             ON ObjectLink_GoodsTypeKind_Nom.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom()
        LEFT JOIN ObjectLink AS ObjectLink_GoodsTypeKind_Ves
                             ON ObjectLink_GoodsTypeKind_Ves.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsTypeKind_Ves.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Ves()

        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
        LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Box
                             ON ObjectLink_GoodsPropertyValue_Box.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsPropertyValue_Box.DescId = zc_ObjectLink_GoodsPropertyValue_Box()
        LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_GoodsPropertyValue_Box.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsKindSub
                             ON ObjectLink_GoodsKindSub.ObjectId = Object_GoodsPropertyValue.Id
                            AND ObjectLink_GoodsKindSub.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKindSub()
        LEFT JOIN Object AS Object_GoodsKindSub ON Object_GoodsKindSub.Id = ObjectLink_GoodsKindSub.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isGoodsKind
                                ON ObjectBoolean_isGoodsKind.ObjectId = Object_GoodsPropertyValue.Id
                               AND ObjectBoolean_isGoodsKind.DescId = zc_ObjectBoolean_GoodsPropertyValue_isGoodsKind()

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
      , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId                   AS GoodsId
                                     , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                                     , ObjectBoolean_Order.ValueData                          AS isOrder
                                     , Object_GoodsBrand.ValueData                            AS GoodsBrandName
                                FROM Object_GoodsByGoodsKind_View
                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Order
                                                             ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                            AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                   
                                     LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsBrand
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsBrand.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsBrand.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsBrand()
                                     LEFT JOIN Object AS Object_GoodsBrand ON Object_GoodsBrand.Id = ObjectLink_GoodsByGoodsKind_GoodsBrand.ChildObjectId
                                  
                                WHERE ObjectBoolean_Order.ValueData = TRUE 
                                   OR COALESCE (ObjectLink_GoodsByGoodsKind_GoodsBrand.ChildObjectId, 0) <> 0
                                )
   ---
   SELECT
         tmpObjectLink.GoodsPropertyValueId         AS Id
       , tmpObjectLink.GoodsPropertyValueCode       AS Code
       , tmpObjectLink.GoodsPropertyValueName       AS Name
       , tmpObjectLink.GoodsPropertyValueNameExternal    AS NameExternal
       , tmpObjectLink.GoodsPropertyValueArticleExternal AS ArticleExternal

       , tmpObjectLink.Amount
       , tmpObjectLink.BoxCount
       , tmpObjectLink.AmountDoc
       , tmpObjectLink.BarCodeShort
       , tmpObjectLink.BarCode
       , tmpObjectLink.Article
       , tmpObjectLink.BarCodeGLN
       , tmpObjectLink.ArticleGLN
       , tmpObjectLink.CodeSticker
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

       , tmpObjectLink.GoodsKindSubId
       , tmpObjectLink.GoodsKindSubCode
       , tmpObjectLink.GoodsKindSubName

       , tmpObjectLink.Quality
       , tmpObjectLink.Quality2
       , tmpObjectLink.Quality10

       , COALESCE (tmpGoodsByGoodsKind.GoodsBrandName, NULL) :: TVarChar AS GoodsBrandName

       , COALESCE (tmpGoodsByGoodsKind.isOrder, FALSE) :: Boolean AS isOrder
       , tmpObjectLink.isWeigth                        :: Boolean AS isWeigth 
       , tmpObjectLink.isGoodsKind                     :: Boolean AS isGoodsKind
       , tmpObjectLink.isErased

       , COALESCE (tmpObjectLink.isGoodsTypeKind_Sh,  FALSE) :: Boolean AS isGoodsTypeKind_Sh
       , COALESCE (tmpObjectLink.isGoodsTypeKind_Nom, FALSE) :: Boolean AS isGoodsTypeKind_Nom
       , COALESCE (tmpObjectLink.isGoodsTypeKind_Ves, FALSE) :: Boolean AS isGoodsTypeKind_Ves

       , tmpObjectLink.BoxId
       , tmpObjectLink.BoxCode
       , tmpObjectLink.BoxName
       , tmpObjectLink.WeightOnBox
       , tmpObjectLink.CountOnBox

    FROM tmpGoods 
        LEFT JOIN (SELECT Object_GoodsPropertyValue.Id          AS GoodsPropertyValueId
                        , Object_GoodsPropertyValue.ObjectCode  AS GoodsPropertyValueCode
                        , Object_GoodsPropertyValue.ValueData   AS GoodsPropertyValueName
                        , ObjectString_NameExternal.ValueData    AS GoodsPropertyValueNameExternal
                        , ObjectString_ArticleExternal.ValueData AS GoodsPropertyValueArticleExternal
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
                        , ObjectString_CodeSticker.ValueData   AS CodeSticker
                        , ObjectString_GroupName.ValueData     AS GroupName

                        , Object_GoodsKind.Id                  AS GoodsKindId
                        , Object_GoodsKind.ValueData           AS GoodsKindName

                        , Object_GoodsBox.Id                   AS GoodsBoxId
                        , Object_GoodsBox.ObjectCode           AS GoodsBoxCode
                        , Object_GoodsBox.ValueData            AS GoodsBoxName

                        , ObjectString_Quality.ValueData       AS Quality
                        , ObjectString_Quality2.ValueData      AS Quality2
                        , ObjectString_Quality10.ValueData     AS Quality10

                        , CASE WHEN COALESCE (ObjectLink_GoodsTypeKind_Sh.ChildObjectId, 0)  <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Sh
                        , CASE WHEN COALESCE (ObjectLink_GoodsTypeKind_Nom.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Nom
                        , CASE WHEN COALESCE (ObjectLink_GoodsTypeKind_Ves.ChildObjectId, 0) <> 0 THEN TRUE ELSE FALSE END AS isGoodsTypeKind_Ves

                        , Object_Box.Id                          AS BoxId
                        , Object_Box.ObjectCode                  AS BoxCode
                        , Object_Box.ValueData                   AS BoxName
                        , ObjectFloat_WeightOnBox.ValueData      AS WeightOnBox
                        , ObjectFloat_CountOnBox.ValueData       AS CountOnBox

                        , Object_GoodsKindSub.Id                 AS GoodsKindSubId
                        , Object_GoodsKindSub.ObjectCode         AS GoodsKindSubCode
                        , Object_GoodsKindSub.ValueData          AS GoodsKindSubName

                        , COALESCE (ObjectBoolean_Weigth.ValueData, FALSE)      :: Boolean AS isWeigth
                        , COALESCE (ObjectBoolean_isGoodsKind.ValueData, FALSE) :: Boolean AS isGoodsKind
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

                      LEFT JOIN ObjectLink AS ObjectLink_GoodsTypeKind_Sh
                                           ON ObjectLink_GoodsTypeKind_Sh.ObjectId = Object_GoodsPropertyValue.Id
                                          AND ObjectLink_GoodsTypeKind_Sh.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Sh()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsTypeKind_Nom
                                           ON ObjectLink_GoodsTypeKind_Nom.ObjectId = Object_GoodsPropertyValue.Id
                                          AND ObjectLink_GoodsTypeKind_Nom.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Nom()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsTypeKind_Ves
                                           ON ObjectLink_GoodsTypeKind_Ves.ObjectId = Object_GoodsPropertyValue.Id
                                          AND ObjectLink_GoodsTypeKind_Ves.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsTypeKind_Ves()

                      LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Box
                                           ON ObjectLink_GoodsPropertyValue_Box.ObjectId = Object_GoodsPropertyValue.Id
                                          AND ObjectLink_GoodsPropertyValue_Box.DescId = zc_ObjectLink_GoodsPropertyValue_Box()
                      LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_GoodsPropertyValue_Box.ChildObjectId

                      LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                            ON ObjectFloat_Amount.ObjectId = Object_GoodsPropertyValue.Id 
                                           AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
                      LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                            ON ObjectFloat_BoxCount.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_GoodsPropertyValue_BoxCount()
                      LEFT JOIN ObjectFloat AS ObjectFloat_AmountDoc
                                            ON ObjectFloat_AmountDoc.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectFloat_AmountDoc.DescId = zc_ObjectFloat_GoodsPropertyValue_AmountDoc()

                      LEFT JOIN ObjectFloat AS ObjectFloat_WeightOnBox
                                            ON ObjectFloat_WeightOnBox.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectFloat_WeightOnBox.DescId = zc_ObjectFloat_GoodsPropertyValue_WeightOnBox()
                      LEFT JOIN ObjectFloat AS ObjectFloat_CountOnBox
                                            ON ObjectFloat_CountOnBox.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectFloat_CountOnBox.DescId = zc_ObjectFloat_GoodsPropertyValue_CountOnBox()

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

                     LEFT JOIN ObjectString AS ObjectString_CodeSticker
                                            ON ObjectString_CodeSticker.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectString_CodeSticker.DescId = zc_ObjectString_GoodsPropertyValue_CodeSticker()

                     LEFT JOIN ObjectString AS ObjectString_Quality
                                            ON ObjectString_Quality.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectString_Quality.DescId = zc_ObjectString_GoodsPropertyValue_Quality()
                     LEFT JOIN ObjectString AS ObjectString_Quality2
                                            ON ObjectString_Quality2.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectString_Quality2.DescId = zc_ObjectString_GoodsPropertyValue_Quality2()
                     LEFT JOIN ObjectString AS ObjectString_Quality10
                                            ON ObjectString_Quality10.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectString_Quality10.DescId = zc_ObjectString_GoodsPropertyValue_Quality10()

                     LEFT JOIN ObjectString AS ObjectString_NameExternal
                                            ON ObjectString_NameExternal.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectString_NameExternal.DescId = zc_ObjectString_GoodsPropertyValue_NameExternal()
                     LEFT JOIN ObjectString AS ObjectString_ArticleExternal
                                            ON ObjectString_ArticleExternal.ObjectId = Object_GoodsPropertyValue.Id
                                           AND ObjectString_ArticleExternal.DescId = zc_ObjectString_GoodsPropertyValue_ArticleExternal()

                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Weigth
                                             ON ObjectBoolean_Weigth.ObjectId = Object_GoodsPropertyValue.Id
                                            AND ObjectBoolean_Weigth.DescId = zc_ObjectBoolean_GoodsPropertyValue_Weigth()

                     LEFT JOIN ObjectLink AS ObjectLink_GoodsKindSub
                                          ON ObjectLink_GoodsKindSub.ObjectId = Object_GoodsPropertyValue.Id
                                         AND ObjectLink_GoodsKindSub.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKindSub()
                     LEFT JOIN Object AS Object_GoodsKindSub ON Object_GoodsKindSub.Id = ObjectLink_GoodsKindSub.ChildObjectId

                     LEFT JOIN ObjectBoolean AS ObjectBoolean_isGoodsKind
                                             ON ObjectBoolean_isGoodsKind.ObjectId = Object_GoodsPropertyValue.Id
                                            AND ObjectBoolean_isGoodsKind.DescId = zc_ObjectBoolean_GoodsPropertyValue_isGoodsKind()

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
 29.07.22         *
 02.11.20         * add ArticleExternal
 01.11.20         * add NameExternal
 09.08.19         * add isWeigth
 10.04.19         * 
 30.03.19         * add Quality
 26.02.19         *
 17.12.18         * add Quality10, Quality2
 25.07.18         * add CodeSticker
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


-- update - zc_ObjectLink_GoodsPropertyValue_GoodsBox
with t1 as (
SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                             , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                             , Object_GoodsPropertyValue.ValueData  AS Name
                                             , ObjectString_BarCode.ValueData       AS BarCode
                                             , ObjectString_BarCodeGLN.ValueData    AS BarCodeGLN
                                             , ObjectString_Article.ValueData       AS Article
                                             , COALESCE (ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId, 0)  AS GoodsBoxId
                                             , COALESCE (ObjectFloat_Weight.ValueData, 0)                          AS GoodsBox_Weight
, Object_1.ValueData AS A11
, Object_2.ValueData AS A22

FROM ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty

                                             LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                             LEFT JOIN ObjectString AS ObjectString_BarCodeGLN
                                                                    ON ObjectString_BarCodeGLN.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_BarCodeGLN.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeGLN()
                                             LEFT JOIN ObjectString AS ObjectString_Article
                                                                    ON ObjectString_Article.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   AND ObjectString_Article.DescId = zc_ObjectString_GoodsPropertyValue_Article()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                  ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()


                                             LEFT JOIN Object AS Object_GoodsPropertyValue on Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId

LEFT JOIN Object AS Object_1 on Object_1.Id = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId 
LEFT JOIN Object AS Object_2 on Object_2.Id = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId
                                            

                                             LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = Object_GoodsPropertyValue.Id
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
                                             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                   ON ObjectFloat_Weight.ObjectId = ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
                                                                  AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

where ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
-- and Object_2.ValueData ilike '%нар%'
--   and ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId > 0 
   and ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId is null

)
, t2 as (select Object_GoodsByGoodsKind_View.* from Object_GoodsByGoodsKind_View
            JOIN ObjectBoolean AS ObjectBoolean_Order
                                    ON ObjectBoolean_Order.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
AND ObjectBoolean_Order.valueData = true)

select t1.* 
 ,    lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsBox(), t1.ObjectId, CASE WHEN A22 ilike '%нар%' THEN 1918750 ELSE 6186668 end)

from t1 
left join t2 on t2.GoodsId = t1.GoodsId
            and t2.GoodsKindId = t1.GoodsKindId
-- and 1=0
where t2.GoodsId > 0
order by 1

-- select *  from object where ObjectCode = 978005 and DescId = zc_Object_Goods()
-- select *  from object where ObjectCode = 97958380 and DescId = zc_Object_Goods()
-- select *  from object where valueData ilike '%Гофротара 380х220х110%' and DescId = zc_Object_Goods()
*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsPropertyValue (351299 , TRUE, '2')
