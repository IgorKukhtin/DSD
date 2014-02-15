-- Function: gpInsertUpdate_Object_Receipt()

-- DROP FUNCTION gpInsertUpdate_Object_Receipt();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Receipt(
 INOUT ioId                  Integer   , -- ���� ������� <������������ ��������>
    IN inName                TVarChar  , -- ������������
    IN inCode                TVarChar  , -- ��� ��������� 
    IN inComment             TVarChar  , -- �����������
    IN inValue               TFloat    , -- �������� (����������)
    IN inValueCost           TFloat    , -- �������� ������(����������)
    IN inTaxExit             TFloat    , -- % ������
    IN inPartionValue        TFloat    , -- ���������� � ������ (���������� � ������)
    IN inPartionCount        TFloat    , -- ����������� ���������� ������ (���������� �������, �������� ��� 0.5 ��� 1)
    IN inWeightPackage       TFloat    , -- ��� ��������
    IN inStartDate           TDateTime , -- ��������� ����
    IN inEndDate             TDateTime , -- �������� ����
    IN inMain                Boolean   , -- ������� �������
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
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Receipt()());
   vbUserId := inSession;
   
   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Receipt(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Receipt(), 0, inName);
   
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
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Receipt_Code(), ioId, inCode);
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
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Receipt_Start(), ioId, inStartDate);
   -- ��������� �������� <�������� ����>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Receipt_End(), ioId, inEndDate);
 
    -- ��������� �������� <������� �������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Receipt_Main(), ioId, inMain);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Receipt (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.07.13         * rename zc_ObjectDate_               
 10.07.13         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Receipt ()
    