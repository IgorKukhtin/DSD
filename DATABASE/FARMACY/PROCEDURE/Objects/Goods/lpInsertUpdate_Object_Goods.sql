-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId        Integer   ,    -- ������ �������
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDSKindId           Integer   ,    -- ���
    IN inGoodsMainId         Integer   ,    -- ������ �� ������� �����
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����
    IN inUserId              Integer        -- ������������
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE vbCode Integer;   
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   -- !!! �������� ������������ <������������>
   IF EXISTS (SELECT GoodsName FROM Object_Goods_View AND GoodsName = inName AND Id <> COALESCE(inId, 0) ) THEN
      RAISE EXCEPTION '�������� "%" �� ��������� ��� ����������� "������"', inName;
   END IF; 

   -- !!! �������� ������������ <���>
   IF EXISTS (SELECT ObjectCode FROM Object WHERE DescId = inDescId AND ObjectCode = inObjectCode AND Id <> COALESCE( inId, 0) ) THEN
      SELECT ItemName INTO ObjectName FROM ObjectDesc WHERE Id = inDescId;
      RAISE EXCEPTION '�������� "%" �� ��������� ��� ����������� "%"', inObjectCode, ObjectName;
   END IF; 

   vbCode := inCode::Integer;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), vbCode, inName);

   IF COALESCE(inObjectId, 0) <> 0 THEN
      -- ��������� ���
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Code(), vbGoodsId, inCode);
      -- ��������� �������� <����� ��� ������>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), ioId, inObjectId);
      -- ��������� ����� � <������� �������>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsMain(), vbGoodsId, inGoodsMainId);
   END; 

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� �������� <���>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_NDSKind(), ioId, inNDSKindId );

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.07.14                        *
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
