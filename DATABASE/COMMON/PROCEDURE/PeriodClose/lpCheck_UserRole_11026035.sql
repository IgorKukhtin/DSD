-- �������� - 10275 - ��� ������ ������� � ��������� ��������� ����� ��
-- Function: lpCheck_UserRole_11026035()

DROP FUNCTION IF EXISTS lpCheck_UserRole_11026035 (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheck_UserRole_11026035(
    IN inPersonalServiceListId Integer,    -- 
    IN inUserId                Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

     IF EXISTS (SELECT 1
                FROM ObjectBoolean AS OB_PersonalServiceList_User
                WHERE OB_PersonalServiceList_User.ObjectId  = inPersonalServiceListId
                  AND OB_PersonalServiceList_User.DescId    = zc_ObjectBoolean_PersonalServiceList_User()
                  AND OB_PersonalServiceList_User.ValueData = TRUE
               )
     THEN
          -- ����������� - 10275 - ����������� - ��� ������ ������� � ��������� ��������� ����� ��
          IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = 11026035)
          THEN
              RAISE EXCEPTION '������.��� ���� <%> ��� ���� ��� ���������� ��������.', lfGet_Object_ValueData_sh (11026035);
          END IF;

          -- ����������� - 10200 - ��� ������ ������� � ��������� ������ ��
          IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = 8813637)
          THEN
              RAISE EXCEPTION '������.��� ���� <%> ��� ���� ��� ���������� ��������.', lfGet_Object_ValueData_sh (8813637);
          END IF;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.11.22                                        *
*/

-- ����
-- SELECT lpCheck_UserRole_11026035 (inPersonalServiceListId:=1, inUserId:= 81241)
