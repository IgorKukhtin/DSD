-- Function: gpGet_Object_CashRegister()

DROP FUNCTION IF EXISTS gpGet_Object_CashRegister(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CashRegister(
    IN inId          Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CashRegisterKindId Integer, CashRegisterKindName TVarChar
             , SerialNumber TVarChar
             , TimePUSHFinal1 TDateTime, TimePUSHFinal2 TDateTime) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)       AS Id
           , lfGet_ObjectCode(0, zc_Object_CashRegister()) AS Code
           , CAST ('' as TVarChar)     AS Name

           , CAST (0 as Integer)       AS CashRegisterKindId
           , CAST ('' as TVarChar)     AS CashRegisterKindName

           , CAST ('' as TVarChar)     AS SerialNumber
           , CAST (Null as TDateTime)  AS TimePUSHFinal1
           , CAST (Null as TDateTime)  AS TimePUSHFinal2;

   ELSE
       RETURN QUERY
       SELECT
             Object_CashRegister.Id         AS Id
           , Object_CashRegister.ObjectCode AS Code
           , Object_CashRegister.ValueData  AS Name

           , Object_CashRegisterKind.Id          AS CashRegisterKindId
           , Object_CashRegisterKind.ValueData   AS CashRegisterKindName

           , ObjectString_SerialNumber.ValueData     AS SerialNumber
           , ObjectDate_TimePUSHFinal1.ValueData     AS TimePUSHFinal1
           , ObjectDate_TimePUSHFinal2.ValueData     AS TimePUSHFinal2

       FROM Object AS Object_CashRegister
            LEFT JOIN ObjectLink AS ObjectLink_CashRegister_CashRegisterKind
                                 ON ObjectLink_CashRegister_CashRegisterKind.ObjectId = Object_CashRegister.Id
                                AND ObjectLink_CashRegister_CashRegisterKind.DescId = zc_ObjectLink_CashRegister_CashRegisterKind()
            LEFT JOIN Object AS Object_CashRegisterKind ON Object_CashRegisterKind.Id = ObjectLink_CashRegister_CashRegisterKind.ChildObjectId
            
            LEFT JOIN ObjectString AS ObjectString_SerialNumber 
                                   ON ObjectString_SerialNumber.ObjectId = Object_CashRegister.Id
                                  AND ObjectString_SerialNumber.DescId = zc_ObjectString_CashRegister_SerialNumber()
          
            LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal1 
                                 ON ObjectDate_TimePUSHFinal1.ObjectId = Object_CashRegister.Id
                                AND ObjectDate_TimePUSHFinal1.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal1()

            LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal2 
                                 ON ObjectDate_TimePUSHFinal2.ObjectId = Object_CashRegister.Id
                                AND ObjectDate_TimePUSHFinal2.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal2()

       WHERE Object_CashRegister.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CashRegister(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 04.03.19                                                                      *  
 22.05.15                         *  
*/

-- тест
-- SELECT * FROM gpGet_Object_CashRegister (0, '2')