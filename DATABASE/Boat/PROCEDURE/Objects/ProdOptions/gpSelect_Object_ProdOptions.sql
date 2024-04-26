-- Function: gpSelect_Object_ProdOptions()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptions(Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptions(Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptions(Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptions(Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptions(
    IN inModelId           Integer,
    IN inPriceListId       Integer,
    IN inLanguageId1       Integer,
    IN inLanguageId2       Integer,
    IN inLanguageId3       Integer,
    IN inLanguageId4       Integer,
    IN inIsErased          Boolean,
    IN inSession           TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ModelId Integer, ModelCode Integer, ModelName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ProdEngineId Integer, ProdEngineName TVarChar
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , GoodsId Integer, GoodsId_choice Integer, GoodsCode Integer, GoodsName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar, TaxKind_Value TFloat
             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             , SalePrice TFloat, SalePriceWVAT TFloat
             , SalePrice_pr TFloat, StartDate_pr TDateTime
             , Amount TFloat
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , MaterialOptionsId Integer, MaterialOptionsName TVarChar
             , Id_Site TVarChar
             , CodeVergl Integer
             , NPP Integer, NPP_pcp Integer 
             , Value1 TVarChar
             , Value2 TVarChar
             , Value3 TVarChar
             , Value4 TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptions());
     vbUserId:= lpGetUserBySession (inSession);

     -- ����������
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = inPriceListId AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     RETURN QUERY
     WITH tmpPriceBasis AS (SELECT tmp.GoodsId
                                 , tmp.ValuePrice
                                 , tmp.StartDate
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId --zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS tmp
                           )
          -- �����, ������� ���������� ��� Boat Structure
        , tmpProdColorPattern AS (SELECT Object_ProdColorPattern.Id                    AS ProdColorPatternId
                                     /*, Object_ColorPattern.Id                        AS ColorPatternId
                                       , Object_ColorPattern.ValueData                 AS ColorPatternName

                                       , Object_Model.Id                    ::Integer  AS ModelId
                                       , Object_Model.ValueData             ::TVarChar AS ModelName*/

                                       , Object_Goods.Id                    ::Integer  AS GoodsId
                                       , Object_Goods.ObjectCode            ::Integer  AS GoodsCode
                                       , Object_Goods.ValueData             ::TVarChar AS GoodsName

                                       , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
                                       , Object_GoodsGroup.ValueData                AS GoodsGroupName
                                       , ObjectString_Article.ValueData             AS Article
                                       , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL THEN ObjectString_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
                                       , Object_Measure.ValueData                   AS MeasureName

                                       , Object_TaxKind.Id                   AS TaxKindId
                                       , Object_TaxKind.ValueData            AS TaxKindName
                                       , ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value

                                         -- ���� ��. ��� ���
                                       , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
                                        -- ���� ��. � ���
                                      , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                            * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT -- ������ ������� ���� � ���, �� 4 ������

                                        -- ���� ������� ��� ���
                                      , CASE WHEN vbPriceWithVAT = FALSE
                                             THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                             ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                        END ::TFloat  AS BasisPrice
                                        -- ���� ������� � ���
                                      , CASE WHEN vbPriceWithVAT = FALSE
                                             THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                             ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                                        END ::TFloat  AS BasisPriceWVAT 
                                        
                                  FROM -- ������� Boat Structure �� ������
                                       Object AS Object_ProdColorPattern
                                       LEFT JOIN ObjectString AS ObjectString_Comment
                                                              ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                                             AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()
                                       -- ������
                                     /*LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                                            ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                                           AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
                                       LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId
                                       LEFT JOIN ObjectLink AS ObjectLink_Model
                                                            ON ObjectLink_Model.ObjectId = ObjectLink_ColorPattern.ChildObjectId
                                                           AND ObjectLink_Model.DescId   = zc_ObjectLink_ColorPattern_Model()
                                       LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId*/
                                       -- �������������
                                       LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                            ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                                                           AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
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
                                       LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

                                       LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                             ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                            AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                                       LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

                                  WHERE Object_ProdColorPattern.DescId   = zc_Object_ProdColorPattern()
                                    AND Object_ProdColorPattern.isErased = FALSE
                                 )      

       , tmpRes AS (SELECT
                          Object_ProdOptions.Id           AS Id
                        , Object_ProdOptions.ObjectCode   AS Code
                        , Object_ProdOptions.ValueData    AS Name
               
                        , Object_Model.Id         ::Integer  AS ModelId
                        , Object_Model.ObjectCode ::Integer  AS ModelCode
                        , Object_Model.ValueData  ::TVarChar AS ModelName
                        , Object_Brand.Id                    AS BrandId
                        , Object_Brand.ValueData             AS BrandName
                        , Object_ProdEngine.Id               AS ProdEngineId
                        , Object_ProdEngine.ValueData        AS ProdEngineName

                          -- Boat Structure               
                        , Object_ProdColorPattern.Id          AS ProdColorPatternId
                        , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData
                                                          , Object_ProdColorPattern.ValueData
                                                          , Object_Model_pcp.ValueData
                                                          , Object_ProdColorPattern.isErased
                                                           ) AS ProdColorPatternName
                        , Object_ColorPattern.Id              AS ColorPatternId
                        , Object_ColorPattern.ValueData       AS ColorPatternName
               
                        , Object_Goods.Id         :: Integer  AS GoodsId
                        , Object_Goods.ObjectCode :: Integer  AS GoodsCode
                        , Object_Goods.ValueData  :: TVarChar AS GoodsName
               
                        , Object_TaxKind.Id                   AS TaxKindId
                        , Object_TaxKind.ValueData            AS TaxKindName
                        , ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value
               
                          -- ���� ��. ��� ��� - ������ �� ������
                        , ObjectFloat_EKPrice.ValueData       AS EKPrice
                          -- ���� ��. � ���
                        , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                             * (1 + (COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData, 0) / 100)) AS NUMERIC (16, 2)) :: TFloat AS EKPriceWVAT
               
                          -- ���� ������� ��� ��� (Artikel)
                        , CASE WHEN vbPriceWithVAT = FALSE
                               THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                               ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                          END :: TFloat AS BasisPrice
               
                          -- ���� ������� � ���
                        , CASE WHEN vbPriceWithVAT = FALSE
                               THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                               ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                          END :: TFloat  AS BasisPriceWVAT
               
                          -- ���� ������� ��� ��� - ���� ����� ������ �� ����� ���� ������, ����� ��� Boat Structure ����� ����� SalePrice
                        , CASE WHEN ObjectLink_Goods.ChildObjectId > 0 AND Object_ProdColorPattern.Id IS NULL AND 1=0
                                    THEN CASE WHEN vbPriceWithVAT = FALSE
                                              THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                              ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                         END
                               ELSE -- ����� - ���� ������� ��� ���
                                    ObjectFloat_SalePrice.ValueData
               
                          END :: TFloat AS SalePrice
               
                          -- ���� ������� � ��� - ���� ����� ������ �� ����� ���� ������, ����� ��� Boat Structure ����� ����� SalePrice
                        , CASE WHEN ObjectLink_Goods.ChildObjectId > 0 AND Object_ProdColorPattern.Id IS NULL AND 1=0
                                    THEN CASE WHEN vbPriceWithVAT = FALSE
                                              THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                              ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                                         END
                               ELSE -- ����� - ���� ������� � ���
                                    CAST (COALESCE (ObjectFloat_SalePrice.ValueData, 0)
                                       * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))
                          END :: TFloat AS SalePriceWVAT 
                        , ObjectFloat_Amount.ValueData    AS Amount
               
                        , ObjectString_Comment.ValueData  AS Comment
               
                        , Object_Insert.ValueData         AS InsertName
                        , ObjectDate_Insert.ValueData     AS InsertDate
                        , Object_ProdOptions.isErased     AS isErased
               
                        , ObjectString_GoodsGroupFull.ValueData  AS GoodsGroupNameFull
                        , Object_GoodsGroup.ValueData            AS GoodsGroupName
                        , ObjectString_Article.ValueData         AS Article
                        , Object_ProdColor.ValueData             AS ProdColorName
                        , Object_Measure.ValueData               AS MeasureName
               
                        , Object_MaterialOptions.Id                   AS MaterialOptionsId
                        , Object_MaterialOptions.ValueData            AS MaterialOptionsName
                        , ObjectString_Id_Site.ValueData              AS Id_Site
                        , ObjectFloat_ProdOptions_CodeVergl.ValueData AS CodeVergl
                        
                        , ROW_NUMBER() OVER (PARTITION BY Object_Model.Id
                                             ORDER BY CASE WHEN Object_ProdColorPattern.Id > 0 THEN 0 ELSE 1 END ASC
                                                    , COALESCE (Object_ProdColorPattern.ObjectCode, 0) ASC
                                                    , COALESCE (ObjectFloat_ProdOptions_CodeVergl.ValueData, 0) ASC
                                                    , ObjectString_Id_Site.ValueData ASC
                                                    , Object_ProdOptions.ValueData   ASC
                                                    , Object_ProdOptions.ObjectCode  ASC
                                            ) :: Integer AS NPP
               
                        , ROW_NUMBER() OVER (PARTITION BY Object_Model.Id, Object_ProdColorPattern.Id
                                             ORDER BY CASE WHEN Object_MaterialOptions.ValueData ILIKE 'LISSE/MATT' THEN 0 ELSE 1 END
                                                    , Object_ProdOptions.ObjectCode ASC
                                            ) :: Integer AS NPP_pcp
               
                    FROM Object AS Object_ProdOptions
                         LEFT JOIN ObjectString AS ObjectString_Comment
                         
                                                ON ObjectString_Comment.ObjectId = Object_ProdOptions.Id
                                               AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptions_Comment()
               
                         -- ���� ������� �����
                         LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                               ON ObjectFloat_SalePrice.ObjectId = Object_ProdOptions.Id
                                              AND ObjectFloat_SalePrice.DescId = zc_ObjectFloat_ProdOptions_SalePrice() 
                         -- ���-�� (�������������)
                         LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                               ON ObjectFloat_Amount.ObjectId = Object_ProdOptions.Id
                                              AND ObjectFloat_Amount.DescId = zc_ObjectFloat_ProdOptions_Amount()
                         LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                              ON ObjectLink_TaxKind.ObjectId = Object_ProdOptions.Id
                                             AND ObjectLink_TaxKind.DescId = zc_ObjectLink_ProdOptions_TaxKind()
                         LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_TaxKind.ChildObjectId
               
                         LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                               ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                              AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
               
                         -- ��������� �����
                         LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                              ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                             AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
                         LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId
               
                         LEFT JOIN ObjectString AS ObjectString_Id_Site
                                                ON ObjectString_Id_Site.ObjectId = Object_ProdOptions.Id
                                               AND ObjectString_Id_Site.DescId = zc_ObjectString_Id_Site()
                         LEFT JOIN ObjectFloat AS ObjectFloat_ProdOptions_CodeVergl
                                               ON ObjectFloat_ProdOptions_CodeVergl.ObjectId = Object_ProdOptions.Id
                                              AND ObjectFloat_ProdOptions_CodeVergl.DescId = zc_ObjectFloat_ProdOptions_CodeVergl()
               
                         -- ������
                         LEFT JOIN ObjectLink AS ObjectLink_Model
                                              ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                                             AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
                         LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
               
                         LEFT JOIN ObjectLink AS ObjectLink_Brand
                                              ON ObjectLink_Brand.ObjectId = Object_Model.Id
                                             AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
                         LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId
               
                         LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                                              ON ObjectLink_ProdEngine.ObjectId = Object_Model.Id
                                             AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
                         LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId
               
                         -- Boat Structure
                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                              ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdOptions.Id
                                             AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ProdOptions_ProdColorPattern()
                         LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId
               
                         LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                              ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                                             AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                         LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                                              ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                             AND ObjectLink_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
                         LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId
                         LEFT JOIN ObjectLink AS ObjectLink_Model_pcp
                                              ON ObjectLink_Model_pcp.ObjectId = ObjectLink_ColorPattern.ChildObjectId
                                             AND ObjectLink_Model_pcp.DescId   = zc_ObjectLink_ColorPattern_Model()
                         LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_Model_pcp.ChildObjectId

                         -- �������������
                         LEFT JOIN ObjectLink AS ObjectLink_Goods
                                              ON ObjectLink_Goods.ObjectId = Object_ProdOptions.Id
                                             AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdOptions_Goods()
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
               
                         LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_goods
                                               ON ObjectFloat_TaxKind_Value_goods.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                              AND ObjectFloat_TaxKind_Value_goods.DescId = zc_ObjectFloat_TaxKind_Value()
               
                         LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id
               
                         --
                         LEFT JOIN ObjectLink AS ObjectLink_Insert
                                              ON ObjectLink_Insert.ObjectId = Object_ProdOptions.Id
                                             AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                         LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId
               
                         LEFT JOIN ObjectDate AS ObjectDate_Insert
                                              ON ObjectDate_Insert.ObjectId = Object_ProdOptions.Id
                                             AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
               
                    WHERE Object_ProdOptions.DescId = zc_Object_ProdOptions()
                     AND (ObjectLink_Model.ChildObjectId = inModelId OR inModelId = 0 OR COALESCE (ObjectLink_Model.ChildObjectId,0) = 0)
                     AND (Object_ProdOptions.isErased = FALSE OR inIsErased = TRUE)
                   )

       , tmpTranslateObject AS (SELECT Object_TranslateObject.Id          AS Id 
                                     , Object_TranslateObject.ObjectCode  AS Code
                                     , Object_TranslateObject.ValueData   AS Name
                                     , ObjectLink_Language.ChildObjectId  AS LanguageId
                                     , ObjectLink_Object.ChildObjectId    AS ProdOptionsId
                                FROM Object AS Object_TranslateObject
                                   INNER JOIN ObjectLink AS ObjectLink_Language
                                                         ON ObjectLink_Language.ObjectId = Object_TranslateObject.Id
                                                        AND ObjectLink_Language.DescId = zc_ObjectLink_TranslateObject_Language()
                                   INNER JOIN ObjectLink AS ObjectLink_Object
                                                         ON ObjectLink_Object.ObjectId = Object_TranslateObject.Id
                                                        AND ObjectLink_Object.DescId = zc_ObjectLink_TranslateObject_Object()
                                   INNER JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId AND Object_Object.DescId = zc_Object_ProdOptions()

                                WHERE Object_TranslateObject.DescId = zc_Object_TranslateObject()
                                  AND Object_TranslateObject.isErased = FALSE
                                )

     -- ���������
     SELECT
           tmpRes.Id
         , tmpRes.Code
         , tmpRes.Name

         , tmpRes.ModelId
         , tmpRes.ModelCode
         , tmpRes.ModelName
         , tmpRes.BrandId
         , tmpRes.BrandName
         , tmpRes.ProdEngineId
         , tmpRes.ProdEngineName

         
           -- Boat Structure               
         , tmpRes.ProdColorPatternId
         , tmpRes.ProdColorPatternName
         , tmpRes.ColorPatternId
         , tmpRes.ColorPatternName

         , CASE WHEN tmpRes.NPP_pcp = 1 THEN tmpRes.GoodsId ELSE tmpRes.GoodsId END                                                      :: Integer  AS GoodsId
         , COALESCE (tmpRes.GoodsId,   CASE WHEN tmpRes.NPP_pcp = 1 THEN tmpProdColorPattern.GoodsId ELSE NULL END, tmpRes.GoodsId)      :: Integer  AS GoodsId_choice
         , COALESCE (tmpRes.GoodsCode, CASE WHEN tmpRes.NPP_pcp = 1 THEN tmpProdColorPattern.GoodsCode ELSE NULL END, tmpRes.GoodsCode)  :: Integer  AS GoodsCode
         , COALESCE (tmpRes.GoodsName, CASE WHEN tmpRes.NPP_pcp = 1 THEN tmpProdColorPattern.GoodsName ELSE NULL END, tmpRes.GoodsName)  :: TVarChar AS GoodsName

         , tmpRes.TaxKindId :: INteger
         , COALESCE (tmpRes.TaxKindName,   tmpProdColorPattern.TaxKindName, tmpRes.TaxKindName)        :: TVarChar AS TaxKindName
         , COALESCE (tmpRes.TaxKind_Value, tmpProdColorPattern.TaxKind_Value, tmpRes.TaxKind_Value)    :: TFloat   AS TaxKind_Value

           -- ���� ��. ��� ��� - ������ �� ������
         , COALESCE (tmpRes.EKPrice, tmpProdColorPattern.EKPrice, tmpRes.EKPrice) :: TFloat AS EKPrice
           -- ���� ��. � ���
         , COALESCE (tmpRes.EKPriceWVAT, tmpProdColorPattern.EKPriceWVAT, tmpRes.EKPriceWVAT) :: TFloat AS EKPriceWVAT

           -- ���� ������� ��� ��� (Artikel)
         , COALESCE (tmpRes.BasisPrice, tmpProdColorPattern.BasisPrice, tmpRes.BasisPrice) :: TFloat AS BasisPrice

           -- ���� ������� � ���
         , COALESCE (tmpRes.BasisPriceWVAT, tmpProdColorPattern.BasisPriceWVAT, tmpRes.BasisPriceWVAT) :: TFloat  AS BasisPriceWVAT

           -- ���� ������� ��� ��� - ���� ����� ������ �� ����� ���� ������, ����� ��� Boat Structure ����� ����� SalePrice
         , tmpRes.SalePrice :: TFloat

           -- ���� ������� � ��� - ���� ����� ������ �� ����� ���� ������, ����� ��� Boat Structure ����� ����� SalePrice
         , tmpRes.SalePriceWVAT :: TFloat 
         
         --���� ����� �� ������ 
         , COALESCE (tmpPriceBasis.ValuePrice, 0)   ::TFloat    AS SalePrice_pr
         --���� � �� ������
         , COALESCE (tmpPriceBasis.StartDate, Null) ::TDateTime AS StartDate_pr
         
         , tmpRes.Amount ::TFloat

         , tmpRes.Comment

         , tmpRes.InsertName
         , tmpRes.InsertDate
         , tmpRes.isErased

         , COALESCE (tmpRes.GoodsGroupNameFull, CASE WHEN tmpRes.NPP_pcp = 1 THEN tmpProdColorPattern.GoodsGroupNameFull ELSE NULL END, tmpRes.GoodsGroupNameFull) ::TVarChar AS GoodsGroupNameFull
         , COALESCE (tmpRes.GoodsGroupName, CASE WHEN tmpRes.NPP_pcp = 1 THEN tmpProdColorPattern.GoodsGroupName ELSE NULL END, tmpRes.GoodsGroupName)             ::TVarChar AS GoodsGroupName
         , COALESCE (tmpRes.Article, CASE WHEN tmpRes.NPP_pcp = 1 THEN tmpProdColorPattern.Article ELSE NULL END, tmpRes.Article)                                  ::TVarChar AS Article
         , CASE WHEN tmpRes.Comment <> ''
                THEN tmpRes.Comment
                ELSE COALESCE (tmpRes.ProdColorName
                             , CASE WHEN tmpRes.NPP_pcp = 1 OR tmpProdColorPattern.GoodsId IS NULL
                                    THEN tmpProdColorPattern.ProdColorName
                                    ELSE NULL
                               END
                             , tmpRes.ProdColorName
                              )
           END ::TVarChar AS ProdColorName
         , COALESCE (tmpRes.MeasureName, CASE WHEN tmpRes.NPP_pcp = 1 THEN tmpProdColorPattern.MeasureName ELSE NULL END, tmpRes.MeasureName)                     ::TVarChar  AS MeasureName

         , tmpRes.MaterialOptionsId
         , tmpRes.MaterialOptionsName
         , tmpRes.Id_Site
         , tmpRes.CodeVergl :: Integer
         
         , tmpRes.NPP

         , tmpRes.NPP_pcp 
         
         , tmpTranslate1.Name ::TVarChar AS Value1
         , tmpTranslate2.Name ::TVarChar AS Value2
         , tmpTranslate3.Name ::TVarChar AS Value3
         , tmpTranslate4.Name ::TVarChar AS Value4

     FROM tmpRes
          -- Boat Structure
          LEFT JOIN tmpProdColorPattern ON tmpProdColorPattern.ProdColorPatternId = tmpRes.ProdColorPatternId 
         
          LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpRes.Id --���� �� ������ ��� �����
          
          LEFT JOIN tmpTranslateObject AS tmpTranslate1 ON tmpTranslate1.ProdOptionsId = tmpRes.Id AND tmpTranslate1.LanguageId = inLanguageId1
          LEFT JOIN tmpTranslateObject AS tmpTranslate2 ON tmpTranslate2.ProdOptionsId = tmpRes.Id AND tmpTranslate2.LanguageId = inLanguageId2
          LEFT JOIN tmpTranslateObject AS tmpTranslate3 ON tmpTranslate3.ProdOptionsId = tmpRes.Id AND tmpTranslate3.LanguageId = inLanguageId3
          LEFT JOIN tmpTranslateObject AS tmpTranslate4 ON tmpTranslate4.ProdOptionsId = tmpRes.Id AND tmpTranslate4.LanguageId = inLanguageId4
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.04.24         * Language
 29.03.24         * inPriceListId
 29.05.23         *
 25.12.20         *
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ProdOptions (0, zc_PriceList_Basis(), False, zfCalc_UserAdmin())
