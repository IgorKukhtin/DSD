-- Function: gpSelect_Object_ProdOptItems()

--DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptItems(
    IN inIsShowAll   Boolean,       -- ������� �������� ��� (���������� �� ����� �����������)
    IN inIsErased    Boolean,       -- ������� �������� ��������� �� / ���
    IN inIsSale      Boolean,       -- ������� �������� ��������� �� / ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , NPP Integer
             , PartNumber TVarChar, Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , ProdOptPatternId Integer, ProdOptPatternName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar

             , ProdColorPatternId Integer

             , isSale Boolean
             , isEnabled Boolean
             , isErased Boolean

             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , MeasureName TVarChar
               -- % ������
             , DiscountTax    TFloat
               -- ���� ��. ��� ���
             , EKPrice        TFloat
               -- ���� ��. � ���
             , EKPriceWVAT    TFloat
               --
             , EKPrice_summ TFloat, EKPriceWVAT_summ TFloat
               -- ���� ������� ��� ���
             , SalePrice      TFloat
               -- ���� ������� � ���
             , SalePriceWVAT  TFloat
               --
             , Sale_summ TFloat, SaleWVAT_summ TFloat
             
             --
             , Amount TFloat

             , InsertName TVarChar
             , InsertDate TDateTime

             , Color_fon Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptItems());
     vbUserId:= lpGetUserBySession (inSession);


     -- ����������
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     -- ���������
     RETURN QUERY
     WITH
         -- ������� ����
         tmpPriceBasis AS (SELECT tmp.GoodsId
                                , tmp.ValuePrice
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                    , inOperDate   := CURRENT_DATE) AS tmp
                          )
  -- ��� �������� ������ ������ - ����� ������ Boat Structure
