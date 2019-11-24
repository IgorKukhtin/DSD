-- Function: gpGet_Object_MarginCategory (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MarginCategory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MarginCategory(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isSite Boolean
             , isErased Boolean
             , Percent TFloat) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MarginCategory());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MarginCategory()) AS Code
           , CAST ('' AS TVarChar)  AS NAME
           , FALSE                  AS isSite
           , FALSE                  AS isErased
           , NULL::TFloat           AS Percent;
   ELSE
       RETURN QUERY 
       SELECT Object_MarginCategory.Id                            AS Id
            , Object_MarginCategory.ObjectCode                    AS Code
            , Object_MarginCategory.ValueData                     AS Name
            , ObjectBoolean_MarginCategory_Site.ValueData        AS isSite
            , Object_MarginCategory.isErased                      AS isErased
            , ObjectFloat_MarginCategory_Percent.ValueData AS Percent
       FROM Object AS Object_MarginCategory
            LEFT JOIN ObjectBoolean AS ObjectBoolean_MarginCategory_Site
                                    ON ObjectBoolean_MarginCategory_Site.ObjectId = Object_MarginCategory.Id 
                                   AND ObjectBoolean_MarginCategory_Site.DescId = zc_ObjectBoolean_MarginCategory_Site() 
            LEFT JOIN ObjectFloat AS ObjectFloat_MarginCategory_Percent
                                  ON ObjectFloat_MarginCategory_Percent.ObjectId = Object_MarginCategory.Id 
                                 AND ObjectFloat_MarginCategory_Percent.DescId = zc_ObjectFloat_MarginCategory_Percent() 
       WHERE Object_MarginCategory.Id = inId;
   END IF;
   
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.11.19         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_MarginCategory(0,'2')