-- Function: gpInsertUpdate_Object_()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OverSettings(Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OverSettings(
 INOUT ioId                      Integer   ,   	-- ключ объекта 
    IN inUnitId                  Integer   ,    -- подразделение
    IN inMinPrice                TFloat    ,    -- Минимальная цена
    IN inMinimumLot              TFloat    ,    -- округление
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession;
   
   -- сохранили объект
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OverSettings(), 0, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_OverSettings_Unit(), ioId, inUnitId);
   -- Минимальная цена
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OverSettings_MinPrice(), ioId, inMinPrice);
   -- округление
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OverSettings_MinimumLot(), ioId, inMinimumLot);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.07.16         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_OverSettings ()                            
