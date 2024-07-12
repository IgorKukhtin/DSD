-- View: Constant_User_LevelMax01_View

-- DROP VIEW IF EXISTS Constant_User_LevelMax01_View CASCADE;

CREATE OR REPLACE VIEW Constant_User_LevelMax01_View
AS
  SELECT DISTINCT UserId
  FROM ObjectLink_UserRole_View
  WHERE RoleId IN (10898    -- ������ (�����������)
                 , 413075   -- �� �������� ���
                 , 10597056 -- ������ �������� �������
                  )
 UNION
  SELECT 5 AS UserId -- �����"
  ;

ALTER TABLE Constant_User_LevelMax01_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 04.04.15                                        *
*/

-- LevelMax01
-- LevelHigh02
-- LevelMedium03
-- LevelNormal04
-- LevelLover05
-- LevelMin06

-- ����
-- SELECT * FROM Constant_User_LevelMax01_View LEFT JOIN Object ON Object.Id = Constant_User_LevelMax01_View.UserId ORDER BY 1
