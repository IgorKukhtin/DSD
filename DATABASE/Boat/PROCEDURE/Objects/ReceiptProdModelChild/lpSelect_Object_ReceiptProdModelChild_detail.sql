-- Function: gpSelect_Object_ReceiptProdModelChild()

-- DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptProdModelChild_detail (Integer);
DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptProdModelChild_detail (Boolean, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Object_ReceiptProdModelChild_detail(
    IN inIsGroup     Boolean,       -- 
    IN inUserId      Integer        -- ������������
)
RETURNS TABLE (ModelId Integer, ModelName TVarChar
               --
             , isMain Boolean
             , ReceiptProdModelId Integer, ReceiptProdModelChildId Integer
               -- ������� ������� ������������
             , ObjectId_parent Integer, ObjectCode_parent Integer, ObjectName_parent TVarChar, ObjectDescId_parent Integer, DescName_parent TVarChar
               -- ��������
             , Value_parent NUMERIC(16, 8), Value_parent_orig TFloat, ForCount_parent TFloat
               -- �� ��� ��������� /���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar, ObjectDescId Integer, DescName TVarChar
               -- ��������
             , Value      NUMERIC(16, 8)
             , Value_orig TFloat
             , ForCount   TFloat
               --
             , ReceiptGoodsId Integer, ReceiptGoodsChildId Integer
               -- Boat Structure
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
               -- ���� /���� Comment �� Boat Structure
             , ProdColorId Integer, ProdColorName TVarChar
               -- ���� ��� Boat Structure � ���� ������� ����� ���� ��� �����
           --, ProdOptionsId Integer, ProdOptionsCode Integer, ProdOptionsName TVarChar

               -- ��������� �����
             , MaterialOptionsId Integer, MaterialOptionsCode Integer, MaterialOptionsName TVarChar
               --
             , ReceiptLevelId Integer, ReceiptLevelCode Integer, ReceiptLevelName TVarChar
             , GoodsId_child Integer, GoodsCode_child Integer, GoodsName_child TVarChar

               --
             , TaxKindId_parent Integer, TaxKindValue_parent TFloat
             , EKPrice_parent TFloat, EKPriceWVAT_parent TFloat
             , BasisPrice_parent TFloat, BasisPriceWVAT_parent TFloat
               --
             , TaxKindId Integer --, TaxKindId_opt Integer
             , TaxKindValue TFloat --, TaxKindValue_opt TFloat
               --
             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat

           --, SalePrice_opt TFloat, SalePriceWVAT_opt TFloat
              )
AS
$BODY$
   DECLARE vbPriceWithVAT_pl Boolean;
   DECLARE vbTaxKindValue_basis TFloat;
BEGIN

     -- ������� � ������� ������
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!������� % ���!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());

     -- ���������
     RETURN QUERY
     WITH
     --������� ����
     tmpPriceBasis AS (SELECT tmp.GoodsId
                            , tmp.ValuePrice
                       FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                , inOperDate   := CURRENT_DATE) AS tmp
                      )
          -- �������� ReceiptProdModelChild
        , tmpReceiptProdModelChild AS(SELECT COALESCE (ObjectBoolean_Main.ValueData, FALSE)  AS isMain
                                           , Object_ReceiptProdModel.Id                      AS ReceiptProdModelId
                                           , Object_ReceiptProdModelChild.Id                 AS ReceiptProdModelChildId
                                             -- ������ ����� � ������� ProdModel
                                           , ObjectLink_Model.ChildObjectId                  AS ModelId
                                             -- ReceiptLevel
                                           , ObjectLink_ReceiptLevel.ChildObjectId           AS ReceiptLevelId
                                             -- ������� ������� ����� ������������
                                           , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                             -- ��������
                                           , ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END AS Value
                                           , ObjectFloat_Value.ValueData    AS Value_orig
                                           , ObjectFloat_ForCount.ValueData AS ForCount

                                      FROM Object AS Object_ReceiptProdModel
                                           -- ������� ������� Yes/no ������ ProdModel
                                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                   ON ObjectBoolean_Main.ObjectId = Object_ReceiptProdModel.Id
                                                                  AND ObjectBoolean_Main.DescId   = zc_ObjectBoolean_ReceiptProdModel_Main()
                                           -- ������ ����� � ������� ProdModel
                                           LEFT JOIN ObjectLink AS ObjectLink_Model
                                                                ON ObjectLink_Model.ObjectId = Object_ReceiptProdModel.Id
                                                               AND ObjectLink_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()
                                           -- �������� ReceiptProdModelChild
                                           INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                                 ON ObjectLink_ReceiptProdModel.ChildObjectId = Object_ReceiptProdModel.Id
                                                                AND ObjectLink_ReceiptProdModel.DescId        = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                           -- ������� �� ������
                                           INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id       = ObjectLink_ReceiptProdModel.ObjectId
                                                                                            AND Object_ReceiptProdModelChild.isErased = FALSE
                                           -- ReceiptLevel
                                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                                ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
                                           -- �� ���� ����������
                                           LEFT JOIN ObjectLink AS ObjectLink_Object
                                                                ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                                           -- �������� � ������
                                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                                 ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                                AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptProdModelChild_Value()
                                           LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                                                 ON ObjectFloat_ForCount.ObjectId = Object_ReceiptProdModelChild.Id
                                                                AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptProdModelChild_ForCount()
                                                                
                                      WHERE Object_ReceiptProdModel.DescId   = zc_Object_ReceiptProdModel()
                                        AND Object_ReceiptProdModel.isErased = FALSE
                                     )
         -- ������������ ReceiptProdModelChild - ��� ������ ModelId
       , tmpReceiptGoodsChild AS (SELECT tmpReceiptProdModelChild.ModelId                  AS ModelId
                                         -- ������� ������� Yes/no ������ ProdModel
                                       , tmpReceiptProdModelChild.isMain                   AS isMain
                                         --
                                       , tmpReceiptProdModelChild.ReceiptProdModelId       AS ReceiptProdModelId
                                       , tmpReceiptProdModelChild.ReceiptProdModelChildId  AS ReceiptProdModelChildId
                                       , tmpReceiptProdModelChild.ObjectId                 AS ObjectId_parent
                                         --
                                       , Object_ReceiptGoods.Id                            AS ReceiptGoodsId
                                       , Object_ReceiptGoodsChild.Id                       AS ReceiptGoodsChildId
                                         -- ������ ���� - � ReceiptGoodsChild
                                       , Object_ReceiptGoodsChild.ValueData                AS Comment
                                         -- ��������� ��� ���� ������ "�������������", �� ��� ��� � Boat Structure
                                       , ObjectLink_Object.ChildObjectId                   AS GoodsId
                                         -- ����� ������� Boat Structure
                                       , COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) AS ProdColorPatternId
                                         -- ��������� �����
                                       , ObjectLink_MaterialOptions.ChildObjectId          AS MaterialOptionsId
                                         -- ReceiptLevel
                                       , ObjectLink_ReceiptLevel.ChildObjectId             AS ReceiptLevelId
                                         -- GoodsChild
                                       , ObjectLink_GoodsChild.ChildObjectId               AS GoodsChildId
                                         -- �������� ProdModelChild
                                       , tmpReceiptProdModelChild.Value                    AS Value_parent
                                       , tmpReceiptProdModelChild.Value_orig               AS Value_parent_orig
                                       , tmpReceiptProdModelChild.ForCount                 AS ForCount_parent
                                       
                                         -- ��������
                                       , tmpReceiptProdModelChild.Value * ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END AS Value
                                       , tmpReceiptProdModelChild.Value * ObjectFloat_Value.ValueData AS Value_orig
                                       , ObjectFloat_ForCount.ValueData AS ForCount

                                  FROM tmpReceiptProdModelChild
                                       -- ����� ��� � ������ �����
                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                             ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpReceiptProdModelChild.ObjectId
                                                            AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                                       -- �� ������
                                       INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_ReceiptGoods_Object.ObjectId
                                                                               AND Object_ReceiptGoods.isErased = FALSE
                                       -- ��� ������� ������ ������ �����
                                       INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                ON ObjectBoolean_Main.ObjectId  = ObjectLink_ReceiptGoods_Object.ObjectId
                                                               AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptGoods_Main()
                                                               AND ObjectBoolean_Main.ValueData = TRUE
                                       -- �� ���� �������
                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                             ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = ObjectLink_ReceiptGoods_Object.ObjectId
                                                            AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                       -- �� ������
                                       INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                                    AND Object_ReceiptGoodsChild.isErased = FALSE
                                       -- ����� ���� ����� ���������
                                       LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                            ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                       -- ��������� ��� ���� ���� "������" - "�������������" � ReceiptGoodsChild, �.�. �� �� ����� ��� � zc_ObjectLink_ProdColorPattern_Goods
                                       LEFT JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                       -- ��������� �����
                                       LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                            ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                                       -- ReceiptLevel
                                       LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                            ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                                       -- GoodsChild
                                       LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                            ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                       -- �������� � ������
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                            AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                       LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                                             ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                                                            AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptGoodsChild_ForCount()
                                 )

                           -- �������� ReceiptProdModelChild
                         , tmpRes AS (SELECT -- ������ ����� � ������� ProdModel
                                             tmpReceiptProdModelChild.ModelId
                                             --
                                           , tmpReceiptProdModelChild.isMain
                                           , tmpReceiptProdModelChild.ReceiptProdModelId
                                           , tmpReceiptProdModelChild.ReceiptProdModelChildId
                                             -- ������� ������� �� ��������������
                                           , tmpReceiptProdModelChild.ObjectId AS ObjectId_parent
                                             -- ������� ReceiptProdModelChild
                                           , tmpReceiptProdModelChild.ObjectId
                                             -- ReceiptLevel
                                           , tmpReceiptProdModelChild.ReceiptLevelId
                                             -- GoodsChild
                                           , 0 AS GoodsChildId
                                             --
                                           , '' AS Comment_Receipt
                                             -- ��������
                                           , tmpReceiptProdModelChild.Value       AS Value_parent
                                           , tmpReceiptProdModelChild.Value_orig  AS Value_parent_orig
                                           , tmpReceiptProdModelChild.ForCount    AS ForCount_parent
                                             --
                                           , tmpReceiptProdModelChild.Value  AS Value
                                           , tmpReceiptGoodsChild.Value_orig AS Value_orig
                                           , tmpReceiptGoodsChild.ForCount   AS ForCount
                                             --
                                           , 0 AS ReceiptGoodsId
                                           , 0 AS ReceiptGoodsChildId
                                           , 0 AS ProdColorPatternId
                                           , 0 AS MaterialOptionsId

                                      FROM tmpReceiptProdModelChild
                                           LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                                      -- ��� �� ��������������
                                      WHERE tmpReceiptGoodsChild.ReceiptProdModelChildId IS NULL

                                     UNION ALL
                                      -- ���� �� ���� ������������
                                      SELECT tmpReceiptGoodsChild.ModelId
                                           , tmpReceiptGoodsChild.isMain
                                           , tmpReceiptGoodsChild.ReceiptProdModelId
                                           , (tmpReceiptGoodsChild.ReceiptProdModelChildId) AS ReceiptProdModelChildId
                                             -- ������� ������� ������������
                                           , (tmpReceiptGoodsChild.ObjectId_parent) AS ObjectId_parent
                                             -- �� ��� ������������
                                           , tmpReceiptGoodsChild.GoodsId AS ObjectId
                                             -- ReceiptLevel
                                           , (tmpReceiptGoodsChild.ReceiptLevelId) AS ReceiptLevelId
                                             -- GoodsChild
                                           , (tmpReceiptGoodsChild.GoodsChildId)   AS GoodsChildId
                                             --
                                           , tmpReceiptGoodsChild.Comment AS Comment_Receipt
                                             -- ��������
                                           , tmpReceiptGoodsChild.Value_parent      AS Value_parent
                                           , tmpReceiptGoodsChild.Value_parent_orig AS Value_parent_orig
                                           , tmpReceiptGoodsChild.ForCount_parent   AS ForCount_parent
                                             -- 
                                           , (tmpReceiptGoodsChild.Value)      AS Value
                                           , (tmpReceiptGoodsChild.Value_orig) AS Value_orig
                                           , (tmpReceiptGoodsChild.ForCount)   AS ForCount

                                             --
                                           , (tmpReceiptGoodsChild.ReceiptGoodsId)      AS ReceiptGoodsId
                                           , (tmpReceiptGoodsChild.ReceiptGoodsChildId) AS ReceiptGoodsChildId
                                           , tmpReceiptGoodsChild.ProdColorPatternId
                                           , tmpReceiptGoodsChild.MaterialOptionsId

                                      -- �� ��� �����������
                                      FROM tmpReceiptGoodsChild
                                      WHERE inIsGroup = FALSE

                                     UNION ALL
                                      -- ���� ���� ������������
                                      SELECT tmpReceiptGoodsChild.ModelId
                                           , tmpReceiptGoodsChild.isMain
                                           , tmpReceiptGoodsChild.ReceiptProdModelId
                                           , MAX (tmpReceiptGoodsChild.ReceiptProdModelChildId) AS ReceiptProdModelChildId
                                             -- ������� ������� ������������
                                           , MAX (tmpReceiptGoodsChild.ObjectId_parent) AS ObjectId_parent
                                             -- �� ��� ������������
                                           , tmpReceiptGoodsChild.GoodsId AS ObjectId
                                             -- ReceiptLevel
                                           , MAX (tmpReceiptGoodsChild.ReceiptLevelId) AS ReceiptLevelId
                                             -- GoodsChild
                                           , MAX (tmpReceiptGoodsChild.GoodsChildId)   AS GoodsChildId
                                             --
                                           , tmpReceiptGoodsChild.Comment AS Comment_Receipt
                                             -- ��������
                                           , tmpReceiptGoodsChild.Value_parent      AS Value_parent
                                           , tmpReceiptGoodsChild.Value_parent_orig AS Value_parent_orig
                                           , tmpReceiptGoodsChild.ForCount_parent   AS ForCount_parent
                                             --
                                           , SUM (tmpReceiptGoodsChild.Value)      AS Value
                                           , SUM (tmpReceiptGoodsChild.Value_orig) AS Value_orig
                                           , MAX (tmpReceiptGoodsChild.ForCount)   AS ForCount
                                             --
                                           , MAX (tmpReceiptGoodsChild.ReceiptGoodsId)      AS ReceiptGoodsId
                                           , MAX (tmpReceiptGoodsChild.ReceiptGoodsChildId) AS ReceiptGoodsChildId
                                           , tmpReceiptGoodsChild.ProdColorPatternId
                                           , tmpReceiptGoodsChild.MaterialOptionsId

                                      -- �� ��� �����������
                                      FROM tmpReceiptGoodsChild
                                      WHERE inIsGroup = TRUE
                                      GROUP BY tmpReceiptGoodsChild.ModelId
                                             , tmpReceiptGoodsChild.isMain
                                             , tmpReceiptGoodsChild.ReceiptProdModelId
                                           --, tmpReceiptGoodsChild.ReceiptProdModelChildId
                                               -- ������� ������� ������������
                                           --, tmpReceiptGoodsChild.ObjectId_parent
                                               -- �� ��� ������������
                                             , tmpReceiptGoodsChild.GoodsId
                                               -- ReceiptLevel
                                           --, tmpReceiptGoodsChild.ReceiptLevelId
                                               -- GoodsChild
                                           --, tmpReceiptGoodsChild.GoodsChildId
                                               --
                                             , tmpReceiptGoodsChild.Comment
                                               -- ��������
                                             , tmpReceiptGoodsChild.Value_parent
                                             , tmpReceiptGoodsChild.Value_parent_orig
                                             , tmpReceiptGoodsChild.ForCount_parent
                                               --
                                             , tmpReceiptGoodsChild.ProdColorPatternId
                                             , tmpReceiptGoodsChild.MaterialOptionsId
                                     )
       --
       SELECT tmpRes.ModelId
            , Object_Model.ValueData AS ModelName
              --
            , tmpRes.isMain
            , tmpRes.ReceiptProdModelId
            , tmpRes.ReceiptProdModelChildId
              -- ������� ReceiptProdModelChild
            , tmpRes.ObjectId_parent, Object_parent.ObjectCode AS ObjectCode_parent, Object_parent.ValueData AS ObjectName_parent, Object_parent.DescId AS ObjectDescId_parent, ObjectDesc_parent.ItemName AS DescName_parent
              -- �������� ReceiptProdModelChild
            , tmpRes.Value_parent      :: NUMERIC(16, 8) AS Value_parent
            , tmpRes.Value_parent_orig :: TFloat         AS Value_parent_orig
            , tmpRes.ForCount_parent   :: TFloat         AS ForCount_parent
              -- ������� ReceiptProdModelChild ��� ��������� �� ReceiptGoodsChild
            , tmpRes.ObjectId, Object.ObjectCode, Object.ValueData AS ObjectName, Object.DescId AS ObjectDescId, ObjectDesc.ItemName AS DescName
              -- ��������
            , COALESCE (tmpRes.Value, 0)      :: NUMERIC(16, 8) AS Value
            , COALESCE (tmpRes.Value_orig, 0) :: TFloat         AS Value_orig
            , COALESCE (tmpRes.ForCount, 0)   :: TFloat         AS ForCount
              --
            , tmpRes.ReceiptGoodsId                  :: Integer AS ReceiptGoodsId
            , tmpRes.ReceiptGoodsChildId             :: Integer AS ReceiptGoodsChildId

            , Object_ProdColorGroup.Id AS ProdColorGroupId, Object_ProdColorGroup.ValueData AS ProdColorGroupName
              -- Boat Structure
            , tmpRes.ProdColorPatternId
            , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData
                                              , Object_ProdColorPattern.ValueData
                                              , Object_Model_pcp.ValueData
                                              , Object_ProdColorPattern.isErased
                                               ) AS ProdColorPatternName

              -- �������� Farbe
            , Object_ProdColor.Id           AS ProdColorId
              -- ���� � Boat Structure ��� ������, ����� �������� Farbe
            , CASE WHEN ObjectLink_ProdColorPattern_Goods.ChildObjectId IS NULL AND tmpRes.ProdColorPatternId > 0 AND tmpRes.Comment_Receipt <> ''
                        -- ������ ���� - � ReceiptGoodsChild
                        THEN tmpRes.Comment_Receipt

                   WHEN ObjectLink_ProdColorPattern_Goods.ChildObjectId IS NULL AND tmpRes.ProdColorPatternId > 0
                        -- � Boat Structure  (����� ��� GoodsId)
                        THEN ObjectString_ProdColorPattern_Comment.ValueData

                   -- ����� ���� � ������
                   ELSE Object_ProdColor.ValueData

              END :: TVarChar AS ProdColorName

          --, Object_ProdOptions.Id         AS ProdOptionsId
          --, Object_ProdOptions.ObjectCode AS ProdOptionsCode
          --, Object_ProdOptions.ValueData  AS ProdOptionsName

            , Object_MaterialOptions.Id         AS MaterialOptionsId
            , Object_MaterialOptions.ObjectCode AS MaterialOptionsCode
            , Object_MaterialOptions.ValueData  AS MaterialOptionsName

            , Object_ReceiptLevel.Id         AS ReceiptLevelId
            , Object_ReceiptLevel.ObjectCode AS ReceiptLevelCode
            , Object_ReceiptLevel.ValueData  AS ReceiptLevelName

            , Object_Goods_child.Id         AS GoodsId_child
            , Object_Goods_child.ObjectCode AS GoodsCode_child
            , Object_Goods_child.ValueData  AS GoodsName_child

             -- ��� ��� - !!!ReceiptProdModelChild!!!
            , COALESCE (ObjectLink_Goods_TaxKind_parent.ChildObjectId, ObjectLink_ReceiptService_TaxKind_parent.ChildObjectId) AS TaxKindId_parent
             -- % ���
            , ObjectFloat_TaxKind_Value_parent.ValueData AS TaxKindValue_parent

             -- ���� ��. ��� ���
            , COALESCE (ObjectFloat_EKPrice_parent.ValueData, ObjectFloat_ReceiptService_EKPrice_parent.ValueData, 0) :: TFloat AS EKPrice_parent
              -- ���� ��. � ���
            , zfCalc_SummWVAT (COALESCE (ObjectFloat_EKPrice_parent.ValueData, ObjectFloat_ReceiptService_EKPrice_parent.ValueData, 0)
                              , COALESCE (ObjectFloat_TaxKind_Value_parent.ValueData, 0))  ::TFloat AS EKPriceWVAT_parent

             -- ���� ������� ��� ���
           , CASE WHEN vbPriceWithVAT_pl = FALSE
                   THEN COALESCE (tmpPriceBasis_parent.ValuePrice, ObjectFloat_ReceiptService_SalePrice_parent.ValueData, 0)
                   ELSE zfCalc_Summ_NoVAT (COALESCE (tmpPriceBasis_parent.ValuePrice, ObjectFloat_ReceiptService_SalePrice_parent.ValueData, 0)
                                         , vbTaxKindValue_basis)
             END ::TFloat  AS BasisPrice_parent

             -- ���� ������� � ���
           , CASE WHEN vbPriceWithVAT_pl = FALSE
                   THEN zfCalc_SummWVAT (COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                                       , vbTaxKindValue_basis)
                   ELSE COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
             END ::TFloat  AS BasisPriceWVAT_parent


             -- ��� ��� - !!!ReceiptGooldsChild!!!
            , COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, ObjectLink_ReceiptService_TaxKind.ChildObjectId) AS TaxKindId
          --, ObjectLink_ProdOptions_TaxKind_opt.ChildObjectId                                                   AS TaxKindId_opt
             -- % ���
            , ObjectFloat_TaxKind_Value.ValueData     AS TaxKindValue
          --, ObjectFloat_TaxKind_Value_opt.ValueData AS TaxKindValue_opt

             -- ���� ��. ��� ���
            , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
              -- ���� ��. � ���
            , zfCalc_SummWVAT ( COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0)
                              , COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) )  ::TFloat AS EKPriceWVAT

             -- ���� ������� ��� ���
           , CASE WHEN vbPriceWithVAT_pl = FALSE
                   THEN COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                   ELSE zfCalc_Summ_NoVAT (COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                                          , vbTaxKindValue_basis)
             END ::TFloat  AS BasisPrice

             -- ���� ������� � ���
           , CASE WHEN vbPriceWithVAT_pl = FALSE
                   THEN zfCalc_SummWVAT (COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                                       , vbTaxKindValue_basis)
                   ELSE COALESCE (tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
             END ::TFloat  AS BasisPriceWVAT

             -- ���� ������� ��� ��� - �����
         --, CASE WHEN vbPriceWithVAT_pl = FALSE
         --        THEN ObjectFloat_SalePrice_opt.ValueData
         --        ELSE zfCalc_Summ_NoVAT (ObjectFloat_SalePrice_opt.ValueData, vbTaxKindValue_basis)
         --  END ::TFloat  AS SalePrice_opt

             -- ���� ������� � ��� - �����
         --, CASE WHEN vbPriceWithVAT_pl = FALSE
         --        THEN zfCalc_SummWVAT (ObjectFloat_SalePrice_opt.ValueData, vbTaxKindValue_basis)
         --        ELSE ObjectFloat_SalePrice_opt.ValueData
         --  END ::TFloat  AS SalePriceWVAT_opt

       FROM tmpRes
            -- Boat Structure
            LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpRes.ProdColorPatternId
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                 ON ObjectLink_ProdColorGroup.ObjectId = tmpRes.ProdColorPatternId
                                AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ColorPattern
                                 ON ObjectLink_ProdColorPattern_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectLink_ProdColorPattern_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()

            LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                                 ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ProdColorPattern_ColorPattern.ChildObjectId
                                AND ObjectLink_ColorPattern_Model.DescId = zc_ObjectLink_ColorPattern_Model()
            LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_ColorPattern_Model.ChildObjectId


            LEFT JOIN ObjectString AS ObjectString_ProdColorPattern_Comment
                                   ON ObjectString_ProdColorPattern_Comment.ObjectId = tmpRes.ProdColorPatternId
                                  AND ObjectString_ProdColorPattern_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()

            -- ���� � Boat Structure ��� ������, ����� �������� Farbe ����� = Comment
            LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_Goods
                                 ON ObjectLink_ProdColorPattern_Goods.ObjectId = tmpRes.ProdColorPatternId
                                AND ObjectLink_ProdColorPattern_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor_parent
                                 ON ObjectLink_Goods_ProdColor_parent.ObjectId = tmpRes.ObjectId_parent
                                AND ObjectLink_Goods_ProdColor_parent.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                 ON ObjectLink_Goods_ProdColor.ObjectId = tmpRes.ObjectId
                                AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
            LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = COALESCE (ObjectLink_Goods_ProdColor.ChildObjectId, ObjectLink_Goods_ProdColor_parent.ChildObjectId)

            -- Boat Structure -> ProdOptions
          --LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
          --                     ON ObjectLink_ProdOptions.ObjectId = tmpRes.ProdColorPatternId
          --                    AND ObjectLink_ProdOptions.DescId   = zc_ObjectLink_ProdColorPattern_ProdOptions()
          --LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId

            --
            LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = tmpRes.MaterialOptionsId
            LEFT JOIN Object AS Object_ReceiptLevel    ON Object_ReceiptLevel.Id    = tmpRes.ReceiptLevelId
            LEFT JOIN Object AS Object_Goods_child     ON Object_Goods_child.Id     = tmpRes.GoodsChildId

            --
            LEFT JOIN Object AS Object_Model ON Object_Model.Id = tmpRes.ModelId

            -- ������� ReceiptProdModelChild
            LEFT JOIN Object AS Object_parent ON Object_parent.Id = tmpRes.ObjectId_parent
            LEFT JOIN ObjectDesc AS ObjectDesc_parent ON ObjectDesc_parent.Id = Object_parent.DescId
            -- ������� ReceiptProdModelChild ��� ��������� �� ReceiptGoodsChild
            LEFT JOIN Object ON Object.Id = tmpRes.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId

            -- Options
          --LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice_opt
          --                      ON ObjectFloat_SalePrice_opt.ObjectId = Object_ProdOptions.Id
          --                     AND ObjectFloat_SalePrice_opt.DescId   = zc_ObjectFloat_ProdOptions_SalePrice()
          --LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_TaxKind_opt
          --                     ON ObjectLink_ProdOptions_TaxKind_opt.ObjectId = Object_ProdOptions.Id
          --                    AND ObjectLink_ProdOptions_TaxKind_opt.DescId   = zc_ObjectLink_ProdOptions_TaxKind()
          --LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_opt
          --                      ON ObjectFloat_TaxKind_Value_opt.ObjectId = ObjectLink_ProdOptions_TaxKind_opt.ChildObjectId
          --                     AND ObjectFloat_TaxKind_Value_opt.DescId   = zc_ObjectFloat_TaxKind_Value()

            -- ���� ��� ������/������ ����. ��� ���
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice_parent
                                  ON ObjectFloat_ReceiptService_EKPrice_parent.ObjectId = tmpRes.ObjectId_parent
                                 AND ObjectFloat_ReceiptService_EKPrice_parent.DescId   = zc_ObjectFloat_ReceiptService_EKPrice()
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                  ON ObjectFloat_ReceiptService_EKPrice.ObjectId = tmpRes.ObjectId
                                 AND ObjectFloat_ReceiptService_EKPrice.DescId   = zc_ObjectFloat_ReceiptService_EKPrice()
            -- ���� ��� ������/������ ������� ��� ���
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice_parent
                                  ON ObjectFloat_ReceiptService_SalePrice_parent.ObjectId = tmpRes.ObjectId_parent
                                 AND ObjectFloat_ReceiptService_SalePrice_parent.DescId   = zc_ObjectFloat_ReceiptService_SalePrice()
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice
                                  ON ObjectFloat_ReceiptService_SalePrice.ObjectId = tmpRes.ObjectId
                                 AND ObjectFloat_ReceiptService_SalePrice.DescId   = zc_ObjectFloat_ReceiptService_SalePrice()
            -- ������ / ������ ��� ���
            LEFT JOIN ObjectLink AS ObjectLink_ReceiptService_TaxKind_parent
                                 ON ObjectLink_ReceiptService_TaxKind_parent.ObjectId = tmpRes.ObjectId_parent
                                AND ObjectLink_ReceiptService_TaxKind_parent.DescId   = zc_ObjectLink_ReceiptService_TaxKind()
            LEFT JOIN ObjectLink AS ObjectLink_ReceiptService_TaxKind
                                 ON ObjectLink_ReceiptService_TaxKind.ObjectId = tmpRes.ObjectId
                                AND ObjectLink_ReceiptService_TaxKind.DescId   = zc_ObjectLink_ReceiptService_TaxKind()

            LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice_parent
                                  ON ObjectFloat_EKPrice_parent.ObjectId = tmpRes.ObjectId_parent
                                 AND ObjectFloat_EKPrice_parent.DescId   = zc_ObjectFloat_Goods_EKPrice()
            LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                  ON ObjectFloat_EKPrice.ObjectId = tmpRes.ObjectId
                                 AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind_parent
                                 ON ObjectLink_Goods_TaxKind_parent.ObjectId = tmpRes.ObjectId_parent
                                AND ObjectLink_Goods_TaxKind_parent.DescId   = zc_ObjectLink_Goods_TaxKind()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                 ON ObjectLink_Goods_TaxKind.ObjectId = tmpRes.ObjectId
                                AND ObjectLink_Goods_TaxKind.DescId   = zc_ObjectLink_Goods_TaxKind()

            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_parent
                                  ON ObjectFloat_TaxKind_Value_parent.ObjectId = COALESCE (ObjectLink_Goods_TaxKind_parent.ChildObjectId, ObjectLink_ReceiptService_TaxKind_parent.ChildObjectId)
                                 AND ObjectFloat_TaxKind_Value_parent.DescId   = zc_ObjectFloat_TaxKind_Value()
            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, ObjectLink_ReceiptService_TaxKind.ChildObjectId)
                                 AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

            LEFT JOIN tmpPriceBasis AS tmpPriceBasis_parent ON tmpPriceBasis_parent.GoodsId = tmpRes.ObjectId_parent
            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpRes.ObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.12.20                                        *
*/

-- ����
-- SELECT * FROM lpSelect_Object_ReceiptProdModelChild_detail (FALSE, zfCalc_UserAdmin() :: Integer) ORDER BY ModelId
