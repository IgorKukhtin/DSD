-- Function: gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                       Integer   ,    -- ���� ������� <�����> 
 INOUT ioCode                     Integer   ,    -- ��� ������� <�����>     
    IN inName                     TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId             Integer   ,    -- ������ ������
    IN inMeasureId                Integer   ,    -- ������� ���������
    IN inCompositionId            Integer   ,    -- ������
    IN inGoodsInfoId              Integer   ,    -- ��������
    IN inLineFabricaID            Integer   ,    -- �����
    IN inLabelId                  Integer   ,    -- �������� � �������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbInfoMoneyId   Integer;
   DECLARE vbGroupNameFull TVarChar;
   DECLARE vbIsInsert      Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��� �������� �� Sybase �.�. ��� ��� �� = 0 
   IF vbUserId = zc_User_Sybase()
   THEN
       -- ��������
       IF COALESCE (ioCode, 0) >= 0 THEN RAISE EXCEPTION 'COALESCE (ioCode, 0) >= 0 : <%>', ioCode; END IF;

       -- ����������
       ioCode:= -1 * ioCode;

   -- ����� ������ - ��� ����� ����� � ioCode -> ioCode
   ELSEIF COALESCE (ioId, 0) = 0
   THEN
       -- ��������
       IF COALESCE (ioCode, 0) <= 0 THEN RAISE EXCEPTION '������.�������� �������� "���������������" �������� ���� : <%>', ioCode; END IF;

       -- ����������
       ioCode:= NEXTVAL ('Object_Goods_seq'); 

   END IF; 

   -- �� ����� ��� �������� �� Sybase �.�. ��� ��� �� = 0 
   -- IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Goods_seq'); 
   -- ELSEIF ioCode = 0
   --       THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   -- END IF; 

   -- ��������
   IF TRIM (inName) = '' THEN
      RAISE EXCEPTION '������.���������� ������ ��������.';
   END IF;

   -- ��������
   IF COALESCE (inGoodsGroupId, 0) = 0 THEN
      RAISE EXCEPTION '������.���������� ������ ������.';
   END IF;

   -- �������� ���� ������������ ��� �������� <��������>
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Goods(), inName);

   -- �������� ������������ ��� �������� <���>
   -- PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), ioCode);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), ioCode, inName);

   -- ������ ��� Update
   IF vbIsInsert = FALSE
   THEN
       -- !!!�� ������ - �������� �������� � ������!!!
       PERFORM lpUpdate_Object_PartionGoods_Goods (inGoodsId       := ioId
                                                 , inGoodsGroupId  := inGoodsGroupId
                                                 , inMeasureId     := inMeasureId
                                                 , inCompositionId := inCompositionId
                                                 , inGoodsInfoId   := inGoodsInfoId
                                                 , inLineFabricaID := inLineFabricaID
                                                 , inLabelId       := inLabelId
                                                 , inUserId        := vbUserId
                                                  );
   END IF;

   -- ������ - ������ �������� ������
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());
   -- �� ��������� ������ ��� ����������� <������ ����������>
   vbInfoMoneyId:= lfGet_Object_GoodsGroup_InfoMoneyId (inGoodsGroupId);

   -- ��������� ������ �������� ������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
  
   -- ��������� ����� � <������ �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- ��������� ����� � <������� ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� ����� � <������ ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Composition(), ioId, inCompositionId);
   -- ��������� ����� � <�������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsInfo(), ioId, inGoodsInfoId);
   -- ��������� ����� � <����� ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_LineFabrica(), ioId, inLineFabricaId);
   -- ��������� ����� � <�������� ��� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Label(), ioId, inLabelId);
   -- ��������� ����� � ***<�� ������ ����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, vbInfoMoneyId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
07.06.17          * add vbInfoMoneyId
13.05.17                                                           *
03.03.17                                                           *
02.03.17                                                           *
01.03.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods()
