-- Function: gpSelect_Object_Process()

DROP FUNCTION IF EXISTS lpCheckRight (TVarChar, Integer, Date);

CREATE OR REPLACE FUNCTION lpCheckRight(
    IN inSession     TVarChar     , -- ������ ������������
    IN inProcessId   Integer      , --
    IN inOperDate    Date DEFAULT current_Date)
RETURNS Integer
AS
$BODY$
DECLARE
  vbUserId Integer;
BEGIN
  --
  vbUserId := lpGetUserBySession (inSession);

  -- ��� ������  - ��� �����
  IF EXISTS (SELECT 1
             FROM ObjectLink AS Object_UserRole_User -- ����� ������������ � �������� ���� ������������
                      JOIN ObjectLink AS Object_UserRole_Role -- ����� ����� � �������� ���� ������������
                                      ON Object_UserRole_Role.DescId        = zc_ObjectLink_UserRole_Role()
                                     AND Object_UserRole_Role.ObjectId      = Object_UserRole_User.ObjectId
                                     AND Object_UserRole_Role.ChildObjectId = zc_Enum_Role_Admin()
             WHERE Object_UserRole_User.DescId        = zc_ObjectLink_UserRole_User()
               AND Object_UserRole_User.ChildObjectId = vbUserId
            )
     -- ����� ��� �������  - ��� "���������" ����� ������� :)
     AND NOT EXISTS (SELECT 1
                     FROM Object_Role_Process_View
                     WHERE -- �.�. ���� ������� ���� � ������ ���� � zc_Enum_Process_AccessKey_Check
                           Object_Role_Process_View.ProcessId = inProcessId
                       AND Object_Role_Process_View.RoleId    IN (-- ��� ��� ���� + ������������: � ��������� ���� = ������
                                                                  SELECT Object_RoleAccessKey_View.RoleId 
                                                                  FROM Object_RoleAccessKey_View
                                                                  WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_Check()
                                                                    AND Object_RoleAccessKey_View.UserId      = vbUserId
                                                                 )
                    )
  THEN
     RETURN vbUserId;
  ELSE

      IF NOT EXISTS (SELECT 1
                     FROM ObjectLink AS Object_UserRole_User -- ����� ������������ � �������� ���� ������������
                          JOIN ObjectLink AS Object_UserRole_Role -- ����� ����� � �������� ���� ������������
                                          ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                         AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
                                         AND Object_UserRole_Role.ChildObjectId NOT IN
                                                                  -- ��� ��� ���� + ������������: � ��������� ���� = ������
                                                                 (SELECT Object_RoleAccessKey_View.RoleId 
                                                                  FROM Object_RoleAccessKey_View
                                                                  WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_Check()
                                                                    AND Object_RoleAccessKey_View.UserId      = vbUserId
                                                                 )
                          JOIN ObjectLink AS RoleRight_Role -- ����� ���� � �������� �������� �����
                                          ON RoleRight_Role.ChildObjectId = Object_UserRole_Role.ChildObjectId
                                         AND RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                          JOIN ObjectLink AS RoleRight_Process -- ����� �������� � �������� �������� �����
                                          ON RoleRight_Process.ObjectId = RoleRight_Role.ObjectId
                                         AND RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                                         AND RoleRight_Process.ChildObjectId = inProcessId -- !!!��� ��������!!!
                     WHERE Object_UserRole_User.DescId        = zc_ObjectLink_UserRole_User()
                       AND Object_UserRole_User.ChildObjectId = vbUserId)
      THEN
         --RAISE EXCEPTION '������������ <%> �� ����� ���� �� %', lfGet_Object_ValueData_sh (vbUserId), lfGet_Object_ValueData_sh (inProcessId);
         RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������������ <%> �� ����� ���� �� <%>' :: TVarChar
                                               , inProcedureName := 'lpCheckRight                         :: TVarChar
                                               , inUserId        := vbUserId
                                               , inParam1        := lfGet_Object_ValueData_sh (vbUserId)    :: TVarChar
                                               , inParam2        := lfGet_Object_ValueData_sh (inProcessId) :: TVarChar
                                               );
      ELSE
         RETURN vbUserId;

      END IF;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpCheckRight (TVarChar, Integer, Date)  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.10.13                                        * ��� ������  - ��� �����
 23.09.13                         *
*/

-- ����
-- SELECT * FROM lpCheckRight (zfCalc_UserAdmin())