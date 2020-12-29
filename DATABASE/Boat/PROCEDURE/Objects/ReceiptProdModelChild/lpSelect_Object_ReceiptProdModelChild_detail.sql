-- Function: gpSelect_Object_ReceiptProdModelChild()

DROP FUNCTION IF EXISTS lpSelect_Object_ReceiptProdModelChild_detail (TVarChar);

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
              )
AS
$BODY$
BEGIN

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
       FROM tmpRes
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
