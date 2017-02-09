-- Function: gpGet_Object_CashRegister()

DROP FUNCTION IF EXISTS gpGet_Object_CashRegister(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CashRegister(
    IN inId          Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CashRegisterKindId Integer, CashRegisterKindName TVarChar) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_CashRegister()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)    AS CashRegisterKindId
           , CAST ('' as TVarChar)  AS CashRegisterKindName;
   ELSE
       RETURN QUERY
       SELECT
             Object_CashRegister.Id         AS Id
           , Object_CashRegister.ObjectCode AS Code
           , Object_CashRegister.ValueData  AS Name

           , Object_CashRegisterKind.Id          AS CashRegisterKindId
           , Object_CashRegisterKind.ValueData   AS CashRegisterKindName

       FROM Object AS Object_CashRegister
            LEFT JOIN ObjectLink AS ObjectLink_CashRegister_CashRegisterKind
                                 ON ObjectLink_CashRegister_CashRegisterKind.ObjectId = Object_CashRegister.Id
                                AND ObjectLink_CashRegister_CashRegisterKind.DescId = zc_ObjectLink_CashRegister_CashRegisterKind()
            LEFT JOIN Object AS Object_CashRegisterKind ON Object_CashRegisterKind.Id = ObjectLink_CashRegister_CashRegisterKind.ChildObjectId
            
       WHERE Object_CashRegister.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CashRegister(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
22.05.15                         *  
*/

-- тест
-- SELECT * FROM gpGet_Object_CashRegister (0, '2')