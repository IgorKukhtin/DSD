-- Function: gpSelect_Object_CashRegister()

DROP FUNCTION IF EXISTS gpSelect_Object_CashRegister(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CashRegister(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CashRegisterKindId Integer, CashRegisterKindName TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CashRegister()());

   RETURN QUERY
   SELECT
          Object_CashRegister.Id         AS Id
        , Object_CashRegister.ObjectCode AS Code
        , Object_CashRegister.ValueData  AS Name

        , Object_CashRegisterKind.Id          AS CashRegisterKindId
        , Object_CashRegisterKind.ValueData   AS CashRegisterKindName

        , Object_CashRegister.isErased             AS isErased

   FROM Object AS Object_CashRegister
        LEFT JOIN ObjectLink AS ObjectLink_CashRegister_CashRegisterKind
                             ON ObjectLink_CashRegister_CashRegisterKind.ObjectId = Object_CashRegister.Id
                            AND ObjectLink_CashRegister_CashRegisterKind.DescId = zc_ObjectLink_CashRegister_CashRegisterKind()
        LEFT JOIN Object AS Object_CashRegisterKind ON Object_CashRegisterKind.Id = ObjectLink_CashRegister_CashRegisterKind.ChildObjectId
          
   WHERE Object_CashRegister.DescId = zc_Object_CashRegister();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CashRegister(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 22.05.15                         *  
*/

-- тест
-- SELECT * FROM gpSelect_Object_CashRegister('2')