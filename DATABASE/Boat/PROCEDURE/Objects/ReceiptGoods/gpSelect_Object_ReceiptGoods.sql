-- Function: gpSelect_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoods(
    IN inIsErased    Boolean,       -- ������� �������� ��������� �� / ���
    IN inSession     TVarChar       -- ������ ������������
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

               -- ����� ��. ��� ���, �� 2-� ������ - �����
             , EKPrice_summ_goods     TFloat
               -- ����� ��. � ���, �� 2-� ������ - �����
             , EKPriceWVAT_summ_goods TFloat
               -- ����� ��. ��� ���, �� 2-� ������ - Boat Structure
             , EKPrice_summ_colPat     TFloat
               -- ����� ��. ��� ���, �� 2-� ������ - Boat Structure
             , EKPriceWVAT_summ_colPat TFloat
               -- ����� ����� ��. � ���, �� 2-� ������
             , EKPrice_summ     TFloat
               -- ����� ����� ��. � ���, �� 2-� ������
             , EKPriceWVAT_summ TFloat
               -- ���� ������� ��� ���
             , BasisPrice TFloat
               -- ���� ������� � ���, �� 2-� ������
             , BasisPriceWVAT TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������� � ������� ������
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());


     RETURN QUERY
     WITH -- ���� � ������� ������
          tmpPriceBasis AS (SELECT tmp.GoodsId
                                 , tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS tmp
                           )
          -- ��� �������� ������ �����
        , tmpReceiptGoodsChild_all AS (-- �������� ������ ����� - �����
                                       SELECT gpSelect.ReceiptGoodsId
                                              -- ����� ��. ��� ���, �� 2-� ������
                                            , SUM (gpSelect.EKPrice_summ)     AS EKPrice_summ_goods
                                              -- ����� ��. � ���, �� 2-� ������
                                            , SUM (gpSelect.EKPriceWVAT_summ) AS EKPriceWVAT_summ_goods
                                              -- Boat Structure
                                            , 0 AS EKPrice_summ_colPat
                                            , 0 AS EKPriceWVAT_summ_colPat

                                       FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPatternNo (inIsShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
                                       GROUP BY gpSelect.ReceiptGoodsId

                                      UNION ALL
                                       -- �������� ������ ����� - Boat Structure
                                       SELECT gpSelect.ReceiptGoodsId
                                              -- �����
                                            , 0 AS EKPrice_summ_goods
                                            , 0 AS EKPriceWVAT_summ_goods
                                              -- ����� ��. � ���, �� 2-� ������
                                            , SUM (gpSelect.EKPrice_summ)     AS EKPrice_summ_colPat
                                              -- ����� ��. � ���, �� 2-� ������
                                            , SUM (gpSelect.EKPriceWVAT_summ) AS EKPriceWVAT_summ_colPat

                                       FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPattern (inIsShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
                                       GROUP BY gpSelect.ReceiptGoodsId
                                   )
          -- ������� � 1 ������
        , tmpReceiptGoodsChild AS (SELECT tmpReceiptGoodsChild_all.ReceiptGoodsId
                                          -- ����� ��. ��� ���, �� 2-� ������
                                        , SUM (tmpReceiptGoodsChild_all.EKPrice_summ_goods)       :: TFloat AS EKPrice_summ_goods
                                          -- ����� ��. � ���, �� 2-� ������
                                        , SUM (tmpReceiptGoodsChild_all.EKPriceWVAT_summ_goods)   :: TFloat AS EKPriceWVAT_summ_goods
                                          -- ����� ��. ��� ���, �� 2-� ������
                                        , SUM (tmpReceiptGoodsChild_all.EKPrice_summ_colPat)      :: TFloat AS EKPrice_summ_colPat
                                          -- ����� ��. � ���, �� 2-� ������
                                        , SUM (tmpReceiptGoodsChild_all.EKPriceWVAT_summ_colPat)  :: TFloat AS EKPriceWVAT_summ_colPat

                                   FROM tmpReceiptGoodsChild_all
                                   GROUP BY tmpReceiptGoodsChild_all.ReceiptGoodsId
                                  )
     -- ���������
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

        , tmpReceiptGoodsChild.EKPrice_summ_goods      ::TFloat
        , tmpReceiptGoodsChild.EKPriceWVAT_summ_goods  ::TFloat

        , tmpReceiptGoodsChild.EKPrice_summ_colPat     ::TFloat
        , tmpReceiptGoodsChild.EKPriceWVAT_summ_colPat ::TFloat

        , (COALESCE (tmpReceiptGoodsChild.EKPrice_summ_colPat,0)     + COALESCE (tmpReceiptGoodsChild.EKPrice_summ_goods,0))     ::TFloat AS EKPrice_summ
        , (COALESCE (tmpReceiptGoodsChild.EKPriceWVAT_summ_colPat,0) + COALESCE (tmpReceiptGoodsChild.EKPriceWVAT_summ_goods,0)) ::TFloat AS EKPriceWVAT_summ

          -- ���� ������� ��� ���
        , CASE WHEN vbPriceWithVAT = FALSE
               THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
               ELSE zfCalc_Summ_NoVAT (tmpPriceBasis.ValuePrice, ObjectFloat_TaxKind_Value.ValueData)
          END ::TFloat  AS BasisPrice

          -- ���� ������� � ���
        , CASE WHEN vbPriceWithVAT = FALSE
               THEN zfCalc_SummWVAT (tmpPriceBasis.ValuePrice, ObjectFloat_TaxKind_Value.ValueData)
               ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
          END ::TFloat  AS BasisPriceWVAT

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

          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis() --Object_TaxKind.Id
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.20         *
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReceiptGoods (false, zfCalc_UserAdmin())
