-- Function: gpSelect_Object_Contract()

-- DROP FUNCTION gpSelect_Object_Contract (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Contract(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, Comment TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Contract());

   RETURN QUERY 
   SELECT
         Object_Contract.Id               AS Id
       , ObjectString_InvNumber.ValueData AS InvNumber
       , ObjectString_Comment.ValueData   AS Comment
       , Object_Contract.isErased         AS isErased
   FROM Object AS Object_Contract
        LEFT JOIN ObjectString AS ObjectString_InvNumber
               ON ObjectString_InvNumber.ObjectId = Object_Contract.Id
              AND ObjectString_InvNumber.DescId = zc_objectString_Contract_InvNumber()
        LEFT JOIN ObjectString AS ObjectString_Comment
               ON ObjectString_Comment.ObjectId = Object_Contract.Id
              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
   WHERE Object_Contract.DescId = zc_Object_Contract();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Contract (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13          *
 12.04.13                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Contract('2')
