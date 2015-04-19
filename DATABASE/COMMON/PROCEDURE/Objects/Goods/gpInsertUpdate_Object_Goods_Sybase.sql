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
   DECLARE vbGoodsPlatformId     Integer;
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



   -- !!!��������!!!
   IF inInfoMoneyId NOT IN (zc_Enum_InfoMoney_10202(), zc_Enum_InfoMoney_10203()) -- ������ ����� + �������� + ��������
      AND inInfoMoneyId IN (zc_Enum_InfoMoney_10201(), zc_Enum_InfoMoney_10204()) -- ������ ����� + ������ + ������ �����
      AND ioId > 0 
      AND EXISTS (SELECT ObjectLink_Receipt_Goods.ObjectId
                  FROM ObjectLink AS ObjectLink_Receipt_GoodsKind
                       INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods ON ObjectLink_Receipt_Goods.ChildObjectId = ObjectLink_Receipt_GoodsKind.ObjectId
                                                                        AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                                                                        AND ObjectLink_Receipt_Goods.ObjectId = ioId
                       INNER JOIN ObjectLink AS ObjectLink_ReceiptChild_Receipt ON ObjectLink_ReceiptChild_Receipt.ChildObjectId = ObjectLink_Receipt_GoodsKind.ObjectId
                                                                               AND ObjectLink_ReceiptChild_Receipt.DescId = zc_ObjectLink_ReceiptChild_Receipt()
                       INNER JOIN Object AS Object_ReceiptChild ON Object_ReceiptChild.Id = ObjectLink_ReceiptChild_Receipt.ObjectId
                                                               AND Object_ReceiptChild.isErased = FALSE
                       INNER JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                ON ObjectBoolean_TaxExit.ObjectId = Object_ReceiptChild.Id 
                                               AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                                               AND ObjectBoolean_TaxExit.ValueData = TRUE
                  WHERE ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                    AND ObjectLink_Receipt_GoodsKind.ChildObjectId = zc_GoodsKind_WorkProgress())
   THEN
       inInfoMoneyId:= zc_Enum_InfoMoney_10203(); -- ��������
   END IF;


   -- �������
   vbGoodsPlatformId:= (SELECT CASE WHEN InfoMoneyCode IN (10102,10103,10104,10105,30101,30201,30301) -- �������� ����� + ������ ����� OR ������ + ��������� or ������ �����
                                         THEN (SELECT Id FROM Object WHERE ObjectCode = 1 AND DescId = zc_Object_GoodsPlatform())
                                    WHEN InfoMoneyCode IN (20901) -- ����
                                         THEN (SELECT Id FROM Object WHERE ObjectCode = 2 AND DescId = zc_Object_GoodsPlatform())
                                    WHEN InfoMoneyCode IN (30102) -- �������
                                         THEN (SELECT Id FROM Object WHERE ObjectCode = 3 AND DescId = zc_Object_GoodsPlatform())
                                    WHEN InfoMoneyCode IN (20901) -- ����
                                         THEN (SELECT Id FROM Object WHERE ObjectCode = 4 AND DescId = zc_Object_GoodsPlatform())
                               END AS GoodsPlatformId
                        FROM Object_InfoMoney_View
                        WHERE Object_InfoMoney_View.InfoMoneyId = inInfoMoneyId);


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
   -- ��������� ����� � <���������������� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ioId, vbGoodsPlatformId);


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
