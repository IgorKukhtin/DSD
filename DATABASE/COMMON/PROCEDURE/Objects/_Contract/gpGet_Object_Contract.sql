-- Function: gpGet_Object_Contract()

-- DROP FUNCTION gpGet_Object_Contract (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Contract(
    IN inId             Integer,       -- ключ объекта <Договор>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, Comment TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Contract());

   RETURN QUERY
   SELECT
         Object_Contract.Id
       , ObjectString_InvNumber.ValueData AS InvNumber
       , ObjectString_Comment.ValueData AS Comment
       , Object_Contract.isErased 
   FROM Object AS Object_Contract
        LEFT JOIN ObjectString AS ObjectString_InvNumber
                 ON ObjectString_InvNumber.ObjectId = Object_Contract.Id
                AND ObjectString_InvNumber.DescId = zc_objectString_Contract_InvNumber()
        LEFT JOIN ObjectString AS ObjectString_Comment
                 ON ObjectString_Comment.ObjectId = Object_Contract.Id
                AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()
   WHERE Object_Contract.Id = inId;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Contract (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Contract (2, '')
