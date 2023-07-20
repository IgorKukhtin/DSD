-- Function: gpSelect_Object_TaxKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_TaxKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_TaxKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Code_str TVarChar, Name TVarChar
             , Enum TVarChar, NDS TFloat
             , Info TVarChar, Comment TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_TaxKind());

   RETURN QUERY 
   SELECT
        Object_TaxKind.Id           AS Id 
      , Object_TaxKind.ObjectCode   AS Code
      , ObjectString_TaxKind_Code.ValueData :: TVarChar AS Code_str
      , Object_TaxKind.ValueData    AS Name
      
      , ObjectString_Enum.ValueData          AS Enum
      , ObjectFloat_TaxKind_Value.ValueData  AS Value
      
      , ObjectString_TaxKind_Info.ValueData    AS Info
      , ObjectString_TaxKind_Comment.ValueData AS Comment
      
      , Object_TaxKind.isErased     AS isErased
      
   FROM OBJECT AS Object_TaxKind
        LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                              ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id 
                             AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()   
        LEFT JOIN ObjectString AS ObjectString_TaxKind_Code
                               ON ObjectString_TaxKind_Code.ObjectId = Object_TaxKind.Id 
                              AND ObjectString_TaxKind_Code.DescId = zc_ObjectString_TaxKind_Code()

        LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                               ON ObjectString_TaxKind_Info.ObjectId = Object_TaxKind.Id 
                              AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()
        LEFT JOIN ObjectString AS ObjectString_TaxKind_Comment
                               ON ObjectString_TaxKind_Comment.ObjectId = Object_TaxKind.Id 
                              AND ObjectString_TaxKind_Comment.DescId = zc_ObjectString_TaxKind_Comment()   
        
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object_TaxKind.Id 
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()
   WHERE Object_TaxKind.DescId = zc_Object_TaxKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.23         *
 11.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_TaxKind('2')