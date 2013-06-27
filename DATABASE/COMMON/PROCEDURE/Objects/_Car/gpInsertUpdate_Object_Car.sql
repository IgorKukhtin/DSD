-- Function: gpInsertUpdate_Object_Car()

-- DROP FUNCTION gpInsertUpdate_Object_Car();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Car(
 INOUT ioId                       Integer   ,    -- ключ объекта <Автомобиль> 
    IN inCode                     Integer   ,    -- Код объекта <Автомобиль>
    IN inName                     TVarChar  ,    -- Название объекта <Автомобиль>
    IN inRegistrationCertificate  TVarChar  ,    -- Техпаспорт объекта <Автомобиль>
    IN inCarModelId               Integer   ,    -- Модель авто          
    IN inSession                  TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   

BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Car());
   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Car();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование Автомобиля>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Car(), inName);
   -- проверка прав уникальности для свойства <Код Автомобиля>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Car(), Code_max);
   -- проверка прав уникальности для свойства <Техпаспорт> 
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Car_RegistrationCertificate(), inRegistrationCertificate);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Car(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_RegistrationCertificate(), ioId, inRegistrationCertificate);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarModel(), ioId, inCarModelId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Car(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar)
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.13          *
 05.06.13          

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Car()
                            