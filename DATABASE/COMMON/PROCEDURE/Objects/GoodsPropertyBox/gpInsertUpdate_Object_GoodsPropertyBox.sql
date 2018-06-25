-- Function: gpInsertUpdate_Object_GoodsPropertyBox (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsPropertyBox (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyBox(
 INOUT ioId                   Integer  , -- ���� ������� <>
    IN inBoxId                Integer  , -- ����
    IN inGoodsId              Integer  , -- ������
    IN inGoodsKindId          Integer  , -- ���� �������
    IN inCountOnBox           TFloat   , -- ���������� ��. � ��.
    IN inWeightOnBox          TFloat   , -- ���������� ��. � ��.
    IN inSession              TVarChar 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyBox());

   -- ��������
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
   END IF;

   -- �������� ������������
   IF EXISTS (SELECT ObjectLink_GoodsPropertyBox_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsPropertyBox_Goods
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_GoodsKind
                                        ON ObjectLink_GoodsPropertyBox_GoodsKind.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                       AND ObjectLink_GoodsPropertyBox_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyBox_GoodsKind()
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyBox_Box
                                        ON ObjectLink_GoodsPropertyBox_Box.ObjectId = ObjectLink_GoodsPropertyBox_Goods.ObjectId
                                       AND ObjectLink_GoodsPropertyBox_Box.DescId = zc_ObjectLink_GoodsPropertyBox_Box()
              WHERE ObjectLink_GoodsPropertyBox_Goods.DescId = zc_ObjectLink_GoodsPropertyBox_Goods()
                AND ObjectLink_GoodsPropertyBox_Box.ChildObjectId = inBoxId
                AND ObjectLink_GoodsPropertyBox_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsPropertyBox_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsPropertyBox_Goods.ObjectId <> COALESCE (ioId, 0))

   THEN 
       RAISE EXCEPTION '������.��������  <%> + <%> + <%> ��� ���� � �����������. ������������ ���������.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId), lfGet_Object_ValueData (inBoxId);
   END IF;   

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsPropertyBox(), 0, '');
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyBox_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyBox_GoodsKind(), ioId, inGoodsKindId);

   -- ��������� ����� � <����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPropertyBox_Box(), ioId, inBoxId);

   -- ��������� �������� <���������� ��. � ��.>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyBox_WeightOnBox(), ioId, inWeightOnBox);
   -- ��������� �������� <���������� ��. � ��.>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsPropertyBox_CountOnBox(), ioId, inCountOnBox);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  
 24.06.18         *
*/

-- ����
-- 
