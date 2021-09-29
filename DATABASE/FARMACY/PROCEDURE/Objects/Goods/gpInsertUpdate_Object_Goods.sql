-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId        Integer   ,    -- ������ �������
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDSKindId           Integer   ,    -- ���
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����
    IN inUserId              Integer   ,    -- 
    IN inMakerId             Integer  DEFAULT 0,      -- �������������
    IN inMakerName           TVarChar DEFAULT '',     -- �������������
    IN inCheckName           Boolean  DEFAULT true ,
    IN inAreaId              Integer  DEFAULT 0,      -- 
    IN inNameUkr             TVarChar DEFAULT '',     -- �������� ����������
    IN inCodeUKTZED          TVarChar DEFAULT '',     -- ��� ������
    IN inExchangeId          Integer  DEFAULT 0       -- ��:
)
RETURNS Integer
AS
$BODY$
  DECLARE vbCode Integer;
  DECLARE text_var1 text;
BEGIN

   IF COALESCE(ioId, 0) <> 0 AND inName <> (SELECT Object.ValueData FROM Object WHERE Object.ID = ioId) AND
      EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Retail())
   THEN
     PERFORM lpCheckRight (inUserId::TVarChar, zc_Enum_Process_InsertUpdate_Object_Goods());
   END IF;

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

   -- ������ ������� �����������
   IF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Juridical())
   THEN
     -- ��������� �������� <�������������>
     -- PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Maker(), ioId, inMakerId); ������� �� �������������
     -- ��������� �������� <�������������>
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), ioId, inMakerName);
   END IF;

   -- ��������� �������� <�������� ����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_NameUkr(), ioId, inNameUkr);
   -- ��������� �������� <��� ������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CodeUKTZED(), ioId, inCodeUKTZED);
   -- ��������� �������� <��>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Exchange(), ioId, inExchangeId);
   
    -- ��������� � ������� �������
   BEGIN
   PERFORM lpInsertUpdate_Object_Goods_Flat (ioId             :=  ioId
                                            , inCode           :=  inCode
                                            , inName           :=  inName
                                            , inGoodsGroupId   :=  inGoodsGroupId
                                            , inMeasureId      :=  inMeasureId
                                            , inNDSKindId      :=  inNDSKindId
                                            , inObjectId       :=  inObjectId
                                            , inUserId         :=  inUserId
                                            , inMakerId        :=  inMakerId
                                            , inMakerName      :=  inMakerName
                                            , inCheckName      :=  inCheckName
                                            , inAreaId         :=  inAreaId
                                            , inNameUkr        :=  inNameUkr 
                                            , inCodeUKTZED     :=  inCodeUKTZED
                                            , inExchangeId     :=  inExchangeId);
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat', text_var1::TVarChar, inUserId);
   END;

   -- ��������� �������� - !!!������ ��� "������ �����������"!!!
   IF COALESCE (inObjectId, 0) = 0
   THEN
       PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   END IF; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer) OWNER TO postgres;
  
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