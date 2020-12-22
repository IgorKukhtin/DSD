-- Function: gpSelect_Object_ReceiptProdModelChild_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelChild_Goods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModelChild_Goods(
    IN inIsErased    Boolean,       -- ������� �������� ��������� �� / ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS SETOF refcursor

AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbPriceWithVAT Boolean;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModelChild());
     vbUserId:= lpGetUserBySession (inSession);


     -- ����������
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     -- ����
     CREATE TEMP TABLE tmpPriceBasis ON COMMIT DROP AS
       (SELECT tmp.GoodsId
             , tmp.ValuePrice
        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                 , inOperDate   := CURRENT_DATE) AS tmp
       UNION
        SELECT Object.Id, 1 AS ValuePrice FROM Object WHERE Object.DescId = zc_Object_ReceiptService()
       );

     -- �������� ReceiptProdModelChild
     CREATE TEMP TABLE tmpReceiptProdModelChild ON COMMIT DROP AS
       (SELECT ObjectLink_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
             , Object_ReceiptProdModelChild.Id           AS ReceiptProdModelChildId
             , Object_ReceiptProdModelChild.ObjectCode   AS ObjectCode
             , Object_ReceiptProdModelChild.ValueData    AS ValueData
             , Object_ReceiptProdModelChild.isErased     AS isErased
               -- ������� ������� ����� ������������
             , ObjectLink_Object.ChildObjectId           AS ObjectId
               -- ��������
             , COALESCE (ObjectFloat_Value.ValueData, 0)   :: TFloat AS Value

               -- ���� ��. ��� ���
             , COALESCE (ObjectFloat_EKPrice.ValueData, 0) :: TFloat AS EKPrice
               -- ���� ��. � ���
             , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) :: TFloat AS EKPriceWVAT

               -- ���� ������� ��� ���
             , CASE WHEN vbPriceWithVAT = FALSE
                    THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                    ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
               END  :: TFloat AS BasisPrice
               -- ���� ������� � ���
             , CASE WHEN vbPriceWithVAT = FALSE
                    THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                    ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
               END ::TFloat AS BasisPriceWVAT

        FROM Object AS Object_ReceiptProdModelChild
             LEFT JOIN ObjectLink AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()

             LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                  ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                   ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                  AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value()

             LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                   ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Object.ChildObjectId
                                  AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                  ON ObjectLink_Goods_TaxKind.ObjectId = ObjectLink_Object.ChildObjectId
                                 AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
             LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                   ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Object.ChildObjectId
                                  AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

             LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Object.ChildObjectId

        WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
          AND (Object_ReceiptProdModelChild.isErased = FALSE OR inIsErased = TRUE)
       );

     -- ������������ ReceiptProdModelChild
     CREATE TEMP TABLE tmpReceiptGoodsChild ON COMMIT DROP AS
       (SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
             , Object_Goods.Id                       AS GoodsId
             , Object_Goods.ObjectCode               AS GoodsCode
             , Object_Goods.ValueData                AS GoodsName

             , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , Object_GoodsGroup.ValueData           AS GoodsGroupName
             , ObjectString_Article.ValueData        AS Article
             , Object_ProdColor.ValueData            AS ProdColorName
             , Object_Measure.ValueData              AS MeasureName

             , ROW_NUMBER() OVER (PARTITION BY tmpReceiptProdModelChild.ReceiptProdModelChildId ORDER BY Object_ReceiptGoodsChild.Id ASC) :: Integer AS NPP

               -- ��������
             , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)) :: TFloat AS Value

               -- ���� ��. ��� ���
             , COALESCE (ObjectFloat_EKPrice.ValueData, 0) :: TFloat AS EKPrice
               -- ���� ��. � ���
             , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                    * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) :: TFloat AS EKPriceWVAT

               -- ���� ������� ��� ���
             , CASE WHEN vbPriceWithVAT = FALSE
                    THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                    ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
               END  :: TFloat AS BasisPrice

               -- ���� ������� � ���
             , CASE WHEN vbPriceWithVAT = FALSE
                    THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                    ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
               END ::TFloat AS BasisPriceWVAT

               -- ����� ��. ��� ���
             , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0) * COALESCE (ObjectFloat_EKPrice.ValueData, 0)) :: TFloat AS EKPrice_summ
               -- ����� ��. � ���
             , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)
                    * CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                           * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))) :: TFloat AS EKPriceWVAT_summ

               -- ����� ������� ��� ���
             , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)
                * CASE WHEN vbPriceWithVAT = FALSE
                       THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                       ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                  END)  :: TFloat AS Basis_summ
               -- ����� ������� � ���
             , (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0)
                * CASE WHEN vbPriceWithVAT = FALSE
                        THEN CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                        ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                   END) ::TFloat AS BasisWVAT_summ

        FROM tmpReceiptProdModelChild
             -- ����� ��� � ������ �����
             INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                   ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpReceiptProdModelChild.ObjectId
                                  AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
             -- ��� ������� ������
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
             -- ������������� / ������/������
             LEFT JOIN ObjectLink AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                 AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
             -- � ���� ����������
             LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                 AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
             -- �������� � ������
             LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                   ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                  AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()

             -- !!!� ���� ����������!!!
             INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Object.ChildObjectId

             --
             LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                    ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = Object_Goods.Id
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()

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
                                   ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                  AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

             LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

        -- ��� ���� ���������
        -- WHERE ObjectLink_ProdColorPattern.ChildObjectId IS NULL
       );


     CREATE TEMP TABLE tmpChild ON COMMIT DROP AS
       (SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
               -- ���� ��� ���
             , tmpReceiptProdModelChild.EKPrice
               -- ���� ��. � ���
             , tmpReceiptProdModelChild.EKPriceWVAT
               -- ���� ������� ��� ���
             , tmpReceiptProdModelChild.BasisPrice
               -- ���� ������� � ���
             , tmpReceiptProdModelChild.BasisPriceWVAT
               --
             , (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPrice)        :: TFloat AS EKPrice_summ
             , (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.EKPriceWVAT)    :: TFloat AS EKPriceWVAT_summ
             , (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.BasisPrice)     :: TFloat AS Basis_summ
             , (tmpReceiptProdModelChild.Value * tmpReceiptProdModelChild.BasisPriceWVAT) :: TFloat AS BasisWVAT_summ

        FROM tmpReceiptProdModelChild
             LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
        WHERE tmpReceiptGoodsChild.ReceiptProdModelChildId IS NULL

       UNION ALL
        SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
               -- ���� ��� ���
             , CASE WHEN tmpReceiptProdModelChild.Value > 0 THEN SUM (tmpReceiptGoodsChild.EKPrice_summ)     / tmpReceiptProdModelChild.Value ELSE 0 END :: TFloat AS EKPrice
               -- ���� ��. � ���
             , CASE WHEN tmpReceiptProdModelChild.Value > 0 THEN SUM (tmpReceiptGoodsChild.EKPriceWVAT_summ) / tmpReceiptProdModelChild.Value ELSE 0 END :: TFloat AS EKPriceWVAT
               -- ���� ������� ��� ���
             , CASE WHEN tmpReceiptProdModelChild.Value > 0 THEN SUM (tmpReceiptGoodsChild.Basis_summ)       / tmpReceiptProdModelChild.Value ELSE 0 END :: TFloat AS BasisPrice
               -- ���� ������� � ���
             , CASE WHEN tmpReceiptProdModelChild.Value > 0 THEN SUM (tmpReceiptGoodsChild.BasisWVAT_summ)   / tmpReceiptProdModelChild.Value ELSE 0 END :: TFloat AS BasisPriceWVAT
               --
             , SUM (tmpReceiptGoodsChild.EKPrice_summ)     :: TFloat AS EKPrice_summ
             , SUM (tmpReceiptGoodsChild.EKPriceWVAT_summ) :: TFloat AS EKPriceWVAT_summ
             , SUM (tmpReceiptGoodsChild.Basis_summ)       :: TFloat AS Basis_summ
             , SUM (tmpReceiptGoodsChild.BasisWVAT_summ)   :: TFloat AS BasisWVAT_summ

        FROM tmpReceiptProdModelChild
             INNER JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
        GROUP BY tmpReceiptProdModelChild.ReceiptProdModelChildId
               , tmpReceiptProdModelChild.Value
       );

     -- ���������
     OPEN Cursor1 FOR

     SELECT
           tmpReceiptProdModelChild.ReceiptProdModelChildId AS Id
         , ROW_NUMBER() OVER (PARTITION BY tmpReceiptProdModelChild.ReceiptProdModelId ORDER BY tmpReceiptProdModelChild.ReceiptProdModelChildId ASC) :: Integer AS NPP
         , tmpReceiptProdModelChild.ValueData               AS Comment

         , CASE WHEN ObjectDesc.Id = zc_Object_Goods()          THEN tmpReceiptProdModelChild.Value ELSE 0 END ::TFloat   AS Value
         , CASE WHEN ObjectDesc.Id = zc_Object_ReceiptService() THEN tmpReceiptProdModelChild.Value ELSE 0 END ::TFloat   AS Value_service

         , tmpReceiptProdModelChild.ReceiptProdModelId

         , Object_ReceiptLevel.Id         ::Integer  AS ReceiptLevelId
         , Object_ReceiptLevel.ValueData  ::TVarChar AS ReceiptLevelName

         , Object_Object.Id               ::Integer  AS ObjectId
         , Object_Object.ObjectCode       ::Integer  AS ObjectCode
         , Object_Object.ValueData        ::TVarChar AS ObjectName
         , ObjectDesc.ItemName            ::TVarChar AS DescName

         , Object_Insert.ValueData                    AS InsertName
         , Object_Update.ValueData                    AS UpdateName
         , ObjectDate_Insert.ValueData                AS InsertDate
         , ObjectDate_Update.ValueData                AS UpdateDate
         , tmpReceiptProdModelChild.isErased          AS isErased

         --
         , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Article.ValueData             AS Article
         , Object_ProdColor.ValueData                 AS ProdColorName
         , Object_Measure.ValueData                   AS MeasureName

         , tmpChild.EKPrice_summ      :: TFloat AS EKPrice
         , tmpChild.EKPriceWVAT_summ  :: TFloat AS EKPriceWVAT
         , tmpChild.Basis_summ        :: TFloat AS BasisPrice
         , tmpChild.BasisWVAT_summ    :: TFloat AS BasisPriceWVAT

         , tmpChild.EKPrice_summ       :: TFloat AS EKPrice_summ
         , tmpChild.EKPriceWVAT_summ   :: TFloat AS EKPriceWVAT_summ
         , tmpChild.Basis_summ         :: TFloat AS Basis_summ
         , tmpChild.BasisWVAT_summ     :: TFloat AS BasisWVAT_summ

     FROM tmpReceiptProdModelChild

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                               ON ObjectLink_ReceiptLevel.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
          LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptLevel.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectDate AS ObjectDate_Update
                               ON ObjectDate_Update.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

          -- ����
          LEFT JOIN tmpChild ON tmpChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId

          -- �� ���� �������
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpReceiptProdModelChild.ObjectId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

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

     ;
      RETURN NEXT Cursor1;


     -- ���������
     OPEN Cursor2 FOR
     SELECT *
     FROM tmpReceiptGoodsChild;
     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.12.20         * add ReceiptLevel
 09.12.20         *
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReceiptProdModelChild_Goods (false, zfCalc_UserAdmin())
