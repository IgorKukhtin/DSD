-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId        Integer   ,    -- ������ �������
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDSKindId           Integer   ,    -- ���
    IN inGoodsMainId         Integer   ,    -- ������ �� ������� �����
    IN inObjectId            Integer   ,    -- �� ���� ��� �������� ����

    IN inSession             TVarChar       -- ������� ������������
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE vbCode Integer;   
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   ioId := lpInsertUpdate_Object_Goods(ioId, inCode, inName, inGoodsGroupId, inMeasureId, vbNDSKindId, inGoodsMainId, inObjectId, inSession);
 

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
