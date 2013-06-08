-- Function: gpInsertUpdate_Object_Measure()

-- DROP FUNCTION gpInsertUpdate_Object_Measure();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Measure(
 INOUT ioId	         Integer,   	-- ключ объекта <Единица измерения> 
    IN inCode        Integer,       -- свойство <Код Единицы измерения> 
    IN inName        TVarChar,      -- главное Название Единицы измерения
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Measure(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Measure(), 0, inName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            