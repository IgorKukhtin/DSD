-- Function: gpUpdate_ConditionsKeep_SetRelatedProduct()

DROP FUNCTION IF EXISTS gpUpdate_ConditionsKeep_SetRelatedProduct(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ConditionsKeep_SetRelatedProduct(
    IN inId	                 Integer   ,    -- ���� ������� <̳�������� ������������� ����� (���. ������)> 
    IN inRelatedProductId    Integer   ,    -- ������������� ������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ConditionsKeep());
   vbUserId := inSession;
   
   -- �������� ����� ���
   IF COALESCE(inId, 0) = 0
   THEN
       RAISE EXCEPTION '������. ������� �������� �� �������.';
   END IF;

   -- ��������� �������� <������������� ������>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ConditionsKeep_RelatedProduct(), inId, inRelatedProductId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 14.10.18                                                      *
*/

-- ����
-- SELECT * FROM gpUpdate_ConditionsKeep_SetRelatedProduct()
