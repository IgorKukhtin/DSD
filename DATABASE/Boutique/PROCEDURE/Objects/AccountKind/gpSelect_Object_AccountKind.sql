-- Function: gpSelect_Object_AccountKind (TVarChar)

-- DROP FUNCTION gpSelect_Object_AccountKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AccountKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               isErased Boolean)
  AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_AccountKind());

   RETURN QUERY 
   SELECT
        Object_AccountKind.Id                   AS Id 
      , Object_AccountKind.ObjectCode           AS Code
      , Object_AccountKind.ValueData            AS NAME
       
      , Object_AccountKind.isErased   AS isErased
   FROM OBJECT AS Object_AccountKind
   WHERE Object_AccountKind.DescId = zc_Object_AccountKind();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 05.07.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AccountKind('2')
