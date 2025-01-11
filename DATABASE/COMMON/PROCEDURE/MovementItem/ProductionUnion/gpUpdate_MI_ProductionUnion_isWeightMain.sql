 -- Function: gpUpdate_MI_ProductionUnion_isWeightMain()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_isWeightMain (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_isWeightMain(
    IN inMovementItemId       Integer   , -- Ключ объекта <>
    IN inisWeightMain         Boolean   , -- 
   OUT outisWeightMain        Boolean   , --
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionUnion_isWeightMain());
   
   -- проверка
   IF COALESCE (inMovementItemId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Ошибка.Строка не сохранена.';
   END IF;

   outisWeightMain := Not inisWeightMain;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_WeightMain(), inMovementItemId, outisWeightMain);
 
   IF vbUserId = 9457 
   THEN
        RAISE EXCEPTION 'Test.OK';
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.01.25         * 
*/

-- тест
-- 