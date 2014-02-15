-- Function: gpInsertUpdate_Object_UserRole (Integer, Integer, Integer, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_UserRole (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UserRole(
 INOUT ioId	        Integer   ,     -- ���� ������� ����� 
    IN inUserId         Integer   ,     -- ������������
    IN inRoleId         Integer   ,     -- ����
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_UserRole());

   UserId := inSession;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UserRole(), 0, '');

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_User(), ioId, inUserId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UserRole_Role(), ioId, inRoleId);

   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
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