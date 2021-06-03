-- Function: gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_isOrder(
 INOUT ioId                  Integer  , -- ���� ������� <�����>
    IN inGoodsId             Integer  , -- ������
    IN inGoodsKindId         Integer  , -- ���� �������
    IN inIsOrder             Boolean  , -- ������������ � �������
    IN inIsNotMobile         Boolean  , -- �� ������������ � ���.������
    IN inSession             TVarChar 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsOrder Boolean;
   DECLARE vbIsNotMobile Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isOrder());


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

   --�������� ���� inIsOrder � inIsNotMobile �� �������� �������, ������ ������� isTop - ������ ����� � ������
   vbIsOrder     :=(SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId AND ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()) :: Boolean;
   vbIsNotMobile :=(SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId AND ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_NotMobile()):: Boolean;
   IF COALESCE (vbIsNotMobile,False) = COALESCE (inIsNotMobile,False) AND COALESCE (vbIsOrder,False) = COALESCE (inIsOrder,False)
   THEN
       RETURN;
   END IF;
   
   -- �������� - ��� � ����� ������ �� �����
   IF vbUserId = 5
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
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inIsOrder);

   -- ��������� �������� <������������ � �������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_NotMobile(), ioId, inIsNotMobile);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.06.17         * add NotMobile
 24.03.16                                        * 
 23.02.16         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (inGoodsId:= 1, inGoodsKindId:= 1, inUserId:= 2)
