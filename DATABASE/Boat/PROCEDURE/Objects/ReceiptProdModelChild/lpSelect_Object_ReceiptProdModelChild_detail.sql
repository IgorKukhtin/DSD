-- Function: gpSelect_Object_ReceiptProdModelChild()

DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptProdModelChild_detail (Integer);

CREATE OR REPLACE FUNCTION lpSelect_Object_ReceiptProdModelChild_detail(
    IN inUserId      Integer        -- ������������
)
RETURNS TABLE (ModelId Integer
               --
             , isMain Boolean
             , ReceiptProdModelId Integer, ReceiptProdModelChildId Integer
             , ObjectId Integer
               -- ��������
             , Value TFloat
               --
             , ReceiptGoodsChildId Integer
             , ProdColorPatternId Integer
             , ProdOptionsId Integer, ProdOptionsCode Integer, ProdOptionsName TVarChar

             , EKPrice TFloat, EKPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
              )
AS
$BODY$
   DECLARE vbPriceWithVAT Boolean;
BEGIN

     -- ����������
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());


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
                                             -- ������� ������� ����� ������������
                                           , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                             -- ��������
                                           , ObjectFloat_Value.ValueData                     AS Value

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
                                           -- �� ���� ����������
                                           LEFT JOIN ObjectLink AS ObjectLink_Object
                                                                ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                                           -- �������� � ������
                                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                                 ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                                AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptProdModelChild_Value()

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
                                       , Object_ReceiptGoodsChild.Id                       AS ReceiptGoodsChildId
                                         -- ��������� ��� ���� ������ "�������������", �� ��� ��� � Boat Structure
                                       , ObjectLink_Object.ChildObjectId                   AS GoodsId
                                         -- ����� ������� Boat Structure
                                       , COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) AS ProdColorPatternId
                                         -- ��������
                                       , tmpReceiptProdModelChild.Value * ObjectFloat_Value.ValueData AS Value
                                  FROM tmpReceiptProdModelChild
                                       -- ����� ��� � ������ �����
                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                             ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpReceiptProdModelChild.ObjectId
                                                            AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
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
                                                            ON ObjectLink_ProdColorPattern.ObjectId      = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                           AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                       -- ��������� ��� ���� ���� "������" - "�������������" � ReceiptGoodsChild, �.�. �� �� ����� ��� � zc_ObjectLink_ProdColorPattern_Goods
                                       LEFT JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                           AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                       -- �������� � ������
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                            AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                 )

                           -- �������� ReceiptProdModelChild
                         , tmpRes AS (SELECT -- ������ ����� � ������� ProdModel
                                             tmpReceiptProdModelChild.ModelId
                                             --
                                           , tmpReceiptProdModelChild.isMain
                                           , tmpReceiptProdModelChild.ReceiptProdModelId
                                           , tmpReceiptProdModelChild.ReceiptProdModelChildId
                                             -- ������� ReceiptProdModelChild
                                           , tmpReceiptProdModelChild.ObjectId
                                             -- ��������
                                           , tmpReceiptProdModelChild.Value
                                             --
                                           , 0 AS ReceiptGoodsChildId
                                           , 0 AS ProdColorPatternId
                                      FROM tmpReceiptProdModelChild
                                           LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                                      WHERE tmpReceiptGoodsChild.ReceiptProdModelChildId IS NULL
                                     UNION ALL
                                      SELECT tmpReceiptGoodsChild.ModelId
                                           , tmpReceiptGoodsChild.isMain
                                           , tmpReceiptGoodsChild.ReceiptProdModelId
                                           , tmpReceiptGoodsChild.ReceiptProdModelChildId
                                           , tmpReceiptGoodsChild.GoodsId AS ObjectId
                                             -- ��������
                                           , tmpReceiptGoodsChild.Value
                                             --
                                           , tmpReceiptGoodsChild.ReceiptGoodsChildId
                                           , tmpReceiptGoodsChild.ProdColorPatternId
                                      FROM tmpReceiptGoodsChild
                                     )
       --
       SELECT tmpRes.ModelId
              --
            , tmpRes.isMain
            , tmpRes.ReceiptProdModelId
            , tmpRes.ReceiptProdModelChildId
              -- ������� ReceiptProdModelChild
            , tmpRes.ObjectId
              -- ��������
            , tmpRes.Value :: TFloat AS Value
              --
            , tmpRes.ReceiptGoodsChildId
            , tmpRes.ProdColorPatternId

            , Object_ProdOptions.Id         AS ProdOptionsId
            , Object_ProdOptions.ObjectCode AS ProdOptionsCode
            , Object_ProdOptions.ValueData  AS ProdOptionsName

             -- ���� ��. ��� ���
            , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
              -- ���� ��. � ���
            , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0)
                 * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT-- ������ ������� ���� � ���, �� 4 ������

             -- ���� ������� ��� ���
           , CASE WHEN vbPriceWithVAT = FALSE
                   THEN COALESCE (ObjectFloat_SalePrice.ValueData, tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
                   ELSE CAST (COALESCE (ObjectFloat_SalePrice.ValueData, tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
             END ::TFloat  AS BasisPrice   -- ����������� ���� - ���� ��� ���

             -- ���� ������� � ���
           , CASE WHEN vbPriceWithVAT = FALSE
                   THEN CAST ( COALESCE (ObjectFloat_SalePrice.ValueData, tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                   ELSE COALESCE (ObjectFloat_SalePrice.ValueData, tmpPriceBasis.ValuePrice, ObjectFloat_ReceiptService_SalePrice.ValueData, 0)
             END ::TFloat  AS BasisPriceWVAT

       FROM tmpRes
            LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                                 ON ObjectLink_ProdOptions.ObjectId = tmpRes.ProdColorPatternId
                                AND ObjectLink_ProdOptions.DescId   = zc_ObjectLink_ProdColorPattern_ProdOptions()
            LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId

            -- Options
            LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                  ON ObjectFloat_SalePrice.ObjectId = Object_ProdOptions.Id
                                 AND ObjectFloat_SalePrice.DescId   = zc_ObjectFloat_ProdOptions_SalePrice()
            LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_TaxKind
                                 ON ObjectLink_ProdOptions_TaxKind.ObjectId = Object_ProdOptions.Id
                                AND ObjectLink_ProdOptions_TaxKind.DescId   = zc_ObjectLink_ProdOptions_TaxKind()

            -- ���� ��� ������/������ ����. ��� ���
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                  ON ObjectFloat_ReceiptService_EKPrice.ObjectId = tmpRes.ObjectId
                                 AND ObjectFloat_ReceiptService_EKPrice.DescId   = zc_ObjectFloat_ReceiptService_EKPrice()
            -- ���� ��� ������/������ ������� ��� ���
            LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice
                                  ON ObjectFloat_ReceiptService_SalePrice.ObjectId = tmpRes.ObjectId
                                 AND ObjectFloat_ReceiptService_SalePrice.DescId   = zc_ObjectFloat_ReceiptService_SalePrice()
            -- ������ / ������ ��� ���
            LEFT JOIN ObjectLink AS ObjectLink_ReceiptService_TaxKind
                                 ON ObjectLink_ReceiptService_TaxKind.ObjectId = tmpRes.ObjectId
                                AND ObjectLink_ReceiptService_TaxKind.DescId   = zc_ObjectLink_ReceiptService_TaxKind()

            LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                  ON ObjectFloat_EKPrice.ObjectId = tmpRes.ObjectId
                                 AND ObjectFloat_EKPrice.DescId   = zc_ObjectFloat_Goods_EKPrice()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                 ON ObjectLink_Goods_TaxKind.ObjectId = tmpRes.ObjectId
                                AND ObjectLink_Goods_TaxKind.DescId   = zc_ObjectLink_Goods_TaxKind()

            LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                  ON ObjectFloat_TaxKind_Value.ObjectId = COALESCE (ObjectLink_ProdOptions_TaxKind.ChildObjectId, ObjectLink_Goods_TaxKind.ChildObjectId, ObjectLink_ReceiptService_TaxKind.ChildObjectId)
                                 AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

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
-- SELECT * FROM lpSelect_Object_ReceiptProdModelChild_detail (zfCalc_UserAdmin() :: Integer)
