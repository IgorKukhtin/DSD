-- Function: gpSelect_Object_MailKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MailKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MailKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_MailKind());

   RETURN QUERY 
   SELECT
        Object_MailKind.Id           AS Id 
      , Object_MailKind.ObjectCode   AS Code
      , Object_MailKind.ValueData    AS Name
      , ObjectString_Enum.ValueData  AS EnumName      
      , Object_MailKind.isErased     AS isErased
      
   FROM OBJECT AS Object_MailKind
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object_MailKind.Id 
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()                               
   WHERE Object_MailKind.DescId = zc_Object_MailKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.03.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MailKind('2')