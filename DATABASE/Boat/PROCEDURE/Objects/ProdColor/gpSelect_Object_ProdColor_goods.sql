-- Function: gpSelect_Object_ProdColor_goods()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColor_goods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColor_goods(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет
    IN inSession     TVarChar            -- сессия пользователя

)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , GoodsId Integer, GoodsCode Integer, Article TVarChar, GoodsName TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPriceWithVAT Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_ProdColor());
   vbUserId:= lpGetUserBySession (inSession);


   -- Результат
   RETURN QUERY
       WITH tmpPriceBasis AS (SELECT tmp.GoodsId
                                   , tmp.ValuePrice
                              FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                       , inOperDate   := CURRENT_DATE) AS tmp
                             )
       -- Результат
       SELECT
             Object_ProdColor.Id             AS Id
           , Object_ProdColor.ObjectCode     AS Code
           , Object_ProdColor.ValueData      AS Name

           , Object_Goods.Id                 AS Id
           , Object_Goods.ObjectCode         AS Code
           , ObjectString_Article.ValueData  AS Article
           , Object_Goods.ValueData          AS Name

           , Object_GoodsGroup.Id            AS GoodsGroupId
           , Object_GoodsGroup.ValueData     AS GoodsGroupName
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull

             -- Цена вх. без НДС
           , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
             -- Цена вх. с НДС
           , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT

              -- Цена продажи без НДС
           , CASE WHEN vbPriceWithVAT = FALSE
                  THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                  ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
             END ::TFloat  AS BasisPrice

              -- Цена продажи с НДС
           , CASE WHEN vbPriceWithVAT = FALSE
                  THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                  ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
             END ::TFloat  AS BasisPriceWVAT

           , ObjectString_Comment.ValueData  AS Comment

           , Object_Insert.ValueData         AS InsertName
           , ObjectDate_Insert.ValueData     AS InsertDate
           , Object_ProdColor.isErased       AS isErased

       FROM Object AS Object_ProdColor
            INNER JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                  ON ObjectLink_Goods_ProdColor.ChildObjectId = Object_ProdColor.Id
                                 AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
            INNER JOIN Object AS Object_Goods ON Object_Goods.Id       = ObjectLink_Goods_ProdColor.ObjectId
                                             AND Object_Goods.isErased = FALSE

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            INNER JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                  -- !!!временно!!!
                                                  AND (Object_GoodsGroup.ValueData ILIKE '%hypalon%'
                                                    OR Object_GoodsGroup.ValueData ILIKE 'Fabric%'
                                                      )

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                 ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                 AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_Goods.Id
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                  ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_ProdColor.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_ProdColor_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Object_ProdColor.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Insert
                                 ON ObjectDate_Insert.ObjectId = Object_ProdColor.Id
                                AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
       WHERE Object_ProdColor.DescId = zc_Object_ProdColor()
         AND (Object_ProdColor.isErased = FALSE OR inIsShowAll = TRUE)
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
22.01.21                                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdColor_goods (inIsShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
