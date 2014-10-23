-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, INTEGER, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId        Integer   ,    -- ������ �������
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDSKindId           Integer   ,    -- ���
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����
    IN inUserId              Integer   ,    -- ������������
    IN inMakerId             Integer   ,    -- �������������
    IN inMakerName           TVarChar  ,    -- �������������
    IN inCheckName           boolean  DEFAULT true
)
RETURNS integer AS
$BODY$
  DECLARE vbCode INTEGER;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   
   -- !!! �������� ������������ <������������>
   IF inCheckName THEN
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
           WHERE ((inObjectId = 0 AND ObjectId IS NULL) OR (ObjectId = inObjectId AND inObjectId <> 0))
             AND GoodsName = inName AND Id <> COALESCE(ioId, 0) ) THEN
          RAISE EXCEPTION '�������� "%" �� ��������� ��� ����������� "������"', inName;
      END IF; 
   END IF;

   -- !!! �������� ������������ <���>
   IF inObjectId = 0 THEN
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
               WHERE ObjectId IS NULL 
                 AND GoodsCodeInt = inCode::Integer AND Id <> COALESCE(ioId, 0)  ) THEN
         RAISE EXCEPTION '��� "%" �� ��������� ��� ����������� "������"', inCode;
      END IF; 
   ELSE
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
               WHERE ObjectId = inObjectId 
                 AND GoodsCode = inCode AND Id <> COALESCE(ioId, 0)  ) THEN
         RAISE EXCEPTION '��� "%" �� ��������� ��� ����������� "������"', inCode;
      END IF; 
   END IF;
   
   BEGIN
     vbCode := inCode::Integer;
   EXCEPTION           
     WHEN data_exception THEN
         vbCode := 0;
   END;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), vbCode, inName);

   IF COALESCE(inObjectId, 0) <> 0 THEN
      -- ��������� ���
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Code(), ioId, inCode);
      -- ��������� �������� <����� ��� ������>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), ioId, inObjectId);
   ELSE
      PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Goods_isMain(), ioId, true);
   END IF; 

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� �������� <���>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_NDSKind(), ioId, inNDSKindId );

   -- ��������� �������� <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Maker(), ioId, inMakerId );

   -- ��������� �������� <�������������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), ioId, inMakerName );

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.10.14                        *
 29.07.14                        *
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
