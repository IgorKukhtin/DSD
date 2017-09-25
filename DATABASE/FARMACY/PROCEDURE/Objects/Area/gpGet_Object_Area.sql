-- Function: gpGet_Object_Area()

DROP FUNCTION IF EXISTS gpGet_Object_Area(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Area(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Email TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Area()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS Email
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_Area.Id                     AS Id
            , Object_Area.ObjectCode             AS Code
            , Object_Area.ValueData              AS Name
            , ObjectString_Area_Email.ValueData  AS Email
            , Object_Area.isErased               AS isErased
       FROM Object AS Object_Area
            LEFT JOIN ObjectString AS ObjectString_Area_Email
                            ON ObjectString_Area_Email.ObjectId = Object_Area.Id 
                           AND ObjectString_Area_Email.DescId = zc_ObjectString_Area_Email()
       WHERE Object_Area.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Area(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.17         *
 14.11.13         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Area (0, '2')