-- Function: gpSelect_Object_BankPOSTerminal()

DROP FUNCTION IF EXISTS gpSelect_Object_BankPOSTerminal(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BankPOSTerminal(
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
   WHERE Object_BankPOSTerminal.DescId = zc_Object_BankPOSTerminal();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 16.02.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_BankPOSTerminal('3')