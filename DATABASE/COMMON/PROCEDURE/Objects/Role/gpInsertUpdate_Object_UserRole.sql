-- Function: gpInsertUpdate_Object_UserRole (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_UserRole (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UserRole(
 INOUT ioId	        Integer   ,     -- ���� ������� ����� 
    IN inUserId         Integer   ,     -- ������������
    IN inRoleId         Integer   ,     -- ����
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   IF COALESCE (inRoleId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <Role>.';
   END IF;
   -- ��������
   IF COALESCE (inUserId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <User>.';
   END IF;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), ioId, inUserId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), ioId, inRoleId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_UserRole (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.09.13                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_UserRole()