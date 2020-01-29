-- Function: gpInsertUpdate_Object_PlanIventory (Integer, TVarChar, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PlanIventory (Integer, TVarChar, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PlanIventory(
 INOUT ioId              Integer   ,    -- ключ объекта <Производитель>
    IN inName            TVarChar  ,    -- Комментарий
    IN inUnitId          Integer   ,    -- Аптека
    IN inMemberId        Integer   ,    -- ФИО ответственного
    IN inMemberReturnId  Integer   ,    -- ФИО ответственного за возврат
    IN inOperDate        TDateTime,     -- Дата инвентаризации
    IN inDateStart       TDateTime,     -- Дата начала
    IN inDateEnd         TDateTime,     -- Дата окончания
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PlanIventory());
   vbUserId := inSession; 
  
   -- проверка в 1 день по аптеке только 1 запись
   IF EXISTS (SELECT 1
              FROM Object
                   INNER JOIN ObjectLink AS ObjectLink_Unit 
                                         ON ObjectLink_Unit.ObjectId = Object.Id 
                                        AND ObjectLink_Unit.DescId = zc_ObjectLink_PlanIventory_Unit()
                                        ANd ObjectLink_Unit.ChildObjectId = inUnitId
                   INNER JOIN ObjectDate AS ObjectDate_OperDate
                                         ON ObjectDate_OperDate.ObjectId = Object.Id
                                        AND ObjectDate_OperDate.DescId = zc_ObjectDate_PlanIventory_OperDate()
                                        AND ObjectDate_OperDate.ValueData = inOperDate
              WHERE Object.DescId = zc_Object_PlanIventory() 
                AND Object.Id <> ioId)
   THEN
       RAISE EXCEPTION 'Ошибка.По <%> уже внесена дата инвентаризации <%>.', lfGet_Object_ValueData (inUnitId), inOperDate::Date;
   END IF;
   
  
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PlanIventory(), 0, inName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PlanIventory_Unit(), ioId, inUnitId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PlanIventory_Member(), ioId, inMemberId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PlanIventory_MemberReturn(), ioId, inMemberReturnId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PlanIventory_OperDate(), ioId, inOperDate);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PlanIventory_DateStart(), ioId, inDateStart);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PlanIventory_DateEnd(), ioId, inDateEnd);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.01.20         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PlanIventory()