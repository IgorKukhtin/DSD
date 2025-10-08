-- Function: gpSelect_Object_ProdColor_goods()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColor_goods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColor_goods(
    IN inIsShowAll   Boolean,            -- признак показать удаленные да / нет
    IN inSession     TVarChar            -- сессия пользователя

)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Color_Value Integer
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
       WITH tmpProdColor_goods AS (SELECT Object_ProdColor.*
                                        , Object_Goods.Id                 AS GoodsId
                                        , Object_Goods.ObjectCode         AS GoodsCode
                                        , Object_Goods.ValueData          AS GoodsName
                                        , Object_GoodsGroup.Id            AS GoodsGroupId
                                        , Object_GoodsGroup.ValueData     AS GoodsGroupName

                                   FROM Object AS Object_ProdColor
                                        INNER JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                              ON ObjectLink_Goods_ProdColor.ChildObjectId = Object_ProdColor.Id
                                                             AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                                        INNER JOIN Object AS Object_Goods ON Object_Goods.Id       = ObjectLink_Goods_ProdColor.ObjectId
                                                                         AND Object_Goods.isErased = FALSE
                                                                         AND Object_Goods.ValueData NOT ILIKE 'AGL%'
                                                                         AND Object_Goods.ValueData NOT ILIKE '%AGL-%'
                                                                         AND Object_Goods.ValueData NOT ILIKE '%АGL-%'
                            
                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                        INNER JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                                              -- !!!временно!!!
                                                                              AND (Object_GoodsGroup.ValueData ILIKE '%hypalon%'
                                                                                OR Object_GoodsGroup.ValueData ILIKE 'Fabric%'
                                                                                OR Object_Goods.ObjectCode < 0
                                                                                --
                                                                                OR Object_ProdColor.ValueData ILIKE 'RAL%'
                                                                                --
                                                                                OR Object_ProdColor.ValueData ILIKE 'wei%'
                                                                                OR Object_ProdColor.ValueData ILIKE 'grau'
                                                                                OR Object_ProdColor.ValueData ILIKE 'Schwarz'
                                                                                  )
                                  )

           , tmpPriceBasis AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                                    , ObjectHistory_PriceListItem.StartDate            AS StartDate
                                    , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                                    , ObjectLink_PriceListItem_PriceList.ChildObjectId AS PriceListId
                               FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                                    INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                          ON ObjectLink_PriceListItem_PriceList.ObjectId     = ObjectLink_PriceListItem_Goods.ObjectId
                                                         AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                                         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                    LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                            ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                           AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                           AND CURRENT_DATE >= ObjectHistory_PriceListItem.StartDate AND CURRENT_DATE < ObjectHistory_PriceListItem.EndDate
                                    INNER JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                  ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                 AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                                                 AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
                               WHERE ObjectLink_PriceListItem_Goods.ChildObjectId IN (SELECT DISTINCT tmpProdColor_goods.GoodsId FROM tmpProdColor_goods)
                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                              )
       -- Результат
       SELECT
             Object_ProdColor.Id             AS Id
           , Object_ProdColor.ObjectCode     AS Code
           , Object_ProdColor.ValueData      AS Name
           , COALESCE(ObjectFloat_Value.ValueData, zc_Color_White())::Integer  AS Color_Value

           , Object_ProdColor.GoodsId        AS GoodsId
           , Object_ProdColor.GoodsCode      AS GoodsCode
           , ObjectString_Article.ValueData  AS Article
           , Object_ProdColor.GoodsName      AS GoodsName

           , Object_ProdColor.GoodsGroupId   AS GoodsGroupId
           , Object_ProdColor.GoodsGroupName AS GoodsGroupName
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

       FROM tmpProdColor_goods AS Object_ProdColor
            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                  ON ObjectFloat_Value.ObjectId = Object_ProdColor.Id
                                 AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ProdColor_Value()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                 ON ObjectLink_Goods_TaxKind.ObjectId = Object_ProdColor.GoodsId
                                AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                 AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = Object_ProdColor.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = Object_ProdColor.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                  ON ObjectFloat_EKPrice.ObjectId = Object_ProdColor.GoodsId
                                 AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_ProdColor.GoodsId

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
-- SELECT * FROM gpSelect_Object_ProdColor_goods (inIsShowAll:= FALSE, inSession:= zfCalc_UserAdmin())
