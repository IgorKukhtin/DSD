-- Function: gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsItem(
 INOUT ioId           Integer,       -- ���� ������� <������ � ���������>            
    IN inGoodsId      Integer,       -- ���� ������� <������>             
    IN inGoodsSizeId  Integer,       -- ���� ������� <������ ������>
    IN inIsErased     Boolean,       -- ������ (��/���)	�������� - ���� ��� ������� �������, ��� � �������� ����������� ��������
    IN inisArc        Boolean,       -- �������� (��/���) ����� �������� "������" ��������, �� ������� �������� ����������� �������
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsInfo(), 0, '');

   -- ��������� ������ (��/���)	�������� - ���� ��� ������� �������, ��� � �������� ����������� ��������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsItem_isErased(), ioId, inIsErased);
   -- ��������� �������� (��/���) ����� �������� "������" ��������, �� ������� �������� ����������� �������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsItem_isArc(), ioId, inisArc);

   -- ��������� ����� � <������> 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsInfo_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <������ ������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsInfo_GoodsSize(), ioId, inGoodsSizeId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
10.03.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsInfo()
