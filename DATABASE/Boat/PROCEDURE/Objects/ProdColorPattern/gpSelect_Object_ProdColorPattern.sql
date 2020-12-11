-- Function: gpSelect_Object_ProdColorPattern()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorPattern (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorPattern (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorPattern(
    IN inColorPatternId   Integer,
    IN inIsErased         Boolean,       -- признак показать удаленные да / нет
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NPP Integer
             , Comment TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , EKPrice TFloat, EKPriceWVAT TFloat
             , EmpfPrice TFloat, EmpfPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorPattern());
     vbUserId:= lpGetUserBySession (inSession);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     RETURN QUERY
     WITH tmpPriceBasis AS (SELECT tmp.GoodsId
                                 , tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS tmp
                           )
     --
     SELECT
           Object_ProdColorPattern.Id         AS Id
         , Object_ProdColorPattern.ObjectCode AS Code
         , Object_ProdColorPattern.ValueData  AS Name
         , ROW_NUMBER() OVER (PARTITION BY Object_ProdColorGroup.Id ORDER BY Object_ProdColorPattern.ObjectCode ASC) :: Integer AS NPP

         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
         , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName

         , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

         , Object_Goods.Id                    ::Integer  AS GoodsId
         , Object_Goods.ObjectCode            ::Integer  AS GoodsCode
         , Object_Goods.ValueData             ::TVarChar AS GoodsName

         , Object_Insert.ValueData            AS InsertName
         , ObjectDate_Insert.ValueData        AS InsertDate
         , Object_ProdColorPattern.isErased   AS isErased

         , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Article.ValueData             AS Article
         , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL THEN ObjectString_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
         , Object_Measure.ValueData                   AS MeasureName

         , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
         , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
              * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT-- расчет входной цены с НДС, до 4 знаков

         , ObjectFloat_EmpfPrice.ValueData ::TFloat   AS EmpfPrice
         , CAST (COALESCE (ObjectFloat_EmpfPrice.ValueData, 0)
              * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100) ) AS NUMERIC (16, 2)) ::TFloat AS EmpfPriceWVAT-- расчет рекомендованной цены с НДС, до 4 знаков

          -- расчет базовой цены без НДС, до 2 знаков
        , CASE WHEN vbPriceWithVAT = FALSE
               THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
               ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
          END ::TFloat  AS BasisPrice   -- сохраненная цена - цена без НДС

          -- расчет базовой цены с НДС, до 2 знаков
        , CASE WHEN vbPriceWithVAT = FALSE
               THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
               ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
          END ::TFloat  AS BasisPriceWVAT

     FROM Object AS Object_ProdColorPattern
          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          --
          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Goods.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                               AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
          LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                               AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                               ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                               AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

          LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

     WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
      AND (Object_ProdColorPattern.isErased = FALSE OR inIsErased = TRUE)
      AND (ObjectLink_ColorPattern.ChildObjectId = inColorPatternId OR inColorPatternId = 0)
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.20         * zc_ObjectLink_ProdColorPattern_Goods
 15.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdColorPattern (false, zfCalc_UserAdmin())
