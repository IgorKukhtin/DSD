-- Function: gpInsertUpdate_Object_ReceiptChild_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild_Sybase (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptChild_Sybase(
 INOUT ioId              Integer   , -- ���� ������� <������������ ��������>
    IN inValue           TFloat    , -- �������� ������� 
    IN inIsWeightMain    Boolean   , -- ������ � ����� ��� �����
    IN inIsTaxExit       Boolean   , -- ������� �� % ������
    IN inStartDate       TDateTime , -- ��������� ����
    IN inEndDate         TDateTime , -- �������� ����
    IN inComment         TVarChar  , -- �����������
    IN inReceiptId       Integer   , -- ������ �� ���������
    IN inGoodsId         Integer   , -- ������ �� ������
    IN inGoodsKindId     Integer   , -- ������ �� ���� �������
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptChild());


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptChild(), 0, '');
   
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_Receipt(), ioId, inReceiptId);
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <����� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_GoodsKind(), ioId, inGoodsKindId);
   
   -- ��������� �������� <��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptChild_Value(), ioId, inValue);
   IF EXISTS (SELECT * FROM ObjectLink WHERE ObjectId = inReceiptId AND DescId = zc_ObjectLink_Receipt_GoodsKind() AND ChildObjectId = zc_GoodsKind_WorkProgress())
      OR EXISTS (SELECT * FROM ObjectLink WHERE ObjectId = (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inReceiptId AND DescId = zc_ObjectLink_Receipt_Goods())
                                            AND DescId = zc_ObjectLink_Goods_InfoMoney()
                                            AND ChildObjectId = zc_Enum_InfoMoney_10105()) -- �������� ����� + ������ ����� + ������ ������ �����
   THEN
       -- ��������� �������� <������ � ���. ����� (100 ��.)>
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_WeightMain(), ioId, inIsWeightMain);
   ELSE
       -- ��������� �������� <������ � ���. ����� (100 ��.)>
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_WeightMain(), ioId, FALSE);
   END IF;

   -- ��������� �������� <������� �� % ������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_TaxExit(), ioId, inIsTaxExit);
   -- ��������� �������� <��������� ����>
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_Start(), ioId, inStartDate);
   -- ��������� �������� <�������� ����>
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_End(), ioId, inEndDate);
   -- ��������� �������� <�����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptChild_Comment(), ioId, inComment);

   -- !!!����������� �������� ���-�� �� �������!!!
   PERFORM lpUpdate_Object_Receipt_Total (inReceiptId, vbUserId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ReceiptChild_Sybase (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 14.02.15                                        *all
 19.07.13         * rename zc_ObjectDate_              
 09.07.13         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReceiptChild_Sybase ()
