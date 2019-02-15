-- Function: lpInsertUpdate_Object_LinkGoods(Integer, TFloat, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_LinkGoods (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_LinkGoods(
 INOUT ioId               Integer   , -- ���� ������� <������� ��������>
    IN inGoodsMainId      Integer   , -- ������� �����
    IN inGoodsId          Integer   , -- ����� ��� ������
    IN inUserId           Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsUpdate Boolean;
BEGIN
   -- ��������
   IF COALESCE (inGoodsMainId, 0) = 0 THEN
      RAISE EXCEPTION '������.������� ����� �� ���������';
   END IF;
   -- ��������
   IF COALESCE (inGoodsId, 0) = 0 THEN
      RAISE EXCEPTION '������.����� �� ���������';
   END IF;


   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_LinkGoods(), 0, '');

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LinkGoods_GoodsMain(), ioId, inGoodsMainId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LinkGoods_Goods(), ioId, inGoodsId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= inUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.02.19                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_LinkGoods (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
