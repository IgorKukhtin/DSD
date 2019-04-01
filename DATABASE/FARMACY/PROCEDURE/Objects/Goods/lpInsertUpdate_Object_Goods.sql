-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId        Integer   ,    -- ������ �������
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDSKindId           Integer   ,    -- ���
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����
    IN inUserId              Integer   ,    -- 
    IN inMakerId             Integer   ,    -- �������������
    IN inMakerName           TVarChar  ,    -- �������������
    IN inCheckName           Boolean  DEFAULT true ,
    IN inAreaId              Integer  DEFAULT 0,      -- 
    IN inNameUkr             TVarChar DEFAULT '',     -- �������� ����������
    IN inCodeUKTZED          TVarChar DEFAULT '',    -- ��� ������
    IN inExchangeId          Integer  DEFAULT 0,       -- ��:
    IN inGoodsAnalogId       Integer  DEFAULT 0      -- ������� ������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbCode Integer;
BEGIN
   -- !!!�������� ������������ <������������> ��� "������" inObjectId
   IF inCheckName = TRUE
   THEN
      IF EXISTS (SELECT GoodsName
                 FROM Object_Goods_View 
                 WHERE GoodsName = inName AND Id <> COALESCE(ioId, 0)
                   AND ((ObjectId IS NULL AND inObjectId = 0)
                     OR (ObjectId = inObjectId AND inObjectId <> 0))
                   AND (-- ���� ������ ������������
                        COALESCE (Object_Goods_View.AreaId, 0) = inAreaId
                        -- ��� ��� ������ zc_Area_Basis - ����� ���� � ������� "�����"
                     OR (inAreaId = zc_Area_Basis() AND Object_Goods_View.AreaId IS NULL)
                        -- ��� ��� ������ "�����" - ����� ���� � ������� zc_Area_Basis
                     OR (inAreaId = 0 AND Object_Goods_View.AreaId = zc_Area_Basis())
                       )
                )
      THEN
          RAISE EXCEPTION '�������� <(%)%>%�� ��������� ��� ����������� %.', inCode, inName
                        , CASE WHEN COALESCE (inObjectId, 0) = 0 THEN '' ELSE ' � �������� ���� <' || COALESCE (lfGet_Object_ValueData (inObjectId), 'NULL') || '> ' END
                        , CASE WHEN COALESCE (inObjectId, 0) = 0 THEN '<������ - �����>' ELSE '<������>' END;
      END IF; 
   END IF;

   -- �������� ������������ <���>
   IF COALESCE (inObjectId, 0) = 0 -- AND inUserId <> 3 -- !!!������ ����� ������ ����� ����!!!
   THEN
      -- !!!��� "������ �����������" - GoodsCodeInt
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
                 WHERE GoodsCodeInt = inCode :: Integer AND Id <> COALESCE (ioId, 0)
                   AND ObjectId IS NULL
                )
      THEN
         RAISE EXCEPTION '��� "%" �� ��������� ��� ����������� "������"', inCode;
      END IF; 
   ELSE
      -- !!!��� inObjectId - GoodsCode (TVarChar)
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
                 WHERE GoodsCode = inCode AND Id <> COALESCE (ioId, 0)
                   AND ObjectId = inObjectId 
                   AND (-- ���� ������ ������������
                        COALESCE (Object_Goods_View.AreaId, 0) = inAreaId
                        -- ��� ��� ������ zc_Area_Basis - ����� ���� � ������� "�����"
                     OR (inAreaId = zc_Area_Basis() AND Object_Goods_View.AreaId IS NULL)
                        -- ��� ��� ������ "�����" - ����� ���� � ������� zc_Area_Basis
                     OR (inAreaId = 0 AND Object_Goods_View.AreaId = zc_Area_Basis())
                       )
                )
      THEN
         RAISE EXCEPTION '��� "%" �� ��������� ��� ����������� "������"', inCode;
      END IF; 
   END IF;
   
   -- ������� ������������� ���
   BEGIN
        vbCode:= inCode :: Integer;
   EXCEPTION           
            WHEN data_exception
            THEN vbCode := 0;
   END;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), vbCode, inName);

   -- ���� �� �� "������ �����������"
   IF COALESCE (inObjectId, 0) <> 0
   THEN
      -- ��������� ���
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Code(), ioId, inCode);
      -- ��������� �������� <����� ��� ������>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), ioId, inObjectId);

   ELSE
       -- ����� �������� ��� ����� �� "������ �����������"
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_isMain(), ioId, TRUE);
   END IF; 


   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� �������� <���>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_NDSKind(), ioId, inNDSKindId );

   -- ��������� �������� <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Maker(), ioId, inMakerId);
   -- ��������� �������� <�������������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), ioId, inMakerName);

   -- ��������� �������� <�������� ����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_NameUkr(), ioId, inNameUkr);
   -- ��������� �������� <��� ������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CodeUKTZED(), ioId, inCodeUKTZED);
   -- ��������� �������� <��>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Exchange(), ioId, inExchangeId);
   -- ��������� �������� <������� ������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsAnalog(), ioId, inGoodsAnalogId);

   -- ��������� �������� - !!!������ ��� "������ �����������"!!!
   IF COALESCE (inObjectId, 0) = 0
   THEN
       PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   END IF; 


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer, Integer) OWNER TO postgres;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.09.18                                                       *
 22.10.14                        *
 29.07.14                        *
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
