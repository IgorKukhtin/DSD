-- Function: gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Maker (Integer,Integer,TVarChar, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Maker(
 INOUT ioId              Integer   ,    -- ключ объекта <Производитель>
    IN inCode            Integer   ,    -- Код объекта <>
    IN inName            TVarChar  ,    -- Название объекта <>
    IN inCountryId       Integer   ,    -- Страна
    IN inContactPersonId Integer   ,    -- Контактные лица
    IN inSendPlan        TDateTime,     -- Когда планируем отправить(дата/время)
    IN inSendReal        TDateTime,     -- Когда успешно прошла отправка (дата/время)
    IN inDay             TFloat    ,    -- периодичность отправки в дня
    IN inMonth           TFloat    ,    -- периодичность отправки в месяцах
    IN inisReport1       Boolean,       -- отправлять "отчет по приходам"
    IN inisReport2       Boolean,       -- отправлять "отчет по продажам"
    IN inisReport3       Boolean,       -- отправлять "реализация за период с остатками на конец периода"
    IN inisReport4       Boolean,       -- отправлять "приход расход остаток"
    IN inisReport5       Boolean,       -- отправлять "отчет по срокам"
    IN inisReport6       Boolean,       -- отправлять "отчет по товару на виртуальном складе"
    IN inisReport7       Boolean,       -- отправлять "отчет по оплате приходов"
    IN inisQuarter       Boolean,       -- Отправлять дополнительно квартальные отчеты
    IN inis4Month        Boolean,       -- Отправлять дополнительно отчеты за 4 месяца
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

   IF COALESCE (inDay, 0) <> 0 AND COALESCE (inMonth, 0) <> 0 
   THEN
        RAISE EXCEPTION 'Ошибка.Должен быть выбран только один параметр периодичности <Дней> или <Месяцев>.'; 
   END IF;
   
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Maker_Day(), ioId, inDay);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Maker_Month(), ioId, inMonth);

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
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report5(), ioId, inisReport5);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report6(), ioId, inisReport6);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Report7(), ioId, inisReport7);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_Quarter(), ioId, inisQuarter);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Maker_4Month(), ioId, inis4Month);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.01.20                                                       *
 07.08.19                                                       *
 05.04.19                                                       *
 03.04.19                                                       *
 18.01.19         *
 11.01.19         *
 11.02.14         *  
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Maker()