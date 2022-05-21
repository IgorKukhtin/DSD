-- Function: gpSelect_Object_ReceiptGoods_Print ()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoods_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoods_Print(
    IN inReceiptGoodsId               Integer   ,   --    
    IN inSession                      TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbPriceWithVAT_pl    Boolean;
    DECLARE vbTaxKindValue_basis TFloat;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Признак в Базовом Прайсе
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!Базовый % НДС!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());


     -- Результат
     OPEN Cursor1 FOR

     SELECT
           Object_ReceiptGoods.Id         AS Id
         , Object_ReceiptGoods.ObjectCode AS Code
         , Object_ReceiptGoods.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Goods.Id         ::Integer  AS GoodsId
         , Object_Goods.ObjectCode ::Integer  AS GoodsCode
         , Object_Goods.ValueData  ::TVarChar AS GoodsName

         , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

            --
         , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
         , Object_ProdColor.ValueData            :: TVarChar AS ProdColorName

         , ObjectString_GoodsGroupFull.ValueData ::TVarChar AS ModelName
         , Object_ProdColor.ValueData            ::TVarChar AS BrandName
         , ''    ::TVarChar AS EngineName


         , '' ::TVarChar AS ModelGroupName
         , 0  ::TFloat   AS EnginePower
         , 0  ::TFloat   AS EngineVolume

         , tmpInfo.Footer1        ::TVarChar AS Footer1
         , tmpInfo.Footer2        ::TVarChar AS Footer2
         , tmpInfo.Footer3        ::TVarChar AS Footer3
         , tmpInfo.Footer4        ::TVarChar AS Footer4
         
     FROM Object AS Object_ReceiptGoods
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptGoods_Code()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptGoods_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ReceiptGoods_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1

     WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
       AND Object_ReceiptGoods.Id = inReceiptGoodsId

          ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR  
     SELECT (ROW_NUMBER() OVER (ORDER BY Object_ReceiptGoodsChild.Id ASC)
           + CASE WHEN ObjectLink_ProdColorPattern.ChildObjectId IS NULL THEN 1000 ELSE 0 END)  :: Integer AS NPP

         , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END ::TFloat   AS Value
         , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END ::TFloat   AS Value_service

         --, Object_ReceiptGoods.Id        ::Integer  AS ReceiptGoodsId
         --, Object_ReceiptGoods.ValueData ::TVarChar AS ReceiptGoodsName
         
         , Object_Object.ObjectCode       ::Integer  AS ObjectCode
         , Object_Object.ValueData        ::TVarChar AS ObjectName
         --, ObjectDesc.ItemName            ::TVarChar AS DescName
         , ObjectString_EAN.ValueData                AS EAN

         , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
         , ObjectString_Article.ValueData        ::TVarChar  AS Article
         , Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
         , Object_Measure.ValueData              ::TVarChar  AS MeasureName

     FROM Object AS Object_ReceiptGoodsChild

          INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                               AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                               ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

          LEFT JOIN ObjectLink AS ObjectLink_Object
                               ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = COALESCE (ObjectLink_Object.ChildObjectId, ObjectLink_ProdColorPattern.ChildObjectId)
                          AND Object_Object.DescId = zc_Object_Goods()
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value() 

          --
          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Object.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Object.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_EAN
                                 ON ObjectString_EAN.ObjectId = Object_Object.Id
                                AND ObjectString_EAN.DescId = zc_ObjectString_EAN()

     WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
       AND Object_ReceiptGoodsChild.isErased = FALSE
       AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId
      -- без этой структуры
      --AND ObjectLink_ProdColorPattern.ChildObjectId IS NULL
  
                               
     ;

     RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.22          *
*/

-- тест
--