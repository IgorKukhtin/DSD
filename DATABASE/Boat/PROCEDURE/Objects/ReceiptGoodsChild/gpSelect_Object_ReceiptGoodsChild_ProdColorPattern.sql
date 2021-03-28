-- Function: gpSelect_Object_ReceiptGoodsChild_ProdColorPattern_ProdColorPattern()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoodsChild_ProdColorPattern (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoodsChild_ProdColorPattern (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoodsChild_ProdColorPattern(
    IN inIsShowAll   Boolean,       --
    IN inIsErased    Boolean,       -- ������� �������� ��������� �� / ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ReceiptGoodsId Integer
             , Value TFloat
             , Comment TVarChar
             , isEnabled Boolean
             , isErased Boolean
             , NPP Integer

             , ProdColorPatternId Integer, ProdColorPatternCode Integer, ProdColorPatternName TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
               -- ���� /���� Comment �� Boat Structure
             , ColorPatternId Integer, ColorPatternName TVarChar
               --
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar

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
   DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoodsChild());
     vbUserId:= lpGetUserBySession (inSession);

     -- ����������
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());


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
                              -- ��������
                            , ObjectFloat_Value.ValueData                     AS Value
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
                            -- �������� � ������
                            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value()
                       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                         AND (Object_ReceiptGoodsChild.isErased = FALSE OR inIsErased = TRUE)
                      )
          -- ���������� ��� �������� Boat Structure
        , tmpProdColorPattern AS
                      (SELECT tmpItems.ReceiptGoodsChildId                                         AS ReceiptGoodsChildId
                            , tmpItems.ObjectId                                                    AS ObjectId
                            , COALESCE (tmpItems.ReceiptGoodsId, tmpObject.ReceiptGoodsId)         AS ReceiptGoodsId

                            , COALESCE (tmpItems.ProdColorPatternId, tmpObject.ProdColorPatternId) AS ProdColorPatternId
                            , tmpItems.Value                                                       AS Value
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
          , tmpProdColorPattern.Value         :: TFloat   AS Value
          , tmpProdColorPattern.Comment       :: TVarChar AS Comment
          , tmpProdColorPattern.isEnabled     :: Boolean  AS isEnabled
          , tmpProdColorPattern.isErased      :: Boolean  AS isErased
          , ROW_NUMBER() OVER (PARTITION BY tmpProdColorPattern.ReceiptGoodsId ORDER BY Object_ProdColorPattern.ObjectCode ASC) :: Integer AS NPP

          , Object_ProdColorPattern.Id              AS ProdColorPatternId
          , Object_ProdColorPattern.ObjectCode      AS ProdColorPatternCode
          , Object_ProdColorPattern.ValueData       AS ProdColorPatternName

          , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
          , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName
          , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
          , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

          , Object_Goods.Id                    ::Integer  AS GoodsId
          , Object_Goods.ObjectCode            ::Integer  AS GoodsCode
          , Object_Goods.ValueData             ::TVarChar AS GoodsName

          , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
          , Object_GoodsGroup.ValueData                AS GoodsGroupName
          , ObjectString_Article.ValueData             AS Article
            -- �������� Farbe
          , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL THEN ObjectString_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
          , Object_Measure.ValueData                   AS MeasureName

            -- ���� ��. ��� ���
          , ObjectFloat_EKPrice.ValueData                                                                 AS EKPrice
            -- ���� ��. � ���, �� 2-� ������
          , zfCalc_SummWVAT (ObjectFloat_EKPrice.ValueData, ObjectFloat_TaxKind_Value.ValueData)          AS EKPriceWVAT

            -- ����� ��. ��� ���, �� 2-� ������
          , zfCalc_SummIn (tmpProdColorPattern.Value, ObjectFloat_EKPrice.ValueData, 1)                   AS EKPrice_summ
            -- ����� ��. � ���, �� 2-� ������
          , zfCalc_SummWVAT (zfCalc_SummIn (tmpProdColorPattern.Value, ObjectFloat_EKPrice.ValueData, 1)
                           , ObjectFloat_TaxKind_Value.ValueData)                                         AS EKPriceWVAT_summ

     FROM tmpProdColorPattern
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpProdColorPattern.ProdColorPatternId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
          -- !!!������!!!
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpProdColorPattern.ObjectId, ObjectLink_Goods.ChildObjectId)

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

          -- ���� ��. ��� ��� - �����
          LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                               AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
          -- !!!������� ���!!!
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis()
                               AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

         -- LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.20         *
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPattern (TRUE, FALSE, zfCalc_UserAdmin())
