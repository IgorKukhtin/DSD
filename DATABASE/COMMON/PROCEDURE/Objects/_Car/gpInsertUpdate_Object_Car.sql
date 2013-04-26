-- Function: gpInsertUpdate_Object_Car()

-- DROP FUNCTION gpInsertUpdate_Object_Car();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Car(
INOUT ioId	         Integer   ,   	/* ключ объекта < Банк> */
IN inCode                Integer   ,    /* Код объекта <Банк> */
IN inName                TVarChar  ,    /* Название объекта <Банк> */
IN inRegistrationCertificate                 TVarChar  ,    /* МФО */
IN inCarModelId          Integer   ,    /* Модель авто          */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Car());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Car(), inName);
   PERFORM lpCheckUnique_Object_String_ValueData(ioId, zc_Object_Car_RegistrationCertificate(), inRegistrationCertificate);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Car(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_RegistrationCertificate(), ioId, inRegistrationCertificate);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarModel(), ioId, inCarModelId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            