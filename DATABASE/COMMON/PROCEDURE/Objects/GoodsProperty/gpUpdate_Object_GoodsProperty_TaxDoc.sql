-- Function: gpUpdate_Object_GoodsProperty_TaxDoc()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsProperty_TaxDoc(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsProperty_TaxDoc(
    IN inId                  Integer   ,    -- ���� ������� <�������� ������� ������� ��� ��������������>
    IN inTaxDoc              TFloat    ,    -- 
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsProperty_TaxDoc());

   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ��������.';
   END IF;
  
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsProperty_TaxDoc(), inId, inTaxDoc);
 
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.06.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_GoodsProperty_TaxDoc()

