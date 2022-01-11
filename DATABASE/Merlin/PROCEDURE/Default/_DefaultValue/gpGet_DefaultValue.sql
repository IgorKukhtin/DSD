-- Function: gpGet_DefaultValue()

--DROP FUNCTION gpGet_DefaultValue();

CREATE OR REPLACE FUNCTION gpGet_DefaultValue(
    IN inDefaultKey  TVarChar,      -- ключ дефолта
    IN inUserKeyId   Integer,       -- ключ роли
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TVarChar AS
$BODY$
BEGIN
    RETURN(lpGet_DefaultValue(inDefaultKey,inUserKeyId));
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_DefaultValue(TVarChar, integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Role('2')