-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MainGoods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MainGoods(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId        Integer   ,    -- ������ �������
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDSKindId           Integer   ,    -- ���
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserName TVarChar;
   DECLARE vbObjectId Integer;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   vbUserId := lpGetUserBySession (inSession);
   vbObjectId := 0;

   IF COALESCE(inMeasureId, 0) = 0 THEN
      RAISE EXCEPTION '������� ��������� ������ ���� ����������';
   END IF; 

   IF COALESCE(inNDSKindId, 0) = 0 THEN
      RAISE EXCEPTION '��� ��� ������ ���� ���������';
   END IF; 

   
   ioId := lpInsertUpdate_Object_Goods(ioId, inCode, inName, inGoodsGroupId, inMeasureId, inNDSKindId, vbObjectId, vbUserId);

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MainGoods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
