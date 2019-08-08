-- Function: gpInsertUpdate_Object_UnitLincDriver()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_UnitLincDriver(Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UnitLincDriver(
 INOUT ioId             Integer   ,     -- ключ объекта <> 
    IN inUnitId         Integer   ,     -- Код объекта  
    IN inDriverId       Integer   ,     -- Код объекта 
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Driver());

   IF COALESCE(inUnitId, 0) = 0 OR COALESCE(inDriverId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Не заполнено подразделение или водитель!';
   END IF;
 
   -- пытаемся найти код
   IF COALESCE(ioId, 0) <> 0 AND ioId <> inUnitId
   THEN
     RAISE EXCEPTION 'Ошибка. Изменять подразделение запрещено!';
   END IF;
   
   IF COALESCE(ioId, 0) = 0 AND EXISTS(SELECT 1 FROM ObjectLink 
                                       WHERE ObjectLink.DescId = zc_ObjectLink_Unit_Driver()
                                         AND ObjectLink.ObjectId = inUnitId)
   THEN
     RAISE EXCEPTION 'Ошибка. Всязь подразделения <%> с водителем уже установлена!', (SELECT Object.ValueData FROM Object WHERE Object.ID = inUnitId);
   END IF;
   
   -- сохранили связь с <Подразделением>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Driver(), inUnitId, inDriverId);
   
   ioId := inUnitId;
   
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.08.19                                                       *
*/

-- тест
-- 
