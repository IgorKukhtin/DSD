-- Function: gpInsertUpdate_Object_RoleAction()

-- DROP FUNCTION gpInsertUpdate_Object_RoleAction();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RoleAction(
 INOUT ioId	        Integer   ,     -- ���� ������� ����� 
    IN inRoleId         Integer   ,     -- ����
    IN inActionId       Integer   ,     -- ��������
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
   IF COALESCE (inActionId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <Action>.';
   END IF;

   -- �������� �����
   IF COALESCE (ioId, 0) = 0
   THEN
       ioId:= (SELECT ObjectLink_RoleAction_Role.ObjectId
               FROM ObjectLink AS ObjectLink_RoleAction_Role
                    INNER JOIN ObjectLink AS ObjectLink_RoleAction_Action
                                          ON ObjectLink_RoleAction_Action.ObjectId = ObjectLink_RoleAction_Role.ObjectId
                                         AND ObjectLink_RoleAction_Action.ChildObjectId = inActionId
                                         AND ObjectLink_RoleAction_Action.DescId = zc_ObjectLink_RoleAction_Action()
               WHERE ObjectLink_RoleAction_Role.ChildObjectId = inRoleId
                 AND ObjectLink_RoleAction_Role.DescId = zc_ObjectLink_RoleAction_Role()
               LIMIT 1
              );
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_RoleAction(), 0, '');

   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleAction_Role(), ioId, inRoleId);
   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_RoleAction_Action(), ioId, inActionId);

   
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
-- SELECT * FROM gpInsertUpdate_Object_RoleAction()
