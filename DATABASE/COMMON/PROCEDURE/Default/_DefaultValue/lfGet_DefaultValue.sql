-- Function: gpGet_DefaultValue()

-- DROP FUNCTION IF EXISTS lpGet_DefaultValue (TVarChar, Integer) CASCADE;

CREATE OR REPLACE FUNCTION lpGet_DefaultValue(
    IN inDefaultKey  TVarChar,      -- ключ дефолта
    IN inUserId      Integer        -- ключ пользователя
)
RETURNS TVarChar AS
$BODY$
BEGIN

  IF LOWER (REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit')) = LOWER ('zc_Object_Unit') AND inUserId = 183242 -- Люба
  THEN
       RETURN '0'; -- !!!захардодил для Pharmacy!!!
  ELSE

  IF EXISTS (SELECT 1
                              FROM DefaultValue
                                   INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                                   INNER JOIN (SELECT RoleId, 2 AS OrderId FROM ObjectLink_UserRole_View WHERE UserId = inUserId
                                              UNION
                                               SELECT inUserId AS RoleId, 1 AS OrderId
                                              ) AS UserRole ON UserRole.RoleId = DefaultValue.UserKeyId
                              WHERE DefaultKeys.Key = REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit')
            )
    OR REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit') <> inDefaultKey
  THEN
  RETURN COALESCE (CASE WHEN 1=0 AND 0 < (SELECT RoleId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
                             THEN '-1' -- !!!захардодил для Pharmacy!!!
                        ELSE (SELECT DefaultValue
                              FROM DefaultValue
                                   INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                                   INNER JOIN (SELECT RoleId, 2 AS OrderId FROM ObjectLink_UserRole_View WHERE UserId = inUserId
                                              UNION
                                               SELECT inUserId AS RoleId, 1 AS OrderId
                                              ) AS UserRole ON UserRole.RoleId = DefaultValue.UserKeyId
                              WHERE DefaultKeys.Key = REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit')
                              ORDER BY UserRole.OrderId
                              LIMIT 1)
                   END, '0') :: TVarChar;
  ELSE

  RETURN COALESCE (CASE WHEN 1=0 AND 0 < (SELECT RoleId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
                             THEN '-1' -- !!!захардодил для Pharmacy!!!
                        ELSE (SELECT DefaultValue
                              FROM DefaultValue
                                   INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                                   LEFT JOIN (SELECT RoleId, 2 AS OrderId FROM ObjectLink_UserRole_View WHERE UserId = inUserId
                                              UNION
                                               SELECT inUserId AS RoleId, 1 AS OrderId
                                              ) AS UserRole ON UserRole.RoleId = DefaultValue.UserKeyId
                              WHERE DefaultKeys.Key = REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit')
                              ORDER BY UserRole.OrderId
                              LIMIT 1)
                   END, '0') :: TVarChar;

  END IF;
  END IF;

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION lpGet_DefaultValue (TVarChar, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.14                         * add LEFT для пользователя.
 20.12.13                         *
*/

-- тест
-- SELECT * FROM lpGet_DefaultValue ('zc_Object_Retail', zfCalc_UserAdmin() :: Integer)
