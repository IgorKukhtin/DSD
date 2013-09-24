-- Function: gpInsertUpdate_Object_Car(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_Car(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Car(
 INOUT ioId                       Integer   ,    -- ключ объекта <Автомобиль> 
    IN inCode                     Integer   ,    -- Код объекта <Автомобиль>
    IN inName                     TVarChar  ,    -- Название объекта <Автомобиль>
    IN inRegistrationCertificate  TVarChar  ,    -- Техпаспорт объекта <Автомобиль>
    IN inStartDateRate            TDateTime ,    -- Начальная дата для Типа нормы
    IN inEndDateRate              TDateTime ,    -- Конечная дата для Типа нормы
    IN inCarModelId               Integer   ,    -- Модель авто          
    IN inUnitId                   Integer   ,    -- Подразделение
    IN inPersonalDriverId         Integer   ,    -- Сотрудник (водитель)
    IN inFuelMasterId             Integer   ,    -- Вид топлива (основной)
    IN inFuelChildId              Integer   ,    -- Вид топлива (дополнительный)
    IN inRateFuelKindId           Integer   ,    -- Типы норм для топлива
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   

BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Car());
   vbUserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Car()); 
   
   -- проверка прав уникальности для свойства <Наименование Автомобиля>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Car(), inName);
   -- проверка прав уникальности для свойства <Код Автомобиля>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Car(), vbCode_calc);
   -- проверка прав уникальности для свойства <Техпаспорт> 
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Car_RegistrationCertificate(), inRegistrationCertificate);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Car(), vbCode_calc, inName);
   -- сохранили св-во <Техпаспорт>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_RegistrationCertificate(), ioId, inRegistrationCertificate);

   -- сохранили свойство <Начальная дата для Типа нормы>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Car_StartDateRate(), ioId, inStartDateRate);
   -- сохранили свойство <Конечная дата для Типа нормы>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Car_EndDateRate(), ioId, inEndDateRate);

   -- сохранили связь с <Модель авто>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarModel(), ioId, inCarModelId);
   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_Unit(), ioId, inUnitId);
   -- сохранили связь с <Сотрудник (водитель)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_PersonalDriver(), ioId, inPersonalDriverId);
   -- сохранили связь с <Вид топлива (основной)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_FuelMaster(), ioId, inFuelMasterId);
   -- сохранили связь с <Вид топлива (дополнительный)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_FuelChild(), ioId, inFuelChildId);
   -- сохранили связь с <Типы норм для топлива>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_RateFuelKind(), ioId, inRateFuelKindId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_Car(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.13          * add StartDateRate, EndDateRate, Unit, PersonalDriver, FuelMaster, FuelChild, RateFuelKind
 10.06.13          *
 05.06.13          

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Car()
