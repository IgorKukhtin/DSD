-- Function: gpInsertUpdate_Object_Street (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Street (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Street(
 INOUT ioId                       Integer   ,    -- ключ объекта < Улица/проспект> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inPostalCode               TVarChar  ,    -- 
    IN inStreetKindId             Integer   ,    --          
    IN inCityId                   Integer   ,    --
    IN inProvinceCityId           Integer   ,    -- 
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Street());


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Street()); 
   
   -- проверка прав уникальности для свойства <Наименование > + <City>
 --  PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Street(), inName);
   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Street(), vbCode_calc);

   -- проверка
   IF COALESCE (inCityId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Населенный пункт> не заполнено.';
   END IF;
   -- проверка
   IF COALESCE (inStreetKindId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Вид(улица,проспект)> не заполнено.';
   END IF;

   -- проверка
   IF EXISTS (SELECT 1
              FROM Object AS Object_Street
                   JOIN ObjectLink AS ObjectLink_Street_StreetKind ON ObjectLink_Street_StreetKind.ObjectId     = Object_Street.Id
                                                                  AND ObjectLink_Street_StreetKind.DescId        = zc_ObjectLink_Street_StreetKind()
                                                                  AND ObjectLink_Street_StreetKind.ChildObjectId = inStreetKindId
                   INNER JOIN ObjectLink AS ObjectLink_Street_City ON ObjectLink_Street_City.ObjectId       = Object_Street.Id
                                                                  AND ObjectLink_Street_City.DescId         = zc_ObjectLink_Street_City()
                                                                  AND ObjectLink_Street_City.ChildObjectId  = inCityId
                   LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                                                         AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
                 /*LEFT JOIN ObjectString AS ObjectString_PostalCode ON ObjectString_PostalCode.ObjectId  = Object_Street.Id
                                                                    AND ObjectString_PostalCode.DescId    = zc_ObjectString_Street_PostalCode()
                                                                    AND ObjectString_PostalCode.ValueData = inPostalCode*/
                                                                         
              WHERE Object_Street.Id <> COALESCE (ioId, 0)
                AND Object_Street.DescId = zc_Object_Street()
                AND Object_Street.ValueData = inName
                AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (inProvinceCityId, 0)
              --AND COALESCE (ObjectString_PostalCode.ValueData, '') = COALESCE (inPostalCode, '')
             )
   THEN
       RAISE EXCEPTION 'Ошибка.В справочнике <Улица/проспект> значение <%><%> не уникально для города <%>.'
                     , lfGet_Object_ValueData_sh (inStreetKindId)
                     , inName
                     , lfGet_Object_ValueData_sh (inCityId)
                      ;
   END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Street(), vbCode_calc, inName);
   -- сохранили св-во <Техпаспорт>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Street_PostalCode(), ioId, inPostalCode);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Street_StreetKind(), ioId, inStreetKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Street_City(), ioId, inCityId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Street_ProvinceCity(), ioId, inProvinceCityId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Street()
