-- Function: lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar,TVarChar,Integer,Integer,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_CarExternal(
   INOUT ioId                       Integer, 
      IN incode                     Integer, 
      IN inName                     TVarChar, 
      IN inRegistrationCertificate  TVarChar, 
      IN inComment                  TVarChar  ,    -- Примечание
      IN inCarModelId               Integer, 
      IN inJuridicalId              Integer,        
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
   -- сохранили связь с <юр.лицом>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_Juridical(), ioId, inJuridicalId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_CarExternal()
