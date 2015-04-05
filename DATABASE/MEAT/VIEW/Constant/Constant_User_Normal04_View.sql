-- View: Constant_User_Normal04_View

-- DROP VIEW IF EXISTS Constant_User_Normal04_View CASCADE;

CREATE OR REPLACE VIEW Constant_User_Normal04_View
AS
  SELECT * FROM Constant_User_Medium03_View
 UNION
  SELECT DISTINCT UserId
  FROM ObjectLink_UserRole_View
  WHERE RoleId IN (14738 -- ���������� �����
                 , 78432 -- ��������-���� ������������
                  )
  ;

ALTER TABLE Constant_User_Normal04_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.04.15                                        *
*/

-- ����
-- SELECT * FROM Constant_User_Normal04_View LEFT JOIN Object ON Object.Id = Constant_User_Normal04_View.UserId ORDER BY 1
