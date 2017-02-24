-- Function: gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Поcтавщики> 
    IN inCode                     Integer   ,    -- Код объекта <Поcтавщики>
    IN inName                     TVarChar  ,    -- Название объекта <Поcтавщики>
    IN inUnitId                   Integer   ,    -- ключ объекта <Подразделение> 
    IN inValutaId                 Integer   ,    -- ключ объекта <Валюта> 
    IN inBrandId                  Integer   ,    -- ключ объекта <Торговая марка> 
    IN inFabrikaId                Integer   ,    -- ключ объекта <Фабрика производитель> 
    IN inPeriodId                 Integer   ,    -- ключ объекта <Период> 
    IN inPeriod                   TFloat    ,    -- Период
    IN inKindAccount              TFloat    ,    -- Вид счета
    IN inPeriodYear               TFloat    ,    -- Год периода
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_Partner()); 
   
   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName);

   -- проверка уникальность <Наименование> для !!!одной!! <Подразделение>
   IF TRIM (inName) <> '' AND COALESCE (inUnitId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_Partner_Unit
                                       ON ObjectLink_Partner_Unit.ObjectId = Object.Id
                                      AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
                                      AND ObjectLink_Partner_Unit.ChildObjectId = inUnitId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION 'Ошибка. Группа Подразделение <%> уже установлена у <%>.', TRIM (inName), lfGet_Object_ValueData (inUnitId);
       END IF;
   END IF;


   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), vbCode_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), vbCode_max, inName);

   -- сохранили связь с <Подразделение>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Unit(), ioId, inUnitId);
   -- сохранили связь с <Валюта>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Valuta(), ioId, inValutaId);
   -- сохранили связь с <Торговая марка>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Brand(), ioId, inBrandId);
   -- сохранили связь с <Фабрика производитель>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Fabrika(), ioId, inFabrikaId);
   -- сохранили связь с <Период>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Period(), ioId, inPeriodId);

   -- сохранили <Период>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectLink_Partner_Period(), ioId, inPeriod);
   -- сохранили <Вид счета>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_KindAccount(), ioId, inKindAccount);
   -- сохранили <Год периода>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_PeriodYear(), ioId, inPeriodYear);
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
20.02.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner()
