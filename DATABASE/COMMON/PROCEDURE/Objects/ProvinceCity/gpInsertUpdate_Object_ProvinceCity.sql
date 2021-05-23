-- Function: gpInsertUpdate_Object_ProvinceCity()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProvinceCity (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProvinceCity(
 INOUT ioId             Integer   ,     -- ключ объекта <>
    IN inCode           Integer   ,     -- Код объекта
    IN inName           TVarChar  ,     -- Название объекта
    IN inCityId         Integer   ,     -- 
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ProvinceCity());

  
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProvinceCity());

   -- проверка прав уникальности для свойства <Наименование>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ProvinceCity(), inName);

  -- проверка уникальность <Наименование> для !!!одного!! населенного пункта
   IF TRIM (inName) <> '' AND COALESCE (inCityId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_ProvinceCity_City
                                       ON ObjectLink_ProvinceCity_City.ObjectId = Object.Id
                                      AND ObjectLink_ProvinceCity_City.DescId = zc_ObjectLink_ProvinceCity_City()
                                      AND ObjectLink_ProvinceCity_City.ChildObjectId = inCityId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION 'Ошибка. Район <%> уже установлен у <%>.', TRIM (inName), lfGet_Object_ValueData (inCityId);
       END IF;
   END IF;

   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ProvinceCity(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ProvinceCity(), vbCode_calc, inName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProvinceCity_City(), ioId, inCityId);
 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ProvinceCity (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 31.05.14         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProvinceCity(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='2')