-- Function: gpSelect_Object_PayrollGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_PayrollGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PayrollGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BankPOSTerminal()());

   RETURN QUERY
   SELECT
          Object_BankPOSTerminal.Id         AS Id
        , Object_BankPOSTerminal.ObjectCode AS Code
        , Object_BankPOSTerminal.ValueData  AS Name

        , Object_BankPOSTerminal.isErased   AS isErased
   FROM Object AS Object_BankPOSTerminal
   WHERE Object_BankPOSTerminal.DescId = zc_Object_PayrollGroup();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.08.19                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PayrollGroup('3')