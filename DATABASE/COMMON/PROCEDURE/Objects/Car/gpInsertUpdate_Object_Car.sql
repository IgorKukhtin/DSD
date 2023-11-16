 -- Function: gpInsertUpdate_Object_Car(Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Car(
   INOUT ioId                       Integer,     -- ид
      IN incode                     Integer,     -- код автомобиля
      IN inName                     TVarChar,    -- наименование 
      IN inRegistrationCertificate  TVarChar,    -- Техпаспорт
      IN inVIN                      TVarChar,    -- VIN код
      IN inEngineNum                TVarChar,    -- Номер двигателя
      IN inComment                  TVarChar,    -- Примечание
      IN inCarModelId               Integer,     -- Марка автомобиля
      IN inCarTypeId                Integer,     -- Модель автомобиля
      IN inBodyTypeId               Integer,     -- Тип кузова
      IN inCarPropertyId            Integer,     -- Тип авто
      IN inObjectColorId            Integer,     -- Цвет авто
      IN inUnitId                   Integer,     -- Подразделение
      IN inPersonalDriverId         Integer,     -- Сотрудник (водитель)
      IN inFuelMasterId             Integer,     -- Вид топлива (основной)
      IN inFuelChildId              Integer,     -- Вид топлива (дополнительный)
      IN inJuridicalId              Integer,     -- Юридическое лицо(стороннее)
      --IN inAssetId                  Integer,     -- Основные средства
      IN inKoeffHoursWork           TFloat ,     -- коэфф. для модели Рабочее время из путевого листа
      IN inPartnerMin               TFloat ,     -- Кол-во минут на ТТ
      IN inLength                   TFloat ,     -- 
      IN inWidth                    TFloat ,     -- 
      IN inHeight                   TFloat ,     -- 
      IN inWeight                   TFloat ,     --
      IN inYear                     TFloat ,     --
      IN inSession                  TVarChar     -- Пользователь
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Car());
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Car()); 
   
   -- проверка прав уникальности для свойства <Наименование Автомобиля>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Car(), inName);
   -- проверка прав уникальности для свойства <Код Автомобиля>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Car(), vbCode_calc);
   -- проверка прав уникальности для свойства <Техпаспорт> 
   -- PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Car_RegistrationCertificate(), inRegistrationCertificate);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Car(), vbCode_calc, inName
                                , inAccessKeyId:= COALESCE ((SELECT Object_Branch.AccessKeyId FROM ObjectLink LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId WHERE ObjectLink.ObjectId = inUnitId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch()), zc_Enum_Process_AccessKey_TrasportDnepr()));
   -- сохранили св-во <Техпаспорт>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_RegistrationCertificate(), ioId, inRegistrationCertificate);
   -- сохранили св-во <Примечание>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_Comment(), ioId, inComment);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_VIN(), ioId, inVIN);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_EngineNum(), ioId, inEngineNum);
   
   -- сохранили связь с <Марка автомобиля>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarModel(), ioId, inCarModelId);
   -- сохранили связь с <Модель авто>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarType(), ioId, inCarTypeId);
   -- сохранили связь с <Тип кузова>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_BodyType(), ioId, inBodyTypeId);
   -- сохранили связь с <Тип авто>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarProperty(), ioId, inCarPropertyId);
   -- сохранили связь с <цвет>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_ObjectColor(), ioId, inObjectColorId);

   -- сохранили связь с <подразделением>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_Unit(), ioId, inUnitId);
   -- сохранили связь с <Сотрудник (водитель)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_PersonalDriver(), ioId, inPersonalDriverId);
   -- сохранили связь с <Вид топлива (основной)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_FuelMaster(), ioId, inFuelMasterId);
   -- сохранили связь с <Вид топлива (дополнительный)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_FuelChild(), ioId, inFuelChildId);
   -- сохранили связь с <юр.лицом>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <Осн.средством>
   --PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_Asset(), ioId, inAssetId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_KoeffHoursWork(), ioId, inKoeffHoursWork);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_PartnerMin(), ioId, inPartnerMin);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Length(), ioId, inLength);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Height(), ioId, inHeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Width(), ioId, inWidth);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Weight(), ioId, inWeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Year(), ioId, inYear);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.23         *
 17.07.23         *
 07.12.21         * del inAssetId
 01.11.21         *
 05.10.21         *
 27.04.21         * PartnerMin
 29.10.19         * inKoeffHoursWork
 28.11.16         * add Asset
 18.11.15         * add comment
 17.12.14         * add Juridical               
 04.09.14                                        * !!!RESTORE!!!
*/

-- тест
-- SELECT * FROM 
