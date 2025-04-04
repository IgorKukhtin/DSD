-- Function: lpGetInsert_Object_PriceListItem(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpGetInsert_Object_PriceListItem (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetInsert_Object_PriceListItem(
    IN inPriceListId         Integer,      -- �����-����
    IN inGoodsId             Integer,      -- �����
    IN inUserId              Integer
)
RETURNS Integer
AS
$BODY$
DECLARE vbId Integer;
BEGIN
   

   -- �����
   vbId:= (SELECT ObjectLink_PriceListItem_Goods.ObjectId
           FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                               AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                               AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
           WHERE ObjectLink_PriceListItem_Goods.DescId            = zc_ObjectLink_PriceListItem_Goods()
             AND ObjectLink_PriceListItem_Goods.ChildObjectId     = inGoodsId
          );

  -- �����
  IF COALESCE (vbId, 0) = 0 THEN
     -- ��������� <������>
     vbId := lpInsertUpdate_Object(0, zc_Object_PriceListItem(), 0, '');

     --
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PriceListItem_PriceList(), vbId, inPriceListId);
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PriceListItem_Goods()    , vbId, inGoodsId);

  END IF;

  -- ������� ��������
  RETURN vbId;

END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.20         *
*/

-- ����
-- SELECT * FROM lpGetInsert_Object_PriceListItem()
