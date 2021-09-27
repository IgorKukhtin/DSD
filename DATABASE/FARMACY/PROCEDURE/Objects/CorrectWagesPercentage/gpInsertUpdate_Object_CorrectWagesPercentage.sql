-- Function: gpInsertUpdate_Object_CorrectWagesPercentage()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CorrectWagesPercentage (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CorrectWagesPercentage(
 INOUT ioId              Integer   ,   	-- ключ объекта <>
    IN inCode            Integer   ,    -- Код объекта  
    IN inUserId          Integer   ,    -- Сотрудник
    IN inUnitId          Integer   ,    -- Аптека
    IN inDateStart       TDateTime ,    -- Дата начала действия
    IN inDateEnd         TDateTime ,    -- Дата конца действия
    IN inPercent         TFloat    ,    -- Процент от начислено
    IN inisCheck         Boolean   ,    -- Расчет от чеков
    IN inisStore         Boolean   ,    -- Расчет по приходам
    IN inSession         TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectWagesPercentage());
   vbUserId := lpGetUserBySession (inSession); 

   inDateStart := DATE_TRUNC ('DAY', inDateStart);
   inDateEnd := DATE_TRUNC ('DAY', inDateEnd);
   
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Разрешено только системному администратору';
   END IF;
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CorrectWagesPercentage());

   IF COALESCE(inUserId, 0) = 0 OR COALESCE(inUnitId, 0) = 0 
   THEN
     RAISE EXCEPTION 'Не определен <Сотрудник> или <Подразделение>';
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CorrectWagesPercentage(), vbCode_calc, '');

   -- сохранили связь с <Пользователи>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CorrectWagesPercentage_User(), ioId, inUserId);
   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CorrectWagesPercentage_Unit(), ioId, inUnitId);

   -- сохранили свойство <Дата начала действия>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CorrectWagesPercentage_DateStart(), ioId, inDateStart);
   -- сохранили свойство <Дата окончания действия>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CorrectWagesPercentage_DateEnd(), ioId, inDateEnd);

   -- сохранили свойство <Процент от начислено>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjectFloat_CorrectWagesPercentage_Percent(), ioId, inPercent);

   -- сохранили свойство <Расчет от чеков>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CorrectWagesPercentage_Check(), ioId, inisCheck);
   -- сохранили свойство <Расчет по приходам>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CorrectWagesPercentage_Store(), ioId, inisStore);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.09.21                                                       *
*/

-- тест
--