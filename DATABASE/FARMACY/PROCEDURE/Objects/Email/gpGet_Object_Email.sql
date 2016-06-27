-- Function: gpGet_Object_Email()

DROP FUNCTION IF EXISTS gpGet_Object_Email (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Email(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EmailKindId Integer, EmailKindName TVarChar
)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Email());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Email()) AS Code
           , CAST ('' AS TVarChar)  AS Name
          
           , CAST (0 AS Integer)    AS EmailKindId
           , CAST ('' AS TVarChar)  AS EmailKindName;
   ELSE
       RETURN QUERY
       SELECT
             Object_Email.Id         AS Id
           , Object_Email.ObjectCode AS Code
           , Object_Email.ValueData  AS Name

           , Object_EmailKind.Id         AS EmailKindId
           , Object_EmailKind.ValueData  AS EmailKindName

       FROM Object AS Object_Email
           LEFT JOIN ObjectLink AS ObjectLink_Email_EmailKind
                                ON ObjectLink_Email_EmailKind.ObjectId = Object_Email.Id
                               AND ObjectLink_Email_EmailKind.DescId = zc_ObjectLink_Email_EmailKind()
           LEFT JOIN Object AS Object_EmailKind ON Object_EmailKind.Id = ObjectLink_Email_EmailKind.ChildObjectId

       WHERE Object_Email.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Email (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.06.16         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_Email (0, '2')
