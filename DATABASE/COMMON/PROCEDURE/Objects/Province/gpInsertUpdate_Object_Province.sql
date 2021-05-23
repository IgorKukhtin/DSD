-- Function: gpInsertUpdate_Object_Province (Integer,Integer,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Province (Integer,Integer,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Province(
 INOUT ioId                       Integer   ,    -- ключ объекта <Район> 
    IN inCode                     Integer   ,    -- Код объекта <>
    IN inName                     TVarChar  ,    -- Название объекта <>
    IN inRegionId                 Integer   ,    -- 
    IN inSession                  TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Province());


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Province()); 
   
   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Province(), inName);
   -- проверка уникальность <Наименование> для !!!одноq!! области
   IF TRIM (inName) <> '' AND COALESCE (inRegionId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_Province_Region
                                       ON ObjectLink_Province_Region.ObjectId = Object.Id
                                      AND ObjectLink_Province_Region.DescId = zc_ObjectLink_Province_Region()
                                      AND ObjectLink_Province_Region.ChildObjectId = inRegionId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION 'Ошибка. Район <%> уже установлен у <%>.', TRIM (inName), lfGet_Object_ValueData (inRegionId);
       END IF;
   END IF;


   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Province(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Province(), vbCode_calc, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Province_Region(), ioId, inRegionId);

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
-- SELECT * FROM gpInsertUpdate_Object_Province()
