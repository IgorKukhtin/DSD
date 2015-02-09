-- Function: gpGet_Object_Quality (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Quality (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Quality(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Quality());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Quality()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS Comment

           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (NULL AS Boolean) AS isErased

       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Quality.Id              AS Id
           , Object_Quality.ObjectCode      AS Code
           , Object_Quality.ValueData       AS Name
           , ObjectString_Comment.ValueData AS Comment
         
           , Object_Juridical.Id            AS JuridicalId
           , Object_Juridical.ValueData     AS JuridicalName

           , Object_Quality.isErased        AS isErased
           
       FROM Object AS Object_Quality

            LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_Quality.Id 
                                 AND ObjectString_Comment.DescId = zc_ObjectString_Quality_Comment()
                                 
            LEFT JOIN ObjectLink AS ObjectLink_Quality_Juridical
                                 ON ObjectLink_Quality_Juridical.ObjectId = Object_Quality.Id
                                AND ObjectLink_Quality_Juridical.DescId = zc_ObjectLink_Quality_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Quality_Juridical.ChildObjectId

       WHERE Object_Quality.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_Quality (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 059.02.15         *         
*/

-- тест
-- SELECT * FROM gpGet_Object_Quality (0, inSession := '5')
