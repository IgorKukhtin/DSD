-- Function: gpSelect_Object_ProfitLossDirection (TVarChar)

-- DROP FUNCTION gpSelect_Object_ProfitLossDirection (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProfitLossDirection(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ProfitLossDirection());

   RETURN QUERY 
   SELECT
         Object_ProfitLossDirection.Id         AS Id 
       , Object_ProfitLossDirection.ObjectCode AS Code
       , Object_ProfitLossDirection.ValueData  AS Name
       , Object_ProfitLossDirection.isErased   AS isErased
   FROM Object AS Object_ProfitLossDirection
   WHERE Object_ProfitLossDirection.DescId = zc_Object_ProfitLossDirection();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ProfitLossDirection (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ProfitLossDirection('2')