, tmpProdColorPattern_all AS (SELECT lpSelect.ModelId, lpSelect.ReceiptProdModelId
                                     -- ���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure /���� �����
                                   , lpSelect.ObjectId
                                     -- ��������
                                   , lpSelect.Value
                                     --
                                   , lpSelect.ProdColorPatternId
                                   , lpSelect.ProdOptionsId, lpSelect.ProdOptionsCode, lpSelect.ProdOptionsName
                                     -- ���� /���� Comment �� Boat Structure
                                   , lpSelect.ProdColorId, lpSelect.ProdColorName

                                   , lpSelect.EKPrice, lpSelect.EKPriceWVAT

                                   , lpSelect.isMain

                              FROM lpSelect_Object_ReceiptProdModelChild_detail (vbUserId) AS lpSelect
                              -- � ����� ����������
                              WHERE lpSelect.ProdColorPatternId > 0
                              -- ��� �������
                              --AND lpSelect.isMain = TRUE
                             )
      -- ��� �������� ������ ������ - ��� ����� + � ������ ReceiptProdModel
    , tmpProdColorPattern AS (SELECT ObjectLink_ReceiptProdModel_master.ObjectId      AS ProductId
                                   , ObjectLink_ReceiptProdModel_master.ChildObjectId AS ReceiptProdModelId
                                   , tmpProdColorPattern_all.ModelId
                                     -- ���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure /���� �����
                                   , tmpProdColorPattern_all.ObjectId
                                     -- ��������
                                   , tmpProdColorPattern_all.Value
                                     --
                                   , tmpProdColorPattern_all.ProdColorPatternId
                                   , tmpProdColorPattern_all.ProdOptionsId, tmpProdColorPattern_all.ProdOptionsCode, tmpProdColorPattern_all.ProdOptionsName
                                     -- ���� /���� Comment �� Boat Structure
                                   , tmpProdColorPattern_all.ProdColorId, tmpProdColorPattern_all.ProdColorName

                                   , tmpProdColorPattern_all.EKPrice, tmpProdColorPattern_all.EKPriceWVAT

                              FROM ObjectLink AS ObjectLink_ReceiptProdModel_master
                              
                                   INNER JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id       = ObjectLink_ReceiptProdModel_master.ChildObjectId
                                                                            -- !!!���!!!
                                                                            -- AND Object_ReceiptProdModel.isErased = FALSE
                                   INNER JOIN tmpProdColorPattern_all ON tmpProdColorPattern_all.ReceiptProdModelId = ObjectLink_ReceiptProdModel_master.ChildObjectId
                              -- ������������� ������ � �����
                              WHERE ObjectLink_ReceiptProdModel_master.DescId = zc_ObjectLink_Product_ReceiptProdModel()
                             )
           -- ��� ����� �� �������
         , tmpProdOptions AS (SELECT Object_ProdOptions.Id, Object_ProdOptions.ObjectCode, Object_ProdOptions.ValueData
                                     -- ����� ��� ��������, �.�. ��� ����� ��� "����" �����
                                   , 0 AS ProductId
                                   , 0 AS ReceiptProdModelId
                                     -- ��� ������� �� �����������
                                   , COALESCE (ObjectLink_Model.ChildObjectId, 0) AS ModelId
                                   , ObjectLink_Goods.ChildObjectId AS GoodsId
                                   , Object_ProdColor.Id            AS ProdColorId
                                   , Object_ProdColor.ValueData     AS ProdColorName
                                   , 0                              AS ProdColorPatternId
                                     -- � Goods
                                   , ObjectLink_Goods_TaxKind.ChildObjectId AS TaxKindId

                                     -- ���-��
                                   , 1                             AS Value
                                     -- ���� ��. ��� ��� - �������������
                                   , ObjectFloat_EKPrice.ValueData AS EKPrice
                                     -- ���� ��. � ��� - �������������
                                   , CAST (ObjectFloat_EKPrice.ValueData
                                          * (1 + (COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData, 0) / 100)) AS NUMERIC (16, 2)) :: TFloat AS EKPriceWVAT

                                     -- ���� ������� ��� ��� - �������������
                                   , CASE WHEN vbPriceWithVAT = FALSE
                                          THEN tmpPriceBasis.ValuePrice
                                          ELSE CAST (tmpPriceBasis.ValuePrice * ( 1 - COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                     END  :: TFloat AS SalePrice
                                     -- ���� ������� � ��� - �������������
                                   , CASE WHEN vbPriceWithVAT = FALSE
                                          THEN CAST (tmpPriceBasis.ValuePrice * ( 1 + COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                          ELSE tmpPriceBasis.ValuePrice
                                     END ::TFloat AS SalePriceWVAT

                              FROM Object AS Object_ProdOptions
                                   -- ������ �����
                                   LEFT JOIN ObjectLink AS ObjectLink_Model
                                                        ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
                                   -- ������������� � ����� �����
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                        ON ObjectLink_Goods.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdOptions_Goods()

                                   -- ��� ����� �� ���� ���������
                                   LEFT JOIN tmpProdColorPattern ON tmpProdColorPattern.ProdOptionsId = Object_ProdOptions.Id

                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                        ON ObjectLink_Goods_ProdColor.ObjectId = ObjectLink_Goods.ChildObjectId
                                                       AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                                   LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                                   LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Goods.ChildObjectId

                                   LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                         ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Goods.ChildObjectId
                                                        AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                        ON ObjectLink_Goods_TaxKind.ObjectId = ObjectLink_Goods.ChildObjectId
                                                       AND ObjectLink_Goods_TaxKind.DescId   = zc_ObjectLink_Goods_TaxKind()

                                   LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_goods
                                                         ON ObjectFloat_TaxKind_Value_goods.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                        AND ObjectFloat_TaxKind_Value_goods.DescId   = zc_ObjectFloat_TaxKind_Value()

                              WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                                AND Object_ProdOptions.isErased = FALSE
                                -- ��� ���� ���������
                                AND tmpProdColorPattern.ProdOptionsId IS NULL

                             UNION ALL
                              -- ��� ���� ���������
                              SELECT Object_ProdOptions.Id, Object_ProdOptions.ObjectCode, Object_ProdOptions.ValueData
                                     -- ������ �����������
                                   , tmpProdColorPattern.ProductId
                                   , tmpProdColorPattern.ReceiptProdModelId
                                     -- ������ �����������
                                   , tmpProdColorPattern.ModelId
                                     -- ���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure /���� �����
                                   , tmpProdColorPattern.ObjectId AS GoodsId
                                     -- ���� /���� Comment �� Boat Structure
                                   , tmpProdColorPattern.ProdColorId, tmpProdColorPattern.ProdColorName
                                     -- Boat Structure
                                   , tmpProdColorPattern.ProdColorPatternId
                                     -- � �����, �.�. �� ���� ����������� ���� �������....
                                   , ObjectLink_TaxKind.ChildObjectId AS TaxKindId

                                     -- ���-��
                                   , tmpProdColorPattern.Value
                                     -- ���� ��. ��� ��� - ������������� (���� ����)
                                   , tmpProdColorPattern.EKPrice
                                     -- ���� ��. � ��� - ������������� (���� ����)
                                   , tmpProdColorPattern.EKPriceWVAT

                                     -- ����� - ���� ������� ��� ���
                                   , ObjectFloat_SalePrice.ValueData
                                     -- ����� - ���� ������� � ���
                                   , CAST (COALESCE (ObjectFloat_SalePrice.ValueData, 0)
                                        * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2)) AS SalePriceWVAT

                              FROM tmpProdColorPattern
                                   INNER JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = tmpProdColorPattern.ProdOptionsId

                                   -- ���� ������� �����
                                   LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                                         ON ObjectFloat_SalePrice.ObjectId = Object_ProdOptions.Id
                                                        AND ObjectFloat_SalePrice.DescId   = zc_ObjectFloat_ProdOptions_SalePrice()
                                   LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                                        ON ObjectLink_TaxKind.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_TaxKind.DescId   = zc_ObjectLink_ProdOptions_TaxKind()

                                   LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                         ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                        AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

                              WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                                AND Object_ProdOptions.isErased = FALSE
                             )
           -- ��� ����� + ���������� ������� ��/���
         , tmpProduct AS (SELECT Object_Product.*
                               , ObjectLink_Model.ChildObjectId AS ModelId
                               , CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                          FROM Object AS Object_Product
                               -- ������ �����
                               LEFT JOIN ObjectLink AS ObjectLink_Model
                                                    ON ObjectLink_Model.ObjectId = Object_Product.Id
                                                   AND ObjectLink_Model.DescId   = zc_ObjectLink_Product_Model()
                               -- ������� ��/���
                               LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                                    ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                                   AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()
                          WHERE Object_Product.DescId = zc_Object_Product()
                           AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                          )
      -- ������������ �������� ProdOptItems
    , tmpProdOptItems AS (SELECT Object_ProdOptItems.Id           AS Id
                               , Object_ProdOptItems.ObjectCode   AS Code
                               , Object_ProdOptItems.ValueData    AS Name
                               , Object_ProdOptItems.isErased     AS isErased

                               , ObjectLink_ProdOptions.ChildObjectId    AS ProdOptionsId
                               , ObjectLink_Product.ChildObjectId        AS ProductId
                                 -- ����
                               , ObjectLink_Goods.ChildObjectId          AS GoodsId
                                 --
                               , ObjectLink_ProdOptPattern.ChildObjectId AS ProdOptPatternId

                               , Object_ProdColor.Id        AS ProdColorId
                               , Object_ProdColor.ValueData AS ProdColorName

                                 -- % ������
                               , COALESCE (ObjectFloat_DiscountTax.ValueData,0) AS DiscountTax

                                 -- ���-��
                               , COALESCE (tmpProdOptions.Value, 1) AS Value

                                 -- ���� ��. ��� ��� - ������������� - ����
                               , ObjectFloat_EKPrice.ValueData AS EKPrice
                                 -- ���� ��. � ��� - ������������� - ����
                               , CAST (ObjectFloat_EKPrice.ValueData
                                      * (1 + (COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData, 0) / 100)) AS NUMERIC (16, 2)) :: TFloat AS EKPriceWVAT

                               , tmpProdOptions.ProdColorPatternId

                                 -- ��� ���� ���������
                               , CASE WHEN tmpProdOptions.ProdColorPatternId > 0
                                           THEN -- �����
                                                tmpProdOptions.TaxKindId

                                      ELSE -- ������������� - ����
                                           ObjectLink_Goods_TaxKind.ChildObjectId

                                 END AS TaxKindId

                                 -- ��� ���� ���������
                               , CASE WHEN tmpProdOptions.ProdColorPatternId > 0
                                           THEN -- ���� ������� ��� ��� - �����
                                                tmpProdOptions.SalePrice

                                      ELSE -- ���� ������� ��� ��� - ������������� - ����
                                           CASE WHEN vbPriceWithVAT = FALSE
                                                THEN tmpPriceBasis.ValuePrice
                                                ELSE CAST (tmpPriceBasis.ValuePrice * ( 1 - COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                           END
                                 END AS SalePrice

                                 -- ��� ���� ���������
                               , CASE WHEN tmpProdOptions.ProdColorPatternId > 0
                                           THEN -- ���� ������� � ��� - �����
                                                tmpProdOptions.SalePriceWVAT

                                      ELSE -- ���� ������� � ��� - ������������� - ����
                                           CASE WHEN vbPriceWithVAT = FALSE
                                                THEN CAST (tmpPriceBasis.ValuePrice * ( 1 + COALESCE (ObjectFloat_TaxKind_Value_goods.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                                ELSE tmpPriceBasis.ValuePrice
                                           END
                                 END AS SalePriceWVAT

                          FROM Object AS Object_ProdOptItems
                               -- �����
                               INNER JOIN ObjectLink AS ObjectLink_Product
                                                     ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                                    AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdOptItems_Product()
                               INNER JOIN tmpProduct ON tmpProduct.Id = ObjectLink_Product.ChildObjectId

                               -- �������
                               LEFT JOIN ObjectLink AS ObjectLink_ProdOptPattern
                                                    ON ObjectLink_ProdOptPattern.ObjectId = Object_ProdOptItems.Id
                                                   AND ObjectLink_ProdOptPattern.DescId   = zc_ObjectLink_ProdOptItems_ProdOptPattern()
                               -- �������������
                               LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                    ON ObjectLink_Goods.ObjectId = Object_ProdOptItems.Id
                                                   AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdOptItems_Goods()
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                    ON ObjectLink_Goods_ProdColor.ObjectId = ObjectLink_Goods.ChildObjectId
                                                   AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                               LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                               LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                     ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Goods.ChildObjectId
                                                    AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                    ON ObjectLink_Goods_TaxKind.ObjectId = ObjectLink_Goods.ChildObjectId
                                                   AND ObjectLink_Goods_TaxKind.DescId   = zc_ObjectLink_Goods_TaxKind()
                               LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value_goods
                                                     ON ObjectFloat_TaxKind_Value_goods.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                    AND ObjectFloat_TaxKind_Value_goods.DescId   = zc_ObjectFloat_TaxKind_Value()
                               LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Goods.ChildObjectId

                               -- �����
                               LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                                                    ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                                                   AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()
                               -- ������� �� "��� �����" (������ ������) - ���� ����� ���� ������ ��������� ��������
                               LEFT JOIN tmpProdOptions ON tmpProdOptions.Id         = ObjectLink_ProdOptions.ChildObjectId
                                                       AND (tmpProdOptions.ModelId   = tmpProduct.ModelId OR tmpProdOptions.ModelId   = 0)
                                                       AND (tmpProdOptions.ProductId = tmpProduct.Id      OR tmpProdOptions.ProductId = 0)

                               LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                                     ON ObjectFloat_DiscountTax.ObjectId = Object_ProdOptItems.Id
                                                    AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_ProdOptItems_DiscountTax()

                          WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                           AND (Object_ProdOptItems.isErased = FALSE OR inIsErased = TRUE)
                         )
         -- ��� �������� ProdOptItems
       , tmpRes AS (SELECT tmpProdOptItems.Id
                         , tmpProdOptItems.Code
                         , tmpProdOptItems.Name
                         , TRUE :: Boolean AS isEnabled
                         , tmpProdOptItems.isErased

                         , tmpProdOptItems.ProdOptionsId
                         , tmpProdOptItems.GoodsId

                         , tmpProdOptItems.ProductId
                         , tmpProdOptItems.ProdOptPatternId

                         , tmpProdOptItems.ProdColorPatternId
                         , tmpProdOptItems.ProdColorId
                         , tmpProdOptItems.ProdColorName
                         , tmpProdOptItems.TaxKindId

                           -- % ������
                         , tmpProdOptItems.DiscountTax

                         , tmpProdOptItems.Value
                         , tmpProdOptItems.EKPrice
                         , tmpProdOptItems.EKPriceWVAT
                         , tmpProdOptItems.SalePrice
                         , tmpProdOptItems.SalePriceWVAT

                    FROM tmpProdOptItems

                   UNION ALL
                    SELECT 0     :: Integer  AS Id
                         , 0     :: Integer  AS Code
                         , ''    :: TVarChar AS Name
                         , FALSE :: Boolean  AS isEnabled
                         , FALSE :: Boolean  AS isErased

                         , tmpProdOptions.Id AS ProdOptionsId
                         , tmpProdOptions.GoodsId

                         , tmpProduct.Id     AS ProductId
                         , 0     :: Integer  AS ProdOptPatternId

                         , tmpProdOptions.ProdColorPatternId
                         , tmpProdOptions.ProdColorId
                         , tmpProdOptions.ProdColorName
                         , tmpProdOptions.TaxKindId

                           -- % ������
                         , 0     :: TFloat   AS DiscountTax

                           -- ���-��
                         , 0     :: TFloat   AS Value

                           -- ���� ��. ��� ���
                         , tmpProdOptions.EKPrice
                           -- ���� ��. � ���
                         , tmpProdOptions.EKPriceWVAT

                           -- ���� ������� ��� ���
                         , tmpProdOptions.SalePrice
                           -- ���� ������� � ���
                         , tmpProdOptions.SalePriceWVAT

                    FROM tmpProdOptions
                         LEFT JOIN tmpProduct ON (tmpProduct.ModelId = tmpProdOptions.ModelId   OR tmpProdOptions.ModelId   = 0)
                                             AND (tmpProduct.Id      = tmpProdOptions.ProductId OR tmpProdOptions.ProductId = 0)
                         LEFT JOIN tmpProdOptItems ON tmpProdOptItems.ProductId     = tmpProduct.Id
                                                  AND tmpProdOptItems.ProdOptionsId = tmpProdOptions.Id
                    -- ���� �� ������ � ������������ + ���� �������� ��� ��������
                    WHERE tmpProdOptItems.ProdOptionsId IS NULL
                      -- ���� ����� ���
                      AND inIsShowAll = TRUE
                   )
         -- �������� ��� GoodsId
       , tmpGoods AS (SELECT tmpObject.GoodsId                          AS GoodsId
                           , Object_Goods.ObjectCode                    AS GoodsCode
                           , Object_Goods.ValueData                     AS GoodsName
                           , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
                           , Object_GoodsGroup.ValueData                AS GoodsGroupName
                           , ObjectString_Article.ValueData             AS Article
                           , Object_Measure.ValueData                   AS MeasureName

                      FROM (SELECT DISTINCT tmpRes.GoodsId FROM tmpRes) AS tmpObject
                           LEFT JOIN Object AS Object_Goods          ON Object_Goods.Id          = tmpObject.GoodsId

                           LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                  ON ObjectString_GoodsGroupFull.ObjectId = tmpObject.GoodsId
                                                 AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                           LEFT JOIN ObjectString AS ObjectString_Article
                                                  ON ObjectString_Article.ObjectId = tmpObject.GoodsId
                                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpObject.GoodsId
                                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = tmpObject.GoodsId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                     )
     -- ���������
     SELECT
           tmpRes.Id
         , tmpRes.Code
         , tmpRes.Name
         , ROW_NUMBER() OVER (PARTITION BY tmpProduct.Id ORDER BY CASE WHEN tmpRes.Id > 0 THEN 0 ELSE 1 END, tmpRes.Id ASC, Object_ProdOptions.ObjectCode ASC) :: Integer AS NPP

         , ObjectString_PartNumber.ValueData  ::TVarChar  AS PartNumber
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , tmpProduct.Id                  ::Integer   AS ProductId
         , tmpProduct.ValueData           ::TVarChar  AS ProductName

         , Object_ProdOptions.Id                          AS ProdOptionsId
         , Object_ProdOptions.ValueData                   AS ProdOptionsName

         , Object_ProdOptPattern.Id           ::Integer  AS ProdOptPatternId
         , Object_ProdOptPattern.ValueData    ::TVarChar AS ProdOptPatternName

         , tmpGoods.GoodsId
         , tmpGoods.GoodsCode
         , tmpGoods.GoodsName

         , tmpRes.ProdColorPatternId          :: Integer AS ProdColorPatternId

         , tmpProduct.isSale                  ::Boolean   AS isSale
         , tmpRes.isEnabled                   ::Boolean   AS isEnabled
         , tmpRes.isErased                    ::Boolean   AS isErased

         , tmpGoods.GoodsGroupNameFull
         , tmpGoods.GoodsGroupName
         , tmpGoods.Article
         , tmpRes.ProdColorName
         , tmpGoods.MeasureName

         , tmpRes.DiscountTax    ::TFloat    AS DiscountTax

           -- ���� ��.
         , tmpRes.EKPrice                        :: TFloat AS EKPrice
         , tmpRes.EKPriceWVAT                    :: TFloat AS EKPriceWVAT
         , (tmpRes.EKPrice     * tmpRes.Value)   :: TFloat AS EKPrice_summ
         , (tmpRes.EKPriceWVAT * tmpRes.Value)   :: TFloat AS EKPriceWVAT_summ
           -- ���� �������
         , tmpRes.SalePrice                      :: TFloat AS SalePrice
         , tmpRes.SalePriceWVAT                  :: TFloat AS SalePriceWVAT
         , (tmpRes.SalePrice     * CASE WHEN tmpRes.ProdColorPatternId > 0 THEN 1 ELSE tmpRes.Value END) :: TFloat AS Sale_summ
         , (tmpRes.SalePriceWVAT * CASE WHEN tmpRes.ProdColorPatternId > 0 THEN 1 ELSE tmpRes.Value END) :: TFloat AS SaleWVAT_summ
         , tmpRes.Value ::TFloat AS Amount

         , Object_Insert.ValueData            ::TVarChar  AS InsertName
         , ObjectDate_Insert.ValueData        ::TDateTime AS InsertDate

         , CASE WHEN CEIL (tmpRes.Code / 2) * 2 <> tmpRes.Code
                     THEN zc_Color_Aqua()
                ELSE
                    -- ��� �����
                    zc_Color_White()
           END :: Integer AS Color_fon

     FROM tmpRes
          LEFT JOIN Object AS Object_ProdOptions    ON Object_ProdOptions.Id    = tmpRes.ProdOptionsId
          LEFT JOIN Object AS Object_ProdOptPattern ON Object_ProdOptPattern.Id = tmpRes.ProdOptPatternId

          LEFT JOIN tmpProduct ON tmpProduct.Id    = tmpRes.ProductId
          LEFT JOIN tmpGoods   ON tmpGoods.GoodsId = tmpRes.GoodsId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = tmpRes.Id
                                AND ObjectString_Comment.DescId   = zc_ObjectString_ProdOptItems_Comment()
          LEFT JOIN ObjectString AS ObjectString_PartNumber
                                 ON ObjectString_PartNumber.ObjectId = tmpRes.Id
                                AND ObjectString_PartNumber.DescId   = zc_ObjectString_ProdOptItems_PartNumber()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = tmpRes.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = tmpRes.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ProdOptItems (false, false, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ProdOptItems (true, false,true, zfCalc_UserAdmin())
