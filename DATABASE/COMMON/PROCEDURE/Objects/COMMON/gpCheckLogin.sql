-- Function: gpchecklogin(tvarchar, tvarchar, tvarchar)

-- DROP FUNCTION gpchecklogin(tvarchar, tvarchar, tvarchar);

CREATE OR REPLACE FUNCTION gpCheckLogin(
IN inUserLogin TVarChar, 
IN inUserPassword TVarChar, 
INOUT Session TVarChar)
  RETURNS tvarchar AS
$BODY$BEGIN
   SELECT UserLogin.Id INTO Session 
     FROM Object AS UserLogin
     JOIN ObjectString UserPassword
       ON UserPassword.ValueData = inUserPassword 
      AND UserPassword.DescId = zc_ObjectString_User_Password()
      AND UserPassword.ObjectId = UserLogin.Id
    WHERE UserLogin.ValueData = inUserLogin
      AND UserLogin.DescId = zc_Object_User();

    IF NOT found THEN
       RAISE EXCEPTION 'Неправильный логин или пароль';
    END IF;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpCheckLogin(TVarChar, TVarChar, TVarChar)
  OWNER TO postgres;