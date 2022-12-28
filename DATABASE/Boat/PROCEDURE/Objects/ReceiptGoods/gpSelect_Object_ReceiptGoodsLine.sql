-- Function: gpSelect_Object_ReceiptGoodsLine()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoodsLine (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoodsLine(
    IN inIsErased    Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , isMain Boolean
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             --, MaterialOptionsName TVarChar, ProdColorName_pcp TVarChar
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
             
               -- Цена продажи без НДС
             , BasisPrice TFloat
               -- Цена продажи с НДС, до 2-х знаков
             , BasisPriceWVAT TFloat 
             
             ---
             , ReceiptGoodsChildId Integer
             , NPP            Integer
             , Comment_child  TVarChar, Comment_goods_child TVarChar
             , Value NUMERIC (16, 8), Value_Service NUMERIC (16, 8)
             , ForCount             TFloat
             , ProdColorGroupId     Integer
             , ProdColorGroupName   TVarChar
             , ProdColorPatternId   Integer
             , ProdColorPatternName TVarChar
             , MaterialOptionsId    Integer
             , MaterialOptionsName  TVarChar 
             , ReceiptLevelId       Integer 
             , ReceiptLevelName     TVarChar
             , GoodsChildId         Integer 
             , GoodsChildName       TVarChar
             , ObjectId          Integer
             , ObjectCode        Integer
             , ObjectName        TVarChar
             , DescName          TVarChar
             , InsertName_child    TVarChar
             , UpdateName_child    TVarChar
             , InsertDate_child    TDateTime
             , UpdateDate_child    TDateTime
             , isErased_child      Boolean
             , GoodsGroupNameFull_child TVarChar
             , GoodsGroupName_child     TVarChar
             , Article_child            TVarChar, Article_All_child TVarChar
             , ProdColorName_child      TVarChar
             , MeasureName_child        TVarChar
             , EKPrice            TFloat
             , EKPriceWVAT        TFloat
             , EKPrice_summ       TFloat
             , EKPriceWVAT_summ   TFloat
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
      /*  , tmpReceiptGoodsChild_ProdColorPattern AS (SELECT gpSelect.ReceiptGoodsId
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
        */ -- продублировали GoodsChild
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
                             

         -- ВСЕ Элементы сборки Узлов
        , tmpReceiptGoodsChild AS (SELECT
                                          Object_ReceiptGoodsChild.Id              AS Id
                                        , ROW_NUMBER() OVER (PARTITION BY Object_ReceiptGoods.Id ORDER BY CASE WHEN ObjectLink_ProdColorPattern.ChildObjectId IS NULL THEN 0 ELSE 1 END ASC
                                                                                                        , Object_ReceiptGoodsChild.Id ASC) :: Integer AS NPP
                                        , Object_ReceiptGoodsChild.ValueData       AS Comment
                                        , ObjectString_Goods_Comment.ValueData              AS Comment_goods     
                                        
                                        , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value
                                        , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value_Service
                                        , ObjectFloat_ForCount.ValueData :: TFloat AS ForCount
                                        
                                        , Object_ReceiptGoods.Id        ::Integer  AS ReceiptGoodsId
                                        , Object_ReceiptGoods.ValueData ::TVarChar AS ReceiptGoodsName
                               
                                        , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
                                        , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName
                               
                                        , Object_ProdColorPattern.Id         ::Integer  AS ProdColorPatternId
                                        , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData, Object_ProdColorPattern.ValueData, Object_Model_pcp.ValueData, Object_ProdColorPattern.isErased) :: TVarChar AS ProdColorPatternName
                               
                                        , Object_MaterialOptions.Id          ::Integer  AS MaterialOptionsId
                                        , Object_MaterialOptions.ValueData   ::TVarChar AS MaterialOptionsName
                                        , Object_ReceiptLevel.Id                        AS ReceiptLevelId
                                        , Object_ReceiptLevel.ValueData      ::TVarChar AS ReceiptLevelName
                                        , Object_GoodsChild.Id                          AS GoodsChildId
                                        , Object_GoodsChild.ValueData        ::TVarChar AS GoodsChildName
                               
                                        , Object_Object.Id               ::Integer  AS ObjectId
                                        , Object_Object.ObjectCode       ::Integer  AS ObjectCode
                                        , Object_Object.ValueData        ::TVarChar AS ObjectName
                                        , ObjectDesc.ItemName            ::TVarChar AS DescName
                               
                                        , Object_Insert.ValueData                  AS InsertName
                                        , Object_Update.ValueData                  AS UpdateName
                                        , ObjectDate_Insert.ValueData              AS InsertDate
                                        , ObjectDate_Update.ValueData              AS UpdateDate
                                        , Object_ReceiptGoodsChild.isErased        AS isErased
                               
                                        , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
                                        , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
                                        , ObjectString_Article.ValueData        ::TVarChar  AS Article
                                        , zfCalc_Article_all (ObjectString_Article.ValueData) ::TVarChar AS Article_all
                                        , Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
                                        , Object_Measure.ValueData              ::TVarChar  AS MeasureName
                               
                                          -- Цена вх. без НДС - Товар/Услуги
                                        , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
                                          -- расчет Цена вх. с НДС, до 2-х знаков - Товар/Услуги
                                        , zfCalc_SummWVAT (COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData), vbTaxKindValue_basis) AS EKPriceWVAT
                               
                                          -- Сумма вх. без НДС, до 2-х знаков - Товар/Услуги
                                        , zfCalc_SummIn (ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END
                                                       , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData)
                                                       , 1) AS EKPrice_summ
                                          -- Сумма вх. с НДС, до 2-х знаков - Товар/Услуги
                                        , zfCalc_SummWVAT (zfCalc_SummIn (ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END
                                                                        , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData)
                                                                        , 1)
                                                          , vbTaxKindValue_basis) AS EKPriceWVAT_summ
                               
                                    FROM Object AS Object_ReceiptGoodsChild
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_Object
                                                              ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
                                         LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                               
                                         -- значение в сборке
                                         LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                               ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                              AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                         LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                                               ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                                                              AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptGoodsChild_ForCount()
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                              ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                         LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                              ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                                             AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                         LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ColorPattern
                                                              ON ObjectLink_ProdColorPattern_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                                             AND ObjectLink_ProdColorPattern_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                                              ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ProdColorPattern_ColorPattern.ChildObjectId
                                                             AND ObjectLink_ColorPattern_Model.DescId = zc_ObjectLink_ColorPattern_Model()
                                         LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_ColorPattern_Model.ChildObjectId
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                              ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                                         LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                              ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                                         LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptLevel.ChildObjectId
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                              ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                         LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = ObjectLink_GoodsChild.ChildObjectId
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                              ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                         LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_Insert
                                                              ON ObjectLink_Insert.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                                         LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_Update
                                                              ON ObjectLink_Update.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
                                         LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId
                               
                                         LEFT JOIN ObjectDate AS ObjectDate_Insert
                                                              ON ObjectDate_Insert.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
                               
                                         LEFT JOIN ObjectDate AS ObjectDate_Update
                                                              ON ObjectDate_Update.ObjectId = Object_ReceiptGoodsChild.Id
                                                             AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()
                               
                                         --
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

                                         LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                                                ON ObjectString_Goods_Comment.ObjectId = Object_Object.Id
                                                               AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()

                                         -- Цена вх. без НДС - Товар
                                         LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                               ON ObjectFloat_EKPrice.ObjectId = Object_Object.Id
                                                              AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                                         -- Цена вх. без НДС - Услуги
                                         LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                                               ON ObjectFloat_ReceiptService_EKPrice.ObjectId = Object_Object.Id
                                                              AND ObjectFloat_ReceiptService_EKPrice.DescId   = zc_ObjectFloat_ReceiptService_EKPrice()
                               
                                         LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                                               ON ObjectFloat_EmpfPrice.ObjectId = Object_Object.Id
                                                              AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()
                               
                                         LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                              ON ObjectLink_Goods_TaxKind.ObjectId = Object_Object.Id
                                                             AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                                         LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId
                               
                                         LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                               ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                                              AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                               
                                    WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                     AND (Object_ReceiptGoodsChild.isErased = FALSE OR inIsErased = TRUE)
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

         , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

         --, tmpMaterialOptions.MaterialOptionsName :: TVarChar AS MaterialOptionsName
         --, COALESCE (tmpProdColorPattern.ProdColorName, tmpProdColorPattern_next.ProdColorName, tmpProdColorPattern_next_all.ProdColorName) :: TVarChar AS ProdColorName_pcp

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

           -- Цена продажи без ндс
         , COALESCE (tmpPriceBasis.ValuePrice, 0)     ::TFloat AS BasisPrice
           -- Цена продажи с ндс
         , COALESCE (tmpPriceBasis.ValuePriceWVAT, 0) ::TFloat AS BasisPriceWVAT

         ---ReceiptGoodsChild
         
         , tmpReceiptGoodsChild.Id AS ReceiptGoodsChildId
         , tmpReceiptGoodsChild.NPP
         , tmpReceiptGoodsChild.Comment     AS Comment_child
         , tmpReceiptGoodsChild.Comment_goods AS Comment_goods_child

         , tmpReceiptGoodsChild.Value         :: NUMERIC (16, 8) AS Value
         , tmpReceiptGoodsChild.Value_Service :: NUMERIC (16, 8) AS Value_Service
         , tmpReceiptGoodsChild.ForCount ::TFloat

         , tmpReceiptGoodsChild.ProdColorGroupId
         , tmpReceiptGoodsChild.ProdColorGroupName

         , tmpReceiptGoodsChild.ProdColorPatternId
         , tmpReceiptGoodsChild.ProdColorPatternName

         , tmpReceiptGoodsChild.MaterialOptionsId
         , tmpReceiptGoodsChild.MaterialOptionsName

         , tmpReceiptGoodsChild.ReceiptLevelId
         , tmpReceiptGoodsChild.ReceiptLevelName
         , tmpReceiptGoodsChild.GoodsChildId
         , tmpReceiptGoodsChild.GoodsChildName

         , tmpReceiptGoodsChild.ObjectId
         , tmpReceiptGoodsChild.ObjectCode
         , tmpReceiptGoodsChild.ObjectName
         , tmpReceiptGoodsChild.DescName

         , tmpReceiptGoodsChild.InsertName             AS InsertName_child
         , tmpReceiptGoodsChild.UpdateName             AS UpdateName_child
         , tmpReceiptGoodsChild.InsertDate             AS InsertDate_child
         , tmpReceiptGoodsChild.UpdateDate             AS UpdateDate_child
         , tmpReceiptGoodsChild.isErased               AS isErased_child

         , tmpReceiptGoodsChild.GoodsGroupNameFull ::TVarChar  AS GoodsGroupNameFull_child
         , tmpReceiptGoodsChild.GoodsGroupName     ::TVarChar  AS GoodsGroupName_child
         , tmpReceiptGoodsChild.Article            ::TVarChar  AS Article_child
         , tmpReceiptGoodsChild.Article_all        ::TVarChar  AS Article_All_child
         , tmpReceiptGoodsChild.ProdColorName      ::TVarChar  AS ProdColorName_child
         , tmpReceiptGoodsChild.MeasureName        ::TVarChar  AS MeasureName_child

         , tmpReceiptGoodsChild.EKPrice            ::TFloat
         , tmpReceiptGoodsChild.EKPriceWVAT        ::TFloat
         , tmpReceiptGoodsChild.EKPrice_summ       ::TFloat
         , tmpReceiptGoodsChild.EKPriceWVAT_summ   ::TFloat
       

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
          
          --  tmpReceiptGoodsChild
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
 28.12.22         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptGoodsLine (false, zfCalc_UserAdmin())
