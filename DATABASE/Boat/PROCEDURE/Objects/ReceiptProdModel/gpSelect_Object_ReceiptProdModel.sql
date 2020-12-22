-- Function: gpSelect_Object_ReceiptProdModel()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModel (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModel(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , isMain Boolean
             , ModelId Integer, ModelName TVarChar
             , BrandId Integer, BrandName TVarChar
             , EngineId Integer, EngineName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , EKPrice_summ            TFloat
             , EKPriceWVAT_summ        TFloat
             , Basis_summ              TFloat
             , BasisWVAT_summ          TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModel());
     vbUserId:= lpGetUserBySession (inSession);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());


     RETURN QUERY
     WITH
          -- Цены
          tmpPriceBasis AS (SELECT tmp.GoodsId
                                 , tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS tmp
                           UNION
                            SELECT Object.Id, 1 AS ValuePrice FROM Object WHERE Object.DescId = zc_Object_ReceiptService()
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
                           , COALESCE (ObjectFloat_EKPrice.ValueData, 0) :: TFloat AS EKPrice
                             -- Цена вх. с НДС
                           , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                  * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) :: TFloat AS EKPriceWVAT

                             -- Цена продажи без ндс
                           , CASE WHEN vbPriceWithVAT = FALSE
                                  THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                  ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                             END  :: TFloat AS BasisPrice
                             -- Цена продажи с ндс
                           , CASE WHEN vbPriceWithVAT = FALSE
                                  THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                  ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                             END ::TFloat AS BasisPriceWVAT

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

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                ON ObjectLink_Goods_TaxKind.ObjectId = ObjectLink_Object.ChildObjectId
                                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                           LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Object.ChildObjectId
                                                AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

                           LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Object.ChildObjectId

                      WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                        AND Object_ReceiptProdModelChild.isErased = FALSE
                     )

          -- раскладываем ReceiptProdModelChild
        , tmpReceiptGoodsChild AS
                     (SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
                             -- Сумма вх. без НДС
                           , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0) * COALESCE (ObjectFloat_EKPrice.ValueData, 0)) :: TFloat AS EKPrice_summ
                             -- Сумма вх. с НДС
                           , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)
                                  * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                         * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ

                             -- Сумма продажи без НДС
                           , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)
                              * CASE WHEN vbPriceWithVAT = FALSE
                                     THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                     ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                END) AS Basis_summ
                             -- Сумма продажи с НДС
                           , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)
                              * CASE WHEN vbPriceWithVAT = FALSE
                                      THEN CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                      ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                                END) AS BasisWVAT_summ

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
                           -- значение в сборке
                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                 ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()

                           -- !!!с этой структурой!!!
                           INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Object.ChildObjectId

                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                           LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                           LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id
                     )
       , tmpChild AS (SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                             --
                           , SUM (tmpReceiptProdModelChild.EKPrice_summ)     :: TFloat AS EKPrice_summ
                           , SUM (tmpReceiptProdModelChild.EKPriceWVAT_summ) :: TFloat AS EKPriceWVAT_summ
                           , SUM (tmpReceiptProdModelChild.Basis_summ)       :: TFloat AS Basis_summ
                           , SUM (tmpReceiptProdModelChild.BasisWVAT_summ)   :: TFloat AS BasisWVAT_summ

                      FROM (SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                                   --
                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPrice)        AS EKPrice_summ
                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPriceWVAT)    AS EKPriceWVAT_summ
                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.BasisPrice)     AS Basis_summ
                                 , SUM (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.BasisPriceWVAT) AS BasisWVAT_summ
                    
                            FROM tmpReceiptProdModelChild
                                 LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                            WHERE tmpReceiptGoodsChild.ReceiptProdModelChildId IS NULL
                            GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                    
                           UNION ALL
                            SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                                   --
                                 , SUM (tmpReceiptGoodsChild.EKPrice_summ)     AS EKPrice_summ
                                 , SUM (tmpReceiptGoodsChild.EKPriceWVAT_summ) AS EKPriceWVAT_summ
                                 , SUM (tmpReceiptGoodsChild.Basis_summ)       AS Basis_summ
                                 , SUM (tmpReceiptGoodsChild.BasisWVAT_summ)   AS BasisWVAT_summ
                    
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

         , Object_Insert.ValueData            AS InsertName
         , Object_Update.ValueData            AS UpdateName
         , ObjectDate_Insert.ValueData        AS InsertDate
         , ObjectDate_Update.ValueData        AS UpdateDate
         , Object_ReceiptProdModel.isErased   AS isErased

         , tmpChild.EKPrice_summ
         , tmpChild.EKPriceWVAT_summ
         , tmpChild.Basis_summ
         , tmpChild.BasisWVAT_summ

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

     WHERE Object_ReceiptProdModel.DescId = zc_Object_ReceiptProdModel()
      AND (Object_ReceiptProdModel.isErased = FALSE OR inIsErased = TRUE)
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
-- SELECT * FROM gpSelect_Object_ReceiptProdModel (false, zfCalc_UserAdmin())
