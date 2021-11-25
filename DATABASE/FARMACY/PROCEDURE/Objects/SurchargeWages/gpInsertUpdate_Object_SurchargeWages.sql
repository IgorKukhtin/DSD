-- Function: gpInsertUpdate_Object_SurchargeWages()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SurchargeWages (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SurchargeWages(
 INOUT ioId              Integer   ,   	-- ключ объекта <>
    IN inCode            Integer   ,    -- Код объекта  
    IN inUserId          Integer   ,    -- Сотрудник
    IN inUnitId          Integer   ,    -- Аптека
    IN inDateStart       TDateTime ,    -- Дата начала действия
    IN inDateEnd         TDateTime ,    -- Дата конца действия
    IN inSumma           TFloat    ,    -- Сумма доплаты
    IN inDescription     TVarChar  ,    -- Описание
    IN inSession         TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SurchargeWages());
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
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SurchargeWages());

   IF COALESCE(inUserId, 0) = 0 OR COALESCE(inUnitId, 0) = 0 
   THEN
     RAISE EXCEPTION 'Не определен <Сотрудник> или <Подразделение>';
   END IF;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_SurchargeWages(), vbCode_calc, '');

   -- сохранили связь с <Пользователи>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SurchargeWages_User(), ioId, inUserId);
   -- сохранили связь с <Подразделения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SurchargeWages_Unit(), ioId, inUnitId);

   -- сохранили свойство <Дата начала действия>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_SurchargeWages_DateStart(), ioId, inDateStart);
   -- сохранили свойство <Дата окончания действия>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_SurchargeWages_DateEnd(), ioId, inDateEnd);

   -- сохранили свойство <Сумма доплаты>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjectFloat_SurchargeWages_Summa(), ioId, inSumma);

   -- сохранили свойство <Описание>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SurchargeWages_Description(), ioId, inDescription);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.11.21                                                       *
*/

-- тест
--