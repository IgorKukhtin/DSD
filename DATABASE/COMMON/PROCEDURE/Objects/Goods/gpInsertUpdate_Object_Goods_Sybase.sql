-- Function: gpInsertUpdate_Object_Goods_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Sybase(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Sybase(
 INOUT ioId                  Integer   , -- ���� ������� <�����>
    IN inCode                Integer   , -- ��� ������� <�����>
    IN inName                TVarChar  , -- �������� ������� <�����>
    IN inWeight              TFloat    , -- ���
    IN inGoodsGroupId        Integer   , -- ������ �� ������ �������
    IN inMeasureId           Integer   , -- ������ �� ������� ���������
    IN inInfoMoneyId         Integer   , -- �������������� ���������
    IN inBusinessId          Integer   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbGroupNameFull TVarChar;   

   DECLARE vbIndex               Integer;
   DECLARE vbGoodsGroupId        Integer;
   DECLARE vbTradeMarkId         Integer;
   DECLARE vbGoodsTagId          Integer;
   DECLARE vbGoodsGroupAnalystId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   
   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   -- !!! vbCode:=lfGet_ObjectCode (inCode, zc_Object_Goods());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- !!! �������� ������������ <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Goods(), inName);

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), vbCode);


   -- �������� �������� <������ �������� ������>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), vbCode, inName
                                , inAccessKeyId:= CASE WHEN ioId <> 0
                                                            THEN (SELECT AccessKeyId FROM Object WHERE Id= ioId)
                                                  END);

   -- ��������� �������� <������ �������� ������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
   -- ��������� �������� <���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Weight(), ioId, inWeight);
   -- ��������� ����� � <������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- ��������� ����� � <�������� ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� ����� � <�������������� ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, inInfoMoneyId);
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Business(), ioId, inBusinessId);


   -- Level-0
   vbTradeMarkId:=         (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_TradeMark());
   vbGoodsTagId:=          (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_GoodsTag());
   vbGoodsGroupAnalystId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst());
   vbGoodsGroupId:=        (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_Parent());

   vbIndex:= 1;
   WHILE vbGoodsGroupId <> 0 AND vbIndex < 10 LOOP
      -- Level-next
      IF COALESCE (vbTradeMarkId, 0) = 0         THEN vbTradeMarkId:=         (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_TradeMark()); END IF;
      IF COALESCE (vbGoodsTagId, 0) = 0          THEN vbGoodsTagId:=          (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_GoodsTag()); END IF;
      IF COALESCE (vbGoodsGroupAnalystId, 0) = 0 THEN vbGoodsGroupAnalystId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_GoodsGroupAnalyst()); END IF;
      vbGoodsGroupId:= (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = vbGoodsGroupId AND DescId = zc_ObjectLink_GoodsGroup_Parent());
      -- ������ ����������
      vbIndex := vbIndex + 1;
   END LOOP;

   -- ��������� ����� � <�������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ioId, vbTradeMarkId);   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ioId, vbGoodsTagId);   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ioId, vbGoodsGroupAnalystId);  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods_Sybase (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
 
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.09.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods_Sybase (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
