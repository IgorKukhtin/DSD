-- Function: gpGet_Object_User()

--DROP FUNCTION gpGet_Object_User();

CREATE OR REPLACE FUNCTION gpGet_Object_User(
    IN inId          Integer,       -- пользователь 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Login TVarChar, Password TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
--   PERFORM lpCheckRight(inSession, zc_Object_Process_User());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , MAX (Object.ObjectCode) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST ('' as TVarChar)  AS LOGIN
           , CAST ('' as TVarChar)  AS Password
           , CAST (NULL AS Boolean) AS isErased
       FROM Object 
       WHERE Object.DescId = zc_Object_User();
   ELSE
      RETURN QUERY 
      SELECT 
            Object.Id
          , Object.ObjectCode
          , Object.ValueData
          , ObjectString_UserLogin.ValueData
          , ObjectString_UserPassword.ValueData
          , Object.isErased
      FROM Object
   LEFT JOIN ObjectString AS ObjectString_UserLogin 
          ON ObjectString_UserLogin.DescId = zc_ObjectString_User_Login() 
         AND ObjectString_UserLogin.ObjectId = Object.Id
   LEFT JOIN ObjectString AS ObjectString_UserPassword 
          ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Password() 
         AND ObjectString_UserPassword.ObjectId = Object.Id
      WHERE Object.Id = inId;
   END IF;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_User(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.13          *

*/

-- тест
-- SELECT * FROM gpSelect_User('2')