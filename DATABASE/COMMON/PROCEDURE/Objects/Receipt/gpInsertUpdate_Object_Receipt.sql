-- Function: gpInsertUpdate_Object_Receipt()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Receipt (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Receipt(
 INOUT ioId                  Integer   , -- ���� ������� <������������ ��������>
    IN inCode                Integer   , -- ���
    IN inReceiptCode         TVarChar  , -- ��� ���������
    IN inComment             TVarChar  , -- �����������
    IN inValue               TFloat    , -- �������� (����������)
    IN inValueCost           TFloat    , -- �������� ������(����������)
    IN inTaxExit             TFloat    , -- % ������
    IN inPartionValue        TFloat    , -- ���������� � ������ (���������� � ������)
    IN inPartionCount        TFloat    , -- ����������� ���������� ������ (���������� �������, �������� ��� 0.5 ��� 1)
    IN inWeightPackage       TFloat    , -- ��� ��������
    IN inStartDate           TDateTime , -- ��������� ����
    IN inEndDate             TDateTime , -- �������� ����
    IN inIsMain                Boolean   , -- ������� �������
    IN inGoodsId             Integer   , -- ������ �� ������
    IN inGoodsKindId         Integer   , -- ������ �� ���� �������
    IN inGoodsKindCompleteId Integer   , -- ���� ������� (������� ���������)
    IN inReceiptCostId       Integer   , -- ������� � ����������
    IN inReceiptKindId       Integer   , -- ���� ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbName TVarChar;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Receipt());
   

   -- �������� <�����>
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <�����> ������ ���� �����������.';
   END IF;


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;
   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Receipt()); 


   -- ������ ��������
   vbName:= TRIM (TRIM ((SELECT ValueData FROM Object WHERE DescId = zc_Object_Goods() AND Id = inGoodsId))
         || ' ' || COALESCE ((SELECT ValueData FROM Object WHERE DescId = zc_Object_GoodsKind() AND Id = inGoodsKindId AND inGoodsKindId <> zc_GoodsKind_WorkProgress()), ''))
         || '-' || TRIM (inComment)
         || '-' || TRIM (inReceiptCode);

   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Receipt(), vbCode_calc);
   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Receipt(), vbName);
   -- �������� ������������ ��� �������� <��� ���������>
   PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Receipt_Code(), inReceiptCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Receipt(), vbCode_calc, vbName);
   
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_Goods(), ioId, inGoodsId);   
   -- ��������� ����� � <����� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� ����� � <���� ������� (������� ���������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_GoodsKindComplete(), ioId, inGoodsKindCompleteId);
   -- ��������� ����� � <������� � ����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_ReceiptCost(), ioId, inReceiptCostId);
   -- ��������� ����� � <���� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_ReceiptKind(), ioId, inReceiptKindId);

   -- ��������� �������� <��� ���������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Receipt_Code(), ioId, inReceiptCode);
   -- ��������� �������� <�����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Receipt_Comment(), ioId, inComment);


   -- ��������� �������� <�������� (����������)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_Value(), ioId, inValue);
   -- ��������� �������� <�������� ������(����������)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_ValueCost(), ioId, inValueCost);
   -- ��������� �������� <% ������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TaxExit(), ioId, inTaxExit);
   -- ��������� �������� <���������� � ������ (���������� � ������)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_PartionValue(), ioId, inPartionValue);
   -- ��������� �������� <����������� ���������� ������ (���������� �������, �������� ��� 0.5 ��� 1)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_PartionCount(), ioId, inPartionCount);
   -- ��������� �������� <��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_WeightPackage(), ioId, inWeightPackage);

   -- ��������� �������� <��������� ����>
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Receipt_Start(), ioId, inStartDate);
   -- ��������� �������� <�������� ����>
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Receipt_End(), ioId, inEndDate);
 
   -- !!!����������� �������� ���-�� �� �������!!!
   PERFORM lpUpdate_Object_Receipt_Total (ioId, vbUserId);

   -- ��������� �������� <������� �������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Receipt_Main(), ioId, inIsMain);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Receipt (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.02.15                                        * all
 24.12.14         *
 19.07.13         * rename zc_ObjectDate_               
 10.07.13         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Receipt ()
