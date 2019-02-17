-- Function: gpGet_Object_BankPOSTerminal()

DROP FUNCTION IF EXISTS gpGet_Object_BankPOSTerminal(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BankPOSTerminal(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_BankPOSTerminal()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_BankPOSTerminal.Id                       AS Id
           , Object_BankPOSTerminal.ObjectCode               AS Code
           , Object_BankPOSTerminal.ValueData                AS Name
           , Object_BankPOSTerminal.isErased                 AS isErased

       FROM Object AS Object_BankPOSTerminal
       WHERE Object_BankPOSTerminal.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 16.02.19         *

*/

-- тест
-- SELECT * FROM gpGet_Object_BankPOSTerminal (1, '3')