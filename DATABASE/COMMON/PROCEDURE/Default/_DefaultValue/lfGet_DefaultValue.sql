-- Function: gpGet_DefaultValue()

DROP FUNCTION IF EXISTS lpGet_DefaultValue(TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpGet_DefaultValue(
    IN inDefaultKey  TVarChar,      -- ключ дефолта
    IN inUserId      Integer        -- ключ пользователя
)
RETURNS TVarChar AS
$BODY$
BEGIN
  
  RETURN
  COALESCE((SELECT DefaultValue FROM DefaultValue 
    JOIN DefaultKeys ON DefaultKeys.Id = DefaultValue.DefaultKeyId
LEFT JOIN (SELECT RoleId, 2 AS TypeId 
            FROM ObjectLink_UserRole_View
           WHERE UserId = inUserId
           UNION 
          SELECT inUserId, 1) AS UserRole ON UserRole.RoleId = DefaultValue.UserKeyId
   WHERE DefaultKeys.Key = inDefaultKey
   ORDER BY UserRole.TypeId 
   LIMIT 1), '0');
    
END;
$BODY$

LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION lpGet_DefaultValue(TVarChar, integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.14                         * add LEFT для пользователя.
 20.12.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Role('2')