-- Function: gpSelect_Object_ModelServiceKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ModelServiceKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ModelServiceKind(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ModelServiceKind());

   RETURN QUERY 
   SELECT
        Object_ModelServiceKind.Id           AS Id 
      , Object_ModelServiceKind.ObjectCode   AS Code
      , Object_ModelServiceKind.ValueData    AS NAME
      
      , ObjectString_Comment.ValueData       AS Comment
      
      , Object_ModelServiceKind.isErased     AS isErased
      
   FROM OBJECT AS Object_ModelServiceKind
        LEFT JOIN ObjectString AS ObjectString_Comment ON ObjectString_Comment.ObjectId = Object_ModelServiceKind.Id 
                                                      AND ObjectString_Comment.DescId = zc_ObjectString_ModelServiceKind_Comment()   
                                                                                   
   WHERE Object_ModelServiceKind.DescId = zc_Object_ModelServiceKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ModelServiceKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.13         * add Comment               
 18.10.13         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_ModelServiceKind('2')
