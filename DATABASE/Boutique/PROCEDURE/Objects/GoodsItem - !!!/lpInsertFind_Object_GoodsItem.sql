-- Function: gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_GoodsItem (Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertFind_Object_GoodsItem (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_GoodsItem(
    IN inGoodsId      Integer,       -- ���� ������� <�����>
    IN inGoodsSizeId  Integer,       -- ���� ������� <������ ������>
    IN inPartionId    Integer,       -- ���� ������� <������ ������>
    IN inUserId       Integer        --
)
RETURNS Integer
AS
$BODY$
   DECLARE vbId Integer;
BEGIN
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inGoodsSizeId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������ ������>.';
     END IF;


     -- ������� �� ��-���
     vbId:= (SELECT Object_GoodsItem.Id FROM Object_GoodsItem WHERE Object_GoodsItem.GoodsId = inGoodsId AND Object_GoodsItem.GoodsSizeId = inGoodsSizeId);

     -- ���� �� �����, �� ������ ��� ����
     IF inPartionId > 0 AND COALESCE (vbId, 0) = 0
     THEN
         -- ������� �� ������
         vbId:= (SELECT Object_PartionGoods.GoodsItemId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId);
     
         -- ������ - ���� ���� ������� ����������� ����� ������ - inPartionId
         IF 1 = (SELECT COUNT(*) FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsItemId = vbId)
         THEN
             -- �������� �������
             UPDATE Object_GoodsItem SET GoodsId = inGoodsId, GoodsSizeId = inGoodsSizeId WHERE Id = vbId ;
         
             -- ���� ����� ������� �� ��� �������
             IF NOT FOUND THEN
                RAISE EXCEPTION '������.����� ������� �� ��� ������� <%> <%>.', vbId, inPartionId;
             END IF; -- if NOT FOUND

         ELSE

             -- ������� ��� �� �����, �.�. ���� ����� ������� INSERT
             vbId:= 0;

         END IF; -- if 1 = ...
         
     END IF;

     -- ���� �� �����
     IF COALESCE (vbId, 0) = 0
     THEN
          -- �������� ����� �������
          INSERT INTO Object_GoodsItem (GoodsId, GoodsSizeId)
                                VALUES (inGoodsId, inGoodsSizeId) RETURNING Id INTO vbId;

     END IF; -- if COALESCE (vbId, 0) = 0

     -- ���������� ��������
     RETURN (vbId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
24.04.17                                         *
*/

-- ����
--