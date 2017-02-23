-- Function: lpInsert_Object_GoodsByGoodsKind (Integer, Integer, Integer)

-- DROP FUNCTION lpInsert_Object_GoodsByGoodsKind (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Object_GoodsByGoodsKind(
    IN inGoodsId      Integer  , -- ������
    IN inGoodsKindId  Integer  , -- ���� �������
    IN inUserId       Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbId Integer;
BEGIN

     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.����� �� ���������.';
     END IF;
     -- ��������
     IF inGoodsId = inGoodsKindId
     THEN
         RAISE EXCEPTION '������.��������� ����� � ��� ������ = <%> <%>.', inGoodsId, inGoodsKindId;
     END IF;


     -- ���� ����� �� �����, ����� �� ���������
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RETURN;
     END IF;

     -- ���� ����� ����� ������, ������ �� ������
     IF EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = inGoodsKindId
                WHERE ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                  AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
               )
     THEN
         RETURN;
     END IF;

     -- ��������� <������>
     vbId := lpInsertUpdate_Object (NULL, zc_Object_GoodsByGoodsKind(), 0, '');
      -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), vbId, inGoodsId);
      -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), vbId, inGoodsKindId);

     -- ��������� ��������, ���� �� ���� �� �����
     -- PERFORM lpInsert_ObjectProtocol (vbId, inUserId);


END;
$BODY$
 LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsert_Object_GoodsByGoodsKind (Integer, Integer, Integer)  OWNER TO postgres;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.07.13                                        *
*/

-- ����
-- SELECT * FROM lpInsert_Object_GoodsByGoodsKind (inGoodsId:= 1, inGoodsKindId:= 1, inUserId:= 2)
