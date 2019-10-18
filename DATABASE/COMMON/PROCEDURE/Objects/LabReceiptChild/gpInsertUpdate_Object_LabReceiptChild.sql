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

    -- ��������� ������������ �������� ���������� / �����
    IF EXISTS (SELECT 1 
               FROM ObjectLink AS ObjectLink_LabReceiptChild_LabMark
                    INNER JOIN ObjectLink AS ObjectLink_LabReceiptChild_Goods
                                         ON ObjectLink_LabReceiptChild_Goods.ObjectId = ObjectLink_LabReceiptChild_LabMark.ObjectId
                                        AND ObjectLink_LabReceiptChild_Goods.DescId = zc_ObjectLink_LabReceiptChild_Goods()
                                        AND ObjectLink_LabReceiptChild_Goods.ChildObjectId = inGoodsId
               WHERE ObjectLink_LabReceiptChild_LabMark.DescId = zc_ObjectLink_LabReceiptChild_LabMark()
                 AND ObjectLink_LabReceiptChild_LabMark.ChildObjectId = inLabMarkId
                 AND ObjectLink_LabReceiptChild_LabMark.ObjectId <> COALESCE (ioId,0)
              )
    THEN
        RAISE EXCEPTION '������. � ����������� ��� ����������� ����� ��� <%> � <%>.', lfGet_Object_ValueData (inLabMarkId), lfGet_Object_ValueData (inGoodsId);
    END IF;

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
