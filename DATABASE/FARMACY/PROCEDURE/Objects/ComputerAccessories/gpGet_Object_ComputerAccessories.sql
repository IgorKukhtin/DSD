-- Function: gpGet_Object_ComputerAccessories()

DROP FUNCTION IF EXISTS gpGet_Object_ComputerAccessories(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ComputerAccessories(
    IN inId            Integer,       -- ключ объекта <Города>
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)       AS Id
           , lfGet_ObjectCode(0, zc_Object_ComputerAccessories()) AS Code
           , CAST ('' as TVarChar)     AS Name;

   ELSE
       RETURN QUERY
       SELECT
             Object_ComputerAccessories.Id         AS Id
           , Object_ComputerAccessories.ObjectCode AS Code
           , Object_ComputerAccessories.ValueData  AS Name
           , ObjectFloat_CountForPrice.ValueData  AS CountForPrice

       FROM Object AS Object_ComputerAccessories
       WHERE Object_ComputerAccessories.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ComputerAccessories(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_ComputerAccessories (0, '3')