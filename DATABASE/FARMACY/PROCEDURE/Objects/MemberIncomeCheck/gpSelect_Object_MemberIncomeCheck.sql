-- Function: gpSelect_Object_MemberIncomeCheck(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberIncomeCheck(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberIncomeCheck(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MemberIncomeCheck());

   RETURN QUERY 
     SELECT Object_MemberIncomeCheck.Id                 AS Id
          , Object_MemberIncomeCheck.ObjectCode         AS Code
          , Object_MemberIncomeCheck.ValueData          AS Name
          , Object_MemberIncomeCheck.isErased           AS isErased
     FROM Object AS Object_MemberIncomeCheck
     WHERE Object_MemberIncomeCheck.DescId = zc_Object_MemberIncomeCheck();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MemberIncomeCheck(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.17         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_MemberIncomeCheck('2')