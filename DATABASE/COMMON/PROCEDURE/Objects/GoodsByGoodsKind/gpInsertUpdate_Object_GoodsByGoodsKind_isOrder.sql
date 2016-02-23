-- Function: gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_isOrder(
 INOUT ioId                  Integer  , -- ���� ������� <�����>
    IN inIsOrder             Boolean  , -- ������������ � �������
    IN inSession             TVarChar 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isOrder());

   -- ��������
   IF COALESCE (ioId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� �������.';
   END IF;
   
   -- ��������� �������� <������������ � �������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inIsOrder);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.02.16         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (inGoodsId:= 1, inGoodsKindId:= 1, inUserId:= 2)
