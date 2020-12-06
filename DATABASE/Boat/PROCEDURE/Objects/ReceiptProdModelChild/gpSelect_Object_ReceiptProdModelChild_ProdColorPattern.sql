-- Function: gpSelect_Object_ReceiptProdModelChild_ProdColorPattern()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelChild_ProdColorPattern (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModelChild_ProdColorPattern(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, NPP Integer, Comment TVarChar
             , Value TFloat
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , ProdColorGroupName TVarChar
             , GoodsCode Integer
             , GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , EKPrice TFloat, EKPriceWVAT TFloat
             , EmpfPrice TFloat, EmpfPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             
             , EKPrice_summ TFloat
             , EKPriceWVAT_summ TFloat
             , Basis_summ TFloat
             , BasisWVAT_summ TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModelChild());
   vbUserId:= lpGetUserBySession (inSession);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     RETURN QUERY
     WITH tmpPriceBasis AS (SELECT tmp.GoodsId
                                 , tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS tmp
                           )
     SELECT 
           Object_ReceiptProdModelChild.Id              AS Id
         , ROW_NUMBER() OVER (PARTITION BY Object_ReceiptProdModel.Id ORDER BY Object_Object.ObjectCode ASC) :: Integer AS NPP
         , Object_ReceiptProdModelChild.ValueData       AS Comment

         , ObjectFloat_Value.ValueData       ::TFloat   AS Value

         , Object_ReceiptProdModel.Id        ::Integer  AS ReceiptProdModelId
         , Object_ReceiptProdModel.ValueData ::TVarChar AS ReceiptProdModelName

         , Object_Object.Id                  ::Integer  AS ObjectId
         , Object_Object.ObjectCode          ::Integer  AS ObjectCode
         , Object_Object.ValueData           ::TVarChar AS ObjectName

         , Object_Insert.ValueData                      AS InsertName
         , Object_Update.ValueData                      AS UpdateName
         , ObjectDate_Insert.ValueData                  AS InsertDate
         , ObjectDate_Update.ValueData                  AS UpdateDate
         , Object_ReceiptProdModelChild.isErased        AS isErased
         
         , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName

         , Object_Goods.ObjectCode             ::Integer AS GoodsCode
         , Object_Goods.ValueData             ::TVarChar AS GoodsName
         , ObjectString_GoodsGroupFull.ValueData         AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                   AS GoodsGroupName
         , ObjectString_Article.ValueData                AS Article
         , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL
                THEN CASE WHEN Object_ReceiptProdModelChild.ValueData <> ''
                          THEN Object_ReceiptProdModelChild.ValueData
                          ELSE ObjectString_ProdColorPattern_Comment.ValueData
                     END
                ELSE Object_ProdColor.ValueData
           END :: TVarChar AS ProdColorName
         , Object_Measure.ValueData                      AS MeasureName
         
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
          
        , (ObjectFloat_Value.ValueData * ObjectFloat_EKPrice.ValueData) :: TFloat AS EKPrice_summ
        , (ObjectFloat_Value.ValueData
             * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ
                    
        , (ObjectFloat_Value.ValueData
            * CASE WHEN vbPriceWithVAT = FALSE
                   THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                   ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
              END)  :: TFloat AS Basis_summ

        , (ObjectFloat_Value.ValueData
            * CASE WHEN vbPriceWithVAT = FALSE
                    THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                    ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
               END) ::TFloat BasisWVAT_summ


     FROM Object AS Object_ReceiptProdModelChild

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value() 

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                               ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
          LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = ObjectLink_ReceiptProdModel.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Object
                               ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptProdModelChild_Object()
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectDate AS ObjectDate_Update
                               ON ObjectDate_Update.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_Object.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId 

          LEFT JOIN ObjectString AS ObjectString_ProdColorPattern_Comment
                                 ON ObjectString_ProdColorPattern_Comment.ObjectId = Object_Object.Id
                                AND ObjectString_ProdColorPattern_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId 

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

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
             
             
             
     WHERE Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
      AND (Object_ReceiptProdModelChild.isErased = FALSE OR inIsErased = TRUE)
      AND Object_Object.DescId = zc_Object_ProdColorPattern()
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
-- SELECT * FROM gpSelect_Object_ReceiptProdModelChild_ProdColorPattern (false, zfCalc_UserAdmin())
