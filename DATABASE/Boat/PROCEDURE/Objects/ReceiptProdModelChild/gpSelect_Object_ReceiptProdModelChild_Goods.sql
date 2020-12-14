-- Function: gpSelect_Object_ReceiptProdModelChild_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelChild_Goods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModelChild_Goods(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет 
    IN inSession     TVarChar       -- сессия пользователя
)
/*RETURNS TABLE (Id Integer, NPP Integer, Comment TVarChar
             , Value TFloat
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ReceiptLevelId Integer, ReceiptLevelName TVarChar
             , GoodsId_parent Integer, GoodsCode_parent Integer, GoodsName_parent TVarChar
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             
             , EKPrice_summ TFloat
             , EKPriceWVAT_summ TFloat
             , Basis_summ TFloat
             , BasisWVAT_summ TFloat
              )*/

RETURNS SETOF refcursor

AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbPriceWithVAT Boolean;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModelChild());
   vbUserId:= lpGetUserBySession (inSession);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     CREATE TEMP TABLE tmpPriceBasis ON COMMIT DROP AS
       (SELECT tmp.GoodsId
             , tmp.ValuePrice
        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                 , inOperDate   := CURRENT_DATE) AS tmp
       );

     CREATE TEMP TABLE tmpReceiptProdModelChild ON COMMIT DROP AS
       (SELECT Object_ReceiptProdModelChild.*
             , ObjectLink_Object.ChildObjectId AS GoodsId
        FROM Object AS Object_ReceiptProdModelChild
             LEFT JOIN ObjectLink AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptProdModelChild_Object()
             INNER JOIN Object AS Object_Object
                               ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                              AND Object_Object.DescId = zc_Object_Goods()
        WHERE Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
         AND (Object_ReceiptProdModelChild.isErased = FALSE OR inIsErased = TRUE)
        );

     CREATE TEMP TABLE tmpReceiptGoodsChild ON COMMIT DROP AS
       (SELECT tmpGoods.GoodsId                      AS GoodsId_parent
             , Object_Goods.Id                       AS GoodsId
             , Object_Goods.ObjectCode               AS GoodsCode
             , Object_Goods.ValueData                AS GoodsName

             , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , Object_GoodsGroup.ValueData           AS GoodsGroupName
             , ObjectString_Article.ValueData        AS Article
             , Object_ProdColor.ValueData            AS ProdColorName
             , Object_Measure.ValueData              AS MeasureName

             , ROW_NUMBER() OVER (PARTITION BY tmpGoods.GoodsId ORDER BY Object_Goods.ValueData ASC) :: Integer AS NPP

             , ObjectFloat_EKPrice.ValueData :: TFloat AS EKPrice
             , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) :: TFloat AS EKPriceWVAT
             , CASE WHEN vbPriceWithVAT = FALSE
                    THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                    ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
               END  :: TFloat AS BasisPrice
             , CASE WHEN vbPriceWithVAT = FALSE
                    THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                    ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
               END ::TFloat AS BasisPriceWVAT

             , SUM (COALESCE (ObjectFloat_ReceiptGoodsChild_Value.ValueData,1))    AS Value
             
             , SUM (COALESCE (ObjectFloat_ReceiptGoodsChild_Value.ValueData,1) * ObjectFloat_EKPrice.ValueData) :: TFloat AS EKPrice_summ
             , SUM (COALESCE (ObjectFloat_ReceiptGoodsChild_Value.ValueData,1)
                    * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                           * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ

             , SUM (COALESCE (ObjectFloat_ReceiptGoodsChild_Value.ValueData,1)
                    * CASE WHEN vbPriceWithVAT = FALSE
                           THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                           ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                      END)  :: TFloat AS Basis_summ

             , SUM (COALESCE (ObjectFloat_ReceiptGoodsChild_Value.ValueData,1)
                    * CASE WHEN vbPriceWithVAT = FALSE
                            THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                            ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
                       END) ::TFloat AS BasisWVAT_summ

        FROM (SELECT DISTINCT tmpRMC.GoodsId FROM tmpReceiptProdModelChild AS tmpRMC) AS tmpGoods
             LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                  ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpGoods.GoodsId  ---ObjectLink_ReceiptGoods_Object.ObjectId = Object_ReceiptGoods.Id
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
   
             LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_Object
                                  ON ObjectLink_ReceiptGoodsChild_Object.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                 AND ObjectLink_ReceiptGoodsChild_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (ObjectLink_ReceiptGoodsChild_Object.ChildObjectId,tmpGoods.GoodsId)

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
        WHERE COALESCE (ObjectBoolean_Main.ValueData, FALSE)  = TRUE OR ObjectLink_ReceiptGoods_Object.ObjectId IS NULL
        GROUP BY tmpGoods.GoodsId
               , Object_Goods.Id
               , Object_Goods.ObjectCode
               , Object_Goods.ValueData  
               , ObjectString_GoodsGroupFull.ValueData
               , Object_GoodsGroup.ValueData
               , ObjectString_Article.ValueData
               , Object_ProdColor.ValueData
               , Object_Measure.ValueData

               , ObjectFloat_EKPrice.ValueData
               , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                      * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))
               , CASE WHEN vbPriceWithVAT = FALSE
                      THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                      ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                 END
               , CASE WHEN vbPriceWithVAT = FALSE
                      THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                      ELSE COALESCE (tmpPriceBasis.ValuePrice, 0) 
                 END
        );

     CREATE TEMP TABLE tmpChild ON COMMIT DROP AS
       (SELECT tmpReceiptGoodsChild.GoodsId_parent
             , SUM (tmpReceiptGoodsChild.Value)                      AS Value
             , SUM (tmpReceiptGoodsChild.EKPrice_summ)     :: TFloat AS EKPrice_summ
             , SUM (tmpReceiptGoodsChild.EKPriceWVAT_summ) :: TFloat AS EKPriceWVAT_summ
             , SUM (tmpReceiptGoodsChild.Basis_summ)       :: TFloat AS Basis_summ
             , SUM (tmpReceiptGoodsChild.BasisWVAT_summ)   :: TFloat AS BasisWVAT_summ

        FROM tmpReceiptGoodsChild
        GROUP BY tmpReceiptGoodsChild.GoodsId_parent
        );

     -- Результат
     OPEN Cursor1 FOR

     SELECT 
           Object_ReceiptProdModelChild.Id              AS Id 
         , ROW_NUMBER() OVER (PARTITION BY Object_ReceiptProdModel.Id ORDER BY Object_ReceiptProdModelChild.Id ASC) :: Integer AS NPP
         , Object_ReceiptProdModelChild.ValueData       AS Comment

         , ObjectFloat_Value.ValueData       ::TFloat   AS Value

         , Object_ReceiptProdModel.Id        ::Integer  AS ReceiptProdModelId
         , Object_ReceiptProdModel.ValueData ::TVarChar AS ReceiptProdModelName

         , Object_ReceiptLevel.Id            ::Integer  AS ReceiptLevelId
         , Object_ReceiptLevel.ValueData     ::TVarChar AS ReceiptLevelName

         , Object_Object.Id                  ::Integer  AS ObjectId
         , Object_Object.ObjectCode          ::Integer  AS ObjectCode
         , Object_Object.ValueData           ::TVarChar AS ObjectName

         , Object_Insert.ValueData                      AS InsertName
         , Object_Update.ValueData                      AS UpdateName
         , ObjectDate_Insert.ValueData                  AS InsertDate
         , ObjectDate_Update.ValueData                  AS UpdateDate
         , Object_ReceiptProdModelChild.isErased        AS isErased
         
         --
         , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Article.ValueData             AS Article
         , Object_ProdColor.ValueData                 AS ProdColorName
         , Object_Measure.ValueData                   AS MeasureName
          
         , tmpChild.EKPrice_summ      ::TFloat AS EKPrice
         , tmpChild.EKPriceWVAT_summ  ::TFloat AS EKPriceWVAT
         , tmpChild.Basis_summ        ::TFloat AS BasisPrice
         , tmpChild.BasisWVAT_summ    ::TFloat AS BasisPriceWVAT
          
        , (ObjectFloat_Value.ValueData * tmpChild.EKPrice_summ) :: TFloat AS EKPrice_summ

        , (ObjectFloat_Value.ValueData * tmpChild.EKPriceWVAT_summ) :: TFloat AS EKPriceWVAT_summ

        , (ObjectFloat_Value.ValueData * tmpChild.Basis_summ)  :: TFloat AS Basis_summ

        , (ObjectFloat_Value.ValueData * tmpChild.BasisWVAT_summ) ::TFloat BasisWVAT_summ
             
     FROM tmpReceiptProdModelChild AS Object_ReceiptProdModelChild

          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value() 

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                               ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
          LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = ObjectLink_ReceiptProdModel.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                               ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptProdModelChild.Id
                              AND ObjectLink_ReceiptLevel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
          LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptLevel.ChildObjectId 

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

          -- подтягиваем данные из ReceiptGoods, если они есть, если нет то по комплектующему изначальному
          LEFT JOIN tmpChild ON tmpChild.GoodsId_parent = Object_ReceiptProdModelChild.GoodsId
          
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = Object_ReceiptProdModelChild.GoodsId

          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Object.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Object.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

     WHERE Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
      AND (Object_ReceiptProdModelChild.isErased = FALSE OR inIsErased = TRUE)
      --AND Object_Object.DescId = zc_Object_Goods()
     ;
      RETURN NEXT Cursor1;


     -- Результат
     OPEN Cursor2 FOR
     SELECT *
     FROM tmpReceiptGoodsChild;
     RETURN NEXT Cursor2;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.12.20         * add ReceiptLevel
 09.12.20         *
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptProdModelChild_Goods (false, zfCalc_UserAdmin())
