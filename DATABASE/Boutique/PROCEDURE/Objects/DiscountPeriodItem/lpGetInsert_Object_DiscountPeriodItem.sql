-- Function: lpGetInsert_Object_DiscountPeriodItem(Integer,Integer,Integer)

DROP FUNCTION IF EXISTS lpGetInsert_Object_DiscountPeriodItem (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetInsert_Object_DiscountPeriodItem(
    IN inUnitId         Integer,      -- �������������
    IN inGoodsId        Integer,      -- �����
    IN inUserId         Integer
)
RETURNS Integer
AS
$BODY$
DECLARE vbId Integer;
BEGIN

   -- �����
   SELECT ObjectLink_DiscountPeriodItem_Goods.ObjectId INTO vbId
   FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
        JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
          ON ObjectLink_DiscountPeriodItem_Unit.ObjectId = ObjectLink_DiscountPeriodItem_Goods.ObjectId
         AND ObjectLink_DiscountPeriodItem_Unit.DescId = zc_ObjectLink_DiscountPeriodItem_Unit()
         AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
   WHERE ObjectLink_DiscountPeriodItem_Goods.DescId = zc_ObjectLink_DiscountPeriodItem_Goods()
     AND ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = inGoodsId;


  IF COALESCE (vbId, 0) = 0 THEN
     -- ��������� <������>
     vbId := lpInsertUpdate_Object(0, zc_Object_DiscountPeriodItem(), 0, '');

     --
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_DiscountPeriodItem_Unit(), vbId, inUnitId);

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_DiscountPeriodItem_Goods(), vbId, inGoodsId);
     -- ��������� �������� <���� ��������>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������������ (��������)>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbId, inUserId);

  END IF;

  -- ������� ��������
  RETURN vbId;

END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.04.17         *

*/

-- ����
-- SELECT * FROM lpGetInsert_Object_DiscountPeriodItem()