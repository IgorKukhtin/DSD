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
                                    , CurrencyId_pl = COALESCE (ObjectHistoryLink_Currency.ObjectId, zc_Currency_Basis())
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
            LEFT JOIN ObjectHistoryLink AS ObjectHistoryLink_Currency
                                        ON ObjectHistoryLink_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                       AND ObjectHistoryLink_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
       WHERE Object_PartionGoods.GoodsId          = inGoodsId
         AND OL_PriceListItem_Goods.ChildObjectId = Object_PartionGoods.GoodsId
         AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
         AND (Object_PartionGoods.OperPriceList   <> COALESCE (OHF_PriceListItem_Value.ValueData, 0)                     -- ������ - ������ ���� �������� ����������
           OR Object_PartionGoods.CurrencyId_pl   <> COALESCE (ObjectHistoryLink_Currency.ObjectId, zc_Currency_Basis()) -- ������ - ������ ���� �������� ����������
             )
      ;

      -- ���� ���� ��������� - ���� �������� � Object_GoodsPrint - ����� ����������� ������ � ����� �����
      IF FOUND AND inUserId <> zc_User_Sybase()
      THEN
          -- ? �� ���� ������� ?
          PERFORM lpInsertUpdate_Object_GoodsPrint (ioOrd       := 0
                                                  , ioUserId    := inUserId
                                                  , inUnitId    := Container.WhereObjectId
                                                  , inPartionId := Object_PartionGoods.MOvementItemId
                                                  , inAmount    := Container.Amount
                                                  , inIsReprice := TRUE      -- ����������
                                                  , inUserId    := inUserId
                                                   )
          FROM Object_PartionGoods
               INNER JOIN Container ON Container.PartionId = Object_PartionGoods.MOvementItemId
                                   AND Container.DescId    = zc_Container_Count()
                                   AND Container.Amount    > 0
               LEFT JOIN ContainerLinkObject AS CLO_Client
                                             ON CLO_Client.ContainerId = Container.Id
                                            AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
          WHERE Object_PartionGoods.GoodsId  = inGoodsId
            -- AND Object_PartionGoods.isErased = FALSE
            AND CLO_Client.ContainerId       IS NULL -- !!!��������� ����� �����������!!!
         ;

      END IF; -- if NOT FOUND


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
