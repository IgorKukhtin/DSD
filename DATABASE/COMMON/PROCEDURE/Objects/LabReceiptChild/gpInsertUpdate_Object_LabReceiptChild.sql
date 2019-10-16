-- Function: gpInsertUpdate_Object_LabReceiptChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LabReceiptChild (Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LabReceiptChild (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LabReceiptChild(
 INOUT ioId              Integer   , -- ���� ������� <>
    IN inLabMarkId       Integer   , -- ������ �� �������� ���������� (��� ������������)
    IN inGoodsId         Integer   , -- ������ �� ������
    IN inValue           TFloat    , -- �������� ������� 
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LabReceiptChild());

   -- ���������� <�������>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_LabReceiptChild(), 0, '');

   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LabReceiptChild_LabMark(), ioId, inLabMarkId);
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LabReceiptChild_Goods(), ioId, inGoodsId);

   -- ��������� �������� <��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_LabReceiptChild_Value(), ioId, inValue);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.10.19         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_LabReceiptChild ()
