-- Function: gpInsertUpdate_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Unit(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Unit(
    IN inId               Integer   ,    -- ���� ������� <�����>
    IN inUnitId           Integer   ,    ---
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);

    --
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN;
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Unit(), inId, inUnitId);
   
   
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
 22.12.22         * inUnitId
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods_Unit()