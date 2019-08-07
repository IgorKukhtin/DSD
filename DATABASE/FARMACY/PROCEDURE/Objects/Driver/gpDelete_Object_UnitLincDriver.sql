-- Function: gpDelete_Object_UnitLincDriver()

DROP FUNCTION IF EXISTS gpDelete_Object_UnitLincDriver(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_UnitLincDriver(
    IN inUnitId         Integer   ,     -- Код объекта  
    IN inDriverId       Integer   ,     -- Код объекта 
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
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
 
   
   IF NOT EXISTS(SELECT 1 FROM ObjectLink 
                                       WHERE ObjectLink.DescId = zc_ObjectLink_Unit_Driver()
                                         AND ObjectLink.ObjectId = inUnitId)
   THEN
     RAISE EXCEPTION 'Ошибка. Всязь подразделения <%> с водителем не найдена!', (SELECT Object.ValueData FROM Object WHERE Object.ID = inUnitId);
   END IF;
   
   -- сохранили связь с <Подразделением>
   DELETE FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_Unit_Driver()
                            AND ObjectLink.ObjectId = inUnitId;
   
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.08.19                                                       *
*/

-- тест
-- 
