-- Function: gpchecklogin(tvarchar, tvarchar, tvarchar)

-- DROP FUNCTION gpchecklogin(tvarchar, tvarchar, tvarchar);

CREATE OR REPLACE FUNCTION gpCheckLogin(
IN inUserLogin TVarChar, 
IN inUserPassword TVarChar, 
INOUT Session TVarChar)
  RETURNS tvarchar AS
$BODY$BEGIN
   SELECT UserLogin.ObjectId INTO Session 
     FROM ObjectString UserLogin
     JOIN ObjectString UserPassword
       ON UserLogin.ValueData = inUserLogin
      AND UserLogin.DescId = zc_Object_User_Login() 
      AND UserLogin.ObjectId = UserPassword.ObjectId
    WHERE UserPassword.ValueData = inUserPassword AND UserPassword.DescId = zc_Object_User_Password();

    IF NOT found THEN
       RAISE EXCEPTION 'Неправильный логин или пароль';
    END IF;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpCheckLogin(TVarChar, TVarChar, TVarChar)
  OWNER TO postgres;