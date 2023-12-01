-- Function: gpSelect_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptGoods(
    IN inIsErased    Boolean,       -- ������� �������� ��������� �� / ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UserCode TVarChar, Comment TVarChar
             , isMain Boolean
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_all TVarChar
             , GoodsId_group Integer, GoodsCode_group Integer, GoodsName_group TVarChar, Article_group TVarChar

             , ColorPatternId Integer, ColorPatternName TVarChar
             , ModelId Integer, ModelName TVarChar
             , MaterialOptionsName TVarChar, ProdColorName_pcp TVarChar
             , UnitId Integer, UnitName TVarChar
             , UnitChildId Integer, UnitChildName TVarChar

             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar, Article_all TVarChar
             , ArticleVergl TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
             , Comment_goods TVarChar


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
   DECLARE vbUserId             Integer;
   DECLARE vbPriceWithVAT_pl    Boolean;
   DECLARE vbTaxKindValue_basis TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoods());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������� � ������� ������
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!������� % ���!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());

     -- ���������
     RETURN QUERY
     WITH -- ���� � ������� ������
          tmpPriceBasis AS (SELECT lfSelect.GoodsId
                                   -- ���� ������� ��� ���
                                 , CASE WHEN vbPriceWithVAT_pl = FALSE
                                        THEN COALESCE (lfSelect.ValuePrice, 0)
                                        -- ������
                                        ELSE zfCalc_Summ_NoVAT (lfSelect.ValuePrice, vbTaxKindValue_basis)
                                   END ::TFloat  AS ValuePrice
                                   -- ���� ������� � ���
                                 , CASE WHEN vbPriceWithVAT_pl = TRUE
                                        THEN COALESCE (lfSelect.ValuePrice, 0)
                                        -- ������
                                        ELSE zfCalc_SummWVAT (lfSelect.ValuePrice, vbTaxKindValue_basis)
                                   END ::TFloat  AS ValuePriceWVAT
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS lfSelect
                           )
          -- �������� ������ ����� - Boat Structure
        , tmpReceiptGoodsChild_ProdColorPattern AS (SELECT gpSelect.ReceiptGoodsId
                                                         , gpSelect.GoodsId
                                                         , gpSelect.ProdColorPatternName_all
                                                         , gpSelect.ProdColorName
                                                         , gpSelect.MaterialOptionsName
                                                           -- ����� ��. � ���, �� 2-� ������
                                                         , gpSelect.EKPrice_summ
                                                           -- ����� ��. � ���, �� 2-� ������
                                                         , gpSelect.EKPriceWVAT_summ

                                                    FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPattern (inIsShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
                                                    ORDER BY gpSelect.ReceiptGoodsId, gpSelect.NPP
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

                                       FROM gpSelect_Object_ReceiptGoodsChild_ProdColorPatternNo (inReceiptGoodsId:=0, inReceiptLevelId:=0, inIsShowAll:= FALSE, inIsErased:= FALSE, inSession:= inSession) AS gpSelect
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

                                       FROM tmpReceiptGoodsChild_ProdColorPattern AS gpSelect
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
          -- �������������� GoodsChild
        , tmpReceiptGoods AS (SELECT Object_ReceiptGoods.Id, Object_ReceiptGoods.DescId, Object_ReceiptGoods.ObjectCode, Object_ReceiptGoods.ValueData, Object_ReceiptGoods.isErased
                                   , ObjectLink_Goods.ChildObjectId AS GoodsId
                                   , ObjectLink_Goods.ChildObjectId AS GoodsId_main
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
                                   , ObjectLink_Goods.ChildObjectId      AS GoodsId_main
                              FROM Object AS Object_ReceiptGoods
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                        ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                                                       AND ObjectLink_Goods.DescId   = zc_ObjectLink_ReceiptGoods_Object()
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
           -- ����� "��������"
         , tmpReceiptProdModel AS (SELECT DISTINCT ObjectLink_Object.ChildObjectId                 AS GoodsId
                                                 , Object_Goods.ObjectCode                         AS GoodsCode
                                                 , Object_Goods.ValueData                          AS GoodsName
                                                 , ObjectLink_ReceiptProdModel_Model.ChildObjectId AS ModelId
                                                 , CASE WHEN Object_Goods.ValueData ILIKE '%RAL %' THEN TRIM (SPLIT_PART (Object_Goods.ValueData, 'AGL-', 1))
                                                        ELSE ObjectString_Goods_Comment.ValueData
                                                   END AS Comment
                                   FROM Object AS Object_ReceiptProdModelChild
                                        LEFT JOIN ObjectLink AS ObjectLink_Object
                                                             ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                            AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Object.ChildObjectId

                                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                             ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                                            AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                        INNER JOIN Object AS Object_ReceiptProdModel
                                                          ON Object_ReceiptProdModel.Id       = ObjectLink_ReceiptProdModel.ChildObjectId
                                                         AND Object_ReceiptProdModel.isErased = FALSE
                                        LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel_Model
                                                             ON ObjectLink_ReceiptProdModel_Model.ObjectId = Object_ReceiptProdModel.Id
                                                            AND ObjectLink_ReceiptProdModel_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()
                                        LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                                               ON ObjectString_Goods_Comment.ObjectId = ObjectLink_Object.ChildObjectId
                                                              AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()
                                   WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                                     AND Object_ReceiptProdModelChild.isErased = FALSE
                                  )
     -- ���������
     SELECT
           Object_ReceiptGoods.Id         AS Id
         , Object_ReceiptGoods.ObjectCode AS Code
         , Object_ReceiptGoods.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         , CASE WHEN ObjectString_Comment.ValueData <> '' OR 1=1 THEN ObjectString_Comment.ValueData ELSE ObjectString_Goods_Comment.ValueData END ::TVarChar  AS Comment
         , CASE WHEN Object_Goods.Id = tmpReceiptProdModel.GoodsId
                     THEN TRUE
                ELSE FALSE -- ObjectBoolean_Main.ValueData
           END :: Boolean AS isMain

         , Object_Goods.Id         ::Integer  AS GoodsId
         , Object_Goods.ObjectCode ::Integer  AS GoodsCode
         , Object_Goods.ValueData  ::TVarChar AS GoodsName
         , zfCalc_GoodsName_all (ObjectString_Article.ValueData, Object_Goods.ValueData) ::TVarChar AS GoodsName_all

         , tmpReceiptProdModel.GoodsId          AS GoodsId_group
         , tmpReceiptProdModel.GoodsCode        AS GoodsCode_group
         , tmpReceiptProdModel.GoodsName        AS GoodsName_group
         , ObjectString_Article_group.ValueData AS Article_group

         , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName
         , Object_Model.Id                    ::Integer  AS ModelId
         , Object_Model.ValueData             ::TVarChar AS ModelName

         , tmpMaterialOptions.MaterialOptionsName :: TVarChar AS MaterialOptionsName
       --, COALESCE (tmpProdColorPattern.ProdColorName, tmpProdColorPattern_next.ProdColorName, tmpProdColorPattern_next_all.ProdColorName) :: TVarChar AS ProdColorName_pcp
         , (tmpProdColorPattern.ProdColorName || COALESCE ('*' || tmpProdColorPattern_next.ProdColorName, '*' || tmpProdColorPattern_next_all.ProdColorName, '')) :: TVarChar AS ProdColorName_pcp

         , Object_Unit.Id                     AS UnitId
         , Object_Unit.ValueData              AS UnitName
         , Object_UnitChild.Id                AS UnitChildId
         , Object_UnitChild.ValueData         AS UnitChildName

         , Object_Insert.ValueData            AS InsertName
         , Object_Update.ValueData            AS UpdateName
         , ObjectDate_Insert.ValueData        AS InsertDate
         , ObjectDate_Update.ValueData        AS UpdateDate
         , Object_ReceiptGoods.isErased       AS isErased

           --
         , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
         , ObjectString_Article.ValueData        ::TVarChar  AS Article
         , zfCalc_Article_all (COALESCE (ObjectString_Article.ValueData, '') || '_' || COALESCE (ObjectString_ArticleVergl.ValueData, '')) ::TVarChar AS Article_all
         , ObjectString_ArticleVergl.ValueData   :: TVarChar AS ArticleVergl
         , Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
         , Object_Measure.ValueData              ::TVarChar  AS MeasureName
         , ObjectString_Goods_Comment.ValueData  ::TVarChar  AS Comment_goods


         , tmpReceiptGoodsChild.EKPrice_summ_goods      ::TFloat
         , tmpReceiptGoodsChild.EKPriceWVAT_summ_goods  ::TFloat

         , tmpReceiptGoodsChild.EKPrice_summ_colPat     ::TFloat
         , tmpReceiptGoodsChild.EKPriceWVAT_summ_colPat ::TFloat

         , (COALESCE (tmpReceiptGoodsChild.EKPrice_summ_colPat,0)     + COALESCE (tmpReceiptGoodsChild.EKPrice_summ_goods,0))     ::TFloat AS EKPrice_summ
         , (COALESCE (tmpReceiptGoodsChild.EKPriceWVAT_summ_colPat,0) + COALESCE (tmpReceiptGoodsChild.EKPriceWVAT_summ_goods,0)) ::TFloat AS EKPriceWVAT_summ

           -- ���� ������� ��� ���
         , COALESCE (tmpPriceBasis.ValuePrice, 0)     ::TFloat AS BasisPrice
           -- ���� ������� � ���
         , COALESCE (tmpPriceBasis.ValuePriceWVAT, 0) ::TFloat AS BasisPriceWVAT

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

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                               ON ObjectLink_ColorPattern_Model.ObjectId = Object_ColorPattern.Id
                              AND ObjectLink_ColorPattern_Model.DescId   = zc_ObjectLink_ColorPattern_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_ColorPattern_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Unit
                               ON ObjectLink_Unit.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_Unit.DescId = zc_ObjectLink_ReceiptGoods_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_UnitChild
                               ON ObjectLink_UnitChild.ObjectId = Object_ReceiptGoods.Id
                              AND ObjectLink_UnitChild.DescId = zc_ObjectLink_ReceiptGoods_UnitChild()
          LEFT JOIN Object AS Object_UnitChild ON Object_UnitChild.Id = ObjectLink_UnitChild.ChildObjectId

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
          LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                 ON ObjectString_ArticleVergl.ObjectId = Object_Goods.Id
                                AND ObjectString_ArticleVergl.DescId = zc_ObjectString_ArticleVergl()

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

          LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptGoodsId = Object_ReceiptGoods.Id

          LEFT JOIN (SELECT tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                          , STRING_AGG (DISTINCT tmpReceiptGoodsChild_ProdColorPattern.MaterialOptionsName, ';') AS MaterialOptionsName
                     FROM tmpReceiptGoodsChild_ProdColorPattern
                     WHERE tmpReceiptGoodsChild_ProdColorPattern.MaterialOptionsName <> ''
                     GROUP BY tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                    ) AS tmpMaterialOptions
                      ON tmpMaterialOptions.ReceiptGoodsId = Object_ReceiptGoods.Id
          -- ���� ��� �����
          LEFT JOIN (SELECT tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                          , STRING_AGG (tmpReceiptGoodsChild_ProdColorPattern.ProdColorName, ';') AS ProdColorName
                     FROM tmpReceiptGoodsChild_ProdColorPattern
                     WHERE tmpReceiptGoodsChild_ProdColorPattern.GoodsId > 0 /*OR tmpReceiptGoodsChild_ProdColorPattern.ProdColorPatternName_all ILIKE 'Stitching%'*/
                     GROUP BY tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                    ) AS tmpProdColorPattern
                      ON tmpProdColorPattern.ReceiptGoodsId = Object_ReceiptGoods.Id
                     AND tmpProdColorPattern.ProdColorName <> ''

          -- ���� ��� ����������, ���������� ��������
          LEFT JOIN (SELECT tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                          , STRING_AGG (DISTINCT tmpReceiptGoodsChild_ProdColorPattern.ProdColorName, ';') AS ProdColorName
                     FROM tmpReceiptGoodsChild_ProdColorPattern
                     WHERE tmpReceiptGoodsChild_ProdColorPattern.GoodsId IS NULL
                     GROUP BY tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                    ) AS tmpProdColorPattern_next
                      ON tmpProdColorPattern_next.ReceiptGoodsId = Object_ReceiptGoods.Id
                     AND tmpProdColorPattern_next.ProdColorName <> ''
                     AND POSITION (';' IN tmpProdColorPattern_next.ProdColorName) = 0

          -- ���� ��� ����������, ���� ���� �������� ��������
          LEFT JOIN (SELECT tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                          , STRING_AGG (tmpReceiptGoodsChild_ProdColorPattern.ProdColorName, ';') AS ProdColorName
                     FROM tmpReceiptGoodsChild_ProdColorPattern
                     WHERE tmpReceiptGoodsChild_ProdColorPattern.GoodsId IS NULL
                     GROUP BY tmpReceiptGoodsChild_ProdColorPattern.ReceiptGoodsId
                    ) AS tmpProdColorPattern_next_all
                      ON tmpProdColorPattern_next_all.ReceiptGoodsId = Object_ReceiptGoods.Id


           -- ����� "��������"
          LEFT JOIN Object AS Object_Goods_main ON Object_Goods_main.Id = Object_ReceiptGoods.GoodsId_main
          LEFT JOIN ObjectString AS ObjectString_Goods_Comment_main
                                 ON ObjectString_Goods_Comment_main.ObjectId = Object_Goods_main.Id
                                AND ObjectString_Goods_Comment_main.DescId   = zc_ObjectString_Goods_Comment()
          LEFT JOIN tmpReceiptProdModel ON tmpReceiptProdModel.ModelId = Object_Model.Id
                                       AND tmpReceiptProdModel.Comment = CASE WHEN Object_Goods_main.ValueData ILIKE '%RAL %'
                                                                              THEN TRIM (SPLIT_PART (Object_Goods_main.ValueData, 'AGL-', 1))
                                                                              ELSE ObjectString_Goods_Comment_main.ValueData
                                                                         END
                                       AND ObjectString_Goods_Comment_main.ValueData <> ''
          LEFT JOIN ObjectString AS ObjectString_Article_group
                                 ON ObjectString_Article_group.ObjectId = tmpReceiptProdModel.GoodsId
                                AND ObjectString_Article_group.DescId   = zc_ObjectString_Article()

     WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
      AND (Object_ReceiptGoods.isErased = FALSE OR inIsErased = TRUE)
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.22         * Unit
 11.12.20         *
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReceiptGoods (false, zfCalc_UserAdmin())
