-- Function: gpInsertUpdate_Object_RoleProcess()

-- DROP FUNCTION gpInsertUpdate_Object_RoleProcess();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RoleProcess(
 INOUT ioId	        Integer   ,     -- ���� ������� ����� 
    IN inRoleId         Integer   ,     -- ����
    IN inProcessId      Integer   ,     -- �������
    IN inSession        TVarChar        -- ������ ������������
)
RETURNS Integer
AS
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
   IF COALESCE (inProcessId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <Process>.';
   END IF;


   -- �������� �����
   IF COALESCE (ioId, 0) = 0
   THEN
       ioId:= (SELECT ObjectLink_RoleRight_Role.ObjectId
               FROM ObjectLink AS ObjectLink_RoleRight_Role
                    INNER JOIN ObjectLink AS ObjectLink_RoleRight_Process
                                          ON ObjectLink_RoleRight_Process.ObjectId = ObjectLink_RoleRight_Role.ObjectId
                                         AND ObjectLink_RoleRight_Process.ChildObjectId = inProcessId
                                         AND ObjectLink_RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
               WHERE ObjectLink_RoleRight_Role.ChildObjectId = inRoleId
                 AND ObjectLink_RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
               LIMIT 1
              );
   END IF;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleRight(), 0, '');

   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleRight_Role(), ioId, inRoleId);
   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleRight_Process(), ioId, inProcessId);

   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.09.13                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_RoleProcess()
