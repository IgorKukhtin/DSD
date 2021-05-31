-- Function: gpInsertUpdate_Object_Partner_Category()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner_Category (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner_Category(
    IN inId                  Integer   ,    -- ���� ������� <����������> 
    IN inCategory            TFloat    ,    -- ��������� ��    
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Category());

   IF COALESCE (inId, 0) = 0 
   THEN 
       RAISE EXCEPTION '������.������� �� ��������.';
   END IF;   
   
   -- ��������
   IF (inCategory <> COALESCE((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = inId AND OFl.DescId = zc_ObjectFloat_Partner_Category()), 0))
   AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_Partner_Category())
   THEN
       RAISE EXCEPTION '������.��� ���� ��������� <��������� ��>.';
   END IF;


   -- ��������� �������� <inCategory>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Partner_Category(), inId, inCategory);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.05.21         *
*/

-- ����
--