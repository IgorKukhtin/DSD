-- Function: gpSelect_Object_User()

--DROP FUNCTION gpSelect_Object_User();

CREATE OR REPLACE FUNCTION gpSelect_Object_User(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Login TVarChar, Password TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   PERFORM lpCheckRight(inSession, zc_Object_Process_User());

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
   WHERE Object.DescId = zc_Object_User();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpSelect_Object_User(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_User('2')