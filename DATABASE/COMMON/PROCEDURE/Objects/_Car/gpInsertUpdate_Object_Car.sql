-- Function: gpInsertUpdate_Object_Car()

-- DROP FUNCTION gpInsertUpdate_Object_Car();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Car(
 INOUT ioId	                      Integer   ,    -- ключ объекта <Автомобиль> 
    IN inCode                     Integer   ,    -- Код объекта <Автомобиль>
    IN inName                     TVarChar  ,    -- Название объекта <Автомобиль>
    IN inRegistrationCertificate  TVarChar  ,    -- Техпаспорт объекта <Автомобиль>
    IN inCarModelId               Integer   ,    -- Модель авто          
    IN inSession                  TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Car());

   -- проверка прав уникальности для свойства <Наименование Автомобиля>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Car(), inName);
   -- проверка прав уникальности для свойства <Техпаспорт> 
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_RegistrationCertificate(), inRegistrationCertificate);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Car(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_RegistrationCertificate(), ioId, inRegistrationCertificate);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarModel(), ioId, inCarModelId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Car(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar)
  OWNER TO postgres;

                            