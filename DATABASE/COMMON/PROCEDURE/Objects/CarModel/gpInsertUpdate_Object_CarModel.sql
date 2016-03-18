-- Function: gpInsertUpdate_Object_CarModel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CarModel (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CarModel(
 INOUT ioId             Integer   ,     -- ключ объекта < Марки Автомобиля> 
    IN inCode           Integer   ,     -- Код объекта <Марки Автомобиля> 
    IN inName           TVarChar  ,     -- Название объекта <Марки Автомобиля>
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_CarModel());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CarModel());
   
   -- проверка прав уникальности для свойства <Наименование Марки Автомобиля>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CarModel(), inName);
   -- проверка прав уникальности для свойства <Код Марки Автомобиля>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CarModel(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CarModel(), vbCode_calc, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CarModel (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.13                                        * пытаемся найти код
 10.06.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CarModel()