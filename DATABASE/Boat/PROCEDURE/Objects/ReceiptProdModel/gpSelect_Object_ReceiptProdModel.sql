-- Function: gpSelect_Object_ReceiptProdModel()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModel (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModel (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModel(
    IN inModelId         Integer,
    IN inIsErased        Boolean,       -- признак показать удаленные да / нет
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , isMain Boolean
             , ModelId Integer, ModelName TVarChar
             , BrandId Integer, BrandName TVarChar
             , EngineId Integer, EngineName TVarChar
             , MaterialOptionsName TVarChar, ProdColorName_pcp TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , EKPrice_summ            TFloat
             , EKPriceWVAT_summ        TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
              )
AS
$BODY$
   DECLARE vbUserId             Integer;
   DECLARE vbPriceWithVAT_pl    Boolean;
   DECLARE vbTaxKindValue_basis TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModel());
     vbUserId:= lpGetUserBySession (inSession);


     -- Признак в Базовом Прайсе
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!Базовый % НДС!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());

     -- Результат
     RETURN QUERY
     WITH
          -- Цены
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
                           --UNION
                           -- SELECT Object.Id, 1 AS ValuePrice FROM Object WHERE Object.DescId = zc_Object_ReceiptService()
                           )
          -- элементы ReceiptProdModelChild
        , tmpReceiptProdModelChild AS
                     (SELECT ObjectLink_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
                           , Object_ReceiptProdModelChild.Id           AS ReceiptProdModelChildId
                             -- элемент который будем раскладывать
                           , ObjectLink_Object.ChildObjectId           AS ObjectId
                             -- значение
                           , COALESCE (ObjectFloat_Value.ValueData, 0)   :: TFloat AS Value

                             -- Цена вх. без НДС
                           , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
                             -- Цена вх. с НДС
                           , zfCalc_SummWVAT ( COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0), ObjectFloat_TaxKind_Value.ValueData) AS EKPriceWVAT
                      FROM Object AS Object_ReceiptProdModelChild
                           LEFT JOIN ObjectLink AS ObjectLink_Object
                                                ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                               AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()

                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                               AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()

                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                 ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value()

                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Object.ChildObjectId
                                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                              -- цены для Работы/Услуги вход. без ндс
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                                 ON ObjectFloat_ReceiptService_EKPrice.ObjectId = ObjectLink_Object.ChildObjectId
                                                AND ObjectFloat_ReceiptService_EKPrice.DescId = zc_ObjectFloat_ReceiptService_EKPrice()
                              -- цены для Работы/Услуги продажи без ндс
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice
                                                 ON ObjectFloat_ReceiptService_SalePrice.ObjectId = ObjectLink_Object.ChildObjectId
                                                AND ObjectFloat_ReceiptService_SalePrice.DescId = zc_ObjectFloat_ReceiptService_SalePrice()

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis() --Object_TaxKind.Id
                                                AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

                      WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                        AND Object_ReceiptProdModelChild.isErased = FALSE
                     )

          -- раскладываем ReceiptProdModelChild
        , tmpReceiptGoodsChild AS
                     (SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
                             -- 
                           , Object_ProdColorPattern.ObjectCode AS ProdColorPatternCode
                             -- Категория Опций
                           , Object_MaterialOptions.Id          AS MaterialOptionsId
                           , Object_MaterialOptions.ValueData   AS MaterialOptionsName
                             -- значение Farbe
                           , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL AND Object_ReceiptGoodsChild.ValueData <> ''
                                       THEN Object_ReceiptGoodsChild.ValueData
                                  WHEN ObjectLink_Goods.ChildObjectId IS NULL
                                       THEN ObjectString_Comment.ValueData
                                  ELSE Object_ProdColor.ValueData
                             END :: TVarChar AS ProdColorName
                             -- Сумма вх. без НДС
                           , zfCalc_SummIn (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0), COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0),1) :: TFloat AS EKPrice_summ
                             -- Сумма вх. с НДС
                           , zfCalc_SummWVAT (zfCalc_SummIn (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0), COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0),1)
                                            , ObjectFloat_TaxKind_Value.ValueData)  AS EKPriceWVAT_summ
                      FROM tmpReceiptProdModelChild
                           -- нашли его в сборке узлов
                           INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                 ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpReceiptProdModelChild.ObjectId
                                                AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                           -- это главный шаблон
                           INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                    ON ObjectBoolean_Main.ObjectId  = ObjectLink_ReceiptGoods_Object.ObjectId
                                                   AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptGoods_Main()
                                                   AND ObjectBoolean_Main.ValueData = TRUE
                           -- из чего состоит
                           INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                 ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = ObjectLink_ReceiptGoods_Object.ObjectId
                                                AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                           -- не удален
                           INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                        AND Object_ReceiptGoodsChild.isErased = FALSE
                           -- Комплектующие / Работы/Услуги
                           LEFT JOIN ObjectLink AS ObjectLink_Object
                                                ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                               AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                           -- с этой структурой
                           LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                ON ObjectLink_ProdColorPattern.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                               AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                           LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                           -- Goods - для этой структуры
                           LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                ON ObjectLink_Goods.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                               AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
                           -- Farbe - для этой структуры
                           LEFT JOIN ObjectString AS ObjectString_Comment
                                                  ON ObjectString_Comment.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                 AND ObjectString_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()
                           -- Farbe - для этой структуры + здесь уже фактический Goods
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                ON ObjectLink_Goods_ProdColor.ObjectId = ObjectLink_Object.ChildObjectId
                                               AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                                               -- !!!с этой структурой!!!
                                               AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                           LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
                           -- значение в сборке
                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                 ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()

                           -- !!!с этой структурой!!!
                           INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Object.ChildObjectId

                            -- Категория Опций
                           LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                ON ObjectLink_MaterialOptions.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                               AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                           LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId

                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                              -- цены для Работы/Услуги вход. без ндс
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                                 ON ObjectFloat_ReceiptService_EKPrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_ReceiptService_EKPrice.DescId = zc_ObjectFloat_ReceiptService_EKPrice()
                              -- цены для Работы/Услуги продажи без ндс
                           LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice
                                                 ON ObjectFloat_ReceiptService_SalePrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_ReceiptService_SalePrice.DescId = zc_ObjectFloat_ReceiptService_SalePrice()

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis() --Object_TaxKind.Id
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                     )

       , tmpChild AS (SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                             --
                           , SUM (tmpReceiptProdModelChild.EKPrice_summ)     :: TFloat AS EKPrice_summ
                           , SUM (tmpReceiptProdModelChild.EKPriceWVAT_summ) :: TFloat AS EKPriceWVAT_summ
                      FROM (SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                                   --
                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPrice)        AS EKPrice_summ
                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPriceWVAT)    AS EKPriceWVAT_summ
                            FROM tmpReceiptProdModelChild
                                 LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                            WHERE tmpReceiptGoodsChild.ReceiptProdModelChildId IS NULL
                            GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                           UNION ALL
                            SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                                   --
                                 , SUM (tmpReceiptGoodsChild.EKPrice_summ)     AS EKPrice_summ
                                 , SUM (tmpReceiptGoodsChild.EKPriceWVAT_summ) AS EKPriceWVAT_summ
                            FROM tmpReceiptProdModelChild
                                 INNER JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                            GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                           ) AS tmpReceiptProdModelChild
                      GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                     )
     -- Результат
     SELECT
           Object_ReceiptProdModel.Id         AS Id
         , Object_ReceiptProdModel.ObjectCode AS Code
         , Object_ReceiptProdModel.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment
         , ObjectBoolean_Main.ValueData       ::Boolean   AS isMain

         , Object_Model.Id           ::Integer  AS ModelId
         , Object_Model.ValueData    ::TVarChar AS ModelName
         , Object_Brand.Id                      AS BrandId
         , Object_Brand.ValueData               AS BrandName
         , Object_ProdEngine.Id                 AS EngineId
         , Object_ProdEngine.ValueData          AS EngineName

         , tmpMaterialOptions.MaterialOptionsName :: TVarChar AS MaterialOptionsName
         , tmpProdColorPattern.ProdColorName      :: TVarChar AS ProdColorName_pcp

         , Object_Insert.ValueData            AS InsertName
         , Object_Update.ValueData            AS UpdateName
         , ObjectDate_Insert.ValueData        AS InsertDate
         , ObjectDate_Update.ValueData        AS UpdateDate
         , Object_ReceiptProdModel.isErased   AS isErased

         , tmpChild.EKPrice_summ
         , tmpChild.EKPriceWVAT_summ

          -- Цена продажи без ндс

        , COALESCE (tmpPriceBasis.ValuePrice, 0)     ::TFloat AS BasisPrice
          -- Цена продажи с ндс
        , COALESCE (tmpPriceBasis.ValuePriceWVAT, 0) ::TFloat AS BasisPriceWVAT

     FROM Object AS Object_ReceiptProdModel
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptProdModel.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptProdModel_Code()
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptProdModel.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptProdModel_Comment()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_ReceiptProdModel.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptProdModel_Main()

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_ReceiptProdModel.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                               ON ObjectLink_ProdEngine.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
          LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ReceiptProdModel.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_ReceiptProdModel.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ReceiptProdModel.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectDate AS ObjectDate_Update
                               ON ObjectDate_Update.ObjectId = Object_ReceiptProdModel.Id
                              AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN tmpChild ON tmpChild.ReceiptProdModelId = Object_ReceiptProdModel.Id
          
          LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_ReceiptProdModel.Id

          LEFT JOIN (SELECT tmpChild.ReceiptProdModelId
                          , STRING_AGG (tmpChild.MaterialOptionsName, ';') AS MaterialOptionsName
                     FROM (SELECT tmpReceiptProdModelChild.ReceiptProdModelId, tmpReceiptGoodsChild.MaterialOptionsName
                                , MIN (tmpReceiptGoodsChild.ProdColorPatternCode)
                           FROM tmpReceiptProdModelChild
                                INNER JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                           WHERE tmpReceiptGoodsChild.MaterialOptionsName <> ''
                           GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId, tmpReceiptGoodsChild.MaterialOptionsName
                           ORDER BY 1, 3
                          ) AS tmpChild
                     GROUP BY tmpChild.ReceiptProdModelId
                    ) AS tmpMaterialOptions
                      ON tmpMaterialOptions.ReceiptProdModelId = Object_ReceiptProdModel.Id

          LEFT JOIN (SELECT tmpChild.ReceiptProdModelId
                          , STRING_AGG (tmpChild.ProdColorName, ';') AS ProdColorName
                     FROM (SELECT tmpReceiptProdModelChild.ReceiptProdModelId, tmpReceiptGoodsChild.ProdColorName
                           FROM tmpReceiptProdModelChild
                                INNER JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                           WHERE tmpReceiptGoodsChild.ProdColorName <> ''
                           ORDER BY tmpReceiptProdModelChild.ReceiptProdModelId, tmpReceiptGoodsChild.ProdColorPatternCode
                          ) AS tmpChild
                     GROUP BY tmpChild.ReceiptProdModelId
                    ) AS tmpProdColorPattern
                      ON tmpProdColorPattern.ReceiptProdModelId = Object_ReceiptProdModel.Id

     WHERE Object_ReceiptProdModel.DescId = zc_Object_ReceiptProdModel()
      AND (Object_ReceiptProdModel.isErased = FALSE OR inIsErased = TRUE)
      AND (ObjectLink_Model.ChildObjectId = inModelId OR inModelId = 0)
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptProdModel (0, false, zfCalc_UserAdmin())
