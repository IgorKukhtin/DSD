-- �������� - 10200 - ��� ������ ������� � ��������� ������ ��
-- Function: lpCheck_UserRole_8813637()

DROP FUNCTION IF EXISTS lpCheck_UserRole_8813637 (Integer);

CREATE OR REPLACE FUNCTION lpCheck_UserRole_8813637(
    IN inUserId          Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

     -- ����������� - 10200 - ��� ������ ������� � ��������� ������ ��
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = 8813637)
     THEN
         RAISE EXCEPTION '������.��� ���� <%> ��� ���� ��� ���������� ��������.', lfGet_Object_ValueData_sh (8813637);
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
-- SELECT lpCheck_UserRole_8813637 (inUserId:= 81241)
