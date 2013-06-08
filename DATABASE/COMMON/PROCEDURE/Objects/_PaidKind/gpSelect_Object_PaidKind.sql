--Function: gpSelect_Object_PaidKind(TVarChar)

--DROP FUNCTION gpSelect_Object_PaidKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PaidKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id
   , Object.ObjectCode AS Code
   , Object.ValueData AS Name
   , Object.isErased
   FROM Object
   WHERE Object.DescId = zc_Object_PaidKind();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_PaidKind(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PaidKind('2')