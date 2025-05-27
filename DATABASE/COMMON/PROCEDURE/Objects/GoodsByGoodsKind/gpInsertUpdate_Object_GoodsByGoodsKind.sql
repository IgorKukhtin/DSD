-- Function: gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Boolean, Boolean, TVarChar);
/*DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                               , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Boolean, Boolean, TVarChar);*/
/*DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                               , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, Boolean, Boolean, TVarChar);*/
/*DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                               , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, Boolean, Boolean, TVarChar);*/
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                               , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind(
 INOUT ioId                    Integer  , -- ���� ������� <�����>
    IN inGoodsId               Integer  , -- ������
    IN inGoodsKindId           Integer  , -- ���� �������
    IN inGoodsSubId            Integer  , -- ������
    IN inGoodsKindSubId        Integer  , -- ���� �������
    IN inGoodsSubSendId        Integer  , -- ������
    IN inGoodsKindSubSendId    Integer  , -- ���� ������� 
    IN inGoodsPackId           Integer  , -- ������� ����� � ������������ ������� � ��������
    IN inGoodsKindPackId       Integer  , -- ������� ��� � ������������ ������� � �������� 
    IN inGoodsSubId_Br         Integer  , -- ������ (����������� �� �������� - ������)>
    IN inGoodsKindSubSendId_Br Integer , -- ���� ������� (�������.����������� �� �������� - ������) 
    IN inGoodsRealId           Integer  , -- ������
    IN inGoodsKindRealId       Integer  , -- ���� �������
    IN inGoodsKindNewId        Integer  , -- ���� ������� �����
    IN inGoodsIncomeId         Integer  , -- ������ ���� ������
    IN inGoodsKindIncomeId     Integer  , -- ���� ������� ���� ������
    IN inGoodsSubId_CEH        Integer  , -- ������ (����������� ��� - ������)
    IN inGoodsKindSubId_CEH    Integer  , -- ���� ������� (����������� ��� - ������)
    IN inGoodsSubId_SendCEH        Integer  , -- ������ (��������.����������� ��� - ������)
    IN inGoodsKindSubId_SendCEH    Integer  , -- ���� ������� (����������� ��� - ������)
    
    IN inReceiptId             Integer  , -- ���������
    IN inReceiptGPId           Integer  , -- ��������� (����� � ��������)
    IN inWeightPackageKorob    TFloat   , -- ��� 1-��� ������ ��� �������
    IN inWeightPackage         TFloat   , -- ��� ������
    IN inWeightPackageSticker  TFloat   , -- ��� 1-��� ������
    IN inWeightTotal           TFloat   , -- ��� � ��������  
    IN inChangePercentAmount   TFloat   , -- % ������ ��� ���-��
    IN inDaysQ                 TFloat   , -- ��������� ���� ������ � ������������   

    IN inWeightMin             TFloat  , -- ���. ���
    IN inWeightMax             TFloat  , -- ���. ���
    IN inHeight                TFloat  , -- ������
    IN inLength                TFloat  , -- �����
    IN inWidth                 TFloat  , -- ������

    IN inGoodsSubDate          TDateTime, --
    IN inGoodsSub_CEH_start    TDateTime, --
    IN inGoodsSub_SendCEH_start  TDateTime, --
    IN inisNotDate             Boolean  , -- ���� FALSE �������� � inGoodsSubDate - NULL 
    IN inIsNotPack             Boolean  , -- �� �����������
    IN inSession               TVarChar 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind());


   -- ��������
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
   END IF;

   -- !!!���� ���������!!! ���� ����� �� �����, ����� �� ���������
   -- IF COALESCE (inGoodsKindId, 0) = 0
   -- THEN
   --     RETURN;
   -- END IF;

   -- �������� ������������
   IF EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
              WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION '������.��������  <%> + <%> ��� ���� � �����������. ������������ ���������.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;   


   -- ��������
   IF COALESCE (inGoodsSubId, 0) <> COALESCE (inGoodsPackId, 0) AND inGoodsPackId > 0 AND inGoodsSubId > 0
   THEN 
       RAISE EXCEPTION '������.�������� ����� (��������. - ������) = <%>  � �������� ����� (����., �������) = <%> ������ ���������.', lfGet_Object_ValueData (inGoodsSubId), lfGet_Object_ValueData (inGoodsPackId);
   END IF;   

   -- ��������
   IF COALESCE (inGoodsKindSubId, 0) <> COALESCE (inGoodsKindPackId, 0) AND inGoodsPackId > 0 AND inGoodsKindSubId > 0
   THEN 
       RAISE EXCEPTION '������.�������� ��� (��������. - ������) = <%>  � ��� (����., �������) = <%> ������ ���������.', lfGet_Object_ValueData (inGoodsKindSubId), lfGet_Object_ValueData (inGoodsKindPackId);
   END IF;   

   -- �������� - ��� � ����� ������ �� �����
   IF vbUserId = 5 OR vbUserId = 9457 
   THEN
       RAISE EXCEPTION '������.��� ���� - ��� � ����� ������ �� �����.';
   END IF;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsByGoodsKind(), 0, '');
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), ioId, inGoodsKindId);

   -- ��������� ����� � <������  (����������� - ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSub(), ioId, inGoodsSubId);
   -- ��������� ����� � <���� �������  (����������� - ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub(), ioId, inGoodsKindSubId); 
   
   IF COALESCE (inisNotDate, TRUE) = FALSE
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsByGoodsKind_GoodsSub(), ioId, NULL);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsByGoodsKind_GoodsSub(), ioId, inGoodsSubDate);
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsByGoodsKind_GoodsKindSub_CEH_start(), ioId, inGoodsSub_CEH_start);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_GoodsByGoodsKind_GoodsKindSub_SendCEH_start(), ioId, inGoodsSub_SendCEH_start);

   -- ��������� ����� � <������  (�������.����������� - ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSubSend(), ioId, inGoodsSubSendId);
   -- ��������� ����� � <���� �������  (�������.����������� - ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend(), ioId, inGoodsKindSubSendId);

   -- ��������� ����� � <������ (����������� �� �������� - ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSub_Br(), ioId, inGoodsSubId_Br);
   -- ��������� ����� � <���� ������� (�������.����������� �� �������� - ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSubSend_Br(), ioId, inGoodsKindSubSendId_Br);

   -- ��������� ����� � <������  (��� ��������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsPack(), ioId, inGoodsPackId);
   -- ��������� ����� � <���� �������  (��� ��������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack(), ioId, inGoodsKindPackId);

   -- ��������� ����� � <������  (���� ��������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsReal(), ioId, inGoodsRealId);
   -- ��������� ����� � <���� �������  (���� ��������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindReal(), ioId, inGoodsKindRealId);

   -- ��������� ����� � <���� �������  (�����)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindNew(), ioId, inGoodsKindNewId);

   -- ��������� ����� � <������  (���� ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsIncome(), ioId, inGoodsIncomeId);
   -- ��������� ����� � <���� �������  (���� ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindIncome(), ioId, inGoodsKindIncomeId);

   -- ��������� ����� � <������  (�����.����������� ���- ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSub_SendCEH(), ioId, inGoodsSubId_SendCEH);
   -- ��������� ����� � <���� �������  (�����.����������� ���- ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub_SendCEH(), ioId, inGoodsKindSubId_SendCEH);

   -- ��������� ����� � <������  (����������� ���- ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsSub_CEH(), ioId, inGoodsSubId_CEH);
   -- ��������� ����� � <���� �������  (����������� ���- ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKindSub_CEH(), ioId, inGoodsKindSubId_CEH);
   
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Receipt(), ioId, inReceiptId);
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_ReceiptGP(), ioId, inReceiptGPId);

   -- ��������� �������� <��� ������ ��� �������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackageKorob(), ioId, inWeightPackageKorob);
   -- ��������� �������� <��� ������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackage(), ioId, inWeightPackage);
   -- ��������� �������� <��� 1-��� ������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker(), ioId, inWeightPackageSticker);
   -- ��������� �������� <��� � ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightTotal(), ioId, inWeightTotal); 
   -- ��������� �������� <��� � ��������>                                                                                                                              
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount(), ioId, inChangePercentAmount); 
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightMin(), ioId, inWeightMin);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightMax(), ioId, inWeightMax);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Height(), ioId, inHeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Length(), ioId, inLength);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_Width(), ioId, inWidth);
   
   
   -- ��������� �������� <������������ � �������>
   --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inIsOrder);
   -- ��������� �������� <��������� ���� ������ � ������������>                                                                                                                              
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_DaysQ(), ioId, inDaysQ);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_NotPack(), ioId, inIsNotPack);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   -- �������� - ��� � ����� ������ �� �����
   IF vbUserId = 5 OR vbUserId = 9457
   THEN
       RAISE EXCEPTION '������.��� ���� - ��� � ����� ������ �� �����.';
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  
 22.05.25         * inGoodsSubId_CEH, inGoodsKindSubId_CEH
 22.04.25         * inWeightMin, inWeightMax, inHeight, inLength, inWidth 
 21.03.25         * WeightPackageKorob
 04.11.24         * inGoodsIncomeId, inGoodsKindIncomeId
 21.12.22         * inGoodsKindNewId
 29.09.22         * inGoodsReal
 19.02.21         * add inDaysQ
 04.11.20         * add inReceiptGPId
 10.04.20         *
 20.02.18         * inWeightPackageSticker 
 21.12.17         * 
 22.02.17         * ChangePercentAmount
 27.10.16         * Receipt
 26.07.16         *
 23.02.16         * dell inIsOrder - ����������� � ��. ������, ���������� ����
 17.06.15                                        *   -- !!!���� ���������!!!
 19.03.15         *
*/

-- ����
-- 
