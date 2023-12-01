-- Function: gpInsertUpdate_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_UnitChild(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods_UnitChild(
    IN inId               Integer   ,    -- ���� ������� <�����>
    IN inUnitChildId      Integer   ,    ---
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptGoods());
   vbUserId:= lpGetUserBySession (inSession);

    --
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN;
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoods_UnitChild(), inId, inUnitChildId);
   
   
   -- ��������� �������� <���� ����>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);
   -- ��������� �������� <������������ (����)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inId, vbUserId);



   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.12.23         * inUnitChildId
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoods_UnitChild()