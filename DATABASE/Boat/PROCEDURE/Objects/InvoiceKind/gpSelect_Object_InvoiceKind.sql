--Function: gpSelect_Object_InvoiceKind(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InvoiceKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InvoiceKind(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , Enum TVarChar
             , isErased Boolean
              )
AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InvoiceKind());

   RETURN QUERY
       SELECT
             Object.Id                      AS Id
           , Object.ObjectCode              AS Code
           , Object.ValueData               AS Name
           , ObjectString_Comment.ValueData AS Comment
           , ObjectString_Enum.ValueData    AS Enum
           , Object.isErased                AS isErased
       FROM Object
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_InvoiceKind_Comment()

            LEFT JOIN ObjectString AS ObjectString_Enum
                                   ON ObjectString_Enum.ObjectId = Object.Id
                                  AND ObjectString_Enum.DescId = zc_ObjectString_Enum()
       WHERE Object.DescId = zc_Object_InvoiceKind()

      /*UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , 'УДАЛИТЬ' :: TVarChar AS Name
            , ''        :: TVarChar AS Comment
            , ''        :: TVarChar AS Enum
            , FALSE                 AS isErased*/
     ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.12.23          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_InvoiceKind('2')
