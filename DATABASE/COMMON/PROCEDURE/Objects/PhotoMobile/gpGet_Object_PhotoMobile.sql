-- Function: gpGet_Object_PhotoMobile()

DROP FUNCTION IF EXISTS gpGet_Object_PhotoMobile(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PhotoMobile(
    IN inId          Integer,       -- ключ объекта <Регионы>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PhotoData Tblob
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
           , lfGet_ObjectCode(0, zc_Object_PhotoMobile()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TBlob)     AS PhotoData
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PhotoMobile.Id         AS Id
           , Object_PhotoMobile.ObjectCode AS Code
           , Object_PhotoMobile.ValueData  AS Name
           , ObjectBlob_Photo.ValueData  AS PhotoData
           , Object_PhotoMobile.isErased   AS isErased
       FROM Object AS Object_PhotoMobile
         LEFT JOIN ObjectBlob AS ObjectBlob_Photo
                              ON ObjectBlob_Photo.ObjectId = Object_PhotoMobile.Id
                             AND ObjectBlob_Photo.DescId = zc_ObjectBlob_PhotoMobile_Data()
 
       WHERE Object_PhotoMobile.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PhotoMobile(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.03.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_PhotoMobile (0, '2')