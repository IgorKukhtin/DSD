-- Function: gpGet_DefaultValue()

-- DROP FUNCTION IF EXISTS lpGet_DefaultValue (TVarChar, Integer) CASCADE;

CREATE OR REPLACE FUNCTION lpGet_DefaultValue(
    IN inDefaultKey  TVarChar,      -- ���� �������
    IN inUserId      Integer        -- ���� ������������
)
RETURNS TVarChar AS
$BODY$
BEGIN

  IF LOWER (inDefaultKey) = LOWER ('zc_Object_Unit') AND inUserId = 183242 -- ����
  THEN RETURN '0'; -- !!!���������� ��� Pharmacy!!!
  ELSE
  
  RETURN COALESCE (CASE WHEN 1=0 AND 0 < (SELECT RoleId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
                             THEN '-1' -- !!!���������� ��� Pharmacy!!!
                        ELSE (SELECT DefaultValue
                              FROM DefaultValue 
                                   INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                                   INNER JOIN (SELECT RoleId, 2 AS OrderId FROM ObjectLink_UserRole_View WHERE UserId = inUserId
                                              UNION 
                                               SELECT inUserId AS RoleId, 1 AS OrderId
                                              ) AS UserRole ON UserRole.RoleId = DefaultValue.UserKeyId
                              WHERE DefaultKeys.Key = inDefaultKey
                              ORDER BY UserRole.OrderId 
                              LIMIT 1)
                   END, '0') :: TVarChar;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION lpGet_DefaultValue (TVarChar, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.02.14                         * add LEFT ��� ������������.
 20.12.13                         *
*/

-- ����
-- SELECT * FROM lpGet_DefaultValue ('zc_Object_Retail', zfCalc_UserAdmin() :: Integer)
