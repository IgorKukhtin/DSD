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
