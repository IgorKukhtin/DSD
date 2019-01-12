-- Function: gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Maker(
 INOUT ioId              Integer   ,    -- ключ объекта <Производитель>
    IN inCode            Integer   ,    -- Код объекта <>
    IN inName            TVarChar  ,    -- Название объекта <>
    IN inCountryId       Integer   ,    -- Страна
    IN inContactPersonId Integer   ,    -- Контактные лица
    IN inSendPlan        TDateTime,     -- Когда планируем отправить(дата/время)
    IN inSendReal        TDateTime,     -- Когда успешно прошла отправка (дата/время)
    IN inisReport1       Boolean,       -- отправлять "отчет по приходам"
    IN inisReport2       Boolean,       -- отправлять "отчет по продажам"
    IN inisReport3       Boolean,       -- отправлять "реализация за период с остатками на конец периода"
    IN inisReport4       Boolean,       -- отправлять "приход расход остаток"
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;    
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Maker());
   vbUserId := inSession; 

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Maker()); 
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Maker(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Maker(), vbCode_calc);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Maker(), vbCode_calc, inName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Maker_Country(), ioId, inCountryId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Maker_ContactPerson(), ioId, inContactPersonId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendPlan(), ioId, inSendPlan);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Maker_SendReal(), ioId, inSendReal);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report1(), ioId, inisReport1);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report2(), ioId, inisReport2);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report3(), ioId, inisReport3);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report4(), ioId, inisReport4);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.19         *
 11.02.14         *  
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Maker()