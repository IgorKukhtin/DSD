-- Function: lpUpdate_Object_PartionGoods_OperPriceList

DROP FUNCTION IF EXISTS lpUpdate_Object_PartionGoods_PriceSale (Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_PartionGoods_OperPriceList (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_PartionGoods_OperPriceList(
    IN inGoodsId                Integer,       -- �����
    IN inUserId                 Integer        --
)
RETURNS VOID
AS
$BODY$
BEGIN

       -- �������� �� ���� ������� ������
       UPDATE Object_PartionGoods SET OperPriceList = COALESCE (OHF_PriceListItem_Value.ValueData, 0)
       FROM ObjectLink AS OL_PriceListItem_Goods
            INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                  ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                 AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                 AND OL_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis() -- !!!������� �����!!!
            LEFT JOIN ObjectHistory AS OH_PriceListItem
                                    ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                   AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                   AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!��������� ��������!!!
            LEFT JOIN ObjectHistoryFloat AS OHF_PriceListItem_Value
                                         ON OHF_PriceListItem_Value.ObjectHistoryId = OH_PriceListItem.Id
                                        AND OHF_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
       WHERE Object_PartionGoods.GoodsId          = inGoodsId
         AND OL_PriceListItem_Goods.ChildObjectId = Object_PartionGoods.GoodsId
         AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
         AND Object_PartionGoods.OperPriceList    <> COALESCE (OHF_PriceListItem_Value.ValueData, 0) -- ������ - ������ ���� �������� ����������
      ;

                                     
END;                                 
$BODY$                               
  LANGUAGE plpgsql VOLATILE;           
                                     
/*------------------------------     -------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
06.06.17                                         *
*/
/*
       -- �������� �� ���� ������� ������
       UPDATE Object_PartionGoods SET OperPriceList = COALESCE (OHF_PriceListItem_Value.ValueData, 0)
       FROM ObjectLink AS OL_PriceListItem_Goods
            INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                  ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                 AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                 AND OL_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis() -- !!!������� �����!!!
            LEFT JOIN ObjectHistory AS OH_PriceListItem
                                    ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                   AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                   AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!��������� ��������!!!
            LEFT JOIN ObjectHistoryFloat AS OHF_PriceListItem_Value
                                         ON OHF_PriceListItem_Value.ObjectHistoryId = OH_PriceListItem.Id
                                        AND OHF_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
       WHERE OL_PriceListItem_Goods.ChildObjectId = Object_PartionGoods.GoodsId
         AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
         AND COALESCE (Object_PartionGoods.OperPriceList, 0)        <> COALESCE (OHF_PriceListItem_Value.ValueData, 0) -- ������ - ������ ���� �������� ����������
      ;
*/
-- ����
-- SELECT * FROM lpUpdate_Object_PartionGoods_OperPriceList()
