-- Function: gpSelect_Object_CashRegisterKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_CashRegisterKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CashRegisterKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_CashRegisterKind());

   RETURN QUERY 
   SELECT
        Object_CashRegisterKind.Id           AS Id 
      , Object_CashRegisterKind.ObjectCode   AS Code
      , Object_CashRegisterKind.ValueData    AS NAME
      , Object_CashRegisterKind.isErased     AS isErased
      
   FROM OBJECT AS Object_CashRegisterKind
                              
   WHERE Object_CashRegisterKind.DescId = zc_Object_CashRegisterKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CashRegisterKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.05.15                         *             

*/

-- тест
-- SELECT * FROM gpSelect_Object_CashRegisterKind('2')



