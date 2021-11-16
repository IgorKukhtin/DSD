-- Function: gpSelect_Object_StaffListSummKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StaffListSummKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffListSummKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar, EnumName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StaffListSummKind());

   RETURN QUERY 
   SELECT
        Object_StaffListSummKind.Id           AS Id 
      , Object_StaffListSummKind.ObjectCode   AS Code
      , Object_StaffListSummKind.ValueData    AS NAME
      
      , ObjectString_Comment.ValueData        AS Comment
      , ObjectString_Enum.ValueData           AS EnumName
      
      , Object_StaffListSummKind.isErased     AS isErased
      
   FROM OBJECT AS Object_StaffListSummKind
        LEFT JOIN ObjectString AS ObjectString_Comment ON ObjectString_Comment.ObjectId = Object_StaffListSummKind.Id 
                                                      AND ObjectString_Comment.DescId = zc_ObjectString_StaffListSummKind_Comment()   
                              
        LEFT JOIN ObjectString AS ObjectString_Enum ON ObjectString_Enum.ObjectId = Object_StaffListSummKind.Id 
                                                   AND ObjectString_Enum.DescId = zc_ObjectString_Enum()   
                              
   WHERE Object_StaffListSummKind.DescId = zc_Object_StaffListSummKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_StaffListSummKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.13         * add Comment              
 30.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_StaffListSummKind('2')
