-- Function: gpSelect_Object_ProdOptItems()

--DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptItems(
    IN inMovementId_OrderClient   Integer, --
    IN inIsShowAll                Boolean,       -- ������� �������� ��� (���������� �� ����� �����������)
    IN inIsErased                 Boolean,       -- ������� �������� ��������� �� / ���
    IN inIsSale                   Boolean,       -- ������� �������� ��������� �� / ���
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS TABLE (MovementId_OrderClient Integer
             , Id Integer, Code Integer, Name TVarChar
             , NPP Integer
             , PartNumber TVarChar, Comment TVarChar, CommentOpt TVarChar
             , KeyId TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , ProdOptPatternId Integer, ProdOptPatternName TVarChar
             , MaterialOptionsId Integer, MaterialOptionsName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
               -- Boat Structure
             , ProdColorPatternId Integer, ProdColorPatternName TVarChar
               -- ������ Boat Structure
             , ColorPatternId Integer, ColorPatternName TVarChar

             , isSale Boolean
             , isEnabled Boolean
             , isErased Boolean

             , GoodsGroupNameFull TVarChar
             , GoodsGroupName TVarChar
             , Article TVarChar
             , ProdColorName TVarChar
             , ProdColorValue TVarChar
             , Color_ProdColorValue Integer
             , MeasureName TVarChar
               -- % ������
             , DiscountTax           TFloat
             , DiscountTax_order     TFloat
             , DiscountNextTax_order TFloat
               -- % ��� ����� �������
             , VATPercent     TFloat
               -- ���� ��. ��� ���
             , EKPrice        TFloat
               --
             , EKPrice_summ TFloat

               -- ���� ������� ��� ���
             , SalePrice      TFloat
               -- ���� ������� � ���
             , SalePriceWVAT  TFloat
               --
             , Sale_summ TFloat, SaleWVAT_summ TFloat

               -- ���-�� ��� ������ ����
             , AmountBasis TFloat
               -- ��� �����
             , Amount TFloat
             , Amount_goods TFloat

             , InsertName TVarChar
             , InsertDate TDateTime

             , Color_fon Integer
              )
AS
$BODY$
   DECLARE vbUserId             Integer;
   DECLARE vbPriceWithVAT_pl    Boolean;
   DECLARE vbTaxKindValue_basis TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptItems());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������� � ������� ������
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!������� % ���!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());

     -- ���������
     RETURN QUERY
     WITH
          -- ���� ������� - ��� ���
          tmpPriceBasis AS (SELECT lfSelect.GoodsId
                                 , CASE WHEN vbPriceWithVAT_pl = FALSE
                                        THEN COALESCE (lfSelect.ValuePrice, 0)
                                        -- ������
                                        ELSE zfCalc_Summ_NoVAT (lfSelect.ValuePrice, vbTaxKindValue_basis)
                                   END ::TFloat  AS ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS lfSelect
                           )
  -- ��� �������� ������ ������ - ����� ������ Boat Structure
