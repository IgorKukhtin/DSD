-- Function: gpGet_Object_HouseholdInventory()

DROP FUNCTION IF EXISTS gpGet_Object_HouseholdInventory(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_HouseholdInventory(
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
       -- проверка прав пользователя на вызов процедуры
       PERFORM lpCheckRight(inSession, zc_Enum_Process_Update_Object_HouseholdInventory());

       RETURN QUERY
       SELECT
             CAST (0 as Integer)       AS Id
           , lfGet_ObjectCode(0, zc_Object_HouseholdInventory()) AS Code
           , CAST ('' as TVarChar)     AS Name;

   ELSE
       RETURN QUERY
       SELECT
             Object_HouseholdInventory.Id         AS Id
           , Object_HouseholdInventory.ObjectCode AS Code
           , Object_HouseholdInventory.ValueData  AS Name

       FROM Object AS Object_HouseholdInventory
       WHERE Object_HouseholdInventory.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_HouseholdInventory(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Object_HouseholdInventory (0, '3')