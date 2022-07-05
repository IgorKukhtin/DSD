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
    OR LOWER (inDefaultKey) = LOWER ('-zc_Object_Unit') AND inUserId = 4183126 -- Олег 
  THEN
       RETURN '0'; -- !!!захардодил для Pharmacy!!!
  ELSE

  IF LOWER (REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit')) = LOWER ('zc_Object_Unit') AND 
    EXISTS(SELECT 1 FROM Object WHERE Object.DescId = zc_Object_Role() AND LOWER (Object.ValueData) = LOWER ('Директор Партнёр'))
  THEN
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = inUserId AND RoleId = zc_Enum_Role_DirectorPartner())
     THEN
        RETURN zc_DirectorPartner_UnitID()::TVarChar;
     END IF;
  END IF;
  

  IF EXISTS (SELECT 1
                              FROM DefaultValue
                                   INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                                   INNER JOIN (SELECT RoleId, 2 AS OrderId FROM ObjectLink_UserRole_View WHERE UserId = inUserId
                                              UNION
                                               SELECT inUserId AS RoleId, 1 AS OrderId
                                              ) AS UserRole ON UserRole.RoleId = DefaultValue.UserKeyId
                              WHERE DefaultKeys.Key = REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit')
            )
       -- или с МИНУСОМ
    OR REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit') <> inDefaultKey -- !!!вот здесь имееет значение этот МИНУС!!!
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
  -- если у Роли или у Пользователя - отсутсвует Default - Unit, тогда будем искать любой из zc_Object_Retail
  ELSEIF
        NOT EXISTS (SELECT 1
                              FROM DefaultValue
                                   INNER JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
                                   INNER JOIN (SELECT RoleId, 2 AS OrderId FROM ObjectLink_UserRole_View WHERE UserId = inUserId
                                              UNION
                                               SELECT inUserId AS RoleId, 1 AS OrderId
                                              ) AS UserRole ON UserRole.RoleId = DefaultValue.UserKeyId
                              WHERE DefaultKeys.Key = REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit')
            )
    AND REPLACE (inDefaultKey, '-zc_Object_Unit', 'zc_Object_Unit') = 'zc_Object_Unit'

  THEN
  
  IF EXISTS(SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = inUserId AND RoleId = zc_Enum_Role_CashierPharmacy()) 
  THEN
    RAISE EXCEPTION 'Привяжите себя к аптеке. Зайдите в Farmacy cash!';
  END IF;
  
  RETURN COALESCE ((WITH tmpRetail AS (SELECT zfConvert_StringToFloat (lpGet_DefaultValue ('zc_Object_Retail', inUserId)) :: Integer AS RetailId)
                    SELECT MIN (OL_Unit_Juridical.ObjectId)
                    FROM tmpRetail
                         INNER JOIN ObjectLink AS OL_Juridical_Retail
                                               ON OL_Juridical_Retail.ChildObjectId = tmpRetail.RetailId
                                              AND OL_Juridical_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
                         INNER JOIN ObjectLink AS OL_Unit_Juridical
                                               ON OL_Unit_Juridical.ChildObjectId = OL_Juridical_Retail.ObjectId
                                              AND OL_Unit_Juridical.DescId        = zc_ObjectLink_Unit_Juridical()
                         INNER JOIN Object AS Object_Unit ON Object_Unit.Id       = OL_Unit_Juridical.ObjectId
                                                         AND Object_Unit.isErased = FALSE
                                                         AND Object_Unit.Id not in (183288, 183289, 183290, 183291)
                         LEFT JOIN ObjectLink AS OL_Unit_Parent
                                              ON OL_Unit_Parent.ChildObjectId = OL_Unit_Juridical.ObjectId
                                             AND OL_Unit_Parent.DescId        = zc_ObjectLink_Unit_Parent()
                    WHERE OL_Unit_Parent.ObjectId IS NULL -- т.е. это НЕ Группа
                   ), '0') :: TVarChar;
  
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19:11:18                                                       * для Олега обход аптек
 18.02.14                         * add LEFT для пользователя.
 20.12.13                         *
*/

-- тест
-- SELECT * FROM lpGet_DefaultValue ('zc_Object_Retail', zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM lpGet_DefaultValue ('zc_Object_Unit', 11780883);