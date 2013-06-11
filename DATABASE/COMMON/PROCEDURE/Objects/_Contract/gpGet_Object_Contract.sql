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

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST ('' as TVarChar)  AS InvNumber
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_Contract();
   ELSE
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
       WHERE Object_Contract.Id = inId;
   END IF;
     
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Contract (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13          *
 12.04.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Contract (2, '')
