-- Function: gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, TFloat, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind(
 INOUT ioId                  Integer  , -- ���� ������� <�����>
    IN inGoodsId             Integer  , -- ������
    IN inGoodsKindId         Integer  , -- ���� �������
    IN inWeightPackage       TFloat   , -- ��� ������
    IN inWeightTotal         TFloat   , -- ��� ��������
    IN inisOrder             Boolean  , -- ������������ � �������
    IN inUserId              Integer    -- ������������
)
  RETURNS Integer AS    --VOID AS
$BODY$
   DECLARE vbId Integer;
BEGIN

     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.����� �� ���������.';
     END IF;

     -- ���� ����� �� �����, ����� �� ���������
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RETURN;
     END IF;


     -- ���� �� ����� ����� ������, �� ������� �����,
     IF NOT EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                     JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                     ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                    AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = inGoodsKindId
                WHERE ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                  AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
               )
     THEN
         -- ��������� <������>
         ioId := lpInsertUpdate_Object (NULL, zc_Object_GoodsByGoodsKind(), 0, '');
         -- ��������� ����� � <������>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), ioId, inGoodsId);
         -- ��������� ����� � <���� �������>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), ioId, inGoodsKindId);
      END IF;

     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackage(), ioId, inWeightPackage);
     -- ��������� �������� <���>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightTotal(), ioId, inWeightTotal);
      -- ��������� �������� <>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inisOrder);
   
    
     -- ��������� ��������, ���� �� ���� �� �����
     -- PERFORM lpInsert_ObjectProtocol (vbId, inUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, TFloat, TFloat, Boolean, Integer) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.

 19.03.15         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsByGoodsKind (inGoodsId:= 1, inGoodsKindId:= 1, inUserId:= 2)
