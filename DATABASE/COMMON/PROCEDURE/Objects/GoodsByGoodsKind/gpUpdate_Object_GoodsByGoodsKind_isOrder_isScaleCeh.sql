-- Function: gpUpdate_Object_GoodsByGoodsKind_isOrder_isScaleCeh (Integer, Integer, Integer)

--DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_isOrder_isScaleCeh (Integer, Integer, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_isOrder_isScaleCeh (Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsByGoodsKind_isOrder_isScaleCeh(
 INOUT ioId                  Integer  , -- ���� ������� <�����>
    IN inGoodsId             Integer  , -- ������
    IN inGoodsKindId         Integer  , -- ���� �������
    IN inIsOrder             Boolean  , -- ������������ � �������
    IN inIsScaleCeh          Boolean  , -- ������������ � ScaleCeh 
    IN inisRK                Boolean  , -- ����������� �� ��
    IN inSession             TVarChar 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_GoodsByGoodsKind_OrderScaleCeh());


   -- �������� ������������
   IF EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
              WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION '������.��������  <%> + <%> ��� ���� � �����������. ������������ ���������.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;   

   -- �������� - ��� � ����� ������ �� �����
   IF vbUserId = 5 AND 1=1
   THEN
       RAISE EXCEPTION '������.��� ���� - ��� � ����� ������ �� �����.';
   END IF;


   IF COALESCE (ioId, 0) = 0 
   THEN
       -- ��������� <������>
       ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsByGoodsKind(), 0, '');
       -- ��������� ����� � <������>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), ioId, inGoodsId);

       -- ��������� ����� � <���� �������>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), ioId, inGoodsKindId);

   ELSE
       -- ��������
       IF NOT EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                      FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                               AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                      WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                        AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                        AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                        AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId = ioId)
       THEN 
           RAISE EXCEPTION '������.��� ���� �������� �������� <��� ��������>.';
       END IF;   

   END IF;
   
   -- ��������� �������� <������������ � �������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inisOrder);
   -- ��������� �������� <������������ � ScaleCeh>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_ScaleCeh(), ioId, inisScaleCeh);
   -- ��������� �������� <����������� �� ��>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_RK(), ioId, inisRK);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.22         * inisRK
 01.03.17         * 
*/

-- ����
-- SELECT * FROM gpUpdate_Object_GoodsByGoodsKind_isOrder_isScaleCeh (inGoodsId:= 1, inGoodsKindId:= 1, inUserId:= 2)
