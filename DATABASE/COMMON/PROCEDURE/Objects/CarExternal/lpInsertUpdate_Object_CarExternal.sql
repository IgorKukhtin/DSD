-- Function: lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar)

--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar,TVarChar,Integer,Integer,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,Integer,Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,Integer,Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,Integer,Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_CarExternal(
   INOUT ioId                       Integer, 
      IN incode                     Integer, 
      IN inName                     TVarChar, 
      IN inRegistrationCertificate  TVarChar,
      IN inVIN                      TVarChar,    -- VIN код
      IN inComment                  TVarChar  ,    -- Примечание
      IN inCarModelId               Integer, 
      IN inCarTypeId                Integer,     -- Модель автомобиля
      IN inCarPropertyId            Integer,     -- Тип авто
      IN inObjectColorId            Integer,     -- Цвет авто
      IN inJuridicalId              Integer,
      IN inLength                   TFloat ,     -- 
      IN inWidth                    TFloat ,     -- 
      IN inHeight                   TFloat ,     -- 
      IN inWeight                   TFloat ,     --
      IN inYear                     TFloat ,     --      
      IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer;
BEGIN
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_CarExternal());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CarExternal(), TRIM (inName));
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CarExternal(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CarExternal(), vbCode_calc, TRIM (inName), NULL);


   -- сохранили св-во <Техпаспорт>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CarExternal_RegistrationCertificate(), ioId, inRegistrationCertificate);
   -- сохранили св-во <Примечание>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CarExternal_Comment(), ioId, inComment);
   -- сохранили связь с <Модель авто>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_CarModel(), ioId, inCarModelId);
   -- сохранили связь с <Модель авто>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_CarType(), ioId, inCarTypeId);
   -- сохранили связь с <Тип авто>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_CarProperty(), ioId, inCarPropertyId);
   -- сохранили связь с <цвет>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_ObjectColor(), ioId, inObjectColorId);
   -- сохранили связь с <юр.лицом>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_Juridical(), ioId, inJuridicalId);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CarExternal_VIN(), ioId, inVIN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Length(), ioId, inLength);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Height(), ioId, inHeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Width(), ioId, inWidth);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Weight(), ioId, inWeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Year(), ioId, inYear);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.23         *
 09.11.21         *
 17.03.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_CarExternal()