, tmpProdColorPattern_all AS (SELECT lpSelect.ModelId, lpSelect.ReceiptProdModelId
                                     -- ���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure /���� �����
                                   , lpSelect.ObjectId
                                     -- ��������
                                   , lpSelect.Value
                                     --
                                   , lpSelect.ProdColorPatternId
                                 --, lpSelect.ProdOptionsId, lpSelect.ProdOptionsCode, lpSelect.ProdOptionsName
                                     -- ���� /���� Comment �� Boat Structure
                                   , lpSelect.ProdColorId, lpSelect.ProdColorName

                                   , lpSelect.EKPrice

                                   , lpSelect.isMain

                              FROM lpSelect_Object_ReceiptProdModelChild_detail (inIsGroup:= TRUE, inUserId:= vbUserId) AS lpSelect
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
                                 --, tmpProdColorPattern_all.ProdOptionsId, tmpProdColorPattern_all.ProdOptionsCode, tmpProdColorPattern_all.ProdOptionsName

                                     -- ���� /���� Comment �� Boat Structure
                                   , tmpProdColorPattern_all.ProdColorId, tmpProdColorPattern_all.ProdColorName

                                   , tmpProdColorPattern_all.EKPrice

                              FROM ObjectLink AS ObjectLink_ReceiptProdModel_master

                                   INNER JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id       = ObjectLink_ReceiptProdModel_master.ChildObjectId
                                                                            -- !!!���!!!
                                                                            -- AND Object_ReceiptProdModel.isErased = FALSE
                                   INNER JOIN tmpProdColorPattern_all ON tmpProdColorPattern_all.ReceiptProdModelId = ObjectLink_ReceiptProdModel_master.ChildObjectId
                              -- ������������� ������ � �����
                              WHERE ObjectLink_ReceiptProdModel_master.DescId = zc_ObjectLink_Product_ReceiptProdModel()
                             )
       -- ��� ����� - ��� ���� ���������
     , tmpProdOptions_pcp AS (SELECT Object_ProdOptions.Id, Object_ProdOptions.ObjectCode, Object_ProdOptions.ValueData
                                     -- ������ �����������
                                   , tmpProdColorPattern.ProductId
                                   , tmpProdColorPattern.ReceiptProdModelId
                                     -- ������ �����������
                                   , tmpProdColorPattern.ModelId
                                     -- ���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure /���� �����
                                   , tmpProdColorPattern.ObjectId  AS GoodsId
                                     -- ���� �� Boat Structure ���� - Goods/Comment
                                   , tmpProdColorPattern.ProdColorId    AS ProdColorId
                                   , tmpProdColorPattern.ProdColorName  AS ProdColorName
                                     -- Boat Structure
                                   , tmpProdColorPattern.ProdColorPatternId
                                     -- ��������� �����
                                   , ObjectLink_MaterialOptions.ChildObjectId AS MaterialOptionsId

                                     -- ���-��
                                   , tmpProdColorPattern.Value

                                     -- ���� ��. ��� ��� - ������������� (���� ����)
                                   , tmpProdColorPattern.EKPrice
                                     -- � �/�, ������ ��� 1 ����� ���� �� Boat Structure
                                   , ROW_NUMBER() OVER (PARTITION BY tmpProdColorPattern.ProductId, tmpProdColorPattern.ProdColorPatternId
                                                        ORDER BY CASE WHEN Object_MaterialOptions.ValueData ILIKE 'LISSE/MATT' THEN 0 ELSE 1 END
                                                               , Object_ProdOptions.ObjectCode ASC
                                                       ) :: Integer AS NPP_pcp

                              FROM tmpProdColorPattern
                                   -- ��������� � ����� �����
                                   INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                         ON ObjectLink_ProdColorPattern.ChildObjectId = tmpProdColorPattern.ProdColorPatternId
                                                        AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                   --
                                   INNER JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdColorPattern.ObjectId
                                   -- ������ �����
                                   INNER JOIN ObjectLink AS ObjectLink_Model
                                                         ON ObjectLink_Model.ObjectId      = Object_ProdOptions.Id
                                                        AND ObjectLink_Model.DescId        = zc_ObjectLink_ProdOptions_Model()
                                                        AND ObjectLink_Model.ChildObjectId = tmpProdColorPattern.ModelId
                                   -- ��������� �����
                                   LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                        ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ProdOptions_MaterialOptions()
                                   LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = ObjectLink_MaterialOptions.ChildObjectId

                              WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                                AND Object_ProdOptions.isErased = FALSE
                             )
           -- ��� ����� �� �������
         , tmpProdOptions AS (SELECT Object_ProdOptions.Id, Object_ProdOptions.ObjectCode, Object_ProdOptions.ValueData
                                     -- ����� ��� ��������, �.�. ��� ����� ��� "����" �����
                                   , 0 AS ProductId
                                   , 0 AS ReceiptProdModelId
                                     -- ��� ������� !!�����������!!
                                   , COALESCE (ObjectLink_Model.ChildObjectId, 0) AS ModelId
                                     --
                                   , ObjectLink_Goods.ChildObjectId               AS GoodsId
                                   , Object_ProdColor.Id                          AS ProdColorId
                                   , Object_ProdColor.ValueData                   AS ProdColorName
                                   , ObjectLink_ProdColorPattern.ChildObjectId    AS ProdColorPatternId
                                   , ObjectLink_MaterialOptions.ChildObjectId     AS MaterialOptionsId

                                     -- ���-��
                                   , 1                             AS Value
                                     -- ���-��
                                   , CASE WHEN ObjectFloat_ProdOptions_Amount.ValueData > 0 THEN ObjectFloat_ProdOptions_Amount.ValueData ELSE 1 END AS Value_goods

                                     -- ���� ��. ��� ��� - �������������
                                   , ObjectFloat_EKPrice.ValueData AS EKPrice
                                     -- ���� ������� ��� ��� - �����/�������������
                                   , CASE WHEN ObjectFloat_SalePrice.ValueData > 0 THEN ObjectFloat_SalePrice.ValueData ELSE tmpPriceBasis.ValuePrice END AS SalePrice

                              FROM Object AS Object_ProdOptions
                                   LEFT JOIN ObjectFloat AS ObjectFloat_ProdOptions_Amount
                                                         ON ObjectFloat_ProdOptions_Amount.ObjectId = Object_ProdOptions.Id
                                                        AND ObjectFloat_ProdOptions_Amount.DescId   = zc_ObjectFloat_ProdOptions_Amount()
                                   -- ������ �����
                                   LEFT JOIN ObjectLink AS ObjectLink_Model
                                                        ON ObjectLink_Model.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_Model.DescId = zc_ObjectLink_ProdOptions_Model()
                                   -- ������������� � ����� �����
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                        ON ObjectLink_Goods.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdOptions_Goods()

                                   -- ��������� � ����� �����
                                   LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                        ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdOptions_ProdColorPattern()
                                   -- ��������� �����
                                   LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                        ON ObjectLink_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                                       AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()

                                   -- ��� ����� �� ���� ���������
                                   LEFT JOIN tmpProdColorPattern ON tmpProdColorPattern.ProdColorPatternId = ObjectLink_ProdColorPattern.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                        ON ObjectLink_Goods_ProdColor.ObjectId = ObjectLink_Goods.ChildObjectId
                                                       AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                                   LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                                   LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Goods.ChildObjectId

                                   LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                         ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Goods.ChildObjectId
                                                        AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                                   -- ���� ������� ��� ��� �����
                                   LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                                         ON ObjectFloat_SalePrice.ObjectId = Object_ProdOptions.Id
                                                        AND ObjectFloat_SalePrice.DescId   = zc_ObjectFloat_ProdOptions_SalePrice()

                              WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                                AND Object_ProdOptions.isErased = FALSE
                                -- ��� ���� ���������
                                AND tmpProdColorPattern.ProdColorPatternId IS NULL

                             UNION ALL
                              -- ��� ���� ���������
                              SELECT tmpProdOptions_pcp.Id, tmpProdOptions_pcp.ObjectCode, tmpProdOptions_pcp.ValueData
                                     -- ������ �����������
                                   , tmpProdOptions_pcp.ProductId
                                   , tmpProdOptions_pcp.ReceiptProdModelId
                                     -- ������ �����������
                                   , tmpProdOptions_pcp.ModelId
                                     -- ���� Goods-Options, ���� Goods "�����" ��� � Boat Structure /���� ������ Goods, �� ����� ��� � Boat Structure /���� �����
                                   , COALESCE (ObjectLink_Goods.ChildObjectId, CASE WHEN tmpProdOptions_pcp.NPP_pcp = 1 THEN tmpProdOptions_pcp.GoodsId ELSE 0 END)    AS GoodsId
                                     -- ���� ���� Goods-Options, ���� �� Boat Structure ���� - Goods/Comment
                                   , COALESCE (Object_ProdColor.Id, CASE WHEN tmpProdOptions_pcp.NPP_pcp = 1 THEN tmpProdOptions_pcp.ProdColorId ELSE 0 END)           AS ProdColorId
                                   , COALESCE (Object_ProdColor.ValueData, CASE WHEN tmpProdOptions_pcp.NPP_pcp = 1 THEN tmpProdOptions_pcp.ProdColorName ELSE '' END) AS ProdColorName
                                     -- Boat Structure
                                   , tmpProdOptions_pcp.ProdColorPatternId
                                     -- ��������� �����
                                   , tmpProdOptions_pcp.MaterialOptionsId

                                     -- ���-��
                                   , tmpProdOptions_pcp.Value
                                     -- ���-��
                                   , tmpProdOptions_pcp.Value AS Value_goods
                                     -- ���� ��. ��� ��� - ������������� (���� ����)
                                   , COALESCE (ObjectFloat_EKPrice.ValueData, tmpProdOptions_pcp.EKPrice) AS EKPrice
                                     -- ����� - ���� ������� ��� ���
                                   , ObjectFloat_SalePrice.ValueData AS SalePrice

                              FROM tmpProdOptions_pcp
                                   -- ���� ������� ��� ��� �����
                                   LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                                         ON ObjectFloat_SalePrice.ObjectId = tmpProdOptions_pcp.Id
                                                        AND ObjectFloat_SalePrice.DescId   = zc_ObjectFloat_ProdOptions_SalePrice()
                                   -- ������������� - �����
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                        ON ObjectLink_Goods.ObjectId = tmpProdOptions_pcp.Id
                                                       AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdOptions_Goods()
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                        ON ObjectLink_Goods_ProdColor.ObjectId = ObjectLink_Goods.ChildObjectId
                                                       AND ObjectLink_Goods_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                   LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                                   LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                         ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Goods.ChildObjectId
                                                        AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()
                             )

      -- ??���?? ��������� ����� �������
    , tmpOrderClient AS (SELECT Movement.Id                              AS MovementId
                              , MovementLinkObject_Product.ObjectId      AS ProductId
                                -- % ��� ����� �������
                              , MovementFloat_VATPercent.ValueData       AS VATPercent
                                -- 
                              , MovementFloat_DiscountTax.ValueData      AS DiscountTax
                                -- 
                              , MovementFloat_DiscountNextTax.ValueData  AS DiscountNextTax

                         FROM MovementLinkObject AS MovementLinkObject_Product
                              INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                                 AND Movement.DescId = zc_Movement_OrderClient()
                                               --AND Movement.StatusId <> zc_Enum_Status_Erased()

                              LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                      ON MovementFloat_VATPercent.MovementId = Movement.Id
                                                     AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()
                              LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                                      ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                                     AND MovementFloat_DiscountTax.DescId     = zc_MovementFloat_DiscountTax()
                              LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                                      ON MovementFloat_DiscountNextTax.MovementId = Movement.Id
                                                     AND MovementFloat_DiscountNextTax.DescId     = zc_MovementFloat_DiscountNextTax()
                         -- !!!��������, ���� ����� ���-�� �������� �� ���!!!
                         WHERE MovementLinkObject_Product.ObjectId > 0
                           AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                        )
           -- ��� ����� + ���������� ������� ��/���
         , tmpProduct AS (SELECT COALESCE (tmpOrderClient.MovementId, 0)       AS MovementId_OrderClient
                               , COALESCE (tmpOrderClient.VATPercent, 0)       AS VATPercent
                               , COALESCE (tmpOrderClient.DiscountTax, 0)      AS DiscountTax_order
                               , COALESCE (tmpOrderClient.DiscountNextTax, 0)  AS DiscountNextTax_order
                               , Object_Product.Id
                               , Object_Product.ObjectCode
                               , Object_Product.ValueData
                               , Object_Product.isErased
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
                               -- ������ �������
                               LEFT JOIN tmpOrderClient ON tmpOrderClient.ProductId = Object_Product.Id

                          WHERE Object_Product.DescId = zc_Object_Product()
                           AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                           AND (COALESCE (tmpOrderClient.MovementId, 0) = inMovementId_OrderClient OR inMovementId_OrderClient = 0)
                           AND (Object_Product.isErased = FALSE OR inIsErased = TRUE)
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
                               , CASE WHEN Object_ProdColor.Id > 0
                                           -- � ������
                                           THEN Object_ProdColor.ValueData

                                      WHEN TRIM (ObjectString_Comment.ValueData) <> ''
                                           -- ���� ���� ��������� ��� ����� (����� ��� GoodsId)
                                           THEN TRIM (ObjectString_Comment.ValueData)

                                      ELSE tmpProdOptions.ProdColorName

                                 END AS ProdColorName

                               , ObjectString_ProdColorValue.ValueData  AS ProdColorValue
                               , ObjectFloat_Value.ValueData::Integer   AS Color_ProdColorValue

                                 -- % ������
                               , COALESCE (ObjectFloat_DiscountTax.ValueData,0) AS DiscountTax

                                 -- ���-��
                               , COALESCE (tmpProdOptions.Value, 0)       AS Value
                                 -- ���-��
                               , CASE WHEN ObjectFloat_ProdOptions_Amount.ValueData > 0 THEN ObjectFloat_ProdOptions_Amount.ValueData ELSE 1 END AS Value_goods

                                 -- ���� ��. ��� ��� - ������������� - ����
                               , ObjectFloat_EKPrice.ValueData AS EKPrice

                               , tmpProdOptions.ProdColorPatternId
                               , tmpProdOptions.MaterialOptionsId


                                 -- ��� ���� ���������
                               , CASE WHEN ObjectFloat_PriceOut.ValueData >= 0 OR 1=1
                                           THEN ObjectFloat_PriceOut.ValueData

                                      WHEN tmpProdOptions.ProdColorPatternId > 0
                                           THEN -- ���� ������� ��� ��� - �����
                                                tmpProdOptions.SalePrice

                                      WHEN tmpProdOptions.SalePrice > 0
                                           THEN -- ���� ������� ��� ��� - �����
                                                tmpProdOptions.SalePrice

                                      ELSE -- ���� ������� ��� ��� - ������������� - ����
                                           tmpPriceBasis.ValuePrice
                                 END AS SalePrice

                                 -- ��� ���� ���������
                               , CASE WHEN ObjectFloat_PriceOut.ValueData >= 0 OR 1=1
                                           THEN zfCalc_SummWVAT (ObjectFloat_PriceOut.ValueData, tmpProduct.VATPercent)

                                      WHEN tmpProdOptions.ProdColorPatternId > 0
                                           THEN -- ���� ������� � ��� - �����
                                                zfCalc_SummWVAT (tmpProdOptions.SalePrice, tmpProduct.VATPercent)

                                      WHEN tmpProdOptions.SalePrice > 0
                                           THEN -- ���� ������� � ��� - �����
                                                zfCalc_SummWVAT (tmpProdOptions.SalePrice, tmpProduct.VATPercent)

                                      ELSE -- ���� ������� � ��� - ������������� - ����
                                           zfCalc_SummWVAT (tmpPriceBasis.ValuePrice, tmpProduct.VATPercent)

                                 END AS SalePriceWVAT

                               , tmpProduct.MovementId_OrderClient
                               , tmpProduct.VATPercent
                               , tmpProduct.DiscountTax_order
                               , tmpProduct.DiscountNextTax_order

                               , COALESCE (ObjectFloat_Count.ValueData, 0) AS Amount
                               

                          FROM Object AS Object_ProdOptItems
                               -- �����
                               INNER JOIN ObjectLink AS ObjectLink_Product
                                                     ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                                                    AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdOptItems_Product()
                               -- ����� �������
                               INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                                      ON ObjectFloat_MovementId_OrderClient.ObjectId = Object_ProdOptItems.Id
                                                     AND ObjectFloat_MovementId_OrderClient.DescId   = zc_ObjectFloat_ProdOptItems_OrderClient()
                               -- PriceOut
                               LEFT JOIN ObjectFloat AS ObjectFloat_PriceOut
                                                     ON ObjectFloat_PriceOut.ObjectId = Object_ProdOptItems.Id
                                                    AND ObjectFloat_PriceOut.DescId   = zc_ObjectFloat_ProdOptItems_PriceOut()
                               -- ���-�� ����� �����
                               LEFT JOIN ObjectFloat AS ObjectFloat_Count
                                                     ON ObjectFloat_Count.ObjectId = Object_ProdOptItems.Id
                                                    AND ObjectFloat_Count.DescId   = zc_ObjectFloat_ProdOptItems_Count()
                               -- ����� ������� + �����
                               INNER JOIN tmpProduct ON tmpProduct.Id                     = ObjectLink_Product.ChildObjectId
                                                    AND tmpProduct.MovementId_OrderClient = ObjectFloat_MovementId_OrderClient.ValueData :: Integer

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

                               -- �������� �����
                               LEFT JOIN ObjectString AS ObjectString_ProdColorValue
                                                      ON ObjectString_ProdColorValue.ObjectId = Object_ProdColor.Id
                                                     AND ObjectString_ProdColorValue.DescId   =zc_ObjectString_ProdColor_Value()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                     ON ObjectFloat_Value.ObjectId = Object_ProdColor.Id
                                                    AND ObjectFloat_Value.DescId = zc_ObjectFloat_ProdColor_Value()

                               LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                     ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Goods.ChildObjectId
                                                    AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                               LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_Goods.ChildObjectId

                               -- �����
                               LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                                                    ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                                                   AND ObjectLink_ProdOptions.DescId   = zc_ObjectLink_ProdOptItems_ProdOptions()
                               LEFT JOIN ObjectFloat AS ObjectFloat_ProdOptions_Amount
                                                     ON ObjectFloat_ProdOptions_Amount.ObjectId = ObjectLink_ProdOptions.ChildObjectId
                                                    AND ObjectFloat_ProdOptions_Amount.DescId   = zc_ObjectFloat_ProdOptions_Amount()
                                                   
                               -- ������� �� "��� �����" (������ ������) - ���� ����� ���� ������ ��������� ��������
                               LEFT JOIN tmpProdOptions ON tmpProdOptions.Id         = ObjectLink_ProdOptions.ChildObjectId
                                                       AND (tmpProdOptions.ModelId   = tmpProduct.ModelId OR tmpProdOptions.ModelId   = 0)
                                                       AND (tmpProdOptions.ProductId = tmpProduct.Id      OR tmpProdOptions.ProductId = 0)

                               LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                                     ON ObjectFloat_DiscountTax.ObjectId = Object_ProdOptItems.Id
                                                    AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_ProdOptItems_DiscountTax()

                               -- ����� ���� (����� ��� GoodsId)
                               LEFT JOIN ObjectString AS ObjectString_Comment
                                                      ON ObjectString_Comment.ObjectId = Object_ProdOptItems.Id
                                                     AND ObjectString_Comment.DescId    = zc_ObjectString_ProdOptItems_Comment()

                          WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                           AND (Object_ProdOptItems.isErased = FALSE OR inIsErased = TRUE)
                           AND (tmpProduct.MovementId_OrderClient = inMovementId_OrderClient OR inMovementId_OrderClient = 0)
                         )
         -- ��� �������� ProdOptItems
       , tmpRes AS (-- ������������
                    SELECT tmpProdOptItems.Id
                         , tmpProdOptItems.Code
                         , tmpProdOptItems.Name
                         , CASE WHEN tmpProdOptItems.isErased = TRUE THEN FALSE ELSE TRUE END :: Boolean AS isEnabled
                         , tmpProdOptItems.isErased

                         , tmpProdOptItems.ProdOptionsId
                         , tmpProdOptItems.GoodsId

                         , tmpProdOptItems.ProductId
                         , tmpProdOptItems.ProdOptPatternId

                         , tmpProdOptItems.ProdColorPatternId
                         , tmpProdOptItems.ProdColorId
                         , tmpProdOptItems.ProdColorName
                         , tmpProdOptItems.ProdColorValue
                         , tmpProdOptItems.Color_ProdColorValue
                         , tmpProdOptItems.MaterialOptionsId

                           -- % ������
                         , tmpProdOptItems.DiscountTax
                         , tmpProdOptItems.DiscountTax_order
                         , tmpProdOptItems.DiscountNextTax_order
                         
                         , tmpProdOptItems.Value
                         , tmpProdOptItems.Value_goods
                         , tmpProdOptItems.EKPrice
                         , tmpProdOptItems.SalePrice
                         , tmpProdOptItems.SalePriceWVAT

                         , tmpProdOptItems.MovementId_OrderClient
                         , tmpProdOptItems.VATPercent
                         , tmpProdOptItems.Amount

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
                         , 0                 AS ProdOptPatternId

                         , tmpProdOptions.ProdColorPatternId
                         , tmpProdOptions.ProdColorId
                         , tmpProdOptions.ProdColorName
                         , NULL :: TVarChar    AS ProdColorValue
                         , NULL :: Integer     AS Color_ProdColorValue
                         , tmpProdOptions.MaterialOptionsId

                           -- % ������
                         , 0 AS DiscountTax
                         , tmpProduct.DiscountTax_order
                         , tmpProduct.DiscountNextTax_order

                           -- ���-��
                         , 0 AS Value
                         , tmpProdOptions.Value_goods

                           -- ���� ��. ��� ���
                         , tmpProdOptions.EKPrice

                           -- ���� ������� ��� ���
                         , tmpProdOptions.SalePrice
                           -- ���� ������� � ���
                         , zfCalc_SummWVAT (tmpProdOptions.SalePrice, tmpProduct.VATPercent) AS SalePriceWVAT

                         , tmpProduct.MovementId_OrderClient
                         , tmpProduct.VATPercent
                         , 1 AS Amount

                    FROM tmpProdOptions
                         LEFT JOIN tmpProduct ON (tmpProduct.ModelId = tmpProdOptions.ModelId   OR tmpProdOptions.ModelId   = 0)
                                             AND (tmpProduct.Id      = tmpProdOptions.ProductId OR tmpProdOptions.ProductId = 0)
                         LEFT JOIN tmpProdOptItems ON tmpProdOptItems.ProductId              = tmpProduct.Id
                                                  AND tmpProdOptItems.MovementId_OrderClient = tmpProduct.MovementId_OrderClient
                                                  AND tmpProdOptItems.ProdOptionsId          = tmpProdOptions.Id
                    -- ���� �� ������ � ������������ + ���� �������� ��� ��������
                    WHERE tmpProdOptItems.ProdOptionsId IS NULL
                      -- ���� ����� ���
                      AND inIsShowAll = TRUE
                      -- ��� ��� ��� ���� ����� � ������������� ?
                      --AND (tmpProdOptions.SalePrice > 0 OR tmpProdOptions.GoodsId > 0)
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
         -- ��� ����� ��� ������� � ������������
       , tmpProdColor AS (SELECT Object_ProdColor.ValueData      AS Name
                               , ObjectString_Value.ValueData    AS Value
                               , COALESCE(ObjectFloat_Value.ValueData, zc_Color_White())::Integer  AS Color_Value
                               , ROW_NUMBER() OVER (PARTITION BY upper(Object_ProdColor.ValueData) ORDER BY Object_ProdColor.isErased DESC, Object_ProdColor.Id DESC) AS Ord
                           FROM Object AS Object_ProdColor
                              LEFT JOIN ObjectString AS ObjectString_Value
                                                     ON ObjectString_Value.ObjectId = Object_ProdColor.Id
                                                    AND ObjectString_Value.DescId = zc_ObjectString_ProdColor_Value()
                              LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                    ON ObjectFloat_Value.ObjectId = Object_ProdColor.Id
                                                   AND ObjectFloat_Value.DescId = zc_ObjectFloat_ProdColor_Value()
                           WHERE Object_ProdColor.DescId = zc_Object_ProdColor()
                         )


     -- ���������
     SELECT
           tmpRes.MovementId_OrderClient
         , tmpRes.Id
         , tmpRes.Code
         , tmpRes.Name
         , ROW_NUMBER() OVER (PARTITION BY tmpProduct.Id ORDER BY CASE WHEN tmpRes.ProdColorPatternId > 0 THEN 0
                                                                       WHEN tmpRes.Id > 0 THEN 1
                                                                       ELSE 2
                                                                  END
                                                                , COALESCE (Object_ProdColorPattern.ObjectCode, 0) ASC
                                                                , tmpRes.Id ASC
                                                                , COALESCE (ObjectFloat_ProdOptions_CodeVergl.ValueData, 0) ASC
                                                                , Object_ProdOptions.ObjectCode ASC
                                                                 ) :: Integer AS NPP

         , ObjectString_PartNumber.ValueData  ::TVarChar  AS PartNumber
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment
         , ObjectString_CommentOpt.ValueData  ::TVarChar  AS CommentOpt

         , (tmpProduct.Id :: TVarChar || '_' || tmpRes.MovementId_OrderClient :: TVarChar) :: TVarChar KeyId

         , tmpProduct.Id                  ::Integer   AS ProductId
         , zfCalc_ValueData_isErased (tmpProduct.ValueData, tmpProduct.isErased) AS ProductName

         , Object_ProdOptions.Id                          AS ProdOptionsId
         , Object_ProdOptions.ValueData                   AS ProdOptionsName

         , Object_ProdOptPattern.Id           ::Integer  AS ProdOptPatternId
         , Object_ProdOptPattern.ValueData    ::TVarChar AS ProdOptPatternName
         , Object_MaterialOptions.Id          ::Integer  AS MaterialOptionsId
         , Object_MaterialOptions.ValueData   ::TVarChar AS MaterialOptionsName

         , tmpGoods.GoodsId
         , tmpGoods.GoodsCode
         , tmpGoods.GoodsName

           -- Boat Structure
         , tmpRes.ProdColorPatternId          :: Integer  AS ProdColorPatternId
         , zfCalc_ProdColorPattern_isErased (Object_ProdColorGroup.ValueData, Object_ProdColorPattern.ValueData, Object_Model_pcp.ValueData, Object_ProdColorPattern.isErased) :: TVarChar AS ProdColorPatternName
           -- ������ Boat Structure
         , Object_ColorPattern.Id             ::Integer   AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar  AS ColorPatternName

         , tmpProduct.isSale                  ::Boolean   AS isSale
         , tmpRes.isEnabled                   ::Boolean   AS isEnabled
         , tmpRes.isErased                    ::Boolean   AS isErased

         , tmpGoods.GoodsGroupNameFull
         , tmpGoods.GoodsGroupName
         , tmpGoods.Article

         , CASE WHEN vbUserId = 5 AND 1=0
                     THEN Object_ProdColorGroup.ValueData
                WHEN Object_ProdColorGroup.ValueData ILIKE 'teak' AND Object_MaterialOptions.ValueData <> '' 
                     THEN Object_MaterialOptions.ValueData || ' ' || tmpRes.ProdColorName
                ELSE tmpRes.ProdColorName
           END :: TVarChar AS ProdColorName

         , COALESCE(tmpRes.ProdColorValue, ProdColorComent.Value, ProdColorName.Value)  :: TVarChar AS ProdColorValue
         , COALESCE(tmpRes.Color_ProdColorValue, ProdColorComent.Color_Value, ProdColorName.Color_Value, zc_Color_White()) ::Integer AS Color_ProdColorValue
         , tmpGoods.MeasureName

         , tmpRes.DiscountTax           ::TFloat AS DiscountTax
         , tmpRes.DiscountTax_order     ::TFloat AS DiscountTax_order
         , tmpRes.DiscountNextTax_order ::TFloat AS DiscountNextTax_order
         
         , tmpRes.VATPercent     ::TFloat    AS VATPercent

           -- ���� ��.
         , tmpRes.EKPrice                        :: TFloat AS EKPrice
         , (tmpRes.EKPrice * CASE WHEN tmpRes.ProdColorPatternId > 0 THEN tmpRes.Value ELSE tmpRes.Amount END) :: TFloat AS EKPrice_summ

           -- ���� �������
         , tmpRes.SalePrice                   :: TFloat AS SalePrice
         , tmpRes.SalePriceWVAT               :: TFloat AS SalePriceWVAT
         , (tmpRes.SalePrice * tmpRes.Amount) :: TFloat AS Sale_summ
         , zfCalc_SummWVAT (tmpRes.SalePrice * tmpRes.Amount, tmpRes.VATPercent) :: TFloat AS SaleWVAT_summ

           -- ���-�� � ������
         , tmpRes.Value        ::TFloat AS AmountBasis
         -- ���-�� �����
         , tmpRes.Amount       ::TFloat AS Amount
         , tmpRes.Value_goods  ::TFloat AS Amount_goods

         , Object_Insert.ValueData            ::TVarChar  AS InsertName
         , ObjectDate_Insert.ValueData        ::TDateTime AS InsertDate

         , CASE WHEN CEIL (tmpRes.Code / 2) * 2 <> tmpRes.Code
                     THEN zc_Color_Aqua()
                ELSE
                    -- ��� �����
                    zc_Color_White()
           END :: Integer AS Color_fon

     FROM tmpRes
          LEFT JOIN Object AS Object_ProdOptions     ON Object_ProdOptions.Id    = tmpRes.ProdOptionsId
          LEFT JOIN Object AS Object_ProdOptPattern  ON Object_ProdOptPattern.Id = tmpRes.ProdOptPatternId
          LEFT JOIN Object AS Object_MaterialOptions ON Object_MaterialOptions.Id = tmpRes.MaterialOptionsId
          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpRes.ProdColorPatternId

          LEFT JOIN tmpProduct ON tmpProduct.Id    = tmpRes.ProductId
          LEFT JOIN tmpGoods   ON tmpGoods.GoodsId = tmpRes.GoodsId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = tmpRes.Id
                                AND ObjectString_Comment.DescId   = zc_ObjectString_ProdOptItems_Comment()
          LEFT JOIN ObjectString AS ObjectString_CommentOpt
                                 ON ObjectString_CommentOpt.ObjectId = tmpRes.Id
                                AND ObjectString_CommentOpt.DescId   = zc_ObjectString_ProdOptItems_CommentOpt()
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

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern_Model
                               ON ObjectLink_ColorPattern_Model.ObjectId = ObjectLink_ColorPattern.ChildObjectId
                              AND ObjectLink_ColorPattern_Model.DescId = zc_ObjectLink_ColorPattern_Model()
          LEFT JOIN Object AS Object_Model_pcp ON Object_Model_pcp.Id = ObjectLink_ColorPattern_Model.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_ProdOptions_CodeVergl
                                ON ObjectFloat_ProdOptions_CodeVergl.ObjectId = Object_ProdOptions.Id
                               AND ObjectFloat_ProdOptions_CodeVergl.DescId = zc_ObjectFloat_ProdOptions_CodeVergl()

          LEFT JOIN tmpProdColor AS ProdColorName
                                 ON ProdColorName.Name ILIKE tmpRes.ProdColorName
                                AND ProdColorName.Ord = 1

          LEFT JOIN tmpProdColor AS ProdColorComent
                                 ON ProdColorComent.Name ILIKE ObjectString_Comment.ValueData
                                AND ProdColorComent.Ord = 1
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.05.23         *
 23.09.22                                                       *
 08.10.20         *
*/

/*
-- update 
SELECT ObjectLink.ChildObjectId, GoodsId, * 
-- , lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdOptItems_Goods(), gpSelect.Id, ObjectLink.ChildObjectId)

FROM gpSelect_Object_ProdOptItems (0, false, false, false, zfCalc_UserAdmin()) as gpSelect
join ObjectLink on ObjectLink.ObjectId =  ProdOptionsId
and ObjectLink.DescId = zc_ObjectLink_ProdOptions_Goods()
and coalesce (ObjectLink.ChildObjectId, 0) <> coalesce (GoodsId, 0)

where ProdOptionsId > 0 
and ProdColorPatternId is null
-- and GoodsId is null
*/
-- ����
-- SELECT * FROM gpSelect_Object_ProdOptItems (0, true, false,true, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_ProdOptItems (0, false, false, false, zfCalc_UserAdmin())
