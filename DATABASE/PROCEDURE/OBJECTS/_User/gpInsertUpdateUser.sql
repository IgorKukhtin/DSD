-- Function: gpinsertupdateuser()

-- DROP FUNCTION gpinsertupdateuser();

CREATE OR REPLACE FUNCTION gpInsertUpdateUser(
INOUT ioId	 Integer   ,   	/* ключ объекта <Пользователь> */
IN inUserName    TVarChar  ,    /* главное Название пользователя объекта <Пользователь> */
IN inLogin       TVarChar  ,    /* логин пользователя*/
IN inPassword    TVarChar       /* пароль пользователя*/
)
  RETURNS integer AS
$BODY$BEGIN

   ioId := lpInsertUpdateObject(ioId, zc_User(), 0, inUserName);

   PERFORM lpInsertUpdateObjectString(zc_User_Login(), ioId, inLogin);

   PERFORM lpInsertUpdateObjectString(zc_User_Password(), ioId, inPassword);
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdateUser(Integer, TVarChar, TVarChar, TVarChar)
  OWNER TO postgres;
  
                            