-- Function: gpInsertUpdate_Object_ReceiptChild()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptChild(
 INOUT ioId              Integer   , -- ���� ������� <������������ ��������>
    IN inValue           TFloat    , -- �������� ������� 
   OUT outValueWeight    TFloat    , -- �������� ������� 
    IN inIsWeightMain    Boolean   , -- ������ � ���. ����� (100 ��.)
    IN inIsTaxExit       Boolean   , -- ������� �� % ������
 --   IN inIsReal          Boolean   , -- ������� �� �����
    IN inisSave          Boolean   , --
    IN inisDel           Boolean   , --
 INOUT ioStartDate       TDateTime , -- ��������� ����
 INOUT ioEndDate         TDateTime , -- �������� ����
    IN inComment         TVarChar  , -- �����������
    IN inReceiptId       Integer   , -- ������ �� ���������
    IN inReceiptLevelId  Integer   , -- ����� ������������
    IN inGoodsId         Integer   , -- ������ �� ������
    IN inGoodsKindId     Integer   , -- ������ �� ���� �������
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptChild());

   --��������
   IF COALESCE (inisSave,FALSE) = TRUE AND COALESCE (inisDel,FALSE) = TRUE
   THEN
       RAISE EXCEPTION '������.����� ���� ������� ������ ���� �������� C�������� ��� ������� ������� ��� �������.';
   END IF;

   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- ������
   outValueWeight:= (SELECT inValue * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                     FROM ObjectLink AS ObjectLink_Goods_Measure
                          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                               ON ObjectFloat_Weight.ObjectId = ObjectLink_Goods_Measure.ObjectId
                                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    );

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptChild(), 0, '');

   
   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_Receipt(), ioId, inReceiptId);
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <����� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_GoodsKind(), ioId, inGoodsKindId);

   -- ��������� ����� � <����� ������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_ReceiptLevel(), ioId, inReceiptLevelId);

   -- ��������� �������� <��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptChild_Value(), ioId, inValue);
   -- ��������� �������� <������ � ���. ����� (100 ��.)>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_WeightMain(), ioId, inIsWeightMain);
   -- ��������� �������� <������� �� % ������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_TaxExit(), ioId, inIsTaxExit);

   -- ��������� �������� <������� �� �����>
   --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_Real(), ioId, inIsReal);

   
   IF COALESCE (inisSave,FALSE) = TRUE
      THEN   
          -- ��������� �������� <��������� ����>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_Start(), ioId, ioStartDate);
          -- ��������� �������� <�������� ����>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_End(), ioId, ioEndDate);
   END IF;
   IF COALESCE (inisDel,FALSE) = TRUE
      THEN   
          -- ��������� �������� <��������� ����>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_Start(), ioId, NULL);
          -- ��������� �������� <�������� ����>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_End(), ioId, NULL);
   END IF;
   -- ���������� ����������� �������� 
   ioStartDate := (SELECT ObjectDate.ValueData FROM ObjectDate WHERE ObjectDate.DescId = zc_ObjectDate_ReceiptChild_Start() AND ObjectDate.ObjectId = ioId);
   ioEndDate   := (SELECT ObjectDate.ValueData FROM ObjectDate WHERE ObjectDate.DescId = zc_ObjectDate_ReceiptChild_End() AND ObjectDate.ObjectId = ioId);
   
   -- ��������� �������� <�����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptChild_Comment(), ioId, inComment);

   -- !!!����������� �������� ���-�� �� �������!!!
   PERFORM lpUpdate_Object_Receipt_Total (inReceiptId, vbUserId);

   -- !!!����������� ����� � ������ "�����"!!!
   -- PERFORM lpUpdate_Object_Receipt_Parent (inReceiptId, 0, vbUserId);

   -- ��������� ��������
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);  

   
   if vbUserId = 9457
   then   
        RAISE EXCEPTION 'Test.OK. <%> , <%>', ioStartDate, ioEndDate;
   end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.09.22         *inIsReal
 14.06.21         * inReceiptLevelId
 12.11.15         * 
 14.02.15                                        *all
 19.07.13         * rename zc_ObjectDate_              
 09.07.13         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReceiptChild ()
