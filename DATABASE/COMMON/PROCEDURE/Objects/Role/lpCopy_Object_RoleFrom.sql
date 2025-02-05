-- Function: lpCopy_Object_RoleMask()

DROP FUNCTION IF EXISTS lpCopy_Object_RoleFrom (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS lpCopy_Object_RoleFrom (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION lpCopy_Object_RoleFrom(
    IN inRoleId_from     Integer   ,     -- ��� ������� 
    IN inRoleId_to       Integer   ,     -- ��� ������� 
    IN inIsProcessAccess Boolean   ,     -- 
    IN inSession         TVarChar        -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN
   -- 1 - RoleAction
   PERFORM gpInsertUpdate_Object_RoleAction (ioId       := 0
                                           , inRoleId   := inRoleId_to
                                           , inActionId := tmp.id
                                           , inSession := inSession) 
   FROM gpSelect_Object_RoleAction(inSession) AS tmp
        LEFT JOIN  gpSelect_Object_RoleAction (inSession) AS tmp_to
                  ON tmp_to.roleId = inRoleId_to
                 AND tmp_to.Id = tmp.Id
   WHERE tmp.roleId = inRoleId_from
     AND tmp_to.roleId IS NULL
  ;
   
   -- 2 - RoleProcess
   PERFORM gpInsertUpdate_Object_RoleProcess (ioId := 0
                                           , inRoleId := inRoleId_to
                                           , inProcessId := tmp.id 
                                           , inSession := inSession)
   FROM gpSelect_Object_RoleProcess (inSession) AS tmp
        LEFT JOIN  gpSelect_Object_RoleProcess (inSession) AS tmp_to
                  ON tmp_to.roleId = inRoleId_to
                 AND tmp_to.Id = tmp.Id
   WHERE tmp.roleId = inRoleId_from
     AND tmp_to.roleId IS NULL
  ;

   -- 3 - RoleProcessAccess
   IF inIsProcessAccess = TRUE
   THEN
       PERFORM gpInsertUpdate_Object_RoleProcessAccess (ioid := 0 
                                                     , inroleid := inRoleId_to
                                                     , inprocessid := tmp.id 
                                                     , inSession := inSession)
       FROM gpSelect_Object_RoleProcessAccess (inSession) AS tmp
            LEFT JOIN gpSelect_Object_RoleProcessAccess (inSession) AS tmp_to
                      ON tmp_to.roleId = inRoleId_to
                     AND tmp_to.Id = tmp.Id
       WHERE tmp.roleId = inRoleId_from
         AND tmp_to.roleId IS NULL
      ;
   END IF;

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.07.15                                         *
*/
/*
 select tmp.Id AS FromId, tmp.*
     , lpCopy_Object_RoleFrom (inRoleId_from := tmp.Id , inRoleId_to := 442930 , inSession := zfCalc_UserAdmin()) -- ��������� ������ ������ �� - ���������� �.�.
 from gpSelect_Object_UserRole (zfCalc_UserAdmin()) as tmp
 where tmp.UserId = 81238 -- ���������� �.�.

 select tmp.Id AS FromId, tmp.*
     , lpCopy_Object_RoleFrom (inRoleId_from := tmp.Id , inRoleId_to := 419508  , inSession := zfCalc_UserAdmin()) -- ���������� ������� �.
 from gpSelect_Object_UserRole (zfCalc_UserAdmin()) as tmp
 where tmp.UserId = 128491 -- ������� �.�.
 
 select tmp.Id AS FromId, tmp.*
     , lpCopy_Object_RoleFrom (inRoleId_from := tmp.Id , inRoleId_to := 442931  , inSession := zfCalc_UserAdmin()) -- ���������� ������� �.
 from gpSelect_Object_UserRole (zfCalc_UserAdmin()) as tmp
 where tmp.UserId = 80830 -- ��������� �.�.


   -- !!!!�������!!!
   select tmp.*
        , lpCopy_Object_RoleFrom (inRoleId_from:= tmp.Id, inRoleId_to:= (SELECT Id FROM Object WHERE ObjectCode = 2100 AND DescId = zc_Object_Role()), inIsProcessAccess:= FALSE, inSession:= zfCalc_UserAdmin())
   from gpSelect_Object_Role (zfCalc_UserAdmin()) as tmp
   WHERE tmp.Code IN (3001, 4001, 5001, 6001, 7001, 8001, 8011)


   -- !!!!DELETE ROLE!!! � ������������
   select tmp.*
        , lp Delete_Object (userroleid, '5') 
   from gpSelect_Object_UserRole (zfCalc_UserAdmin()) as tmp
    where tmp.UserId = 81238 -- ���������� �.�.


   -- !!!!DELETE "������" ACTION!!! � ����
   select tmp.*
        , lp Delete_Object (RoleActionId, '5') 
   FROM gpSelect_Object_RoleAction ('') AS tmp
   WHERE tmp.roleId = 442930 -- ��������� ������ ������ �� - ���������� �.�.
     AND tmp.Id = 257508     -- ��� "Action1"

   -- !!!!DELETE "����������" ACTION!!! � ����
   select lp Delete_Object (Id_del, '5') 
   from (select max (RoleActionId) as Id_del
         FROM gpSelect_Object_RoleAction ('') AS tmp
         WHERE tmp.roleId = 442930 -- ��������� ������ ������ �� - ���������� �.�.
         group by roleId, Id
         having count(*) > 1
         ) as a


   -- !!!!DELETE "������" Process!!! � ����
   select tmp.*
        , lp Delete_Object (RoleProcessId, '5') 
   FROM gpSelect_Object_RoleProcess ('') AS tmp
   WHERE tmp.roleId = 442930 -- ��������� ������ ������ �� - ���������� �.�.
     AND tmp.Id = zc_Enum_Process_Null() -- ��� "zc_Enum_Process_Null"

   -- !!!!DELETE "����������" Process!!! � ����
   select lp Delete_Object (Id_del, '5') 
   from (select max (RoleProcessId) as Id_del
         FROM gpSelect_Object_RoleProcess ('') AS tmp
         WHERE tmp.roleId = 442930 -- ��������� ������ ������ �� - ���������� �.�.
         group by roleId, Id
         having count(*) >1
         ) as a
*/