-- Function: gpSelect_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoods(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , isMain Boolean
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_all TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , MaterialOptionsName TVarChar, ProdColorName_pcp TVarChar
             , UnitId Integer, UnitName TVarChar

             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , Comment_goods TVarChar
             

               -- Сумма вх. без НДС, до 2-х знаков - Товар
             , EKPrice_summ_goods     TFloat
               -- Сумма вх. с НДС, до 2-х знаков - Товар
             , EKPriceWVAT_summ_goods TFloat
               -- Сумма вх. без НДС, до 2-х знаков - Boat Structure
             , EKPrice_summ_colPat     TFloat
               -- Сумма вх. без НДС, до 2-х знаков - Boat Structure
             , EKPriceWVAT_summ_colPat TFloat
               -- Итого Сумма вх. с НДС, до 2-х знаков
             , EKPrice_summ     TFloat
               -- Итого Сумма вх. с НДС, до 2-х знаков
             , EKPriceWVAT_summ TFloat
               -- Цена продажи без НДС
             , BasisPrice TFloat
               -- Цена продажи с НДС, до 2-х знаков
             , BasisPriceWVAT TFloat
              )
AS
$BODY$
   DECLARE vbUserId             Integer;
   DECLARE vbPriceWithVAT_pl    Boolean;
   DECLARE vbTaxKindValue_basis TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoods());
     vbUserId:= lpGetUserBySession (inSession);


     -- Признак в Базовом Прайсе
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!Базовый % НДС!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());

     -- Результат
     RETURN QUERY
     WITH -- Цены в Базовом Прайсе
          tmpPriceBasis AS (SELECT lfSelect.GoodsId
                                   -- Цена продажи без НДС
                                 , CASE WHEN vbPriceWithVAT_pl = FALSE
                                        THEN COALESCE (lfSelect.ValuePrice, 0)
                                        -- расчет
                                        ELSE zfCalc_Summ_NoVAT (lfSelect.ValuePrice, vbTaxKindValue_basis)
                                   END ::TFloat  AS ValuePrice
                                   -- Цена продажи с НДС
                                 , CASE WHEN vbPriceWithVAT_pl = TRUE
                                        THEN COALESCE (lfSelect.ValuePrice, 0)
                                        -- расчет
                                        ELSE zfCalc_SummWVAT (lfSelect.ValuePrice, vbTaxKindValue_basis)
                                   END ::TFloat  AS ValuePriceWVAT
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS lfSelect
                           )
          -- Элементы сборки Узлов - Boat Structure
        , tmpReceiptGoodsChild_ProdColorPattern AS (SELECT gpSelect.ReceiptGoodsId
                                                         , gpSelect.GoodsId
                                                         , gpSelect.ProdColorPatternName_all
                                                         , gpSelect.ProdColorName
                                                         , gpSelect.MaterialOptionsName
                                                           -- Сумма вх. с НДС, до 2-х знаков
                                                         , gpSelect.EKPrice_summ
                                                           -- Сумма вх. с НДС, до 2-х знаков
                                                         , gpSelect.EKPriceWVAT_summ

                                                    FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPattern (inIsShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
                                                    ORDER BY gpSelect.ReceiptGoodsId, gpSelect.NPP
                                                   )
          -- ВСЕ Элементы сборки Узлов
        , tmpReceiptGoodsChild_all AS (-- Элементы сборки Узлов - Товар
                                       SELECT gpSelect.ReceiptGoodsId
                                              -- Сумма вх. без НДС, до 2-х знаков
                                            , SUM (gpSelect.EKPrice_summ)     AS EKPrice_summ_goods
                                              -- Сумма вх. с НДС, до 2-х знаков
                                            , SUM (gpSelect.EKPriceWVAT_summ) AS EKPriceWVAT_summ_goods
                                              -- Boat Structure
                                            , 0 AS EKPrice_summ_colPat
                                            , 0 AS EKPriceWVAT_summ_colPat

                                       FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPatternNo (inIsShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
                                       GROUP BY gpSelect.ReceiptGoodsId

                                      UNION ALL
                                       -- Элементы сборки Узлов - Boat Structure
                                       SELECT gpSelect.ReceiptGoodsId
                                              -- Товар
                                            , 0 AS EKPrice_summ_goods
                                            , 0 AS EKPriceWVAT_summ_goods
                                              -- Сумма вх. с НДС, до 2-х знаков
                                            , SUM (gpSelect.EKPrice_summ)     AS EKPrice_summ_colPat
                                              -- Сумма вх. с НДС, до 2-х знаков
                                            , SUM (gpSelect.EKPriceWVAT_summ) AS EKPriceWVAT_summ_colPat

                                       FROM tmpReceiptGoodsChild_ProdColorPattern AS gpSelect
                                       GROUP BY gpSelect.ReceiptGoodsId
                                   )
          -- собрали в 1 строку
        , tmpReceiptGoodsChild AS (SELECT tmpReceiptGoodsChild_all.ReceiptGoodsId
                                          -- Сумма вх. без НДС, до 2-х знаков
                                        , SUM (tmpReceiptGoodsChild_all.EKPrice_summ_goods)       :: TFloat AS EKPrice_summ_goods
                                          -- Сумма вх. с НДС, до 2-х знаков
                                        , SUM (tmpReceiptGoodsChild_all.EKPriceWVAT_summ_goods)   :: TFloat AS EKPriceWVAT_summ_goods
                                          -- Сумма вх. без НДС, до 2-х знаков
                                        , SUM (tmpReceiptGoodsChild_all.EKPrice_summ_colPat)      :: TFloat AS EKPrice_summ_colPat
                                          -- Сумма вх. с НДС, до 2-х знаков
                                        , SUM (tmpReceiptGoodsChild_all.EKPriceWVAT_summ_colPat)  :: TFloat AS EKPriceWVAT_summ_colPat

                                   FROM tmpReceiptGoodsChild_all
                                   GROUP BY tmpReceiptGoodsChild_all.ReceiptGoodsId
                                  )
          -- продублировали GoodsChild
        , tmpReceiptGoods AS (SELECT Object_ReceiptGoods.Id, Object_ReceiptGoods.DescId, Object_ReceiptGoods.ObjectCode, Object_ReceiptGoods.ValueData, Object_ReceiptGoods.isErased
                                   , ObjectLink_Goods.ChildObjectId AS GoodsId
                              FROM Object AS Object_ReceiptGoods
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                        ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                                                       AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
                              WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
                               AND (Object_ReceiptGoods.isErased = FALSE OR inIsErased = TRUE)
                             UNION ALL
                              SELECT DISTINCT
                                     Object_ReceiptGoods.Id, Object_ReceiptGoods.DescId, Object_ReceiptGoods.ObjectCode, Object_ReceiptGoods.ValueData, Object_ReceiptGoods.isErased
                                   , ObjectLink_GoodsChild.ChildObjectId AS GoodsId
                              FROM Object AS Object_ReceiptGoods
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                        ON ObjectLink_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                       AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                   INNER JOIN Object AS Object_ReceiptGoodsChild
                                                     ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoods.ObjectId
                                                    AND Object_ReceiptGoodsChild.isErased = FALSE
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsChild
                                                         ON ObjectLink_GoodsChild.ObjectId      = Object_ReceiptGoodsChild.Id
                                                        AND ObjectLink_GoodsChild.DescId        = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                                        AND ObjectLink_GoodsChild.ChildObjectId > 0

                              WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
                               AND (Object_ReceiptGoods.isErased = FALSE OR inIsErased = TRUE)
                             )
     -- Результат
     SELECT
           Object_ReceiptGoods.Id         AS Id
         , Object_ReceiptGoods.ObjectCode AS Code
         , Object_ReceiptGoods.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , CASE WHEN ObjectString_Comment.ValueData <> '' THEN ObjectString_Comment.ValueData ELSE ObjectString_Goods_Comment.ValueData END ::TVarChar  AS Comment
         , ObjectBoolean_Main.ValueData       ::Boolean   AS isMain

         , Object_Goods.Id         ::Integer  AS GoodsId
         , Object_Goods.ObjectCode ::Integer  AS GoodsCode
         , Object_Goods.ValueData  ::TVarChar AS GoodsName
         , zfCalc_GoodsName_all (ObjectString_Article.ValueData, Object_Goods.ValueData) ::TVarChar AS GoodsName_all

         , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

         , tmpMaterialOptions.MaterialOptionsName :: TVarChar AS MaterialOptionsName
         , COALESCE (tmpProdColorPattern.ProdColorName, tmpProdColorPattern_next.ProdColorName, tmpProdColorPattern_next_all.ProdColorName) :: TVarChar AS ProdColorName_pcp

         , Object_Unit.Id                     AS UnitId
         , Object_Unit.ValueData              AS UnitName
         
         , Object_Insert.ValueData            AS InsertName
         , Object_Update.ValueData            AS UpdateName
         , ObjectDate_Insert.ValueData        AS InsertDate
         , ObjectDate_Update.ValueData        AS UpdateDate
         , Object_ReceiptGoods.isErased       AS isErased

           --
         , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
         , ObjectString_Article.ValueData        ::TVarChar  AS Article
         , Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
         , Object_Measure.ValueData              ::TVarChar  AS MeasureName
         , ObjectString_Goods_Comment.ValueData  ::TVarChar  AS Comment_goods


         , tmpReceiptGoodsChild.EKPrice_summ_goods      ::TFloat
         , tmpReceiptGoodsChild.EKPriceWVAT_summ_goods  ::TFloat

         , tmpReceiptGoodsChild.EKPrice_summ_colPat     ::TFloat
         , tmpReceiptGoodsChild.EKPriceWVAT_summ_colPat ::TFloat

         , (COALESCE (tmpReceiptGoodsChild.EKPrice_summ_colPat,0)     + COALESCE (tmpReceiptGoodsChild.EKPrice_summ_goods,0))     ::TFloat AS EKPrice_summ
         , (COALESCE (tmpReceiptGoodsChild.EKPriceWVAT_summ_colPat,0) + COALESCE (tmpReceiptGoodsChild.EKPriceWVAT_summ_goods,0)) ::TFloat AS EKPriceWVAT_summ

           -- Цена продажи без ндс
         , COALESCE (tmpPriceBasis.ValuePrice, 0)     ::TFloat AS BasisPrice
           -- Цена продажи с ндс
         , COALESCE (tmpPriceBasis.ValuePriceWVAT, 0) ::TFloat AS BasisPriceWVAT

     FROM tmpReceiptGoods AS Object_ReceiptGoods
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptGoods_Code()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptGoods_Comment()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_ReceiptGoods.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptGoods_Main()

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Object_ReceiptGoods.GoodsId

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ReceiptGoods_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit
                               ON ObjectLink_Unit.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Unit.DescId = zc_ObjectLink_ReceiptGoods_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectDate AS ObjectDate_Update
                               ON ObjectDate_Update.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

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

          LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                 ON ObjectString_Goods_Comment.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()

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

          LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

          LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptGoodsId = Object_ReceiptGoods.Id

          LEFT JOIN (SELECT tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                          , STRING_AGG (DISTINCT tmpReceiptGoodsChild_ProdColorPattern.MaterialOptionsName, ';') AS MaterialOptionsName
                     FROM tmpReceiptGoodsChild_ProdColorPattern
                     WHERE tmpReceiptGoodsChild_ProdColorPattern.MaterialOptionsName <> ''
                     GROUP BY tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                    ) AS tmpMaterialOptions
                      ON tmpMaterialOptions.ReceiptGoodsId = Object_ReceiptGoods.Id
          -- если это Товар
          LEFT JOIN (SELECT tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                          , STRING_AGG (tmpReceiptGoodsChild_ProdColorPattern.ProdColorName, ';') AS ProdColorName
                     FROM tmpReceiptGoodsChild_ProdColorPattern
                     WHERE tmpReceiptGoodsChild_ProdColorPattern.GoodsId > 0 OR tmpReceiptGoodsChild_ProdColorPattern.ProdColorPatternName_all ILIKE 'Stitching%'
                     GROUP BY tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                    ) AS tmpProdColorPattern
                      ON tmpProdColorPattern.ReceiptGoodsId = Object_ReceiptGoods.Id
                     AND tmpProdColorPattern.ProdColorName <> ''

          -- если это Примечание, одинаковое значение
          LEFT JOIN (SELECT tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                          , STRING_AGG (DISTINCT tmpReceiptGoodsChild_ProdColorPattern.ProdColorName, ';') AS ProdColorName
                     FROM tmpReceiptGoodsChild_ProdColorPattern
                     WHERE tmpReceiptGoodsChild_ProdColorPattern.GoodsId IS NULL
                     GROUP BY tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                    ) AS tmpProdColorPattern_next
                      ON tmpProdColorPattern_next.ReceiptGoodsId = Object_ReceiptGoods.Id
                     AND tmpProdColorPattern_next.ProdColorName <> ''
                     AND POSITION (';' IN tmpProdColorPattern_next.ProdColorName) = 0

          -- если это Примечание, хоть одно отличное значение
          LEFT JOIN (SELECT tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                          , STRING_AGG (tmpReceiptGoodsChild_ProdColorPattern.ProdColorName, ';') AS ProdColorName
                     FROM tmpReceiptGoodsChild_ProdColorPattern
                     WHERE tmpReceiptGoodsChild_ProdColorPattern.GoodsId IS NULL
                     GROUP BY tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                    ) AS tmpProdColorPattern_next_all
                      ON tmpProdColorPattern_next_all.ReceiptGoodsId = Object_ReceiptGoods.Id

     WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
      AND (Object_ReceiptGoods.isErased = FALSE OR inIsErased = TRUE)
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.22         * Unit
 11.12.20         *
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptGoods (false, zfCalc_UserAdmin())
