-- Function: gpSelect_Object_ReceiptGoodsChild_ProdColorPattern_ProdColorPattern()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoodsChild_ProdColorPattern (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoodsChild_ProdColorPattern (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoodsChild_ProdColorPattern(
    IN inIsShowAll   Boolean,       --
    IN inIsErased    Boolean,       -- ������� �������� ��������� �� / ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ReceiptGoodsId Integer
             , Value NUMERIC (16, 8), ForCount TFloat
             , Comment TVarChar
             , isEnabled Boolean
             , isErased Boolean
             , NPP Integer, NPP_calc Integer

               -- Boat Structure 
             , ProdColorPatternId Integer, ProdColorPatternCode Integer, ProdColorPatternName TVarChar, ProdColorPatternName_all TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
               -- ��������� �����
             , MaterialOptionsId Integer, MaterialOptionsName TVarChar
               --
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsId_receipt Integer, GoodsCode_receipt  Integer, GoodsName_receipt TVarChar, Article_receipt TVarChar, ProdColorName_receipt TVarChar

             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
               -- ���� /���� Comment �� Boat Structure
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , ReceiptLevelId Integer, ReceiptLevelName TVarChar
             , GoodsChildId Integer, GoodsChildName TVarChar

               -- ���� ��. ��� ���
             , EKPrice TFloat
               -- ���� ��. � ���, �� 2-� ������
             , EKPriceWVAT TFloat
               -- ����� ��. ��� ���, �� 2-� ������
             , EKPrice_summ TFloat
               -- ����� ��. � ���, �� 2-� ������
             , EKPriceWVAT_summ TFloat

              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTaxKindValue_basis TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoodsChild());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������� % ���!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());

     -- ���������
     RETURN QUERY
     WITH -- ���������� �������� Boat Structure
          tmpObject AS (SELECT ObjectLink_ReceiptGoods_ColorPattern.ObjectId   AS ReceiptGoodsId
                             , OL_ProdColorPattern_ColorPattern.ObjectId       AS ProdColorPatternId
                        FROM ObjectLink AS ObjectLink_ReceiptGoods_ColorPattern
                             -- �������� �������� Boat Structure
                             INNER JOIN ObjectLink AS OL_ProdColorPattern_ColorPattern
                                                   ON OL_ProdColorPattern_ColorPattern.ChildObjectId = ObjectLink_ReceiptGoods_ColorPattern.ChildObjectId
                                                  AND OL_ProdColorPattern_ColorPattern.DescId        = zc_ObjectLink_ProdColorPattern_ColorPattern()
                             -- �� ������ �������� Boat Structure
                             INNER JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id       = OL_ProdColorPattern_ColorPattern.ObjectId
                                                                         AND Object_ProdColorPattern.isErased = FALSE
                        WHERE ObjectLink_ReceiptGoods_ColorPattern.DescId = zc_ObjectLink_ReceiptGoods_ColorPattern()
                          AND inIsShowAll = TRUE
                       )
          -- ������������ �������� Boat Structure
        , tmpItems AS (SELECT Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId
                            , ObjectLink_ReceiptGoods.ChildObjectId           AS ReceiptGoodsId
                              -- ���� ������ �� ������ �����, �� ��� ��� � Boat Structure
                            , ObjectLink_Object.ChildObjectId                 AS ObjectId
                              -- ����� ������� Boat Structure
                            , ObjectLink_ProdColorPattern.ChildObjectId       AS ProdColorPatternId
                            , ObjectLink_MaterialOptions.ChildObjectId        AS MaterialOptionsId
                              -- ��������
                            , ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END AS Value
                            , ObjectFloat_ForCount.ValueData AS ForCount
                              --
                            , Object_ReceiptGoodsChild.ValueData              AS Comment
                            , Object_ReceiptGoodsChild.isErased               AS isErased

                       FROM Object AS Object_ReceiptGoodsChild
                            INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                                 AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                            LEFT JOIN ObjectLink AS ObjectLink_Object
                                                 ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object() 

                            -- ��������� �����
                            LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                 ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()

                            -- �������� � ������
                            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value()
                            LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                                  ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectFloat_ForCount.DescId = zc_ObjectFloat_ReceiptGoodsChild_ForCount()

                       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                         AND (Object_ReceiptGoodsChild.isErased = FALSE OR inIsErased = TRUE)
                      )
          -- ���������� ��� �������� Boat Structure
        , tmpProdColorPattern AS
                      (SELECT tmpItems.ReceiptGoodsChildId                                         AS ReceiptGoodsChildId
                            , tmpItems.ObjectId                                                    AS ObjectId
                            , COALESCE (tmpItems.ReceiptGoodsId, tmpObject.ReceiptGoodsId)         AS ReceiptGoodsId

                            , COALESCE (tmpItems.ProdColorPatternId, tmpObject.ProdColorPatternId) AS ProdColorPatternId
                            , tmpItems.MaterialOptionsId
                            , tmpItems.Value                                                       AS Value
                            , tmpItems.ForCount                                                    AS ForCount
                            , tmpItems.Comment                                                     AS Comment
                            , COALESCE (tmpItems.isErased, FALSE)                                  AS isErased
                            , CASE WHEN tmpItems.ProdColorPatternId > 0 THEN TRUE ELSE FALSE END   AS isEnabled

                       FROM tmpItems
                            FULL JOIN tmpObject ON tmpObject.ReceiptGoodsId     = tmpItems.ReceiptGoodsId
                                               AND tmpObject.ProdColorPatternId = tmpItems.ProdColorPatternId
                      )
     -- ���������
     SELECT tmpProdColorPattern.ReceiptGoodsChildId       AS Id
          , tmpProdColorPattern.ReceiptGoodsId            AS ReceiptGoodsId
          , CASE WHEN COALESCE (tmpProdColorPattern.Value,0) <> 0 THEN tmpProdColorPattern.Value ::TVarChar ELSE Null END :: NUMERIC (16, 8) AS Value
          , tmpProdColorPattern.ForCount      :: TFloat          AS ForCount
          , tmpProdColorPattern.Comment       :: TVarChar AS Comment
          , tmpProdColorPattern.isEnabled     :: Boolean  AS isEnabled
          , tmpProdColorPattern.isErased      :: Boolean  AS isErased
 
          , ObjectFloat_NPP.ValueData         :: Integer  AS NPP
          , ROW_NUMBER() OVER (PARTITION BY tmpProdColorPattern.ReceiptGoodsId ORDER BY Object_ProdColorPattern.ObjectCode ASC) :: Integer AS NPP_calc

          , Object_ProdColorPattern.Id                    AS ProdColorPatternId
          , Object_ProdColorPattern.ObjectCode            AS ProdColorPatternCode
          , zfCalc_ValueData_isErased (Object_ProdColorPattern.ValueData, Object_ProdColorPattern.isErased) AS ProdColorPatternName
          , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData
                                            , Object_ProdColorPattern.ValueData
                                            , Object_Model_pcp.ValueData
                                            , Object_ProdColorPattern.isErased
                                             ) AS ProdColorPatternName_all
          , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
          , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName
          , Object_ColorPattern_pcp.Id                    AS ColorPatternId
          , Object_ColorPattern_pcp.ValueData             AS ColorPatternName

          , Object_MaterialOptions.Id          ::Integer  AS MaterialOptionsId
          , Object_MaterialOptions.ValueData   ::TVarChar AS MaterialOptionsName

          , Object_Goods.Id                    ::Integer  AS GoodsId
          , Object_Goods.ObjectCode            ::Integer  AS GoodsCode
          , Object_Goods.ValueData             ::TVarChar AS GoodsName

          , Object_Goods_receipt.Id            ::Integer  AS GoodsId_receipt
          , Object_Goods_receipt.ObjectCode    ::Integer  AS GoodsCode_receipt
          , Object_Goods_receipt.ValueData     ::TVarChar AS GoodsName_receipt
          , ObjectString_Article_receipt.ValueData        AS Article_receipt
          , tmpProdColorPattern.Comment        ::TVarChar AS ProdColorName_receipt

          , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
          , Object_GoodsGroup.ValueData                AS GoodsGroupName
          , ObjectString_Article.ValueData             AS Article
            -- �������� Farbe
          , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL AND tmpProdColorPattern.Comment <> ''
                      THEN tmpProdColorPattern.Comment
                 WHEN ObjectLink_Goods.ChildObjectId IS NULL
                      THEN ObjectString_Comment.ValueData
                 ELSE Object_ProdColor.ValueData
            END :: TVarChar AS ProdColorName

          , Object_Measure.ValueData                   AS MeasureName

          , Object_ReceiptLevel.Id                        AS ReceiptLevelId
          , Object_ReceiptLevel.ValueData      ::TVarChar AS ReceiptLevelName

          , Object_GoodsChild.Id                          AS GoodsChildId
          , Object_GoodsChild.ValueData        ::TVarChar AS GoodsChildName

            -- ���� ��. ��� ���
          , ObjectFloat_EKPrice.ValueData                                                                 AS EKPrice
            -- ���� ��. � ���, �� 2-� ������
          , zfCalc_SummWVAT (ObjectFloat_EKPrice.ValueData, vbTaxKindValue_basis)                         AS EKPriceWVAT

            -- ����� ��. ��� ���, �� 2-� ������
          , zfCalc_SummIn (tmpProdColorPattern.Value, ObjectFloat_EKPrice.ValueData, 1)                   AS EKPrice_summ
            -- ����� ��. � ���, �� 2-� ������
          , zfCalc_SummWVAT (zfCalc_SummIn (tmpProdColorPattern.Value, ObjectFloat_EKPrice.ValueData, 1)
                           , vbTaxKindValue_basis)                                                        AS EKPriceWVAT_summ

     FROM tmpProdColorPattern
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpProdColorPattern.ProdColorPatternId
          LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = tmpProdColorPattern.MaterialOptionsId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

          -- NPP
          LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                                ON ObjectFloat_NPP.ObjectId = tmpProdColorPattern.ReceiptGoodsChildId
                               AND ObjectFloat_NPP.DescId   = zc_ObjectFloat_ReceiptGoodsChild_NPP()

          -- ������
          LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_ColorPattern
                               ON ObjectLink_ProdColorPattern_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorPattern_ColorPattern.DescId   = zc_ObjectLink_ProdColorPattern_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern_pcp ON Object_ColorPattern_pcp.Id = ObjectLink_ProdColorPattern_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                               ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ProdColorPattern_ColorPattern.ChildObjectId
                              AND ObjectLink_ColorPattern_Model.DescId = zc_ObjectLink_ColorPattern_Model()
          LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_ColorPattern_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
          -- !!!������!!!
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpProdColorPattern.ObjectId, ObjectLink_Goods.ChildObjectId)
          -- !!!������������ - ��� � ReceiptGoodsChild!!!
          LEFT JOIN Object AS Object_Goods_receipt ON Object_Goods_receipt.Id = tmpProdColorPattern.ObjectId

          --
          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Goods.Id
                                AND ObjectString_Article.DescId   = zc_ObjectString_Article()
          LEFT JOIN ObjectString AS ObjectString_Article_receipt
                                 ON ObjectString_Article_receipt.ObjectId = Object_Goods_receipt.Id
                                AND ObjectString_Article_receipt.DescId   = zc_ObjectString_Article()

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

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                               ON ObjectLink_ReceiptLevel.ObjectId = tmpProdColorPattern.ReceiptGoodsChildId
                              AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
          LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptLevel.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                               ON ObjectLink_GoodsChild.ObjectId = tmpProdColorPattern.ReceiptGoodsChildId
                              AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
          LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = ObjectLink_GoodsChild.ChildObjectId

          -- ���� ��. ��� ��� - �����
          LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                               AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.06.22         * MaterialOptions
 14.12.20         *
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPattern (inIsShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
