-- Function: lpGetInsert_Object_PriceListItem(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpGetInsert_Object_PriceListItem (Integer, Integer);
DROP FUNCTION IF EXISTS lpGetInsert_Object_PriceListItem (Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpGetInsert_Object_PriceListItem (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetInsert_Object_PriceListItem(
    IN inPriceListId         Integer,      -- �����-����
    IN inGoodsId             Integer,      -- �����
    IN inGoodsKindId         Integer,      -- ��� �����
    IN inUserId              Integer
)
RETURNS Integer
AS
$BODY$
DECLARE vbId Integer;
BEGIN
   

   IF COALESCE (inGoodsKindId,0) > 0
   THEN  
       -- ���� ������ ������ �� ���������� ���� � �����
       -- RAISE EXCEPTION '������.��������� ���������� ���� �� ���� ������.';
       -- �����
       vbId:= (SELECT ObjectLink_PriceListItem_Goods.ObjectId
               FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                    JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                    ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                   AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                   AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                    JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                    ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                   AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
                                   AND ObjectLink_PriceListItem_GoodsKind.ChildObjectId = inGoodsKindId
               WHERE ObjectLink_PriceListItem_Goods.DescId            = zc_ObjectLink_PriceListItem_Goods()
                 AND ObjectLink_PriceListItem_Goods.ChildObjectId     = inGoodsId
              );
   ELSE
        -- �����
       vbId:= (SELECT ObjectLink_PriceListItem_Goods.ObjectId
               FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                    JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                    ON ObjectLink_PriceListItem_PriceList.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                   AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                   AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                    LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                         ON ObjectLink_PriceListItem_GoodsKind.ObjectId      = ObjectLink_PriceListItem_Goods.ObjectId
                                        AND ObjectLink_PriceListItem_GoodsKind.DescId        = zc_ObjectLink_PriceListItem_GoodsKind()
               WHERE ObjectLink_PriceListItem_Goods.DescId            = zc_ObjectLink_PriceListItem_Goods()
                 AND ObjectLink_PriceListItem_Goods.ChildObjectId     = inGoodsId
                 AND ObjectLink_PriceListItem_GoodsKind.ChildObjectId IS NULL
              );
   END IF;


  -- �����
  IF COALESCE (vbId, 0) = 0 THEN
     -- ��������� <������>
     vbId := lpInsertUpdate_Object(0, zc_Object_PriceListItem(), 0, '');

     --
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PriceListItem_PriceList(), vbId, inPriceListId);
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PriceListItem_Goods()    , vbId, inGoodsId);
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PriceListItem_GoodsKind(), vbId, inGoodsKindId);

     -- ��������� �������� <���� ��������> - ����� �.�. ����������� � ��������� �������
     -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������������ (��������)> - ����� �.�. ����������� � ��������� �������
     -- PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbId, inUserId);

  END IF;

  -- ������� ��������
  RETURN vbId;

END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.11.19         *
 26.11.19                                        *
 06.06.13                        *
*/

-- ����
-- SELECT * FROM lpGetInsert_Object_PriceListItem()
