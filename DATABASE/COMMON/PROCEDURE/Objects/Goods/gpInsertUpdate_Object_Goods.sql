-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   , -- ���� ������� <�����>
    IN inCode                Integer   , -- ��� ������� <�����>
    IN inName                TVarChar  , -- �������� ������� <�����>
    IN inWeight              TFloat    , -- ���
    IN inWeightTare          TFloat    , -- ��� ������/����
    IN inCountForWeight      TFloat    , -- ��� ��� ����
    IN inGoodsGroupId        Integer   , -- ������ �� ������ �������
    IN inGroupStatId         Integer   , -- ������ �� ������ ������� (����������)   
    IN inMeasureId           Integer   , -- ������ �� ������� ���������
    IN inTradeMarkId         Integer   , -- ***�������� �����
    IN inInfoMoneyId         Integer   , -- ***�� ������ ����������
    IN inBusinessId          Integer   , -- �������
    IN inFuelId              Integer   , -- ��� �������
    IN inGoodsTagId          Integer   , -- ***������� ������
    IN inGoodsGroupAnalystId Integer   , -- ***������ ���������
    IN inPriceListId         Integer   , -- �����
    IN inStartDate           TDateTime , -- ���� ������
    IN inValuePrice          TFloat    , -- �������� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbGroupNameFull TVarChar;   
   DECLARE vbIsUpdate Boolean;  
   DECLARE vbGoodsPlatformId Integer; -- ***���������������� ��������
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   
   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   -- vbCode:=lfGet_ObjectCode (inCode, zc_Object_Goods());
   vbCode:=inCode;
   
   -- �������� ������������ <���>
   IF vbCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), vbCode); END IF;
   -- !!! �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Goods(), inName);

   -- �������� <inName>
   IF TRIM (COALESCE (inName, '')) = ''
   THEN
       RAISE EXCEPTION '������.�������� <��������> ������ ���� �����������.';
   END IF;

   -- �������� <GoodsGroupId>
   IF COALESCE (inGoodsGroupId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <������ �������> ������ ���� �����������.';
   END IF;
   -- �������� <Measure>
   IF COALESCE (inMeasureId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <������� ���������> ������ ���� �����������.';
   END IF;
   -- �������� <Measure>
   IF inMeasureId = zc_Measure_Sh() AND COALESCE (inWeight, 0) <= 0
   THEN
       RAISE EXCEPTION '������.��� ������� ��������� <%> ������ ���� ����������� �������� <���>.', lfGet_Object_ValueData (inMeasureId);
   END IF;

   -- �� ��������� ������ ��� ����������� <�� ������ ����������>
   inInfomoneyId:= lfGet_Object_GoodsGroup_InfomoneyId (inGoodsGroupId);
   -- �������� <InfoMoneyId>
   IF COALESCE (inInfomoneyId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <�� ������ ����������> �� ������� ��� ������ <%>.', lfGet_Object_ValueData (inGoodsGroupId);
   END IF;
   -- �� ��������� ������ ��� ����������� <�������� �����>
   inTradeMarkId:= lfGet_Object_GoodsGroup_TradeMarkId (inGoodsGroupId);
   -- �� ��������� ������ ��� ����������� <������� ������>
   inGoodsTagId:= lfGet_Object_GoodsGroup_GoodsTagId (inGoodsGroupId);
   -- �� ��������� ������ ��� ����������� <������ ���������>
   inGoodsGroupAnalystId:= lfGet_Object_GoodsGroup_GoodsGroupAnalystId (inGoodsGroupId);
   -- �� ��������� ������ ��� ����������� <���������������� ��������>
   vbGoodsPlatformId:= lfGet_Object_GoodsGroup_GoodsPlatformId (inGoodsGroupId);

   -- �������� �������� <������ �������� ������>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());

   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), vbCode, inName
                                , inAccessKeyId:= CASE WHEN inFuelId <> 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_TicketFuel_Goods() AND ChildObjectId = ioId)
                                                            THEN zc_Enum_Process_AccessKey_TrasportAll()
                                                  END);

   -- ��������� �������� <������ �������� ������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
   -- ��������� �������� <���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Weight(), ioId, inWeight);
   -- ��������� �������� <���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_WeightTare(), ioId, inWeightTare);
   -- ��������� �������� <��� ��� ����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountForWeight(), ioId, inCountForWeight);
      
   -- ��������� ����� � <������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- ��������� ����� � <������� ������(����������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupStat(), ioId, inGroupStatId);
   -- ��������� ����� � <�������� ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� ���� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Business(), ioId, inBusinessId);
   -- ��������� ����� � <��� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Fuel(), ioId, inFuelId);

   -- ��������� ����� � ***<�� ������ ����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, inInfomoneyId);
   -- ��������� ����� � ***<�������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ioId, inTradeMarkId);
   -- ��������� ����� � ***<������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ioId, inGoodsTagId);
   -- ��������� ����� � ***<������ ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupAnalyst(), ioId, inGoodsGroupAnalystId);
   -- �������� �������� ***<���������������� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPlatform(), ioId, vbGoodsPlatformId);


   IF inValuePrice <> 0 AND inPriceListId <> 0
      AND ((vbIsUpdate = FALSE) OR NOT EXISTS (SELECT 1 FROM gpSelect_ObjectHistory_PriceListGoodsItem(inPriceListId := inPriceListId, inGoodsId :=ioId, inSession := inSession) as tmp LIMIT 1))
   THEN
       PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId := 0
                                                         , inPriceListId := inPriceListId
                                                         , inGoodsId     := ioId
                                                         , inGoodsKindId := 0
                                                         , inOperDate    := inStartDate
                                                         , inValue       := inValuePrice
                                                         , inUserId      := vbUserId
                                                          );
   END IF;
  


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
 
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.19         * CountForWeight
 09.10.19         * inWeightTare
 24.11.14         * add inGoodsGroupAnalystId
 15.09.14         * add inGoodsTagId
 04.09.14         * add inGroupStatId
 13.01.14                                        * add vbGroupNameFull
 14.12.13                                        * add inAccessKeyId
 20.10.13                                        * vbCode:=0
 29.09.13                                        * add zc_ObjectLink_Goods_Fuel
 01.09.13                                        * add zc_ObjectLink_Goods_Business
 30.06.13                                        * add vb
 20.06.13          * vbCode:=lpGet_ObjectCode (inCode, zc_Object_Goods());
 16.06.13                                        * IF COALESCE (inCode, 0) = 0  THEN Code_max := NULL ...
 11.06.13          *
 11.05.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
