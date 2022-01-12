-- Function: gpSelect_Object_Form()

DROP FUNCTION IF EXISTS gpSelect_Object_Form();
DROP FUNCTION IF EXISTS gpSelect_Object_Form(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Form(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, HelpFile TVarChar, isErased boolean) AS
$BODY$BEGIN
   
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

    RETURN QUERY 
    SELECT 
        Object.Id                       AS Id 
      , Object.ObjectCode               AS Code
      , Object.ValueData                AS Name
      , ObjectString_HelpFile.ValueData AS HelpFile
      , Object.isErased                 AS isErased
    FROM 
        Object
        LEFT OUTER JOIN ObjectString AS ObjectString_HelpFile
                                     ON ObjectString_HelpFile.ObjectId = Object.Id
                                    AND ObjectString_HelpFile.DescId = zc_ObjectString_Form_HelpFile()
    WHERE 
        Object.DescId = zc_Object_Form();
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Form(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 16.12.15                                                         * zc_ObjectString_Form_HelpFile
 19.12.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Action('2')