-- Function: gpSelect_Object_EmailKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_EmailKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_EmailKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar, DropBox TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_EmailKind());

   RETURN QUERY 
   SELECT
        Object_EmailKind.Id           AS Id 
      , Object_EmailKind.ObjectCode   AS Code
      , Object_EmailKind.ValueData    AS Name
      , ObjectString_Enum.ValueData    ::TVarChar AS EnumName
      , ObjectString_DropBox.ValueData ::TVarChar AS DropBox
      
      , Object_EmailKind.isErased     AS isErased
      
   FROM Object AS Object_EmailKind
       LEFT JOIN ObjectString AS ObjectString_Enum
                              ON ObjectString_Enum.ObjectId = Object_EmailKind.Id 
                             AND ObjectString_Enum.DescId = zc_ObjectString_Enum()
       LEFT JOIN ObjectString AS ObjectString_DropBox
                              ON ObjectString_DropBox.ObjectId = Object_EmailKind.Id
                             AND ObjectString_DropBox.DescId = zc_ObjectString_EmailKind_DropBox()                     
   WHERE Object_EmailKind.DescId = zc_Object_EmailKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.02.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_EmailKind('2')
