-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLink(Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsMainId         Integer   ,    -- ������ �� ������� �����
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   
   -- !!! �������� ������������ <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Goods(), inName);

   -- �������� ������������ <���>
   -- PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), vbCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), 0, inName);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsMain(), ioId, inGoodsMainId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� �������� <���>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_NDSKind(), ioId, inNDSKindId );
  

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
