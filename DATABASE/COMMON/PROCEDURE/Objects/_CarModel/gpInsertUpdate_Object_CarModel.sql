-- Function: gpInsertUpdate_Object_CarModel()

-- DROP FUNCTION gpInsertUpdate_Object_CarModel();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CarModel(
INOUT ioId	         Integer   ,   	/* ключ объекта < Бизнес> */
IN inCode                Integer   ,    /* Код объекта <Бизнес> */
IN inName                TVarChar  ,    /* Название объекта <Бизнес> */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_CarModel());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CarModel(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_CarModel(), inCode, inName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            