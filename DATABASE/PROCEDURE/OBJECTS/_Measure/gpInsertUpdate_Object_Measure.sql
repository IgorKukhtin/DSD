-- Function: gpInsertUpdate_Object_Measure()

-- DROP FUNCTION gpInsertUpdate_Object_Measure();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Measure(
INOUT ioId	 Integer   ,   	/* ключ объекта <Единица измерения> */
IN inMeasureName TVarChar  ,    /* главное Название пользователя объекта <Пользователь> */
IN inSession     TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Measure(), inMeasureName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Measure(), 0, inMeasureName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            