-- Function: gpInsertUpdate_Object_RoleProcessAccess()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RoleProcessAccess(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RoleProcessAccess(
 INOUT ioId	        Integer   ,     -- ���� ������� ����� 
    IN inRoleId         Integer   ,     -- ����
    IN inProcessId      Integer   ,     -- �������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_RoleProcess());

   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleProcessAccess(), 0, '');

   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleProcessAccess_Role(), ioId, inRoleId);
   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleProcessAccess_Process(), ioId, inProcessId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RoleProcessAccess (Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.12.13                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_RoleProcessAccess()
