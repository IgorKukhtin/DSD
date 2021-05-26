-- Function: gpInsert_Object_RoleMask()

-- DROP FUNCTION gpInsert_Object_RoleMask (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_RoleMask(
 INOUT ioId	            Integer   ,     -- ���� ������� <��������> 
    IN inCode           Integer   ,     -- ��� ������� <��������> 
    IN inName           TVarChar  ,     -- �������� ������� <��������>
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Role());

   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode := lfGet_ObjectCode(inCode, zc_Object_Role()); 
   
   -- �������� ������������ ��� �������� <������������ ��������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Role(), inName);
   -- �������� ������������ ��� �������� <��� ����� ��������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Role(), inCode);


   -- ��������� <������>
   vbId  := lpInsertUpdate_Object(0, zc_Object_Role(), inCode, inName);
   
   PERFORM gpInsertUpdate_Object_RoleAction (ioId       := 0
                                           , inRoleId   := vbId
                                           , inActionId := tmp.id
                                           , inSession := inSession) 
   FROM gpSelect_Object_RoleAction(inSession) AS tmp
   WHERE tmp.roleId = ioId; 
   
   PERFORM gpInsertUpdate_Object_RoleProcess(ioId := 0
                                           , inRoleId := vbId 
                                           , inProcessId := tmp.id 
                                           , inSession := inSession)
   FROM gpSelect_Object_RoleProcess(inSession) AS tmp
   WHERE tmp.roleId = ioId; 
/*   
   PERFORM gpInsertUpdate_Object_UserRole (ioId := 0 
                                        , inUserId := tmp.id
                                        , inRoleId := vbId
                                        , inSession := inSession)
   FROM gpSelect_Object_RoleUser(inSession) AS tmp
   WHERE tmp.roleId = ioId;
 */


   --select * from gpInsertUpdate_Object_UserRole(ioId := 14257 , inUserId := 78433 , RoleId := 9805 ,  inSession := '5');

   PERFORM gpInsertUpdate_Object_RoleProcessAccess(ioid := 0 
                                                 , inroleid := vbId 
                                                 , inprocessid := tmp.id 
                                                 , inSession := inSession)
   FROM gpSelect_Object_RoleProcessAccess(inSession) AS tmp
   WHERE tmp.roleId = ioId;

    ioId := vbId;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsert_Object_RoleMask (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.15         *

*/

-- ����
-- SELECT * FROM gpInsert_Object_RoleMask()

--select * from gpInsert_Object_RoleMask(ioId := 9805 , inCode := 9004 , inName := '�����2' ,  inSession := '5');

