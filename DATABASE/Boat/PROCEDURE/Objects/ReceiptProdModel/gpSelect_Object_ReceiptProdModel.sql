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
             , EKPrice_summ_colPat     TFloat
             , EKPrice_summ_goods      TFloat
             , EKPriceWVAT_summ_colPat TFloat
             , EKPriceWVAT_summ_goods  TFloat
             , Basis_summ_colPat       TFloat
             , Basis_summ_goods        TFloat
             , BasisWVAT_summ_colPat   TFloat
             , BasisWVAT_summ_goods    TFloat
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
     WITH tmpPriceBasis AS (SELECT tmp.GoodsId
                                 , tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS tmp
                           )
        , tmpReceiptChild AS (SELECT Object_ReceiptProdModelChild.*
                                   , ObjectLink_ReceiptProdModel.ChildObjectId  ::Integer  AS ReceiptProdModelId
                                   , ObjectLink_Object.ChildObjectId AS ObjectId
                                   , Object_Object.DescId            AS ObjectDescId
                                   , ObjectFloat_Value.ValueData     AS Value
                              FROM Object AS Object_ReceiptProdModelChild

                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value() 

                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                        ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                                       AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                               
                                   LEFT JOIN ObjectLink AS ObjectLink_Object
                                                        ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                       AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptProdModelChild_Object()
                                   LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId

                              WHERE Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
                               AND (Object_ReceiptProdModelChild.isErased = FALSE OR inIsErased = TRUE)
                              )

        , tmpReceiptProdModelChild AS 
                    (SELECT tmp.ReceiptProdModelId
                          , SUM (tmp.EKPrice_summ_colPat)     :: TFloat AS EKPrice_summ_colPat
                          , SUM (tmp.EKPriceWVAT_summ_colPat) :: TFloat AS EKPriceWVAT_summ_colPat
                          , SUM (tmp.Basis_summ_colPat)       :: TFloat AS Basis_summ_colPat
                          , SUM (tmp.BasisWVAT_summ_colPat)   :: TFloat AS BasisWVAT_summ_colPat
                          ------
                          , SUM (tmp.EKPrice_summ_goods)      :: TFloat AS EKPrice_summ_goods
                          , SUM (tmp.EKPriceWVAT_summ_goods)  :: TFloat AS EKPriceWVAT_summ_goods
                          , SUM (tmp.Basis_summ_goods)        :: TFloat AS Basis_summ_goods
                          , SUM (tmp.BasisWVAT_summ_goods)    :: TFloat AS BasisWVAT_summ_goods
                     FROM 
                         (--zc_Object_ProdColorPattern
                          SELECT tmpReceiptProdModelChild.ReceiptProdModelId

                               , SUM (tmpReceiptProdModelChild.Value * ObjectFloat_EKPrice.ValueData
                                      ) :: TFloat AS EKPrice_summ_colPat

                               , SUM (tmpReceiptProdModelChild.Value
                                    * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                           * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))
                                      ) :: TFloat AS EKPriceWVAT_summ_colPat

                               , SUM (tmpReceiptProdModelChild.Value
                                    * CASE WHEN vbPriceWithVAT = FALSE
                                           THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                           ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                      END
                                      )  :: TFloat AS Basis_summ_colPat

                               , SUM (tmpReceiptProdModelChild.Value
                                    * CASE WHEN vbPriceWithVAT = FALSE
                                            THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                            ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
                                       END
                                      ) ::TFloat AS BasisWVAT_summ_colPat
                               ------
                               , 0 :: TFloat AS EKPrice_summ_goods
                               , 0 :: TFloat AS EKPriceWVAT_summ_goods
                               , 0 :: TFloat AS Basis_summ_goods
                               , 0 :: TFloat AS BasisWVAT_summ_goods
                          FROM tmpReceiptChild AS tmpReceiptProdModelChild
                               LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                    ON ObjectLink_Goods.ObjectId = tmpReceiptProdModelChild.ObjectId
                                                   AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()
                               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

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

                          WHERE tmpReceiptProdModelChild.ObjectDescId = zc_Object_ProdColorPattern()
                          GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                        UNION
                          --zc_Object_Goods()
                          SELECT tmpReceiptProdModelChild.ReceiptProdModelId
                               , 0 :: TFloat AS EKPrice_summ_colPat
                               , 0 :: TFloat AS EKPriceWVAT_summ_colPat
                               , 0 :: TFloat AS Basis_summ_colPat
                               , 0 :: TFloat AS BasisWVAT_summ_colPat
                                      
                               , SUM (COALESCE(tmpReceiptProdModelChild.Value,0) * (COALESCE (ObjectFloat_ReceiptGoodsChild_Value.ValueData,1) * ObjectFloat_EKPrice.ValueData)) :: TFloat AS EKPrice_summ_goods
                               , SUM (COALESCE(tmpReceiptProdModelChild.Value,0)
                                     *(COALESCE (ObjectFloat_ReceiptGoodsChild_Value.ValueData,1)
                                      * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                             * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)
                                      )) ) :: TFloat AS EKPriceWVAT_summ_goods

                               , SUM (COALESCE (tmpReceiptProdModelChild.Value,0) 
                                     *(COALESCE (ObjectFloat_ReceiptGoodsChild_Value.ValueData,1)
                                      * CASE WHEN vbPriceWithVAT = FALSE
                                             THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                             ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                        END))  :: TFloat AS Basis_summ_goods

                               , SUM (COALESCE(tmpReceiptProdModelChild.Value,0) 
                                     *(COALESCE (ObjectFloat_ReceiptGoodsChild_Value.ValueData,1)
                                      * CASE WHEN vbPriceWithVAT = FALSE
                                              THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                              ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
                                         END)) ::TFloat AS BasisWVAT_summ_goods

                          FROM (SELECT tmp.* FROM tmpReceiptChild AS tmp WHERE tmp.ObjectDescId = zc_Object_Goods()) AS tmpReceiptProdModelChild
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                  ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpReceiptProdModelChild.ObjectId
                                                 AND ObjectLink_ReceiptGoods_Object.DescId = zc_ObjectLink_ReceiptGoods_Object()
                
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                     ON ObjectBoolean_Main.ObjectId = ObjectLink_ReceiptGoods_Object.ObjectId
                                                    AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_ReceiptGoods_Main() 
                
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                  ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = ObjectLink_ReceiptGoods_Object.ObjectId  --ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                
                             LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptGoodsChild_Value
                                                   ON ObjectFloat_ReceiptGoodsChild_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                  AND ObjectFloat_ReceiptGoodsChild_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value() 
                   
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_Goods
                                                  ON ObjectLink_ReceiptGoodsChild_Goods.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                 AND ObjectLink_ReceiptGoodsChild_Goods.DescId = zc_ObjectLink_ReceiptGoodsChild_Goods()
                
                             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (ObjectLink_ReceiptGoodsChild_Goods.ChildObjectId,tmpReceiptProdModelChild.ObjectId)
                
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
                          WHERE COALESCE (ObjectBoolean_Main.ValueData, FALSE)  = TRUE OR ObjectLink_ReceiptGoods_Object.ObjectId IS NULL
                          GROUP BY tmpReceiptProdModelChild.ReceiptProdModelId
                          ) AS tmp
                     GROUP BY tmp.ReceiptProdModelId
                     )


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

         , tmpReceiptProdModelChild.EKPrice_summ_colPat     ::TFloat
         , tmpReceiptProdModelChild.EKPrice_summ_goods      ::TFloat
         , tmpReceiptProdModelChild.EKPriceWVAT_summ_colPat ::TFloat
         , tmpReceiptProdModelChild.EKPriceWVAT_summ_goods  ::TFloat
         , tmpReceiptProdModelChild.Basis_summ_colPat       ::TFloat
         , tmpReceiptProdModelChild.Basis_summ_goods        ::TFloat
         , tmpReceiptProdModelChild.BasisWVAT_summ_colPat   ::TFloat
         , tmpReceiptProdModelChild.BasisWVAT_summ_goods    ::TFloat
         , (COALESCE (tmpReceiptProdModelChild.EKPrice_summ_colPat,0)     + COALESCE (tmpReceiptProdModelChild.EKPrice_summ_goods,0))     ::TFloat AS EKPrice_summ
         , (COALESCE (tmpReceiptProdModelChild.EKPriceWVAT_summ_colPat,0) + COALESCE (tmpReceiptProdModelChild.EKPriceWVAT_summ_goods,0)) ::TFloat AS EKPriceWVAT_summ
         , (COALESCE (tmpReceiptProdModelChild.Basis_summ_colPat,0)       + COALESCE(tmpReceiptProdModelChild.Basis_summ_goods,0))        ::TFloat AS Basis_summ
         , (COALESCE (tmpReceiptProdModelChild.BasisWVAT_summ_colPat,0)   + COALESCE(tmpReceiptProdModelChild.BasisWVAT_summ_goods,0))    ::TFloat AS BasisWVAT_summ
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

          LEFT JOIN tmpReceiptProdModelChild ON tmpReceiptProdModelChild.ReceiptProdModelId = Object_ReceiptProdModel.Id
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
