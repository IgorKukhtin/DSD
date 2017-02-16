-- Function: gpSelect_Object_InfoMoneyGroup (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyGroup (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyGroup(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean)
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoneyGroup());

   RETURN QUERY 
   SELECT 
         Object_InfoMoneyGroup.Id         AS Id 
       , Object_InfoMoneyGroup.ObjectCode AS Code
       , Object_InfoMoneyGroup.ValueData  AS Name
       , Object_InfoMoneyGroup.isErased   AS isErased
   FROM Object AS Object_InfoMoneyGroup
   WHERE Object_InfoMoneyGroup.DescId = zc_Object_InfoMoneyGroup();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoneyGroup (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *                             
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoneyGroup (zfCalc_UserAdmin()) ORDER BY Code
