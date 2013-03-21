-- Function: gpInsertUpdate_Object_User()

-- DROP FUNCTION gpInsertUpdate_Object_User();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_User(
INOUT ioId	 Integer   ,   	/* ключ объекта <Пользователь> */
IN inUserName    TVarChar  ,    /* главное Название пользователя объекта <Пользователь> */
IN inLogin       TVarChar  ,    /* логин пользователя */
IN inPassword    TVarChar  ,    /* пароль пользователя */
IN inSession     TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
   PERFORM lpCheckRight(inSession, zc_Object_Process_User());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_User(), inUserName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_User(), 0, inUserName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Login(), ioId, inLogin);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Password(), ioId, inPassword);
 
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            