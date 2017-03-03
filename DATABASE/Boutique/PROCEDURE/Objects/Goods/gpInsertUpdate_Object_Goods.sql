-- Function: gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                       Integer   ,    -- ���� ������� <������> 
    IN inCode                     Integer   ,    -- ��� ������� <������>     
    IN inName                     TVarChar  ,    -- �������� ������� <������>
    IN inGoodsGroupId             Integer   ,    -- ���� ������� <������ �������> 
    IN inMeasureId                Integer   ,    -- ���� ������� <������� ���������> 
    IN inCompositionId            Integer   ,    -- ���� ������� <������ ������> 
    IN inGoodsInfoId              Integer   ,    -- ���� ������� <�������� ������> 
    IN inLineFabricaID            Integer   ,    -- ���� ������� <����� ���������> 
    IN inLabelId                  Integer   ,    -- ���� ������� <�������� ��� �������> 
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGroupNameFull TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Goods_seq'); END IF; 

   -- �������� ���� ������������ ��� �������� <������������>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Goods(), inName);

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), inCode, inName);

   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());
 
   -- ��������� ������ �������� ������ + 
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
  
   -- ��������� ����� � <������ �������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- ��������� ����� � <������� ���������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� ����� � <������ ������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Composition(), ioId, inCompositionId);
   -- ��������� ����� � <�������� ������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsInfo(), ioId, inGoodsInfoId);
   -- ��������� ����� � <����� ���������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_LineFabrica(), ioId, inLineFabricaId);
   -- ��������� ����� � <�������� ��� �������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Label(), ioId, inLabelId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
03.03.17                                                           *
02.03.17                                                           *
01.03.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods()
