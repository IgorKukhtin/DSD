-- Function: gpSelect_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoods(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , isMain Boolean
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar

             , EKPrice_summ_goods     TFloat
             , EKPriceWVAT_summ_goods TFloat
             , Basis_summ_goods       TFloat
             , BasisWVAT_summ_goods   TFloat

             , EKPrice_summ_colPat     TFloat
             , EKPriceWVAT_summ_colPat TFloat
             , Basis_summ_colPat       TFloat
             , BasisWVAT_summ_colPat   TFloat

             , EKPrice_summ     TFloat
             , EKPriceWVAT_summ TFloat
             , Basis_summ       TFloat
             , BasisWVAT_summ   TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());


     RETURN QUERY
     WITH tmpPriceBasis AS (SELECT tmp.GoodsId
                                 , tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS tmp
                           )

        , tmpReceiptGoodsChild AS (SELECT ObjectLink_ReceiptGoods.ChildObjectId  ::Integer  AS ReceiptGoodsId

                                        , SUM (CASE WHEN ObjectLink_ProdColorPattern.ChildObjectId IS NULL THEN ObjectFloat_Value.ValueData * ObjectFloat_EKPrice.ValueData ELSE 0 END) :: TFloat AS EKPrice_summ_goods
                                        , SUM (CASE WHEN ObjectLink_ProdColorPattern.ChildObjectId IS NULL THEN 1 ELSE 0 END
                                               * ObjectFloat_Value.ValueData
                                               * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                                      * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ_goods
                    
                                        , SUM (CASE WHEN ObjectLink_ProdColorPattern.ChildObjectId IS NULL THEN 1 ELSE 0 END
                                               * ObjectFloat_Value.ValueData
                                               * CASE WHEN vbPriceWithVAT = FALSE
                                                      THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                                      ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                                 END)  :: TFloat AS Basis_summ_goods

                                        , SUM (CASE WHEN ObjectLink_ProdColorPattern.ChildObjectId IS NULL THEN 1 ELSE 0 END
                                               * ObjectFloat_Value.ValueData
                                               * CASE WHEN vbPriceWithVAT = FALSE
                                                       THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                                       ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
                                                  END) ::TFloat BasisWVAT_summ_goods
                                        ------------------
                                        , SUM (CASE WHEN COALESCE (ObjectLink_ProdColorPattern.ChildObjectId,0)<>0 THEN ObjectFloat_Value.ValueData * ObjectFloat_EKPrice.ValueData ELSE 0 END) :: TFloat AS EKPrice_summ_colPat
                                        , SUM (CASE WHEN COALESCE (ObjectLink_ProdColorPattern.ChildObjectId,0)<>0 THEN 1 ELSE 0 END
                                               * ObjectFloat_Value.ValueData
                                               * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                                      * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ_colPat
                    
                                        , SUM (CASE WHEN COALESCE (ObjectLink_ProdColorPattern.ChildObjectId,0)<>0 THEN 1 ELSE 0 END
                                               * ObjectFloat_Value.ValueData
                                               * CASE WHEN vbPriceWithVAT = FALSE
                                                      THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                                      ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                                 END)  :: TFloat AS Basis_summ_colPat

                                        , SUM (CASE WHEN COALESCE (ObjectLink_ProdColorPattern.ChildObjectId,0)<>0 THEN 1 ELSE 0 END
                                               * ObjectFloat_Value.ValueData
                                               * CASE WHEN vbPriceWithVAT = FALSE
                                                       THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                                       ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
                                                  END) ::TFloat BasisWVAT_summ_colPat

                                   FROM Object AS Object_ReceiptGoodsChild
                            
                                        LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                              ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value() 
                            
                                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                             ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                            AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                        LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId 

                                        LEFT JOIN ObjectLink AS ObjectLink_Object
                                                             ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                            AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()

                                        LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                             ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                                            AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
          
                                        LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                             ON ObjectLink_Goods.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                            AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()

                                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (ObjectLink_Object.ChildObjectId, ObjectLink_Goods.ChildObjectId)

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
                              
                                   WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                    AND (Object_ReceiptGoodsChild.isErased = FALSE OR inIsErased = TRUE)
                                   GROUP BY ObjectLink_ReceiptGoods.ChildObjectId
                                   )



     --
     SELECT 
           Object_ReceiptGoods.Id         AS Id 
         , Object_ReceiptGoods.ObjectCode AS Code
         , Object_ReceiptGoods.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment
         , ObjectBoolean_Main.ValueData       ::Boolean   AS isMain

         , Object_Goods.Id         ::Integer  AS GoodsId
         , Object_Goods.ObjectCode ::Integer  AS GoodsCode
         , Object_Goods.ValueData  ::TVarChar AS GoodsName

         , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

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

        , tmpReceiptGoodsChild.EKPrice_summ_goods     ::TFloat
        , tmpReceiptGoodsChild.EKPriceWVAT_summ_goods ::TFloat
        , tmpReceiptGoodsChild.Basis_summ_goods       ::TFloat
        , tmpReceiptGoodsChild.BasisWVAT_summ_goods   ::TFloat

        , tmpReceiptGoodsChild.EKPrice_summ_colPat     ::TFloat
        , tmpReceiptGoodsChild.EKPriceWVAT_summ_colPat ::TFloat
        , tmpReceiptGoodsChild.Basis_summ_colPat       ::TFloat
        , tmpReceiptGoodsChild.BasisWVAT_summ_colPat   ::TFloat
               
        , (COALESCE (tmpReceiptGoodsChild.EKPrice_summ_colPat,0)     + COALESCE (tmpReceiptGoodsChild.EKPrice_summ_goods,0))     ::TFloat AS EKPrice_summ
        , (COALESCE (tmpReceiptGoodsChild.EKPriceWVAT_summ_colPat,0) + COALESCE (tmpReceiptGoodsChild.EKPriceWVAT_summ_goods,0)) ::TFloat AS EKPriceWVAT_summ
        , (COALESCE (tmpReceiptGoodsChild.Basis_summ_colPat,0)       + COALESCE (tmpReceiptGoodsChild.Basis_summ_goods,0))       ::TFloat AS Basis_summ
        , (COALESCE (tmpReceiptGoodsChild.BasisWVAT_summ_colPat,0)   + COALESCE (tmpReceiptGoodsChild.BasisWVAT_summ_goods,0))   ::TFloat AS BasisWVAT_summ
     FROM Object AS Object_ReceiptGoods
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptGoods_Code()  
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ReceiptGoods.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptGoods_Comment()  

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = Object_ReceiptGoods.Id
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptGoods_Main() 

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ReceiptGoods_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

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
          
          LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptGoodsId = Object_ReceiptGoods.Id

     WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
      AND (Object_ReceiptGoods.isErased = FALSE OR inIsErased = TRUE)
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.20         *
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptGoods (false, zfCalc_UserAdmin())
