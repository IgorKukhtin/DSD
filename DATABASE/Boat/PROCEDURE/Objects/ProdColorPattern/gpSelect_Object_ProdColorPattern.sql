-- Function: gpSelect_Object_ProdColorPattern()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorPattern (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorPattern (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorPattern (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorPattern(
    IN inColorPatternId   Integer,
    IN inIsErased         Boolean,       -- признак показать удаленные да / нет
    IN inIsShowAll        Boolean,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_all TVarChar
             , NPP Integer
             , Comment TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , ModelId Integer, ModelCode Integer, ModelName TVarChar, ModelName_full TVarChar
             , BrandId Integer, BrandName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             , SalePrice TFloat, SalePriceWVAT TFloat
             , isEnabled Boolean
             , isPhoto Boolean
              )
AS
$BODY$
   DECLARE vbUserId       Integer;
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
        , tmpData AS (SELECT
                            Object_ProdColorPattern.Id         AS Id
                          , Object_ProdColorPattern.ObjectCode AS Code
                          , Object_ProdColorPattern.ValueData  AS Name

                          , ObjectString_Comment.ValueData     ::TVarChar AS Comment

                          , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
                          , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName

                          , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
                          , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

                          , Object_Model.Id         ::Integer  AS ModelId
                          , Object_Model.ObjectCode ::Integer  AS ModelCode
                          , Object_Model.ValueData  ::TVarChar AS ModelName
                          , Object_Brand.Id                    AS BrandId
                          , Object_Brand.ValueData             AS BrandName

                          , Object_Goods.Id                    ::Integer  AS GoodsId
                          , Object_Goods.ObjectCode            ::Integer  AS GoodsCode
                          , Object_Goods.ValueData             ::TVarChar AS GoodsName

                          , Object_ProdOptions.Id              ::Integer  AS ProdOptionsId
                          , Object_ProdOptions.ValueData       ::TVarChar AS ProdOptionsName

                          , Object_Insert.ValueData            AS InsertName
                          , ObjectDate_Insert.ValueData        AS InsertDate
                          , Object_ProdColorPattern.isErased   AS isErased

                          , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
                          , Object_GoodsGroup.ValueData                AS GoodsGroupName
                          , ObjectString_Article.ValueData             AS Article
                          , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL THEN ObjectString_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
                          , Object_Measure.ValueData                   AS MeasureName

                            -- Цена вх. без НДС
                          , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
                           -- Цена вх. с НДС
                         , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                               * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT-- расчет входной цены с НДС, до 4 знаков

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

                           -- опция - Цена продажи без НДС
                         , ObjectFloat_SalePrice.ValueData AS SalePrice
                           -- опция - Цена продажи с НДС
                         , CAST (COALESCE (ObjectFloat_SalePrice.ValueData, 0)
                              * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS SalePriceWVAT

                      FROM Object AS Object_ProdColorPattern
                           -- Шаблон Boat Structure
                           LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
                           LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

                           -- Категория/Группа Boat Structure
                           LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                           LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

                           LEFT JOIN ObjectString AS ObjectString_Comment
                                                  ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                                 AND ObjectString_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()

                           -- Опция
                           LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                                                ON ObjectLink_ProdOptions.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_ProdOptions.DescId   = zc_ObjectLink_ProdColorPattern_ProdOptions()
                                               -- НЕ понадобится
                                               AND 1=0
                           LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_TaxKind
                                                ON ObjectLink_ProdOptions_TaxKind.ObjectId = Object_ProdOptions.Id
                                               AND ObjectLink_ProdOptions_TaxKind.DescId   = zc_ObjectLink_ProdOptions_TaxKind()
                           LEFT JOIN Object AS Object_TaxKind_opt ON Object_TaxKind_opt.Id = ObjectLink_ProdOptions_TaxKind.ChildObjectId

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_opt
                                                 ON ObjectFloat_TaxKind_Value_opt.ObjectId = Object_TaxKind_opt.Id
                                                AND ObjectFloat_TaxKind_Value_opt.DescId   = zc_ObjectFloat_TaxKind_Value()
                           -- Цена продажи Опции
                           LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                                 ON ObjectFloat_SalePrice.ObjectId = Object_ProdOptions.Id
                                                AND ObjectFloat_SalePrice.DescId   = zc_ObjectFloat_ProdOptions_SalePrice()

                           -- Комплектующие
                           LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()
                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId
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

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                           LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

                           -- Модель из Шаблон Boat Structure
                           LEFT JOIN ObjectLink AS ObjectLink_Model
                                                ON ObjectLink_Model.ObjectId = Object_ColorPattern.Id
                                               AND ObjectLink_Model.DescId = zc_ObjectLink_ColorPattern_Model()
                           LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
                           LEFT JOIN ObjectLink AS ObjectLink_Brand
                                                ON ObjectLink_Brand.ObjectId = Object_Model.Id
                                               AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
                           LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

                           --
                           LEFT JOIN ObjectLink AS ObjectLink_Insert
                                                ON ObjectLink_Insert.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

                           LEFT JOIN ObjectDate AS ObjectDate_Insert
                                                ON ObjectDate_Insert.ObjectId = Object_ProdColorPattern.Id
                                               AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

                      WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
                       AND (Object_ProdColorPattern.isErased = FALSE OR inIsErased = TRUE)
                     )
                     
          , tmpGoodsPhoto AS (SELECT ObjectLink_GoodsPhoto_Goods.ChildObjectId AS ObjectId
                                   , Object_GoodsPhoto.Id                      AS PhotoId
                                   , ROW_NUMBER() OVER (PARTITION BY ObjectLink_GoodsPhoto_Goods.ChildObjectId ORDER BY Object_GoodsPhoto.Id) AS Ord
                              FROM Object AS Object_GoodsPhoto
                                     JOIN ObjectLink AS ObjectLink_GoodsPhoto_Goods
                                                     ON ObjectLink_GoodsPhoto_Goods.ObjectId = Object_GoodsPhoto.Id
                                                    AND ObjectLink_GoodsPhoto_Goods.DescId   = zc_ObjectLink_GoodsPhoto_Goods()
                               WHERE Object_GoodsPhoto.DescId   = zc_Object_GoodsPhoto()
                                 AND Object_GoodsPhoto.isErased = FALSE
                             )
          , tmpProdColorPatternPhoto AS (SELECT ObjectLink_ProdColorPatternPhoto_ProdColorPattern.ChildObjectId AS ObjectId
                                   , Object_ProdColorPatternPhoto.Id                      AS PhotoId
                                   , ROW_NUMBER() OVER (PARTITION BY ObjectLink_ProdColorPatternPhoto_ProdColorPattern.ChildObjectId ORDER BY Object_ProdColorPatternPhoto.Id) AS Ord
                              FROM Object AS Object_ProdColorPatternPhoto
                                     JOIN ObjectLink AS ObjectLink_ProdColorPatternPhoto_ProdColorPattern
                                                     ON ObjectLink_ProdColorPatternPhoto_ProdColorPattern.ObjectId = Object_ProdColorPatternPhoto.Id
                                                    AND ObjectLink_ProdColorPatternPhoto_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorPatternPhoto_ProdColorPattern()
                               WHERE Object_ProdColorPatternPhoto.DescId   = zc_Object_ProdColorPatternPhoto()
                                 AND Object_ProdColorPatternPhoto.isErased = FALSE
                             )
     --
     SELECT
           tmpData.Id
         , tmpData.Code
         , tmpData.Name
         , (tmpData.ProdColorGroupName || ' ' || tmpData.Name) :: TVarChar AS Name_all
         , ROW_NUMBER() OVER (PARTITION BY tmpData.ColorPatternId ORDER BY tmpData.Code ASC) :: Integer AS NPP

         , tmpData.Comment

         , tmpData.ProdColorGroupId
         , tmpData.ProdColorGroupName

         , tmpData.ColorPatternId
         , tmpData.ColorPatternName

         , tmpData.ModelId
         , tmpData.ModelCode
         , tmpData.ModelName
         , (tmpData.ModelName ||' (' || tmpData.BrandName||')') ::TVarChar AS ModelName_full
         , tmpData.BrandId
         , tmpData.BrandName

         , tmpData.GoodsId
         , tmpData.GoodsCode
         , tmpData.GoodsName

         , tmpData.ProdOptionsId
         , tmpData.ProdOptionsName

         , tmpData.InsertName
         , tmpData.InsertDate
         , tmpData.isErased

         , tmpData.GoodsGroupNameFull
         , tmpData.GoodsGroupName
         , tmpData.Article
         , tmpData.ProdColorName
         , tmpData.MeasureName

           -- Цена вх. без НДС
         , tmpData.EKPrice
         , tmpData.EKPriceWVAT

          -- Цена продажи без НДС
        , tmpData.BasisPrice
        , tmpData.BasisPriceWVAT

          -- Цена Options без НДС
        , tmpData.SalePrice     ::TFloat
        , tmpData.SalePriceWVAT ::TFloat

        , TRUE :: Boolean AS isEnabled
        , CASE WHEN tmpPhoto1.ObjectId > 0 OR tmpPhoto2.ObjectId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPhoto

     FROM tmpData
             LEFT JOIN tmpProdColorPatternPhoto AS tmpPhoto1
                                                ON tmpPhoto1.ObjectId = tmpData.Id
                                               AND tmpPhoto1.Ord = 1
             LEFT JOIN tmpGoodsPhoto AS tmpPhoto2
                                     ON tmpPhoto2.ObjectId = tmpData.GoodsId
                                    AND tmpPhoto2.Ord = 1
     WHERE tmpData.ColorPatternId = inColorPatternId
        OR inColorPatternId       = 0

    UNION ALL
     SELECT
           tmpData.Id
         , tmpData.Code
         , tmpData.Name
         , (tmpData.ProdColorGroupName || ' ' || tmpData.Name) :: TVarChar AS Name_all
         , ROW_NUMBER() OVER (PARTITION BY Object_ColorPattern.Id ORDER BY tmpData.Code ASC) :: Integer AS NPP

         , tmpData.Comment

         , tmpData.ProdColorGroupId
         , tmpData.ProdColorGroupName

         , Object_ColorPattern.Id        AS ColorPatternId
         , Object_ColorPattern.ValueData AS ColorPatternName

         , Object_Model.Id         ::Integer  AS ModelId
         , Object_Model.ObjectCode ::Integer  AS ModelCode
         , Object_Model.ValueData  ::TVarChar AS ModelName
         , (Object_Model.ValueData ||' (' || Object_Brand.ValueData||')') ::TVarChar AS ModelName_full
         , Object_Brand.Id                    AS BrandId
         , Object_Brand.ValueData             AS BrandName

         , tmpData.GoodsId
         , tmpData.GoodsCode
         , tmpData.GoodsName

         , tmpData.ProdOptionsId
         , tmpData.ProdOptionsName

         , tmpData.InsertName
         , tmpData.InsertDate
         , tmpData.isErased

         , tmpData.GoodsGroupNameFull
         , tmpData.GoodsGroupName
         , tmpData.Article
         , tmpData.ProdColorName
         , tmpData.MeasureName

           -- Цена вх. без НДС
         , tmpData.EKPrice
         , tmpData.EKPriceWVAT

          -- Цена продажи без НДС
        , tmpData.BasisPrice
        , tmpData.BasisPriceWVAT

          -- Цена Options без НДС
        , tmpData.SalePrice     ::TFloat
        , tmpData.SalePriceWVAT ::TFloat

        , FALSE :: Boolean AS isEnabled
        , CASE WHEN tmpPhoto1.ObjectId > 0 OR tmpPhoto2.ObjectId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPhoto

     FROM Object AS Object_ColorPattern
          INNER JOIN (SELECT 0                  :: Integer AS Id
                           , MAX (tmpData.Code) :: Integer AS Code
                           , tmpData.Name

                           , tmpData.Comment

                           , tmpData.ProdColorGroupId
                           , tmpData.ProdColorGroupName

                           , tmpData.GoodsId
                           , tmpData.GoodsCode
                           , tmpData.GoodsName

                           , 0     :: Integer   AS ProdOptionsId
                           , ''    :: TVarChar  AS ProdOptionsName

                           , NULL  :: TVarChar  AS InsertName
                           , NULL  :: TDateTime AS InsertDate
                           , FALSE :: Boolean   AS isErased

                           , tmpData.GoodsGroupNameFull
                           , tmpData.GoodsGroupName
                           , tmpData.Article
                           , tmpData.ProdColorName
                           , tmpData.MeasureName

                             -- Цена вх. без НДС
                           , tmpData.EKPrice
                           , tmpData.EKPriceWVAT

                            -- Цена продажи без НДС
                          , tmpData.BasisPrice
                          , tmpData.BasisPriceWVAT

                            -- Цена Options без НДС
                          , 0         :: TFloat AS SalePrice
                          , 0         :: TFloat AS SalePriceWVAT

                      FROM tmpData
                      WHERE tmpData.isErased = FALSE
                      GROUP BY tmpData.Name

                             , tmpData.Comment

                             , tmpData.ProdColorGroupId
                             , tmpData.ProdColorGroupName

                             , tmpData.GoodsId
                             , tmpData.GoodsCode
                             , tmpData.GoodsName

                             , tmpData.GoodsGroupNameFull
                             , tmpData.GoodsGroupName
                             , tmpData.Article
                             , tmpData.ProdColorName
                             , tmpData.MeasureName

                             , tmpData.EKPrice
                             , tmpData.EKPriceWVAT

                            , tmpData.BasisPrice
                            , tmpData.BasisPriceWVAT
                     ) AS tmpData ON 1=1

          LEFT JOIN tmpData AS tmpData_check ON tmpData_check.ColorPatternId   = Object_ColorPattern.Id
                                            AND tmpData_check.ProdColorGroupId = tmpData.ProdColorGroupId
                                            AND tmpData_check.Code             = tmpData.Code

          ---
          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_ColorPattern.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_ColorPattern_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN tmpProdColorPatternPhoto AS tmpPhoto1
                                             ON tmpPhoto1.ObjectId = tmpData.Id
                                            AND tmpPhoto1.Ord = 1
          LEFT JOIN tmpGoodsPhoto AS tmpPhoto2
                                  ON tmpPhoto2.ObjectId = tmpData.GoodsId
                                 AND tmpPhoto2.Ord = 1

     WHERE Object_ColorPattern.DescId   = zc_Object_ColorPattern()
       AND Object_ColorPattern.isErased = FALSE
       AND (Object_ColorPattern.Id       = inColorPatternId
         OR inColorPatternId       = 0)
       AND tmpData_check.ColorPatternId IS NULL
       AND inIsShowAll                  = TRUE
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.12.20         *
 01.12.20         * zc_ObjectLink_ProdColorPattern_Goods
 15.10.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= 0, inIsErased:= FALSE, inIsShowAll := FALSE, inSession:= zfCalc_UserAdmin())
