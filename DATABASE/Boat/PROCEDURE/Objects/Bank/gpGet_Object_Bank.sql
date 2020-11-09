-- Function: gpGet_Object_Bank(Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Bank(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Bank(
    IN inId          Integer,       -- ключ объекта <Банки>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , IBAN TVarChar, Comment TVarChar
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   IF COALESCE (inId, 0) = 0
   THEN
   RETURN QUERY
       SELECT
             CAST (0 as Integer)                AS Id
           , lfGet_ObjectCode(0, zc_Object_Bank()) AS Code
           , CAST ('' as TVarChar)              AS Name
           , CAST ('' as TVarChar)              AS IBAN
           , CAST ('' as TVarChar)              AS Comment;
   ELSE
       RETURN QUERY
       SELECT
             Object_Bank.Id                  AS Id
           , Object_Bank.ObjectCode          AS Code
           , Object_Bank.ValueData           AS Name
           , ObjectString_IBAN.ValueData     AS IBAN
           , ObjectString_Comment.ValueData  AS Comment

       FROM Object AS Object_Bank
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Bank.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Bank_Comment()

            LEFT JOIN ObjectString AS ObjectString_IBAN
                                   ON ObjectString_IBAN.ObjectId = Object_Bank.Id
                                  AND ObjectString_IBAN.DescId = zc_ObjectString_Bank_IBAN()
       WHERE Object_Bank.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.20         *
*/

-- тест
-- SELECT * FROM  gpGet_Object_Bank (2, '')
