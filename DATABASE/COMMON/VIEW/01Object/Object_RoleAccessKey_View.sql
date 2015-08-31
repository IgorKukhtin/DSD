-- View: Object_RoleAccessKey_View

-- DROP VIEW IF EXISTS Object_RoleAccess_View;

CREATE OR REPLACE VIEW Object_RoleAccessKey_View AS

   SELECT ObjectLink_RoleProcessAccess_Process.ChildObjectId AS AccessKeyId
        , ObjectLink_RoleProcessAccess_Role.ChildObjectId AS RoleId
        , 0 AS ProcessId
        , ObjectLink_UserRole_View.UserId
        , Object_Role.ObjectCode AS RoleCode
        , Object_Role.ValueData AS RoleName
   FROM ObjectLink AS ObjectLink_RoleProcessAccess_Process
        JOIN ObjectLink AS ObjectLink_RoleProcessAccess_Role
                        ON ObjectLink_RoleProcessAccess_Role.ObjectId = ObjectLink_RoleProcessAccess_Process.ObjectId
                       AND ObjectLink_RoleProcessAccess_Role.DescId = zc_ObjectLink_RoleProcessAccess_Role()
        LEFT JOIN ObjectLink_UserRole_View ON ObjectLink_UserRole_View.RoleId = ObjectLink_RoleProcessAccess_Role.ChildObjectId
        LEFT JOIN Object AS Object_Role ON Object_Role.Id = ObjectLink_RoleProcessAccess_Role.ChildObjectId
   WHERE ObjectLink_RoleProcessAccess_Process.DescId = zc_ObjectLink_RoleProcessAccess_Process();

/*
        -- ���������, ���� ��� ��� ����� �������� ��� ����� � ���� ������ ��������� (������ ���������)
        (SELECT Id AS RoleId
              , CASE WHEN ObjectCode = 4 -- ���������-����-���� ����������
                          THEN zc_Enum_Process_AccessKey_TrasportDnepr()
                     WHEN ObjectCode = 14 -- ���������-�����-���� ����������
                          THEN zc_Enum_Process_AccessKey_TrasportKiev()
                END AS AccessKeyId
         FROM Object
         WHERE DescId = zc_Object_Role() AND ObjectCode IN (4  -- ���������-�����-���� ����������
                                                          , 14 -- ���������-����-���� ����������
                                                           )
        UNION ALL
         SELECT Id AS RoleId
              , zc_Enum_Process_AccessKey_TrasportAll()
         FROM Object
         WHERE DescId = zc_Object_Role() AND ObjectCode IN (4  -- ���������-�����-���� ����������
                                                          , 14 -- ���������-����-���� ����������
                                                           )
        UNION ALL
         -- !!!��� ������!!!
         SELECT Id AS RoleId
              , tmpAccessKey.AccessKeyId
         FROM (SELECT zc_Enum_Process_AccessKey_GuideAll() AS AccessKeyId
              ) AS tmpAccessKey
              LEFT JOIN Object ON DescId = zc_Object_Role() AND ObjectCode IN (1) -- ���� ��������������
        ) AS Object_Role_AccessKey
        LEFT JOIN ObjectLink_UserRole_View ON ObjectLink_UserRole_View.RoleId = Object_Role_AccessKey.RoleId*/
   ;

ALTER TABLE Object_RoleAccessKey_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.09.14                                        * add ProcessId
 06.03.14                                        * add RoleCode and RoleName
 15.12.13                                        * select ...
 14.12.13                                        * add zc_Enum_Process_AccessKey_GuideAll
 07.12.13                                        *
*/

-- ����
-- SELECT * FROM Object_RoleAccessKey_View
