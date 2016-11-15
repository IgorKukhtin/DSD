-- Function: gpInsertUpdate_Object_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SheetWorkTime(Integer, Integer, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SheetWorkTime(
 INOUT ioId                  Integer   ,    -- ключ объекта < Основные средства>
    IN inCode                Integer   ,    -- Код объекта 
    --IN inName                TVarChar  ,    -- Название объекта --сформировать автоматом по св-вам
    IN inStartTime           TDateTime ,    -- Время начала
    IN inWorkTime            TDateTime ,    -- Количество рабочих часов
    IN inDayOffPeriodDate    TDateTime ,    -- Начиная с какого числа расчет периодичности
    IN inComment             TVarChar  ,    -- Примечание
    IN inDayOffPeriod        TVarChar  ,    -- Периодичность в днях
    IN inDayOffWeek          TVarChar  ,    -- Дни недели
    IN inDayKindId           Integer   ,    -- ссылка на Тип дня
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
   DECLARE vbName TVarChar; 
BEGIN
   
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_SheetWorkTime());

    -- Если код не установлен, определяем его как последний+1
    vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SheetWorkTime()); 

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SheetWorkTime(), vbCode_calc);
    
   vbName:= '';
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_SheetWorkTime(), vbCode_calc, vbName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffPeriod(), ioId, inDayOffPeriod);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffWeek(), ioId, inDayOffWeek);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_Comment(), ioId, inComment);

    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_Start(), ioId, inStartTime);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_Work(), ioId, inWorkTime);
    -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_DayOffPeriod(), ioId, inDayOffPeriodDate);


   -- сохранили связь <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SheetWorkTime_DayKind(), ioId, inDayKindId);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.11.16         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_SheetWorkTime()
