-- Function: gpUpdate_Object_Unit_HistoryCost

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_HistoryCost (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_HistoryCost(
    IN inId                    Integer   , -- ключ объекта <Подразделение>
    IN inUnitId_HistoryCost    Integer   , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_HistoryCost());

   IF inId = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Элемент не сохранен.';
   END IF;
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_HistoryCost(), inId, inUnitId_HistoryCost);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.19         *            
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Unit_HistoryCost ()                            
