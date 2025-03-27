 -- Function: gpUpdate_MI_ProductionUnion_AmountForm_two()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_AmountForm_two (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_AmountForm_two(
    IN inMovementItemId       Integer   , -- Ключ объекта <>
    IN inAmountForm_two       TFloat    , -- кол-во формовка+2день,кг
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionUnion_AmountForm_two());
   
   -- проверка
   IF COALESCE (inMovementItemId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Ошибка.Строка не сохранена.';
   END IF;

   -- сохранили свойство <кол-во формовка+1день,кг>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForm_two(), inMovementItemId, inAmountForm_two);
 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.03.25         * 
*/

-- тест
-- 